package in.talentify.core.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.javabean.SuperAdminEvent;

public class SuperAdminUiUtils {

	
	public SuperAdminEvent getTodayAllEvent(){
	    Calendar c = Calendar.getInstance();        
	    c.add(Calendar.DATE, -156);  // number of days to add      

		SuperAdminEvent event = new SuperAdminEvent();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		DBUTILS db = new DBUTILS();
		String sql ="SELECT 	COUNT (*) AS total_count, 	COUNT (*) FILTER (WHERE status = 'SCHEDULED') AS schedule_count, 	COUNT (*) FILTER ( 		WHERE 			status = 'TEACHING' 		OR status = 'STARTED' 		OR status = 'ATTENDANCE' 		OR status = 'REACHED' 	) inprogress_count, 	COUNT (*) FILTER (WHERE status = 'COMPLETED') completed_count FROM 	batch_schedule_event WHERE 	cast(eventdate as varchar) like  '%"
				+ sdf.format(c.getTime()).toString()
				+ "%'";
		System.out.println("11--> "+sql);
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		event.setCompleted_event(Integer.parseInt(data.get(0).get("completed_count").toString()));
		event.setTotal_event(Integer.parseInt(data.get(0).get("total_count").toString()));
		event.setEvent_inprogress(Integer.parseInt(data.get(0).get("inprogress_count").toString()));
		event.setEvent_pending(Integer.parseInt(data.get(0).get("schedule_count").toString()));
		return event;
	}
	
	public JSONArray getCourseReportEvent(int course_id,String type) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer sb = new StringBuffer();
		String sql ="";
		if(type.equalsIgnoreCase("Program")){

		 sql = "SELECT 	DISTINCT bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	bse.batch_id AS batch_id, 	s. ID AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	student s, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	college org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID  AND B.course_id = " + course_id
				+ " AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate";
		}else{
			sql = "SELECT DISTINCT	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	bse.batch_id AS batch_id, 	s. ID AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	student s, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	college org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID  AND B.id = " + course_id
					+ " AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate";
		}
		//System.out.println("101 -> " + sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		System.out.println("102 -> " + data.size());

		ArrayList<CourseReportEvent> course_event_list = new ArrayList<>();
		for (HashMap<String, Object> item : data) {
			Date eventdate = null;
			try {
				eventdate = sdf.parse(item.get("eventdate").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if (eventdate != null) {
				CourseReportEvent course_report_event = new CourseReportEvent(item.get("event_name").toString(),
						sdf.format(eventdate), "#58D68D");
				course_event_list.add(course_report_event);
			} else {
				if (item.get("event_name") != null)
					System.out.println("Event not added due to dateformat issue " + item.get("event_name").toString());
			}
		}
		JSONArray arr_strJson = new JSONArray(course_event_list);
		// System.out.println(arr_strJson);

		return arr_strJson;
	}
	
	
}
