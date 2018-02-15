/**
 * 
 */
package tfy.admin.farzidata.services;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.github.javafaker.Faker;
import com.istarindia.android.pojo.AssessmentPOJO;
import com.istarindia.android.pojo.ClassFeedbackByTrainer;
import com.istarindia.android.pojo.FeedbackPojo;
import com.istarindia.android.pojo.GroupPojo;
import com.istarindia.android.pojo.GroupStudentPojo;
import com.istarindia.android.pojo.OptionPOJO;
import com.istarindia.android.pojo.QuestionPOJO;
import com.istarindia.android.pojo.QuestionResponsePOJO;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.AssessmentOption;
import com.viksitpro.core.dao.entities.AssessmentQuestion;
import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchDAO;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.BatchStudents;
import com.viksitpro.core.dao.entities.ClassroomDetails;
import com.viksitpro.core.dao.entities.ClassroomDetailsDAO;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.QuestionDAO;
import com.viksitpro.core.dao.entities.Report;
import com.viksitpro.core.dao.entities.ReportDAO;
import com.viksitpro.core.dao.entities.StudentAssessment;
import com.viksitpro.core.dao.entities.StudentAssessmentDAO;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.dao.entities.TaskDAO;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;
import com.viksitpro.core.utilities.TaskItemCategory;
import com.viksitpro.core.utilities.TrainerWorkflowStages;

import tfy.admin.services.StudentPlayListServicesAdmin;
import tfy.admin.services.StudentSkillMapService;

/**
 * @author ISTAR-SKILL
 *
 */
public class FarziDataCreatorServices {
	
	public static int getRandomInteger(int maximum, int minimum) {
		return ((int) (Math.random() * (maximum - minimum))) + minimum;
	}
	
	public int createOrganization(String name)
	{
		DBUTILS db = new DBUTILS();
		String sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) "
				+ "VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), 'Phase 2', 'Manyata Tech Park', 154819, '73.8834149', '18.4866277' )RETURNING ID;";
		int addressId = db.executeUpdateReturn(sql);

		sql = "INSERT INTO organization (id, name, org_type, address_id, industry, profile,created_at, updated_at, iscompany, max_student) VALUES "
				+ "((select COALESCE(max(id),0)+1 from organization ), '"+name.trim().replace("'", "")+"', 'COLLEGE', "+addressId+", 'EDUCATION', 'NA',  now(), now(), 'f',1000) RETURNING ID;";
		int college_id = db.executeUpdateReturn(sql);
		
		createOrgAdmin(college_id);
		
