package in.orgadmin.admin.services;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.UUID;

import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchDAO;
import com.viksitpro.core.dao.entities.BatchStudents;
import com.viksitpro.core.dao.entities.BatchStudentsDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.utilities.DBUTILS;
import org.apache.commons.lang3.time.DateUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class EventSchedulerService {

	DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	DateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
	static DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdf1 = new SimpleDateFormat("HH:mm a");
	Date FinaleventDate = null;

	public void createEvent(int trainerID, int hours, int minute, int batchID, String eventDate, String startTime,
			int AdminUserID, int classroomID, int cmsessionID, String associateTrainerID) {
		String action = "cmsession_id__" + cmsessionID;
		Batch b = new BatchDAO().findById(batchID);
		Organization org = b.getBatchGroup().getOrganization();
		Course c = b.getCourse();
		if (cmsessionID == -1) {
			cmsessionID = -1;
			action = "cmsession_id__-1";
		}

		String evnetName = "REAL EVENT FOR CLASS-" + org.getName() + "-Ilab-" + c.getCourseName();

		String title_new = "Event: Scheduled on " + eventDate;
		String details_new = "" + c.getCourseName() + ": at " + eventDate;

		DBUTILS db = new DBUTILS();

		String ssql = "SELECT count(*) as tcount FROM trainer_batch WHERE trainer_id= " + trainerID + " AND batch_id ="
				+ batchID;

		List<HashMap<String, Object>> data = db.executeQuery(ssql);

		if (Integer.parseInt(data.get(0).get("tcount").toString()) == 0) {

			String trainerBatchSql = "INSERT INTO trainer_batch ( 	id, 	batch_id, 	trainer_id ) VALUES 	((SELECT COALESCE (MAX(ID) + 1, 1) 	FROM 	trainer_batch ) , "
					+ batchID + ", " + trainerID + ");";

			db.executeUpdate(trainerBatchSql);
			System.out.println("trainerBatchSql-----> "+trainerBatchSql);

		}

		String sql = "WITH ins1 AS ( 	INSERT INTO event_queue (ID, event_name, batch_id) 	VALUES 		( 			( 				SELECT 					COALESCE (MAX(ID) + 1, 1) 				FROM 					event_queue 			), 			'event_queue_' || "
				+ batchID + ", 			" + batchID
				+ " 		) RETURNING ID ),  ins2 AS ( 	INSERT INTO batch_schedule_event ( 		actor_id, 		created_at, 		creator_id, 		eventdate, 		eventhour, 		eventminute, 		isactive, 		TYPE, 		updated_at, 		ID, 		status, 		ACTION, 		cmsession_id, 		batch_id, 		event_name, 		classroom_id, 		associate_trainee, 		batch_group_code 	) 	VALUES 		( 			"
				+ trainerID + ", 			now(), 			" + AdminUserID + ", 			'" + eventDate
				+ "', 			" + hours + ", 			" + minute
				+ ", 			't', 			'BATCH_SCHEDULE_EVENT_TRAINER', 			now(), 			( 				SELECT 					COALESCE (MAX(ID) + 1, 1) 				FROM 					batch_schedule_event 			), 			'SCHEDULED', 			'"
				+ action + "', 			" + cmsessionID + ", 			" + batchID + ", 			'" + evnetName
				+ "', 			" + classroomID + ", 			'" + associateTrainerID
				+ "', 			NULL 		) RETURNING ID ),  ins3 AS ( 	INSERT INTO batch_schedule_event ( 		actor_id, 		created_at, 		creator_id, 		eventdate, 		eventhour, 		eventminute, 		isactive, 		TYPE, 		updated_at, 		ID, 		status, 		ACTION, 		cmsession_id, 		batch_id, 		event_name, 		classroom_id, 		associate_trainee, 		batch_group_code 	) 	VALUES 		( 			( 				SELECT 					presentor_id 				FROM 					trainer_presentor 				WHERE 					trainer_id = "
				+ trainerID + " 			), 			now(), 			" + AdminUserID + ", 			'" + eventDate
				+ "', 			" + hours + ", 			" + minute
				+ ", 			't', 			'BATCH_SCHEDULE_EVENT_PRESENTOR', 			now(), 			( 				SELECT 					COALESCE (MAX(ID) + 2, 1) 				FROM 					batch_schedule_event 			), 			'SCHEDULED', 			'"
				+ action + "', 			" + cmsessionID + ", 			" + batchID + ", 			'" + evnetName
				+ "', 			" + classroomID + ", 			'0', 			NULL 		) RETURNING ID ),  ins4 AS ( 	INSERT INTO event_queue_event_mapping ( 		ID, 		event_queue_id, 		event_for, 		user_id, 		event_id, 		created_at, 		updated_at 	) SELECT 		( 			SELECT 				COALESCE (MAX(ID) + 1, 1) 			FROM 				event_queue_event_mapping 		), 		ins1. ID, 		'Trainer Event: "
				+ evnetName + "', 		" + trainerID
				+ ", 		ins2. ID, 		now(), 		now() 	FROM 		ins2, 		ins1 ),  ins5 AS ( 	INSERT INTO event_queue_event_mapping ( 		ID, 		event_queue_id, 		event_for, 		user_id, 		event_id, 		created_at, 		updated_at 	) SELECT 		( 			SELECT 				COALESCE (MAX(ID) + 2, 1) 			FROM 				event_queue_event_mapping 		), 		ins1. ID, 		'Presenter Event: "
				+ evnetName
				+ "', 		( 			SELECT 				presentor_id 			FROM 				trainer_presentor 			WHERE 				trainer_id = "
				+ trainerID
				+ " 		), 		ins3. ID, 		now(), 		now() 	FROM 		ins3, 		ins1 ),  ins6 AS ( 	INSERT INTO task ( 		ID, 		NAME, 		task_type, 		priority, 		OWNER, 		actor, 		STATE, 		start_date, 		end_date, 		is_repeatative, 		is_active, 		created_at, 		updated_at, 		item_id, 		item_type 	) SELECT 		( 			SELECT 				COALESCE (MAX(ID), 0) + 1 			FROM 				task 		), 		'CLASSROOM EVENT TASK', 		2, 		1, 		"
				+ AdminUserID + ", 		" + trainerID + ", 		'SCHEDULED', 		" + " CAST ('" + eventDate
				+ "' AS TIMESTAMP), 		CAST ( 			'(" + eventDate
				+ ")' AS TIMESTAMP 		) + INTERVAL '1' MINUTE * (" + hours + " * 60 + " + minute
				+ "), 		'f', 		't', 		now(), 		now(), 		ins2. ID, 		'CLASSROOM_SESSION' 	FROM 		ins2 RETURNING ID ),ins7 AS ( INSERT INTO istar_notification ( 	ID, 	sender_id, 	receiver_id, 	title, 	details, 	status, 	ACTION, 	TYPE, 	is_event_based, 	created_at, 	task_id ) SELECT 	( 		SELECT 			COALESCE (MAX(ID) + 1, 1) 		FROM 			istar_notification 	), 	"
				+ AdminUserID + ", 	'" + trainerID + "', 	'" + title_new + "', 	'" + details_new
				+ "', 	'UNREAD', 	NULL, 	'BATCH_SCHEDULE_EVENT_TRAINER', 	't', 	now(), 	ins6. ID FROM 	ins6 ) SELECT 	ID FROM 	ins2";
	
		System.out.println("sql-----> "+sql);
		int bseTrainerID = db.executeUpdateReturn(sql);
		

		createTaskStudent(batchID, eventDate, hours, minute, bseTrainerID, title_new, details_new, AdminUserID);

	}

	public void createTaskStudent(int batchID, String eventDate, int hours, int minute, int eventID, String title_new,
			String details_new, int AdminUserID) {

		String sql = "SELECT actor FROM task WHERE  item_id = " + eventID + " AND item_type = 'CLASSROOM_SESSION' ";

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		ArrayList<Integer> alreadyAssigned = new ArrayList<>();

		if (data.size() != 0) {
			for (HashMap<String, Object> row : data) {
				int actor_id = (int) row.get("actor");
				if (!alreadyAssigned.contains(actor_id)) {
					alreadyAssigned.add(actor_id);
				}
			}
		}

		Batch batch = new Batch();
		BatchDAO batchDAO = new BatchDAO();

		batch = batchDAO.findById(batchID);

		for (BatchStudents bstudent : batch.getBatchGroup().getBatchStudentses()) {
			if (alreadyAssigned != null && !alreadyAssigned.contains(bstudent.getIstarUser().getId())) {

				String insertIntoTask = "INSERT INTO task (id, name,  task_type, priority, owner, actor, state, start_date, end_date, "
						+ "   is_repeatative,  is_active,  created_at, updated_at, item_id, item_type  " + ") VALUES "
						+ "((select COALESCE(max(id),0)+1 from task), 'CLASSROOM EVENT TASK', 2, 1, 300, "
						+ bstudent.getIstarUser().getId() + ", 'SCHEDULED'," + " cast('" + eventDate
						+ "' as timestamp), cast('(" + eventDate + ")'as timestamp) + interval '1' minute * (" + hours
						+ "*60+" + minute + "),    'f',  't', now(), now(), " + "" + eventID
						+ ",'CLASSROOM_SESSION' ) RETURNING ID;";

				System.out.println("sql-----> "+insertIntoTask);
				int taskID = db.executeUpdateReturn(insertIntoTask);

				String notificationsql = "INSERT INTO istar_notification ( 	id, 	sender_id, 	receiver_id, 	title, 	details, 	status, 	ACTION, 	TYPE, 	is_event_based, 	created_at, 	task_id ) VALUES 	( 		(SELECT COALESCE (MAX(ID) + 1, 1) 	FROM 	istar_notification), 		"
						+ AdminUserID + ", 		'" + bstudent.getIstarUser().getId() + "', 		'" + title_new
						+ "', 		'" + details_new
						+ "', 		'UNREAD', 		NULL, 		'BATCH_SCHEDULE_EVENT_TRAINER', 		't', 		now(), 		"
						+ taskID + " 	);";

				System.out.println("sql-----> "+notificationsql);
				db.executeUpdate(notificationsql);

			}

		}

	}

	public void deleteEvent(String eventID) {

		DBUTILS db = new DBUTILS();

		String delete_notification_sql = "DELETE FROM istar_notification WHERE  task_id in (select id FROM task WHERE  item_id = "
				+ eventID + " AND item_type = 'CLASSROOM_SESSION' );";
		db.executeUpdate(delete_notification_sql);

		String delete_task_sql = "DELETE FROM task WHERE  item_id = " + eventID
				+ " AND item_type = 'CLASSROOM_SESSION' ";
		db.executeUpdate(delete_task_sql);

		String sql = "SELECT 	event_queue_event_mapping.event_queue_id AS event_queue_id,event_queue_event_mapping.event_id AS eventid FROM 	event_queue_event_mapping WHERE 	event_queue_id IN ( 		SELECT 			event_queue_id 		FROM 			event_queue_event_mapping 		WHERE 			event_id = "
				+ eventID + " 	)";
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		String deletesql4 = "DELETE FROM event_queue WHERE id = '" + data.get(0).get("event_queue_id") + "'";
		db.executeUpdate(deletesql4);

		for (HashMap<String, Object> item : data) {
			String deletesql3 = "DELETE FROM batch_schedule_event WHERE id = '" + item.get("eventid") + "'";
			String deletesql2 = "DELETE FROM event_queue_event_mapping WHERE event_id = '" + item.get("eventid") + "'";
			db.executeUpdate(deletesql3);
			db.executeUpdate(deletesql2);

		}

	}

	public void updateEvent(String eventID, int trainerID, int hours, int minute, int batchID, String eventDate,
			String startTime, int AdminUserID, int classroomID, int sessionID, String associateTrainerID) {

		deleteEvent(eventID);

		createEvent(trainerID, hours, minute, batchID, eventDate, startTime, AdminUserID, classroomID, sessionID,
				associateTrainerID);

	}

	// for fullCalendar
	public void editEvent(String eventID, String eventDate, String startTime) {

		try {
			FinaleventDate = formatter.parse(dateformatto.format(dateformatfrom.parse(eventDate)) + " " + startTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		int trainerID = 0;
		int hours = 0;
		int minute = 0;
		int batchID = 0;
		int AdminUserID = 0;
		int classroomID = 0;
		int cmsessionID = -1;
		String associateTrainerID = null;
		String editsql = "SELECT associate_trainee,actor_id,creator_id,eventhour,eventminute,cmsession_id,batch_id,classroom_id FROM batch_schedule_event WHERE id = '"
				+ eventID + "'";

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(editsql);

		for (HashMap<String, Object> item : data) {

			trainerID = (int) item.get("actor_id");
			hours = (int) item.get("eventhour");
			minute = (int) item.get("eventminute");
			batchID = (int) item.get("batch_id");
			AdminUserID = (int) item.get("creator_id");
			classroomID = (int) item.get("classroom_id");
			cmsessionID = (int) item.get("cmsession_id");
			associateTrainerID = (String) item.get("associate_trainee");

		}

		ArrayList<String> datacheck = eventValidation(hours, minute, startTime, eventDate, classroomID, batchID + "",
				trainerID);
		if (datacheck.size() > 0) {

		} else {

			deleteEvent(eventID);

			createEvent(trainerID, hours, minute, batchID, FinaleventDate.toString(), startTime, AdminUserID,
					classroomID, cmsessionID, associateTrainerID);
		}

	}

	/*
	 * public ArrayList<Integer> getDuration(String startTime, String endTime) {
	 * 
	 * ArrayList<Integer> values = new ArrayList(); values.add(0, 0);
	 * values.add(1, 0);
	 * 
	 * SimpleDateFormat timestamp = new SimpleDateFormat("HH:mm");
	 * 
	 * try { timestamp.parse(startTime); timestamp.parse(endTime); long Duration
	 * = (timestamp.parse(endTime).getTime() -
	 * timestamp.parse(startTime).getTime()); long hr =
	 * TimeUnit.MILLISECONDS.toHours(Duration); long min =
	 * TimeUnit.MILLISECONDS.toMinutes(Duration) -
	 * TimeUnit.HOURS.toMinutes(TimeUnit.MILLISECONDS.toHours(Duration));
	 * 
	 * values.add(0, (int) hr); values.add(1, (int) min);
	 * 
	 * } catch (ParseException e) { // TODO Auto-generated catch block
	 * e.printStackTrace(); }
	 * 
	 * return values; }
	 */

	public StringBuffer getBatch(int batchGroupID) {

		String sql = "SELECT 	course.id as cid, batch.id as batchid,     course.course_name as coursename 	FROM 		course, 		batch 	WHERE 		batch_group_id = '"
				+ batchGroupID + "' 	AND course. ID = batch.course_id";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		out.append("<option value=''> Select Course...</option>");
		for (HashMap<String, Object> item : data) {

			out.append("<option data-course='" + item.get("cid") + "' value='" + item.get("batchid") + "'>"
					+ item.get("coursename") + "</option>");
		}
		out.append("");

		return out;

	}

	public StringBuffer getBatchGroups(int courseID) {

		String sql = "SELECT batch_group.id as id,batch_group.name as bgname FROM batch, batch_group WHERE batch_group.id = batch.batch_group_id AND batch.id ="
				+ courseID;
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		out.append("<option  value='Select One'>Select One </option>");
		for (HashMap<String, Object> item : data) {

			out.append("<option  value='" + item.get("id") + "'>" + item.get("bgname") + "</option>");
		}
		out.append("");

		return out;

	}

	public StringBuffer getAssessment(int assessmentData) {

		String sql = "SELECT DISTINCT id,assessmenttitle FROM assessment;";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		out.append("<option value='0'> Select Assessment...</option>");
		for (HashMap<String, Object> item : data) {

			out.append("<option value='" + item.get("id") + "'>" + item.get("assessmenttitle") + "</option>");
		}
		out.append("");

		return out;

	}

	public void insertUpdateData(int trainerID, int hours, int minute, int batchID, String eventType, String eventDate,
			String startTime, int classroomID, int AdminUserID, int sessionID, String eventID,
			String associateTrainerID) {

		try {
			FinaleventDate = formatter.parse(dateformatto.format(dateformatfrom.parse(eventDate)) + " " + startTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		trainerBatchCheck(batchID, trainerID);

		if (eventID != null) {

			updateEvent(eventID, trainerID, hours, minute, batchID, formatter.format(FinaleventDate).toString(),
					startTime, AdminUserID, classroomID, sessionID, associateTrainerID);
		} else {

			createEvent(trainerID, hours, minute, batchID, formatter.format(FinaleventDate).toString(), startTime,
					AdminUserID, classroomID, -1, associateTrainerID);

		}

	}

	public void trainerBatchCheck(int batchID, int TrainerID) {

		String sql = "SELECT count(*) FROM trainer_batch WHERE batch_id = " + batchID + " AND trainer_id = "
				+ TrainerID;
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		if (data.size() == 0) {

			String sql1 = "INSERT INTO trainer_batch ('id', 'batch_id', 'trainer_id') VALUES ((SELECT max(id)+1 FROM trainer_batch), "
					+ batchID + ", " + TrainerID + ")";
			db.executeUpdate(sql1);
		}

	}

	public StringBuffer createDiv(HashMap<String, String> data, boolean isCreated) {
		System.out.println("creatediv");
		StringBuffer out = new StringBuffer();
		String trainerData = "";

		trainerData = "{";
		for (Entry<String, String> value : data.entrySet()) {

			trainerData += "\"" + value.getKey() + "\" : \"" + value.getValue() + "\",";
		}

		trainerData = trainerData.substring(0, trainerData.length() - 1);

		trainerData += "}";
		UUID id = UUID.randomUUID();

		if (isCreated == true) {

			out.append("<div class='col-lg-4 new_schedule' id='new_schedule_parent_" + id + "' data-trainer_data='"
					+ trainerData + "'>" + "<div class='panel panel-warning'>");

		} else {

			out.append("<div class='col-lg-4 new_schedule' id='new_schedule_parent_" + id + "' data-trainer_data='"
					+ trainerData + "'>" + "<div class='panel panel-primary custom-theme-panel-primary'> ");
		}

		out.append("" + "<div class='panel-body'>" + "<h3>New-Session</h3>" + "<p>Course: " + data.get("courseName")
				+ ".</p>" + "<p class='trainer_id_holder' data-trainer_id=''>Trainer : " + data.get("trainerName")
				+ "</p>" + "<hr>" + "<p class=''><i class='fa fa-calendar'> Date: " + data.get("eventDate") + "</i>"
				+ "<i class='fa fa-clock-o pull-right '> Time: " + data.get("startTime") + "</i> </p> </div> "
				+ "<div class='panel-heading custom-theme-panal-color text-center'> 	" + "<button "
				+ "' class='btn btn-block btn-outline btn-default modify-modal-newSchedular' id='" + id
				+ "' type='button'> " + "<i class='fa fa-plus'></i>&nbsp;&nbsp;Modify Details </button> </div> "
				+ "</div> </div>");

		out.append("");
		return out;

	}

	// create single event
	public StringBuffer singleEvent(int trainerID, int hours, int minute, int batchID, String eventType,
			String eventDate, String startTime, int classroomID, int AdminUserID, int orgID,
			String associateTrainerID) {

		// StudentDAO studentDAO = new StudentDAO();
		// Student student = new Student();

		IstarUserDAO dao = new IstarUserDAO();
		IstarUser user = new IstarUser();
		String uType = "SUPER_ADMIN";

		if (AdminUserID != 0 && AdminUserID != 300) {

			user = dao.findById(AdminUserID);
			orgID = user.getUserOrgMappings().iterator().next().getOrganization().getId();
			uType = "ORG_ADMIN";
		}

		Batch batch = new BatchDAO().findById(batchID);
		Course c = batch.getCourse();
		String courseName = c.getCourseName();
		user = dao.findById(trainerID);
		String trainerName = user.getUserProfile().getFirstName();

		HashMap<String, String> hashMap = new HashMap<>();
		hashMap.put("trainerID", trainerID + "");
		hashMap.put("hours", hours + "");
		hashMap.put("minute", minute + "");
		hashMap.put("batchID", batchID + "");
		hashMap.put("classroomID", classroomID + "");
		hashMap.put("AdminUserID", AdminUserID + "");
		hashMap.put("eventType", eventType);
		hashMap.put("eventDate", eventDate);
		hashMap.put("startTime", startTime);
		hashMap.put("trainerName", trainerName);
		hashMap.put("courseName", courseName);
		hashMap.put("tabType", "singleEvent");
		hashMap.put("orgID", orgID + "");
		hashMap.put("associateTrainerID", associateTrainerID);
		hashMap.put("uType", uType);

		StringBuffer out = new StringBuffer();
		String qdate = null;
		boolean isCreated = false;
		try {
			qdate = dateformatto.format(dateformatfrom.parse(eventDate));
			// FinaleventDate =
			// formatter.parse(dateformatto.format(dateformatfrom.parse(eventDate))
			// + " " + startTime);
		} catch (ParseException e1) {
			e1.printStackTrace();
		}

		ArrayList<String> datacheck = eventValidation(hours, minute, startTime, eventDate, classroomID, batchID + "",
				trainerID);

		if (datacheck.size() > 0) {
			isCreated = true;
			out.append(createDiv(hashMap, isCreated));
		} else {
			out.append(createDiv(hashMap, isCreated));
		}

		out.append(getEventDetails(qdate, datacheck, orgID));

		out.append("");
		return out;

	}

	// editNewEvent
	public StringBuffer editNewEvent(JSONArray array) {

		ArrayList<String> list = new ArrayList<>();
		ArrayList<String> qdatelist = new ArrayList<>();
		StringBuffer out = new StringBuffer();
		String qdate = null;
		int orgID = 0;
		for (int i = 0; i < array.size(); i++) {

			HashMap<String, String> hashMap = new HashMap<>();
			JSONObject jsonObject = (JSONObject) array.get(i);
			boolean isCreated = false;
			int classroomID = Integer.parseInt((String) jsonObject.get("classroomID"));
			String tabType = (String) jsonObject.get("tabType");
			String startTime = (String) jsonObject.get("startTime");
			int AdminUserID = Integer.parseInt((String) jsonObject.get("AdminUserID"));
			orgID = Integer.parseInt((String) jsonObject.get("orgID"));
			String eventType = (String) jsonObject.get("eventType");
			int batchID = Integer.parseInt((String) jsonObject.get("batchID"));
			int trainerID = Integer.parseInt((String) jsonObject.get("trainerID"));
			int minute = Integer.parseInt((String) jsonObject.get("minute"));
			int hours = Integer.parseInt((String) jsonObject.get("hours"));
			String eventDate = (String) jsonObject.get("eventDate");
			String associateTrainerID = (String) jsonObject.get("associateTrainerID");

			IstarUserDAO dao = new IstarUserDAO();
			IstarUser user = new IstarUser();

			user = dao.findById(trainerID);
			String trainerName = user.getUserProfile().getFirstName();

			Batch batch = new BatchDAO().findById(batchID);
			Course c = batch.getCourse();
			String courseName = c.getCourseName();
			String uType = "SUPER_ADMIN";

			if (AdminUserID != 0 && AdminUserID != 300) {
				user = dao.findById(AdminUserID);
				orgID = user.getUserOrgMappings().iterator().next().getOrganization().getId();
				uType = "ORG_ADMIN";
			}

			hashMap.put("trainerID", trainerID + "");
			hashMap.put("hours", hours + "");
			hashMap.put("minute", minute + "");
			hashMap.put("batchID", batchID + "");
			hashMap.put("classroomID", classroomID + "");
			hashMap.put("AdminUserID", AdminUserID + "");
			hashMap.put("eventType", eventType);
			hashMap.put("eventDate", eventDate);
			hashMap.put("startTime", startTime);
			hashMap.put("trainerName", trainerName);
			hashMap.put("courseName", courseName);
			hashMap.put("tabType", "singleEvent");
			hashMap.put("orgID", orgID + "");
			hashMap.put("associateTrainerID", associateTrainerID);
			hashMap.put("uType", uType);
			try {
				qdate = dateformatto.format(dateformatfrom.parse(eventDate));
				qdatelist.add(qdate);
			} catch (ParseException e1) {
				e1.printStackTrace();
			}

			ArrayList<String> datacheck = eventValidation(hours, minute, startTime, eventDate, classroomID,
					batchID + "", trainerID);

			if (!list.contains(datacheck)) {
				list.addAll(datacheck);
			}

			if (datacheck.size() > 0) {
				isCreated = true;
				out.append(createDiv(hashMap, isCreated));
			} else {
				out.append(createDiv(hashMap, isCreated));
			}

		}

		for (String qqdate : qdatelist) {
			out.append(getEventDetails(qqdate, list, orgID));
		}

		out.append("");
		return out;

	}

	// create daily events
	public StringBuffer dailyEvent(int trainerID, int hours, int minute, int batchID, String eventType,
			String startEventDate, String endEventDate, String startTime, int classroomID, int AdminUserID, int orgID,
			String associateTrainerID) {

		Batch batch = new BatchDAO().findById(batchID);
		Course c = batch.getCourse();
		String courseName = c.getCourseName();

		IstarUserDAO dao = new IstarUserDAO();
		IstarUser user = new IstarUser();

		user = dao.findById(trainerID);
		String trainerName = user.getUserProfile().getFirstName();

		String uType = "SUPER_ADMIN";
		if (AdminUserID != 0 && AdminUserID != 300) {
			user = dao.findById(AdminUserID);
			orgID = user.getUserOrgMappings().iterator().next().getOrganization().getId();
			uType = "ORG_ADMIN";
		}

		HashMap<String, String> hashMap = new HashMap<>();
		hashMap.put("trainerID", trainerID + "");
		hashMap.put("hours", hours + "");
		hashMap.put("minute", minute + "");
		hashMap.put("batchID", batchID + "");
		hashMap.put("classroomID", classroomID + "");
		hashMap.put("AdminUserID", AdminUserID + "");
		hashMap.put("eventType", eventType);
		hashMap.put("tabType", "dailyEvent");
		hashMap.put("startTime", startTime);
		hashMap.put("trainerName", trainerName);
		hashMap.put("courseName", courseName);
		hashMap.put("orgID", orgID + "");
		hashMap.put("associateTrainerID", associateTrainerID);
		hashMap.put("uType", uType);

		StringBuffer out = new StringBuffer();
		String qdate = null;
		ArrayList<String> list = new ArrayList<>();
		ArrayList<String> qdatelist = new ArrayList<>();
		for (String eventDate : getDatesBetweenDates(startEventDate, endEventDate)) {
			boolean isCreated = false;
			hashMap.put("eventDate", eventDate);
			try {
				qdate = dateformatto.format(dateformatfrom.parse(eventDate));
				qdatelist.add(qdate);
			} catch (ParseException e1) {
				e1.printStackTrace();
			}

			ArrayList<String> datacheck = eventValidation(hours, minute, startTime, eventDate, classroomID,
					batchID + "", trainerID);

			if (!list.contains(datacheck)) {
				list.addAll(datacheck);
			}

			if (datacheck.size() > 0) {
				isCreated = true;
				out.append(createDiv(hashMap, isCreated));
			} else {
				out.append(createDiv(hashMap, isCreated));
			}

		}

		for (String qqdate : qdatelist) {
			out.append(getEventDetails(qqdate, list, orgID));
		}
		out.append("");
		return out;

	}

	// create weekly events
	public StringBuffer weeklyEvent(int trainerID, int hours, int minute, int batchID, String eventType,
			String startEventDate, String endEventDate, String startTime, int classroomID, int AdminUserID, String days,
			int orgID, String associateTrainerID) {

		Batch batch = new BatchDAO().findById(batchID);
		Course c = batch.getCourse();

		IstarUserDAO dao = new IstarUserDAO();
		IstarUser user = new IstarUser();

		String courseName = c.getCourseName();
		user = dao.findById(trainerID);
		String trainerName = user.getUserProfile().getFirstName();

		String uType = "SUPER_ADMIN";
		if (AdminUserID != 0 && AdminUserID != 300) {
			user = dao.findById(AdminUserID);
			orgID = user.getUserOrgMappings().iterator().next().getOrganization().getId();
			uType = "ORG_ADMIN";

		}

		HashMap<String, String> hashMap = new HashMap<>();
		hashMap.put("trainerID", trainerID + "");
		hashMap.put("hours", hours + "");
		hashMap.put("minute", minute + "");
		hashMap.put("batchID", batchID + "");
		hashMap.put("classroomID", classroomID + "");
		hashMap.put("AdminUserID", AdminUserID + "");
		hashMap.put("eventType", eventType);
		hashMap.put("tabType", "dailyEvent");
		hashMap.put("startTime", startTime);
		hashMap.put("trainerName", trainerName);
		hashMap.put("courseName", courseName);
		hashMap.put("orgID", orgID + "");
		hashMap.put("associateTrainerID", associateTrainerID);
		hashMap.put("uType", uType);
		StringBuffer out = new StringBuffer();
		String qdate = null;
		ArrayList<String> list = new ArrayList<>();
		ArrayList<String> qdatelist = new ArrayList<>();
		for (String eventDate : getDaysBetweenDates(startEventDate, endEventDate, days)) {
			boolean isCreated = false;
			hashMap.put("eventDate", eventDate);
			try {
				qdate = dateformatto.format(dateformatfrom.parse(eventDate));
				qdatelist.add(qdate);
			} catch (ParseException e1) {
				e1.printStackTrace();
			}

			ArrayList<String> datacheck = eventValidation(hours, minute, startTime, eventDate, classroomID,
					batchID + "", trainerID);

			if (!list.contains(datacheck)) {
				list.addAll(datacheck);
			}

			if (datacheck.size() > 0) {
				isCreated = true;
				out.append(createDiv(hashMap, isCreated));
			} else {
				out.append(createDiv(hashMap, isCreated));
			}

		}

		for (String qqdate : qdatelist) {
			out.append(getEventDetails(qqdate, list, orgID));
		}
		out.append("");
		return out;

	}

	public StringBuffer getEventDetails(String qdate, ArrayList<String> datacheck, int orgID) {

		StringBuffer out = new StringBuffer();
		String sql = "SELECT 	batch_schedule_event.batch_id AS bid, 	batch_schedule_event.eventhour AS eventhour, 	batch_schedule_event.eventminute AS eventminute, 	batch_schedule_event.actor_id AS userid, 	batch_schedule_event.classroom_id AS classroomid, 	CAST ( 		batch_schedule_event. ID AS VARCHAR (50) 	) AS eventid, 	batch_schedule_event.eventdate AS eventdate, 	user_profile.first_name AS NAME FROM 	batch_schedule_event, user_profile, user_role WHERE 	batch_id IN ( 		SELECT 			ID 		FROM 			batch 		WHERE 			batch.batch_group_id IN ( 				SELECT 					ID 				FROM 					batch_group 				WHERE 					college_id = "
				+ orgID + " 			) 	) " + "AND CAST (eventdate AS VARCHAR(50)) LIKE '%" + qdate
				+ "%' AND user_profile.user_id = batch_schedule_event.actor_id AND user_role.user_id = user_profile.user_id "
				+ "AND user_role.role_id = 14";

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {

			String evdate = null;
			String evetime = null;
			int batchId = (int) item.get("bid");
			Batch batch = new BatchDAO().findById(batchId);
			Course c = batch.getCourse();
			String courseName = c.getCourseName();

			try {
				evdate = sdf2.format(formatter1.parse(item.get("eventdate").toString()));
				evetime = sdf1.format(formatter1.parse(item.get("eventdate").toString()));
			} catch (ParseException e) {
				e.printStackTrace();
			}

			if (datacheck.contains(item.get("eventid").toString())) {

				out.append("<div class='col-lg-4'>" + "<div class='panel panel-warning'>");

			} else {

				out.append("<div class='col-lg-4'>" + "<div class='panel panel-success'>");
			}

			out.append("<div class='panel-body'>" + "<h3>Existing Session</h3>" + "<p>Course: " + courseName + ".</p>"
					+ "<p>Trainer : " + item.get("name") + "</p>" + "<hr>" + "<p><i class='fa fa-calendar'> Date: "
					+ evdate + "</i>" + "<i class='fa fa-clock-o pull-right'> Time: " + evetime + "</i> </p> </div> "
					+ "<div class='panel-heading text-center'> 	" + "<button id='" + item.get("eventid")
					+ "' class='btn btn-block btn-outline btn-default modify-modal' type='button'> "
					+ "<i class='fa fa-plus'></i>&nbsp;&nbsp;Modify Details </button> </div> "

					+ "</div> </div>");

		}
		out.append("");
		return out;
	}

	public ArrayList<String> eventValidation(int duration_hour, int duration_min, String id__event_time,
			String id__event_date_holder, int classroom_id, String hidden_batch_id, int trainer_id) {

		String result = "";
		ArrayList<String> arrayList = new ArrayList<>();
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		DateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");

		Date date = null;

		String newdate = null;
		try {

			newdate = dateformatto.format(dateformatfrom.parse(id__event_date_holder));

			date = formatter
					.parse(dateformatto.format(dateformatfrom.parse(id__event_date_holder)) + " " + id__event_time);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Date upper_limit = DateUtils.addMinutes(date, duration_hour * 60 + duration_min);

		String Validatesql = "SELECT cast(batch_schedule_event. ID as varchar(50)) as eventid, actor_id,eventdate,eventhour,eventminute,classroom_id,batch_id FROM batch_schedule_event WHERE cast (eventdate as varchar (50)) LIKE '%"
				+ newdate + " " + id__event_time.substring(0, 2) + "%' AND type = 'BATCH_SCHEDULE_EVENT_TRAINER'";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(Validatesql);

		for (HashMap<String, Object> item : data) {

			Date db_upper_limit = DateUtils.addMinutes((Date) item.get("eventdate"),
					Integer.parseInt(item.get("eventhour").toString()) * 60
							+ Integer.parseInt(item.get("eventminute").toString()));

			if (formatter1.format(date).compareTo(formatter1.format(item.get("eventdate"))) > 0
					&& (int) item.get("actor_id") == trainer_id || classroom_id == (int) item.get("classroom_id")
					|| Integer.parseInt(hidden_batch_id) == (int) item.get("batch_id")) {

				if (!arrayList.contains(item.get("eventid").toString())) {

					arrayList.add(item.get("eventid").toString());
				}

			}
			if (formatter1.format(db_upper_limit).compareTo(formatter1.format(upper_limit)) < 0
					&& (int) item.get("actor_id") == trainer_id || classroom_id == (int) item.get("classroom_id")
					|| Integer.parseInt(hidden_batch_id) == (int) item.get("batch_id")) {

				if (!arrayList.contains(item.get("eventid").toString())) {

					arrayList.add(item.get("eventid").toString());
				}
			}

		}

		String class_and_time_available = "SELECT cast(batch_schedule_event. ID as varchar(50)) as eventid, count(*) as countt FROM 	batch_schedule_event WHERE 	 eventdate  >= '"
				+ formatter1.format(date) + "' AND eventdate  <= '" + formatter1.format(upper_limit)
				+ "' And type !='BATCH_SCHEDULE_EVENT_PRESENTOR' And classroom_id = " + classroom_id
				+ " GROUP BY eventid";

		String trainer_available = "SELECT cast(batch_schedule_event. ID as varchar(50)) as eventid, count(*) as countt FROM 	batch_schedule_event WHERE 	actor_id = "
				+ trainer_id + " And type !='BATCH_SCHEDULE_EVENT_PRESENTOR' AND 	 eventdate >= '"
				+ formatter1.format(date) + "' AND eventdate <= '" + formatter1.format(upper_limit)
				+ "' GROUP BY eventid";

		String batch_available = "SELECT cast(batch_schedule_event. ID as varchar(50)) as eventid, count(*) as countt FROM 	batch_schedule_event WHERE 	 eventdate >= '"
				+ formatter1.format(date) + "' AND eventdate <= '" + formatter1.format(upper_limit)
				+ "'And type !='BATCH_SCHEDULE_EVENT_PRESENTOR' and batch_id =" + hidden_batch_id + " GROUP BY eventid";

		List<HashMap<String, Object>> classtime = db.executeQuery(class_and_time_available);
		try {
			if (classtime.size() > 0) {
				for (HashMap<String, Object> item : classtime) {

					if (!arrayList.contains(item.get("eventid").toString())) {

						arrayList.add(item.get("eventid").toString());
					}
				}

			}

			List<HashMap<String, Object>> traineravailable = db.executeQuery(trainer_available);
			if (traineravailable.size() > 0) {
				for (HashMap<String, Object> item : traineravailable) {

					if (!arrayList.contains(item.get("eventid").toString())) {

						arrayList.add(item.get("eventid").toString());
					}

				}

			}

			List<HashMap<String, Object>> batchavailable = db.executeQuery(batch_available);
			if (batchavailable.size() > 0) {
				for (HashMap<String, Object> item : batchavailable) {
					if (!arrayList.contains(item.get("eventid").toString())) {

						arrayList.add(item.get("eventid").toString());
					}
				}

			} else {
				// arrayList.add("every_thing_fine");
			}
		} catch (Exception e) {
			// arrayList.add("every_thing_fine");
			return arrayList;
		}
		return arrayList;

	}

	public static List<String> getDatesBetweenDates(String startEventDate, String endEventDate) {

		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat format1 = new SimpleDateFormat("MMM d, yyyy HH:mm:ss");

		Date startDate = null, endDate = null;
		try {
			startDate = format.parse(startEventDate);
			endDate = format.parse(endEventDate);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ArrayList<String> dates = new ArrayList<String>();
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(startDate);
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(endDate);
		while (cal1.before(cal2) || cal1.equals(cal2)) {

			String fdate = format.format(cal1.getTime());

			dates.add(fdate);

			cal1.add(Calendar.DATE, 1);
		}
		return dates;
	}

	public static List<String> getDaysBetweenDates(String startEventDate, String endEventDate, String selectedDays) {

		org.joda.time.format.DateTimeFormatter pattern = DateTimeFormat.forPattern("dd/MM/yyyy");
		DateTime startDate = pattern.parseDateTime(startEventDate);
		DateTime endDate = pattern.parseDateTime(endEventDate);

		List<String> days = new ArrayList<>();

		String[] selectedDayssplit = selectedDays.split(",");

		for (String value : selectedDayssplit) {

			while (startDate.isBefore(endDate)) {
				if (startDate.getDayOfWeek() == Integer.parseInt(value)) {

					days.add(dateformatfrom.format(startDate.toDate()).toString());
				}
				startDate = startDate.plusDays(1);
			}
		}

		return days;

	}

}
