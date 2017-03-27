package in.orgadmin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.Batch;
import com.istarindia.apps.dao.BatchDAO;
import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.BatchGroupDAO;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.utils.DatatableUtils;

/**
 * Servlet implementation class DashboardboardReportList
 */
@WebServlet("/student_report_list")
public class DashboardboardStudentReportList extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public DashboardboardStudentReportList() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		
		
		
		if(request.getParameterMap().containsKey("ids")){
			
			
			
			String col_id =request.getParameter("ids");
			System.out.println(col_id);
			
			String[] seperate_ids = col_id.split(",");
			
			
		//	sb.append("<option value='NONE'>Select Student</option>");
			for(String Colid : seperate_ids){
				
				
				String sql ="SELECT id, name FROM student WHERE organization_id="+Colid+" AND user_type = 'STUDENT'";
				
				
				
				List<HashMap<String, Object>> data = util.executeQuery(sql);
                if(data.size()>0)
                {	
                	for(HashMap<String, Object> row : data)
                	{
                		int id= (int)row.get("id");
                		String name= (String)row.get("name");
               
                		sb.append("<option  value='"+id+"'>"+name+"</option>");
									
                	}
                }
				
				}
			
			
               
		}if(request.getParameterMap().containsKey("selectedstud") ){
			
			System.out.println("---------------------------------------"+request.getParameter("selectedstud"));
			
			int student_id = Integer.parseInt(request.getParameter("selectedstud"));
			
			sb.append("<div class='ibox-content' style='min-height: 40em;'>");
			DatatableUtils dtUtils = new DatatableUtils();
			HashMap<String, String> conditions = new HashMap<>();
			
			conditions.put("student_id", student_id + "");
			sb.append(dtUtils.getReport(3030, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString());
			sb.append("</div>");
               
		}
		
		
		response.getWriter().print(sb);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

}
