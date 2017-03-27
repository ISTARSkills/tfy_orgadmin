/**
 * 
 */
package in.orgadmin.dashboard.services;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.istarindia.apps.dao.DBUTILS;

/**
 * @author mayank
 *
 */
public class OrgAdminDashboardServices {

	
	public List<HashMap<String, Object>> getTodaysEventStats(int collegeId)
	{
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		String aajKiDate =dateformatto.format(new Date(System.currentTimeMillis())).toString();
		System.out.println(aajKiDate);
		DBUTILS dbutils = new DBUTILS();
		String sql="SELECT 	COUNT (*) AS totevent, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'COMPLETED' 	) AS completed, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'SCHEDULED' 	) AS scheduled, 	COUNT (*) FILTER (WHERE bse.status = 'TEACHING') AS teaching, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'CANCELLED' 	) AS cancelled FROM 	batch_schedule_event bse, 	classroom_details cd WHERE 	cast (bse.eventdate as varchar) like '%"+aajKiDate+"%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND bse.classroom_id = cd. ID AND cd.organization_id = "+collegeId+"";

		if(collegeId== -3 ) {
			sql="SELECT 	COUNT (*) AS totevent, 	COUNT (*) FILTER (  		WHERE 	"
					+ "		bse.status = 'COMPLETED' 	) AS completed, 	COUNT (*) FILTER (  	"
					+ "	WHERE 			bse.status = 'SCHEDULED' 	) AS scheduled, 	"
					+ "COUNT (*) FILTER (WHERE bse.status = 'TEACHING') AS teaching, "
					+ "	COUNT (*) FILTER (  		WHERE 			bse.status = 'CANCELLED' "
					+ "	) AS cancelled FROM 	batch_schedule_event bse, 	classroom_details cd WHERE"
					+ " 	cast (bse.eventdate as varchar) like '%"+aajKiDate+"%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER'"
							+ " AND bse.classroom_id = cd. ID ";

		}
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		System.out.println(sql);
		return items;
	}
	public List<HashMap<String, Object>> getTodaysEventData(int collegeId)
	{
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		String aajKiDate =dateformatto.format(new Date(System.currentTimeMillis())).toString();
		System.out.println(aajKiDate);
		DBUTILS dbutils = new DBUTILS();
		String sql1 = "SELECT DISTINCT 	batch_schedule_event.batch_id, course.course_name as title, batch_schedule_event.actor_id, CAST( batch_schedule_event.id as VARCHAR) AS event_id ,"
				+ " batch_schedule_event.eventdate, 	batch_schedule_event.eventhour, 	batch_schedule_event.status, 	batch. NAME AS batchname,"
				+ " 	batch_schedule_event.cmsession_id, 	 	classroom_details.classroom_identifier, "
				+ "	student. NAME AS trainername, 	case when student_profile_data.profile_image like 'null' OR student_profile_data.profile_image is null then 'http://api.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' ELSE 'http://api.talentify.in/'||student_profile_data.profile_image end AS trainer_image "
				+ "FROM 	batch_schedule_event "
				+ "JOIN batch ON (batch_schedule_event.batch_id = batch. ID) join course on (batch.course_id = course.id) JOIN classroom_details ON (batch_schedule_event.classroom_id = classroom_details. ID) "
				+ "JOIN student ON (batch_schedule_event.actor_id = student. ID) join student_profile_data on (student.id = student_profile_data.student_id) WHERE  batch_schedule_event.type != 'BATCH_SCHEDULE_EVENT_PRESENTOR' "
				+ "and batch_schedule_event.type != 'BATCH_SCHEDULE_EVENT_STUDENT' and 	batch_schedule_event.batch_id "
				+ "IN ( 		SELECT DISTINCT 			ID 		FROM 			PUBLIC .batch 		WHERE 			batch_group_id "
				+ "IN ( 				SELECT DISTINCT 					ID 				FROM 					batch_group 				"
				+ "WHERE 					college_id = "+collegeId+" 			) 	) AND CAST ( 	batch_schedule_event.eventdate AS VARCHAR ) LIKE '%"+aajKiDate+"%'";
		
		
		if(collegeId == -3 ) {
			sql1 = "SELECT DISTINCT batch_schedule_event.batch_id, course.course_name as title, batch_schedule_event.actor_id, CAST( batch_schedule_event.id as VARCHAR) AS event_id ,"
			+ " batch_schedule_event.eventdate, batch_schedule_event.eventhour, batch_schedule_event.status, batch. NAME AS batchname,"
			+ " batch_schedule_event.cmsession_id, classroom_details.classroom_identifier, "
			+ "	student. NAME AS trainername, case when student_profile_data.profile_image like 'null' OR student_profile_data.profile_image is null then 'http://api.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' ELSE 'http://api.talentify.in/'||student_profile_data.profile_image end AS trainer_image "
			+ "FROM batch_schedule_event "
			+ "JOIN batch ON (batch_schedule_event.batch_id = batch. ID) join course on (batch.course_id = course.id) JOIN classroom_details ON (batch_schedule_event.classroom_id = classroom_details. ID) "
			+ "JOIN student ON (batch_schedule_event.actor_id = student. ID) join student_profile_data on (student.id = student_profile_data.student_id) WHERE  batch_schedule_event.type != 'BATCH_SCHEDULE_EVENT_PRESENTOR' "
			+ "and batch_schedule_event.type != 'BATCH_SCHEDULE_EVENT_STUDENT' and batch_schedule_event.batch_id "
			+ "IN ( SELECT DISTINCT ID FROM PUBLIC .batch WHERE batch_group_id "
			+ "IN ( SELECT DISTINCT ID FROM batch_group "
			+ " ) ) AND CAST ( batch_schedule_event.eventdate AS VARCHAR ) LIKE '%"+aajKiDate+"%'";
			}

		List<HashMap<String, Object>> items = dbutils.executeQuery(sql1);
		System.out.println(sql1);
		return items;
	}
	
	
	public List<HashMap<String, Object>> getSlideLogs(String EventId)
	{
		String sql2 = "SELECT 	slide_id as slide_id, 	created_at as created_at FROM 	event_session_log WHERE 	cast (event_id as varchar) like '"+EventId+"' ORDER BY 	created_at";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
		
	}
	
