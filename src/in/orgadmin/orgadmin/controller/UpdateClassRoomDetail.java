package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class UpdateClassRoomDetail
 */
@WebServlet("/update_classRoom_detail")
public class UpdateClassRoomDetail extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateClassRoomDetail() {
        super();
       
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		
		DBUTILS util = new DBUTILS();
		
		
		String class_name = request.getParameter("class_name");
		String ip_address = request.getParameter("ip_address");
		int	max_student = Integer.parseInt(request.getParameter("max_student"));
		
		System.out.println("------------out------------"+class_name+ip_address+max_student );
	    
		
        if(request.getParameter("classroom_identifier")!= null){
        	
        	int	class_id = Integer.parseInt(request.getParameter("classroom_identifier"));
        	
			String update_sql = "UPDATE classroom_details SET classroom_identifier = '"+class_name+"', max_students = "+max_student+", ip_address = '"+ip_address+"' WHERE id="+class_id;
			System.out.println("------------update_sql------------"+ update_sql);
			util.executeUpdate(update_sql);
		    System.out.println("------------update_sql------------"+ update_sql);
		    
			
		} else{
			
			int	org_id = Integer.parseInt(request.getParameter("org_id"));
			
			System.out.println("------------out------------"+org_id );
			   
       	 
			String insert_sql = "INSERT INTO classroom_details ( 	classroom_identifier, 	organization_id, 	max_students, 	id, 	ip_address ) "
			+ "VALUES 	( 		'"+class_name+"', 		"+org_id+", 		"+max_student+", 		(SELECT max(id) +1 FROM classroom_details ), 		'"+ip_address+"' 	) ";
			
			System.out.println(insert_sql);
			util.executeUpdate(insert_sql);
			System.out.println(insert_sql);

			response.sendRedirect("orgadmin/organization/dashboard.jsp?org_id="+org_id);
			
			
			
			   
		}
		
        //response.sendRedirect("orgadmin/organization/dashboard.jsp?org_id="+org_id);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
