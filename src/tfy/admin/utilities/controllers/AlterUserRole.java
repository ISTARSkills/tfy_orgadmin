package tfy.admin.utilities.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class AlterUserRole
 */
@WebServlet("/edit_roles")
public class AlterUserRole extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AlterUserRole() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String roles[] = request.getParameterValues("roles");
		String userId =request.getParameter("user_id");
		DBUTILS util = new  DBUTILS();
		
		String deleteOldRoles = "delete from user_role where user_id="+userId;
		util.executeUpdate(deleteOldRoles);		
		
		if(roles!=null)
		{
			for(String role: roles)
			{
				int roleId = Integer.parseInt(role);
				String checkIfExist ="";
			}
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
