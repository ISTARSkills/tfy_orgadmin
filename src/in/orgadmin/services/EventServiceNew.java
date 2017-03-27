package in.orgadmin.services;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.apps.dao.Batch;
import com.istarindia.apps.dao.BatchDAO;
import com.istarindia.apps.dao.BatchScheduleEvent;
import com.istarindia.apps.dao.BatchScheduleEventDAO;
import com.istarindia.apps.dao.ClassroomDetailsDAO;
import com.istarindia.apps.dao.Cmsession;
import com.istarindia.apps.dao.CmsessionDAO;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.Course;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Lesson;
import com.istarindia.apps.dao.LessonDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.service.EventService;
import com.istarindia.apps.service.NotificationService;
import com.publisher.utils.PublishDelegator;
import com.publisher.utils.PublishHandler;

public class EventServiceNew {

	
	static String[] suffixes =
			  //    0     1     2     3     4     5     6     7     8     9           *this is for date suffixes
			     { "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th",
			  //    10    11    12    13    14    15    16    17    18    19
			       "th", "th", "th", "th", "th", "th", "th", "th", "th", "th",
			  //    20    21    22    23    24    25    26    27    28    29
			       "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th",
			  //    30    31
			       "th", "st" };
	
	public int getCurrentLesson(int batch_id) {
		DBUTILS util = new DBUTILS();
		String sql = "select lesson_id  from event_session_log where batch_id=" + batch_id
				+ " order by id desc limit 1;";
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		if (res.size() > 0) {
			return (int) res.get(0).get("lesson_id");
		}
		return 0;
	}

	public List<HashMap<String, Object>> getLessons(int course_id) {
		DBUTILS util = new DBUTILS();
		String sql = "select lesson.id as id,  lesson.title as title, task.status as status from lesson, cmsession, module, course, task where lesson.session_id = cmsession.id and cmsession.module_id = module.id and course.id = module.course_id and task.item_id = lesson.id and task.status != 'DELETED' and task.item_type ='LESSON' and course.id = "
				+ course_id + " order by  lesson.title";
		System.out.println(sql);
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		return res;
	}

