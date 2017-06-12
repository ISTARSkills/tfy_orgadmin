/**
 * 
 */
package in.orgadmin.dashboard.services;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * @author mayank
 *
 */
public class OrgAdminDashboardServices {
	
	public List<HashMap<String, Object>> getStundentFeedbackDataForEvent(int eventId)
	{
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object >> data = new ArrayList<>();
		String sql="SELECT 	cast ( avg(projector) as float8) as  projector, 	cast ( avg(internet) as float8) as  internet, 	cast ( avg(trainer_knowledge) as float8) as  trainer_knowledge, 	cast ( avg(trainer_too_fast) as float8) as  trainer_too_fast, 	cast ( avg(class_control_by_trainer) as float8) as  class_control_by_trainer, 	cast ( avg(too_tough_content) as float8) as  too_tough_content, 	cast ( avg(too_much_theoritic) as float8) as  too_much_theoritic, 	cast ( avg(no_fun_in_class) as float8) as  no_fun_in_class, 	cast ( avg(enough_examples) as float8) as  enough_examples, 	cast ( avg(outside_disturbance) as float8) as  outside_disturbance, 	cast ( avg(rating) as float8) as  rating FROM 	student_feedback where event_id = "+eventId+" group by event_id";
		data = util.executeQuery(sql);	
		return data;
	}
	
	public List<HashMap<String, Object>> learningObjectiveCoveredInEvent(int eventId)
	{
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object >> data = new ArrayList<>();
		String sql="select distinct skill_objective.name  as skills from assessment_benchmark, skill_objective, slide_change_log where slide_change_log.event_id = "+eventId+" and slide_change_log.lesson_id = assessment_benchmark.item_id and assessment_benchmark.item_type = 'LESSON' and assessment_benchmark.skill_objective_id = skill_objective.id order by skills";
		data = util.executeQuery(sql);	
		return data;
	}
	public List<HashMap<String, Object >> getSlideCount(String event_id)
	{
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object >> data = new ArrayList<>();
		String sql ="SELECT 	CAST ( 		COUNT (DISTINCT slide_id) AS INTEGER 	) AS slide_count FROM 	slide_change_log WHERE 	event_id = '"+event_id+"'";
		data = util.executeQuery(sql);	
		return data;
	}
	
	public List<HashMap<String, Object >> getCurrentCMSession(int batch_group_id, int course_id)
	{
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object >> data = new ArrayList<>();
		String sql =" select cmsession.title from cmsession, slide_change_log where slide_change_log.cmsession_id = cmsession.id and slide_change_log.course_id = "+course_id+" and slide_change_log.batch_group_id = "+batch_group_id+" order by slide_change_log.id desc limit 1";
		data = util.executeQuery(sql);
		if(data.size()>0 && data.get(0).get("title")!=null)
		{
			return data;
		}
		else
		{
			String sql2 ="SELECT 	cmsession.title FROM course, module_course, cmsession_module, 	cmsession, 	MODULE  WHERE course.id = module_course.course_id AND module_course.module_id = MODULE.id AND MODULE.id = cmsession_module.module_id AND cmsession.id = cmsession_module.cmsession_id  AND course. ID ="+course_id+" order by module_course.oid, cmsession_module.oid limit 1" ;
			data = util.executeQuery(sql2);
			return data;
		}
		
	}

	public List<HashMap<String, Object>> getTodaysEventStats(int collegeId) {
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		String aajKiDate = dateformatto.format(new Date(System.currentTimeMillis())).toString();
		System.out.println(aajKiDate);
		DBUTILS dbutils = new DBUTILS();
		String sql = "SELECT 	COUNT (*) AS totevent, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'COMPLETED' 	) AS completed, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'SCHEDULED' 	) AS scheduled, 	COUNT (*) FILTER (WHERE bse.status = 'TEACHING') AS teaching, 	COUNT (*) FILTER (  		WHERE 			bse.status = 'CANCELLED' 	) AS cancelled FROM 	batch_schedule_event bse, 	classroom_details cd WHERE 	cast (bse.eventdate as varchar) like '%"
				+ aajKiDate
				+ "%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND bse.classroom_id = cd. ID AND cd.organization_id = "
				+ collegeId + "";

		if (collegeId == -3) {
			sql = "SELECT 	COUNT (*) AS totevent, 	COUNT (*) FILTER (  		WHERE 	"
					+ "		bse.status = 'COMPLETED' 	) AS completed, 	COUNT (*) FILTER (  	"
					+ "	WHERE 			bse.status = 'SCHEDULED' 	) AS scheduled, 	"
					+ "COUNT (*) FILTER (WHERE bse.status = 'TEACHING') AS teaching, "
					+ "	COUNT (*) FILTER (  		WHERE 			bse.status = 'CANCELLED' "
					+ "	) AS cancelled FROM 	batch_schedule_event bse, 	classroom_details cd WHERE"
					+ " 	cast (bse.eventdate as varchar) like '%" + aajKiDate
					+ "%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER'" + " AND bse.classroom_id = cd. ID ";

		}
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		System.out.println(sql);
		return items;
	}

