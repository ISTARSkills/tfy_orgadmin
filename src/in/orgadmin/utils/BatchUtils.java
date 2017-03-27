/**
 * 
 */
package in.orgadmin.utils;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.hibernate.Query;

import com.istarindia.apps.dao.Attendance;
import com.istarindia.apps.dao.AttendanceDAO;
import com.istarindia.apps.dao.Batch;
import com.istarindia.apps.dao.BatchDAO;
import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.BatchScheduleEvent;
import com.istarindia.apps.dao.BatchScheduleEventDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.TrainerBatch;

/**
 * @author Mayank
 *
 */
public class BatchUtils {

	public List<HashMap<String, Object>> getEventPerBatch(Batch b) {
		String sql = "SELECT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	bse.batch_id AS batch_id, 	s. ID AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	student s, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	college org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID and B.id ="
				+ b.getId()
				+ " AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate 			";
		DBUTILS utilss = new DBUTILS();
		List<HashMap<String, Object>> res = utilss.executeQuery(sql);
		return res;
	}

	private StringBuffer getModalAssessment(String lesson_title, Batch b, String assess_id, String date, Timestamp d) {
		DBUTILS util = new DBUTILS();
		// System.out.println(d);

		String sql = "SELECT DISTINCT 	T3.ass_id, 	T3.lesson_title, 	T3.eventdate, 	T3.event_id, 	"
				+ "T3.stu_id, 	T3. NAME, 	T3.email, 	R.score FROM 	( 		SELECT DISTINCT 			T2.ass_id, 			T2.lesson_title, 			IAE.eventdate, 			CAST (IAE. ID AS VARCHAR(50)) AS event_id, 			T1.stu_id, 			T1. NAME, 			T1.email 		FROM 			istar_assessment_event IAE, 			( 				SELECT 					S. ID AS stu_id, 					S. NAME, 					S.email 				FROM 					batch B, 					batch_group BG, 					batch_students BS, 					student S 				WHERE 					B.batch_group_id = BG. ID 				AND BG. ID = BS.batch_group_id 				AND BS.student_id = S. ID 				AND B. ID = "
				+ b.getId()
				+ " 			) T1, 			( 				SELECT 					assessment. ID AS ass_id, 					lesson.title AS lesson_title 				FROM 					lesson, 					cmsession, 					MODULE, 					course, 					assessment, 					batch 				WHERE 					lesson.session_id = cmsession. ID 				AND cmsession.module_id = MODULE . ID 				AND course. ID = MODULE .course_id 				AND batch.course_id = course. ID 				AND batch. ID = "
				+ b.getId()
				+ " 				AND lesson.dtype = 'ASSESSMENT' 				AND assessment.lesson_id = lesson. ID 			) T2 		WHERE 			IAE.actor_id = T1.stu_id 		AND T2.ass_id = IAE.assessment_id 	) T3 LEFT OUTER JOIN report R ON ( 	R.user_id = T3.stu_id 	AND R.assessment_id = T3.ass_id ) where  cast (T3.eventdate as varchar(50)) like '%"
				+ d.toString().split(" ")[0] + "%' and T3.ass_id = " + assess_id + "";
		// System.out.println(sql);
		StringBuffer sb = new StringBuffer();
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("<div id='modal-assess_" + assess_id + date.split(" ")[0] + date.split(" ")[1]
				+ "' class='modal fade' aria-hidden='true'>										"
				+ "        <div class='modal-dialog'>                                                                "
				+ "            <div class='modal-content'>                                                           "
				+ "                <div class='modal-body'>                                                          "
				+ "                    <div class='row'>                                                             "
				+ "                        <div class='col-sm-12 b-r'><h3 class='m-t-none m-b'>Assessment Report for Assessment: "
				+ lesson_title + " at Date: " + date + " </h3>           ");

		sb.append("<div class='table-responsive'>                                                      "
				+ "<table class='table table-striped table-bordered table-hover dataTables-example' >  "
				+ "<thead>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th>Email</th>                                                                "
				+ "    <th>Score</th>                                                            "

				+ "</tr>                                                                               "
				+ "</thead>                                                                             ");

		for (HashMap<String, Object> row : data) {

			int id = (int) row.get("stu_id");
			String name = (String) row.get("name");
			String email = (String) row.get("email");
			int score = 0;
			if (row.get("score") != null) {
				score = (int) row.get("score");
			}

			sb.append("<tbody>                                                                             "
					+ "<tr  style='font-size: 11px;'>                                                                 "
					+ "    <td>" + id + "</td>                                                                "
					+ "    <td>" + name + "</td>  " + "    <td>" + email
					+ "</td>                                                                " + "    <td>" + score
					+ "</td>                                                                "
					+ "</tr>                                                                               "
					+ "                                                                                    "
					+ "</tbody>                                                                            " + "");

		}

		sb.append("<tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th>Email</th>                                                                "
				+ "    <th>Score</th>                                                            "

				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                                                            "
				+ "    </div>                                                                          "
				+ "                                                                                    " + "</div> "
				+ "");
		sb.append("                        </div>                                                                    "
				+ "                </div>                                                                            "
				+ "            </div>                                                                                "
				+ "            </div>                                                                                "
				+ "        </div>                                                                                    "
				+ "</div>");
		return sb;

	}

