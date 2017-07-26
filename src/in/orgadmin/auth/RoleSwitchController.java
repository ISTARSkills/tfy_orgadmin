package in.orgadmin.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class RoleSwitchController
 */
@WebServlet("/role_switch_controller")
public class RoleSwitchController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RoleSwitchController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		if(request.getParameterMap().containsKey("org_id"))
		{
			//trying to login as orgadmin
			
			int orgId = Integer.parseInt(request.getParameter("org_id"));
			request.getSession().setAttribute("orgId",
					orgId);
			request.getSession().removeAttribute("logged_in_role");
			request.getSession().setAttribute("logged_in_role", "ORG_ADMIN");
			String	url = "/orgadmin/dashboard.jsp";
					response.sendRedirect(url);
		}
		else
		{
			
			String newRole = request.getParameter("new_role");
			String refrer = request.getHeader("Referer");
			System.out.println("refre - "+refrer);
			request.getSession().removeAttribute("logged_in_role");
			request.getSession().setAttribute("logged_in_role", newRole);
			String	url="";
			if (newRole.equalsIgnoreCase("SUPER_ADMIN")) {
				url = "/super_admin/dashboard.jsp";
				response.sendRedirect(url);
			} else if (newRole.equalsIgnoreCase("ORG_ADMIN")) {

				
			} else if (newRole.equalsIgnoreCase("COORDINATOR")) {
				
				url = "/coordinator/dashboard.jsp";
				response.sendRedirect(url);
			} else if (newRole.equalsIgnoreCase("MASTER_TRAINER")) {
				
				url = "/student/dashboard.jsp";
				response.sendRedirect(url);
			} else if (newRole.equalsIgnoreCase("TRAINER")) {
				url = "/student/dashboard.jsp";
				response.sendRedirect(url);
			} else if (newRole.equalsIgnoreCase("STUDENT")) {
				url = "/student/dashboard.jsp";
				response.sendRedirect(url);
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