	public void createEvent(int trainer_id, String str_date, int session_id, int classroom_id, int batch_id, int hours,
			int min) {
		int duration_hour = hours;
		int duration_min = min;
		DateFormat formatter;
		Date eventdate = null;
	
		formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		try {
			eventdate = formatter.parse(str_date);

		} catch (ParseException e) {
			
			e.printStackTrace();
		}
		
		DateFormat formatter1 = new SimpleDateFormat ("MMM");
		DateFormat formatter2 = new SimpleDateFormat ("hh:mm a");
		DateFormat formatDayOfMonth  = new SimpleDateFormat("d");
		int day = Integer.parseInt(formatDayOfMonth.format(eventdate));
		 String dayStr = day + suffixes[day];
		 String n_date =  formatter1.format(eventdate);
		String n_time =  formatter2.format(eventdate);
		System.out.println("----------------------------"+n_time);
		System.out.println("---------------new-------------"+n_date+" "+dayStr);

		// new EventService().createBatchScheduleEventLatest("TEST", trainer_id,
		// eventdate, duration_hour, duration_min, session_id, classroom_id,
		// batch_id);
		//new EventService().createBatchScheduleEventLatest("REAL", trainer_id, eventdate, duration_hour, duration_min,
			//	session_id, classroom_id, batch_id);
		Batch b = new BatchDAO().findById(batch_id);
		College org = b.getBatchGroup().getCollege();
		Course c = b.getCourse();
	
		
		
	
		
		String details = "Scheduled session of  " + c.getCourseName() + ". Duration of session: "
				+ (duration_hour * 60 + duration_min) + " mins";
		
		String title = "Scheduled session of  " + c.getCourseName() + ". Duration of session: "
				+ (duration_hour * 60 + duration_min) + " mins";
		
		String title_new ="Event: Scheduled on "+n_date+" "+dayStr;
		
		String details_new = ""+c.getCourseName()+": at "+n_time;
		
		
		//System.out.println("-----------------------------------------"+title_new);
		//System.out.println("-----------------------------------------"+details_new);
		String evnet_name =
				"REAL EVENT FOR CLASS-" + org.getName() + "-Ilab-" + c.getCourseName();
		
		
		DBUTILS util = new DBUTILS();
		String sql ="WITH ins1 AS ( 	INSERT INTO event_queue (event_name, batch_id) 	VALUES 		( 			'event_queue_'||"+batch_id+", 			"+batch_id+" 		) RETURNING ID ),"
				+ "  ins2 AS ( 	INSERT INTO batch_schedule_event ( 		actor_id, 		created_at, 		creator_id, 		eventdate, 		eventhour, 		eventminute, 		isactive, 		TYPE, 		updated_at, 		task_id, 		status, 		ACTION, 		cmsession_id, 		batch_id, 		event_name, 		classroom_id 	) SELECT 		"+trainer_id+", 		now(), 		"+trainer_id+", 		'"+eventdate+"', 		"+duration_hour+", 		"+duration_min+", 		't', 		'BATCH_SCHEDULE_EVENT_TRAINER', 		now(), 		ins1.ID, 		'SCHEDULED', 		'cmsession_id__-1', 		"+session_id+", 		"+batch_id+", 		'"+evnet_name+"', 		"+classroom_id+" 	FROM 		ins1 RETURNING ID ),  "
				+ "ins3 AS ( 	INSERT INTO batch_schedule_event ( 		actor_id, 		created_at, 		creator_id, 		eventdate, 		eventhour, 		eventminute, 		isactive, 		TYPE, 		updated_at, 		task_id, 		status, 		ACTION, 		cmsession_id, 		batch_id, 		event_name, 		classroom_id 	) SELECT 		( 			SELECT 				presentor_id 			FROM 				trainer_presentor 			WHERE 				trainer_id = "+trainer_id+" 		), 		now(), 		"+trainer_id+", 		'"+eventdate+"', 		"+duration_hour+", 		"+duration_min+", 		't', 		'BATCH_SCHEDULE_EVENT_PRESENTOR', 		now(), 		ins1.ID, 		'SCHEDULED', 		'cmsession_id__-1', 		"+session_id+", 		"+batch_id+", 		'"+evnet_name+"', 		"+classroom_id+" 	FROM 		ins1 RETURNING ID ),  "
				+ "ins4 AS ( 	INSERT INTO event_queue_events ( 		event_queue_id, 		event_for, 		user_id, 		event_id, 		created_at, 		updated_at 	) SELECT 		ins1. ID, 		'Trainer Event: "+evnet_name+"', 		"+trainer_id+", 		ins2. ID, 		now(), 		now() 	FROM 		ins1, 		ins2 ),"
				+ "  ins5 AS ( 	INSERT INTO event_queue_events ( 		event_queue_id, 		event_for, 		user_id, 		event_id, 		created_at, 		updated_at 	) SELECT 		ins1. ID, 		'Presenter Event: "+evnet_name+"', 		( 			SELECT 				presentor_id 			FROM 				trainer_presentor 			WHERE 				trainer_id = "+trainer_id+" 		), 		ins3. ID, 		now(), 		now() 	FROM 		ins1, 		ins3 ), "
				+ " ins6 AS ( 	INSERT INTO istar_notification ( 		event_id, 		sender_id, 		receiver_id, 		title, 		details, 		status, 		ACTION, 		TYPE, 		is_event_based, 		created_at 	) SELECT 		ins2. ID, 		"+trainer_id+", 		"+trainer_id+", 		'"+title_new+"', 		'"+details_new+"', 		'UNREAD', 		'NONE', 		'BATCH_SCHEDULE_EVENT_TRAINER', 		't', 		now() 	FROM 		ins2 ) INSERT INTO event_workflow_status ( 	event_id, 	status, 	created_at, 	updated_at, 	user_id ) SELECT 	ins2. ID, 	'SCHEDULED', 	now(), 	now(), 	"+trainer_id+" FROM 	ins2;";
		util.executeUpdate(sql);
		System.out.println(sql);
		
		
			PublishDelegator pd = new PublishDelegator();
	    	pd.sendNotification(trainer_id,title_new+" \n"+details_new,"EVENT", "PLAY_EVENT_WORKFLOW", eventdate.toString());				
		
		

	}

	public HashMap<Integer, String> getBatches() {
		HashMap<Integer, String> sessions = new HashMap<>();
		DBUTILS util = new DBUTILS();
		String sql = "select B.id as id, O.name as org_name,  B.name as batch_name from batch B, batch_group BG, organization O where O.id = BG.college_id and B.batch_group_id = BG.id";
		List<HashMap<String, Object>> res = util.executeQuery(sql);

		for (HashMap<String, Object> sess : res) {
			int id = (int) sess.get("id");
			String org_name = (String) sess.get("org_name");
			String batch_name = (String) sess.get("batch_name");

			sessions.put(id, org_name + "-" + batch_name);
		}

		return sessions;
	}

