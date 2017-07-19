package tfy.admin.controllers;

import java.io.IOException;
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

import com.viksitpro.core.customtask.DropDownItem;
import com.viksitpro.core.customtask.DropDownList;
import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.utils.CMSRegistry;

/**
 * Servlet implementation class GetDataForDropdown
 */
@WebServlet("/get_data_for_dropdown")
public class GetDataForDropdown extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetDataForDropdown() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String searchTerm="";
		String dependencyTerm="";
		if( request.getParameterMap().containsKey("q"))
		{
			searchTerm = request.getParameter("q").replace("'", "");
		}
		if( request.getParameterMap().containsKey("dependency"))
		{
			dependencyTerm = request.getParameter("dependency").replace("'", "");
		}
		String sql = request.getParameter("sql").replaceAll("\"", "'").trim();
		
		DBUTILS util = new DBUTILS();
		sql =sql.replaceAll(":search_term", searchTerm.toLowerCase());
		sql =sql.replaceAll(":dependency_term", dependencyTerm);
		
		System.out.println("sql >>"+sql);
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		for (HashMap<String, Object> row : data) {
			try {
				jsonArray.put(new JSONObject().put("key",row.get("key").toString()).put("value", row.get("value").toString()));
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

}
