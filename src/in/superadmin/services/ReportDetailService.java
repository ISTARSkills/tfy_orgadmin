package in.superadmin.services;

import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

public class ReportDetailService {
	DBUTILS dbutils = new DBUTILS();

	public List<HashMap<String, Object>> getAllSessions(int batch_id, int offset, boolean flag) {

		String sql = "SELECT 	CAST ( 		event_log.event_id AS VARCHAR 	), 	event_log.cmsession_id, 	cmsession.title, 	bse.eventdate FROM 	event_log, 	cmsession, 	batch_schedule_event bse WHERE 	event_id IN ( 		SELECT 			ID 		FROM 			batch_schedule_event 		WHERE 			batch_id = "
				+ batch_id
				+ " 	) AND event_log.cmsession_id = cmsession. ID AND bse. ID = event_log.event_id GROUP BY 	event_log.event_id, 	event_log.cmsession_id, 	cmsession.title, 	bse.eventdate ORDER BY 	bse.eventdate DESC LIMIT 3 OFFSET "
				+ offset;

		if (flag) {
			sql = "SELECT 	CAST ( 		event_log.event_id AS VARCHAR 	), 	event_log.cmsession_id, 	cmsession.title, 	bse.eventdate FROM 	event_log, 	cmsession, 	batch_schedule_event bse WHERE 	event_id IN ( 		SELECT 			ID 		FROM 			batch_schedule_event 		WHERE 			batch_id = "
					+ batch_id
					+ " 	) AND event_log.cmsession_id = cmsession. ID AND bse. ID = event_log.event_id GROUP BY 	event_log.event_id, 	event_log.cmsession_id, 	cmsession.title, 	bse.eventdate ORDER BY 	bse.eventdate DESC";
		}
		System.err.println(sql);
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		return items;
	}

	public List<HashMap<String, Object>> getAllAssessments(int batch_id, int offset, boolean flag) {
		String sql = "SELECT 	ass. ID as assessment_id, 	asse.batch_id, 	ass.assessmenttitle, 	asse.eventdate FROM 	istar_assessment_event asse, 	assessment ass WHERE 	asse.batch_id = "
				+ batch_id
				+ " AND ass. ID = asse.assessment_id GROUP BY 	ass. ID, 	asse.batch_id, 	asse.eventdate ORDER BY 	asse.eventdate DESC LIMIT 3 OFFSET "
				+ offset;

		if (flag) {
			sql = "SELECT 	ass. ID, 	asse.batch_id, 	ass.assessmenttitle, 	asse.eventdate FROM 	istar_assessment_event asse, 	assessment ass WHERE 	asse.batch_id = "
					+ batch_id
					+ " AND ass. ID = asse.assessment_id GROUP BY 	ass. ID, 	asse.batch_id, 	asse.eventdate ORDER BY 	asse.eventdate DESC";
		}

		System.err.println(sql);
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		return items;
	}

	public List<HashMap<String, Object>> getAllStudents(int batch_id) {
		String sql = "SELECT DISTINCT 	s. ID AS student_id, 	sp.first_name AS NAME, 	s.email, 	CASE WHEN sp.profile_image LIKE 'null' OR sp.profile_image IS NULL THEN 	'http://api.talentify.in/video/android_images/' || UPPER (SUBSTRING(sp.first_name FROM 1 FOR 1)) || '.png' ELSE 	'http://api.talentify.in/' || sp.profile_image END AS profile_image FROM 	batch b, 	batch_students bs, 	batch_group bg, 	istar_user s, 	user_profile sp WHERE 	bs.student_id = s. ID AND bg. ID = b.batch_group_id AND bg. ID = bs.batch_group_id AND sp.user_id = s. ID AND b. ID = "
				+ batch_id + " ORDER BY 	sp.first_name";

		// System.err.println(sql);
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		return items;

	}

	public List<HashMap<String, Object>> getAllQuestions(int assessment_id) {
		String sql = "SELECT DISTINCT 	q. ID, 	q.comprehensive_passage_text, 	q.question_text FROM 	assessment ass, 	assessment_question asq, 	question q WHERE 	asq.assessmentid = ass. ID AND q. ID = asq.questionid AND ass. ID ="
				+ assessment_id;

		// System.err.println(sql);
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		return items;
	}

	public StringBuffer getAllOptions(int question_id, int user_id, int assessment_id) {
		String sql = "select * from assessment_option where question_id=" + question_id;

		// System.err.println(sql);
		List<HashMap<String, Object>> questionItem = dbutils.executeQuery(sql);

		sql = "select * from student_assessment where question_id=" + question_id + " and assessment_id="
				+ assessment_id + " and student_id=" + user_id;
		List<HashMap<String, Object>> optionItem = dbutils.executeQuery(sql);

		String userChoice = "";
		if (optionItem != null && optionItem.size() > 0) {
			if ((boolean) optionItem.get(0).get("correct")) {
				userChoice = "<span class='badge badge-success pull-right m-r-sm'>Correct</span>";
			} else {
				userChoice = "<span class='badge badge badge-danger pull-right m-r-sm'>Incorrect</span>";
			}
		} else {
			userChoice = "<span class='badge pull-right m-r-sm'>Skipped</span>";
		}

		StringBuffer out = new StringBuffer();
		out.append(userChoice);
		for (HashMap<String, Object> item : questionItem) {
			String selectedString = "";
			if (item.get("marking_scheme").toString().equalsIgnoreCase("1")) {
				selectedString = "checked";
			}
			out.append("<div class='radio m-l-lg'><input type='radio' name='radio" + item.get("question_id")
					+ "' id='radio" + item.get("id") + "' value='" + item.get("id") + "' " + selectedString
					+ " disabled> <label style='padding-left: 3px;' for='radio" + item.get("id") + "'>"
					+ item.get("text") + "</label></div>");
		}
		return out;
	}

}