	public StringBuffer getAssessmentReportForBatch(Batch b) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "SELECT DISTINCT 	sum(T3.total_questions) as total, 	T3.ass_id, 	T3.lesson_title, 	T3.eventdate, 	sum(R.score) as score_obtained FROM 	( 		SELECT DISTINCT 			T2.total_questions, 			T2.ass_id, 			T2.lesson_title, 			IAE.eventdate, 			CAST (IAE. ID AS VARCHAR(50)) AS event_id, 			T1.stu_id, 			T1. NAME, 			T1.email 		FROM 			istar_assessment_event IAE, 			( 				SELECT 					S. ID AS stu_id, 					S. NAME, 					S.email 				FROM 					batch B, 					batch_group BG, 					batch_students BS, 					student S 				WHERE 					B.batch_group_id = BG. ID 				AND BG. ID = BS.batch_group_id 				AND BS.student_id = S. ID 				AND B. ID = "
				+ b.getId()
				+ " 			) T1, 			( 				SELECT 					assessment. ID AS ass_id, 					lesson.title AS lesson_title, 					( 						SELECT 							COUNT (*) 						FROM 							assessment_question 						WHERE 							assessmentid = assessment. ID 					) AS total_questions 				FROM 					lesson, 					cmsession, 					MODULE, 					course, 					assessment, 					batch 				WHERE 					lesson.session_id = cmsession. ID 				AND cmsession.module_id = MODULE . ID 				AND course. ID = MODULE .course_id 				AND batch.course_id = course. ID 				AND batch. ID = "
				+ b.getId()
				+ " 				AND lesson.dtype = 'ASSESSMENT' 				AND assessment.lesson_id = lesson. ID 			) T2 		WHERE 			IAE.actor_id = T1.stu_id 		AND T2.ass_id = IAE.assessment_id 	) T3 LEFT OUTER JOIN report R ON ( 	R.user_id = T3.stu_id 	AND R.assessment_id = T3.ass_id ) group by T3.ass_id,T3.ass_id, 	T3.lesson_title, 	T3.eventdate ORDER BY 	T3.eventdate DESC";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		try {

			sb.append("<div class='table-responsive' >                                                      "
					+ "<table class='table table-striped table-bordered table-hover dataTables-example' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px; text-transform: uppercase;'>                                                                                "
					+ "    <th>Event Date</th>                                                       "
					+ "    <th>Assessment ID</th>                                                                "
					+ "    <th>Title</th>                                                              "
					+ "    <th>Average</th>                                                            "
					+ "    <th>Details</th>                                                              "
					+ "</tr>                                                                               "
					+ "</thead>                                                                             ");
			sb.append("<tfoot>                                                                             "
					+ "<tr style='font-size: 11px; text-transform: uppercase;'>                                                                                "
					+ "    <th>Event Date</th>                                                       "
					+ "    <th>Assessment ID</th>                                                                "
					+ "    <th>Title</th>                                                              "
					+ "    <th>Average</th>                                                            "
					+ "    <th>Details</th>                                                              "

					+ "</tr>                                                                               "
					+ "</tfoot>                                                                            ");
			for (HashMap<String, Object> row : data) {
				Timestamp event_date = (Timestamp) row.get("eventdate");
				// 2016-07-25 12:20:00
				SimpleDateFormat from = new SimpleDateFormat("yyyy-MM-dd hH:mm:ss");
				SimpleDateFormat to = new SimpleDateFormat("dd MMM yyyy HH:mm");
				String date = to.format(from.parse(event_date.toString()));
				String lesson_title = (String) row.get("lesson_title");
				int ass_id = (int) row.get("ass_id");
				BigDecimal total = (BigDecimal) row.get("total");
				// System.out.println("total+++++"+total.intValue());
				BigInteger score_obtained = (BigInteger) row.get("score_obtained");
				// System.out.println("score_obtained+++++"+score_obtained.intValue());
				double average = ((score_obtained.intValue() * 100) / (total.intValue()));
				// DecimalFormat f = new DecimalFormat("##.00");
				sb.append("<tbody>                                                                             "
						+ "<tr  style='font-size: 11px;'>                                                                 "
						+ "    <td>" + date + "</td>                                                                "
						+ "    <td>" + ass_id
						+ "    </td>                                                                           "
						+ "    <td>" + lesson_title + "</td>                                                       "
						+ "    <td>" + average + "</td>  " + "    <td class='center'>"
						+ "<a data-toggle='modal' class='btn btn-primary btn-xs' href='#modal-assess_" + ass_id
						+ date.split(" ")[0] + date.split(" ")[1] + "'>Details</a>"
						+ getModalAssessment(lesson_title, b, ass_id + "", date, event_date) + "</td>"
						+ "</tr>                                                                               "
						+ "                                                                                    "
						+ "</tbody>                                                                            " + "");

			}
			sb.append("</table>                                                                            "
					+ "    </div>                                                                          "
					+ "                                                                                    " + "</div> "
					+ "");

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sb;
	}

