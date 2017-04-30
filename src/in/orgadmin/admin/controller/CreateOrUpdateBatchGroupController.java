package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.BatchGroup;
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
		/*Param -> user_id : Value ->
Param -> college_id : Value ->3
Param -> group_name : Value ->eeee
Param -> group_desc : Value ->eeee
Param -> group_type : Value ->ROLE
Param -> parent_group_id : Value ->-1
Param -> filer_by : Value ->SECTION, ROLE, "", ORG
Param -> role_section_id : Value ->17
Param -> student_list : Value ->2037*/
		CustomReportUtils repprttil = new CustomReportUtils();
		Integer college_id = Integer.parseInt(request.getParameter("college_id"));
		if (request.getParameterMap().containsKey("group_name")
				&& !request.getParameter("group_name").equalsIgnoreCase("")) {

			List<Integer> list = new ArrayList<Integer>();

			String group_name = request.getParameter("group_name");
			String group_desc = request.getParameter("group_desc");
			String groupType = request.getParameter("group_type");
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
				batchGroup=batchGroupService.updateBatchGroup(bg_id,group_name, group_desc, 1000, college_id, 10195, parentGroupId, groupType);
			}else{
				
				//create
				batchGroup= batchGroupService.createBatchGroup(group_name, group_desc, 1000, college_id, 10195, parentGroupId, groupType);
			}
			
			if (batchGroup != null) {
				batchGroupService.createBGStudents(batchGroup.getId(), list);
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
