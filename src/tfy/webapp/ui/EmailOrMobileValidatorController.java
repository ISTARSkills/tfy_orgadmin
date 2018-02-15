package tfy.webapp.ui;

import java.io.IOException;
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
 * Servlet implementation class EmailOrMobileValidatorController
 */
@WebServlet("/email_mobile_validator")
public class EmailOrMobileValidatorController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EmailOrMobileValidatorController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		printparams(request);
		String email = "";
		String mobile = "";
		DBUTILS db = new DBUTILS();
		if(request.getParameter("key") !=null && request.getParameter("key").equalsIgnoreCase("email")){
			email = request.getParameter("value");
			String sql = "select cast(count(*) as integer) as exist from istar_user where email = '"+email+"'";
			List<HashMap<String, Object>> data = db.executeQuery(sql);
			if((int)data.get(0).get("exist") > 0){
				response.getWriter().print("Email already exist");
			}else{
				response.getWriter().print("new email");
			}
		}else if (request.getParameter("key") !=null && request.getParameter("key").equalsIgnoreCase("mobile")){
			mobile = request.getParameter("value");
			String sql = "select cast(count(*) as integer) as exist from istar_user where mobile = "+mobile+"";
			List<HashMap<String, Object>> data = db.executeQuery(sql);
			if((int)data.get(0).get("exist") > 0){
				response.getWriter().print("Mobile already exist");
			}else{
				response.getWriter().print("new mobile");
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