		return college_id;		
	}
	
	private void createOrgAdmin(int college_id) {
		
		DBUTILS db = new DBUTILS();
		Faker faker = new Faker();

		String name = faker.name().fullName();
		String firstName = faker.name().firstName().replace("'", "");
		String lastName = faker.name().lastName().replace("'", "");
		String email = faker.name().firstName().toLowerCase()+""+getRandomInteger(10000, 1)+"@istarindia.com".replace("'", "");
		String mobile = faker.number().digits(10);
		
		
		String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) "
				+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+email+"', 'test123', 		now(), 		'"+mobile+"', 		NULL,    'f' 	)RETURNING ID;";
		
		//ViksitLogger.logMSG(this.getClass().getName(),istarStudentSql);
		int userID  = db.executeUpdateReturn(istarStudentSql);
			
		String insertIntoUserProfile ="INSERT INTO user_profile (id, first_name, last_name,  gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"+firstName+"', '"+lastName+"', 'MALE', "+userID+");";
		db.executeUpdate(insertIntoUserProfile);

		//Student User Role Mapping
			String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
			//ViksitLogger.logMSG(this.getClass().getName(),userRoleMappingSql);
			db.executeUpdate(userRoleMappingSql);
			String insertIntoOrgMapping="INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("+userID+", "+college_id+", (select COALESCE(max(id),0)+1 from user_org_mapping));"; 
			db.executeUpdate(insertIntoOrgMapping);					
	}

	public int createBGsInOrganization(int orgId, int studentCount, String bgName)
	{
		DBUTILS util = new DBUTILS();
		String insertInToBG ="INSERT INTO batch_group (id, created_at, name, updated_at, college_id, batch_code, assessment_id, bg_desc, year, parent_group_id, type, is_primary, is_historical_group, mode_type, start_date, enrolled_students) "
				+ "VALUES ((select COALESCE(max(id), 0)+1 from batch_group), now(), '"+bgName.replace("'", "").trim()+"', now(), "+orgId+", '"+getRandomInteger(100000, 999999)+"', '10195', '"+bgName.replace("'", "").trim()+"', '2017', '-1', 'SECTION', 't', 'f', 'BLENDED', '2017-08-04', "+studentCount+") returning id;";
		int bgId = util.executeUpdateReturn(insertInToBG);
		
		ArrayList<Integer>  users = createStudentInOrg(orgId, studentCount);
		for(int userId : users)
		{
			mapStudentInBG(bgId, userId);
		}
		return bgId;
	}
	
	
	private void mapStudentInBG(int bgId, int userId) {
		DBUTILS util = new DBUTILS();
		String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0)+1 from batch_students)),"
				+ bgId + "," + userId + ",'STUDENT')";
		ViksitLogger.logMSG(this.getClass().getName(),insert_into_bg);
		util.executeUpdate(insert_into_bg);		
	}
	
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

		ClassroomDetails classRoom = new ClassroomDetailsDAO().findById(classroomID);		
		String evnetName = "REAL EVENT FOR CLASS-" + org.getName() + "-Ilab-" + c.getCourseName();		
		IstarNotificationServices notificationService = new IstarNotificationServices();
		DBUTILS db = new DBUTILS();
		//AndroidNoticeDelegator noticeDelegator = new AndroidNoticeDelegator();
		String ssql = "SELECT count(*) as tcount FROM trainer_batch WHERE trainer_id= " + trainerID + " AND batch_id ="+ batchID;

		List<HashMap<String, Object>> data = db.executeQuery(ssql);

		if (Integer.parseInt(data.get(0).get("tcount").toString()) == 0) {

			String trainerBatchSql = "INSERT INTO trainer_batch ( 	id, 	batch_id, 	trainer_id ) VALUES 	((SELECT COALESCE (MAX(ID) + 1, 1) 	FROM 	trainer_batch ) , "
					+ batchID + ", " + trainerID + ");";

			db.executeUpdate(trainerBatchSql);
			//ViksitLogger.logMSG(this.getClass().getName(),"trainerBatchSql-----> "+trainerBatchSql);

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
		String notificationTitle = "A class has been scheduled for the course <b>"+c.getCourseName()+ "</b> in <b>"+org.getName()+"</b> at <b>"+eventDate+"</b>";
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
		//noticeDelegator.sendNotificationToUser(istarNotification.getId(), trainerID+"", notificationTitle.trim().replace("'", ""), NotificationType.CLASSROOM_SESSION, item);  
		
		if(presentorID!=null){
		String insertPresentorEvent ="INSERT INTO batch_schedule_event ( actor_id, created_at, creator_id, eventdate, eventhour, eventminute, isactive, TYPE, updated_at, ID, status, ACTION, cmsession_id, batch_group_id, course_id, event_name, classroom_id, associate_trainee, batch_group_code ) "
				+ "VALUES ( "+presentorID+", now(), "+AdminUserID+", '"+eventDate+"', "+hours+", "+minute+", 't', 'BATCH_SCHEDULE_EVENT_PRESENTOR', now(), ( SELECT COALESCE (MAX(ID) + 1, 1) FROM batch_schedule_event ), 'SCHEDULED', 'cmsession_id__-1', - 1, "+b.getBatchGroup().getId()+", "+c.getId()+", '"+evnetName+"', "+classroomID+", '"+associateTrainerID+"','"+groupNotificationCode+"' ) RETURNING ID";		
		int presentorEventId = db.executeUpdateReturn(insertPresentorEvent) ; 
			userToEventMap.put(presentorID, presentorEventId);
			String createTaskForPresentor ="INSERT INTO task ( ID, NAME, OWNER, actor, STATE, start_date, end_date, is_active, created_at, updated_at, item_id, item_type , project_id) values (( SELECT COALESCE (MAX(ID), 0) + 1 FROM task ), '"+notificationTitle+"', "+AdminUserID+", "+presentorID+", 'SCHEDULED', CAST ( '"+eventDate+"' AS TIMESTAMP ), CAST ( '("+eventDate+")' AS TIMESTAMP ) + INTERVAL '1' MINUTE * ("+hours+" * 60 + "+minute+"), 't', now(), now(), "+presentorEventId+", '"+TaskItemCategory.CLASSROOM_SESSION_PRESENTOR+"',"+projectId+") returning id ;";
			int taskIdForPresentor = db.executeUpdateReturn(createTaskForPresentor);				
			
		}
		
		String findStudentInBatch ="select distinct batch_students.student_id from batch_students,batch_group, batch where batch.batch_group_id = batch_group.id and batch_group.id = batch_students.batch_group_id and batch_group.is_historical_group ='f' and batch.id = "+batchID;
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
			notificationTitle = "A class has been scheduled for the course <b>"+c.getCourseName()+ "</b> in classroom <b>"+classRoom.getClassroomIdentifier().trim().replace("'", "")+"</b>";
			notificationDescription =  notificationTitle;
		
			IstarNotification istarNotificationForStudent = notificationService.createIstarNotification(AdminUserID, stuId, notificationTitle.trim().replace("'", ""), notificationDescription.trim().replace("'", ""), "UNREAD", null, NotificationType.CLASSROOM_SESSION_STUDENT, true, taskIdForStudent, groupNotificationCode);
			HashMap<String, Object> itemForStudent = new HashMap<String, Object>();
			
			itemForStudent.put("taskId", taskIdForStudent);
		}
		
		
		for(Integer userKey : userToEventMap.keySet())
		{
			String mapWithQueue ="INSERT INTO event_queue_event_mapping ( ID, event_queue_id, event_for, user_id, event_id, created_at, updated_at ) values ( ( SELECT COALESCE (MAX(ID) + 1, 1) FROM event_queue_event_mapping ), "+masterEventQueueId+", 'mapping for "+eventQueueName+" ', "+userKey+", "+userToEventMap.get(userKey)+", now(), now() )";
			db.executeUpdate(mapWithQueue);
		}
		

	}

	public ArrayList<Integer> createStudentInOrg(int orgId, int studentCount)
	{
		ArrayList<Integer> users = new ArrayList<>();
		DBUTILS db = new DBUTILS();
		for(int i=0;i<studentCount;i++)
		{
			Faker faker = new Faker();

			String name = faker.name().fullName();
			String firstName = faker.name().firstName().replace("'", "");
			String lastName = faker.name().lastName().replace("'", "");
			String email = faker.name().firstName().toLowerCase()+"@istarindia.com".replace("'", "");
			String mobile = faker.number().digits(10);
			
			String checkIfEmailExist ="select cast (count(*) as integer) as cnt from istar_user where email ='"+email+"'";
			List<HashMap<String, Object>> checkData = db.executeQuery(checkIfEmailExist);
			if(checkData.size()>0 && checkData.get(0).get("cnt")!=null && (int)checkData.get(0).get("cnt")==0)
			{
				String sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), 'Phase 2', 'Manyata Tech Park', 154819, '73.8834149', '18.4866277' )RETURNING ID;";
				int addressId = db.executeUpdateReturn(sql);
				
				String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email.replace("'", "")+"', 		'test123', 		now(), 		'"+mobile+"', 		NULL,    'f' 	)RETURNING ID;";
				ViksitLogger.logMSG(this.getClass().getName(),istarStudentSql);
							
				 int userID  = db.executeUpdateReturn(istarStudentSql);
								

							//Student User Role Mapping
				String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name = 'STUDENT'), (SELECT MAX(id)+1 FROM user_role), '1');";
				ViksitLogger.logMSG(this.getClass().getName(),userRoleMappingSql);
				db.executeUpdate(userRoleMappingSql);
								
								//Trainer Student  User Profile
				String UserProfileSql = "INSERT INTO user_profile ( 	id, 	address_id, 	first_name, 	last_name, 	dob, 	gender, 	user_id, 	aadhar_no ) VALUES 	( 		(SELECT MAX(id)+1 FROM user_profile), 		"+addressId+", 		'"+firstName+"', 		'"+lastName+"', 	NULL,	'MALE',   "+userID+", 		NULL 	); ";
				ViksitLogger.logMSG(this.getClass().getName(),UserProfileSql);
				db.executeUpdate(UserProfileSql);
								

				//Trainer Student User Org Mapping
				String userOrgMappingSql = "INSERT INTO user_org_mapping ( 	user_id, 	organization_id, 	id ) VALUES 	("+userID+", "+orgId+", (SELECT MAX(id)+1 FROM user_org_mapping));";
				ViksitLogger.logMSG(this.getClass().getName(),userOrgMappingSql);
				db.executeUpdate(userOrgMappingSql);
				
				users.add(userID);
					
			}

		}
		return users;
	}
	
	
	
	public void addCourseInGroup (int bgId, int courseId)
	{
		DBUTILS db = new DBUTILS();
		BatchGroup bg = new BatchGroupDAO().findById(bgId);
		Course c = new CourseDAO().findById(courseId);
		
		String batchGroupName = bg.getName();
		String courseName = c.getCourseName();
		String batchName=batchGroupName+"_"+courseName;
		
		String sql="select * from batch where batch_group_id="+bgId+" and course_id="+courseId;
		ViksitLogger.logMSG(this.getClass().getName(),sql);
		
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		
		if(data.size()==0){
		sql = "INSERT INTO batch ( 	ID, 	createdat, 	NAME, 	updatedat, 	batch_group_id, 	course_id ) VALUES 	((select COALESCE(max(id),0)+1 from batch) 		, 		'now()', 		'"+batchName+"', 		'now()', 		'"+bgId+"', 		'"+courseId+"')returning id";
		ViksitLogger.logMSG(this.getClass().getName(),sql);
		int batchId = (int) db.executeUpdateReturn(sql);
		
		sql="UPDATE batch SET order_id='"+batchId+"' WHERE (id='"+batchId+"')";
		ViksitLogger.logMSG(this.getClass().getName(),sql);
		db.executeUpdate(sql);				
		}
	}
	
	
	public int createTaskForDate(String name, String description, String owner, String actor, String itemId, String itemType, String date)
	{
		DBUTILS util = new DBUTILS();
		String sql ="INSERT INTO task (id, name, description, owner, actor, state,  start_date, end_date, is_active,  created_at, updated_at, item_id, item_type) "
				+ "VALUES ((select COALESCE(max(id),0) +1 from task), '"+name+"', '"+description+"', "+owner+", "+actor+", 'SCHEDULED', '"+date+"','"+date+"', 't', '"+date+"', '"+date+"', "+itemId+", '"+itemType+"') returning id;";
		int taskId = util.executeUpdateReturn(sql);		
		return taskId ;
	}
	public static void main(String args [])
	{		
		
		FarziDataCreatorServices serv = new FarziDataCreatorServices();
		String orgName = "THE FERN HOTELS & RESORTS";
		
		String[] batches = {"Meluha The Fern Mumbai","The Fern Ahmedabad","Mansarovar The Fern Hyderabad","The Fern Jaipur","The Fern Hotel Goregaon","Rodas Hotel","The Fern Residency Chembur","The Fern Bhavnagar","The Fern Gir Forest Resort Sasan Gir","The Fern Kadamba","The Fern Residency Somnath","The Wall Street Hotel Jaipur","The Fern Residency Galaxy Mall Asansol","The Fern Residency Jodhpur","The Fern Residency Kolkata","The Fern Residency Rajkot","Howard Plaza The Fern Agra","The Fern Residency Udaipur","The Fern Hillside Resort Bhimtal","Samanvay Udupi","The Fern Residency Mundra","The Fern Residency MIDC Pune","Maia Beacon Residences Bangalore","T2 Beacon Mumbai","Mystique Heights Beacon","The Fern Samali Resort Dapoli","The Fern Residency Vadodra","The Fern Residency an Ecotel Gurgaon","The Royal Melange Beacon Ajmer","The Fern Residency Chandigarh","The Gardenia Resort","Alibaug","The Fern Amanora Pune","Amritsar Surya Beacon","Grand Ashirwad Beacon Bhopal" };
		int[] batcheCounts = {68 ,32 ,36 ,32 ,40 ,20 ,24 ,32 ,20 ,29 ,24 ,15 ,26 ,24 ,22 ,32 ,26 ,29 ,17 ,16 ,38 ,20 ,3 ,5 ,5 ,14 ,20 ,20 ,20 ,13 ,3 ,18 ,31 ,13 ,13};
		int courses[] = {9 ,101 ,5 ,6 ,7 ,8 ,12 ,13 ,14 ,10 ,19 ,31 ,51 ,3 ,37 ,18 ,20 ,66 ,34 ,43 ,53 ,65 ,67 ,16 ,59 ,58 ,99 ,52 ,102 ,100 ,63 ,62 ,60 ,64 ,9};
		
		int orgID =serv.createOrganization(orgName);
		//278
		for (int k=0; k< batches.length;k++) {
			int bgId = serv.createBGsInOrganization(orgID, batcheCounts[k], batches[k]);
			for(int i=0; i< getRandomInteger(5, 1); i++)
			{
				int cid =getRandomInteger(34, 0); 				
				serv.addCourseInGroup(bgId,courses[cid]);
			}							
		}		
		
		
		serv.createAssesssmentTaskForAllBgs(orgID);
		
		
		//int bgId = 154;    
		//int orgID = 279;
		Organization org = new OrganizationDAO().findById(279);
		/*for(BatchGroup bg : org.getBatchGroups())
		{
			int aPlusPercentage = 25;
		    int APercentage = getRandomInteger(50, 25);
		    int maxNow = 75-APercentage;
		    int BPlusPercentage = getRandomInteger(maxNow, 20);
		    int BPercenatge = maxNow-BPlusPercentage;		    
			serv.submitAssessment(bg.getId(), aPlusPercentage,APercentage, BPlusPercentage, BPercenatge);				
			ViksitLogger.logMSG(this.getClass().getName()," assess submitted for bg"+bg.getId());
		}
		*/
		
		
		/*for(BatchGroup bg : org.getBatchGroups())
		{
			serv.autoScheduleAllCourseInBg(bg.getId());
		}
		
		ViksitLogger.logMSG(this.getClass().getName(),"all autoshcudke");
		
		for(BatchGroup bg : org.getBatchGroups())
		{
			serv.createCLassRoomSessionEvents(bg.getId());
		}*/
		
		serv.updateSessionEventsForOrg(orgID);
		
		
		System.exit(0);
	}

	

	private  void updateSessionEventsForOrg(int orgId) {
		
		DBUTILS util = new DBUTILS();
		String sql ="select * from task where item_id in (select id from batch_schedule_event where status='SCHEDULED' AND type = 'BATCH_SCHEDULE_EVENT_TRAINER' and classroom_id in (select id from classroom_details where organization_id = "+orgId+") ) and item_type ='CLASSROOM_SESSION' ";
		ViksitLogger.logMSG(this.getClass().getName(),sql);
		List<HashMap<String, Object>> taskData = util.executeQuery(sql);
		int i=0;
		for(HashMap<String, Object> taskRow: taskData)
		{
			int taskId = (int)taskRow.get("id");
			String status ="SCHEDULED"; 
			ViksitLogger.logMSG(this.getClass().getName()," finding"+ taskId);
			if(i==0)
			{				
				status="TEACHING";
				ViksitLogger.logMSG(this.getClass().getName(),"teaching "+ taskId);
				markTaskAsTeaching(taskId);
				i=1;
			}else if(i==1)
			{
				status="FEEDBACK";
				ViksitLogger.logMSG(this.getClass().getName(),"FEEDBACK "+ taskId);
				markTaskAsFeedback(taskId);
				updateFeedbackStats(taskId);
				i=2;
			}else if(i==2)
			{
				ViksitLogger.logMSG(this.getClass().getName(),"ATTENDANCE "+ taskId);
				status="ATTENDANCE";
				markTaskAsAttendance(taskId);
				updateAttendanceStats(taskId);
				i=3;
			}else if(i==3)
			{
				ViksitLogger.logMSG(this.getClass().getName(),"COMPLETED "+ taskId);
				markTaskAsCompleted(taskId);
				status = "COMPLETED";
				i=0;
			}	
		}	
		
	}

	

	private void updateFeedbackStats(int taskId) {
		DBUTILS util = new DBUTILS();
		String getFeedbackStats ="SELECT course. ID AS course_id, course.course_description, course.course_name, batch. ID AS batch_id, batch. NAME AS batch_name, batch_group. ID AS bg_id, batch_group.college_id AS college_id, cast (AVG (trainer_feedback.rating) as integer) AS avg_feedback "
				+ "FROM trainer_feedback, batch_schedule_event, batch, batch_group, course WHERE trainer_feedback.event_id = batch_schedule_event. ID AND batch_schedule_event.batch_group_id = batch_group. ID AND batch.batch_group_id = batch_group. ID AND course. ID = batch.course_id AND trainer_feedback.event_id = (select item_id from task where id ="+taskId+") GROUP BY course. ID, course.course_description, course.course_name, batch. ID, batch. NAME, batch_group. ID, batch_group.college_id";
		List<HashMap<String, Object>> feedbackData =util.executeQuery(getFeedbackStats);
		for(HashMap<String, Object> row: feedbackData)
		{
			int courseId = (int)row.get("course_id");
			String courseDescription = row.get("course_description").toString().replace(";", "");
			String courseName = row.get("course_name").toString().replace(";", "");;
			int batchId = (int)row.get("batch_id");
			String batchName = row.get("batch_name").toString().replace(";", "");;
			int bgId = (int)row.get("bg_id");
			int collegeId = (int)row.get("college_id");
			int avg_feedback = (int)row.get("avg_feedback");
			
			String checkBatchStats="select cast (count(*) as integer) as cnt from batch_stats where batch_id = "+batchId;
			List<HashMap<String, Object>> batchStatsData = util.executeQuery(checkBatchStats);
			if(batchStatsData.size()>0 && batchStatsData.get(0).get("cnt")!=null  &&(int)batchStatsData.get(0).get("cnt")==0)
			{
				String insert = "INSERT INTO batch_stats (id, batch_id, batch_name, avg_feedback,completion_perc, created_at, batch_group_id, college_id) VALUES (((select COALESCE(max(id),0)+1 from batch_stats)), "+batchId+", '"+batchName+"', "+avg_feedback+",(SELECT ( CASE WHEN ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) IS NOT NULL AND ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) != 0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" and course_id = "+courseId+"), now(),"+bgId+","+collegeId+");";
				util.executeUpdate(insert);
			}
			else
			{
				String update ="update batch_stats set avg_feedback="+avg_feedback+", completion_perc= ( SELECT ( CASE WHEN ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) IS NOT NULL AND ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) != 0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" and course_id = "+courseId+") where batch_id ="+batchId;
				util.executeUpdate(update);
			}
			
			
			String checkCourseStats="select cast (count(*) as integer) as cnt from course_stats where course_id = "+courseId+" and batch_group_id ="+bgId+" and college_id = "+collegeId;
			List<HashMap<String, Object>> courseStatsData = util.executeQuery(checkCourseStats);
			if(courseStatsData.size()>0 && courseStatsData.get(0).get("cnt")!=null  &&(int)courseStatsData.get(0).get("cnt")==0)
			{
				String insert="INSERT INTO course_stats (id, course_id, course_name, avg_feedback,completion_perc, created_at, batch_group_id, college_id, course_description) VALUES (((select COALESCE(max(id),0)+1 from batch_stats)), "+courseId+", '"+courseName+"', "+avg_feedback+",(SELECT ( CASE WHEN ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) IS NOT NULL AND ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) != 0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+") AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" and course_id = "+courseId+"), now(), "+bgId+", "+collegeId+", '"+courseDescription+"');";
				util.executeUpdate(insert);
					
			}
			else
			{
				String update="update course_stats set avg_feedback="+avg_feedback+", completion_perc=(SELECT ( CASE WHEN ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) IS NOT NULL AND ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) != 0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+courseId+" ) AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" and course_id = "+courseId+") where course_id ="+courseId+" and batch_group_id ="+bgId+" and college_id ="+collegeId;
				util.executeUpdate(update);
			}
			
		}	
		
	}

	private void updateAttendanceStats(int taskId) {
		// TODO Auto-generated method stub
		DBUTILS util = new DBUTILS();
		Task task =  new TaskDAO().findById(taskId);
		String getData ="SELECT course. ID AS course_id, course.course_description, course.course_name, batch. ID AS batch_id, batch. NAME AS batch_name,"
				+ " batch_group. ID AS bg_id, batch_group.college_id AS college_id, COUNT (*) FILTER (  WHERE attendance.status = 'PRESENT' ) * 100 / ( COUNT (*) FILTER (  WHERE attendance.status = 'PRESENT' ) + COUNT (*) FILTER (  WHERE attendance.status = 'ABSENT' ) ) AS present_perc FROM attendance, batch_schedule_event, batch, batch_group, course WHERE attendance.event_id = batch_schedule_event. ID AND batch_schedule_event.batch_group_id = batch_group. ID AND batch_schedule_event.course_id = batch.course_id AND batch.batch_group_id = batch_group. ID AND course. ID = batch.course_id AND CAST ( attendance.event_id AS VARCHAR ) LIKE '"+task.getItemId()+"' GROUP BY course. ID, course.course_description, course.course_name, batch. ID, batch. NAME, batch_group. ID, batch_group.college_id";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = sdf.format(task.getStartDate());
		List<HashMap<String, Object>> getAttendaceData = util.executeQuery(getData);
		if(getAttendaceData.size()>0)
		{
			int curseId = (int)getAttendaceData.get(0).get("course_id");
			Course course = new CourseDAO().findById(curseId);
			String dsc = getAttendaceData.get(0).get("course_description").toString().replace("'", "");
			int batchId = (int)getAttendaceData.get(0).get("batch_id");
			String batchName = getAttendaceData.get(0).get("batch_name").toString().replace("'", "");;
			int bgId = (int)getAttendaceData.get(0).get("bg_id");
			int collegeId = (int)getAttendaceData.get(0).get("college_id");
			BigInteger present_perc = (BigInteger)getAttendaceData.get(0).get("present_perc");
			
			String insertIntoTable ="INSERT INTO attendance_stats (id, course_id, batch_group_id, percentage_attendance, created_at) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from attendance_stats), "+curseId+", "+bgId+", "+present_perc.intValue()+", '"+date+"');";
			util.executeUpdate(insertIntoTable);	
			
			
			String checkBatchStats="select cast (count(*) as integer) as cnt from batch_stats where batch_id = "+batchId;
			List<HashMap<String, Object>> batchStatsData = util.executeQuery(checkBatchStats);
			if(batchStatsData.size()>0 && batchStatsData.get(0).get("cnt")!=null  &&(int)batchStatsData.get(0).get("cnt")==0)
			{
				String insert="INSERT INTO batch_stats ( ID, batch_id, batch_name, attendance_perc, completion_perc, created_at, batch_group_id ) VALUES ( ( ( SELECT COALESCE (MAX(ID), 0) + 1 FROM batch_stats ) ), "+batchId+", '"+batchName+"', "+present_perc.intValue()+", ( SELECT ( CASE WHEN (SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+") is not null and  (SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+") !=0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / (SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+") AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" ), now(), "+bgId+" );";
				util.executeUpdate(insert);
			}
			else
			{
				String update ="update batch_stats set attendance_perc="+present_perc+", completion_perc= (SELECT ( CASE WHEN ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+" ) IS NOT NULL AND ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+" ) != 0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+" ) AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" and course_id = "+curseId+") where batch_id ="+batchId;
				util.executeUpdate(update);
			}
			
			
			String checkCourseStats="select cast (count(*) as integer) as cnt from course_stats where course_id = "+curseId+" and batch_group_id ="+bgId+" and college_id = "+collegeId;
			List<HashMap<String, Object>> courseStatsData = util.executeQuery(checkCourseStats);
			if(courseStatsData.size()>0 && courseStatsData.get(0).get("cnt")!=null  &&(int)courseStatsData.get(0).get("cnt")==0)
			{
				String insert = "INSERT INTO course_stats (id, course_id, course_name, attendance_perc,completion_perc, created_at, batch_group_id, college_id, course_description) "
						+ "VALUES (((select COALESCE(max(id),0)+1 from batch_stats)), "+curseId+", '"+course.getCourseName().replace("'", "")+"', "+present_perc.intValue()+",( SELECT ( CASE WHEN ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+" ) IS NOT NULL AND ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+" ) != 0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+" ) AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" and course_id = "+curseId+", now(), "+bgId+", "+collegeId+", '"+course.getCourseDescription().replace("'", "")+"');";
				util.executeUpdate(insert);
			}
			else
			{
				String update ="update course_stats set attendance_perc="+present_perc.intValue()+", completion_perc=(SELECT ( CASE WHEN ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+") IS NOT NULL AND ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+" ) != 0 THEN CAST ( COUNT (DISTINCT lesson_id) * 100 / ( SELECT COUNT (lesson_cmsession. lesson_id) AS l_id FROM lesson_cmsession, cmsession_module, module_course where lesson_cmsession.cmsession_id = cmsession_module.cmsession_id and cmsession_module.module_id = module_course.module_id and module_course.course_id = "+curseId+") AS INTEGER ) ELSE 0 END ) AS course_completion FROM slide_change_log WHERE batch_group_id = "+bgId+" and course_id = "+curseId+") where course_id ="+curseId+" and batch_group_id ="+ bgId+" and college_id ="+collegeId;
				util.executeUpdate(update);
			}
		}	
		
	
	}

	private  void markTaskAsCompleted(int taskId) {
		// TODO Auto-generated method stub
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Task task = new TaskDAO().findById(taskId);
		markTaskAsTeaching(taskId);
		markTaskAsAttendance(taskId);
		markTaskAsFeedback(taskId);
		updateState(taskId, task.getIstarUserByActor().getId(),TrainerWorkflowStages.FEEDBACK,sdf.format(task.getStartDate()));
	}

	public ArrayList<com.istarindia.android.pojo.GroupStudentPojo> studentsInGroup(int groupId, int taskID)
	{
		String mediaUrlPath =AppProperies.getProperty("media_url_path");
		ArrayList<com.istarindia.android.pojo.GroupStudentPojo> students = new ArrayList<>();
		DBUTILS utils = new DBUTILS();
		String sql="SELECT 	distinct istar_user. ID, 	CASE WHEN ( 	user_profile.first_name IS NULL ) THEN 	istar_user.email ELSE 	user_profile.first_name END,  user_profile.profile_image,  CASE WHEN (attendance.status IS NULL) THEN 	'ABSENT' ELSE 	attendance.status END FROM "
				+ "	task LEFT JOIN batch_schedule_event ON ( 	task.item_id = batch_schedule_event. ID ) "
				+ "LEFT JOIN batch_students ON ( 	batch_students.batch_group_id = "+groupId+" ) "
				+ "LEFT JOIN istar_user ON ( 	batch_students.student_id = istar_user. ID )"
				+ " LEFT JOIN user_profile ON ( 	istar_user. ID = user_profile.user_id ) "
				+ "LEFT JOIN attendance ON ( 	attendance.event_id = batch_schedule_event. ID 	AND istar_user. ID = attendance.user_id )"
				+ " WHERE 	task. ID = "+taskID+" AND istar_user. ID NOTNULL";
		
		//ViksitLogger.logMSG(this.getClass().getName(),(sql);
		List<HashMap<String, Object>> studentData = utils.executeQuery(sql);
		for(HashMap<String, Object> row : studentData)
		{
			int studentId = (int)row.get("id");
			String name = row.get("first_name").toString();
			String profileImage = "/users/"+name.charAt(0)+".png";
			if(row.get("profile_image")!=null)
			{
				profileImage = row.get("profile_image").toString();
			}
			String status = row.get("status").toString();
			com.istarindia.android.pojo.GroupStudentPojo stu = new com.istarindia.android.pojo.GroupStudentPojo();
			stu.setImageUrl(mediaUrlPath+profileImage);
			stu.setStudentId(studentId);
			stu.setStudentName(name);
			if(status.equalsIgnoreCase("PRESENT")) {
				stu.setStatus(true);
			}else{
				stu.setStatus(false);
			}
			
			
			students.add(stu);
		}
		
		return students;
	}
	
	private  void markTaskAsAttendance(int taskId) {
		// TODO Auto-generated method stub
		markTaskAsTeaching(taskId);
		Task task = new TaskDAO().findById(taskId);
		DBUTILS util = new DBUTILS();
		int id = taskId;
		int actor = task.getIstarUserByActor().getId();
		com.istarindia.android.pojo.GroupPojo group = new com.istarindia.android.pojo.GroupPojo();
		String getGroupId ="select batch_group_id, batch_group.name, batch_schedule_event.eventdate from task,batch_schedule_event, batch_group where batch_group.id = batch_schedule_event.batch_group_id and batch_schedule_event.id = task.item_id and task.id ="+id+" and item_type in ('"+TaskItemCategory.CLASSROOM_SESSION+"') ";
		//ViksitLogger.logMSG(this.getClass().getName(),"getGroupId>>>"+getGroupId);
		List<HashMap<String, Object>> groupData = util.executeQuery(getGroupId);
		
		if(groupData.size()>0)
		{
			Random r = new Random();
			int Low = 85;
			int High = 100;
			int Result = r.nextInt(High-Low) + Low;
			
			
			ArrayList<com.istarindia.android.pojo.GroupStudentPojo> students = new ArrayList<>();
			int groupId = (int)groupData.get(0).get("batch_group_id");
			String groupName = groupData.get(0).get("name").toString();
			String eventdate = groupData.get(0).get("eventdate").toString();
			students = studentsInGroup(groupId,id);				
			int totalStu = students.size();
			int homnayToMarkASPResent = (Result*totalStu)/100;  //60
			ArrayList<GroupStudentPojo> updateList = new ArrayList<>();
			int i= 0;
			for(GroupStudentPojo st :students)
			{
				if(i< homnayToMarkASPResent)
				{
					st.setStatus(true);
				}					
				i++;
				updateList.add(st);
			}								
			
			group.setGroupId(groupId);
			group.setGroupName(groupName);
			group.setStudents(updateList);
			group.setStuCount(students.size());	
			
			submitAttendance(id,actor , group,eventdate);	
			updateState(id, actor,TrainerWorkflowStages.ATTENDANCE, eventdate);
		}
		
	}

        public void updateState(int taskId, int istarUserId, String state, String eventdate) {
		
		DBUTILS util = new DBUTILS();
		String fineCourseBGeventId ="select batch_group_id, course_id, id from batch_schedule_event where id = (select item_id from task where id ="+taskId+")";
		List<HashMap<String, Object>> detail = util.executeQuery(fineCourseBGeventId);		
		if(detail.size()>0)
		{
			
			String bgId = detail.get(0).get("batch_group_id").toString();
			String courseId = detail.get(0).get("course_id").toString();
			String id = detail.get(0).get("id").toString();			
			String insertIntoLog="INSERT INTO status_change_log (id, trainer_id, course_id,  created_at, updated_at,  event_type, event_status, event_id, batch_group_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from status_change_log), "+istarUserId+", "+courseId+", '"+eventdate+"','"+eventdate+"', 'STATUS_CHANGED', '"+state+"', "+id+",  "+bgId+");";
			util.executeUpdate(insertIntoLog);
			
			String updateBSE="update batch_schedule_event set status ='"+state+"' where id=(select item_id from task where id ="+taskId+")";
			util.executeUpdate(updateBSE);
			
		}	
		
		
	}

	public void submitAttendance(int taskId, int istarUserId, GroupPojo attendanceResponse, String eventdate) {
		
		DBUTILS util = new DBUTILS();
		
		String deleteOldEntry = "delete from attendance where event_id = (select item_id from task where id = "+taskId+")";
		util.executeUpdate(deleteOldEntry);
		for(GroupStudentPojo stu :attendanceResponse.getStudents())
		{
			String status ="ABSENT";
			if(stu.getStatus()!=null && stu.getStatus() )
			{
				status="PRESENT";
			}
			else
			{
				status="ABSENT";
			}	
			String insertIntoAttendance ="INSERT INTO attendance (id, taken_by, user_id, status, created_at, updated_at, event_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from attendance), '"+istarUserId+"', '"+stu.getStudentId()+"', '"+status+"', (select start_date from task where id ="+taskId+"), (select start_date from task where id ="+taskId+"), (select item_id from task where id="+taskId+"));";
			util.executeUpdate(insertIntoAttendance);
		}
		
	}

	
	private  void markTaskAsFeedback(int taskId) {
		// TODO Auto-generated method stub
		markTaskAsTeaching(taskId);
		markTaskAsAttendance(taskId);
		
		ClassFeedbackByTrainer feedbackResponse = new ClassFeedbackByTrainer();
		Task task = new TaskDAO().findById(taskId);
		int actor =task.getIstarUserByActor().getId();
		ArrayList<FeedbackPojo> feedback = new ArrayList<>();
		feedback.add(new FeedbackPojo("noise",randomNumber()));
		feedback.add(new FeedbackPojo("attendance",randomNumber()));
		feedback.add(new FeedbackPojo("content",randomNumber()));
		feedback.add(new FeedbackPojo("sick",randomNumber()));
		feedback.add(new FeedbackPojo("assignment",randomNumber()));
		feedback.add(new FeedbackPojo("internals",randomNumber()));
		feedback.add(new FeedbackPojo("internet",randomNumber()));
		feedback.add(new FeedbackPojo("electricity",randomNumber()));
		feedback.add(new FeedbackPojo("time",randomNumber()));
		feedback.add(new FeedbackPojo("projector",randomNumber()));
		feedback.add(new FeedbackPojo("comment","Class was a bit noisy."));
		feedbackResponse.setFeedbacks(feedback);
		
		submitFeedbackByTrainer(taskId, actor, feedbackResponse);
	}

	public  String randomNumber() {
		float leftLimit = 0F;
	    float rightLimit = 5F;
	    float generatedFloat = leftLimit + new Random().nextFloat() * (rightLimit - leftLimit);
	    DecimalFormat df = new DecimalFormat();
	    df.setMaximumFractionDigits(1);
		return df.format(generatedFloat);
	}

	public  void submitFeedbackByTrainer(int taskId, int istarUserId, ClassFeedbackByTrainer feedbackResponse) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Task task = new TaskDAO().findById(taskId);
		HashMap<String, String> feedbackData= new HashMap<>(); 
		feedbackData.put("", "0");
		for(FeedbackPojo pojo : feedbackResponse.getFeedbacks())
		{
			feedbackData.put(pojo.getName().toLowerCase(), pojo.getRating());
		}
		DBUTILS util = new DBUTILS();
		String checkIfExist ="delete from trainer_feedback where event_id = (select item_id from task where id = "+taskId+")";
		util.executeUpdate(checkIfExist);
		float avgRating = 5;
		float totalRating = Float.parseFloat(feedbackData.get("noise")) +Float.parseFloat(feedbackData.get("attendance")) +Float.parseFloat(feedbackData.get("sick")) +Float.parseFloat(feedbackData.get("content")) +Float.parseFloat(feedbackData.get("assignment")) +Float.parseFloat(feedbackData.get("internals")) +Float.parseFloat(feedbackData.get("internet")) +Float.parseFloat(feedbackData.get("electricity")) +Float.parseFloat(feedbackData.get("time"));
			avgRating = totalRating/9;
		String insertFeedback="INSERT INTO trainer_feedback (id, user_id, rating, comments, event_id, noise, attendance, sick, content, assignment, internals, internet, electricity, time, projector) "
				+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_feedback), "+istarUserId+","
						+ " "+avgRating+", "
								+ "'"+feedbackData.get("comment")+"',"
										+ " ( select item_id from task where id="+taskId+"),"
												+ " "+Float.parseFloat(feedbackData.get("noise"))+","
														+ " "+Float.parseFloat(feedbackData.get("attendance"))+","
																+ " "+Float.parseFloat(feedbackData.get("sick"))+","
																		+ " "+Float.parseFloat(feedbackData.get("content"))+","
																				+ " "+Float.parseFloat(feedbackData.get("assignment"))+","
																						+ " "+Float.parseFloat(feedbackData.get("internals"))+", "
																								+ ""+Float.parseFloat(feedbackData.get("internet"))+","
																										+ " "+Float.parseFloat(feedbackData.get("electricity"))+", "
																												+ ""+Float.parseFloat(feedbackData.get("time"))+","
																														+ ""+Float.parseFloat(feedbackData.get("projector"))+");";
		util.executeUpdate(insertFeedback);
		
		
		
		String updateTaskAsCompleted = "update task set is_active = 'f' where id="+taskId;
		util.executeUpdate(updateTaskAsCompleted);		
		updateState(taskId, istarUserId,TrainerWorkflowStages.FEEDBACK,sdf.format(task.getStartDate()));		
	}

	
	public Connection getApiConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://api.talentify.in:5432/postgres","postgres", "X3m2p1z0!@#");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
	private  void markTaskAsTeaching(int taskId) {
		Task task = new TaskDAO().findById(taskId);
		DBUTILS util = new DBUTILS();
		String getBatchSheduleEvent = "select * from batch_schedule_event where id ="+task.getItemId();
		List<HashMap<String, Object>> bseData = util.executeQuery(getBatchSheduleEvent);
		if(bseData.size()>0)
		{
			int id = (int)bseData.get(0).get("id");
			int batchGroupId = (int)bseData.get(0).get("batch_group_id");
			int courseId = (int)bseData.get(0).get("course_id");
			int trainerId = (int)bseData.get(0).get("actor_id");
			String eventdate = bseData.get(0).get("eventdate").toString();
			String randomLesson = "select * from (select DISTINCT lesson_cmsession.lesson_id, lesson_cmsession.cmsession_id, cmsession_module.module_id, module_course.course_id from module_course, cmsession_module, lesson_cmsession, lesson where module_course.course_id = "+courseId+" and module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = lesson_cmsession.cmsession_id and lesson.id = lesson_cmsession.lesson_id and lesson.is_deleted='f' and lesson.is_published='t' and lesson.type='PRESENTATION' )T1  OFFSET floor(random()* (select count(*) from (select DISTINCT lesson_cmsession.lesson_id, lesson_cmsession.cmsession_id, cmsession_module.module_id, module_course.course_id from module_course, cmsession_module, lesson_cmsession, lesson where module_course.course_id = "+courseId+" and module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = lesson_cmsession.cmsession_id and lesson.id = lesson_cmsession.lesson_id and lesson.is_deleted='f' and lesson.is_published='t' and lesson.type='PRESENTATION' )T1)) limit 1 "; 
			List<HashMap<String, Object>> lessonData = util.executeQuery(randomLesson);
			if(lessonData.size()>0)
			{
				int moduleId = (int)lessonData.get(0).get("module_id");
				int lessonId = (int)lessonData.get(0).get("lesson_id");
				int cmsessionId = (int)lessonData.get(0).get("cmsession_id");
				
				String sql ="select slide.* , cast (count(*)  over() as integer) as cnt from lesson, presentaion, slide where lesson.id = presentaion.lesson_id and presentaion.id = slide.presentation_id and lesson.id = "+lessonId;
				Connection con = getApiConnection();
				try {
					Statement statement = con.createStatement();
					ResultSet rs = statement.executeQuery(sql);
					if(rs.next())
					{
						while(rs.next())
						{
							int slideId = rs.getInt("id");
							String slideTitle = rs.getString("title").replace("'", "");
							int totalSlides = rs.getInt("cnt");
							String insertIntoLog = "INSERT INTO event_log (id, trainer_id, course_id, cmsession_id, lesson_id, slide_id, created_at, updated_at, module_id, assessment_id, event_type, event_status, event_id, url, batch_group_id, total_slide_count) "
									+ "VALUES ((select COALESCE(max(id),0)+1 from slide_change_log), '"+trainerId+"', '"+courseId+"', '"+cmsessionId+"', '"+lessonId+"', '"+slideId+"', '"+eventdate+"', '"+eventdate+"', '"+moduleId+"', '0', 'SLIDE_CHANGED', 'TEACHING', '"+id+"', '"+slideTitle+"', '"+batchGroupId+"',"+totalSlides+");";							
							ViksitLogger.logMSG(this.getClass().getName(),insertIntoLog);
							util.executeUpdate(insertIntoLog);
							
							
						}	
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					//e.printStackTrace();
				}				
				
			}
			
			String insertIntoLog="INSERT INTO status_change_log (id, trainer_id, course_id,  created_at, updated_at,  event_type, event_status, event_id, batch_group_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from status_change_log), "+trainerId+", "+courseId+", '"+eventdate+"','"+eventdate+"', 'STATUS_CHANGED', 'TEACHING', "+id+",  "+batchGroupId+");";
			util.executeUpdate(insertIntoLog);
			
			String updateBSE="update batch_schedule_event set status ='TEACHING' where id=(select item_id from task where id ="+taskId+")";
			util.executeUpdate(updateBSE);
		}	
		
	}

	private void createCLassRoomSessionEvents(Integer bgId) {
		BatchGroup bg = new BatchGroupDAO().findById(bgId);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");		
		
		int i =0;
		for(Batch batch : bg.getBatchs())
		{
			
				int trainerId = createTrainer();			
				int classRoomId = createClassRoomFor(bg.getOrganization().getId());
				if(trainerId!=0 && classRoomId!=0)
				{
					Date d = new Date(System.currentTimeMillis());
					Calendar start = Calendar.getInstance();
					start.add(Calendar.DATE, -15);
					start.add(Calendar.HOUR, i);
					Calendar end = Calendar.getInstance();
					end.add(Calendar.DATE,60);
					
					Date statrtDate = new Date(start.getTimeInMillis());
					Date endDate = new Date(end.getTimeInMillis());
					for (Date date = statrtDate; date.before(endDate); start.add(Calendar.DATE, 1), date = start.getTime()) {				    
					    ViksitLogger.logMSG(this.getClass().getName(),date);
					    createEvent(trainerId, 1, 0, batch.getId(), sdf.format(date), "", 300, classRoomId, -1, trainerId+"");
					}				
				}
				i++;
						
		}
		
	}

	private int createClassRoomFor(Integer orgId) {
		DBUTILS util = new DBUTILS();
		String 	sql ="INSERT INTO classroom_details (classroom_identifier, organization_id, max_students, id, ip_address, tv_projector, internet_availability, internet_speed, type_of_class, compute_stick, extension_box, router, keyboard, mouse) "
				+ "VALUES ('ClassRoom B '||((SELECT COALESCE (MAX(ID) + 1, 1) FROM classroom_details )), "+orgId+", '100', (SELECT COALESCE (MAX(ID) + 1, 1) FROM classroom_details ), '192.168.0.0', 'NONE', 'f', '100', 'CLASS', 'f', 'f', 'f', 't', 't') returning id; ";
		int classId = util.executeUpdateReturn(sql);
		return classId;
	}

	private int createTrainer() {

		Faker faker = new Faker();
		DBUTILS db = new DBUTILS();
		String name = faker.name().fullName();
		String firstName = faker.name().firstName().replace("'", "");
		String lastName = faker.name().lastName().replace("'", "");
		String email = faker.name().firstName().toLowerCase()+""+getRandomInteger(10000, 1)+"@istarindia.com".replace("'", "");
		String mobile = faker.number().digits(10);
		
		String checkIfEmailExist ="select cast (count(*) as integer) as cnt from istar_user where email ='"+email+"'";
		List<HashMap<String, Object>> checkData = db.executeQuery(checkIfEmailExist);
		if(checkData.size()>0 && checkData.get(0).get("cnt")!=null && (int)checkData.get(0).get("cnt")==0)
		{
			String sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), 'Phase 2', 'Manyata Tech Park', 154819, '73.8834149', '18.4866277' )RETURNING ID;";
			int addressId = db.executeUpdateReturn(sql);
			
			String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email.replace("'", "")+"', 		'test123', 		now(), 		'"+mobile+"', 		NULL,    'f' 	)RETURNING ID;";
			ViksitLogger.logMSG(this.getClass().getName(),istarStudentSql);
						
			 int userID  = db.executeUpdateReturn(istarStudentSql);
							

						//Student User Role Mapping
			String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name = 'TRAINER'), (SELECT MAX(id)+1 FROM user_role), '1');";
			ViksitLogger.logMSG(this.getClass().getName(),userRoleMappingSql);
			db.executeUpdate(userRoleMappingSql);
							
							//Trainer Student  User Profile
			String UserProfileSql = "INSERT INTO user_profile ( 	id, 	address_id, 	first_name, 	last_name, 	dob, 	gender, 	user_id, 	aadhar_no ) VALUES 	( 		(SELECT MAX(id)+1 FROM user_profile), 		"+addressId+", 		'"+firstName+"', 		'"+lastName+"', 	NULL,	'MALE',   "+userID+", 		NULL 	); ";
			ViksitLogger.logMSG(this.getClass().getName(),UserProfileSql);
			db.executeUpdate(UserProfileSql);
							

			//Trainer Student User Org Mapping
			String userOrgMappingSql = "INSERT INTO user_org_mapping ( 	user_id, 	organization_id, 	id ) VALUES 	("+userID+", 2, (SELECT MAX(id)+1 FROM user_org_mapping));";
			ViksitLogger.logMSG(this.getClass().getName(),userOrgMappingSql);
			db.executeUpdate(userOrgMappingSql);
			
			String[] presenterEmailaddress = email.split("@");
			String presenterEmail = presenterEmailaddress[0] + "_presenter@" + presenterEmailaddress[1];
			
			// Insert new Presenter
			String istarPresenterSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"
					+ presenterEmail + "', 		'test123', 		now(), 		'" + mobile
					+ "', 		NULL,    'f' 	)RETURNING ID;";

			int presenterUserID = db.executeUpdateReturn(istarPresenterSql);
			ViksitLogger.logMSG(this.getClass().getName(),istarPresenterSql);
			// Trainer Presenter User Role Mapping
			String presentorRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("
					+ presenterUserID
					+ ", (select id from role where role_name = 'PRESENTOR'), (SELECT MAX(id)+1 FROM user_role), '1');";
			db.executeUpdate(presentorRoleMappingSql);
			ViksitLogger.logMSG(this.getClass().getName(),presentorRoleMappingSql);
			// Trainer Presenter Mapping
			String trainerPresenterSql = "INSERT INTO trainer_presentor ( 	id, 	trainer_id, 	presentor_id ) VALUES 	((SELECT MAX(id)+1 FROM trainer_presentor), "
					+ userID + ", " + presenterUserID + ");";
			db.executeUpdate(trainerPresenterSql);
			ViksitLogger.logMSG(this.getClass().getName(),trainerPresenterSql);
			
			
			
			return userID;
		}	
	return 0;		
	}

	private  void autoScheduleAllCourseInBg(Integer bgID) {
		BatchGroup bg = new BatchGroupDAO().findById(bgID);
		DBUTILS util = new DBUTILS();
		int stuCount=0;
		ArrayList<Integer> users = new ArrayList<>();
		String sql= "select distinct student_id from batch_students where batch_group_id= "+bgID;
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		
		
		for(HashMap<String, Object> row: data)
		{
			int stuId = (int) row.get("student_id");
			users.add(stuId);
			stuCount++;
		}
		ArrayList<Integer> daysList = new ArrayList<>();
		
		daysList.add(Calendar.SUNDAY);
		daysList.add(Calendar.MONDAY);
		daysList.add(Calendar.TUESDAY);
		daysList.add(Calendar.WEDNESDAY);
		daysList.add(Calendar.THURSDAY);
		daysList.add(Calendar.FRIDAY);
		daysList.add(Calendar.SATURDAY);
		String days [] = {"SUN","MON","TUE","WED","THU","FRI","SAT"};
		for(Batch batch : bg.getBatchs())
		{
			ArrayList<Integer> modules = new ArrayList<>();
			ArrayList<Integer> cmsessions = new ArrayList<>();
			ArrayList<Integer> lessons = new ArrayList<>();
			String playListData = "SELECT 	lesson_cmsession.lesson_id, 	lesson_cmsession.cmsession_id, 	cmsession_module.module_id, 	module_course.course_id FROM 	module_course, 	cmsession_module, 	lesson_cmsession, lesson WHERE lesson.is_published = 't' and lesson.is_deleted!='t' and lesson.id = lesson_cmsession.lesson_id AND module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND module_course.course_id = "+batch.getCourse().getId()+" ORDER BY 	module_course.oid, 	cmsession_module.oid, 	lesson_cmsession.oid";
			List<HashMap<String, Object>>  pldata = util.executeQuery(playListData);
			for(HashMap<String, Object> cdata : pldata)
			{
				int mid = (int)cdata.get("module_id");
				modules.add(mid);
				int cmid = (int)cdata.get("cmsession_id");
				cmsessions.add(cmid);
				int lid = (int)cdata.get("lesson_id");
				lessons.add(lid);
			}
			
			int totalLessons = lessons.size();
			Date d = new Date(System.currentTimeMillis());
			Calendar start = Calendar.getInstance();
			start.add(Calendar.DATE, -1*totalLessons);
			Calendar end = Calendar.getInstance();
			end.add(Calendar.DATE,1);
			
			Date statrtDate = new Date(start.getTimeInMillis());
			Date endDate = new Date(end.getTimeInMillis());
			
			
			
			int workingDays = getWorkingDaysBetweenTwoDates(statrtDate, endDate, daysList);
			int freq =0;
			int total_scheduled_days = 0;
			if(workingDays>0)
			{
				freq = (int)Math.ceil((double)lessons.size()/workingDays);
				
				total_scheduled_days = (int)Math.ceil((double)lessons.size()/freq);
				//ViksitLogger.logMSG(this.getClass().getName(),"freq>>"+freq);
				String autoData ="INSERT INTO auto_scheduler_data (id, entity_type, entity_id, course_id, student_count, start_date, end_date, scheduled_days, scheduled_days_count,tasks_per_day) VALUES "
						+ "((select COALESCE(max(id),0)+1 from auto_scheduler_data), '"+bg.getType()+"', "+bgID+", "+batch.getCourse().getId()+", "+stuCount+", '"+new Timestamp(statrtDate.getTime())+"', '"+new Timestamp(endDate.getTime())+"', '"+ String.join(",", days)+"', "+total_scheduled_days+","+freq+");";
				ViksitLogger.logMSG(this.getClass().getName(),autoData);
				util.executeUpdate(autoData);				
				createTaskBetweenTwoDates(statrtDate, endDate, daysList,workingDays,users, modules, cmsessions, lessons, batch.getCourse().getId()+"", freq);
			}
		}			
	}

	
	private void createTaskBetweenTwoDates(Date startDate, Date endDate, ArrayList<Integer> daysList, int totalDays, ArrayList<Integer> users, 
			ArrayList<Integer> modules, ArrayList<Integer> cmsessions, ArrayList<Integer> lessons, String scheduler_course_id, int freq) {
	    Calendar startCal = Calendar.getInstance();
	    startCal.setTime(startDate);        
	    Calendar endCal = Calendar.getInstance();
	    endCal.setTime(endDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+startDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+endDate);
	    int workDays = 0;
	    int currentOrderId=0;
	    //Return 0 if start and end are the same
	    if (startCal.getTimeInMillis() == endCal.getTimeInMillis()) {
	        return ;
	    }

	    if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
	        startCal.setTime(endDate);
	        endCal.setTime(startDate);
	    }
	    
	    
	    endCal.add(Calendar.DATE, 1);
	    
	    
	    
	    int daysCount=0;
	    DBUTILS util = new DBUTILS();
	    String insertIntoProject ="INSERT INTO project (id, name, created_at, updated_at, creator, active) VALUES ((select COALESCE(max(id),0)+1 from project), 'Auto Schedule of Course with id "+scheduler_course_id+"', now(), now(),  300, 't') returning id;";
		 int projectId = util.executeUpdateReturn(insertIntoProject);
	    
		 
	    for(Date sd = startCal.getTime(); sd.before(endCal.getTime()); )
	    {
	    	//ViksitLogger.logMSG(this.getClass().getName(),"chedking for "+sd);
	    	if(daysCount<=totalDays)
	    	{
	    		if (daysList.contains(startCal.get(Calendar.DAY_OF_WEEK))) {
		    		Date taskDate = startCal.getTime();
		        	//ViksitLogger.logMSG(this.getClass().getName(),"creatting task for date+"+taskDate);		        	
		        	for(int stid : users)
		        	{
		        		int cid=Integer.parseInt(scheduler_course_id);
		        		for(int i=0;i<freq;i++){
		        			int orderId = currentOrderId+i;
			        		if(orderId<lessons.size()){
			        			int mid = modules.get(orderId);
				        		int cms = cmsessions.get(orderId);
				        		int lid = lessons.get(orderId);
				        		scheduleTask(stid, cid, mid, cms, lid, taskDate,projectId);
			        		}
			        			
		        		}
		        	}
		        	currentOrderId = currentOrderId+freq;
		        	daysCount++;
		        }
	    	}
	    	else
	    	{
	    		break;
	    	}	
	    	
	    	startCal.add(Calendar.DATE, 1);
	    	sd = startCal.getTime();
	    }
	}
	
	private void scheduleTask(int stid, int cid, int mid, int cms, int lid, Date taskDate, int projectId) {
		Date endate = new Date();
		Calendar c = Calendar.getInstance(); 
		c.setTime(taskDate); 
		c.add(Calendar.DATE, 1);
		endate = c.getTime();
		
		DBUTILS util = new DBUTILS();
		Integer taskId = null;
		Lesson lesson = new LessonDAO().findById(lid);
		String taskTitle = lesson.getTitle().toString();
		String taskDescription = lesson.getDescription()!=null ? lesson.getDescription(): "NA";
		String lessonType = "LESSON";
		int itemId = lesson.getId();
		boolean createEvent = false;;
		StudentSkillMapService serv = new StudentSkillMapService();
		
		if(lesson.getType().equalsIgnoreCase("ASSESSMENT"))
		{
			try {
				lessonType = "ASSESSMENT";
				itemId = Integer.parseInt(lesson.getLessonXml());
				Double maxPointsForItem = serv.getMaxPointsOfAssessment(itemId);
				if(maxPointsForItem!=null && maxPointsForItem>0)
				{
					createEvent = true;
				}
			} catch (NumberFormatException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
			}
		}
		else
		{
			createEvent= true;
		}	
		
		if(createEvent)
		{
			String checkIfTaskExist ="select id from task where actor="+stid+" and item_id="+itemId+" and item_type='"+lessonType+"' and cast (start_date  as date) = cast (now() as date)";
			List<HashMap<String, Object>> alreadyAvailbleTask = util.executeQuery(checkIfTaskExist);
			if(alreadyAvailbleTask.size()==0)
			{
				String sql ="INSERT INTO task (id, name, description, owner, actor, state,  start_date, end_date, is_active,  created_at, updated_at, item_id, item_type, project_id) "
						+ "VALUES ((select COALESCE(max(id),0) +1 from task), '"+taskTitle.replaceAll("'", "")+"', '"+taskDescription.replaceAll("'", "")+"', 300, "+stid+", 'SCHEDULED', '"+new Timestamp(taskDate.getTime())+"','"+new Timestamp(endate.getTime()) +"', 't', now(), now(), "+itemId+", '"+lessonType+"', "+projectId+") returning id;";
				//ViksitLogger.logMSG(this.getClass().getName(),">>>"+sql);
				taskId = util.executeUpdateReturn(sql); 
				
				//TaskServices taskService = new TaskServices();
				StudentPlayListServicesAdmin playListService = new StudentPlayListServicesAdmin();
				playListService.createStudentPlayList(stid,cid, mid, cms,  lid,taskId);
			}
		}					
	}
	
	public  int getWorkingDaysBetweenTwoDates(Date startDate, Date endDate, ArrayList<Integer> days) {
	    Calendar startCal = Calendar.getInstance();
	    startCal.setTime(startDate);        

	    Calendar endCal = Calendar.getInstance();
	    endCal.setTime(endDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+startDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+endDate);
	    int workDays = 0;

	    //Return 0 if start and end are the same
	    if (startCal.getTimeInMillis() == endCal.getTimeInMillis()) {
	        return 0;
	    }

	    if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
	        startCal.setTime(endDate);
	        endCal.setTime(startDate);
	    }
	    
	    endCal.add(Calendar.DATE, 1);
	    for(Date sd = startCal.getTime(); sd.before(endCal.getTime()); )
	    {
	    	if (days.contains(startCal.get(Calendar.DAY_OF_WEEK))) {
	        	////ViksitLogger.logMSG(this.getClass().getName(),"checming for "+startCal.get(Calendar.DAY_OF_WEEK));
	            ++workDays;
	        }
	    	startCal.add(Calendar.DATE, 1);
	    	sd = startCal.getTime();
	    }
	    
	    return workDays;
	}
	
	
	private void submitAssessment(int bgId, int aPlusPercentage, int aPercentage, int bPlusPercentage, int bPercenatge ) {
		
		BatchGroup bg = new BatchGroupDAO().findById(bgId);
		ArrayList<Integer>studentsInBg = new ArrayList<>();
		for(BatchStudents bs : bg.getBatchStudentses())
		{
			studentsInBg.add(bs.getIstarUser().getId());
		}	
		
		ArrayList<Integer>assessmentIds = new ArrayList<>();
		
		for(Batch batch :bg.getBatchs())
		{
			for(Module module : batch.getCourse().getModules())
			{
				for(Cmsession cms : module.getCmsessions())
				{
					for(Lesson lesson : cms.getLessons())
					{
						if(lesson.getType().equalsIgnoreCase("ASSESSMENT"))
						{
							try {
								assessmentIds.add(Integer.parseInt(lesson.getLessonXml()));
							} catch (NumberFormatException e) {
								// TODO Auto-generated catch block
								//e.printStackTrace();
							}
						}	
					}	
				}	
			}
		}
		
		DBUTILS util = new DBUTILS();
		for(int assessId : assessmentIds)
		{
			geiveFarziAssessment(assessId,studentsInBg, aPlusPercentage,aPercentage, bPlusPercentage, bPercenatge);			
		}
		
		for(int assessId :assessmentIds)
		{
			String finddateForTask ="select  created_at from task where item_id = "+assessId+" and item_type ='ASSESSMENT' and actor in (select DISTINCT student_id from batch_students where batch_group_id = "+bgId+") limit 1";
			List<HashMap<String, Object>> taskDate = util.executeQuery(finddateForTask);
			if(taskDate.size()>0)
			{
				int averageScoreOfBatchGroup =  getAverageScoreOfBatchGroup(bgId);
				String insertIntoBgProgress = "INSERT INTO bg_progress (id, created_at, college_id, college_name, batch_group_id, batch_group_name, avg_score)  VALUES ((select COALESCE(max(id),0)+1 from bg_progress), '"+taskDate.get(0).get("created_at")+"', "+bg.getOrganization().getId()+", '"+bg.getOrganization().getName().replace("'", "")+"', "+bgId+", '"+bg.getName().replace("'", "").trim()+"', "+averageScoreOfBatchGroup+");";
				util.executeUpdate(insertIntoBgProgress);
			}	
		}	
	}

	
	private int getAverageScoreOfBatchGroup(int bgId) {
		DBUTILS util = new DBUTILS();
		String sql ="SELECT CAST ( COALESCE (AVG(user_points), 0) AS INTEGER ) AS avg_score FROM ( SELECT T1.student_id, COALESCE (SUM(T1.points), 0) AS user_points FROM ( WITH summary AS ( SELECT TX.student_id, P .skill_objective, custom_eval ( CAST ( TRIM ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) ) AS TEXT ) ) AS points, P .item_id, ROW_NUMBER () OVER ( PARTITION BY TX.student_id, P .skill_objective, P .item_id, P .item_type ORDER BY P . TIMESTAMP DESC ) AS rk FROM ( SELECT student_id FROM batch_students WHERE batch_group_id IN ( SELECT ID FROM batch_group WHERE parent_group_id = "+bgId+" UNION SELECT ID FROM batch_group WHERE ID = "+bgId+" ) ) TX LEFT JOIN user_gamification P ON ( P .istar_user = TX.student_id AND item_type IN ('QUESTION', 'LESSON') AND batch_group_id = "+bgId+" ) ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 GROUP BY student_id ) TFINAL";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		if(data.size()>0 && data.get(0).get("avg_score")!=null)
		{
			return (int)data.get(0).get("avg_score");
		}	
		 return 0;
	}

	private void geiveFarziAssessment(int assessmentId, ArrayList<Integer> students, int aPlusPercentage, int aPercentage, int bPlusPercentage, int bPercenatge) {
		FarziDataCreatorServices mm= new FarziDataCreatorServices();
		int APlusSize =  (aPlusPercentage*students.size())/100; 
		int ASize =  (aPercentage*students.size())/100; 
		int BPlusSize =  (bPlusPercentage*students.size())/100; 
		int BSize =  (bPercenatge*students.size())/100; 
		
		
		ArrayList<Integer>studentsGettingAPlus = new ArrayList<>();
		ArrayList<Integer>studentsGettingA = new ArrayList<>();
		ArrayList<Integer>studentsGettingBPlus = new ArrayList<>();
		ArrayList<Integer>studentsGettingB = new ArrayList<>();
		for(Integer userId : students)
		{
			if(!studentsGettingAPlus.contains(userId) && studentsGettingAPlus.size()<=APlusSize)
			{
				studentsGettingAPlus.add(userId);				
			}				
		}
		for(Integer userId : students)
		{
			if(!studentsGettingAPlus.contains(userId)&& !studentsGettingA.contains(userId) && studentsGettingA.size()<=ASize)
			{
				studentsGettingA.add(userId);				
			}				
		}
		for(Integer userId : students)
		{
			if(!studentsGettingA.contains(userId) && !studentsGettingAPlus.contains(userId)&& !studentsGettingBPlus.contains(userId) && studentsGettingBPlus.size()<=BPlusSize)
			{
				studentsGettingBPlus.add(userId);				
			}				
		}
		for(Integer userId : students)
		{
			if(!studentsGettingBPlus.contains(userId) && !studentsGettingA.contains(userId) && !studentsGettingAPlus.contains(userId)&& !studentsGettingB.contains(userId) && studentsGettingB.size()<=BSize)
			{
				studentsGettingB.add(userId);				
			}				
		}
		
		Integer percentageRequiredAPlus  = ThreadLocalRandom.current().nextInt(76, 100 + 1);
		Integer percentageRequiredA  = ThreadLocalRandom.current().nextInt(61, 75 + 1);
		Integer percentageRequiredBPlus  = ThreadLocalRandom.current().nextInt(41, 60 + 1);
		Integer percentageRequiredB  = ThreadLocalRandom.current().nextInt(0, 40 + 1);
		giveFarziDataWithGrade(studentsGettingAPlus, assessmentId,percentageRequiredAPlus);
		giveFarziDataWithGrade(studentsGettingA, assessmentId,percentageRequiredA);
		giveFarziDataWithGrade(studentsGettingBPlus, assessmentId,percentageRequiredBPlus);
		giveFarziDataWithGrade(studentsGettingB, assessmentId,percentageRequiredB);
		
	}

	private void giveFarziDataWithGrade(ArrayList<Integer> students, int assessmentId,
			Integer percentageRequiredfORgRADE) {
		ViksitLogger.logMSG(this.getClass().getName(),"FARZI DATA STARAT HERE");
		DBUTILS util = new DBUTILS();
		for(Integer userId : students){
		Integer percentageRequired  = percentageRequiredfORgRADE;		
		String findAssessmentTasks = "select id from task where item_type='ASSESSMENT' and actor="+userId+" and item_id="+assessmentId+"";
		ViksitLogger.logMSG(this.getClass().getName(),findAssessmentTasks);
		List<HashMap<String, Object>> tasks = util.executeQuery(findAssessmentTasks);
			
			if(tasks.size()>0)
			{				
				int taskId = (int)tasks.get(0).get("id");
				Assessment assess = new AssessmentDAO().findById(assessmentId);
				
				AssessmentPOJO assessment = null;
				if (assess != null && assess.getAssessmentQuestions().size() > 0) {
					assessment = getAssessmentPOJO(assess);
				}
				
				int questionsToAttend = (percentageRequired * assessment.getQuestions().size())/100;
				ViksitLogger.logMSG(this.getClass().getName(),"percebtage ="+percentageRequired+" queswtion atten ="+questionsToAttend+ " total questions ="+assessment.getQuestions().size());
				ArrayList<QuestionResponsePOJO> asses_response = new ArrayList<>();
				int quePointer =0;
				for(QuestionPOJO que : assessment.getQuestions())
				{
					if(quePointer<=questionsToAttend){
						QuestionResponsePOJO queResponse = new QuestionResponsePOJO();
						queResponse.setQuestionId(que.getId());	
						
						ArrayList<Integer>options = new ArrayList<>();
						ArrayList<Integer>answers = (ArrayList<Integer>)que.getAnswers();
						for(OptionPOJO op :que.getOptions())
						{
							if(answers.contains(op.getId()))
							{	
							options.add(op.getId());
							}
						}
						queResponse.setOptions(options);
						queResponse.setDuration(2);				
						asses_response.add(queResponse);
					}
					else
					{
						QuestionResponsePOJO queResponse = new QuestionResponsePOJO();
						queResponse.setQuestionId(que.getId());	
						
						ArrayList<Integer>options = new ArrayList<>();
						queResponse.setOptions(options);				
						queResponse.setDuration(2);				
						asses_response.add(queResponse);
					}
					quePointer++;
				}				
				
				submitAssessment(taskId,userId, asses_response, assessmentId);
			}
		
		
	}
		ViksitLogger.logMSG(this.getClass().getName(),"giveFarziData ENDS HERE ");
		
	}

	public AssessmentPOJO getAssessmentPOJO(Assessment assessment) {

		AssessmentPOJO assessmentPOJO = new AssessmentPOJO();

		assessmentPOJO.setId(assessment.getId());
		assessmentPOJO.setType(assessment.getAssessmentType());
		assessmentPOJO.setName(assessment.getAssessmenttitle());
		assessmentPOJO.setCategory(assessment.getCategory());
		assessmentPOJO.setDescription(assessment.getDescription());
		assessmentPOJO.setDurationInMinutes(assessment.getAssessmentdurationminutes());
		if (assessment.getRetryAble() != null && assessment.getRetryAble()) {
			assessmentPOJO.setRetryable(true);
		} else {
			assessment.setRetryAble(false);
		}
		Double maxPoints = 0.0;
		maxPoints = getMaxPointsOfAssessment(assessment.getId());
		assessmentPOJO.setPoints((double) Math.round(maxPoints));
		Set<AssessmentQuestion> assessmentQuestions = assessment.getAssessmentQuestions();
		ArrayList<QuestionPOJO> questions = new ArrayList<QuestionPOJO>();

		for (AssessmentQuestion assessmentQuestion : assessmentQuestions) {
			if (assessmentQuestion.getQuestion().getContext_id() == assessment.getCourse()) {
				questions.add(getQuestionPOJO(assessmentQuestion));
			}
		}
		assessmentPOJO.setQuestions(questions);

		return assessmentPOJO;
	}
	
	public QuestionPOJO getQuestionPOJO(AssessmentQuestion assessmentQuestion) {
		QuestionPOJO questionPOJO = new QuestionPOJO();

		Question question = assessmentQuestion.getQuestion();

		int orderId = assessmentQuestion.getOrderId();

		questionPOJO.setId(question.getId());
		questionPOJO.setOrderId(orderId);

		String text = "";
		if (question.getComprehensivePassageText() != null
				&& !question.getComprehensivePassageText().equalsIgnoreCase("")
				&& !question.getComprehensivePassageText().equalsIgnoreCase("null")
				&& !question.getComprehensivePassageText().equalsIgnoreCase("<p>null</p>")) {
			text = question.getComprehensivePassageText() + question.getQuestionText();
		} else {
			text = question.getQuestionText();
		}
		questionPOJO.setText(text);
		questionPOJO.setType(question.getQuestionType());
		questionPOJO.setDifficultyLevel(question.getDifficultyLevel());
		questionPOJO.setExplanation(question.getExplanation());
		questionPOJO.setComprehensivePassageText(question.getComprehensivePassageText());
		questionPOJO.setPoints(question.getPoints());
		questionPOJO.setDurationInSec(question.getDurationInSec());

		Set<AssessmentOption> allAssessmentOption = question.getAssessmentOptions();

		List<OptionPOJO> options = new ArrayList<OptionPOJO>();
		List<Integer> answers = new ArrayList<Integer>();

		for (AssessmentOption assessmentOption : allAssessmentOption) {
			if (assessmentOption.getText() != null && !assessmentOption.getText().trim().isEmpty()) {
				options.add(getOptionPOJO(assessmentOption));
				if (assessmentOption.getMarkingScheme() == 1) {
					answers.add(assessmentOption.getId());
				}
			}
		}
		questionPOJO.setOptions(options);
		questionPOJO.setAnswers(answers);

		return questionPOJO;
	}

	public OptionPOJO getOptionPOJO(AssessmentOption assessmentOption) {

		OptionPOJO optionPOJO = new OptionPOJO();

		optionPOJO.setId(assessmentOption.getId());
		optionPOJO.setText(assessmentOption.getText().replaceAll("\n", "").replaceAll("\r\n", ""));

		return optionPOJO;
	}
	
	
	public HashMap<String, Boolean> getAnsweredOptionsMap(Question question, List<Integer> options) {
		boolean isCorrect = false;

		HashMap<String, Boolean> optionsMap = new HashMap<String, Boolean>();
		List<Boolean> incorrectAnswers = new ArrayList<Boolean>();
		if (options!=null && options.size() > 0) {
			//ViksitLogger.logMSG(this.getClass().getName(),"Checking Options with MaRKED Answers");
			ArrayList<AssessmentOption> allOptions = new ArrayList<AssessmentOption>(question.getAssessmentOptions());

			for (int i = 0; i < 5; i++) {
				////ViksitLogger.logMSG(this.getClass().getName(),"Option ID--->"+allOptions.get(i).getId());
				if (i < allOptions.size() && allOptions.get(i).getMarkingScheme() == 1) {
					if (options.contains(allOptions.get(i).getId())) {
						optionsMap.put("option" + i, true);
					  //ViksitLogger.logMSG(this.getClass().getName(),i + " Answer is Correct and user marked it correct too!");
						isCorrect = true;
					} else {
						optionsMap.put("option" + i, false);
						//ViksitLogger.logMSG(this.getClass().getName(),i +" Answer is Correct and user did not marked it correct!");
						isCorrect = false;
					}
				} else if (i < allOptions.size()) {
					if (options.contains(allOptions.get(i).getId())) {
						optionsMap.put("option" + i, true);
					 //ViksitLogger.logMSG(this.getClass().getName(),i+" Answer is Not Correct and but user marked it correct!");
						isCorrect = false;
						incorrectAnswers.add(isCorrect);
					} else {
						optionsMap.put("option" + i, false);
					 //ViksitLogger.logMSG(this.getClass().getName(),i+" Answer is Not Correct and and user did not marked it also!");
					}
				} else {
					//ViksitLogger.logMSG(this.getClass().getName(),i+" Less Than 5 Options, so setting it to false");
					optionsMap.put("option" + i, false);
				}
			}
		} else {
			 //ViksitLogger.logMSG(this.getClass().getName(),"User did not attempt the question");
			for (int i = 0; i < 5; i++) {
				 //ViksitLogger.logMSG(this.getClass().getName(),i+" Setting All Options to false");
				optionsMap.put("option" + i, false);
			}
		}
		if(incorrectAnswers.size()>0){
			optionsMap.put("isCorrect", false);
		}else{
			optionsMap.put("isCorrect", isCorrect);
		}
		return optionsMap;
	}

	public Double getMaxPointsOfAssessment(Integer assessmentId) {
		
		double totalPoints = 0d;
		String per_assessment_points="",
				per_lesson_points="",
				per_question_points ="",per_assessment_coins="";
		try{
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
				if (inputStream != null) {
					properties.load(inputStream);
					per_assessment_points =  properties.getProperty("per_assessment_points");
					per_lesson_points =  properties.getProperty("per_lesson_points");
					per_question_points =  properties.getProperty("per_question_points");
					per_assessment_coins = properties.getProperty("per_assessment_coins");
					if(AppProperies.getProperty("serverConfig").equalsIgnoreCase("dev")) {
					//ViksitLogger.logMSG(this.getClass().getName(),"per_assessment_points"+per_assessment_points);
					}
				}
			} catch (IOException e) {
				e.printStackTrace();			
		}
		String getTotalPoints ="select cast (sum(TFINAL.points_per_item) as float8) as tot_points from (select cast (custom_eval ( CAST ( TRIM ( REPLACE ( REPLACE ( REPLACE ( COALESCE (max_points, '0'), ':per_lesson_points', '"+per_lesson_points+"' ), ':per_assessment_points', '"+per_assessment_points+"' ), ':per_question_points', '"+per_question_points+"' ) ) AS TEXT ) ) as integer) as points_per_item  from ((select max_points, item_id , item_type from assessment_benchmark where item_id in (select distinct questionid from assessment_question where assessmentid = "+assessmentId+" ) and item_type ='QUESTION' ) union  (select max_points , item_id , item_type from assessment_benchmark where item_id ="+assessmentId+" and item_type ='ASSESSMENT' ) )TT ) TFINAL";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(getTotalPoints);
		if(data.size()>0 && data.get(0).get("tot_points")!=null)
		{
			totalPoints=(double)data.get(0).get("tot_points");
		}
			
		return totalPoints;
	}
	
	
	private void submitAssessment(int taskId, Integer userId, ArrayList<QuestionResponsePOJO> asses_response,
			int assessmentId) {
		Task task = new TaskDAO().findById(taskId);
		IstarUser istarUser = new IstarUserDAO().findById(userId);	
		Assessment assessment = new AssessmentDAO().findById(assessmentId);
		int correctAnswersCount = 0;
			int assessmentDuration = 0;
			for (QuestionResponsePOJO questionResponsePOJO : asses_response) {
				Question question = new QuestionDAO().findById(questionResponsePOJO.getQuestionId());

				HashMap<String, Boolean> optionsMap = getAnsweredOptionsMap(question,
						questionResponsePOJO.getOptions());

				StudentAssessment studentAssessment = getStudentAssessmentOfQuestionForUser(userId, assessmentId, question.getId());

				if (studentAssessment != null) {
					if(assessment.getRetryAble()!=null && assessment.getRetryAble())
					{
						studentAssessment = updateStudentAssessment(studentAssessment,
								optionsMap.get("isCorrect"), optionsMap.get("option0"), optionsMap.get("option1"),
								optionsMap.get("option2"), optionsMap.get("option3"), optionsMap.get("option4"), null, null,
								null, questionResponsePOJO.getDuration());
					}  
					
				} else {
					studentAssessment = createStudentAssessment(assessment, question,
							istarUser, optionsMap.get("isCorrect"), optionsMap.get("option0"),
							optionsMap.get("option1"), optionsMap.get("option2"), optionsMap.get("option3"),
							optionsMap.get("option4"), null, null, null, questionResponsePOJO.getDuration());
				}

				if (optionsMap.get("isCorrect")) {
					++correctAnswersCount;
				}
				if (questionResponsePOJO.getDuration() != null) {
					assessmentDuration = assessmentDuration + questionResponsePOJO.getDuration();
				}
			}

			Double maxPoints = getMaxPointsOfAssessment(assessment.getId());			
			Report report = getAssessmentReportForUser(userId, assessmentId);			
			
			if (report == null) {
				//ViksitLogger.logMSG(this.getClass().getName(),"Report is null, creating new report");
				createReport(istarUser, assessment, correctAnswersCount, assessmentDuration,
						maxPoints.intValue(), task.getCreatedAt());
				updateUserGamificationAfterAssessment(istarUser,assessment, task.getCreatedAt());
			} else {
				//ViksitLogger.logMSG(this.getClass().getName(),"Report exists, updating report");
				if(assessment.getRetryAble()!=null && assessment.getRetryAble())
				{
					updateReport(report, istarUser, assessment, correctAnswersCount, assessmentDuration,maxPoints.intValue(), task.getCreatedAt());
					updateUserGamificationAfterAssessment(istarUser,assessment, task.getCreatedAt());
				}	
			}

			TaskServices taskServices = new TaskServices();
			taskServices.completeTask("COMPLETED", false, taskId, istarUser.getAuthToken());		
	}

	private void updatePointsAndCoinsForAssessment(IstarUser istarUser, Assessment assessment, Timestamp timestamp) {
		//here we will update points and coins for IstarUser for a particular assessment.
	/*	String per_assessment_points="",
				per_lesson_points="",
				per_question_points ="",per_assessment_coins="";
		try{
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
				if (inputStream != null) {
					properties.load(inputStream);
					per_assessment_points =  properties.getProperty("per_assessment_points");
					per_lesson_points =  properties.getProperty("per_lesson_points");
					per_question_points =  properties.getProperty("per_question_points");
					per_assessment_coins = properties.getProperty("per_assessment_coins");
					//ViksitLogger.logMSG(this.getClass().getName(),"per_assessment_points"+per_assessment_points);
				}
			} catch (IOException e) {
				e.printStackTrace();			
		}*/
		DBUTILS util = new DBUTILS();
		String findPrimaryGroupsOfUser = "SELECT distinct	batch_group.id, batch_group.college_id FROM 	batch_students, 	batch_group WHERE 	batch_group. ID = batch_students.batch_group_id AND batch_students.student_id = "+istarUser.getId()+" and batch_group.is_primary='t'";
		//ViksitLogger.logMSG(this.getClass().getName(),"findPrimaryGroupsOfUser>>"+findPrimaryGroupsOfUser);
		List<HashMap<String, Object>> primaryBG = util.executeQuery(findPrimaryGroupsOfUser);
		SimpleDateFormat to = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		for(HashMap<String, Object>primaryG : primaryBG)
		{
			int groupId = (int)primaryG.get("id");
			int orgId = (int)primaryG.get("college_id");
			String findSkillsInAssesssment = "select skill_objective_id, max_points from assessment_benchmark where "
					+ "item_id = "+assessment.getId()+" and item_type ='ASSESSMENT'";
			//ViksitLogger.logMSG(this.getClass().getName(),"findSkillsInAssesssment>>>>>>"+findSkillsInAssesssment);
			List<HashMap<String, Object>> skillsData = util.executeQuery(findSkillsInAssesssment);
			for(HashMap<String, Object> skills : skillsData)
			{
				int skillObjectiveId = (int)skills.get("skill_objective_id");
				String maxPoints = (String)skills.get("max_points");				
				String coins = "( :per_assessment_coins )";
				String getPreviousCoins="select * from user_gamification where item_id ='"+assessment.getId()+"' and item_type='ASSESSMENT' and "
						+ "istar_user='"+istarUser.getId()+"' and batch_group_id="+groupId+" and skill_objective="+skillObjectiveId+"  order by timestamp desc limit 1";
				//ViksitLogger.logMSG(this.getClass().getName(),"getPreviousCoins"+getPreviousCoins);
				List<HashMap<String, Object>> coinsData = util.executeQuery(getPreviousCoins);
				if(coinsData.size()>0)
				{
					String prevCoins = (String)coinsData.get(0).get("coins");
					coins= coins+" + "+prevCoins;
 				}
				
				String insertIntoGamification="INSERT INTO user_gamification (id,istar_user, skill_objective, points, coins, created_at, updated_at, item_id, item_type,  course_id, batch_group_id, org_id, timestamp,max_points) VALUES "
						+ "((SELECT COALESCE(MAX(ID),0)+1 FROM user_gamification),"+istarUser.getId()+", "+skillObjectiveId+",'"+maxPoints+"' , '"+coins+"', '"+to.format(timestamp)+"', now(), "+assessment.getId()+", 'ASSESSMENT', "+assessment.getCourse()+", "+groupId+", "+orgId+", '"+to.format(timestamp)+"','"+maxPoints+"');";
				//ViksitLogger.logMSG(this.getClass().getName(),"insertIntoGamification>>>>"+insertIntoGamification);
				util.executeUpdate(insertIntoGamification);
			}			
		}
		
	}

	public void updateUserGamificationAfterAssessment(IstarUser istarUser, Assessment assessment, Timestamp timestamp ) {
		updatePointsAndCoinsForAssessment(istarUser, assessment, timestamp);
		updatePointsAndCoinsForQuestion(istarUser,assessment, timestamp);
	}

	private void updatePointsAndCoinsForQuestion(IstarUser istarUser, Assessment assessment, Timestamp timestamp) {
		
		
		DBUTILS util = new DBUTILS();
		String findPrimaryGroupsOfUser = "SELECT distinct	batch_group.id, batch_group.college_id FROM 	batch_students, 	batch_group WHERE 	batch_group. ID = batch_students.batch_group_id AND batch_students.student_id = "+istarUser.getId()+" and batch_group.is_primary='t'";
		//ViksitLogger.logMSG(this.getClass().getName(),"findPrimaryGroupsOfUser>>"+findPrimaryGroupsOfUser);
		List<HashMap<String, Object>> primaryBG = util.executeQuery(findPrimaryGroupsOfUser);
		SimpleDateFormat to = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		for(HashMap<String, Object>primaryG : primaryBG)
		{
			int groupId = (int)primaryG.get("id");
			int orgId = (int)primaryG.get("college_id");
			ArrayList<Integer> questionAnsweredCorrectly = new ArrayList<>();
			String findQueAnsweredCorrectly= "select distinct question_id from student_assessment where assessment_id ="+assessment.getId()+" and student_id="+istarUser.getId()+" and correct='t'";
			//ViksitLogger.logMSG(this.getClass().getName(),"correct que id "+findQueAnsweredCorrectly );
			List<HashMap<String, Object>> correctQueAnsweredData = util.executeQuery(findQueAnsweredCorrectly);
			for(HashMap<String, Object> qro : correctQueAnsweredData)
			{
				//ViksitLogger.logMSG(this.getClass().getName(),"correct que id"+(int)qro.get("question_id"));
				questionAnsweredCorrectly.add((int)qro.get("question_id"));
			}
			
			String findQuestionForAssessment="select distinct questionid from assessment_question, question, assessment where assessment_question.questionid = question.id and assessment_question.assessmentid = assessment.id and assessment.course_id = question.context_id and assessment.id = "+assessment.getId();
			List<HashMap<String, Object>> questionData = util.executeQuery(findQuestionForAssessment);
			for(HashMap<String, Object> qRow: questionData)
			{
				int questionId = (int)qRow.get("questionid");
				
				
				String findSkillsInQuestion = "select skill_objective_id, max_points from assessment_benchmark where item_id = "+questionId+" and item_type ='QUESTION'";
				//ViksitLogger.logMSG(this.getClass().getName(),"findSkillsInAssesssment>>>>>>"+findSkillsInQuestion);
				List<HashMap<String, Object>> skillsData = util.executeQuery(findSkillsInQuestion);
				for(HashMap<String, Object> skills : skillsData)
				{
					int skillObjectiveId = (int)skills.get("skill_objective_id");
					String maxPoints = (String)skills.get("max_points");
					String pointsScored = maxPoints;
					String coins = "( :per_question_coins )";
					
											
					String getPreviousCoins="select * from user_gamification where item_id ='"+questionId+"' and item_type='QUESTION' and istar_user='"+istarUser.getId()+"' and batch_group_id="+groupId+" and skill_objective="+skillObjectiveId+"  order by timestamp desc limit 1";
					//ViksitLogger.logMSG(this.getClass().getName(),"getPreviousCoins"+getPreviousCoins);
					List<HashMap<String, Object>> coinsData = util.executeQuery(getPreviousCoins);
					if(coinsData.size()>0)
					{
						String prevCoins = (String)coinsData.get(0).get("coins");
						coins= coins+" + "+prevCoins;
						pointsScored = (String)coinsData.get(0).get("points");
						if(assessment.getRetryAble()!= null && assessment.getRetryAble())
						{
							if(questionAnsweredCorrectly.contains(questionId))
							{
								//ViksitLogger.logMSG(this.getClass().getName(),"questionAnsweredCorrectly contains "+ questionId);
								pointsScored = maxPoints;
							}
							else
							{
								//ViksitLogger.logMSG(this.getClass().getName(),"questionAnsweredCorrectl do not  contains "+ questionId);
								pointsScored = "0";
							}	
							
						}
						
	 				}
					else
					{
						//user has not answerd thos question previously 
						if(!questionAnsweredCorrectly.contains(questionId))
						{
							pointsScored="0";
							
						}
					}	
					
					
					
					String insertIntoGamification="INSERT INTO user_gamification (id,istar_user, skill_objective, points, coins, created_at, updated_at, item_id, item_type,  course_id, batch_group_id, org_id, timestamp,max_points) VALUES "
							+ "((SELECT COALESCE(MAX(ID),0)+1 FROM user_gamification),"+istarUser.getId()+", "+skillObjectiveId+",'"+pointsScored+"' , '"+coins+"', '"+to.format(timestamp)+"', '"+to.format(timestamp)+"', "+questionId+", 'QUESTION', "+assessment.getCourse()+", "+groupId+", "+orgId+", '"+to.format(timestamp)+"','"+maxPoints+"');";
					//ViksitLogger.logMSG(this.getClass().getName(),"insertIntoGamification>>>>"+insertIntoGamification);
					util.executeUpdate(insertIntoGamification);
				}
			}						
		}		
	}	
	
