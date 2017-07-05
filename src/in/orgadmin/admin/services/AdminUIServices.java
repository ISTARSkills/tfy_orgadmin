/**
 * 
 */
package in.orgadmin.admin.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;



/**
 * @author mayank
 *
 */
public class AdminUIServices {

	public StringBuffer getCourses(int orgId) {
		// System.err.println(orgId);
		String sql = "SELECT DISTINCT 	course. ID, 	course.course_name FROM 	batch_group, 	batch, 	course WHERE 	batch_group.college_id = "
				+ orgId
				+ " AND batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID  ORDER BY course_name";

		if (orgId == -3) {
			sql = "SELECT DISTINCT 	course. ID, 	course.course_name FROM 	batch_group, 	batch, 	course where batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID  ORDER BY course_name";
		}

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("course_name") + "'>" + item.get("course_name") + "</option>");
		}
		out.append("");
		return out;
	}

	private String checkAlreadyExist(ArrayList<Integer> selected, int object) {
		if (selected.contains(object)) {
			return "selected";
		} else {
			return "";
		}
	}

	public StringBuffer getBatchGroups(int orgId, ArrayList<Integer> selectedOrgs) {
		// <option value="">Data Analytics</option>
		String sql = "SELECT DISTINCT 	batch_group. ID, 	batch_group. NAME FROM 	batch_group WHERE 	batch_group.college_id ="
				+ orgId + " ORDER BY name";

		if (orgId == -3) {
			sql = "SELECT DISTINCT 	batch_group. ID, 	batch_group. NAME FROM 	batch_group ORDER BY name";
		}

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {

			if (selectedOrgs != null) {
				out.append("<option " + checkAlreadyExist(selectedOrgs, (int) item.get("id")) + "  value='"
						+ item.get("id") + "'>" + item.get("name") + "</option>");
			} else {
				out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
			}
		}
		out.append("");
		return out;
	}

	public StringBuffer getAllOrganizations() {
		// <option value="">Data Analytics</option>
		String sql = "select id,name from organization";

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		out.append("<option value=''>Select Organization</option>");
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
		}
		out.append("");
		return out;
	}
	
	public List<HashMap<String, Object>> studentFeedbackTrainerInfo(int taskId){
		
		String sql="SELECT 	bse.eventdate,bse.id, c.course_name,	iu.email, 	up.first_name, 	iu. ID AS trainer_id, bse.batch_group_id, 	up.profile_image FROM "
				+ "	batch_schedule_event bse, 	istar_user iu, 	user_profile up,course c WHERE 	"
				+ "bse.batch_group_id IN ( 		SELECT 			batch_group_id 		FROM 			batch_schedule_event 		WHERE 			"
				+ "ID IN ( 				SELECT 					item_id 				FROM 					task 				WHERE 					ID = "+taskId+" 			) 	) "
						+ "AND bse.eventdate IN ( 	SELECT 		eventdate 	FROM 		batch_schedule_event 	WHERE 	"
						+ "	ID IN ( 			SELECT 				item_id 			FROM 				task 			WHERE 				ID = "+taskId+" 		) ) AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND bse.actor_id = iu. ID AND iu. ID = up.user_id AND bse.course_id=c.id";

		DBUTILS db = new DBUTILS();
		return db.executeQuery(sql);
	}
	
	

	/*public StringBuffer getAllStudents(int orgId) {
		// <option value="">Data Analytics</option>
		String sql = "SELECT * FROM ( SELECT student. ID, student. NAME, student.email,student.organization_id, case when student_profile_data.profile_image like 'null'"
				+ " OR student_profile_data.profile_image is null then 'http://cdn.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' "
				+ "ELSE 'http://cdn.talentify.in/'||student_profile_data.profile_image end as profile_image, string_agg ( distinct (batch_group. NAME), ', ') AS batch_groups,"
				+ " string_agg ( DISTINCT (course_name), ', ') AS courses, string_agg ( distinct (CAST ( batch_group. ID AS VARCHAR)), ', ' ) AS batch_group_ids,"
				+ " string_agg ( distinct (CAST (course. ID AS VARCHAR)), ', ' ) AS course_ids FROM course, batch, batch_group, student, batch_students,"
				+ " student_profile_data WHERE student.organization_id = " + orgId
				+ " AND student. ID = batch_students.student_id "
				+ "AND batch_students.batch_group_id = batch_group. ID AND batch_group.college_id = " + orgId
				+ " AND student_profile_data.student_id = student. ID "
				+ "AND batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID GROUP BY student. ID, student. NAME, student.email, "
				+ "student_profile_data.profile_image ) T1 LEFT "
				+ "JOIN ( SELECT user_id, 		 COALESCE(cast ((( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 			) 		) * 100 / ( 			COUNT (*) FILTER (  				WHERE 					attendance.status = 'ABSENT' 				OR attendance.status = 'PRESENT' 			) 		)) as integer),0) AS atten_perc"
				+ " FROM attendance WHERE user_id IN ( SELECT ID FROM 	student WHERE organization_id = " + orgId
				+ " ) GROUP BY user_id ) T2 ON (T1. ID = T2.user_id)";

		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<tr class='student_item' data-batch_group_id='" + item.get("batch_group_ids")
					+ "' data-course_id='" + item.get("course_ids") + "'>" + " <td><img style='width:27px' src='"
					+ item.get("profile_image") + "' class='img-sm img-circle'> </td> " + "<td>" + item.get("name")
					+ "</td><td>");
			if (item.get("atten_perc") != null) {
				int attendance_perc = ((int) item.get("atten_perc"));

				if (attendance_perc < 20) {
					out.append("<i class='fa fa-star-half-full'></i>");
				}
				for (int i = 0; i < attendance_perc / 20; i++) {
					out.append("<i class='fa fa-star'></i>");
				}
			} else {
				out.append("NA");
			}

			out.append("  </td> " + "<td>" + item.get("email") + "</td> <td>" + item.get("batch_groups")
					+ "</td><td style='display:none;'>" + item.get("courses") + "</td><td> <div class='btn-group'> "
					+ "<button data-toggle='dropdown' class='btn btn-default btn-xs dropdown-toggle'> "
					+ "<span class='fa fa-ellipsis-v'></span> </button> <ul class='dropdown-menu pull-right'> <li><a href='./partials/modal/admin_user_edit_modal.jsp?user_id="
					+ item.get("id") + "' data-toggle='modal' data-target='#edit_user_model_" + item.get("id") + "'"
					+ " id=edit_user_button_" + item.get("id") + ">Edit</a></li>	"
					+ "<div class='modal inmodal edit_modal' id='edit_user_model_" + item.get("id")
					+ "' tabindex='-1' 		role='dialog' aria-hidden='true'> 		<div class='modal-dialog modal-lg'> 			<div class='modal-content animated flipInY'> 				 				<!-- Content will be loaded here from 'admin_batch_roup_modal.jsp' file --> 				 			</div> 		</div> 	</div>"
					+ "  </ul> </div> </td> </tr>");
		}
		out.append("");
		return out;
	}*/
}
