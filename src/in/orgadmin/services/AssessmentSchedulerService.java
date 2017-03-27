package in.orgadmin.services;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Map.Entry;

import com.istarindia.apps.dao.Assessment;
import com.istarindia.apps.dao.AssessmentDAO;
import com.istarindia.apps.dao.Batch;
import com.istarindia.apps.dao.BatchDAO;
import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.BatchGroupDAO;
import com.istarindia.apps.dao.BatchStudents;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.Course;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.OrgAdmin;

public class AssessmentSchedulerService {

	DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	DateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
	static DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdf1 = new SimpleDateFormat("HH:mm a");
	Date FinaleventDate = null;

	public void createAssessment(int trainerID, int batch_id, int assessment_id, String event_date, String time,
			int AdminUserID, int classroomID, String associateTrainerID) {

		System.out.println("inside Assessment");

		DBUTILS util = new DBUTILS();
		StringBuffer out = new StringBuffer();
		UUID parent_id = UUID.randomUUID();
		Assessment assessment = new AssessmentDAO().findById(assessment_id);
		Batch batch = new BatchDAO().findById(batch_id);
		Course c = batch.getCourse();

		String title_new = "Event: Assessment Scheduled on " + event_date + " " + time;
		String details_new = "" + c.getCourseName() + ": at " + time;

		String sql = "SELECT 	actor_id FROM 	istar_assessment_event   WHERE 	assessment_id = " + assessment_id
				+ " AND cast (eventdate as varchar (50)) LIKE '%" + event_date + "%'";

		List<HashMap<String, Object>> data = util.executeQuery(sql);
		System.out.println("--chk----------------------->" + sql);
		ArrayList<Integer> alreadyAssigned = new ArrayList<>();
		if (data.size() != 0) {
			for (HashMap<String, Object> row : data) {
				int actor_id = (int) row.get("actor_id");
				if (!alreadyAssigned.contains(actor_id)) {
					alreadyAssigned.add(actor_id);
				}
			}
		} else {

			createAssessmentEntryInBse(trainerID, 0, 0, batch_id, event_date, AdminUserID, classroomID, assessment_id,
					associateTrainerID);
		}

		for (BatchStudents bstudent : batch.getBatchGroup().getBatchStudentses()) {
			System.out.println(bstudent.getStudent().getId());
			if (alreadyAssigned != null && !alreadyAssigned.contains(bstudent.getStudent().getId())) {

				String sql1 = "WITH ins2 AS ( 	INSERT INTO istar_assessment_event ( 	actor_id, 	created_at, 	creator_id, 	eventdate, 	eventhour, 	eventminute, 	isactive, 	TYPE, 	updated_at, 	task_id, 	status, 	ACTION, 	assessment_id, 	parent_id, 	batch_id ) "
						+ "VALUES 	( 		" + bstudent.getStudent().getId() + ", 		now(), 		" + AdminUserID
						+ ", 		'" + event_date + "', 		'0', 		"
						+ assessment.getAssessmentdurationminutes()
						+ ", 		't', 		'ASSESSMENT_EVENT', 		now(), 		( 			SELECT 				ID 			FROM 				istar_task_type 			WHERE 				TYPE LIKE '%ASSESSMENT_TASK%' 		), 		'SCHEDULED', 		NULL, 		"
						+ assessment_id + ", 		'" + parent_id + "', 		" + batch_id + " 	)RETURNING ID )	"
						+ "INSERT INTO istar_notification ( 		event_id, 		sender_id, 		receiver_id, 		title, 		details, 		status, 		ACTION, 		TYPE, 		is_event_based, 		created_at 	) SELECT 		ins2. ID, 		"
						+ bstudent.getStudent().getId() + ", 		" + bstudent.getStudent().getId() + ", 		'"
						+ title_new + "', 		'" + details_new
						+ "', 		'UNREAD', 		'NONE', 		'ASSESSMENT_EVENT', 		't', 		now() 	FROM 		ins2 ; ";

				System.out.println(sql1);
				util.executeUpdate(sql1);
			} /*
				 * else {
				 * 
				 * String sql1 =
				 * "WITH ins2 AS ( 	INSERT INTO istar_assessment_event ( 	actor_id, 	created_at, 	creator_id, 	eventdate, 	eventhour, 	eventminute, 	isactive, 	TYPE, 	updated_at, 	task_id, 	status, 	ACTION, 	assessment_id, 	parent_id, 	batch_id ) "
				 * + "VALUES 	( 		" + bstudent.getStudent().getId() +
				 * ", 		now(), 		" + AdminUserID + ", 		'" +
				 * event_date + "', 		'0', 		" +
				 * assessment.getAssessmentdurationminutes() +
				 * ", 		't', 		'ASSESSMENT_EVENT', 		now(), 		( 			SELECT 				ID 			FROM 				istar_task_type 			WHERE 				TYPE LIKE '%ASSESSMENT_TASK%' 		), 		'SCHEDULED', 		NULL, 		"
				 * + assessment_id + ", 		'" + parent_id + "', 		" +
				 * batch_id + " 	)RETURNING ID )	" +
				 * "INSERT INTO istar_notification ( 		event_id, 		sender_id, 		receiver_id, 		title, 		details, 		status, 		ACTION, 		TYPE, 		is_event_based, 		created_at 	) SELECT 		ins2. ID, 		"
				 * + bstudent.getStudent().getId() + ", 		" +
				 * bstudent.getStudent().getId() + ", 		'" + title_new +
				 * "', 		'" + details_new +
				 * "', 		'UNREAD', 		'NONE', 		'ASSESSMENT_EVENT', 		't', 		now() 	FROM 		ins2 ; "
				 * ;
				 * 
				 * System.out.println(sql1); util.executeUpdate(sql1);
				 * 
				 * }
				 */

		}

	}

