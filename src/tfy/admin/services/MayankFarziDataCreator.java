package tfy.admin.services;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.persistence.criteria.CriteriaBuilder.In;
import javax.ws.rs.core.Response;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.github.javafaker.Faker;
import com.istarindia.android.pojo.AssessmentPOJO;
import com.istarindia.android.pojo.ClassFeedbackByTrainer;
import com.istarindia.android.pojo.FeedbackPojo;
import com.istarindia.android.pojo.GroupPojo;
import com.istarindia.android.pojo.GroupStudentPojo;
import com.istarindia.android.pojo.OptionPOJO;
import com.istarindia.android.pojo.QuestionPOJO;
import com.istarindia.android.pojo.QuestionResponsePOJO;
import com.istarindia.android.pojo.RestClient;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchDAO;
import com.viksitpro.core.dao.entities.ClassroomDetails;
import com.viksitpro.core.dao.entities.ClassroomDetailsDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;
import com.viksitpro.core.utilities.TaskItemCategory;
import com.viksitpro.core.utilities.TrainerWorkflowStages;

import in.orgadmin.admin.services.EventSchedulerService;

/**
 * 
 */

/**
 * @author mayank
 *
 */
public class MayankFarziDataCreator {

	/**
	 * @param args
	 */
	public  void main() {
		// TODO Auto-generated method stub
		/* String csvFile = "C:\\Users\\mayank\\Documents\\it.csv";
	        BufferedReader br = null;
	        String line = "";
	        String cvsSplitBy = ",";
	        int college_id = 0;
	        try {
                DBUTILS db = new DBUTILS();
	            br = new BufferedReader(new FileReader(csvFile));
	            while ((line = br.readLine()) != null) {
	                String[] country = line.split(cvsSplitBy);
	                String orgName = country[0];
	                if(college_id==0){
	                String sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), 'Phase 2', 'Manyata Tech Park', 154819, '73.8834149', '18.4866277' )RETURNING ID;";
	    			int addressId = db.executeUpdateReturn(sql);

	    			sql = "INSERT INTO organization (id, name, org_type, address_id, industry, profile,created_at, updated_at, iscompany, max_student) VALUES "
	    					+ "((select COALESCE(max(id),0)+1 from organization ), '"+orgName+"', 'COLLEGE', "+addressId+", 'EDUCATION', 'NA',  now(), now(), 'f',1000) RETURNING ID;";
	    			college_id = db.executeUpdateReturn(sql);
	    			String  adminEmail= country[1];
	    			
	    			String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) "
							+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+adminEmail+"', 'test123', 		now(), 		'9856321474', 		NULL,    'f' 	)RETURNING ID;";
					
					//System.out.println(istarStudentSql);
					int userID  = db.executeUpdateReturn(istarStudentSql);
						
					String insertIntoUserProfile ="INSERT INTO user_profile (id, first_name, last_name,  gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), 'Abhinav', 'Singh', 'MALE', "+userID+");";
					db.executeUpdate(insertIntoUserProfile);

					//Student User Role Mapping
						String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
						//System.out.println(userRoleMappingSql);
						db.executeUpdate(userRoleMappingSql);
						String insertIntoOrgMapping="INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("+userID+", "+college_id+", (select COALESCE(max(id),0)+1 from user_org_mapping));"; 
						db.executeUpdate(insertIntoOrgMapping);					
	                }
	                else
	                {
	                	String roleName = country[2];
	                	String checkIfRoleExist ="select id from batch_group where name='"+roleName+"' and college_id="+college_id;
	                	List<HashMap<String, Object>> existingRoleData = db.executeQuery(checkIfRoleExist);
	                	int roleId =0;
	                	if(existingRoleData.size()>0 && existingRoleData.get(0).get("id")!=null)
	                	{
	                		 roleId = (int)existingRoleData.get(0).get("id");
	                	}
	                	else
	                	{
	                		//createROle
	                		String createRole ="INSERT INTO batch_group (id, created_at, name, updated_at, college_id, batch_code, assessment_id, bg_desc, year, parent_group_id, type, is_primary, is_historical_group, mode_type, start_date, enrolled_students)  "
	                				+ "VALUES ((select COALESCE(max(id),0)+1 from batch_group), now(), '"+roleName+"', now(), "+college_id+", "+getRandomInteger(100000, 999999)+", '10195', '"+roleName+"', '2017', '1', 'ROLE', 't', 'f','BLENDED', '2017-06-12', 1000) returning id;";
	                		roleId = db.executeUpdateReturn(createRole);	                			                		
	                	}
	                	
	                	String sectionName = country[4];
	                	String checkIFSEctionExist ="select id from batch_group where name='"+sectionName+"' and parent_group_id="+roleId;
	                	List<HashMap<String, Object>> existingSectionData = db.executeQuery(checkIFSEctionExist);
	                	int sectionId=0;
	                	if(existingSectionData.size()>0 && existingSectionData.get(0).get("id")!=null)
	                	{
	                		sectionId = (int)existingSectionData.get(0).get("id");
	                	}
	                	else
	                	{
	                		String createSection ="INSERT INTO batch_group (id, created_at, name, updated_at, college_id, batch_code, assessment_id, bg_desc, year, parent_group_id, type, is_primary, is_historical_group, mode_type, start_date, enrolled_students)  "
	                				+ "VALUES ((select COALESCE(max(id),0)+1 from batch_group), now(), '"+sectionName+"', now(), "+college_id+", "+getRandomInteger(100000, 999999)+", '10195', '"+sectionName+"', '2017', '1', 'SECTION', 'f', 'f','BLENDED', '2017-06-12', 1000) returning id;";
	                		sectionId = db.executeUpdateReturn(createSection);	                		
	                	}
	                	
	                }	
	                
	            }

	        } catch (FileNotFoundException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            if (br != null) {
	                try {
	                    br.close();
	                } catch (IOException e) {
	                    e.printStackTrace();
	                }
	            }
	        }*/
	    System.out.println("start");
		//addStudentInBGOFCollege(272);
		//addStudentInBGOFCollege(273);
		createEventsForGroup(273);
	    cerateAssessmentFor(273);
	    markEventAsCompleteInOrg(273);
	   
		//markEventAsCompleteInOrg(273);
		System.out.println("end");
		System.exit(0);
		
		
	}

