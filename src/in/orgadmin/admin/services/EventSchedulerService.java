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
import com.viksitpro.core.dao.entities.ClassroomDetails;
import com.viksitpro.core.dao.entities.ClassroomDetailsDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;
import com.viksitpro.core.utilities.TaskItemCategory;

import in.talentify.core.utils.AndroidNoticeDelegator;

import org.apache.commons.lang3.time.DateUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
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
		
		if(associateTrainerID==null || associateTrainerID.equalsIgnoreCase("[0]"))
		{
			associateTrainerID="";
		}
		String action = "cmsession_id__-1";
		cmsessionID = -1;
		Batch b = new BatchDAO().findById(batchID);
		Organization org = b.getBatchGroup().getOrganization();
		Course c = b.getCourse();
		/*if (cmsessionID == -1) {
			cmsessionID = -1;
			action = "cmsession_id__-1";
		}*/

		ClassroomDetails classRoom = new ClassroomDetailsDAO().findById(classroomID);		
		String evnetName = "REAL EVENT FOR CLASS-" + org.getName() + "-Ilab-" + c.getCourseName();		
		IstarNotificationServices notificationService = new IstarNotificationServices();
		DBUTILS db = new DBUTILS();
		AndroidNoticeDelegator noticeDelegator = new AndroidNoticeDelegator();
		String ssql = "SELECT count(*) as tcount FROM trainer_batch WHERE trainer_id= " + trainerID + " AND batch_id ="+ batchID;

		List<HashMap<String, Object>> data = db.executeQuery(ssql);

		if (Integer.parseInt(data.get(0).get("tcount").toString()) == 0) {

			String trainerBatchSql = "INSERT INTO trainer_batch ( 	id, 	batch_id, 	trainer_id ) VALUES 	((SELECT COALESCE (MAX(ID) + 1, 1) 	FROM 	trainer_batch ) , "
					+ batchID + ", " + trainerID + ");";

			db.executeUpdate(trainerBatchSql);
			System.out.println("trainerBatchSql-----> "+trainerBatchSql);

		}
		
		String findPresentorID = "select presentor_id from trainer_presentor where trainer_id = "+trainerID;		
		List<HashMap<String, Object>> presentorData = db.executeQuery(findPresentorID);
		Integer presentorID = null;
		if(presentorData.size()>0)
		{
			presentorID = (int)presentorData.get(0).get("presentor_id");
		}
		

		String groupNotificationCode = UUID.randomUUID().toString();
		HashMap<Integer,Integer> userToEventMap = new HashMap<>();
		String eventQueueName ="Queue for Group "+b.getBatchGroup().getName().trim().replace("'", "")+" and course "+c.getCourseName().trim().replace("'", "")+"";
		String createMasterEventQueue ="INSERT INTO event_queue (id, event_name, batch_group_id, course_id, group_code) VALUES (( SELECT COALESCE (MAX(ID) + 1, 1) FROM event_queue ), '"+eventQueueName+"', "+b.getBatchGroup().getId()+", "+c.getId()+",'"+groupNotificationCode+"') returning id;";
		String notificationTitle = "A class has been scheduled for the course "+c.getCourseName()+ " in "+org.getName()+" at "+eventDate;
		String notificationDescription =  notificationTitle;
		
		String insertIntoProject ="INSERT INTO project (id, name, created_at, updated_at, creator, active) VALUES ((select COALESCE(max(id),0)+1 from project), '"+eventQueueName+"', now(), now(),  "+AdminUserID+", 't') returning id;";
		int projectId = db.executeUpdateReturn(insertIntoProject);
		
		int masterEventQueueId = db.executeUpdateReturn(createMasterEventQueue);		
		
		String insertTrainerEvent ="INSERT INTO batch_schedule_event ( actor_id, created_at, creator_id, eventdate, eventhour, eventminute, isactive, TYPE, updated_at, ID, status, ACTION, cmsession_id, batch_group_id, course_id, event_name, classroom_id, associate_trainee, batch_group_code ) "
				+ "VALUES ( "+trainerID+", now(), "+AdminUserID+", '"+eventDate+"', "+hours+", "+minute+", 't', 'BATCH_SCHEDULE_EVENT_TRAINER', now(), ( SELECT COALESCE (MAX(ID) + 1, 1) FROM batch_schedule_event ), 'SCHEDULED', 'cmsession_id__-1', - 1, "+b.getBatchGroup().getId()+", "+c.getId()+", '"+evnetName+"', "+classroomID+", '"+associateTrainerID+"','"+groupNotificationCode+"' ) RETURNING ID";
		int trainerEventId = db.executeUpdateReturn(insertTrainerEvent) ;
		userToEventMap.put(trainerID, trainerEventId);
		String createTaskForTrainer ="INSERT INTO task ( ID, NAME, OWNER, actor, STATE, start_date, end_date, is_active, created_at, updated_at, item_id, item_type, project_id ) values (( SELECT COALESCE (MAX(ID), 0) + 1 FROM task ), '"+notificationTitle+"', "+AdminUserID+", "+trainerID+", 'SCHEDULED', CAST ( '"+eventDate+"' AS TIMESTAMP ), CAST ( '("+eventDate+")' AS TIMESTAMP ) + INTERVAL '1' MINUTE * ("+hours+" * 60 + "+minute+"), 't', now(), now(), "+trainerEventId+", '"+TaskItemCategory.CLASSROOM_SESSION+"', "+projectId+") returning id ;";
		int taskIdForTrainer = db.executeUpdateReturn(createTaskForTrainer);
		
		
		IstarNotification istarNotification = notificationService.createIstarNotification(AdminUserID, trainerID, notificationTitle.trim().replace("'", ""), notificationDescription.trim().replace("'", ""), "UNREAD", null, NotificationType.CLASSROOM_SESSION, true, taskIdForTrainer, groupNotificationCode);
		HashMap<String, Object> item = new HashMap<String, Object>();
		item.put("taskId", taskIdForTrainer);
		noticeDelegator.sendNotificationToUser(istarNotification.getId(), trainerID+"", notificationTitle.trim().replace("'", ""), NotificationType.CLASSROOM_SESSION, item);  
		
		if(presentorID!=null){
		String insertPresentorEvent ="INSERT INTO batch_schedule_event ( actor_id, created_at, creator_id, eventdate, eventhour, eventminute, isactive, TYPE, updated_at, ID, status, ACTION, cmsession_id, batch_group_id, course_id, event_name, classroom_id, associate_trainee, batch_group_code ) "
				+ "VALUES ( "+presentorID+", now(), "+AdminUserID+", '"+eventDate+"', "+hours+", "+minute+", 't', 'BATCH_SCHEDULE_EVENT_PRESENTOR', now(), ( SELECT COALESCE (MAX(ID) + 1, 1) FROM batch_schedule_event ), 'SCHEDULED', 'cmsession_id__-1', - 1, "+b.getBatchGroup().getId()+", "+c.getId()+", '"+evnetName+"', "+classroomID+", '"+associateTrainerID+"','"+groupNotificationCode+"' ) RETURNING ID";		
		int presentorEventId = db.executeUpdateReturn(insertPresentorEvent) ; 
			userToEventMap.put(presentorID, presentorEventId);
			String createTaskForPresentor ="INSERT INTO task ( ID, NAME, OWNER, actor, STATE, start_date, end_date, is_active, created_at, updated_at, item_id, item_type , project_id) values (( SELECT COALESCE (MAX(ID), 0) + 1 FROM task ), '"+notificationTitle+"', "+AdminUserID+", "+presentorID+", 'SCHEDULED', CAST ( '"+eventDate+"' AS TIMESTAMP ), CAST ( '("+eventDate+")' AS TIMESTAMP ) + INTERVAL '1' MINUTE * ("+hours+" * 60 + "+minute+"), 't', now(), now(), "+presentorEventId+", '"+TaskItemCategory.CLASSROOM_SESSION_PRESENTOR+"',"+projectId+") returning id ;";
			int taskIdForPresentor = db.executeUpdateReturn(createTaskForPresentor);				
			
		}
		
		/*String findStudentInBatch ="select distinct batch_students.student_id from batch_students,batch_group, batch where batch.batch_group_id = batch_group.id and batch_group.id = batch_students.batch_group_id and batch_group.is_historical_group ='f' and batch.id = "+batchID;
		List<HashMap<String, Object>> studentsInBatch = db.executeQuery(findStudentInBatch);
		for(HashMap<String, Object> row: studentsInBatch)
		{
			int stuId = (int)row.get("student_id");
			String createEventForStudent ="INSERT INTO batch_schedule_event ( actor_id, created_at, creator_id, eventdate, eventhour, eventminute, isactive, TYPE, updated_at, ID, status, ACTION, cmsession_id, batch_group_id, course_id, event_name, classroom_id, associate_trainee, batch_group_code ) "
					+ "VALUES ( "+stuId+", now(), "+AdminUserID+", '"+eventDate+"', "+hours+", "+minute+", 't', 'BATCH_SCHEDULE_EVENT_STUDENT', now(), ( SELECT COALESCE (MAX(ID) + 1, 1) FROM batch_schedule_event ), 'SCHEDULED', 'cmsession_id__-1', - 1, "+b.getBatchGroup().getId()+", "+c.getId()+", '"+evnetName+"', "+classroomID+", '"+associateTrainerID+"','"+groupNotificationCode+"' ) RETURNING ID";
			int studentEventId =db.executeUpdateReturn(createEventForStudent);
			userToEventMap.put(stuId, studentEventId);
			
			String createTaskForStudent ="INSERT INTO task ( ID, NAME, OWNER, actor, STATE, start_date, end_date, is_active, created_at, updated_at, item_id, item_type, project_id ) values (( SELECT COALESCE (MAX(ID), 0) + 1 FROM task ), '"+notificationTitle+"', "+AdminUserID+", "+stuId+", 'SCHEDULED', CAST ( '"+eventDate+"' AS TIMESTAMP ), CAST ( '("+eventDate+")' AS TIMESTAMP ) + INTERVAL '1' MINUTE * ("+hours+" * 60 + "+minute+"), 't', now(), now(), "+studentEventId+", '"+TaskItemCategory.CLASSROOM_SESSION_STUDENT+"',"+projectId+") returning id ;";
			int taskIdForStudent =db.executeUpdateReturn(createTaskForStudent);						
			notificationTitle = "A class has been scheduled for the course "+c.getCourseName()+ " in classroom "+classRoom.getClassroomIdentifier().trim().replace("'", "")+" at "+eventDate;
			notificationDescription =  notificationTitle;
		
			IstarNotification istarNotificationForStudent = notificationService.createIstarNotification(AdminUserID, stuId, notificationTitle.trim().replace("'", ""), notificationDescription.trim().replace("'", ""), "UNREAD", null, NotificationType.CLASSROOM_SESSION_STUDENT, true, taskIdForStudent, groupNotificationCode);
			HashMap<String, Object> itemForStudent = new HashMap<String, Object>();
			
			itemForStudent.put("taskId", taskIdForStudent);
			noticeDelegator.sendNotificationToUser(istarNotificationForStudent.getId(), stuId+"", notificationTitle.trim().replace("'", ""), NotificationType.CLASSROOM_SESSION, itemForStudent);  						
		}*/
		
		
		for(Integer userKey : userToEventMap.keySet())
		{
			String mapWithQueue ="INSERT INTO event_queue_event_mapping ( ID, event_queue_id, event_for, user_id, event_id, created_at, updated_at ) values ( ( SELECT COALESCE (MAX(ID) + 1, 1) FROM event_queue_event_mapping ), "+masterEventQueueId+", 'mapping for "+eventQueueName+" ', "+userKey+", "+userToEventMap.get(userKey)+", now(), now() )";
			db.executeUpdate(mapWithQueue);
		}
		

	}

	

	public void deleteEvent(String eventID) {

		DBUTILS db = new DBUTILS();
		
		String findGrouCode = "select batch_group_code from batch_schedule_event where id ="+eventID;
		List<HashMap<String, Object>> codeData = db.executeQuery(findGrouCode);
		if(codeData.size()>0)
		{
			String groupCode = codeData.get(0).get("batch_group_code").toString();
			
			String deletefromNotification="DELETE FROM istar_notification WHERE group_code ='"+groupCode+"'";
			db.executeUpdate(deletefromNotification);
			
			String deleteFromTask ="DELETE FROM task WHERE  item_id in (select id from batch_schedule_event where batch_group_code='"+groupCode+"') AND item_type like '%CLASSROOM_SESSION%' ";
			db.executeUpdate(deleteFromTask);
			
			String deleteMapping ="delete from event_queue_event_mapping where event_id in (select id from batch_schedule_event where batch_group_code='"+groupCode+"')";
			db.executeUpdate(deleteMapping);
			
			String deleteBSE="DELETE FROM batch_schedule_event WHERE batch_group_code='"+groupCode+"'";
			db.executeUpdate(deleteBSE);
			
			String deteleEventQueue ="delete from event_queue where group_code ='"+groupCode+"'";
			db.executeUpdate(deteleEventQueue);
		}
	}

	public void updateEvent(String eventID, int trainerID, int hours, int minute, int batchID, String eventDate,
			String startTime, int AdminUserID, int classroomID, int sessionID, String associateTrainerID) {

		deleteEvent(eventID);
		
		createEvent(trainerID, hours, minute, batchID, eventDate, startTime, AdminUserID, classroomID, sessionID,
				associateTrainerID);

		updateEventSessionLog(trainerID, hours, minute, batchID, eventDate, startTime, AdminUserID, classroomID, sessionID,
				associateTrainerID);
	}

	private void updateEventSessionLog(int trainerID, int hours, int minute, int batchID, String eventDate, String startTime, int adminUserID, int classroomID, int sessionID, String associateTrainerID) {
		// TODO Auto-generated method stub
		
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
				+ "</p>" + "<p class='current_session_holder' >Current Session : " + data.get("CurrentSession") + "</p>"
				+ "<hr>" + "<p class=''><i class='fa fa-calendar'> Date: " + data.get("eventDate") + "</i>"
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
		hashMap.put("CurrentSession", getCurrentSession(batchID));

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
			String CurrentSession = (String) jsonObject.get("CurrentSession");
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
			hashMap.put("CurrentSession", CurrentSession);
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
		hashMap.put("CurrentSession", getCurrentSession(batchID));
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
		hashMap.put("CurrentSession", getCurrentSession(batchID));
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
		String sql = "SELECT 	batch.id AS bid, 	batch_schedule_event.eventhour AS eventhour, 	batch_schedule_event.eventminute AS eventminute, 	batch_schedule_event.actor_id AS userid, 	batch_schedule_event.classroom_id AS classroomid, 	CAST ( 		batch_schedule_event. ID AS VARCHAR (50) 	) AS eventid, 	batch_schedule_event.eventdate AS eventdate, 	user_profile.first_name AS NAME "
				+ "FROM 	batch_schedule_event, batch,  user_profile, user_role WHERE batch.batch_group_id = batch_schedule_event.batch_group_id and batch.course_id = batch_schedule_event.course_id and"
				+ " 	batch_schedule_event.batch_group_id IN ( SELECT 	ID 	FROM batch_group WHERE 	college_id ="+ orgID + " ) 	 " + "AND CAST (eventdate AS VARCHAR(50)) LIKE '%" + qdate
				+ "%' and batch_schedule_event.type = 'BATCH_SCHEDULE_EVENT_TRAINER' AND user_profile.user_id = batch_schedule_event.actor_id AND user_role.user_id = user_profile.user_id "
				+ "AND user_role.role_id = 14";
		System.out.println("erronous sql>>>>>    "+sql);
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
					+ "<p>Trainer : " + item.get("name") + "</p><p class='current_session_holder' >Current Session : " + getCurrentSession(batchId) + "</p>"
					+ "<hr>" + "<p><i class='fa fa-calendar'> Date: "
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

		String Validatesql = "SELECT cast(batch_schedule_event. ID as varchar(50)) as eventid, actor_id,eventdate,eventhour,eventminute,classroom_id,batch.batch_group_id, batch.id as batch_id "
				+ "FROM batch_schedule_event, batch WHERE  batch.batch_group_id = batch_schedule_event.batch_group_id and batch_schedule_event.course_id = batch.course_id and cast (eventdate as varchar (50)) LIKE '%"
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
				+ "'And type !='BATCH_SCHEDULE_EVENT_PRESENTOR' and batch_group_id =(select batch_group_id from batch where id = "+hidden_batch_id+") GROUP BY eventid";

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
	public String getCurrentSession(int batchID) {
		String SessionName = "";
		DBUTILS db = new DBUTILS();
		String sql = "select cmsession.title from cmsession, event_log where event_log.cmsession_id = cmsession.id and event_log.batch_group_id = (select batch_group_id from batch where id="+batchID+" ) order by event_log.id desc limit 1";
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		if (data.size() > 0) {
			SessionName = (String) data.get(0).get("title");
		} else {
			sql="SELECT 	cmsession.title FROM 	module_course, 	cmsession_module, 	cmsession, 	 	batch WHERE 	module_course.course_id = batch.course_id and module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = cmsession.id and batch.id = "+batchID+" order by module_course.oid, cmsession_module.oid limit 1";
			data = db.executeQuery(sql);
			SessionName = (String) data.get(0).get("title");
		}
		return SessionName;

	}
}