	public HashMap<Integer, String> getClassrooms() {
		HashMap<Integer, String> sessions = new HashMap<>();
		DBUTILS util = new DBUTILS();
		String sql = "select CD.id, O.name, CD.classroom_identifier from classroom_details CD, organization O where CD.organization_id = O.id ";
		List<HashMap<String, Object>> res = util.executeQuery(sql);

		for (HashMap<String, Object> sess : res) {
			int id = (int) sess.get("id");
			String class_name = (String) sess.get("classroom_identifier");
			String org_name = (String) sess.get("name");

			sessions.put(id, org_name + "-" + class_name);
		}

		return sessions;
	}

	public HashMap<Integer, String> getClassrooms(int batchID) {

		HashMap<Integer, String> sessions = new HashMap<>();
		DBUTILS util = new DBUTILS();
		String sql = "SELECT CD. ID, O. NAME, CD.classroom_identifier FROM classroom_details CD, college O, batch, batch_group WHERE CD.organization_id = O. ID and  batch.batch_group_id=batch_group.id and batch_group.college_id=o.id and batch.id="
				+ batchID;
		// String sql = "select CD.id, O.name, CD.classroom_identifier from
		// classroom_details CD, organization O where CD.organization_id = O.id
		// ";
		List<HashMap<String, Object>> res = util.executeQuery(sql);

		for (HashMap<String, Object> sess : res) {
			int id = (int) sess.get("id");
			String class_name = (String) sess.get("classroom_identifier");
			String org_name = (String) sess.get("name");

			sessions.put(id, org_name + "-" + class_name);
		}

		return sessions;
	}

	public HashMap<Integer, String> getPublishedSession() {
		HashMap<Integer, String> sessions = new HashMap<>();
		DBUTILS util = new DBUTILS();
		String sql = "select C.course_name, CM.id , CM.title from cmsession CM, course C, lesson L, task T, module  M where C.id = M.course_id and M.id = CM.module_id and  CM.id = L.session_id and T.item_id = L.id and T.item_type ='LESSON' and T.status='PUBLISHED'";
		List<HashMap<String, Object>> res = util.executeQuery(sql);

		for (HashMap<String, Object> sess : res) {
			int id = (int) sess.get("id");
			String session_name = (String) sess.get("title");
			String course_name = (String) sess.get("course_name");

			sessions.put(id, course_name + "-" + session_name);
		}

		return sessions;
	}

	public HashMap<Integer, String> getAllSession() {
		HashMap<Integer, String> sessions = new HashMap<>();
		DBUTILS util = new DBUTILS();
		String sql = "SELECT 	C .course_name, 	CM. ID, 	CM.title FROM 	cmsession CM, 	course C, 	lesson L, 	task T, 	MODULE M WHERE 	C . ID = M .course_id AND M . ID = CM.module_id AND CM. ID = L.session_id AND T .item_id = L. ID AND T .item_type = 'LESSON'";
		List<HashMap<String, Object>> res = util.executeQuery(sql);

		for (HashMap<String, Object> sess : res) {
			int id = (int) sess.get("id");
			String session_name = (String) sess.get("title");
			String course_name = (String) sess.get("course_name");

			sessions.put(id, course_name + "-" + session_name);
		}

		return sessions;
	}

	public HashMap<Integer, String> getAllSession(int batchID) {
		HashMap<Integer, String> sessions = new HashMap<>();
		DBUTILS util = new DBUTILS();
		String sql = "SELECT C .course_name, CM. ID, CM.title FROM cmsession CM, course C, lesson L, task T, MODULE M, batch WHERE C . ID = M .course_id AND M . ID = CM.module_id AND CM. ID = L.session_id AND T .item_id = L. ID AND T .item_type = 'LESSON' and batch.course_id=c.id and batch.id="
				+ batchID + " and t.status='PUBLISHED'";
		List<HashMap<String, Object>> res = util.executeQuery(sql);

		for (HashMap<String, Object> sess : res) {
			int id = (int) sess.get("id");
			String session_name = (String) sess.get("title");
			String course_name = (String) sess.get("course_name");

			sessions.put(id, course_name + "-" + session_name);
		}

		return sessions;
	}

