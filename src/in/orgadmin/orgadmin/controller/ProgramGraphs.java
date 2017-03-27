package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import com.istarindia.apps.dao.DBUTILS;

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

		System.out.println("-----program_graphs------>");
		String sql = "";
		int courseID = 0, orgID = 0;
		StringBuffer out = new StringBuffer();
		
		if (request.getParameterMap().containsKey("account_tab_orgID")) {
			
			orgID = Integer.parseInt(request.getParameter("account_tab_orgID"));
		//	System.out.println("-----program_graphs---1--->");

			UIUtils uiUtils = new UIUtils();

			out.append("<div class='row' style='display: flex;' id='course_event_card' >");
			out.append(uiUtils.getCourseEventCard(orgID));
			out.append("</div>");
			
			out.append("<div class='row 'style='display: flex;' id='batch_event_card' >");
			out.append(uiUtils.getBatchCard(orgID));
			out.append("</div>");	
			
			System.out.println("-----out---1--->"+out);;
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
			System.out.println(out);
			response.getWriter().print(out);
		} else if (request.getParameterMap().containsKey("trainerRating")) {

			sql = "SELECT 	round(TF.r0, 2) AS r0, 	round(TF.r1, 2) AS r1, 	round(TF.r2, 2) AS r2, 	round(TF.r3, 2) AS r3, 	round(TF.r4, 2) AS r4, 	round(TF.r5, 2) AS r5 FROM 	( 		SELECT 			CAST (t1.rating0 * 100 AS DECIMAL) / sumrat AS r0, 			CAST (t1.rating1 * 100 AS DECIMAL) / sumrat AS r1, 			CAST (t1.rating2 * 100 AS DECIMAL) / sumrat AS r2, 			CAST (t1.rating3 * 100 AS DECIMAL) / sumrat AS r3, 			CAST (t1.rating4 * 100 AS DECIMAL) / sumrat AS r4, 			CAST (t1.rating5 * 100 AS DECIMAL) / sumrat AS r5 		FROM 			( 				SELECT 					T .rating0 + T .rating1 + T .rating2 + T .rating3 + T .rating4 + T .rating5 AS sumrat, 					T .* 				FROM 					( 						SELECT 							COUNT (*) FILTER (  								WHERE 									trainer_feedback.rating = 0 							) AS rating0, 							COUNT (*) FILTER (  								WHERE 									trainer_feedback.rating = 1 							) AS rating1, 							COUNT (*) FILTER (  								WHERE 									trainer_feedback.rating = 2 							) AS rating2, 							COUNT (*) FILTER (  								WHERE 									trainer_feedback.rating = 3 							) AS rating3, 							COUNT (*) FILTER (  								WHERE 									trainer_feedback.rating = 4 							) AS rating4, 							COUNT (*) FILTER (  								WHERE 									trainer_feedback.rating = 5 							) AS rating5 						FROM 							trainer_feedback 					) T 			) t1 	) TF ";
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append(
					"<table id='datatable13'>     <thead>         <tr>             <th>ratinghead</th>             <th>Rating</th>         </tr>     </thead>     "
							+ "<tbody>        ");

			for (HashMap<String, Object> item : data) {

				out.append(" <tr>             <th>rating0</th>             <td>" + item.get("r0")
						+ "</td>         </tr>    " + "     <tr>             <th>rating1</th>             <td>"
						+ item.get("r1") + "</td>         </tr>  "
						+ "       <tr>             <th>rating2</th>             <td>" + item.get("r2")
						+ "</td>         </tr>       " + "  <tr>             <th>rating3</th>             <td>"
						+ item.get("r3") + "</td>         </tr>   "
						+ "     <tr>             <th>rating4</th>             <td>" + item.get("r4")
						+ "</td>         </tr>     " + "    <tr>             <th>rating5</th>             <td>"
						+ item.get("r5") + "</td>         </tr>   ");

			}

			out.append("</tbody> </table>");

		
			response.getWriter().print(out);
			//System.out.println(out);

		} else if (request.getParameterMap().containsKey("trainerLevel")) {

			sql = "SELECT 	T1.level1 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5 	) as lvl1, T1.level2 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl2, T1.level3 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl3, T1.level4 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl4, T1.level5 * 100 / (T1.level1 + T1.level2 + T1.level3 + T1.level4 + T1.level5) as lvl5 FROM 	(   SELECT 	COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 1 	) AS level1,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 2 	) AS level2,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 3 	) AS level3,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 4 	) AS level4,  COUNT (*) FILTER (  		WHERE 			trainer_level_mapping_stats.trainer_level = 5 	) AS level5   FROM 	trainer_level_mapping_stats )T1";
			
			
			DBUTILS db = new DBUTILS();
		//	System.out.println("trainerLevel"+sql);
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append(
					"<table id='datatable12'>     <thead>         <tr>             <th>levelhead</th>             <th>Level</th>         </tr>     </thead>     "
							+ "<tbody>        ");

			for (HashMap<String, Object> item : data) {

				out.append(" <tr>             <th>level1</th>             <td>"
						+ item.get("lvl1") + "</td>         </tr>  "
						+ "       <tr>             <th>level2</th>             <td>" + item.get("lvl2")
						+ "</td>         </tr>       " + "  <tr>             <th>level3</th>             <td>"
						+ item.get("lvl3") + "</td>         </tr>   "
						+ "     <tr>             <th>level4</th>             <td>" + item.get("lvl4")
						+ "</td>         </tr>     " + "    <tr>             <th>level5</th>             <td>"
						+ item.get("lvl5") + "</td>         </tr>   ");

			}

			out.append("</tbody> </table>");
			
			response.getWriter().print(out);
		//	System.out.println(out);

		} else if (request.getParameterMap().containsKey("courseID")) {

			if (request.getParameterMap().containsKey("courseID")) {
				courseID = Integer.parseInt(request.getParameter("courseID"));
			}
			if (request.getParameterMap().containsKey("orgID")) {

				orgID = Integer.parseInt(request.getParameter("orgID"));
			}

			sql = "SELECT DISTINCT 	TFinal.cmname, 	TFinal.cmid, 	COALESCE (TFinal.avgduration, 0) AS avgduration, 	COALESCE (TFinal.avgfeedback, 0) AS avgfeedback, 	COALESCE (TFinal.avgattendance, 0) AS avgattendance FROM 	( 		( 			SELECT 				batch_group.college_id AS colid,  				batch.course_id AS cid 			FROM 				batch, 				batch_group 			WHERE 	"
					+ "			batch_group. ID = batch.batch_group_id AND batch.course_id = " + courseID
					+ " 		) T0 		"
					+ "LEFT JOIN ( 			SELECT 				T1. NAME AS cmname, 				T1.cmsid AS cmid,         T1.cid as cid, 				T1. HOUR * 100 / totcms AS avgduration 			FROM 			"
					+ "	( 					SELECT 						cmsession.title AS NAME, 						event_session_log.cmsession_id AS cmsid,            event_session_log.course_id as cid, 						SUM ( 							batch_schedule_event.eventhour 						) AS HOUR, 						COUNT ( 							event_session_log.cmsession_id 						) AS totcms 					FROM 						event_session_log, 						cmsession, 						batch_schedule_event 					WHERE 					 cmsession. ID = event_session_log.cmsession_id 					AND batch_schedule_event. ID = event_session_log.event_id 					GROUP BY 						cmsession.title, 						event_session_log.cmsession_id,event_session_log.course_id 					ORDER BY 						event_session_log.cmsession_id 				) T1 		) T1F ON (T0.cid = T1F.cid) 		LEFT JOIN ( 			SELECT 				T2. NAME, 				T2.cmsid, 				T2.feedback / T2.totfeedback * 5 AS avgfeedback 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_session_log.cmsession_id AS cmsid, 						SUM (trainer_feedback.rating) AS feedback, 						COUNT ( 							event_session_log.cmsession_id 						) AS totfeedback 					FROM 						event_session_log, 						trainer_feedback, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_session_log.cmsession_id 					AND batch_schedule_event. ID = event_session_log.event_id 					AND trainer_feedback.event_id = event_session_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T2 		) T2F ON (T2F.cmsid = T1F.cmid) 		LEFT JOIN ( 			SELECT 				T3. NAME, 				T3.cmsid, 				T3.present * 100 / T3.totattendance AS avgattendance 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_session_log.cmsession_id AS cmsid, 						COUNT (attendance.status) AS totattendance, 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'PRESENT' 						) AS present 					FROM 						event_session_log, 						attendance, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_session_log.cmsession_id 					AND batch_schedule_event. ID = event_session_log.event_id 					AND attendance.event_id = event_session_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T3 		) T3F ON (T2F.cmsid = T3F.cmsid) 	) TFinal WHERE TFinal.cmname != 'null'";

			if (orgID != 0 && orgID != -3) {

				sql = "SELECT DISTINCT 	TFinal.cmname, 	TFinal.cmid, 	COALESCE (TFinal.avgduration, 0) AS avgduration, 	COALESCE (TFinal.avgfeedback, 0) AS avgfeedback, 	COALESCE (TFinal.avgattendance, 0) AS avgattendance FROM 	( 	"
						+ "	( 			SELECT 				batch_group.college_id AS colid, 				batch.course_id AS cid 			FROM 				batch, 				batch_group 			WHERE 				batch_group. ID = batch.batch_group_id 			AND batch.course_id = "
						+ courseID + "       AND batch_group.college_id = " + orgID + " 		)"
						+ " T0 		LEFT JOIN ( 			SELECT 				T1. NAME AS cmname, 				T1.cmsid AS cmid, 				T1.cid AS cid, 				T1. HOUR * 100 / totcms AS avgduration 			FROM 				( 					SELECT 						cmsession.title AS NAME, 						event_session_log.cmsession_id AS cmsid, 						event_session_log.course_id AS cid, 						SUM ( 							batch_schedule_event.eventhour 						) AS HOUR, 						COUNT ( 							event_session_log.cmsession_id 						) AS totcms 					FROM 						event_session_log, 						cmsession, 						batch_schedule_event 					WHERE 						cmsession. ID = event_session_log.cmsession_id 					AND batch_schedule_event. ID = event_session_log.event_id 					GROUP BY 						cmsession.title, 						event_session_log.cmsession_id, 						event_session_log.course_id 					ORDER BY 						event_session_log.cmsession_id 				) T1 		) T1F ON (T0.cid = T1F.cid) 		LEFT JOIN ( 			SELECT 				T2. NAME, 				T2.cmsid, 				T2.feedback / T2.totfeedback * 5 AS avgfeedback 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_session_log.cmsession_id AS cmsid, 						SUM (trainer_feedback.rating) AS feedback, 						COUNT ( 							event_session_log.cmsession_id 						) AS totfeedback 					FROM 						event_session_log, 						trainer_feedback, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_session_log.cmsession_id 					AND batch_schedule_event. ID = event_session_log.event_id 					AND trainer_feedback.event_id = event_session_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T2 		) T2F ON (T2F.cmsid = T1F.cmid) 		LEFT JOIN ( 			SELECT 				T3. NAME, 				T3.cmsid, 				T3.present * 100 / T3.totattendance AS avgattendance 			FROM 				( 					SELECT DISTINCT 						cmsession.title AS NAME, 						event_session_log.cmsession_id AS cmsid, 						COUNT (attendance.status) AS totattendance, 						COUNT (*) FILTER (  							WHERE 								attendance.status = 'PRESENT' 						) AS present 					FROM 						event_session_log, 						attendance, 						batch_schedule_event, 						cmsession 					WHERE 						cmsession. ID = event_session_log.cmsession_id 					AND batch_schedule_event. ID = event_session_log.event_id 					AND attendance.event_id = event_session_log.event_id 					GROUP BY 						NAME, 						cmsid 				) T3 		) T3F ON (T2F.cmsid = T3F.cmsid) 	) TFinal WHERE 	TFinal.cmname != 'null'";
			}

			//System.out.println("----------->" + sql);
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append("<table id='datatable10' style='display:none'>" + "<thead><tr><th></th>");

			out.append("<td>avgduration</td>" + "<td>avgfeedback</td>" + "<td>avgattendance</td>"
					+ "</tr></thead><tbody>");

			for (HashMap<String, Object> item : data) {
				out.append("<tr> <th>" + item.get("cmname") + "</th>" + "<td>" + item.get("avgduration") + "</td>"
						+ "<td>" + item.get("avgfeedback") + "</td>" + "<td>" + item.get("avgattendance") + "</td>"
						+ "  </tr>");
			}
			out.append("</tbody></table>");
			response.getWriter().print(out);

		}
		else if(request.getParameterMap().containsKey("trainerDetails")){
			
			String tablesql = "SELECT 	TF.tid, 	TF.joindate, 	TF.tname, 	TF.temail, 	TF.city, 	TF.avgrating, 	COALESCE (TF.hours, 0) AS hours, 	COALESCE (TF. MIN, 0) AS MIN, 	COALESCE (TF.EARLY_ENDED, 0) AS EARLY_ENDED, 	COALESCE (TF.LATE_STARTED, 0) AS LATE_STARTED FROM 	( 		( 			select  tid, joindate, tname, temail, city, (case when round(AVG(student_feedback.rating)) is null then 1 else round(AVG(student_feedback.rating)) end)   AS avgrating from (select student. ID AS tid, 				student.created_at AS joindate, 				student. NAME AS tname, 				student.email AS temail, 				pincode.city AS city   from address, pincode, student where student.address_id = address. ID 			AND address.pincode_id = pincode. ID 			AND student.user_type = 'TRAINER' )xxx left join batch_schedule_event on (xxx.tid = batch_schedule_event.actor_id) left join student_feedback on (student_feedback.trainer_id= xxx.tid and student_feedback.event_id = batch_schedule_event.id) GROUP BY 				tid, joindate, 				tname, 				temail, 				city 			ORDER BY 				tid 		) T1 		LEFT JOIN ( 			SELECT 				exception_log.trainer_id AS t_id, 				COUNT (*) FILTER (  					WHERE 						exception_log.exception_type = 'LATE_STARTED' 				) AS LATE_STARTED,  				COUNT (*) FILTER (  					WHERE 						exception_log.exception_type = 'EARLY_ENDED' 				) AS EARLY_ENDED 			FROM 				exception_log 			WHERE 				exception_log.exception_component = 'EVENT_DELIVERY' 			GROUP BY 				exception_log.trainer_id 		) T2 ON (T1.tid = T2.t_id) 		LEFT JOIN ( 			SELECT 				batch_schedule_event.actor_id AS tids, 				SUM ( 					batch_schedule_event.eventhour 				) AS hours, 				SUM ( 					batch_schedule_event.eventminute 				) AS MIN 			FROM 				batch_schedule_event 			WHERE 				batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' 			AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT' 			GROUP BY 				actor_id 		) T3 ON (T3.tids = T1.tid) 	) TF ";
		
		
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(tablesql);

	

			for (HashMap<String, Object> item : data) {
				out.append(""
						+ "<tr><td>"+item.get("tname")+"</td>"
						+ "<td>"+item.get("joindate")+"</td>"
						+ "<td>"+item.get("temail")+"</td>"
						+ "<td>"+item.get("avgrating")+"</td>"
						 + "<td>"+(((BigInteger)item.get("late_started")).intValue()%100)+"</td>"
						 + "<td>"+(((BigInteger)item.get("early_ended")).intValue()%100)+"</td>"
						+ "<td>"+item.get("city")+"</td>"
						+ "<td>"+item.get("hours")+" hours : "+item.get("min")+" min</td>"
						+ "<td>0</td></tr>"
						+ "");
			}
			
			response.getWriter().print(out);
		
		
		
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}