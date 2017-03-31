package in.orgadmin.controller;

import java.io.IOException;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;



@WebServlet("/get_currentprogress_state")
public class DashboardCurrentProgressState extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
   
    public DashboardCurrentProgressState() {
        super();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		StringBuffer sb = new StringBuffer();
		DBUTILS util = new DBUTILS();
		String ids="";
		String sql ="";
		String col_id =request.getParameter("ids");
		
		
		if(request.getParameter("actTab").contentEquals("batchgroup") && !(col_id.equalsIgnoreCase(""))){
			 col_id =request.getParameter("ids");

				System.out.println(col_id);
				
				String[] seperate_ids = col_id.split(",");
				
				
				
				for(String Colid : seperate_ids){
					
					
					sql ="SELECT 	T2.bg_id AS bg_id, 	T2.bg_name AS bg_name, 	string_agg (T2.b_name, '!#') AS b_name, 	string_agg (T2.c_name, '!#') AS course_name, 	string_agg ( 		CAST (T2.perc AS VARCHAR(50)), 		'!#' 	) AS perc FROM 	( 		SELECT 			T1.bg_id, 			T1.bg_name, 			T1.b_name, 			T1.c_name, 			CASE T1.cmsession 		WHEN 0 THEN 			0 		ELSE 			T1.eslcm * 100 / T1.cmsession 		END AS perc 		FROM 			( 				SELECT DISTINCT 					batch.batch_group_id AS bg_id, 					batch_group. NAME AS bg_name, 					batch. NAME AS b_name, 					event_session_log.course_id, 					course.course_name AS c_name, 					COUNT (DISTINCT cmsession. ID) AS cmsession, 					COUNT ( 						DISTINCT event_session_log.cmsession_id 					) AS eslcm 				FROM 					event_session_log, 					batch, 					batch_group, 					college, 					course, 					MODULE, 					cmsession 				WHERE 					event_session_log.batch_id = batch. ID 				AND batch.batch_group_id = batch_group. ID 				AND batch_group.college_id = college. ID 				AND event_session_log.course_id = course. ID 				AND course. ID = MODULE .course_id 				AND MODULE . ID = cmsession.module_id 				"
							+ "AND college. ID = "+Colid+" 				GROUP BY 					batch_id, 					bg_name, 					batch. NAME, 					event_session_log.course_id, 					c_name, 					bg_id 			) T1 		GROUP BY 			T1.bg_id, 			T1.bg_name, 			T1.b_name, 			T1.c_name, 			T1.cmsession, 			T1.eslcm 		ORDER BY 			T1.bg_id 	) T2 GROUP BY 	T2.bg_id, 	T2.bg_name 					";
					System.out.println(sql);
					List<HashMap<String, Object>> data = util.executeQuery(sql);
		             if(data.size()>0)
		             {	
		            	

		             	for(HashMap<String, Object> row : data)
		             	{
		             		int bg_id= (int)row.get("bg_id");
		             		String bg_name= (String)row.get("bg_name");
		             		String course_name= (String)row.get("course_name");
		             		String b_name= (String)row.get("b_name");
		             		String perc = (String)row.get("perc");
		             		
		             		sb.append("<h2>Program: "+bg_name+"</h2>");
		             		

		             		String[] seperate_b_name = b_name.split("!#");
		             		String[] seperate_course_name = course_name.split("!#");
		             		String[] seperate_perc = perc.split("!#");
		             		int count =1;
		             		for(int i=0; i<seperate_b_name.length;i++)
		             		{
		             			//sb.append("<small>Batch: "+seperate_b_name[i]+"</small>");
		             			
		             			sb.append("<ul class='list-group clear-list m-t'>"); 
		             			sb.append("<li class='list-group-item'>");
             					sb.append("<span class='badge badge-primary pull-right'>"+seperate_course_name[i]+" - "+seperate_perc[i]+"% Completed</span>");
             					sb.append("<span class='label label-success' style='margin-right: 16px;'>" + count +  " </span>  " + seperate_b_name[i]+"");
             					
             					sb.append(" </li>");
             					sb.append("</ul>");
             					count++;
		             		}
		             		
		             		
		             		
		             		
		             		
                            
		             		
		            
		             		// System.out.println("------------------batchgroup---------------------------------------"+bg_id+"--"+bg_name+"---"+b_name+"---"+perc);
		             		 
		             			
		             	}
     		
					
				}

					
				
			 }
				
			 }else if(request.getParameter("actTab").contentEquals("course")){
				  col_id =request.getParameter("ids");

				 ids= request.getParameter("ids");

				 
				 String[] seperate_ids = col_id.split(",");
					
					
					for(String Colid : seperate_ids){
						

						
						sql ="SELECT 	T2.c_id as c_id,   T2.c_name AS c_name, 	string_agg (T2.bg_name, '!#') AS bg_name, 	string_agg ( 		CAST (T2.perc AS VARCHAR(50)), 		'!#' 	) AS perc FROM 	( 		SELECT 			T1.c_id, 			T1.bg_name, 			T1.b_name, 			T1.c_name, 			CASE T1.cmsession 		WHEN 0 THEN 			0 		ELSE 			T1.eslcm * 100 / T1.cmsession 		END AS perc 		FROM 			( 				SELECT DISTINCT 					batch.batch_group_id AS bg_id, 					batch_group. NAME AS bg_name, 					batch. NAME AS b_name, 					event_session_log.course_id as c_id, 					course.course_name AS c_name, 					COUNT (DISTINCT cmsession. ID) AS cmsession, 					COUNT ( 						DISTINCT event_session_log.cmsession_id 					) AS eslcm 				FROM 					event_session_log, 					batch, 					batch_group, 					college, 					course, 					MODULE, 					cmsession 				WHERE 					event_session_log.batch_id = batch. ID 				AND batch.batch_group_id = batch_group. ID 				AND batch_group.college_id = college. ID 				AND event_session_log.course_id = course. ID 				AND course. ID = MODULE .course_id 				AND MODULE . ID = cmsession.module_id 				"
								+ "AND college. ID = "+Colid+" 				GROUP BY 					batch_id,           bg_name, 					batch. NAME, 					c_id, 					c_name, 					bg_id 			) T1 		GROUP BY 			T1.c_id,T1.bg_name,T1.b_name, 			T1.c_name,T1.cmsession,	T1.eslcm 		ORDER BY 			T1.c_id 	) T2 GROUP BY 	T2.c_id,T2.c_name";
						
						List<HashMap<String, Object>> data = util.executeQuery(sql);
			             if(data.size()>0)
			             {	
			            	

			             	for(HashMap<String, Object> row : data)
			             	{
			             		int c_id= (int)row.get("c_id");
			             		String bg_name= (String)row.get("bg_name");
			             		String c_name= (String)row.get("c_name");
			             		String perc = (String)row.get("perc");
			             		
			             		sb.append("<h2>Course: "+c_name+"</h2>"); 
			             		

			             		String[] seperate_bg_name = bg_name.split("!#");
	             				String[] seperate_perc = perc.split("!#");
	             				
	             				
	             				int count =1;
	             				for(int i=0; i<seperate_bg_name.length;i++)
			             		{
			             			
			             			sb.append("<ul class='list-group clear-list m-t'>"); 
			             			sb.append("<li class='list-group-item'>");
	             					sb.append("<span class='badge badge-primary pull-right'>"+seperate_perc[i]+"% Completed</span>");
	             					sb.append("<span class='label label-success' style='margin-right: 16px;'>" + count +  " </span>  " + seperate_bg_name[i]+"");
	             					
	             					sb.append(" </li>");
	             					sb.append("</ul>");
	             					count++;
			             		}

			             	}

					}
			
					
			 }
            		 

			 
			 }
			
		response.getWriter().print(sb);

	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
