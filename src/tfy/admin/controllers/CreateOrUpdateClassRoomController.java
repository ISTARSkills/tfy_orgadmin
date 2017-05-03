package tfy.admin.controllers;


import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.controllers.IStarBaseServelet;



/**
 * Servlet implementation class CreateOrUpdateOrganizationController
 */
@WebServlet("/create_or_update_classroom")
public class CreateOrUpdateClassRoomController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateOrUpdateClassRoomController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		boolean isCreate=true;
		int class_id=0;
		if(request.getParameter("class_id")!=null && !request.getParameter("class_id").equalsIgnoreCase("0")){
			isCreate=false;
			class_id=Integer.parseInt(request.getParameter("class_id"));
		}
		
		String class_name=request.getParameter("class_name");
		String class_ip=request.getParameter("class_ip");
		String class_students=request.getParameter("class_students");
		int org_id=Integer.parseInt(request.getParameter("org_id"));
		
		DBUTILS db=new DBUTILS();
		
		String sql="";
				
		if(isCreate){						
			sql="INSERT INTO classroom_details ( classroom_identifier, organization_id, max_students, ID, ip_address ) VALUES ( '"+class_name+"', "+org_id+", "+class_students+", (SELECT COALESCE (MAX(ID) + 1, 1) FROM classroom_details ), '"+class_ip+"')";
			db.executeUpdate(sql);
			
		}else{
				sql="UPDATE classroom_details SET classroom_identifier = '"+class_name+"',  organization_id = '"+org_id+"',  max_students = "+class_students+",  ip_address = '"+class_ip+"' WHERE ( ID ="+class_id+")";
				db.executeUpdate(sql);
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
