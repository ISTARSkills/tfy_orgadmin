package in.orgadmin.admin.controller;

import java.io.IOException;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.simple.JSONObject;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.utils.UIUtils;

/**
 * Servlet implementation class ProgramGraphs
 */
@WebServlet("/program_graphs")
public class ProgramGraphs extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ProgramGraphs() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		////ViksitLogger.logMSG(this.getClass().getName(),"-----program_graphs------>");
		String sql = "";
		int courseID = 0, orgID = 0;
		StringBuffer out = new StringBuffer();
		
		if (request.getParameterMap().containsKey("account_tab_orgID")) {
			
			orgID = Integer.parseInt(request.getParameter("account_tab_orgID"));

			UIUtils uiUtils = new UIUtils();

			out.append("<div class='row' style='display: flex;' id='course_event_card' >");
			out.append(uiUtils.getCourseEventCard(orgID));
			out.append("</div>");
			
			out.append("<div class='row 'style='display: flex;' id='batch_event_card' >");
			out.append(uiUtils.getBatchCard(orgID));
			out.append("</div>");	
			
			 response.getWriter().print(out);
			
		}

		else if (request.getParameterMap().containsKey("trainerSkill")) {

			sql = "SELECT skill_objective.name, 	count(trainer_id) FROM 	trainer_skill_distrubution_stats,skill_objective WHERE skill_objective.id = trainer_skill_distrubution_stats.skill_objective_id GROUP BY 	skill_objective.name ORDER BY skill_objective.name";

			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append(
					"<table id='datatable11'>     <thead>         <tr>             <th>SkillHead</th>             <th>Trainer</th>         </tr>     </thead>     "
							+ "<tbody>        ");

			for (HashMap<String, Object> item : data) {

				out.append(" <tr>             <th>"+item.get("name")+"</th>             <td>" + item.get("count")
				+" </td>         </tr>   ");

			}

			out.append("</tbody> </table>");
			response.getWriter().print(out);
		} else if (request.getParameterMap().containsKey("trainerRating")) {

			sql = "SELECT 	CAST(round(TF.r0, 2) AS INTEGER) AS r0, 	CAST(round(TF.r1, 2)AS INTEGER) AS r1, 	CAST(round(TF.r2, 2)AS INTEGER) AS r2, 	CAST(round(TF.r3, 2)AS INTEGER) AS r3, 	CAST(round(TF.r4, 2)AS INTEGER) AS r4, 	CAST(round(TF.r5, 2)AS INTEGER) AS r5 FROM 	( 		SELECT 			CASE 		WHEN sumrat = 0 THEN 			t1.rating0 		ELSE 			CAST (t1.rating0 * 100 AS DECIMAL) / sumrat 		END AS r0, 		CASE 	WHEN sumrat = 0 THEN 		t1.rating1 	ELSE 		CAST (t1.rating1 * 100 AS DECIMAL) / sumrat 	END AS r1, 	CASE WHEN sumrat = 0 THEN 	t1.rating2 ELSE 	CAST (t1.rating2 * 100 AS DECIMAL) / sumrat END AS r2,  CASE WHEN sumrat = 0 THEN 	t1.rating3 ELSE 	CAST (t1.rating3 * 100 AS DECIMAL) / sumrat END AS r3,  CASE WHEN sumrat = 0 THEN 	t1.rating4 ELSE 	CAST (t1.rating4 * 100 AS DECIMAL) / sumrat END AS r4,  CASE WHEN sumrat = 0 THEN 	t1.rating5 ELSE 	CAST (t1.rating5 * 100 AS DECIMAL) / sumrat END AS r5 FROM 	( 		SELECT 			T .rating0 + T .rating1 + T .rating2 + T .rating3 + T .rating4 + T .rating5 AS sumrat, 			T .* 		FROM 			( 				SELECT 					COUNT (*) FILTER (  						WHERE 							trainer_feedback.rating = 0 					) AS rating0, 					COUNT (*) FILTER (  						WHERE 							trainer_feedback.rating = 1 					) AS rating1, 					COUNT (*) FILTER (  						WHERE 							trainer_feedback.rating = 2 					) AS rating2, 					COUNT (*) FILTER (  						WHERE 							trainer_feedback.rating = 3 					) AS rating3, 					COUNT (*) FILTER (  						WHERE 							trainer_feedback.rating = 4 					) AS rating4, 					COUNT (*) FILTER (  						WHERE 							trainer_feedback.rating = 5 					) AS rating5 				FROM 					trainer_feedback 			) T 	) t1 	) TF";
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append(
					"<table id='datatable13'>     <thead>         <tr>             <th></th>             <th>Rating</th>         </tr>     </thead>     "
							+ "<tbody>        ");

			for (HashMap<String, Object> item : data) {

				out.append(" <tr>             <th>Rating0</th>             <td>" + (int)item.get("r0")
						+ "</td>         </tr>    " + "     <tr>             <th>Rating1</th>             <td>"
						+ (int)item.get("r1") + "</td>         </tr>  "
						+ "       <tr>             <th>Rating2</th>             <td>" + (int)item.get("r2")
						+ "</td>         </tr>       " + "  <tr>             <th>Rating3</th>             <td>"
						+ (int)item.get("r3") + "</td>         </tr>   "
						+ "     <tr>             <th>Rating4</th>             <td>" + (int)item.get("r4")
						+ "</td>         </tr>     " + "    <tr>             <th>Rating5</th>             <td>"
						+ (int)item.get("r5") + "</td>         </tr>   ");

			}

			out.append("</tbody> </table>");

		//ViksitLogger.logMSG(this.getClass().getName(),"------------->"+out);
			response.getWriter().print(out);

		} else if (request.getParameterMap().containsKey("trainerLevel")) {

			sql = "SELECT 	T1.level1 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5 	) as lvl1, T1.level2 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl2, T1.level3 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl3, T1.level4 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl4, T1.level5 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl5 FROM 	(   SELECT 	COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 1 	) AS level1,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 2 	) AS level2,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 3 	) AS level3,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 4 	) AS level4,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 5 	) AS level5   FROM 	trainer_level_mapping_stats )T1";
			
			
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append(
					"<table id='datatable12'>     <thead>         <tr>             <th></th>             <th>Level</th>         </tr>     </thead>     "
							+ "<tbody>        ");

			for (HashMap<String, Object> item : data) {

				out.append(" <tr>             <th>Level1</th>             <td>"
						+ item.get("lvl1") + "</td>         </tr>  "
						+ "       <tr>             <th>Level2</th>             <td>" + item.get("lvl2")
						+ "</td>         </tr>       " + "  <tr>             <th>Level3</th>             <td>"
						+ item.get("lvl3") + "</td>         </tr>   "
						+ "     <tr>             <th>Level4</th>             <td>" + item.get("lvl4")
						+ "</td>         </tr>     " + "    <tr>             <th>Level5</th>             <td>"
						+ item.get("lvl5") + "</td>         </tr>   ");

			}

			out.append("</tbody> </table>");
			
			response.getWriter().print(out);

		} else if (request.getParameterMap().containsKey("courseID")) {

			if (request.getParameterMap().containsKey("courseID")) {
				courseID = Integer.parseInt(request.getParameter("courseID"));
			}
			if (request.getParameterMap().containsKey("orgID")) {

				orgID = Integer.parseInt(request.getParameter("orgID"));
			}

			sql = "SELECT DISTINCT 	TFinal.cmname, 	TFinal.cmid, 	COALESCE (TFinal.avgduration, 0) AS avgduration, 	COALESCE (TFinal.avgfeedback, 0) AS avgfeedback, 	COALESCE (TFinal.avgattendance, 0) AS avgattendance FROM 	( 		( 			SELECT 				batch_group.college_id AS colid, 				batch.course_id AS cid 			FROM 				batch, 				batch_group 			WHERE 				 batch_group. ID = batch.batch_group_id 			AND batch.course_id = " + courseID 					+ " 		) T0 		LEFT JOIN ( 			SELECT 				T1. NAME AS cmname, 				T1.cmsid AS cmid, 				T1.cid AS cid, 				T1. HOUR * 100 / totcms AS avgduration 			FROM 				( 					SELECT 						cmsession.title AS NAME, 						event_log.cmsession_id AS cmsid, 						event_log.course_id AS cid, 						SUM ( 							batch_schedule_event.eventhour 						) AS HOUR, 						COUNT ( 							event_log.cmsession_id 						) AS totcms 					FROM 						event_log, 						cmsession, 						batch_schedule_event 					WHERE 						cmsession. ID = event_log.cmsession_id 					AND batch_schedule_event. ID = event_log.event_id 					GROUP BY 						cmsession.title, 						event_log.cmsession_id, 						event_log.course_id 					ORDER BY 						event_log.cmsession_id 				) T1 		) T1F ON (T0.cid = T1F.cid) 		LEFT JOIN ( 			SELECT 				T2. NAME, 				T2.cmsid, 				T2.feedback / T2.totfeedback * 5 AS avgfeedback 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_log.cmsession_id AS cmsid, 						SUM (trainer_feedback.rating) AS feedback, 						COUNT ( 							event_log.cmsession_id 						) AS totfeedback 					FROM 						event_log, 						trainer_feedback, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_log.cmsession_id 					AND batch_schedule_event. ID = event_log.event_id 					AND trainer_feedback.event_id = event_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T2 		) T2F ON (T2F.cmsid = T1F.cmid) 		LEFT JOIN ( 			SELECT 				T3. NAME, 				T3.cmsid, 				T3.present * 100 / T3.totattendance AS avgattendance 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_log.cmsession_id AS cmsid, 						COUNT (attendance.status) AS totattendance, 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'PRESENT' 						) AS present 					FROM 						event_log, 						attendance, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_log.cmsession_id 					AND batch_schedule_event. ID = event_log.event_id 					AND attendance.event_id = event_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T3 		) T3F ON (T2F.cmsid = T3F.cmsid) 	) TFinal WHERE 	TFinal.cmname != 'null'";

			if (orgID != 0 && orgID != -3) {

				sql = "SELECT DISTINCT 	TFinal.cmname, 	TFinal.cmid, 	COALESCE (TFinal.avgduration, 0) AS avgduration, 	COALESCE (TFinal.avgfeedback, 0) AS avgfeedback, 	COALESCE (TFinal.avgattendance, 0) AS avgattendance FROM 	( ( 			SELECT 				batch_group.college_id AS colid, 				batch.course_id AS cid 			FROM 				batch, 				batch_group 			WHERE 				batch_group. ID = batch.batch_group_id 			AND batch.course_id = "+courseID+" 			AND batch_group.college_id = "+orgID+" 		)  T0 		LEFT JOIN ( 			SELECT 				T1. NAME AS cmname, 				T1.cmsid AS cmid, 				T1.cid AS cid, 				T1. HOUR * 100 / totcms AS avgduration 			FROM 				( 					SELECT 						cmsession.title AS NAME, 						event_log.cmsession_id AS cmsid, 						event_log.course_id AS cid, 						SUM ( 							batch_schedule_event.eventhour 						) AS HOUR, 						COUNT ( 							event_log.cmsession_id 						) AS totcms 					FROM 						event_log, 						cmsession, 						batch_schedule_event 					WHERE 						cmsession. ID = event_log.cmsession_id 					AND batch_schedule_event. ID = event_log.event_id 					GROUP BY 						cmsession.title, 						event_log.cmsession_id, 						event_log.course_id 					ORDER BY 						event_log.cmsession_id 				) T1 		) T1F ON (T0.cid = T1F.cid) 		LEFT JOIN ( 			SELECT 				T2. NAME, 				T2.cmsid, 				T2.feedback / T2.totfeedback * 5 AS avgfeedback 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_log.cmsession_id AS cmsid, 						SUM (trainer_feedback.rating) AS feedback, 						COUNT ( 							event_log.cmsession_id 						) AS totfeedback 					FROM 						event_log, 						trainer_feedback, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_log.cmsession_id 					AND batch_schedule_event. ID = event_log.event_id 					AND trainer_feedback.event_id = event_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T2 		) T2F ON (T2F.cmsid = T1F.cmid) 		LEFT JOIN ( 			SELECT 				T3. NAME, 				T3.cmsid, 				T3.present * 100 / T3.totattendance AS avgattendance 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_log.cmsession_id AS cmsid, 						COUNT (attendance.status) AS totattendance, 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'PRESENT' 						) AS present 					FROM 						event_log, 						attendance, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_log.cmsession_id 					AND batch_schedule_event. ID = event_log.event_id 					AND attendance.event_id = event_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T3 		) T3F ON (T2F.cmsid = T3F.cmsid) 	) TFinal WHERE 	TFinal.cmname != 'null'";
			}

			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append("<table id='datatable10' style='display:none'>" + "<thead><tr><th></th>");

			out.append("<td>Avg Duration</td>" + "<td>Avg Feedback</td>" + "<td>Avg Attendance</td>"
					+ "</tr></thead><tbody>");

			for (HashMap<String, Object> item : data) {
				out.append("<tr> <th>" + item.get("cmname") + "</th>" + "<td>" + item.get("avgduration") + "</td>"
						+ "<td>" + item.get("avgfeedback") + "</td>" + "<td>" + item.get("avgattendance") + "</td>"
						+ "  </tr>");
			}
			out.append("</tbody></table>");
			//ViksitLogger.logMSG(this.getClass().getName(),"--------------->>>>"+out);
			response.getWriter().print(out);

		}
		else if(request.getParameterMap().containsKey("trainerDetails")){

			String searchTerm = request.getParameter("search[value]");
			boolean searchTermExist = false;

			String limtQuery = "";
			if (searchTerm != null && searchTerm.equalsIgnoreCase("")) {
				searchTermExist = true;

				limtQuery = " limit " + request.getParameter("length") + " offset " + request.getParameter("start");
			}

			String tablesql = "SELECT 	TF.tname, 	TF.joindate, 	TF.temail, 	TF.avgrating, 	COALESCE (TF.LATE_STARTED, 0) AS LATE_STARTED, 	COALESCE (TF.EARLY_ENDED, 0) AS EARLY_ENDED, 	TF.city, 	COALESCE (TF.hours, 0) AS hours, 	COALESCE (TF. MIN, 0) AS MIN, 	TF.tid FROM 	( 		( 			SELECT 				tid, 				joindate, 				tname, 				temail, 				city, 				( 					CASE 					WHEN round( 						AVG (student_feedback.rating) 					) IS NULL THEN 						1 					ELSE 						round( 							AVG (student_feedback.rating) 						) 					END 				) AS avgrating 			FROM 				( 					SELECT 						istar_user. ID AS tid, 						istar_user.created_at AS joindate, 						user_profile.first_name AS tname, 						istar_user.email AS temail, 						pincode.city AS city 					FROM 						address, 						pincode, 						istar_user, 						user_profile, 						user_role 					WHERE 						user_profile.address_id = address. ID 					AND istar_user. ID = user_profile.user_id 					AND address.pincode_id = pincode. ID 					AND user_profile.user_id = user_role.user_id 					AND user_role.role_id in (select id from role where role_name = 'TRAINER')  				) xxx 			LEFT JOIN batch_schedule_event ON ( 				xxx.tid = batch_schedule_event.actor_id 			) 			LEFT JOIN student_feedback ON ( 				student_feedback.trainer_id = xxx.tid 				AND student_feedback.event_id = batch_schedule_event. ID 			) 			GROUP BY 				tid, 				joindate, 				tname, 				temail, 				city 			ORDER BY 				tid 		) T1 		LEFT JOIN ( 			SELECT 				exception_log.trainer_id AS t_id, 				COUNT (*) FILTER (  					WHERE 						exception_log.exception_type = 'LATE_STARTED' 				) AS LATE_STARTED, 				COUNT (*) FILTER (  					WHERE 						exception_log.exception_type = 'EARLY_ENDED' 				) AS EARLY_ENDED 			FROM 				exception_log 			WHERE 				exception_log.exception_component = 'EVENT_DELIVERY' 			GROUP BY 				exception_log.trainer_id 		) T2 ON (T1.tid = T2.t_id) 		LEFT JOIN ( 			SELECT 				batch_schedule_event.actor_id AS tids, 				SUM ( 					batch_schedule_event.eventhour 				) AS hours, 				SUM ( 					batch_schedule_event.eventminute 				) AS MIN 			FROM 				batch_schedule_event 			WHERE 				batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' 			AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT' 			GROUP BY 				actor_id 		) T3 ON (T3.tids = T1.tid) 	) TF ORDER BY "
					+ (Integer.parseInt(request.getParameter("order[0][column]")) + 1) + " "
					+ request.getParameter("order[0][dir]") + limtQuery;

			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(tablesql);

			tablesql = "SELECT 	TF.tname, 	TF.joindate, 	TF.temail, 	TF.avgrating, 	COALESCE (TF.LATE_STARTED, 0) AS LATE_STARTED, 	COALESCE (TF.EARLY_ENDED, 0) AS EARLY_ENDED, 	TF.city, 	COALESCE (TF.hours, 0) AS hours, 	COALESCE (TF. MIN, 0) AS MIN, 	TF.tid FROM 	( 		( 			SELECT 				tid, 				joindate, 				tname, 				temail, 				city, 				( 					CASE 					WHEN round( 						AVG (student_feedback.rating) 					) IS NULL THEN 						1 					ELSE 						round( 							AVG (student_feedback.rating) 						) 					END 				) AS avgrating 			FROM 				( 					SELECT 						istar_user. ID AS tid, 						istar_user.created_at AS joindate, 						user_profile.first_name AS tname, 						istar_user.email AS temail, 						pincode.city AS city 					FROM 						address, 						pincode, 						istar_user, 						user_profile, 						user_role 					WHERE 						user_profile.address_id = address. ID 					AND istar_user. ID = user_profile.user_id 					AND address.pincode_id = pincode. ID 					AND user_profile.user_id = user_role.user_id 					AND user_role.role_id in (select id from role where role_name = 'TRAINER') 				) xxx 			LEFT JOIN batch_schedule_event ON ( 				xxx.tid = batch_schedule_event.actor_id 			) 			LEFT JOIN student_feedback ON ( 				student_feedback.trainer_id = xxx.tid 				AND student_feedback.event_id = batch_schedule_event. ID 			) 			GROUP BY 				tid, 				joindate, 				tname, 				temail, 				city 			ORDER BY 				tid 		) T1 		LEFT JOIN ( 			SELECT 				exception_log.trainer_id AS t_id, 				COUNT (*) FILTER (  					WHERE 						exception_log.exception_type = 'LATE_STARTED' 				) AS LATE_STARTED, 				COUNT (*) FILTER (  					WHERE 						exception_log.exception_type = 'EARLY_ENDED' 				) AS EARLY_ENDED 			FROM 				exception_log 			WHERE 				exception_log.exception_component = 'EVENT_DELIVERY' 			GROUP BY 				exception_log.trainer_id 		) T2 ON (T1.tid = T2.t_id) 		LEFT JOIN ( 			SELECT 				batch_schedule_event.actor_id AS tids, 				SUM ( 					batch_schedule_event.eventhour 				) AS hours, 				SUM ( 					batch_schedule_event.eventminute 				) AS MIN 			FROM 				batch_schedule_event 			WHERE 				batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' 			AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT' 			GROUP BY 				actor_id 		) T3 ON (T3.tids = T1.tid) 	) TF";
			List<HashMap<String, Object>> resultSize = db.executeQuery(tablesql);

			int datasize = (searchTermExist) ? resultSize.size() : 0;

			JSONObject jsonObject = new JSONObject();

			try {
				jsonObject.put("draw", request.getParameter("draw"));
				jsonObject.put("recordsTotal", datasize + "");
				jsonObject.put("recordsFiltered", datasize + "");
				jsonObject.put("iDisplayLength", 10);

				JSONArray array = new JSONArray();
				for (HashMap<String, Object> item : data) {
					if (condition(item, searchTerm) || searchTerm.equalsIgnoreCase("")) {
						JSONArray tableRowsdata = new JSONArray();

						tableRowsdata.put(item.get("tname"));

						tableRowsdata.put(item.get("joindate"));

						tableRowsdata.put(item.get("temail"));

						if (item.get("avgrating") != null && !item.get("avgrating").toString().equalsIgnoreCase("")) {
							tableRowsdata.put(item.get("avgrating"));
						} else {
							tableRowsdata.put("NO Rating");
						}

						tableRowsdata.put((((BigInteger) item.get("late_started")).intValue() % 100));
						tableRowsdata.put((((BigInteger) item.get("early_ended")).intValue() % 100));
						tableRowsdata.put(item.get("city"));
						tableRowsdata.put(item.get("hours") + " hours : " + item.get("min") + " min");
						// tableRowsdata.put("0");

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
		else if(request.getParameterMap().containsKey("accountDetails")){

			String searchTerm = request.getParameter("search[value]");
			boolean searchTermExist = false;

			String limtQuery = "";
			if (searchTerm != null && searchTerm.equalsIgnoreCase("")) {
				searchTermExist = true;

				limtQuery = " limit " + request.getParameter("length") + " offset " + request.getParameter("start");
			}

			String tablesql = "SELECT 	T1.cname, 	T1.summaster / countmaster AS avgmaaster, 	T1.sumwizard / countwizard AS avgwiz, 	T1.sumrookie / countrookie AS avgrooki, 	T1.sumapprentice / countapprentice AS avgapp FROM 	( 		SELECT 			organization. NAME AS cname, 			SUM ( 				mastery_level_per_course.apprentice 			) AS sumapprentice, 			SUM ( 				mastery_level_per_course.rookie 			) AS sumrookie, 			SUM ( 				mastery_level_per_course.master 			) AS summaster, 			SUM ( 				mastery_level_per_course.wizard 			) AS sumwizard, 			COUNT ( 				mastery_level_per_course.apprentice 			) AS countapprentice, 			COUNT ( 				mastery_level_per_course.rookie 			) AS countrookie, 			COUNT ( 				mastery_level_per_course.master 			) AS countmaster, 			COUNT ( 				mastery_level_per_course.wizard 			) AS countwizard 		FROM 			mastery_level_per_course, 			organization 		WHERE 			organization. ID = mastery_level_per_course.college_id 		GROUP BY 			cname 	) T1 ORDER BY "
					+ (Integer.parseInt(request.getParameter("order[0][column]")) + 1) + " "
					+ request.getParameter("order[0][dir]") + limtQuery;

			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(tablesql);

			tablesql = "SELECT 	T1.cname, 	T1.summaster / countmaster AS avgmaaster, 	T1.sumwizard / countwizard AS avgwiz, 	T1.sumrookie / countrookie AS avgrooki, 	T1.sumapprentice / countapprentice AS avgapp FROM 	( 		SELECT 			organization. NAME AS cname, 			SUM ( 				mastery_level_per_course.apprentice 			) AS sumapprentice, 			SUM ( 				mastery_level_per_course.rookie 			) AS sumrookie, 			SUM ( 				mastery_level_per_course.master 			) AS summaster, 			SUM ( 				mastery_level_per_course.wizard 			) AS sumwizard, 			COUNT ( 				mastery_level_per_course.apprentice 			) AS countapprentice, 			COUNT ( 				mastery_level_per_course.rookie 			) AS countrookie, 			COUNT ( 				mastery_level_per_course.master 			) AS countmaster, 			COUNT ( 				mastery_level_per_course.wizard 			) AS countwizard 		FROM 			mastery_level_per_course, 			organization 		WHERE 			organization. ID = mastery_level_per_course.college_id 		GROUP BY 			cname 	) T1";
			List<HashMap<String, Object>> resultSize = db.executeQuery(tablesql);

			int datasize = (searchTermExist) ? resultSize.size() : 0;

			JSONObject jsonObject = new JSONObject();

			try {
				jsonObject.put("draw", request.getParameter("draw"));
				jsonObject.put("recordsTotal", datasize + "");
				jsonObject.put("recordsFiltered", datasize + "");
				jsonObject.put("iDisplayLength", 10);

				JSONArray array = new JSONArray();
				for (HashMap<String, Object> item : data) {
					if (condition(item, searchTerm) || searchTerm.equalsIgnoreCase("")) {
						JSONArray tableRowsdata = new JSONArray();

						tableRowsdata.put(item.get("cname"));
						tableRowsdata.put(item.get("avgmaaster"));

						tableRowsdata.put(item.get("avgwiz"));
						tableRowsdata.put(item.get("avgrooki"));
						tableRowsdata.put(item.get("avgapp"));

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
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}