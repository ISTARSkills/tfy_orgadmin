package tfy.admin.utilities.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class CreatePresentor
 */
@WebServlet("/create_presentor")
public class CreatePresentor extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreatePresentor() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String trainer_id = request.getParameter("trainer_id");
		DBUTILS util = new DBUTILS();
		String findIfPresentorExist ="select cast (count(*) as integer) as cnt from trainer_presentor where trainer_id="+trainer_id;
		List<HashMap<String, Object>> presData = util.executeQuery(findIfPresentorExist);
		if(presData.size()>0 && presData.get(0).get("cnt")!=null && (int)presData.get(0).get("cnt")==0)
		{
			IstarUser user = new IstarUserDAO().findById(Integer.parseInt(trainer_id));
			String email = user.getEmail();
			String presentor[] = email.split("@");
			String part1 = presentor[0];
			String part2 = presentor[1];
			String presentor_email = part1 + "_presenter@" + part2;
			
			String insertPresentorIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
					+ presentor_email + "', '" + user.getPassword() + "', now(), 9999999999, NULL, NULL, 't') returning id;";
			int presentorId = util.executeUpdateReturn(insertPresentorIntoIstarUser);
			
			String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + presentorId
					+ ", (select id from role where role_name='PRESENTOR'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
			util.executeUpdate(insertIntoUserRole);
			
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
