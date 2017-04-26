package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class PinCodeCOntroller
 */
@WebServlet("/PinCodeController")
public class PinCodeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PinCodeController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		printParams(request);
		String search_terms = request.getParameter("q").toString();
		
		DBUTILS dbutils = new DBUTILS();
		
		List<HashMap<String, Object>>  pincodeObject= dbutils.executeQuery("select distinct pin from pincode where CAST(pin AS TEXT) like '%"
				+ search_terms
				+ "%'");
		

		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		for (HashMap<String, Object> test : pincodeObject) {
			try {
				jsonArray.put(new JSONObject().put("id", test.get("pin")));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			
		}
		try {
			jsonObject.put("items", jsonArray);
			jsonObject.put("total_count", jsonArray.length());

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("application/json");

		response.getWriter().print(jsonObject);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	private void printParams(HttpServletRequest request) {
		// TODO Auto-generated method stub
		Enumeration params = request.getParameterNames(); 
		while(params.hasMoreElements()){
		 String paramName = (String)params.nextElement();
		 System.out.println("Parameter Name - "+paramName+", Value - "+request.getParameter(paramName));
		}
	}


}
