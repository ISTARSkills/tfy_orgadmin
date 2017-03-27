package in.orgadmin.controller;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;

/**
 * Servlet implementation class GetAllProgramList
 */
@WebServlet("/getallprogramlist")
public class GetAllProgramList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public GetAllProgramList() {
        super();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		StringBuffer sb = new StringBuffer();
		
		String startDate = "", endDate = "" ,sql="" ;
		String col_id = request.getParameter("ids");
		DBUTILS db = new DBUTILS();

		System.out.println();
		
		Calendar c = GregorianCalendar.getInstance();
		     c.set(Calendar.DAY_OF_MONTH,1);
		     DateFormat dfw = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
		     startDate = dfw.format(c.getTime());
		     c.set(Calendar.DAY_OF_MONTH,31);
	         endDate = dfw.format(c.getTime());
	         
	         if(request.getParameterMap().containsKey("ids") && !(col_id.equalsIgnoreCase(""))){
	        	 
	     		System.out.println(request.getParameter("ids"));
	     		col_id = request.getParameter("ids");
	     		
	     		String[] seperate_ids = col_id.split(",");
	    		
				for(String Colid : seperate_ids){

	 			
	        	  sql ="SELECT 	MAX (event_session_log.ID), college. NAME AS c_name, 	batch_group. NAME AS bg_name, batch.name as b_name, lesson.title as l_title FROM event_session_log, batch_group, college, lesson, batch WHERE batch.id = event_session_log.batch_id AND	batch.batch_group_id = batch_group.ID AND batch_group.college_id = college.ID "
	        	  		+ "AND college.id = '"+Colid+"' AND event_session_log.lesson_id = lesson.id  GROUP BY 	event_session_log.batch_id,b_name,c_name,bg_name,l_title ORDER BY c_name";
	        	  
		     		System.out.println(sql);

	         
	         
	         
	         List<HashMap<String, Object>> p_data = db.executeQuery(sql);
	 		
	 		for (HashMap<String, Object> row : p_data) {
	 			
				String CName = (String) row.get("c_name");
				String BGName = (String) row.get("bg_name");

				String BName = (String) row.get("b_name");

				String LTitle = (String) row.get("l_title");
				
	     		/*String[] seperateCourse = BName.split("_");
	     		
	     		String course = "";
	     		
	     			course = seperateCourse[1];
	     		   course = seperateCourse[0];*/
				
				sb.append("<li class='info-element' id='task16'>");
				sb.append("<div class='agile-detail'>");
				sb.append( "<p><strong>College Name </strong>" +CName + "</p>");
				sb.append( "<p><strong>Current Program </strong>" +BGName + "</p>");
				sb.append( "<p><strong>Batch </strong>" + BName +"</p>");
				sb.append( "<p><strong>Lesson </strong>" +LTitle + "<small class='label label-primary' style='float: right;'>DONE</small></p>");

							
						sb.append("</div>");
					sb.append("</li>");


	 		}
				}
	}
		
			response.getWriter().print(sb);
		
		}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
				doGet(request, response);
	}

}
