package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.utils.DatatableUtils;

/**
 * Servlet implementation class EditAddEntity
 */
@WebServlet("/edit_data")
public class EditAddEntity extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public EditAddEntity() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		printAttrs(request);

		int reportID = Integer.parseInt(request.getParameter("report_id").toString());
		int id = 0;
		HashMap<String, String> conditions = new HashMap<>();

		for (Object key : request.getParameterMap().keySet()) {
			String keyString = key.toString();
			String reportKey = new String();
			if (keyString.startsWith("data[") && keyString.contains("][")) {
				id = Integer.parseInt(keyString.split("\\[")[1].replaceAll("\\]", ""));
				reportKey = keyString.substring(keyString.lastIndexOf("][") + 1);
				reportKey = reportKey.substring(1, reportKey.indexOf("]"));

				conditions.put(reportKey, request.getParameter(key.toString()));
			}
		}

		for (Object key : request.getParameterMap().keySet()) {
			String keyString = key.toString();
			String reportKey = new String();
			if (keyString.startsWith("foreign_key") && !keyString.endsWith("_value") ) {	//keyString = "foreign_key_1" ; reportKey = "organization_id" ; conditions.get(reportKey) = "4"
				reportKey = request.getParameter(keyString);
				conditions.put(reportKey, request.getParameter(keyString+"_value"));
			}
		}
		
		List<HashMap<String, Object>> result = new ArrayList<>();
		if (id != 0) {
			conditions.put("id", id + "");
			result = (new DatatableUtils()).updateData(reportID, conditions);
		} else {
			result = (new DatatableUtils()).createNewRecord(reportID, conditions);
		}

		// Send acknowledgement message back to the client once transaction is successful
		response.setContentType("application/json");
		JSONObject parentJson = new JSONObject();
		JSONArray responseJSONArray = new JSONArray();
		JSONObject json = new JSONObject();

		for (String key : result.get(0).keySet()) {
			try {
				json.put(key, result.get(0).get(key));
			} catch (JSONException e) {
				// e.printStackTrace();
			}
		}

		try {
			responseJSONArray.put(json);
			parentJson.put("data", responseJSONArray);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		// System.err.println("response json array string -> " +
		// parentJson.toString());
		PrintWriter out = response.getWriter();
		out.print(parentJson);
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
