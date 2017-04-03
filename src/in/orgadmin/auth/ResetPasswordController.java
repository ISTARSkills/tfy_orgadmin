package in.orgadmin.auth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;

/**
 * Servlet implementation class ResetPasswordController
 */
@WebServlet("/reset_password")
public class ResetPasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ResetPasswordController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (request.getParameterMap().containsKey("email") && request.getParameterMap().containsKey("old_password")
				&& request.getParameterMap().containsKey("new_password")) {
			try {
				IstarUserDAO dao = new IstarUserDAO();
				IstarUser user = dao.findByEmail(request.getParameter("email")).get(0);
				if (user.getPassword().equalsIgnoreCase(request.getParameter("old_password"))) {
					String new_password = request.getParameter("new_password").toString();
					Session session = dao.getSession();
					Transaction tx = null;
					try {
						user.setPassword(new_password);
						tx = session.beginTransaction();
						dao.attachDirty(user);
						tx.commit();
					} catch (Exception e) {
						if (tx != null)
							tx.rollback();
						e.printStackTrace();
					} finally {
						session.close();
					}

					request.getSession().removeAttribute("user");
					request.getRequestDispatcher("/").forward(request, response);
				} else {
					request.setAttribute("msg", "Old password doesn't match!");
					request.getRequestDispatcher("/index.jsp").forward(request, response);
				}
			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("msg", "Missing Username or password");
				request.getRequestDispatcher("/index.jsp").forward(request, response);
			}
		} else {
			request.setAttribute("msg", "Missing essential details. Please try again");
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
