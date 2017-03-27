package in.orgadmin.auth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.IstarCoordinator;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.OrgAdmin;
import com.istarindia.apps.dao.PlacementOfficer;
import com.istarindia.apps.dao.Recruiter;

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
					request.getSession().setMaxInactiveInterval(2000);
					request.getSession().setAttribute("user", user);
										
					System.out.println("User logged in. ID -> " + user.getId());
					System.out.println("User logged in. Type -> " + user.getUserType());
					String url = "";
					if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")) { 
						url = "/super_admin/dashboard.jsp";
					} 
					
					else if (user.getUserType().equalsIgnoreCase("TRAINER")) {
						
						url = "/orgadmin/student/dashboard.jsp?trainer_id=" + user.getId();
					}else if (user.getUserType().equalsIgnoreCase("STUDENT")) {
						
						url = "/orgadmin/student/dashboard.jsp?student_id=" + user.getId();
					}
					
					
					
					else if (user.getUserType().equalsIgnoreCase("ORG_ADMIN")) {
						OrgAdmin admin = (OrgAdmin) user;
						
						request.getSession().setAttribute("orgId", admin.getCollege().getId());
						
						url = "/orgadmin/dashboard.jsp";
						//url = "/orgadmin/organization/dashboard.jsp?org_id=" + admin.getCollege().getId();
					} else if (user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR")) {
						IstarCoordinator admin = (IstarCoordinator) user;
						//url = "/orgadmin/organization/dashboard.jsp?org_id=" + admin.getCollege().getId();
						url = "/orgadmin/dashboard.jsp";

					} else if (user.getUserType().equalsIgnoreCase("RECRUITER")) {
						Recruiter admin = (Recruiter) user;
						url = "/recruiter/dashboard.jsp";
					} else if (user.getUserType().equalsIgnoreCase("PLACEMENT_OFFICER")) {
						PlacementOfficer admin = (PlacementOfficer) user;
						url = "/PlacementOfficer/dashboard.jsp";
					}
					System.out.println(url);
					request.getRequestDispatcher(url).forward(request, response);
				} else {
					request.setAttribute("msg", "Wrong Username or password");
					request.getRequestDispatcher("/index.jsp").forward(request, response);
				}
			} catch (Exception e) {
				e.printStackTrace();
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
