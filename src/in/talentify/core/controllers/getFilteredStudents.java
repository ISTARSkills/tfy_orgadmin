package in.talentify.core.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportUtils;

/**
 * Servlet implementation class getFilteredStudents
 */
@WebServlet("/get_filtered_students")
public class getFilteredStudents extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getFilteredStudents() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		DBUTILS util = new DBUTILS();
		CustomReportUtils utils = new CustomReportUtils();
		StringBuffer sb = new StringBuffer();
		if(request.getParameterMap().containsKey("batch_group_id"))
		{
			ArrayList<Integer> alreadyAddedStudents = new ArrayList<>();
			//editing an existing batch group 
			String batchGroupId = request.getParameter("batch_group_id");
			CustomReport repor8 = utils.getReport(8);
			String sql2=repor8.getSql();
			sql2= sql2.replaceAll(":batch_group_id", batchGroupId);
			List<HashMap<String, Object>>  alreadyAdded = util.executeQuery(sql2);
			for(HashMap<String, Object> stdata: alreadyAdded)
			{
				if(!alreadyAddedStudents.contains(Integer.parseInt(stdata.get("id").toString())))
				{
					alreadyAddedStudents.add(Integer.parseInt(stdata.get("id").toString()));
					int studentID = (int) stdata.get("id");
					String email = stdata.get("email").toString();					
					sb.append("<option value='"+studentID+"' selected >"+email+"</option>");
				}
			}
			
			String entityId = request.getParameter("entity_id");
			String filterBy = request.getParameter("filter_by");
			
			String sql ="";
			
			
			if(filterBy.equalsIgnoreCase("ORG"))
			{
				CustomReport rep = utils.getReport(6);
				 sql = rep.getSql();
				 sql= sql.replaceAll(":college_id", entityId);
			}
			else if(filterBy.equalsIgnoreCase("GROUP"))
			{	CustomReport rep = utils.getReport(7);
			 	sql = rep.getSql();
				sql=rep.getSql();
				sql = sql.replaceAll(":batch_group_ids", entityId); 
			}
			
			List<HashMap<String, Object>>  data = util.executeQuery(sql);
			for(HashMap<String, Object> row: data)
			{
				int studentID = (int) row.get("id");
				String email = row.get("email").toString();
				if(!alreadyAddedStudents.contains(Integer.parseInt(row.get("id").toString())))
				{
					alreadyAddedStudents.add(Integer.parseInt(row.get("id").toString()));
				sb.append("<option value='"+studentID+"'>"+email+"</option>");
				}				
			}								
		}
		else
		{
			//creating new batch group
			String entityId = request.getParameter("entity_id");
			String filterBy = request.getParameter("filter_by");			
			String sql ="";						
			if(filterBy.equalsIgnoreCase("ORG"))
			{
				CustomReport rep = utils.getReport(6);
				 sql = rep.getSql();
				 sql= sql.replaceAll(":college_id", entityId);
			}
			else if(filterBy.equalsIgnoreCase("GROUP"))
			{	CustomReport rep = utils.getReport(7);
			 	sql = rep.getSql();
				sql=rep.getSql();
				sql = sql.replaceAll(":batch_group_ids", entityId); 
			}
			
			List<HashMap<String, Object>>  data = util.executeQuery(sql);
			for(HashMap<String, Object> row: data)
			{
				int studentID = (int) row.get("id");
				String email = row.get("email").toString();
				
				sb.append("<option value='"+studentID+"'>"+email+"</option>");
				
			}
		}	
		
		response.getWriter().write(sb.toString());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
