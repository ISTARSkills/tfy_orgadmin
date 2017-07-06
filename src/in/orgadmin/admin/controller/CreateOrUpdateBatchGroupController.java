package in.orgadmin.admin.controller;

import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

import in.orgadmin.admin.services.OrgAdminBatchGroupService;
import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportUtils;

/**
 * Servlet implementation class CreateOrUpdateBatchGroupController
 */
@WebServlet("/createOrUpdateBatchGroup")
public class CreateOrUpdateBatchGroupController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateOrUpdateBatchGroupController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		/*Param -> college_id : Value ->2
Param -> group_name : Value ->asdasd
Param -> group_desc : Value ->asdasd
Param -> mode_type : Value ->ELT
Param -> group_type : Value ->SECTION
Param -> parent_group_id : Value ->-1
Param -> filter_by : Value ->ROLE
Param -> role_section_id : Value ->217
Param -> student_list : Value ->450
Param -> eventDate : Value ->22/05/2017
Param -> course_ids : Value ->1*/
		CustomReportUtils repprttil = new CustomReportUtils();
		Integer college_id = Integer.parseInt(request.getParameter("college_id"));
		if (request.getParameterMap().containsKey("group_name")
				&& !request.getParameter("group_name").equalsIgnoreCase("")) {

			List<Integer> list = new ArrayList<Integer>();

			String group_name = request.getParameter("group_name");
			String group_desc = request.getParameter("group_desc");			
			
			Boolean isHistorical = false;
			Boolean isPrimary = false;
			if(request.getParameterMap().containsKey("is_historical") && request.getParameter("is_historical").toString().equalsIgnoreCase("on"))
			{
				isHistorical  = true;
			}
			if(request.getParameterMap().containsKey("is_primary") && request.getParameter("is_primary").toString().equalsIgnoreCase("on"))
			{
				isPrimary  = true;
			}
			
			Integer student_count=0;
			
			if(request.getParameterMap().containsKey("student_count"))
			{
				student_count  = Integer.parseInt(request.getParameter("student_count"));
			}			
			
			String modeType = request.getParameter("mode_type");
			
			Date startDateInDateFormats = new Date();
			if(request.getParameterMap().containsKey("startDate"))
			{
				String startDate = request.getParameter("startDate");
				SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
				try {
					 startDateInDateFormats = df.parse(startDate);
					
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			
			
			String groupType = "SCHEDULED";
			groupType = request.getParameter("group_type");
			int parentGroupId = Integer.parseInt(request.getParameter("parent_group_id"));			
			String student_list;
			if(request.getParameterMap().containsKey("select_all") && request.getParameter("select_all").equalsIgnoreCase("on"))
			{
				String getStudents="";
				
				CustomReport report = new CustomReport();
				//we have to add all studnets filter eitther by role , section or organization
				if(request.getParameterMap().containsKey("filter_by"))
				{
					String filterBy = request.getParameter("filter_by");
					if (filterBy.equalsIgnoreCase("ROLE") || filterBy.equalsIgnoreCase("SECTION"))
					{
						//role
						if(request.getParameterMap().containsKey("role_section_id")){
							String role_section_id = request.getParameter("role_section_id");
							report= repprttil.getReport(7);
							getStudents = report.getSql();
							getStudents= getStudents.replaceAll(":batch_group_ids", role_section_id);
						}
					}
					else
					{
						//org 
						report= repprttil.getReport(6);
						getStudents = report.getSql();
						getStudents= getStudents.replaceAll(":college_id", college_id+"");
						
						
					}	
					
				}				
				
				DBUTILS dbutils=new DBUTILS();
				System.out.println(">>getStudents"+getStudents);
				List<HashMap<String, Object>> data=dbutils.executeQuery(getStudents);
				for (HashMap<String, Object> item : data) {
					list.add((int)item.get("id"));
				}
			}
			else
			{
				if (request.getParameterMap().containsKey("student_list")) {
					String studentArray []= request.getParameterValues("student_list");
					if(studentArray.length>0)
					{
						for(String stuId : studentArray)
						{
							list.add(Integer.parseInt(stuId));
						}
					}					
				}

			}	
			
			
			

			OrgAdminBatchGroupService batchGroupService = new OrgAdminBatchGroupService();
			BatchGroup batchGroup=null;
			if(request.getParameterMap().containsKey("bg_id") && !request.getParameter("bg_id").equalsIgnoreCase("")){
				//update
				int bg_id=Integer.parseInt(request.getParameter("bg_id"));
				batchGroup=batchGroupService.updateBatchGroup(bg_id,group_name, group_desc, student_count, college_id, 10195, parentGroupId, groupType,modeType,startDateInDateFormats, isPrimary, isHistorical);
			}else{
				
				//create
				batchGroup= batchGroupService.createBatchGroup(group_name, group_desc, student_count, college_id, 10195, parentGroupId, groupType, modeType,startDateInDateFormats, isPrimary, isHistorical);
			}
			
			if (batchGroup != null) {
				batchGroupService.createBGStudents(batchGroup.getId(), list);
				DBUTILS util = new  DBUTILS();
				String deleteTrainerBatch = "delete from trainer_batch where batch_id in (select id from batch where batch_group_id = "+batchGroup.getId()+")";
				util.executeUpdate(deleteTrainerBatch);	
				String deleteOldBatch ="delete from batch where batch_group_id ="+batchGroup.getId();
				util.executeUpdate(deleteOldBatch);
				if(request.getParameterMap().containsKey("course_ids"))
				{					
					String courseIds[] = request.getParameterValues("course_ids");					
					for(String str : courseIds)
					{
						Course c = new CourseDAO().findById(Integer.parseInt(str));
						String checkIfBatchExist = "select cast (count(*) as integer) as tot_batch from batch where batch_group_id ="+batchGroup.getId()+" and course_id="+c.getId();
						List<HashMap<String, Object>> existingData = util.executeQuery(checkIfBatchExist);
						if(existingData.size()>0 && (int)existingData.get(0).get("tot_batch")==0){
							String insertBatch ="INSERT INTO batch ( ID, createdat, NAME, updatedat, batch_group_id, course_id, order_id, YEAR ) VALUES "
								+ "( (select COALESCE(max(id),0)+1 from batch), now(), '"+batchGroup.getName()+" - "+c.getCourseName()+"', now(), '"+batchGroup.getId()+"', '"+c.getId()+"', (select cast (COALESCE(max(id),0)+1 as integer) from batch), "+Calendar.getInstance().get(Calendar.YEAR)+" );";
							util.executeUpdate(insertBatch);
						}
					}
					
				
				}
				
			}
		}
	
		response.sendRedirect("orgadmin/admin.jsp");
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
