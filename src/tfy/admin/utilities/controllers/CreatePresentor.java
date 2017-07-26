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
		String presenterToDisplay = "N/A";
		String findIfPresentorExist ="select email as email from istar_user where id="+trainer_id;
		List<HashMap<String, Object>> presData = util.executeQuery(findIfPresentorExist);
		String trainerEmail = "";
		if(presData.get(0).size() > 0){
			trainerEmail = presData.get(0).get("email")+"";
			String firstPart = trainerEmail.split("@")[0];
			String lastPart = trainerEmail.split("@")[1];
			String presenterEmail = firstPart+"_presenter@"+lastPart;
			String findPresenterSql = "select id as presenter_id from istar_user where email ='"+presenterEmail+"'";
			List<HashMap<String, Object>> data = util.executeQuery(findPresenterSql);
			if(data!=null && data.size()>0)
			{
				if(data.get(0).get("presenter_id")!=null ){
					String presenterId = data.get(0).get("presenter_id")+"";
					presenterToDisplay = presenterId+"";
					String insertPresenterMapping = "INSERT INTO trainer_presentor (id, trainer_id, presentor_id) VALUES ((select max(id)+1 from trainer_presentor), "+trainer_id+", "+presenterId+");";
					util.executeUpdate(insertPresenterMapping);
				}
			}
			else
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
				presenterToDisplay = presentorId+"";
				String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + presentorId
						+ ", (select id from role where role_name='PRESENTOR'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
				util.executeUpdate(insertIntoUserRole);
				String insertTrainerPresenterMapping = "INSERT INTO trainer_presentor (id, trainer_id, presentor_id) VALUES ((select max(id)+1 from trainer_presentor), "+trainer_id+", "+presentorId+");";
				util.executeUpdate(insertTrainerPresenterMapping);
			}	
			
		}
		
		
		/*
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
			presenterToDisplay = presentorId+"";
			String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + presentorId
					+ ", (select id from role where role_name='PRESENTOR'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
			util.executeUpdate(insertIntoUserRole);
			
		}
		*/
		response.getWriter().print(presenterToDisplay);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
