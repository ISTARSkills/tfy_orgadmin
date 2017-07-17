package tfy.admin.utilities.controllers;

import java.io.IOException;
import java.util.ArrayList;
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
		
		ArrayList<Integer> trainerrelatedRoles = new ArrayList<>();
		String findRoleIdForTrainerAndMasterTrainer="select id from role where role_name in ('TRAINER','MASTER_TRAINER')";
		List<HashMap<String, Object>> roles = util.executeQuery(findRoleIdForTrainerAndMasterTrainer);		
		if(roles.size()>0)
		{
			for(HashMap<String, Object> row: roles)
			{
				trainerrelatedRoles.add((int)row.get("id"));
			}
		}
		if(trainerrelatedRoles.contains(Integer.parseInt(userRole)))
		{
			String presentor[] = email.split("@");
			String part1 = presentor[0];
			String part2 = presentor[1];
			String presentor_email = part1 + "_presenter@" + part2;
			String password="test123";
			
			String insertPresentorIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
					+ presentor_email + "', '" + password + "', now(),  9999999999, NULL, NULL, 't') returning id;";
			int presentorId = util.executeUpdateReturn(insertPresentorIntoIstarUser);
			
			String insertIntoUserRoleForPresentor = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + presentorId
					+ ", (select id from role where role_name='PRESENTOR'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
			util.executeUpdate(insertIntoUserRoleForPresentor);
			
			
			String insertTrainerPresentorMap = "INSERT INTO trainer_presentor (id, trainer_id, presentor_id) VALUES ((SELECT max(id)+1 from trainer_presentor) ,"
					+ " '"+urseId+"', (SELECT id from istar_user where email = '"+presentor_email+"'));";
			util.executeUpdate(insertTrainerPresentorMap);
			
		}
	
		
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
