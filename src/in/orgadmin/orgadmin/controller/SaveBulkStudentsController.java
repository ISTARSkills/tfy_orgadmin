package in.orgadmin.orgadmin.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.istarindia.apps.services.StudentService;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class SaveBulkStudentsController
 */
@WebServlet("/save_bulk_students")
public class SaveBulkStudentsController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SaveBulkStudentsController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);

		String jsonString = request.getParameter("jsonData").toString();
		int org_id = Integer.parseInt(request.getParameter("org_id"));
		System.out.println("---------------------org_id----------------"+org_id);
		try {
			JSONArray array = new JSONArray(jsonString);
			for (int i = 0; i < array.length(); i++) {
				JSONObject object = array.getJSONObject(i);
				String name = object.getString("Name");
				String email = object.getString("Email");
				String gender = object.getString("Gender");
				String mobile = object.getString("Mobile");
				
				StudentService service = new StudentService();
				service.createStudent(name, email, gender, Long.parseLong(mobile),org_id);
			}
		} catch (JSONException e) {
			e.printStackTrace();
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