	public void createAssessmentNewEntryInBG(int batchGrpId) {

		BatchGroup batchGroup = new BatchGroupDAO().findById(batchGrpId);
		int batch_group_code = Integer.parseInt(batchGroup.getBatchCode());

		System.out.println("---> createAssessmentNewEntryInBG");

		String sql = "SELECT cmsession_id,batch_id,creator_id,CAST(eventdate as VARCHAR)as event_date FROM batch_schedule_event WHERE batch_group_code ="
				+ batch_group_code;

		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		if (data.size() != 0) {
			for (HashMap<String, Object> item : data) {

				int assessment_id = (int) item.get("cmsession_id");
				int batch_id = (int) item.get("batch_id");
				int AdminUserID = (int) item.get("creator_id");
				String event_date = (String) item.get("event_date");

				String eveDate = null;
				String time = null;
				try {
					time = sdf1.format(formatter1.parse(event_date));
					eveDate = sdf2.format(formatter1.parse(event_date));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				UUID parent_id = UUID.randomUUID();
				Assessment assessment = new AssessmentDAO().findById(assessment_id);
				Batch batch = new BatchDAO().findById(batch_id);
				Course c = batch.getCourse();

				String title_new = "Event: Assessment Scheduled on " + eveDate + " " + time;
				String details_new = "" + c.getCourseName() + ": at " + time;

				String sql1 = "SELECT 	actor_id FROM 	istar_assessment_event   WHERE 	assessment_id = "
						+ assessment_id + " AND  eventdate = '" + event_date.toString() + "'";

				List<HashMap<String, Object>> data1 = util.executeQuery(sql1);
				ArrayList<Integer> alreadyAssigned = new ArrayList<>();
				if (data1.size() != 0) {
					for (HashMap<String, Object> row : data1) {
						int actor_id = (int) row.get("actor_id");
						if (!alreadyAssigned.contains(actor_id)) {
							alreadyAssigned.add(actor_id);
						}
					}
				}

				for (BatchStudents bstudent : batch.getBatchGroup().getBatchStudentses()) {
					System.out.println(bstudent.getStudent().getId());
					if (alreadyAssigned != null && !alreadyAssigned.contains(bstudent.getStudent().getId())) {

						String sql2 = "WITH ins2 AS ( 	INSERT INTO istar_assessment_event ( 	actor_id, 	created_at, 	creator_id, 	eventdate, 	eventhour, 	eventminute, 	isactive, 	TYPE, 	updated_at, 	task_id, 	status, 	ACTION, 	assessment_id, 	parent_id, 	batch_id ) "
								+ "VALUES 	( 		" + bstudent.getStudent().getId() + ", 		now(), 		"
								+ AdminUserID + ", 		'" + event_date + "', 		'0', 		"
								+ assessment.getAssessmentdurationminutes()
								+ ", 		't', 		'ASSESSMENT_EVENT', 		now(), 		( 			SELECT 				ID 			FROM 				istar_task_type 			WHERE 				TYPE LIKE '%ASSESSMENT_TASK%' 		), 		'SCHEDULED', 		NULL, 		"
								+ assessment_id + ", 		'" + parent_id + "', 		" + batch_id
								+ " 	)RETURNING ID )	"
								+ "INSERT INTO istar_notification ( 		event_id, 		sender_id, 		receiver_id, 		title, 		details, 		status, 		ACTION, 		TYPE, 		is_event_based, 		created_at 	) SELECT 		ins2. ID, 		"
								+ bstudent.getStudent().getId() + ", 		" + bstudent.getStudent().getId()
								+ ", 		'" + title_new + "', 		'" + details_new
								+ "', 		'UNREAD', 		'NONE', 		'ASSESSMENT_EVENT', 		't', 		now() 	FROM 		ins2 ; ";

						System.out.println(sql2);
						util.executeUpdate(sql2);
					}

				}
			}
		}
	}

	public void createAssessmentEntryInBse(int trainerID, int hours, int minute, int batchID, String eventDate,
			int AdminUserID, int classroomID, int assessment_id, String associateTrainerID) {

		Batch b = new BatchDAO().findById(batchID);
		College org = b.getBatchGroup().getCollege();
		String batchCode = b.getBatchGroup().getBatchCode();
		System.out.println("batchCode" + batchCode);
		Course c = b.getCourse();
		String evnetName = "ASSESSMENT EVENT FOR CLASS-" + org.getName() + "-Ilab-" + c.getCourseName();

		String sql = "INSERT INTO batch_schedule_event ( 	actor_id, 	created_at, 	creator_id, 	eventdate, 	eventhour, 	eventminute, 	isactive, 	type, 	updated_at, 	 	task_id, 	status, 	action, 	cmsession_id, 	batch_id, 	event_name, 	classroom_id, 	associate_trainee, 	batch_group_code ) "
				+ "VALUES 	( 		" + trainerID + ", 		now(), 		" + AdminUserID + ", 		'" + eventDate
				+ "', 		'2', 		'0', 		't', 		'ASSESSMENT_EVENT_TRAINER', 		now(), 				NULL, 		'ASSESSMENT', 		'assessment_id__"
				+ assessment_id + "', 		" + assessment_id + ", 		" + batchID + ", 		'" + evnetName
				+ "', 		" + classroomID + ", 		'" + associateTrainerID + "', 		" + batchCode + " 	); ";
		DBUTILS db = new DBUTILS();
		db.executeUpdate(sql);
		System.out.println("---------------sql----------->" + sql);
	}

	public void deleteAssessment(HashMap<String, String> assessmentData) {

		int batchId = Integer.parseInt(assessmentData.get("batchId"));
		int assessmentID = Integer.parseInt(assessmentData.get("assessmentID"));
		String eventDate = assessmentData.get("eventDate");

		eventDate = eventDate.substring(0, eventDate.length() - 2);

		String deletesql1 = "DELETE FROM istar_assessment_event WHERE eventdate = '" + eventDate + "' AND batch_id = "
				+ batchId + " AND assessment_id =" + assessmentID;
		DBUTILS db = new DBUTILS();
		db.executeUpdate(deletesql1);
	}

	public void insertDeleteData(int trainerID, int assessmentID, int batchID, int AdminUserID, String eventDate,
			String startTime, int classroomID, String associateTrainerID) {

		try {
			FinaleventDate = formatter.parse(dateformatto.format(dateformatfrom.parse(eventDate)) + " " + startTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		createAssessment(trainerID, batchID, assessmentID, formatter.format(FinaleventDate).toString(), startTime,
				AdminUserID, classroomID, associateTrainerID);

	}

	public StringBuffer singleAssessmentEvent(int trainerID, String eventType, int batchId, int assessmentID,
			String eventDate, String time, int AdminUserID, int classroomID, String associateTrainerID) {
		String qeventDate = "";
		String qdate = "";
		int orgID = 0;
		IstarUserDAO dao = new IstarUserDAO();
		IstarUser user = new IstarUser();
		if (AdminUserID != 0 && AdminUserID != 300) {

			user = dao.findById(AdminUserID);
			OrgAdmin admin = (OrgAdmin) user;
			orgID = admin.getCollege().getId();
		}
		boolean isCreated = false;
		Batch batch = new BatchDAO().findById(batchId);
		Course c = batch.getCourse();
		String courseName = c.getCourseName();
		StringBuffer out = new StringBuffer();

		HashMap<String, String> hashMap = new HashMap<>();
		hashMap.put("batchID", batchId + "");
		hashMap.put("AdminUserID", AdminUserID + "");
		hashMap.put("eventType", eventType);
		hashMap.put("eventDate", eventDate);
		hashMap.put("startTime", time);
		hashMap.put("tabType", "singleEvent");
		hashMap.put("assessmentID", assessmentID + "");
		hashMap.put("trainerID", trainerID + "");
		hashMap.put("classroomID", classroomID + "");
		hashMap.put("associateTrainerID", associateTrainerID);

		try {
			FinaleventDate = formatter.parse(dateformatto.format(dateformatfrom.parse(eventDate)) + " " + time);
			qeventDate = formatter.format(FinaleventDate).toString();
			qdate = dateformatto.format(dateformatfrom.parse(eventDate));
		} catch (ParseException e) {
			e.printStackTrace();
		}

		ArrayList<String> datacheck = eventValidation(batchId, qeventDate);

		if (datacheck.size() > 0) {
			isCreated = true;
			out.append(createDiv(hashMap, isCreated));
		} else {
			out.append(createDiv(hashMap, isCreated));
		}

		out.append(getEventDetails(orgID, qdate, datacheck));

		return out;
	}

	public ArrayList<String> eventValidation(int batchId, String eventDate) {

		ArrayList<String> arrayList = new ArrayList<>();
		DBUTILS util = new DBUTILS();

		String sql = "SELECT DISTINCT assessment_id FROM 	istar_assessment_event WHERE 	batch_id = " + batchId
				+ " AND CAST (eventdate AS VARCHAR(50)) LIKE '%" + eventDate + "%' ";

		List<HashMap<String, Object>> data = util.executeQuery(sql);
		System.out.println(sql);
		if (data.size() != 0) {
			for (HashMap<String, Object> row : data) {
				int assessment_id = (int) row.get("assessment_id");
				if (!arrayList.contains(assessment_id)) {
					arrayList.add(assessment_id + "");
				}
			}

		}
		return arrayList;
	}

	public StringBuffer createDiv(HashMap<String, String> data, boolean isCreated) {
		System.out.println("creatediv");
		StringBuffer out = new StringBuffer();
		String assessmentData = "";

		assessmentData = "{";
		for (Entry<String, String> value : data.entrySet()) {

			assessmentData += "\"" + value.getKey() + "\" : \"" + value.getValue() + "\",";
		}

		assessmentData = assessmentData.substring(0, assessmentData.length() - 1);

		assessmentData += "}";
		UUID id = UUID.randomUUID();

		out.append("<div class='col-lg-4 new_schedule' id='new_schedule_parent_" + id + "' data-assessment_data='"
				+ assessmentData + "'>" + "<div class='panel panel-primary'> <div class='panel-body'>"
				+ "<h3>New-Assessment</h3>" + "<p>Course: " + data.get("courseName") + ".</p>"

				+ "<hr>" + "<p class=''><i class='fa fa-calendar'> Date: " + data.get("eventDate") + "</i>"
				+ "<i class='fa fa-clock-o pull-right '> Time: " + data.get("startTime") + "</i> </p> </div> "
				+ "<div class='panel-heading text-center'> 	"
				+ "<button ' class='btn btn-block btn-outline btn-default assessment-card' id='" + id
				+ "' type='button'></button>"

				+ " </div> " + "</div> </div>");

		out.append("");
		return out;

	}

	public StringBuffer getEventDetails(int orgId, String qdate, ArrayList<String> datacheck) {

		System.out.println("eventdetails");
		StringBuffer out = new StringBuffer();
		String sql = "SELECT DISTINCT 	istar_assessment_event.eventdate as evdate, 	istar_assessment_event.assessment_id AS assessment_id , 	istar_assessment_event.batch_id as bid FROM 	istar_assessment_event, 	batch, 	batch_group WHERE 	batch.batch_group_id = batch_group. ID AND batch_group.college_id = "
				+ orgId + " AND CAST (eventdate AS VARCHAR(50)) LIKE '%" + qdate + "%'";

		DBUTILS db = new DBUTILS();
		System.out.println(sql);
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {

			String evdate = null;
			String evetime = null;
			int batchId = (int) item.get("bid");
			Batch batch = new BatchDAO().findById(batchId);
			Course c = batch.getCourse();
			String courseName = c.getCourseName();

			try {
				evdate = sdf2.format(formatter1.parse(item.get("evdate").toString()));
				evetime = sdf1.format(formatter1.parse(item.get("evdate").toString()));
			} catch (ParseException e) {
				e.printStackTrace();
			}

			if (datacheck != null && datacheck.contains(item.get("assessment_id").toString())) {

				out.append("<div class='col-lg-4'>" + "<div class='panel panel-warning'>");

			} else {

				out.append("<div class='col-lg-4'>" + "<div class='panel panel-success'>");
			}

			out.append("<div class='panel-body'>" + "<h3>Existing Assessment</h3>" + "<p>Course: " + courseName
					+ ".</p>" + "<hr>" + "<p><i class='fa fa-calendar'> Date: " + evdate + "</i>"
					+ "<i class='fa fa-clock-o pull-right'> Time: " + evetime + "</i> </p> </div> "
					+ "<div class='panel-heading text-center'> 	" + "<button id='batchId_" + item.get("bid")
					+ ",assessmentID_" + item.get("assessment_id") + ",eventDate_" + item.get("evdate") + ""
					+ "' class='btn btn-block btn-outline btn-default deleteAssessment-modal' type='button'> "
					+ "<i class='fa fa-plus'></i>&nbsp;&nbsp;Delete Assessment </button> </div> " + "</div> </div>");

		}
		out.append("");
		return out;
	}

}