	private void cerateAssessmentFor(int i) {
		DBUTILS util = new DBUTILS();
		TaskServices taskService = new TaskServices();
		IstarNotificationServices notificationService = new IstarNotificationServices();
		String getAssessmentID ="select DISTINCT item_id from assessment_benchmark where item_type ='ASSESSMENT'";
		List<HashMap<String, Object>> ass = util.executeQuery(getAssessmentID);
		for(HashMap<String, Object> a : ass)
		{
			int assId = (int)a.get("item_id");
			Assessment assessment = new AssessmentDAO().findById(assId);
			Course course = new CourseDAO().findById(assessment.getCourse());
			String notificationTitle = "An assessment with title <b>"+assessment.getAssessmenttitle()+"</b> of course <b>"+course.getCourseName()+"</b> has been added to task list.";
			String notificationDescription =  notificationTitle;
			String taskTitle = assessment.getAssessmenttitle();
			String taskDescription = notificationDescription;
			
			
			
			String studentIds = "select DISTINCT user_id from user_org_mapping where organization_id = "+i;
			String adminId = "300";
			String groupNotificationCode = UUID.randomUUID().toString();
			List<HashMap<String, Object>> uesrs = util.executeQuery(studentIds);
			for(HashMap<String, Object> studentId: uesrs)
			{	
				int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""), taskDescription.trim().replace("'", ""), adminId, (int)studentId.get("user_id")+"", assId+"", "ASSESSMENT");
				IstarNotification istarNotification = notificationService.createIstarNotification(Integer.parseInt(adminId), (int)studentId.get("user_id"), notificationTitle, notificationDescription, "UNREAD", null, NotificationType.ASSESSMENT, true, taskId, groupNotificationCode);
				
				
			}
		}	
		
	}

	private void createEventsForGroup(int orgid) {
		
		int trainers[] = {8 ,127 ,128 ,129 ,130 ,131 ,132 ,133 ,134 ,135 ,136 ,137 ,138 ,139 ,140 ,141};
		int classrooms[] ={24 ,25 ,26 ,27 ,28 ,29 ,30 ,31 ,32 ,33 ,34 ,35 ,36 ,37 ,38 ,39 ,40 ,41 ,42 ,43 ,44 ,45 ,46 ,47 ,48 ,49 ,50 ,51 ,52};
		
		DBUTILS util = new DBUTILS();
		Calendar c = Calendar.getInstance();
		c.setTime(new Date()); // Now use today date.
		c.add(Calendar.DAY_OF_MONTH, -7);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		for(int j = 0; j< 16;j++)
		{
			
			
			String findBG ="select * from batch_group where college_id = "+orgid+" order by id limit 15";
			List<HashMap<String, Object>> bgs = util.executeQuery(findBG);
			int k=0;
			for(HashMap<String, Object> bg : bgs)
			{
				
				Calendar temp = c;
				String output = sdf.format(temp.getTime());
				int trainerID = trainers[k];
				int hours = 0;
				int minute = 30;
				String getbatchID ="select id from batch where batch_group_id = "+bg.get("id")+" limit 1";
				List<HashMap<String, Object>> ddd = util.executeQuery(getbatchID);
				for(HashMap<String, Object> row: ddd)
				{
					int batchID = (int)row.get("id");					
					String eventDate = output;
					if(!eventDate.contains("27"))
					{
						String startTime = "";
						int classroomID = classrooms[k];
						int AdminUserID = 300;
						
						String eventID = null;
						String associateTrainerID = "";
						System.out.println("trainer id "+ trainerID);
						System.out.println("eventDate id "+ eventDate);
						System.out.println("batchID "+ batchID);
						System.out.println("classroomID "+ classroomID);
						createEvent(trainerID, hours, minute, batchID, eventDate, startTime,AdminUserID, classroomID, -1, associateTrainerID);
						
					}
					
				}	
				
				
				k++;
				temp.add(Calendar.MINUTE, 32);
			}
			c.add(Calendar.DAY_OF_MONTH, 1);
		}
		
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
		/*if (cmsessionID == -1) {
			cmsessionID = -1;
			action = "cmsession_id__-1";
		}*/

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
			//System.out.println("trainerBatchSql-----> "+trainerBatchSql);

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
			//noticeDelegator.sendNotificationToUser(istarNotificationForStudent.getId(), stuId+"", notificationTitle.trim().replace("'", ""), NotificationType.CLASSROOM_SESSION, itemForStudent);  						
		}
		
		
		for(Integer userKey : userToEventMap.keySet())
		{
			String mapWithQueue ="INSERT INTO event_queue_event_mapping ( ID, event_queue_id, event_for, user_id, event_id, created_at, updated_at ) values ( ( SELECT COALESCE (MAX(ID) + 1, 1) FROM event_queue_event_mapping ), "+masterEventQueueId+", 'mapping for "+eventQueueName+" ', "+userKey+", "+userToEventMap.get(userKey)+", now(), now() )";
			db.executeUpdate(mapWithQueue);
		}
		

	}
	
	private void markEventAsCompleteInOrg(int orgId) {
		
			attendaceCreator(orgId);
			submitFeedback(orgId);
			attempAssessment(orgId);
	}

	private void attempAssessment(int orgId) {
		DBUTILS util = new DBUTILS();
		
		String findOrgUSer="select DISTINCT user_id from user_org_mapping where organization_id = "+orgId;
		List<HashMap<String, Object>> userdata = util.executeQuery(findOrgUSer);
		for(HashMap<String, Object> rr : userdata)
		{
			int urseId = (int)rr.get("user_id");
			String findAssessmentTasks = "select id, item_id from task where item_type='ASSESSMENT' and actor="+urseId;
			List<HashMap<String, Object>> data = util.executeQuery(findAssessmentTasks);
			for(HashMap<String, Object> row: data)
			{
				int assessmentId = (int)row.get("item_id");
				int taskId = (int)row.get("id");
				RestClient client = new  RestClient();

				AssessmentPOJO assessment = client.getAssessment(assessmentId, urseId);
				ArrayList<QuestionResponsePOJO> asses_response = new ArrayList<>();
				for(QuestionPOJO que : assessment.getQuestions())
				{
					QuestionResponsePOJO queResponse = new QuestionResponsePOJO();
					queResponse.setQuestionId(que.getId());	
					
					ArrayList<Integer>options = new ArrayList<>();
					for(OptionPOJO op :que.getOptions())
					{
						options.add(op.getId());				
						queResponse.setOptions(options);
					}
					
					queResponse.setDuration(2);				
					asses_response.add(queResponse);						
				}				
				try {
					client.SubmitAssessment(taskId,urseId, asses_response, assessmentId);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		}
		
		
	}

	private  void submitFeedback(int orgId) {
		// TODO Auto-generated method stub
		DBUTILS util = new DBUTILS();
		String getTaskBeforeToday ="select * from task where item_id in (select id from batch_schedule_event where type = 'BATCH_SCHEDULE_EVENT_TRAINER' and batch_group_id in (select id from batch_group where college_id = "+orgId+") and eventdate <  '2017-07-28 09:32:00' ) and item_type = 'CLASSROOM_SESSION'";
		List<HashMap<String, Object>> events = util.executeQuery(getTaskBeforeToday);
		ClassFeedbackByTrainer feedbackResponse = new ClassFeedbackByTrainer();
		
		for(HashMap<String, Object> row: events)
		{
			
			int task_id = (int)row.get("id");
			int actor = (int)row.get("actor");
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
			
			submitFeedbackByTrainer(task_id, actor, feedbackResponse);
			
		}
	}

	public static String randomNumber() {
		float leftLimit = 0F;
	    float rightLimit = 5F;
	    float generatedFloat = leftLimit + new Random().nextFloat() * (rightLimit - leftLimit);
	    DecimalFormat df = new DecimalFormat();
	    df.setMaximumFractionDigits(1);
		return df.format(generatedFloat);
	}

	public  void submitFeedbackByTrainer(int taskId, int istarUserId, ClassFeedbackByTrainer feedbackResponse) {
		
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
		
		updateState(taskId, istarUserId,TrainerWorkflowStages.COMPLETED);
		
	}

	private void attendaceCreator(int orgId) {
		// TODO Auto-generated method stub
		DBUTILS util = new DBUTILS();
		String getTaskBeforeToday ="select * from task where item_id in (select id from batch_schedule_event where type = 'BATCH_SCHEDULE_EVENT_TRAINER' and batch_group_id in (select id from batch_group where college_id = "+orgId+") and eventdate <  '2017-07-28 09:32:00' ) and item_type = 'CLASSROOM_SESSION'";
		List<HashMap<String, Object>> events = util.executeQuery(getTaskBeforeToday);
		for(HashMap<String, Object> row: events)
		{
			int id = (int)row.get("id");
			int actor = (int)row.get("actor");
			com.istarindia.android.pojo.GroupPojo group = new com.istarindia.android.pojo.GroupPojo();
			String getGroupId ="select batch_group_id, batch_group.name from task,batch_schedule_event, batch_group where batch_group.id = batch_schedule_event.batch_group_id and batch_schedule_event.id = task.item_id and task.id ="+id+" and item_type in ('"+TaskItemCategory.CLASSROOM_SESSION+"') ";
			//System.out.println("getGroupId>>>"+getGroupId);
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
				
				submitAttendance(id,actor , group);	
				updateState(id, actor,TrainerWorkflowStages.ATTENDANCE);
			}
			
		}
	}

	public void updateState(int taskId, int istarUserId, String state) {
		
		DBUTILS util = new DBUTILS();
		String fineCourseBGeventId ="select batch_group_id, course_id, id from batch_schedule_event where id = (select item_id from task where id ="+taskId+")";
		List<HashMap<String, Object>> detail = util.executeQuery(fineCourseBGeventId);		
		if(detail.size()>0)
		{
			
			String bgId = detail.get(0).get("batch_group_id").toString();
			String courseId = detail.get(0).get("course_id").toString();
			String id = detail.get(0).get("id").toString();			
			String insertIntoLog="INSERT INTO status_change_log (id, trainer_id, course_id,  created_at, updated_at,  event_type, event_status, event_id, batch_group_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from status_change_log), "+istarUserId+", "+courseId+", now(),now(), 'STATUS_CHANGED', '"+state+"', "+id+",  "+bgId+");";
			util.executeUpdate(insertIntoLog);
			
			String updateBSE="update batch_schedule_event set status ='"+state+"' where id=(select item_id from task where id ="+taskId+")";
			util.executeUpdate(updateBSE);
			
		}	
		
		
	}

	public void submitAttendance(int taskId, int istarUserId, GroupPojo attendanceResponse) {
		
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
		
		//System.err.println(sql);
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
	private static void addStudentInBGOFCollege(int orgId) {
		String  findBGOfOrg="select * from  batch_group where college_id="+orgId+" and type='ROLE'";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> bgs = util.executeQuery(findBGOfOrg);
		for(HashMap<String, Object> bg:bgs)
		{
			int bgId = (int)bg.get("id");
			short enrolledStudents = (short)bg.get("enrolled_students");
			ArrayList<Integer> studs = cerateStudentAndAddInRole(bgId, enrolledStudents, orgId);
			int studCountter =0;
			String findSectionsUnderRole = "select * from  batch_group where parent_group_id="+bgId;
			List<HashMap<String, Object>> sections = util.executeQuery(findSectionsUnderRole);
			ArrayList<Integer>addeddInSection = new ArrayList<>();
			for(HashMap<String, Object> section : sections)
			{
				int sectionID = (int)section.get("id");
				
				
				ArrayList<Integer>addeddInSubsection = new ArrayList<>();
				String findSubsection ="select * from  batch_group where parent_group_id="+sectionID;
				List<HashMap<String, Object>> subSections = util.executeQuery(findSubsection);
				for(HashMap<String, Object> subSection : subSections)
				{
					int subSectionID = (int)subSection.get("id");
					short enrolledInSubSEction = (short)subSection.get("enrolled_students");
					for(int i = studCountter; i<enrolledInSubSEction; i++,studCountter++)
					{
						//insertinSubsection;
						
						String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0)+1 from batch_students)),"
								+ subSectionID + "," + studs.get(i) + ",'STUDENT')";
						System.out.println(insert_into_bg);
						util.executeUpdate(insert_into_bg);
						addeddInSubsection.add(studs.get(i));
						
					}	
				}
				for(int j : addeddInSubsection)
				{
					//add in section
					String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0)+1 from batch_students)),"
							+ sectionID + "," + j + ",'STUDENT')";
					System.out.println(insert_into_bg);
					util.executeUpdate(insert_into_bg);
					addeddInSection.add(j);
				}	
			}
			
		}
	}

	private static ArrayList<Integer> cerateStudentAndAddInRole(int bgId, int enrolledStudents, int orgId) {
		ArrayList<Integer> studs = new ArrayList<>();
		DBUTILS db = new DBUTILS();
		for(int i=0;i<enrolledStudents;i++)
		{
			Faker faker = new Faker();

			String name = faker.name().fullName();
			String firstName = faker.name().firstName().replace("'", "");
			String lastName = faker.name().lastName().replace("'", "");
			String email = faker.name().firstName().toLowerCase()+"@istarindia.com".replace("'", "");
			String mobile = faker.number().digits(10);
			
			// Insert new Student
			
			String sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), 'Phase 2', 'Manyata Tech Park', 154819, '73.8834149', '18.4866277' )RETURNING ID;";
			int addressId = db.executeUpdateReturn(sql);

			
						String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email.replace("'", "")+"', 		'test123', 		now(), 		'"+mobile+"', 		NULL,    'f' 	)RETURNING ID;";
						System.out.println(istarStudentSql);
						
						 int userID  = db.executeUpdateReturn(istarStudentSql);
							

						//Student User Role Mapping
							String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name = 'STUDENT'), (SELECT MAX(id)+1 FROM user_role), '1');";
							System.out.println(userRoleMappingSql);
							db.executeUpdate(userRoleMappingSql);
							
							//Trainer Student  User Profile
							String UserProfileSql = "INSERT INTO user_profile ( 	id, 	address_id, 	first_name, 	last_name, 	dob, 	gender, 	user_id, 	aadhar_no ) VALUES 	( 		(SELECT MAX(id)+1 FROM user_profile), 		"+addressId+", 		'"+firstName+"', 		'"+lastName+"', 	NULL,	'MALE',   "+userID+", 		NULL 	); ";
							System.out.println(UserProfileSql);
							db.executeUpdate(UserProfileSql);
							

							//Trainer Student User Org Mapping
							String userOrgMappingSql = "INSERT INTO user_org_mapping ( 	user_id, 	organization_id, 	id ) VALUES 	("+userID+", "+orgId+", (SELECT MAX(id)+1 FROM user_org_mapping));";
							System.out.println(userOrgMappingSql);
							db.executeUpdate(userOrgMappingSql);
							
							String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0)+1 from batch_students)),"
									+ bgId + "," + userID + ",'STUDENT')";
							System.out.println(insert_into_bg);
							db.executeUpdate(insert_into_bg);
							studs.add(userID);
							
		}
		return studs;
	}

	public static int getRandomInteger(int maximum, int minimum) {
		return ((int) (Math.random() * (maximum - minimum))) + minimum;
	}
}