	public 	List<HashMap<String, Object>> getSkillsForTrainer(int trainerId)
	{
		String sql2 = "select DISTINCT skill_objective.name from batch_schedule_event, course,batch, skill_objective where batch_schedule_event.actor_id = "+trainerId+" and batch_schedule_event.batch_id = batch.id and  batch.course_id = course.id and course.parent_skill_objective_id = skill_objective.id";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	public 	List<HashMap<String, Object>> getSessionsCompletedByTrainerInBatch(int trainerId, int batchId)
	{
		String sql2 = "select COALESCE(count(*),0) as sessions from event_session_log where trainer_id= "+trainerId+" and batch_id= "+batchId;
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	public 	List<HashMap<String, Object>> getStudentAttendanceStatus(String eventId)
	{
		String sql2 = "select attendance.status, student.name, case when student_profile_data.profile_image like 'null' OR student_profile_data.profile_image is null then 'http://api.talentify.in/video/android_images/'||upper( substring(student. NAME from 1 for 1))||'.png' ELSE 'http://api.talentify.in/'||student_profile_data.profile_image end as profile_image, (select count(*) from attendance where attendance.event_id = '"+eventId+"' and status ='ABSENT' ) as  absent , (select count(*) from attendance where attendance.event_id = '"+eventId+"' and status ='PRESENT' ) as  present from attendance, student,student_profile_data where attendance.event_id = '"+eventId+"' and attendance.user_id = student.id and student.id = student_profile_data.student_id ";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	public 	List<HashMap<String, Object>> getFeedbackDataForEvent(String eventId)
	{
		String sql2 = "SELECT rating,noise,attendance,sick, content ,  assignment , internals, internet, electricity,  time  FROM trainer_feedback where cast(event_id as varchar) = '"+eventId+"'";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	public 	StringBuffer getEventSessionLog(String eventId)
	{
		String sql2 = "SELECT url FROM trainer_event_log WHERE event_id = '"+eventId+"' ORDER BY created_at DESC LIMIT 1";
		System.err.println(sql2);
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql2);
		StringBuffer out = new StringBuffer();
		if(data != null && data.size() >0){
		for (HashMap<String, Object> item : data) {
			
			if(item.get("url") != null){
			
			out.append("<iframe id='session-iframe' style='width:100%; min-height: 73vh!important;pointer-events: none;' src='"+item.get("url")+"'></iframe>");
			}else{
				out.append("<p>No Event Session Log Found</p>");
			}
		}	
		}else{
			
			out.append("<p>No Event Session Log Found</p>");
		}
		System.out.println("eeeeeeeeeeeeeeeeeeeeeeeee"+out);
		return out;
	}
	
	public List<HashMap<String, Object>> getEvenetDetailsFromEvent(String eventId){
		String sql="SELECT DISTINCT 	batch_schedule_event.batch_id, 	course.course_name AS title, 	batch_schedule_event.actor_id, 	CAST ( 		batch_schedule_event. ID AS VARCHAR 	) AS event_id, 	 batch_schedule_event.eventdate, 	batch_schedule_event.eventhour, 	batch_schedule_event.status, 	batch. NAME AS batchname, 	 batch_schedule_event.cmsession_id, 	classroom_details.classroom_identifier, 	 student. NAME AS trainername, 	CASE WHEN student_profile_data.profile_image LIKE 'null' OR student_profile_data.profile_image IS NULL THEN 	'http://api.talentify.in/video/android_images/' || UPPER ( 		SUBSTRING (student. NAME FROM 1 FOR 1) 	) || '.png' ELSE 	'http://api.talentify.in/' || student_profile_data.profile_image END AS trainer_image FROM 	batch_schedule_event JOIN batch ON ( 	batch_schedule_event.batch_id = batch. ID ) JOIN course ON (batch.course_id = course. ID) JOIN classroom_details ON ( 	batch_schedule_event.classroom_id = classroom_details. ID ) JOIN student ON ( 	batch_schedule_event.actor_id = student. ID ) JOIN student_profile_data ON ( 	student. ID = student_profile_data.student_id ) WHERE 	batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT' AND batch_schedule_event.batch_id  IN ( 	SELECT DISTINCT 		ID 	FROM 		PUBLIC .batch 	WHERE 		batch_group_id  IN ( 			SELECT DISTINCT 				ID 			FROM 				batch_group 		) ) AND batch_schedule_event.id ='"+eventId+"'";
		System.err.println(sql);
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> events = dbutils.executeQuery(sql);
		return events;
	}
	
	
}