public Report createReport(IstarUser istarUser, Assessment assessment, Integer score,  Integer timeTaken, Integer totalPoints, Timestamp timestamp){
		
		Report report = new Report();
		
		
		
		report.setIstarUser(istarUser);
		report.setAssessment(assessment);
		report.setTotalPoints(totalPoints);
		report.setCreatedAt(timestamp);
		report.setScore(score);
		report.setTimeTaken(timeTaken);		
		
		report = saveReportToDAO(report);
		
		return report;
	}
	
	public Report updateReport(Report report, IstarUser istarUser, Assessment assessment, Integer score,  Integer timeTaken, Integer totalPoints, Timestamp timestamp){

		java.util.Date date = new java.util.Date();
		
		
		report.setIstarUser(istarUser);
		report.setAssessment(assessment);
		report.setTotalPoints(totalPoints);
		report.setScore(score);
		report.setTimeTaken(timeTaken);	
		report.setCreatedAt(timestamp);
		
		report = updateReportToDAO(report);
		
		return report;
	}
	
	
	public Report saveReportToDAO(Report report) {

		ReportDAO reportDAO = new ReportDAO();

		Session reportSession = reportDAO.getSession();
		Transaction reportTransaction = null;
		try {
			reportTransaction = reportSession.beginTransaction();
			reportSession.save(report);
			reportTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (reportTransaction != null)
				reportTransaction.rollback();
		} finally {
			reportSession.close();
		}
		return report;
	}

	public Report updateReportToDAO(Report report) {

		ReportDAO reportDAO = new ReportDAO();

		Session reportSession = reportDAO.getSession();
		Transaction reportTransaction = null;
		try {
			reportTransaction = reportSession.beginTransaction();
			reportSession.update(report);
			reportTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (reportTransaction != null)
				reportTransaction.rollback();
		} finally {
			reportSession.close();
		}
		return report;
	}
	
	
	@SuppressWarnings("unchecked")
	public Report getAssessmentReportForUser(int istarUserId, int assessmentId){
		
		Report report = null;
		String hql = "from Report report where istarUser.id= :istarUserId and assessment.id= :assessmentId";
				
		BaseHibernateDAO baseHibernateDAO = new BaseHibernateDAO();
		Session session = baseHibernateDAO.getSession();
		
		Query query = session.createQuery(hql);
		query.setParameter("istarUserId",istarUserId);
		query.setParameter("assessmentId", assessmentId);
		
		List<Report> allReports = query.list();
		
		if(allReports.size()>0){
			report = allReports.get(0);
		}
		return report;
	}
	
	
	
	
	public StudentAssessment createStudentAssessment(Assessment assessment, Question question, IstarUser istarUser, Boolean correct, 
			Boolean option1, Boolean option2, Boolean option3, Boolean option4, Boolean option5, Integer countryId, 
			Integer organizationId, Integer batchGroupId, Integer timeTaken){
		
		StudentAssessment studentAssessment = new StudentAssessment();
		
		studentAssessment.setAssessment(assessment);
		studentAssessment.setQuestion(question);
		studentAssessment.setIstarUser(istarUser);
		studentAssessment.setCorrect(correct);
		studentAssessment.setOption1(option1);
		studentAssessment.setOption2(option2);
		studentAssessment.setOption3(option3);
		studentAssessment.setOption4(option4);
		studentAssessment.setOption5(option5);
		studentAssessment.setCountryId(countryId);
		studentAssessment.setOrganizationId(organizationId);
		studentAssessment.setBatchGroupId(batchGroupId);
		studentAssessment.setTimeTaken(timeTaken);
		
		studentAssessment = saveStudentAssessmentToDAO(studentAssessment);
		
		return studentAssessment;
	}
	
	public StudentAssessment saveStudentAssessmentToDAO(StudentAssessment studentAssessment) {

		StudentAssessmentDAO studentAssessmentDAO = new StudentAssessmentDAO();

		Session studentAssessmentSession = studentAssessmentDAO.getSession();
		Transaction studentAssessmentTransaction = null;
		try {
			studentAssessmentTransaction = studentAssessmentSession.beginTransaction();
			studentAssessmentSession.save(studentAssessment);
			studentAssessmentTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (studentAssessmentTransaction != null)
				studentAssessmentTransaction.rollback();
		} finally {
			studentAssessmentSession.close();
		}
		return studentAssessment;
	}
	
	
	public StudentAssessment updateStudentAssessment(StudentAssessment studentAssessment, Boolean correct, 
			Boolean option1, Boolean option2, Boolean option3, Boolean option4, Boolean option5, Integer countryId, 
			Integer organizationId, Integer batchGroupId, Integer timeTaken){
		
		//ViksitLogger.logMSG(this.getClass().getName(),"Updating to DAO");
		
		studentAssessment.setCorrect(correct);
		studentAssessment.setOption1(option1);
		studentAssessment.setOption2(option2);
		studentAssessment.setOption3(option3);
		studentAssessment.setOption4(option4);
		studentAssessment.setOption5(option5);
		studentAssessment.setCountryId(countryId);
		studentAssessment.setOrganizationId(organizationId);
		studentAssessment.setBatchGroupId(batchGroupId);
		studentAssessment.setTimeTaken(timeTaken);
		
		studentAssessment = updateStudentAssessmentToDAO(studentAssessment);
		
		return studentAssessment;
	}
	
	public StudentAssessment updateStudentAssessmentToDAO(StudentAssessment studentAssessment) {

		StudentAssessmentDAO studentAssessmentDAO = new StudentAssessmentDAO();

		Session studentAssessmentSession = studentAssessmentDAO.getSession();
		Transaction studentAssessmentTransaction = null;
		try {
			studentAssessmentTransaction = studentAssessmentSession.beginTransaction();
			studentAssessmentSession.update(studentAssessment);
			studentAssessmentTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (studentAssessmentTransaction != null)
				studentAssessmentTransaction.rollback();
		} finally {
			studentAssessmentSession.close();
		}
		return studentAssessment;
	}
	
	@SuppressWarnings("unchecked")
	public StudentAssessment getStudentAssessmentOfQuestionForUser(int istarUserId, int assessmentId, int questionId){
	
		StudentAssessment studentAssessment = null;
		
		String hql = "from StudentAssessment studentAssessment where assessment.id= :assessment and istarUser.id= :istarUser and question.id= :question";

		BaseHibernateDAO baseHibernateDAO = new BaseHibernateDAO();
		Session session = baseHibernateDAO.getSession();

		Query query = session.createQuery(hql);
		query.setParameter("assessment", assessmentId);
		query.setParameter("istarUser", istarUserId);
		query.setParameter("question", questionId);
		
		List<StudentAssessment> allStudentAssessment = query.list();
		
		if(allStudentAssessment.size() > 0){
			studentAssessment = allStudentAssessment.get(0);
		}
		return studentAssessment;
	}
	
	private  void createAssesssmentTaskForAllBgs(int orgID) {
		FarziDataCreatorServices serv = new FarziDataCreatorServices();
		IstarNotificationServices notificationService = new IstarNotificationServices();
		Organization org = new OrganizationDAO().findById(orgID);
		for(BatchGroup bg : org.getBatchGroups())
		{		
			
			ArrayList<Integer>assessmentIds = new ArrayList<>();
			
			for(Batch batch :bg.getBatchs())
			{
				for(Module module : batch.getCourse().getModules())
				{
					for(Cmsession cms : module.getCmsessions())
					{
						for(Lesson lesson : cms.getLessons())
						{
							if(lesson.getType().equalsIgnoreCase("ASSESSMENT") && lesson.getLessonXml()!=null && !lesson.getLessonXml().equalsIgnoreCase(""))
							{
								Assessment ass = new AssessmentDAO().findById(Integer.parseInt(lesson.getLessonXml()));
								if(ass!=null && ass.getAssessmentQuestions().size()>0) {
									assessmentIds.add(Integer.parseInt(lesson.getLessonXml()));
								}
							}	
						}	
					}	
				}
			}
			
			ViksitLogger.logMSG(this.getClass().getName(),"assessments size ="+assessmentIds.size());
			SimpleDateFormat to = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(assessmentIds.size()>0)
			{
				int totalAssesments = assessmentIds.size();
				Date d = new Date(System.currentTimeMillis());
				Calendar start = Calendar.getInstance();
				start.add(Calendar.DATE, -1*totalAssesments);
				Calendar end = Calendar.getInstance();
				end.add(Calendar.DATE,1);
				
				Date statrtDate = new Date(start.getTimeInMillis());
				Date endDate = new Date(end.getTimeInMillis());
				
				ViksitLogger.logMSG(this.getClass().getName(),statrtDate);
				ViksitLogger.logMSG(this.getClass().getName(),endDate);
				
				int assessmentCounter = 0;
				
				
				for (Date date = statrtDate; date.before(endDate); start.add(Calendar.DATE, 1), date = start.getTime()) {				    
				    ViksitLogger.logMSG(this.getClass().getName(),date);
				    if(assessmentCounter<totalAssesments)
				    {
				    	int itemId = assessmentIds.get(assessmentCounter);
				    	
				    	Assessment assessment = new AssessmentDAO().findById(itemId);
				    	Course course = new CourseDAO().findById(assessment.getCourse());
				    	String notificationTitle = "An assessment with title <b>"+assessment.getAssessmenttitle()+"</b> of course <b>"+course.getCourseName()+"</b> has been added to task list.";
				    	String notificationDescription =  notificationTitle;
				    	String taskTitle = assessment.getAssessmenttitle();
				    	String taskDescription = notificationDescription;				    	
				    	String groupNotificationCode = UUID.randomUUID().toString();
				    	
				    	for(BatchStudents bs : bg.getBatchStudentses())
				    	{				    		
				    		int taskId = serv.createTaskForDate(taskTitle.trim().replace("'", ""), taskDescription.trim().replace("'", ""), "300", bs.getIstarUser().getId()+"", itemId+"", "ASSESSMENT", to.format(date));
				    		IstarNotification istarNotification = notificationService.createIstarNotification(300, bs.getIstarUser().getId(), notificationTitle, notificationDescription, "UNREAD", null, NotificationType.ASSESSMENT, true, taskId, groupNotificationCode);
				    	}	
				    	
				    }
				    assessmentCounter++;
				}				
			}
			else
			{
				ViksitLogger.logMSG(this.getClass().getName(),"no assessment is thr ");
			}	

		}
	}	
}
