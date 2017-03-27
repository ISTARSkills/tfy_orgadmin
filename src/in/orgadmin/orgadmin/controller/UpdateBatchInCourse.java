package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.controllers.IStarBaseServelet;
import com.sun.jmx.snmp.Timestamp;

/**
 * Servlet implementation class UpdateBatchInCourse
 */
@WebServlet("/update_batch_in_course")
public class UpdateBatchInCourse extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateBatchInCourse() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		printParams(request);
		
		String referrer = request.getHeader("referer");
		
		          
		DBUTILS util = new DBUTILS();
		
		String name = request.getParameter("batch_name");
		int	course_id = Integer.parseInt(request.getParameter("course_id"));
		
		
		
		
		
		Calendar cal = Calendar.getInstance();
		Date dt = cal.getTime();
	    
		if(request.getParameter("batch_id")!=null){
			
			int	batch_id = Integer.parseInt(request.getParameter("batch_id"));
				
			String update_sql = "UPDATE batch SET name = '"+name+"', course_id = "+course_id+" WHERE id="+batch_id;
		    util.executeUpdate(update_sql);
		    System.out.println("------------update_sql------------"+ update_sql);
		    
		    
		   
		    response.sendRedirect("orgadmin/courses/dashboard.jsp?course_id="+course_id);
		   		
		}else{
        	 
			int	batch_group_id = Integer.parseInt(request.getParameter("batch_group_id"));
			
			
			
			String insert_sql =  "INSERT INTO batch ( 	id, 	createdat, 	name, 	updatedat, 	batch_group_id, 	course_id, 	order_id )"
					+ " VALUES 	( 		(SELECT max(id) +1 FROM batch ), 		'"+dt+"', 		'"+name+"', 		'"+dt+"', 		"+batch_group_id+", 		"+course_id+", 		(SELECT max(id) +1 FROM batch ) 	) ";
		    System.out.println(insert_sql);
			util.executeUpdate(insert_sql);
			System.out.println(insert_sql);
			
			
			//request.getRequestDispatcher("orgadmin/batch_group/dashboard.jsp?batch_group_id="+batch_group_id).forward(request, response);
			 response.sendRedirect("orgadmin/batch_group/dashboard.jsp?batch_group_id="+batch_group_id);  
		}
		
		
	}
	

	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
