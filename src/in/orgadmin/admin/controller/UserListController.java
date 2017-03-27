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

import com.google.gson.JsonObject;
import com.istarindia.apps.dao.DBUTILS;

/**
 * Servlet implementation class UserListController
 */
@WebServlet("/get_list_of_users")
public class UserListController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserListController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int collegeId = Integer.parseInt(request.getParameter("college_id"));

		String searchTerm = request.getParameter("search[value]");

		String limtQuery = "";
		if (searchTerm != null && searchTerm.equalsIgnoreCase("")) {
			limtQuery = " limit " + request.getParameter("length") + " offset " + request.getParameter("start");
		}

		DBUTILS db = new DBUTILS();

		String sql = "SELECT profile_image, name, atten_perc, email, batch_groups, id, courses, course_ids, user_id FROM ( SELECT student. ID, student. NAME, student.email, case when student_profile_data.profile_image like 'null'"
				+ " OR student_profile_data.profile_image is null then 'http://api.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' "
				+ "ELSE 'http://api.talentify.in/'||student_profile_data.profile_image end as profile_image, string_agg ( distinct (batch_group. NAME), ', ') AS batch_groups,"
				+ " string_agg ( DISTINCT (course_name), ', ') AS courses, string_agg ( distinct (CAST ( batch_group. ID AS VARCHAR)), ', ' ) AS batch_group_ids,"
				+ " string_agg ( distinct (CAST (course. ID AS VARCHAR)), ', ' ) AS course_ids FROM course, batch, batch_group, student, batch_students,"
				+ " student_profile_data WHERE student.organization_id = " + collegeId
				+ " AND student. ID = batch_students.student_id "
				+ "AND batch_students.batch_group_id = batch_group. ID AND batch_group.college_id = " + collegeId
				+ " AND student_profile_data.student_id = student. ID "
				+ "AND batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID GROUP BY student. ID, student. NAME, student.email, "
				+ "student_profile_data.profile_image ) T1 LEFT "
				+ "JOIN ( SELECT user_id, 		 COALESCE(cast ((( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 			) 		) * 100 / ( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 				OR attendance.status = 'PRESENT' 			) 		)) as integer),0) AS atten_perc"
				+ " FROM attendance WHERE user_id IN ( SELECT ID FROM 	student WHERE organization_id = " + collegeId
				+ " ) GROUP BY user_id ) T2 ON (T1. ID = T2.user_id) ORDER BY "
				+ (Integer.parseInt(request.getParameter("order[0][column]")) + 1) + " "
				+ request.getParameter("order[0][dir]") + limtQuery;

		if (collegeId == -3) {
			sql = "SELECT profile_image, name, atten_perc, email, batch_groups, id, courses, course_ids, user_id,organization_id,college_name FROM ( SELECT student. ID, student. NAME, student.email,college.name as college_name,student.organization_id, case when student_profile_data.profile_image like 'null'"
					+ " OR student_profile_data.profile_image is null then 'http://api.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' "
					+ "ELSE 'http://api.talentify.in/'||student_profile_data.profile_image end as profile_image, string_agg ( distinct (batch_group. NAME), ', ') AS batch_groups,"
					+ " string_agg ( DISTINCT (course_name), ', ') AS courses, string_agg ( distinct (CAST ( batch_group. ID AS VARCHAR)), ', ' ) AS batch_group_ids,"
					+ " string_agg ( distinct (CAST (course. ID AS VARCHAR)), ', ' ) AS course_ids FROM course, batch, batch_group, student, batch_students,"
					+ " student_profile_data,college WHERE  student. ID = batch_students.student_id AND college.id=student.organization_id "
					+ "AND batch_students.batch_group_id = batch_group. ID "
					+ " AND student_profile_data.student_id = student. ID "
					+ "AND batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID GROUP BY student. ID, student. NAME, student.email, "
					+ "student_profile_data.profile_image,college.name ) T1 LEFT "
					+ "JOIN ( SELECT user_id, 		 COALESCE(cast ((( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 			) 		) * 100 / ( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 				OR attendance.status = 'PRESENT' 			) 		)) as integer),0) AS atten_perc"
					+ " FROM attendance WHERE user_id IN ( SELECT ID FROM 	student "
					+ " ) GROUP BY user_id ) T2 ON (T1. ID = T2.user_id) ORDER BY "
					+ (Integer.parseInt(request.getParameter("order[0][column]")) + 1) + " "
					+ request.getParameter("order[0][dir]") + limtQuery;
		}

		System.err.println(sql);

		List<HashMap<String, Object>> data = db.executeQuery(sql);

		sql = "SELECT profile_image, name, atten_perc, email, batch_groups, id, courses, course_ids, user_id FROM ( SELECT student. ID, student. NAME, student.email, case when student_profile_data.profile_image like 'null'"
				+ " OR student_profile_data.profile_image is null then 'http://api.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' "
				+ "ELSE 'http://api.talentify.in/'||student_profile_data.profile_image end as profile_image, string_agg ( distinct (batch_group. NAME), ', ') AS batch_groups,"
				+ " string_agg ( DISTINCT (course_name), ', ') AS courses, string_agg ( distinct (CAST ( batch_group. ID AS VARCHAR)), ', ' ) AS batch_group_ids,"
				+ " string_agg ( distinct (CAST (course. ID AS VARCHAR)), ', ' ) AS course_ids FROM course, batch, batch_group, student, batch_students,"
				+ " student_profile_data WHERE student.organization_id = " + collegeId
				+ " AND student. ID = batch_students.student_id "
				+ "AND batch_students.batch_group_id = batch_group. ID AND batch_group.college_id = " + collegeId
				+ " AND student_profile_data.student_id = student. ID "
				+ "AND batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID GROUP BY student. ID, student. NAME, student.email, "
				+ "student_profile_data.profile_image ) T1 LEFT "
				+ "JOIN ( SELECT user_id, 		 COALESCE(cast ((( 	COUNT (*) FILTER (  	WHERE 		attendance.status = 'ABSENT' ) 	) * 100 / ( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 				OR attendance.status = 'PRESENT' 			) 		)) as integer),0) AS atten_perc"
				+ " FROM attendance WHERE user_id IN ( SELECT ID FROM 	student WHERE organization_id = " + collegeId
				+ " ) GROUP BY user_id ) T2 ON (T1. ID = T2.user_id)";

		if (collegeId == -3) {
			sql = "SELECT profile_image, name, atten_perc, email, batch_groups, id, courses, course_ids, user_id FROM ( SELECT student. ID, student. NAME, student.email, case when student_profile_data.profile_image like 'null'"
					+ " OR student_profile_data.profile_image is null then 'http://api.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' "
					+ "ELSE 'http://api.talentify.in/'||student_profile_data.profile_image end as profile_image, string_agg ( distinct (batch_group. NAME), ', ') AS batch_groups,"
					+ " string_agg ( DISTINCT (course_name), ', ') AS courses, string_agg ( distinct (CAST ( batch_group. ID AS VARCHAR)), ', ' ) AS batch_group_ids,"
					+ " string_agg ( distinct (CAST (course. ID AS VARCHAR)), ', ' ) AS course_ids FROM course, batch, batch_group, student, batch_students,"
					+ " student_profile_data WHERE " + " student. ID = batch_students.student_id "
					+ "AND batch_students.batch_group_id = batch_group. ID"
					+ " AND student_profile_data.student_id = student. ID "
					+ "AND batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID GROUP BY student. ID, student. NAME, student.email, "
					+ "student_profile_data.profile_image ) T1 LEFT "
					+ "JOIN ( SELECT user_id, 		 COALESCE(cast ((( 	COUNT (*) FILTER (  	WHERE 		attendance.status = 'ABSENT' ) 	) * 100 / ( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 				OR attendance.status = 'PRESENT' 			) 		)) as integer),0) AS atten_perc"
					+ " FROM attendance WHERE user_id IN ( SELECT ID FROM 	student "
					+ " ) GROUP BY user_id ) T2 ON (T1. ID = T2.user_id)";
		}

		List<HashMap<String, Object>> resultSize = db.executeQuery(sql);

		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("draw", request.getParameter("draw"));
			jsonObject.put("recordsTotal", resultSize.size() + "");
			jsonObject.put("recordsFiltered", resultSize.size() + "");
			jsonObject.put("iDisplayLength", 10);

			JSONArray array = new JSONArray();
			for (HashMap<String, Object> item : data) {

				// tableRowsdata.put(item.get("courses"));

				if (condition(item, searchTerm) || searchTerm.equalsIgnoreCase("")) {
					JSONArray tableRowsdata = new JSONArray();
					tableRowsdata.put("<img style='width:27px' src='" + item.get("profile_image").toString()
							+ "' class='img-sm img-circle'>");
					tableRowsdata.put(item.get("name"));
					if (item.get("atten_perc") != null) {
						int attendance_perc = ((int) item.get("atten_perc"));
						
						if (attendance_perc < 20) {
							tableRowsdata.put("<i class='fa fa-star'></i>");
						} else if (attendance_perc >= 20 && attendance_perc < 40) {
							tableRowsdata.put("<i class='fa fa-star'></i> <i class='fa fa-star'></i>");
						} else if (attendance_perc >= 40 && attendance_perc < 60) {
							tableRowsdata.put("<i class='fa fa-star'></i><i class='fa fa-star'></i> <i class='fa fa-star'></i>");
						} else if (attendance_perc >= 60 && attendance_perc < 80) {
							tableRowsdata.put("<i class='fa fa-star'></i><i class='fa fa-star'></i><i class='fa fa-star'></i> <i class='fa fa-star'></i>");
						} else if (attendance_perc >= 80 && attendance_perc <= 100) {
							tableRowsdata.put(
									"<i class='fa fa-star'></i><i class='fa fa-star'></i><i class='fa fa-star'></i><i class='fa fa-star'></i> <i class='fa fa-star'></i>");
						}
						
						
					} else {
						tableRowsdata.put("NA");
					}
					tableRowsdata.put(item.get("email"));
					tableRowsdata.put(item.get("batch_groups"));

					if (collegeId == -3) {
						tableRowsdata.put(item.get("college_name").toString() + " (" + item.get("organization_id") + ")");
					}

					tableRowsdata.put("<div class='btn-group'> "
							+ "<button data-toggle='dropdown' class='btn btn-default btn-xs dropdown-toggle'> "
							+ "<span class='fa fa-ellipsis-v'></span> </button> <ul class='dropdown-menu pull-right'> <li>"
							+ "" + "" + "<a class='user-edit-popup' data-user_id='" + item.get("id") + "'  "
							+ " id=edit_user_button_" + item.get("id") + ">Edit</button></li>	" + "</ul> </div>");
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
