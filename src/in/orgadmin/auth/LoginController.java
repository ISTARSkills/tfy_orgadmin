package in.orgadmin.auth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;


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
		request.getSession().removeAttribute("user");
		if (request.getParameterMap().containsKey("email") && request.getParameterMap().containsKey("password")) {
			System.out.println("Email -> " + request.getParameter("email"));
			System.out.println("Password -> " + request.getParameter("password"));
			
			try {
				IstarUserDAO dao = new IstarUserDAO();
				IstarUser user = dao.findByEmail(request.getParameter("email")).get(0);
				if (user.getPassword().equalsIgnoreCase(request.getParameter("password"))) {
					
					System.out.println("-------------------Email -> " +	user.getEmail());
					request.getSession().setMaxInactiveInterval(2000);
					request.getSession().setAttribute("user", user);
										
					
					String url = "";
					if (user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN")) { 
						
						System.out.println("User logged in. ID -> " + user.getUserRoles().iterator().next().getRole().getRoleName());
						System.out.println("User logged in. ID -> " + user.getId());
						System.out.println("User logged in. Type -> " + user.getUserRoles().iterator().next().getRole().getRoleName());
						url = "/super_admin/dashboard.jsp";
					}else if (user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("STUDENT")) {
						
						url = "/orgadmin/student/dashboard.jsp?student_id=" + user.getId();
					} else if (user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("ORG_ADMIN")) {
						
						System.out.println("User logged in. ID -> " + user.getUserRoles().iterator().next().getRole().getRoleName());
						System.out.println("User logged in. ID -> " + user.getId());
						System.out.println("User logged in. Type -> " + user.getUserRoles().iterator().next().getRole().getRoleName());
						
						
						request.getSession().setAttribute("orgId", user.getUserOrgMappings().iterator().next().getOrganization().getId());
						
						url = "/orgadmin/dashboard.jsp";
					} 
					System.out.println(url);
					request.getRequestDispatcher(url).forward(request, response);
				} else {
					request.setAttribute("msg", "Wrong Username or password");
					request.getRequestDispatcher("/index.jsp").forward(request, response);
				}
			} catch (Exception e) {
				//e.printStackTrace();
				request.setAttribute("msg", "Missing Username or password");
				request.getRequestDispatcher("/index.jsp").forward(request, response);
			}
		} else {
			
			System.err.println("9111");
			request.setAttribute("msg", "Missing Username or password");
			request.getRequestDispatcher("/index.jsp").forward(request, response);
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
