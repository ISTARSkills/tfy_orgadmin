/**
 * 
 */
package in.orgadmin.services;

import java.util.HashMap;
import java.util.List;

import com.istarindia.apps.dao.DBUTILS;

public class LogService {

	DBUTILS util = new DBUTILS();

	public List<HashMap<String, Object>> getIDAndStatus(String event_id) {
		// = new LinkedList<>();e85295ed-f4ba-4367-afdb-4f010279468d
		String get_id_status = "SELECT 	TEL.ID, 	TEL.event_status, 	student.name, 	student.email, 	batch.name as batch_name, 	TEL.created_at FROM 	trainer_event_log TEL left  join student on (student.id = TEL.trainer_id ) left join batch on (TEL.batch_id = batch.id) WHERE 	event_id = '"
				+ event_id + "' AND event_status != 'SLIDE_CHANGED' ORDER BY 	created_at;";
		List<HashMap<String, Object>> data = util.executeQuery(get_id_status);
		return data;
	}
	
	public List<HashMap<String, Object>> getIDAndStatusDashboard(String event_id) {
		// = new LinkedList<>();e85295ed-f4ba-4367-afdb-4f010279468d
		String get_id_status = "SELECT 	TEL. ID, 	TEL.event_status, 	student. NAME, 	student.email, 	batch. NAME AS batch_name, 	TEL.created_at FROM 	trainer_event_log TEL LEFT JOIN student ON (student. ID = TEL.trainer_id) LEFT JOIN batch ON (TEL.batch_id = batch. ID)"
				+ " WHERE 	event_id = '"+event_id+"' AND event_status = 'TEACHING'  ORDER BY 	created_at";
		List<HashMap<String, Object>> data = util.executeQuery(get_id_status);
		return data;
	}
	
	public List<HashMap<String, Object>> getSlideIDDashboard(String event_id) {
		// = new LinkedList<>();e85295ed-f4ba-4367-afdb-4f010279468d
		String get_id_status = "SELECT slide_id FROM event_session_log WHERE event_id='6d604fe6-1554-4c0e-bc37-263d8d61327d' ORDER BY created_at desc LIMIT 1";
		List<HashMap<String, Object>> data = util.executeQuery(get_id_status);
		return data;
	}

	public List<HashMap<String, Object>> getBasicDeatails(String event_id) {
		// = new LinkedList<>();e85295ed-f4ba-4367-afdb-4f010279468d
		String get_id_status = "SELECT DISTINCT 	student. NAME, 	student.email, 	batch. NAME AS batch_name, 	batch_schedule_event.eventdate, batch_schedule_event.eventhour,batch_schedule_event.eventminute	  FROM 	trainer_event_log TEL LEFT JOIN student ON (student. ID = TEL.trainer_id) LEFT JOIN batch ON (TEL.batch_id = batch. ID) left join batch_schedule_event ON (TEL.event_id = batch_schedule_event.id) WHERE 	event_id = '"
				+ event_id + "'  ";
		System.out.println(get_id_status);
		List<HashMap<String, Object>> data = util.executeQuery(get_id_status);
		return data;
	}

	public List<HashMap<String, Object>> getDetails(int lower, int high, String event_id) {
		// = new LinkedList<>();
		if (high == 0) {

			String get_last_id = "select max(id) as max_id from trainer_event_log where event_id = '" + event_id + "'";
			System.out.println(get_last_id);
			List<HashMap<String, Object>> data1 = util.executeQuery(get_last_id);
			if (data1.size() > 0) {
				high = (int) data1.get(0).get("max_id");
			}

		}

		String get_slide_details = "select course.course_name, cmsession.title as session_title, lesson.title as lesson_title, ppt_id, TEL.slide_id, slide.title as slide_title , TEL.created_at,module.module_name, TEL.url   from trainer_event_log TEL left join course on (course.id = TEL.course_id) left join cmsession on (cmsession.id = TEL.cmsession_id) left join module on (module.id = TEL.module_id) left join lesson on (lesson.id = TEL.lesson_id) left join slide on (slide.id = TEL.slide_id) where TEL.event_id ='"
				+ event_id + "' and TEL.event_status ='SLIDE_CHANGED' and TEL.id > " + lower + " and TEL.id <" + high
				+ "   order by TEL.created_at;";
		List<HashMap<String, Object>> data = util.executeQuery(get_slide_details);
		System.out.println(data.size());

		return data;
	}

}
