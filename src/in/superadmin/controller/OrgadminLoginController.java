package in.superadmin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.IStarBaseServelet;



/**
 * Servlet implementation class OrgadminLoginController
 */
@WebServlet("/orgadmin_login")
public class OrgadminLoginController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrgadminLoginController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		request.getSession().removeAttribute("orgId");
		String url = "/orgadmin/dashboard.jsp";
		if(request.getParameter("org_id")!=null){
			request.getSession().setAttribute("orgId", Integer.parseInt(request.getParameter("org_id")));
			request.getSession().setAttribute("not_auth", "true");
			//System.out.println("Hello----------------------------------------------->Hello");
			request.getRequestDispatcher("/orgadmin/dashboard.jsp").forward(request, response);
		}
		
		if(request.getParameter("delete_session")!=null &&request.getParameter("delete_session").equalsIgnoreCase("true") ){
			//System.out.println("delete_session");
		//	request.getSession().removeAttribute("orgAdmin_session");
			 request.getSession().removeAttribute("not_auth");
		}
		
	//	request.getRequestDispatcher(url).forward(request, response);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
