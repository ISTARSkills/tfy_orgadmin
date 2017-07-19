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

		String sql = "SELECT 	profile_image, 	first_name, 	atten_perc, 	email, 	batch_groups, 	ID, 	courses, 	course_ids FROM 	( 		SELECT 			istar_user. ID, 			user_profile.first_name, 			istar_user.email, 			CASE 		WHEN user_profile.profile_image LIKE 'null' 		OR user_profile.profile_image IS NULL THEN 			'http://cdn.talentify.in/video/android_images/' || UPPER ( 				SUBSTRING (user_profile.first_name FROM 1 FOR 1) 			) || '.png' 		ELSE 			'http://cdn.talentify.in/' || user_profile.profile_image 		END AS profile_image, 		string_agg ( 			DISTINCT (batch_group. NAME), 			', ' 		) AS batch_groups, 		string_agg (DISTINCT(course_name), ', ') AS courses, 		string_agg ( 			DISTINCT ( 				CAST (batch_group. ID AS VARCHAR) 			), 			', ' 		) AS batch_group_ids, 		 string_agg ( 			DISTINCT (CAST(course. ID AS VARCHAR)), 			', ' 		) AS course_ids 	FROM 		course, 		batch, 		batch_group, 		istar_user, 		batch_students, 		user_profile,     user_org_mapping 	WHERE 		user_org_mapping.organization_id = "
				+ collegeId
				+ " AND istar_user.id = user_org_mapping.user_id 	AND istar_user. ID = batch_students.student_id 	AND batch_students.batch_group_id = batch_group. ID 	AND batch_group.college_id = "
				+ collegeId
				+ " 	AND user_profile.user_id = istar_user. ID 	AND batch_group. ID = batch.batch_group_id 	AND batch.course_id = course. ID 	GROUP BY 		istar_user. ID, 		user_profile.first_name, 		istar_user.email, 		user_profile.profile_image 	) T1 LEFT JOIN ( 	SELECT 		user_id, 		COALESCE ( 			CAST ( 				( 					( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 						) 					) * 100 / ( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 							OR attendance.status = 'PRESENT' 						) 					) 				) AS INTEGER 			), 			0 		) AS atten_perc 	FROM 		attendance 	WHERE 		user_id IN ( 			SELECT 				istar_user.ID 			FROM 				istar_user,         user_org_mapping 			WHERE 				user_org_mapping.organization_id = "
				+ collegeId
				+ " AND istar_user.id = user_org_mapping.organization_id 		) 	GROUP BY 		user_id ) T2 ON (T1. ID = T2.user_id) ORDER BY "
				+ (Integer.parseInt(request.getParameter("order[0][column]")) + 1) + " "
				+ request.getParameter("order[0][dir]") + limtQuery;

		if (collegeId == -3) {
			sql = "SELECT 	profile_image, 	first_name, 	atten_perc, 	email, 	batch_groups, 	ID, 	courses, 	course_ids, 	organization_id, 	college_name FROM 	( 		SELECT 			istar_user. ID, 			user_profile.first_name, 			istar_user.email, 			organization. NAME AS college_name, 			user_org_mapping.organization_id, 			CASE 		WHEN user_profile.profile_image LIKE 'null' 		OR user_profile.profile_image IS NULL THEN 			'http://cdn.talentify.in/video/android_images/' || UPPER ( 				SUBSTRING (user_profile.first_name FROM 1 FOR 1) 			) || '.png' 		ELSE 			'http://cdn.talentify.in/' || user_profile.profile_image 		END AS profile_image, 		string_agg ( 			DISTINCT (batch_group. NAME), 			', ' 		) AS batch_groups, 		string_agg (DISTINCT(course_name), ', ') AS courses, 		string_agg ( 			DISTINCT ( 				CAST (batch_group. ID AS VARCHAR) 			), 			', ' 		) AS batch_group_ids, 		string_agg ( 			DISTINCT (CAST(course. ID AS VARCHAR)), 			', ' 		) AS course_ids 	FROM 		course, 		batch, 		batch_group, 		istar_user, 		batch_students, 		user_profile,     user_org_mapping, 		organization 	WHERE 		istar_user. ID = batch_students.student_id   AND istar_user.id = user_org_mapping.user_id 	AND organization. ID = user_org_mapping.organization_id 	AND batch_students.batch_group_id = batch_group. ID 	AND user_profile.user_id = istar_user. ID 	AND batch_group. ID = batch.batch_group_id 	AND batch.course_id = course. ID 	GROUP BY 		istar_user. ID, 		user_profile. first_name, 		istar_user.email, 		user_profile.profile_image, 		organization. NAME, user_org_mapping.organization_id 	) T1 LEFT JOIN ( 	SELECT 		user_id, 		COALESCE ( 			CAST ( 				( 					( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 						) 					) * 100 / ( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 							OR attendance.status = 'PRESENT' 						) 					) 				) AS INTEGER 			), 			0 		) AS atten_perc 	FROM 		attendance 	WHERE 		user_id IN (SELECT ID FROM istar_user) 	GROUP BY 		user_id ) T2 ON (T1. ID = T2.user_id) ORDER BY "
					+ (Integer.parseInt(request.getParameter("order[0][column]")) + 1) + " "
					+ request.getParameter("order[0][dir]") + limtQuery;
		}

		//System.err.println(sql);

		List<HashMap<String, Object>> data = db.executeQuery(sql);

		sql = "SELECT 	profile_image, 	first_name, 	atten_perc, 	email, 	batch_groups, 	ID, 	courses, 	course_ids FROM 	( 		SELECT 			istar_user. ID, 			user_profile.first_name, 			istar_user.email, 			CASE 		WHEN user_profile.profile_image LIKE 'null' 		OR user_profile.profile_image IS NULL THEN 			'http://cdn.talentify.in/video/android_images/' || UPPER ( 				SUBSTRING (user_profile.first_name FROM 1 FOR 1) 			) || '.png' 		ELSE 			'http://cdn.talentify.in/' || user_profile.profile_image 		END AS profile_image, 		string_agg ( 			DISTINCT (batch_group. NAME), 			', ' 		) AS batch_groups, 		 string_agg (DISTINCT(course_name), ', ') AS courses, 		string_agg ( 			DISTINCT ( 				CAST (batch_group. ID AS VARCHAR) 			), 			', ' 		) AS batch_group_ids, 		 string_agg ( 			DISTINCT (CAST(course. ID AS VARCHAR)), 			', ' 		) AS course_ids 	FROM 		course, 		batch, 		batch_group, 		istar_user, 		batch_students, 		user_profile, user_org_mapping 	WHERE 		user_org_mapping.organization_id = "
				+ collegeId
				+ " AND user_org_mapping.user_id = istar_user.id 	AND istar_user. ID = batch_students.student_id 	AND batch_students.batch_group_id = batch_group. ID 	AND batch_group.college_id = "
				+ collegeId
				+ " 	AND user_profile.user_id = istar_user. ID 	AND batch_group. ID = batch.batch_group_id 	AND batch.course_id = course. ID 	GROUP BY 		istar_user. ID, 		user_profile.first_name, 		istar_user.email, 		user_profile.profile_image 	) T1 LEFT JOIN ( 	SELECT 		user_id, 		COALESCE ( 			CAST ( 				( 					( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 						) 					) * 100 / ( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 							OR attendance.status = 'PRESENT' 						) 					) 				) AS INTEGER 			), 			0 		) AS atten_perc 	FROM 		attendance 	WHERE 		user_id IN ( 			SELECT 				istar_user.ID 			FROM 				istar_user, user_org_mapping 			WHERE istar_user.id = user_org_mapping.user_id 				AND user_org_mapping.organization_id = "
				+ collegeId + " 		) 	GROUP BY 		user_id ) T2 ON (T1. ID = T2.user_id)";

		if (collegeId == -3) {
			sql = "SELECT 	profile_image, 	first_name, 	atten_perc, 	email, 	batch_groups, 	ID, 	courses, 	course_ids FROM 	( 		SELECT 			istar_user. ID, 			user_profile.first_name, 			istar_user.email, 			CASE 		WHEN user_profile.profile_image LIKE 'null' 		OR user_profile.profile_image IS NULL THEN 			'http://cdn.talentify.in/video/android_images/' || UPPER ( 				SUBSTRING (user_profile. first_name FROM 1 FOR 1) 			) || '.png' 		ELSE 			'http://cdn.talentify.in/' || user_profile.profile_image 		END AS profile_image, 		string_agg ( 			DISTINCT (batch_group. NAME), 			', ' 		) AS batch_groups, 		 string_agg (DISTINCT(course_name), ', ') AS courses, 		string_agg ( 			DISTINCT ( 				CAST (batch_group. ID AS VARCHAR) 			), 			', ' 		) AS batch_group_ids, 		 string_agg ( 			DISTINCT (CAST(course. ID AS VARCHAR)), 			', ' 		) AS course_ids 	FROM 		course, 		batch, 		batch_group, 		istar_user, 		batch_students, 		 user_profile 	WHERE 		 istar_user. ID = batch_students.student_id 	AND batch_students.batch_group_id = batch_group. ID 	AND user_profile.user_id = istar_user. ID 	AND batch_group. ID = batch.batch_group_id 	AND batch.course_id = course. ID 	GROUP BY 		istar_user. ID, 		user_profile.first_name, 		istar_user.email, 		user_profile.profile_image 	) T1 LEFT JOIN ( 	SELECT 		user_id, 		COALESCE ( 			CAST ( 				( 					( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 						) 					) * 100 / ( 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'ABSENT' 							OR attendance.status = 'PRESENT' 						) 					) 				) AS INTEGER 			), 			0 		) AS atten_perc 	FROM 		attendance 	WHERE 		user_id IN ( 			SELECT 				ID 			FROM 				istar_user 		) 	GROUP BY 		user_id ) T2 ON (T1. ID = T2.user_id)";
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
					tableRowsdata.put(item.get("first_name"));
					if (item.get("atten_perc") != null) {
						int attendance_perc = ((int) item.get("atten_perc"));

						if (attendance_perc < 20) {
							tableRowsdata.put("<i class='fa fa-star'></i>");
						} else if (attendance_perc >= 20 && attendance_perc < 40) {
							tableRowsdata.put("<i class='fa fa-star'></i> <i class='fa fa-star'></i>");
						} else if (attendance_perc >= 40 && attendance_perc < 60) {
							tableRowsdata.put(
									"<i class='fa fa-star'></i><i class='fa fa-star'></i> <i class='fa fa-star'></i>");
						} else if (attendance_perc >= 60 && attendance_perc < 80) {
							tableRowsdata.put(
									"<i class='fa fa-star'></i><i class='fa fa-star'></i><i class='fa fa-star'></i> <i class='fa fa-star'></i>");
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
						tableRowsdata
								.put(item.get("college_name").toString() + " (" + item.get("organization_id") + ")");
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
