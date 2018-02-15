package in.orgadmin.auth;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Role;
import com.viksitpro.core.dao.entities.UserRole;
import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class LoginController
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (request.getParameterMap().containsKey("email") && request.getParameterMap().containsKey("password")) {

			ViksitLogger.logMSG(this.getClass().getName(),"Email -> " + request.getParameter("email"));
			ViksitLogger.logMSG(this.getClass().getName(),"Password -> " + request.getParameter("password"));
			IstarUserDAO dao = new IstarUserDAO();
			dao.getSession().clear();

			List<IstarUser> users = dao.findByEmail(request.getParameter("email").toLowerCase());
			
			//ViksitLogger.logMSG(this.getClass().getName(),users.size());

			if (users != null && users.size() != 0) {

				IstarUser user = users.get(0);
				DBUTILS util = new DBUTILS();
				String url = "";
				String findUserRole = "SELECT 	ROLE .role_name FROM 	user_role, 	ROLE WHERE 	user_role.role_id = ROLE . ID AND user_role.user_id = "
						+ user.getId() + " order by ROLE . ID  limit 1";
				
				List<HashMap<String, Object>> roles = util.executeQuery(findUserRole);
				
				String userRole = "";
				if (roles.size() > 0 && roles.get(0).get("role_name") != null) {
					userRole = roles.get(0).get("role_name").toString();
				}
				
					try {

						if (user.getPassword().equals(request.getParameter("password"))) {
							
							ArrayList<Role> userRoles = new ArrayList<>();
							for(UserRole ur : user.getUserRoles())
							{
								ViksitLogger.logMSG(this.getClass().getName(),"ur.getRole -- "+ur.getRole().getRoleName());
								userRoles.add(ur.getRole());
							}
							
							request.getSession().setAttribute("user_roles", userRoles);
							request.getSession().setAttribute("user", user);
							request.getSession().setAttribute("main_role", userRole);
							request.getSession().setAttribute("logged_in_role", userRole);
								
							if (userRole.equalsIgnoreCase("SUPER_ADMIN")) {
								url = "/super_admin/dashboard.jsp";
								request.getRequestDispatcher(url).forward(request, response);
							} else if (userRole.equalsIgnoreCase("ORG_ADMIN")) {

								request.getSession().setAttribute("orgId",
										user.getUserOrgMappings().iterator().next().getOrganization().getId());

								url = "/orgadmin/dashboard.jsp";
								request.getRequestDispatcher(url).forward(request, response);
							} else if (userRole.equalsIgnoreCase("COORDINATOR")) {
								request.getSession().setAttribute("user", user);
								url = "/coordinator/dashboard.jsp";
								request.getRequestDispatcher(url).forward(request, response);
							} else if (userRole.equalsIgnoreCase("MASTER_TRAINER")) {
								request.getSession().setAttribute("user", user);
								url = "/student/dashboard.jsp";
								request.getRequestDispatcher(url).forward(request, response);
							} else if (userRole.equalsIgnoreCase("TRAINER")) {
								url = "/student/dashboard.jsp";
								request.getRequestDispatcher(url).forward(request, response);
							} else if (userRole.equalsIgnoreCase("STUDENT")) {
								url = "/student/dashboard.jsp";
								request.getRequestDispatcher(url).forward(request, response);
							} else if (userRole.equalsIgnoreCase("CONTENT_CREATOR")) {
								url = "/content_creator/dashboard.jsp";
								request.getRequestDispatcher(url).forward(request, response);
							}

							else {

								request.setAttribute("msg", "User Does Not Have Permission To Access");
								request.getRequestDispatcher("/login.jsp").forward(request, response);
							}
							

						} else {
							request.setAttribute("msg", "Wrong Password");
							request.getRequestDispatcher("/login.jsp").forward(request, response);
						}

					} catch (Exception e) {
					
						request.setAttribute("msg", "Wrong Username");
						request.getRequestDispatcher("/login.jsp").forward(request, response);
					}
				
			} else {
				request.setAttribute("msg", "Missing Username or Password");
				request.getRequestDispatcher("/login.jsp").forward(request, response);
			}
		} else {

			//ViksitLogger.logMSG(this.getClass().getName(),("9111");
			request.setAttribute("msg", "Missing Username or Password");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
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
