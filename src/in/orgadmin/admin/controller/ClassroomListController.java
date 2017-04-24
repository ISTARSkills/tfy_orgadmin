package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.viksitpro.core.utilities.DBUTILS;


/**
 * Servlet implementation class ClassroomListController
 */
@WebServlet("/get_list_of_classroom")
public class ClassroomListController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ClassroomListController() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String searchTerm = request.getParameter("search[value]");

		boolean searchTermExist=false;
		
		String limtQuery = "";
		if (searchTerm != null && searchTerm.equalsIgnoreCase("")) {
			searchTermExist=true;
			limtQuery = " limit " + request.getParameter("length") + " offset " + request.getParameter("start");
		}

		DBUTILS db = new DBUTILS();

		String sql = "SELECT cl. ID as classroom_id,cl.classroom_identifier,cl.ip_address,org. NAME as org_name,cl.max_students,org. ID as org_id FROM "
				+ "	classroom_details cl, 	organization org WHERE 	org.ID = cl.organization_id ORDER BY "
				+ (Integer.parseInt(request.getParameter("order[0][column]")) + 1) + " "
				+ request.getParameter("order[0][dir]") + limtQuery;

		List<HashMap<String, Object>> data = db.executeQuery(sql);

		sql = "SELECT cl. ID as classroom_id,cl.classroom_identifier,cl.ip_address,org. NAME as org_name,cl.max_students,org. ID as org_id FROM "
				+ "	classroom_details cl, 	organization org WHERE 	org.ID = cl.organization_id";

		List<HashMap<String, Object>> resultSize = db.executeQuery(sql);

		int datasize=(searchTermExist)?resultSize.size():0;
		
		
		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("draw", request.getParameter("draw"));
			jsonObject.put("recordsTotal", datasize+ "");
			jsonObject.put("recordsFiltered", datasize+ "");
			jsonObject.put("iDisplayLength", 10);

			JSONArray array = new JSONArray();
			
			for (HashMap<String, Object> item : data) {
				
				if (condition(item, searchTerm) || searchTerm.equalsIgnoreCase("")) {
				JSONArray tableRowsdata = new JSONArray();
				
				tableRowsdata.put(item.get("classroom_id"));
				tableRowsdata.put(item.get("classroom_identifier"));
				tableRowsdata.put(item.get("ip_address"));
				tableRowsdata.put(item.get("org_name")+" ("+item.get("org_id")+")");
				tableRowsdata.put(item.get("max_students"));
				
				
				tableRowsdata.put("<div class='btn-group'> "
						+ "<button data-toggle='dropdown' class='btn btn-default btn-xs dropdown-toggle'> "
						+ "<span class='fa fa-ellipsis-v'></span> </button> <ul class='dropdown-menu pull-right'> <li>"
						+ "" + "" + "<a class='class-room-edit-popup' data-class_id='" + item.get("classroom_id") + "'  "
						+ " id=edit_class_button_" + item.get("classroom_id") + ">Edit</button></li>	" + "</ul> </div>"
						);
				
				array.put(tableRowsdata);
			}
			}
			jsonObject.put("data", array);

		} catch (Exception e) {

			e.printStackTrace();
		}

		response.setContentType("application/json");
		response.getWriter().print(jsonObject);
		response.getWriter().flush();
	}
	
	private boolean condition(HashMap<String, Object> item, String searchTerm) {
		boolean status = false;
		for (String key : item.keySet()) {
			if (item.get(key) != null && searchTerm != null) {
				for (int i = 0; i < searchTerm.split(",").length; i++) {
					if (item.get(key).toString().toUpperCase().contains(searchTerm.split(",")[i].toUpperCase())) {
						status = true;
						break;
					}
				}
			}
		}
		return status;
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