	public static void updateEvent(String event_id, String event_date, int trainer_id, int session_id, int class_id,
			int hours, int min) {
		String query= "select cast(id as varchar(50)), type from batch_schedule_event BSE where id in (select event_id from event_queue_events where event_queue_id in (select event_queue_id from event_queue_events where event_id='"+event_id+"'))";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(query);
		 
		BatchScheduleEventDAO dao = new BatchScheduleEventDAO();
		Date old_Date= null;
		for(HashMap<String, Object> row: data)
		{
			String ev_id = (String) row.get("id");
			
			System.out.println("--------------------------------------------"+ev_id);
			
			BatchScheduleEvent bse = dao.findById(UUID.fromString(ev_id));
			old_Date = bse.getEventdate();
			String final_sql = "";
			//String final_upd = "";
			if(bse.getType().equalsIgnoreCase("BATCH_SCHEDULE_EVENT_TRAINER"))
			{
				String sql_t = "UPDATE batch_schedule_event SET actor_id="+trainer_id+", eventdate='"+event_date+"',eventhour="+hours+",eventminute="+min+",cmsession_id="+session_id+",action= 'cmsession_id__"+session_id+"',classroom_id="+class_id+" WHERE id='"+ev_id+"'";
				
				String update_t = "UPDATE event_queue_events SET user_id = "+trainer_id+" WHERE event_id = '"+ev_id+"'";
				final_sql+=sql_t;
				final_sql+=";"+update_t;

			}
			else if(bse.getType().equalsIgnoreCase("BATCH_SCHEDULE_EVENT_PRESENTOR"))
			{
				String sql1 = "select presentor_id from trainer_presentor where trainer_id="+trainer_id;
				List<HashMap<String, Object>> data1 = util.executeQuery(sql1);
			    String presentor_id =  data1.get(0).get("presentor_id").toString();		
					
				String sql_p = "UPDATE batch_schedule_event SET actor_id="+presentor_id+", eventdate='"+event_date+"',eventhour="+hours+",eventminute="+min+",cmsession_id="+session_id+",action= 'cmsession_id__"+session_id+"',classroom_id="+class_id+" WHERE id='"+ev_id+"'";								
				
				String update_p = "UPDATE event_queue_events SET user_id = "+presentor_id+" WHERE event_id = '"+ev_id+"'";
				final_sql+=";"+sql_p;
				final_sql+=";"+update_p;

			}
			util.executeUpdate(final_sql);
			DateFormat formatter ;
			
			Date eventdate =null; 
			   formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			   
			   try {
				   eventdate = formatter.parse(event_date);
				
				
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			    Batch b = new BatchDAO().findById(bse.getBatch().getId());
				College org = b.getBatchGroup().getCollege();
				Course c = b.getCourse();
				
				DateFormat formatter1 = new SimpleDateFormat ("MMM");
				DateFormat formatter2 = new SimpleDateFormat ("hh:mm a");
				DateFormat formatDayOfMonth  = new SimpleDateFormat("d");
				int day = Integer.parseInt(formatDayOfMonth.format(eventdate));
				 String dayStr = day + suffixes[day];
				 String n_date =  formatter1.format(eventdate);
				String n_time =  formatter2.format(eventdate);
				System.out.println("----------------------------"+n_time);
				System.out.println("---------------new-------------"+n_date+" "+dayStr);
				
				
				String title_new ="Event: Re-Scheduled on "+n_date+" "+dayStr;
				
				String details_new = ""+c.getCourseName()+": at "+n_time;
				
				System.out.println("-----------------------------------------"+title_new);
				System.out.println("-----------------------------------------"+details_new);
			   
			   bse.setEventdate(eventdate);
			   if(bse.getType().equalsIgnoreCase("BATCH_SCHEDULE_EVENT_TRAINER"))
				{
			   String sql_n = "INSERT INTO istar_notification ( 	 	event_id, 	sender_id, 	receiver_id, 	title, 	details, 	status, 	action, 	type, 	is_event_based, 	created_at ) VALUES 	( 		 		'"+event_id+"', 		"+trainer_id+", 		"+trainer_id+", 		'"+title_new+"', 		'"+details_new+"', 		'UNREAD', 		'NONE', 		'BATCH_SCHEDULE_EVENT_TRAINER', 		't', 		now() 	);";
			   util.executeUpdate(sql_n);
			   System.out.println(sql_n);
			   
				PublishDelegator pd = new PublishDelegator();
				pd.sendNotification(bse.getActor().getId(),title_new+" \n"+details_new,"EVENT","NO_ID", eventdate.toString());
				System.out.println("-----------------------------------------sent");
				}
			  
			   
			//String details = "Classroom Event for batch "+ bse.getBatch().getName()+" has been reschedule from "+todate.format(old_Date)+" to "+todate.format(eventdate);
			//String title ="Event for batch "+bse.getBatch().getName()+" has been rescheduled.";
			
		
					
			}

	}

}