	public List<HashMap<String, Object>> getTodaysEventData(int collegeId) {
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		String aajKiDate = dateformatto.format(new Date(System.currentTimeMillis())).toString();
		System.out.println(aajKiDate);
		DBUTILS dbutils = new DBUTILS();
		String sql1 = "SELECT DISTINCT batch_schedule_event.batch_group_id,batch_schedule_event.course_id, course.course_name AS title, batch_schedule_event.actor_id, CAST ( batch_schedule_event. ID AS VARCHAR ) AS event_id, batch_schedule_event.eventdate, batch_schedule_event.eventhour, batch_schedule_event.status, batch_group. NAME AS batchname, batch_schedule_event.cmsession_id, classroom_details.classroom_identifier, user_profile.first_name AS trainername, CASE WHEN user_profile.profile_image LIKE 'null' OR user_profile.profile_image IS NULL THEN 'http://cdn.talentify.in/video/android_images/' || UPPER ( SUBSTRING ( user_profile.first_name FROM 1 FOR 1 ) ) || '.png' ELSE 'http://cdn.talentify.in/' || user_profile.profile_image END AS trainer_image FROM batch_schedule_event JOIN batch_group ON ( batch_schedule_event.batch_group_id = batch_group. ID ) JOIN course ON (batch_schedule_event.course_id = course. ID) JOIN classroom_details ON ( batch_schedule_event.classroom_id = classroom_details. ID ) JOIN user_profile ON ( batch_schedule_event.actor_id = user_profile.user_id ) WHERE batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT' AND batch_schedule_event.batch_group_id IN ( SELECT DISTINCT ID FROM batch_group WHERE college_id = "+collegeId+" ) AND CAST ( batch_schedule_event.eventdate AS VARCHAR ) LIKE '%"+aajKiDate+"%'";

		if (collegeId == -3) {
			sql1 = "SELECT DISTINCT batch_schedule_event.batch_group_id,batch_schedule_event.course_id, course.course_name AS title, batch_schedule_event.actor_id, CAST ( batch_schedule_event. ID AS VARCHAR ) AS event_id, batch_schedule_event.eventdate, batch_schedule_event.eventhour, batch_schedule_event.status, batch_group. NAME AS batchname, batch_schedule_event.cmsession_id, classroom_details.classroom_identifier, user_profile.first_name AS trainername, CASE WHEN user_profile.profile_image LIKE 'null' OR user_profile.profile_image IS NULL THEN 'http://cdn.talentify.in/video/android_images/' || UPPER ( SUBSTRING ( user_profile.first_name FROM 1 FOR 1 ) ) || '.png' ELSE 'http://cdn.talentify.in/' || user_profile.profile_image END AS trainer_image FROM batch_schedule_event JOIN batch_group ON ( batch_schedule_event.batch_group_id = batch_group. ID ) JOIN course ON (batch_schedule_event.course_id = course. ID) JOIN classroom_details ON ( batch_schedule_event.classroom_id = classroom_details. ID ) JOIN user_profile ON ( batch_schedule_event.actor_id = user_profile.user_id ) WHERE batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT'  AND CAST ( batch_schedule_event.eventdate AS VARCHAR ) LIKE '%"+aajKiDate+"%'";
		}

		System.out.println(sql1);
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql1);

