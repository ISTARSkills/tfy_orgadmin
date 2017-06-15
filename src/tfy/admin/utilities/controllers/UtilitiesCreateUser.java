package tfy.admin.utilities.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class UtilitiesCreateUser
 */
@WebServlet("/utilies_create_user")
public class UtilitiesCreateUser extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UtilitiesCreateUser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		String firstName = request.getParameter("first_name");
		String lastName = request.getParameter("last_name");
		String email = request.getParameter("email");
		String gender = request.getParameter("gender");
		String userRole = request.getParameter("user_role");
		String userOrg = request.getParameter("user_org");
		DBUTILS util = new DBUTILS();
		String insertIntoIstarUser ="INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"+email+"', 'test123', now(), NULL, NULL, NULL, 't') returning id;";
		int urseId = util.executeUpdateReturn(insertIntoIstarUser);
		
		String createUserProfile ="INSERT INTO user_profile (id,  first_name, last_name,  gender, user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"+firstName+"', '"+lastName+"', '"+gender+"',"+urseId+" );";
		util.executeUpdate(createUserProfile);

		String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES ("+urseId+", "+userRole+", ((select COALESCE(max(id),0)+1 from user_role)), 1);";
		util.executeUpdate(insertIntoUserRole);
		
		String insertIntoUserOrg = "INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("+urseId+", "+userOrg+", ((select COALESCE(max(id),0)+1 from user_org_mapping)));";
		util.executeUpdate(insertIntoUserOrg);
	
		
		response.sendRedirect("/super_admin/utilities/admin_page.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
