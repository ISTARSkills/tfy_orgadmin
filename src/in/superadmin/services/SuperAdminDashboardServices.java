package in.superadmin.services;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;


public class SuperAdminDashboardServices {
	

	public List<HashMap<String, Object>> getTodaysEventStats()
	{
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		String aajKiDate =dateformatto.format(new Date(System.currentTimeMillis())).toString();
		//ViksitLogger.logMSG(this.getClass().getName(),aajKiDate);
		DBUTILS dbutils = new DBUTILS();
		String sql="SELECT 	COUNT (*) AS totevent, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'COMPLETED' 	) AS completed, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'SCHEDULED' 	) AS scheduled, 	COUNT (*) FILTER (WHERE bse.status = 'TEACHING') AS teaching, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'CANCELLED' 	) AS cancelled FROM 	batch_schedule_event bse, 	classroom_details cd WHERE 	cast (bse.eventdate as varchar) like '%"+aajKiDate+"%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND bse.classroom_id = cd. ID";
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		//ViksitLogger.logMSG(this.getClass().getName(),sql);
		return items;
	}
	public List<HashMap<String, Object>> getTodaysEventData(String collegeId,int offset)
	{
		String collegQuery="";
		
		if(collegeId!=null && !collegeId.equalsIgnoreCase("")){
			collegQuery= "WHERE college_id = "+collegeId;
		}
		
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		String aajKiDate =dateformatto.format(new Date(System.currentTimeMillis())).toString();
		//ViksitLogger.logMSG(this.getClass().getName(),aajKiDate);
		DBUTILS dbutils = new DBUTILS();
		String sql1 = "SELECT DISTINCT 	batch_schedule_event.batch_id, course.course_name as title, batch_schedule_event.actor_id, CAST( batch_schedule_event.id as VARCHAR) AS event_id ,"
				+ " batch_schedule_event.eventdate, 	batch_schedule_event.eventhour, 	batch_schedule_event.status, 	batch. NAME AS batchname,"
				+ " 	batch_schedule_event.cmsession_id, 	 	classroom_details.classroom_identifier, "
				+ "	student. NAME AS trainername, 	case when student_profile_data.profile_image like 'null' OR student_profile_data.profile_image is null then 'http://cdn.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' ELSE 'http://cdn.talentify.in/'||student_profile_data.profile_image end AS trainer_image "
				+ "FROM 	batch_schedule_event "
				+ "JOIN batch ON (batch_schedule_event.batch_id = batch. ID) join course on (batch.course_id = course.id) JOIN classroom_details ON (batch_schedule_event.classroom_id = classroom_details. ID) "
				+ "JOIN student ON (batch_schedule_event.actor_id = student. ID) join student_profile_data on (student.id = student_profile_data.student_id) WHERE  batch_schedule_event.type != 'BATCH_SCHEDULE_EVENT_PRESENTOR' "
				+ "and batch_schedule_event.type != 'BATCH_SCHEDULE_EVENT_STUDENT' and 	batch_schedule_event.batch_id "
				+ "IN ( 		SELECT DISTINCT 			ID 		FROM 			PUBLIC .batch 		WHERE 			batch_group_id "
				+ "IN ( 				SELECT DISTINCT 					ID 				FROM 					batch_group "+collegQuery+"	) 	) limit 10 offset "+offset;//AND CAST ( 	batch_schedule_event.eventdate AS VARCHAR ) LIKE '%"+aajKiDate+"%' ";
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql1);
		//ViksitLogger.logMSG(this.getClass().getName(),sql1);
		return items;
	}
	
	public int getTotalEventsAvailable(){
		int count=0;
		String sql="SELECT 	CAST (COUNT(t1.event_id) AS INTEGER) FROM (SELECT DISTINCT  	batch_schedule_event.batch_id, 	course.course_name AS title, 	batch_schedule_event.actor_id, 	CAST ( 		batch_schedule_event. ID AS VARCHAR 	) AS event_id, 	batch_schedule_event.eventdate, 	batch_schedule_event.eventhour, 	batch_schedule_event.status, 	batch. NAME AS batchname, 	batch_schedule_event.cmsession_id, 	classroom_details.classroom_identifier, 	student. NAME AS trainername, 	CASE WHEN student_profile_data.profile_image LIKE 'null' OR student_profile_data.profile_image IS NULL THEN 	'http://cdn.talentify.in/video/android_images/' || UPPER ( 		SUBSTRING (student. NAME FROM 1 FOR 1) 	) || '.png' ELSE 	'http://cdn.talentify.in/' || student_profile_data.profile_image END AS trainer_image FROM 	batch_schedule_event JOIN batch ON ( 	batch_schedule_event.batch_id = batch. ID ) JOIN course ON (batch.course_id = course. ID) JOIN classroom_details ON ( 	batch_schedule_event.classroom_id = classroom_details. ID ) JOIN student ON ( 	batch_schedule_event.actor_id = student. ID ) JOIN student_profile_data ON ( 	student. ID = student_profile_data.student_id ) WHERE 	batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT' AND batch_schedule_event.batch_id IN ( 	SELECT DISTINCT 		ID 	FROM 		PUBLIC .batch 	WHERE 		batch_group_id IN ( 			SELECT DISTINCT 				ID 			FROM 				batch_group 		) ))t1";
		DBUTILS db = new DBUTILS();
		try{
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		count=(int)data.get(0).get("count");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
	
	public List<HashMap<String, Object>> getAllAccount(){
		String sql="SELECT DISTINCT 	organization. ID, 	organization. NAME FROM 	batch_schedule_event, 	classroom_details, 	organization WHERE 	batch_schedule_event.classroom_id = classroom_details. ID AND classroom_details.organization_id = organization. ID AND CAST ( 	batch_schedule_event.eventdate AS DATE ) = (SELECT CURRENT_DATE) AND batch_schedule_event. TYPE LIKE '%EVENT_TRAINER%' ";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> lists = dbutils.executeQuery(sql);
		return lists;
	}
	
	
	public List<HashMap<String, Object>> getSlideLogs(String EventId)
	{
		String sql2 = "SELECT 	slide_id AS slide_id, 	created_at AS created_at FROM 	event_log WHERE 	event_id = "+EventId+" ORDER BY 	created_at";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
		
	}
	
	public 	List<HashMap<String, Object>> getSkillsForTrainer(int trainerId)
	{
		String sql2 = "SELECT DISTINCT 	skill_objective. NAME FROM 	batch_schedule_event, 	course, 	batch, 	skill_objective, course_skill_objective WHERE 	batch_schedule_event.actor_id = "+trainerId+" AND batch_schedule_event.batch_id = batch. ID AND batch.course_id = course. ID AND course.id = course_skill_objective.course_id AND course_skill_objective.skill_objective_id = skill_objective. ID";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	public 	List<HashMap<String, Object>> getSessionsCompletedByTrainerInBatch(int trainerId, int batchId)
	{
		String sql2 = "select COALESCE(count(*),0) as sessions from event_log where trainer_id= "+trainerId+" and batch_id= "+batchId;
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	public 	List<HashMap<String, Object>> getStudentAttendanceStatus(String eventId)
	{
		String sql2 = "SELECT 	attendance.status, 	user_profile.first_name, 	CASE WHEN user_profile.profile_image LIKE 'null' OR user_profile.profile_image IS NULL THEN 	'http://cdn.talentify.in/video/android_images/' || UPPER ( 		SUBSTRING (user_profile.first_name FROM 1 FOR 1) 	) || '.png' ELSE 	'http://cdn.talentify.in/' || user_profile.profile_image END AS profile_image,  ( 	SELECT 		COUNT (*) 	FROM 		attendance 	WHERE 		attendance.event_id = "+eventId+" 	AND status = 'ABSENT' ) AS ABSENT,  ( 	SELECT 		COUNT (*) 	FROM 		attendance 	WHERE 		attendance.event_id = "+eventId+" 	AND status = 'PRESENT' ) AS present FROM 	attendance, 	istar_user, 	user_profile WHERE 	attendance.event_id = "+eventId+" AND attendance.user_id = istar_user. ID AND istar_user. ID = user_profile.user_id";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	public 	List<HashMap<String, Object>> getFeedbackDataForEvent(String eventId)
	{
		String sql2 = "SELECT 	rating, 	noise, 	attendance, 	sick, 	CONTENT, 	ASSIGNMENT, 	internals, 	internet, 	electricity, 	TIME FROM 	trainer_feedback WHERE 	event_id  ="+eventId;
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	

}