		return items;
	}

	public List<HashMap<String, Object>> getSlideLogs(String EventId) {
		String sql2 = "SELECT 	slide_id AS slide_id, 	created_at AS created_at FROM 	slide_change_log  WHERE 	event_id = "+EventId+" ORDER BY 	created_at";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;

	}

	public List<HashMap<String, Object>> getSkillsForTrainer(int trainerId) {
		String sql2 = "select distinct skill_objective.name from trainer_skill_distrubution_stats, skill_objective where trainer_skill_distrubution_stats.skill_objective_id =  skill_objective.id and trainer_skill_distrubution_stats.trainer_id = 449 order by skill_objective.name ";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}

	public List<HashMap<String, Object>> getTotalHoursTaughtByTrainer(int trainerId) {
		String sql2 = "select sum (eventhour+(cast(eventminute as float)/60)) as sessions from batch_schedule_event where actor_id= "+trainerId;
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	
	public List<HashMap<String, Object>> getAverageFeedbackofTrainer(int trainerId)
	{
		String sql2 = "select cast ((case when (total_value is not null or total_value !=0)  then  (trainer_value*100)/ total_value else 0 end) as integer) as percentage  from    (select sum (trainer_specific) as trainer_value , total*25 as total_value from (select ( COALESCE(trainer_knowledge,'5')+ COALESCE(trainer_too_fast,'5')+ COALESCE(class_control_by_trainer,'5')+ COALESCE(no_fun_in_class,'5') + COALESCE(enough_examples,'5')) as trainer_specific, count(*)over() as total from student_feedback where trainer_id = "+trainerId+" )TF group by total )TFINAL  ";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}
	
	
	public List<HashMap<String, Object>> getSessionsCompletedByTrainerInBatch(int trainerId) {
		String sql2 = "select sum (eventhour+(cast(eventminute as float)/60)) as sessions from batch_schedule_event where actor_id= "+trainerId;
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}

	public List<HashMap<String, Object>> getStudentAttendanceStatus(String eventId) {
		String sql2 = "SELECT 	attendance.status, 	user_profile.first_name, 	CASE WHEN user_profile.profile_image LIKE 'null' OR user_profile.profile_image IS NULL THEN 	(select property_value from constant_properties where property_name ='media_url_path')||'/users/'||UPPER ( 		SUBSTRING ( 			user_profile.first_name 			FROM 				1 FOR 1 		) 	) || '.png' WHEN user_profile.profile_image LIKE '%graph.facebook.com%' 		THEN 			user_profile.profile_image ELSE 	(select property_value from constant_properties where property_name ='media_url_path') || user_profile.profile_image END AS profile_image,  ( 	SELECT 		COUNT (*) 	FROM 		attendance 	WHERE 		attendance.event_id = "+eventId+" 	AND status = 'ABSENT' ) AS ABSENT,  ( 	SELECT 		COUNT (*) 	FROM 		attendance 	WHERE 		attendance.event_id = "+eventId+" 	AND status = 'PRESENT' ) AS present FROM 	attendance, 	user_profile WHERE 	attendance.event_id = "+eventId+" AND attendance.user_id = user_profile.user_id ";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}

	public List<HashMap<String, Object>> getFeedbackDataForEvent(String eventId) {
		String sql2 = "SELECT 	rating, 	noise, 	attendance, 	sick, 	CONTENT, 	ASSIGNMENT, 	internals, 	internet, 	electricity, 	TIME FROM 	trainer_feedback WHERE 	event_id ="+eventId;
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> logs = dbutils.executeQuery(sql2);
		return logs;
	}

	public StringBuffer getEventSessionLog(String eventId) {
		String sql2 = "SELECT url FROM trainer_event_log WHERE event_id = '" + eventId
				+ "' ORDER BY created_at DESC LIMIT 1";
		System.err.println(sql2);
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql2);
		StringBuffer out = new StringBuffer();
		if (data != null && data.size() > 0) {
			for (HashMap<String, Object> item : data) {

				if (item.get("url") != null) {

					out.append(
							"<iframe id='session-iframe' style='width:100%; min-height: 73vh!important;pointer-events: none;' src='"
									+ item.get("url") + "'></iframe>");
				} else {
					out.append("<p>No Event Session Log Found</p>");
				}
			}
		} else {

			out.append("<p>No Event Session Log Found</p>");
		}
		System.out.println("eeeeeeeeeeeeeeeeeeeeeeeee" + out);
		return out;
	}

	public List<HashMap<String, Object>> getEvenetDetailsFromEvent(String eventId) {
		String sql = "SELECT DISTINCT batch_group.id as batch_group_id, batch_schedule_event.course_id AS course_id, course.course_name AS title, batch_schedule_event.actor_id, CAST ( batch_schedule_event. ID AS VARCHAR ) AS event_id, batch_schedule_event.eventdate, batch_schedule_event.eventhour, batch_schedule_event.status, batch_group. NAME AS batchname, batch_schedule_event.cmsession_id, classroom_details.classroom_identifier, user_profile.first_name AS trainername, CASE WHEN user_profile.profile_image LIKE 'null' OR user_profile.profile_image IS NULL THEN (select property_value from constant_properties where property_name = 'media_url_path')||'/users/' || UPPER ( SUBSTRING ( user_profile.first_name FROM 1 FOR 1 ) ) || '.png' ELSE (select property_value from constant_properties where property_name = 'media_url_path') || user_profile.profile_image END AS trainer_image FROM batch_schedule_event JOIN batch_group ON ( batch_schedule_event.batch_group_id = batch_group.id ) JOIN course ON (batch_schedule_event.course_id = course. ID) JOIN classroom_details ON ( batch_schedule_event.classroom_id = classroom_details. ID ) JOIN user_profile ON ( batch_schedule_event.actor_id = user_profile.user_id ) WHERE batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_PRESENTOR' AND batch_schedule_event. TYPE != 'BATCH_SCHEDULE_EVENT_STUDENT' AND batch_schedule_event. ID = "+eventId;
		System.err.println(sql);
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> events = dbutils.executeQuery(sql);
		return events;
	}

}