	public StringBuffer getFeedbackByTrainerForBatch(Batch b) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "SELECT DISTINCT 	cast(trainer_feedback.event_id as varchar(50)), batch_schedule_event.eventdate, student.name,"
				+ " 	rating, 	noise, 	attendance, 	sick, 	CONTENT, 	ASSIGNMENT, 	internals, 	electricity, 	"
				+ "TIME, 	internet, 	comments FROM 	trainer_feedback, batch_schedule_event, student WHERE student.id = batch_schedule_event.actor_id and trainer_feedback.event_id = batch_schedule_event.id and 	trainer_feedback.batch_id = "
				+ b.getId() + " order by batch_schedule_event.eventdate desc ;";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		try {

			sb.append("<div class='table-responsive' >                                                      "
					+ "<table class='table table-striped table-bordered table-hover dataTables-example' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px; text-transform: uppercase;'>                                                                                "
					+ "    <th>Event Date</th>                                                       "
					+ "    <th>Trainer</th>                                                                "
					+ "    <th>comments</th>                                                              "
					+ "    <th>rating</th>                                                            "
					+ "    <th>noise</th>                                                         "
					+ "    <th>attendance</th>                                                            "
					+ "    <th>sick</th>                                                         "
					+ "    <th>CONTENT</th>                                                            "
					+ "    <th>ASSIGNMENT</th>                                                         "
					+ "    <th>internals</th>                                                            "
					+ "    <th>electricity</th>                                                         "
					+ "    <th>TIME</th>                                                            "
					+ "    <th>internet</th>                                                         "

					+ "</tr>                                                                               "
					+ "</thead>                                                                             ");
			sb.append("<tfoot>                                                                             "
					+ "<tr style='font-size: 11px; text-transform: uppercase;'>                                                                                "
					+ "    <th>Event Date</th>                                                       "
					+ "    <th>Trainer</th>                                                                "
					+ "    <th>comments</th>                                                              "
					+ "    <th>rating</th>                                                            "
					+ "    <th>noise</th>                                                         "
					+ "    <th>attendance</th>                                                            "
					+ "    <th>sick</th>                                                         "
					+ "    <th>CONTENT</th>                                                            "
					+ "    <th>ASSIGNMENT</th>                                                         "
					+ "    <th>internals</th>                                                            "
					+ "    <th>electricity</th>                                                         "
					+ "    <th>TIME</th>                                                            "
					+ "    <th>internet</th>                                                         "

					+ "</tr>                                                                               "
					+ "</tfoot>                                                                            ");
			for (HashMap<String, Object> row : data) {
				Timestamp event_date = (Timestamp) row.get("eventdate");
				// 2016-07-25 12:20:00
				SimpleDateFormat from = new SimpleDateFormat("yyyy-MM-dd hH:mm:ss");
				SimpleDateFormat to = new SimpleDateFormat("dd MMM yyyy HH:mm");
				String date = to.format(from.parse(event_date.toString()));
				String name = (String) row.get("name");
				int rating = (int) row.get("rating");
				String noise = "fa-thumbs-o-up";
				String attendance = "fa-thumbs-o-up";
				String sick = "fa-thumbs-o-up";
				String CONTENT = "fa-thumbs-o-up";
				String ASSIGNMENT = "fa-thumbs-o-up";
				String internals = "fa-thumbs-o-up";
				String electricity = "fa-thumbs-o-up";
				String TIME = "fa-thumbs-o-up";
				String internet = "fa-thumbs-o-up";
				String comments = (String) row.get("comments");
				if ((boolean) (row.get("noise"))) {
					noise = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("attendance"))) {
					attendance = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("sick"))) {
					sick = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("content"))) {
					CONTENT = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("assignment"))) {
					ASSIGNMENT = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("internals"))) {
					internals = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("electricity"))) {
					electricity = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("time"))) {
					TIME = "fa-thumbs-o-down";
				}
				if ((boolean) (row.get("internet"))) {
					internet = "fa-thumbs-o-down";
				}

				sb.append("<tbody>                                                                             "
						+ "<tr  style='font-size: 11px;'>                                                                 "
						+ "    <td>" + date + "</td>                                                                "
						+ "    <td>" + name
						+ "    </td>                                                                           "
						+ "    <td>" + comments + "</td>                                                       "
						+ "    <td>" + rating + "</td>                                                                "
						+ "    <td><i class='fa " + noise
						+ "'></i></td>                                                       " + "    <td><i class='fa "
						+ attendance + "'></i></td>                                                       "
						+ "    <td><i class='fa " + sick
						+ "'></i></td>                                                       " + "    <td><i class='fa "
						+ CONTENT + "'></i></td>                                                       "
						+ "    <td><i class='fa " + ASSIGNMENT
						+ "'></i></td>                                                       " + "    <td><i class='fa "
						+ internals + "'></i></td>                                                       "
						+ "    <td><i class='fa " + electricity
						+ "'></i></td>                                                       " + "    <td><i class='fa "
						+ TIME + "'></i></td>                                                       "
						+ "    <td><i class='fa " + internet
						+ "'></i></td>                                                       "

						+ "</tr>                                                                               "
						+ "                                                                                    "
						+ "</tbody>                                                                            " + "");

			}
			sb.append("</table>                                                                            "
					+ "    </div>                                                                          "
					+ "                                                                                    " + "</div> "
					+ "");

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sb;
	}

	public StringBuffer getDetailedAttendencePerEvent(String event_id) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "SELECT  	attendance.status, 	student.NAME AS student_name FROM 	batch_schedule_event, 	attendance, 	student WHERE 	cast(batch_schedule_event.ID as varchar(50)) like '"
				+ event_id
				+ "' AND attendance.user_id = student. ID AND batch_schedule_event. ID = attendance.event_id ";
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("                                                                                          "
				+ "<table class='footable table table-stripped toggle-arrow-tiny' data-page-size='15'>       "
				+ "<thead>                                                                                   "
				+ "<tr style='    font-size: 11px;'>                                                                                      "
				+ "    <th data-toggle='true'>Student</th>                                            	    "
				+ "    <th data-toggle='true'>Attendance</th>                                                "
				+ "</tr>                                                                                     "
				+ "</thead> ");

		for (HashMap<String, Object> row : data) {
			/*
			 * Timestamp event_date = (Timestamp) row.get("eventdate"); //
			 * 2016-07-25 12:20:00 SimpleDateFormat from = new SimpleDateFormat(
			 * "yyyy-MM-dd hH:mm:ss"); SimpleDateFormat to = new
			 * SimpleDateFormat("dd MMM yyyy HH:mm"); String date =
			 * to.format(from.parse(event_date.toString()));
			 */

			String name = (String) row.get("student_name");
			String status = (String) row.get("status");

			sb.append("<tbody>                                                                                   "
					+ "<tr style='    font-size: 11px;'>                                                                                      "
					+ "    <td>                                                                                  "
					+ name
					+ "    </td>                                                                                 "
					+ "    <td>                                                                                  "
					+ status
					+ "    </td>                                                                                 "
					+ "</tr>                                                                                     "
					+ "</tbody>                                                                                  "

			);

		}

		sb.append("<tfoot>                                                                                   "
				+ "<tr style='    font-size: 11px;'>                                                                                      "
				+ "    <td colspan='6'>                                                                      "
				+ "        <ul class='pagination pull-right'></ul>                                           "
				+ "    </td>                                                                                 "
				+ "</tr>                                                                                     "
				+ "</tfoot>                                                                                  "
				+ "</table>                                                                                  ");

		return sb;
	}

	public StringBuffer getAttendenceForBatch(Batch b) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "select  cast(batch_schedule_event.id as varchar(50)), batch_schedule_event.eventdate, student.name, count(*) filter (where attendance.status ='PRESENT') as present, count(*) filter (where attendance.status ='ABSENT') as absent  from batch_schedule_event left join attendance on (attendance.event_id = batch_schedule_event.id) left join student on (student.id = batch_schedule_event.actor_id) where batch_schedule_event.batch_id="
				+ b.getId()
				+ " AND batch_schedule_event. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER'  AND batch_schedule_event.event_name LIKE '%REAL EVENT%' GROUP BY batch_schedule_event.id, batch_schedule_event.eventdate, student.name order by batch_schedule_event.eventdate desc";

		System.err.println(sql);
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		try {

			sb.append(getColumnChartForAttendance(b));

			sb.append("<div class='table-responsive' id='555555'>                                                      "
					+ "<table class='table table-striped table-bordered table-hover dataTables-example' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px;'>                                                                                "
					+ "    <th>Event Date</th>                                                       "
					+ "    <th>Trainer</th>                                                                "
					+ "    <th>Absent</th>                                                            "
					+ "    <th>Present</th>                                                         "
					+ "    <th>Details</th>                                                              "
					+ "</tr>                                                                               "
					+ "</thead>                                                                             ");
			sb.append("<tfoot>                                                                             "
					+ "<tr style='font-size: 11px;'>                                                                                "
					+ "    <th>Event Date</th>                                                       "
					+ "    <th>Trainer</th>                                                                "
					+ "    <th>Absent</th>                                                            "
					+ "    <th>Present</th>                                                         "
					+ "    <th>Details</th>                                                              "
					+ "</tr>                                                                               "
					+ "</tfoot>                                                                            ");
			for (HashMap<String, Object> row : data) {
				Timestamp event_date = (Timestamp) row.get("eventdate");
				// 2016-07-25 12:20:00
				SimpleDateFormat from = new SimpleDateFormat("yyyy-MM-dd hH:mm:ss");
				SimpleDateFormat to = new SimpleDateFormat("dd MMM yyyy HH:mm");
				String date = to.format(from.parse(event_date.toString()));

				String event_id = (String) row.get("id");
				String name = (String) row.get("name");
				BigInteger present = (BigInteger) row.get("present");
				BigInteger absent = (BigInteger) row.get("absent");

				sb.append("<tbody>                                                                             "
						+ "<tr  style='font-size: 11px;'>                                                                 "
						+ "    <td>" + date + "</td>                                                                "
						+ "    <td>" + name
						+ "    </td>                                                                           "
						+ "    <td>" + absent + "</td>                                                                "
						+ "    <td class='center'>" + present
						+ "</td>                                                       "
						+ "    <td class='center'><a data-toggle='modal' class='btn btn-primary btn-xs' href='#modal-form_"
						+ event_id + "'>Details</a>" + getModalForAttendance(event_id, date).toString()
						+ "</td>                                                       "
						+ "</tr>                                                                               "
						+ "                                                                                    "
						+ "</tbody>                                                                            " + "");

			}
			sb.append("</table>                                                                            "
					+ "    </div>                                                                          "
					+ "                                                                                    " + "</div> "
					+ "");

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sb;
	}

	private Object getColumnChartForAttendance(Batch b) {
		StringBuffer sb = new StringBuffer();
		sb.append("<div id='container' style='min-width: 310px; height: 400px; margin: 0 auto'></div>");
		return sb;
	}

	private StringBuffer getModalForAttendance(String event_id, String date) {
		DBUTILS util = new DBUTILS();
		String sql = "SELECT attendance.status, student. ID as student_id, student.name as name FROM batch_schedule_event, attendance, student WHERE  attendance.user_id = student. ID AND batch_schedule_event. ID = attendance.event_id and batch_schedule_event.id = '"
				+ event_id + "'";
		StringBuffer sb = new StringBuffer();
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("<div id='modal-form_" + event_id
				+ "' class='modal fade' aria-hidden='true'>										"
				+ "        <div class='modal-dialog'>                                                                "
				+ "            <div class='modal-content'>                                                           "
				+ "                <div class='modal-body'>                                                          "
				+ "                    <div class='row'>                                                             "
				+ "                        <div class='col-sm-12 b-r'><h3 class='m-t-none m-b'>Attendance for Date: "
				+ date + " </h3>           ");

		sb.append("<div class='table-responsive'>                                                      "
				+ "<table class='table table-striped table-bordered table-hover dataTables-example' >  "
				+ "<thead>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th># Status</th>                                                            "

				+ "</tr>                                                                               "
				+ "</thead>                                                                             ");

		for (HashMap<String, Object> row : data) {

			int id = (int) row.get("student_id");
			String name = (String) row.get("name");
			String status = (String) row.get("status");

			sb.append("<tbody>                                                                             "
					+ "<tr  style='font-size: 11px;'>                                                                 "
					+ "    <td>" + id + "</td>                                                                "
					+ "    <td>" + name + "</td>  " + "    <td>" + status
					+ "</td>                                                                "
					+ "</tr>                                                                               "
					+ "                                                                                    "
					+ "</tbody>                                                                            " + "");

		}

		sb.append("<tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th>Status</th>                                                            "

				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                                                            "
				+ "    </div>                                                                          "
				+ "                                                                                    " + "</div> "
				+ "");
		sb.append("                        </div>                                                                    "
				+ "                </div>                                                                            "
				+ "            </div>                                                                                "
				+ "            </div>                                                                                "
				+ "        </div>                                                                                    "
				+ "</div>");
		return sb;

	}
	
	public StringBuffer PrintBatchAttendanceList(Batch b, String baseURL) {
		StringBuffer sb = new StringBuffer();
		
		IstarUserDAO dao = new IstarUserDAO();
		String hql = "SELECT distinct 	cast (batch_schedule_event.id as varchar(50)), event_name, to_char(eventdate,'DD-MM-YYYY HH:mm:ss') as eventdate, "
				+ "student.id as s_id FROM 	batch_schedule_event, student WHERE 	batch_id = "+b.getId()+" and student.id = batch_schedule_event.actor_id"
				+ " AND event_name NOT LIKE '%TEST%' AND TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER'";

		
		System.out.println("------Attendance-------->"+ hql);
		
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(hql);

		
		for (HashMap<String, Object> row : data) {
			
			BatchScheduleEvent bse = new BatchScheduleEventDAO().findById(UUID.fromString(row.get("id").toString()));
			
			Student s = new StudentDAO().findById(Integer.parseInt(row.get("s_id").toString()));
			
			sb.append(" <tr>"

					+ "<td class='project-title'>" + "<h4><b> Trainer: </b> " +s.getName()  + "</h4></br></br><h4> Event Name: " + bse.getEventName() + "</h4>"
					+ " <br/>"
					+ " <small class='event_id'> Event ID: " + bse.getId()
					+ "</small>" + "  </td>"
					+ " <td><h4>Events Date: " + bse.getEventdate()
					+ "</h4><td>"                                       
					+ " </td>" + "<td class='project-people'>");

			sb.append("</td>" + " <td class='project-actions'>" + "<a href='" + baseURL
					+ "orgadmin/batch/attendance_per_event.jsp?bse_id=" + bse.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
					
					+ "  </td>" + "</tr>");
		}

		return sb;
	}
	
	public StringBuffer PrintEventStudentAttendanceList(BatchScheduleEvent bse, String baseURL) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "SELECT 	    T1.ID AS stu_id, 			T1.NAME as name,       T1.email as email,       T1.user_type as user_type,             CASE      When attendance.status is null then 'ABSENT'      ELSE attendance.status       END AS status  FROM 	( 		SELECT 			student. ID , 			student. NAME,       student.email,       student.user_type 		FROM 			batch_schedule_event, 			batch, 			batch_group, 			batch_students, 			student 		WHERE 			batch_schedule_event.batch_id = batch. ID 		AND batch_group. ID = batch.batch_group_id 		AND batch_students.student_id = student. ID 		AND batch_students.batch_group_id = batch_group. ID 		AND batch_schedule_event. ID = '"+bse.getId()+"' 	) T1 LEFT JOIN attendance ON ( 	attendance.user_id = T1. ID   	AND attendance.event_id = '"+bse.getId()+"')";
		
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("<div class='table-responsive'>			  " + "<table class='table table-striped'>         "
				+ "    <thead>                                 " + "    <tr style='font-size:13px'>             "
				+ "                                            " + "        <th>ID </th>                        "
				+ "        <th>Student</th>                    " + "        <th>Email</th>                    "
				+ "		<th>User Type</th>                         " + "        <th>Attendance</th>                 "
				+ "    </tr>                                   " + "    </thead>");

		for (HashMap<String, Object> row : data) {
			int id = (int) row.get("stu_id");
			String name = (String) row.get("name");
			String email = (String) row.get("email");
			String user_type = (String) row.get("user_type");
			String check_status = "";
			if (row.get("status").equals("PRESENT")) {
				check_status = "checked";
				
			}
			sb.append("    <tbody>                                 " + "    <tr style='font-size:13px'>             "
					+ "                                            " + "        <td>" + id
					+ "</td>                           " + "		<td>" + name + "</td>                             "
					+ "		<td>" + email + "</td>                             " + "		<td>" + user_type
					+ "</td>                             " + "        <td><input type='checkbox' " + check_status
					+ " class='i-checks' id='student_ids' value='" + id  +"'name='student_ids' ></td> "
					+ "    </tr>                                   " + "                                            "
					+ "    </tbody>                                ");

		}

		sb.append("<tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "        <th>ID </th>                        " + "        <th>Student</th>                    "
				+ "        <th>Email</th>                    " + "		<th>Task</th>                         "
				+ "        <th>Add/Remove</th>                 "
				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                    " + "</div>                                      ");

		return sb;
	}
	
	public List<HashMap<String, Object>> getEventPerBatchTrainer(Batch b , Student s) {
		
		
		String sql = "SELECT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, "
				+ "	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	"
				+ "bse.batch_id AS batch_id, 	s. ID AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	student s, "
				+ "	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	college org "
				+ "WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID "
				+ "AND BG.college_id = org. ID AND bse.actor_id = s. ID AND B. ID = "+b.getId()+" AND s.ID = "+s.getId()+" AND s.user_type = 'TRAINER' "
				+ "AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate";
		DBUTILS utilss = new DBUTILS();
		List<HashMap<String, Object>> res = utilss.executeQuery(sql);
		return res;
	}
}
