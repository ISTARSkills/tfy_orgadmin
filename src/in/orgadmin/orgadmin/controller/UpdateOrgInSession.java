package in.orgadmin.orgadmin.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class UpdateOrgInSession
 */
@WebServlet("/update_org_insession")
public class UpdateOrgInSession extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdateOrgInSession() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String url = request.getHeader("referer");
		int org_id = Integer.parseInt(request.getParameter("org_id"));
		String org_name = request.getParameter("org_name");
		request.getSession().removeAttribute("org_id");
		request.getSession().removeAttribute("org_name");
		request.getSession().setAttribute("org_id", org_id);
		request.getSession().setAttribute("org_name", org_name);
		response.sendRedirect("/orgadmin/organization/dashboard.jsp?org_id=" + org_id);

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
