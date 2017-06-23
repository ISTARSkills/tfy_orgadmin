import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.lang3.RandomStringUtils;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.istarindia.android.pojo.AssessmentPOJO;
import com.istarindia.android.pojo.OptionPOJO;
import com.istarindia.android.pojo.QuestionPOJO;
import com.istarindia.android.pojo.QuestionResponsePOJO;
import com.istarindia.android.pojo.RestClient;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.dao.entities.UserOrgMapping;
import com.viksitpro.core.dao.entities.UserRole;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.EmailUtils;
import com.viksitpro.core.utilities.NotificationType;
import com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes;
import com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportList;
import in.orgadmin.utils.report.CustomReportUtils;
import in.orgadmin.utils.report.ReportUtils;
import in.talentify.core.services.NotificationAndTicketServices;
import in.talentify.core.utils.CMSRegistry;
import in.talentify.core.utils.EmailSendingUtility;

import tfy.admin.services.EmailService;

import tfy.admin.studentmap.pojos.AdminCMSessionSkillData;
import tfy.admin.studentmap.pojos.AdminCMSessionSkillGraph;


public class MAIN {
	
	
	public static void main(String[] args) throws IOException {

		/*ReportUtils util = new ReportUtils();
		HashMap<String, String> conditions = new HashMap();
		
		
		
		  String course_id="3";
		 conditions.put("course_id", course_id); 
		  String college_id="3";
		 conditions.put("college_id", college_id+"");
		  getAttendanceGraph(3052, conditions);
		//checkingReportUtils();
		//nosense();
*/
		
		//dapoooo();
		//asdas();
		//datlooper();
		//reportUtilTesting();
		//ss();
		//jsontesting();
		System.out.println("start");
		//createInterviewSkill();
		createFarziData();
		/*for(int i=0;i<15;i++)
		{
			createFarziData();
		}*/
		System.out.println("end");
	}
	
	private static void createInterviewSkill() {
		// TODO Auto-generated method stub
		DBUTILS db = new DBUTILS();
		String selectCourse = "select distinct course_id from cluster_requirement where course_id in (select DISTINCT course_id from   cluster_requirement)";
		List<HashMap<String, Object>> cc = db.executeQuery(selectCourse);
		for(HashMap<String, Object> row: cc)
		{
			int cid = (int)row.get("course_id");
			
			for(int j=0;j<10;j++)
			{
				String skillNAme = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
				String insertIntoIntervieSkill ="INSERT INTO interview_skill (id, interview_skill_name, course_id, stage_type) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_skill), '"+skillNAme+"', "+cid+", 'L4');"; 
				db.executeUpdate(insertIntoIntervieSkill);
			}						
		}
		
		for(int j=0;j<10;j++)
		{
			String skillNAme = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
			String insertIntoIntervieSkill ="INSERT INTO interview_skill (id, interview_skill_name,  stage_type) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from interview_skill), '"+skillNAme+"',  'L5');"; 
			db.executeUpdate(insertIntoIntervieSkill);
		}
		
		for(int j=0;j<10;j++)
		{
			String skillNAme = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
			String insertIntoIntervieSkill ="INSERT INTO interview_skill (id, interview_skill_name,  stage_type) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from interview_skill), '"+skillNAme+"',  'L6');"; 
			db.executeUpdate(insertIntoIntervieSkill);
		}
	}

	private static void createFarziData() throws IOException {
		// TODO Auto-generated method stub
		IstarNotificationServices notificationService = new IstarNotificationServices();
		DBUTILS db = new DBUTILS();
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");
		String firstName = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
		String lastName = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
		String email = RandomStringUtils.randomAlphanumeric(5).toUpperCase()+"@"+RandomStringUtils.randomAlphanumeric(5).toUpperCase()+".com";;
		String password = "test123";
		String mobile = "789654123";
		String ugDegree = "BA";
		String pgDegree = "MA";
		String gender = "MALE";
		String dob = "28/03/1991";
		String courseIds = "";
		String avaiableTime = "";
		String experinceYears = "1";
		String experinceMonths = "0";
		String teachingAddress = "";
		String addressLine1 = RandomStringUtils.randomAlphanumeric(10).toUpperCase();;
		String addressLine2 = RandomStringUtils.randomAlphanumeric(10).toUpperCase();;
		String userType = "";
		int pincode = 560066;
		boolean hasUgDegree = false;
		boolean hasPgDegree = false;
		userType = "TRAINER";
		String presentor[] = email.split("@");
		String part1 = presentor[0];
		String part2 = presentor[1];
		String presentor_email = part1 + "_presenter@" + part2;
		TaskServices taskService = new TaskServices();
		String sql = "INSERT INTO address ( 	ID, 	addressline1, 	addressline2, 	pincode_id, 	address_geo_longitude, 	address_geo_latitude ) VALUES 	( 		(SELECT max(id)+1 FROM address), 		'"
				+ addressLine1 + "', 		'" + addressLine2 + "', 		 (select id from pincode where pin="
				+ pincode + " limit 1), 		 NULL, 		 NULL 	)RETURNING ID;";

		System.err.println(sql);
		int address_id = db.executeUpdateReturn(sql);

		String insertIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
				+ email + "', '" + password + "', now(), " + mobile + ", NULL, NULL, 't') returning id;";
		int urseId = db.executeUpdateReturn(insertIntoIstarUser);
		if (userType.equalsIgnoreCase("TRAINER")) {
			String insertPresentorIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
					+ presentor_email + "', '" + password + "', now(), " + mobile
					+ ", NULL, NULL, 't') returning id;";
			int presentorId = db.executeUpdateReturn(insertPresentorIntoIstarUser);
		}

		String createUserProfile = "INSERT INTO user_profile (id,  first_name, last_name,  gender, user_id,address_id ,dob) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"
				+ firstName + "', '" + lastName + "', '" + gender + "'," + urseId + "," + address_id + " , '"
				+ dob + "');";
		db.executeUpdate(createUserProfile);

		String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + urseId
				+ ", (select id from role where role_name='" + userType
				+ "'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
		db.executeUpdate(insertIntoUserRole);

		String insertIntoProfessionalProfile = "INSERT INTO professional_profile (id, user_id, has_under_graduation,has_post_graduation, under_graduate_degree_name, pg_degree_name, experience_in_years, experince_in_months) VALUES ((select COALESCE(max(id),0)+1 from professional_profile), "
				+ urseId + ", '" + Boolean.toString(hasUgDegree).charAt(0) + "','"
				+ Boolean.toString(hasPgDegree).charAt(0) + "','" + ugDegree + "','" + pgDegree + "','"
				+ experinceYears + "','" + experinceMonths + "'); ";
		db.executeUpdate(insertIntoProfessionalProfile);

		if (userType.equalsIgnoreCase("TRAINER")) {

			String insertIntoTrainerEmpanelmentStatus = "insert into trainer_empanelment_status (id, trainer_id, empanelment_status,created_at,stage) values((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "
					+ urseId + ", '" + TrainerEmpanelmentStatusTypes.SELECTED + "',now(), '"
					+ TrainerEmpanelmentStageTypes.SIGNED_UP + "')";
			db.executeUpdate(insertIntoTrainerEmpanelmentStatus);

			String insertIntoUserOrg = "INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("
					+ urseId + ", 2, ((select COALESCE(max(id),0)+1 from user_org_mapping)));";
			db.executeUpdate(insertIntoUserOrg);
			String groupNotificationCode = UUID.randomUUID().toString();
			String selectCourse = "select distinct course_id from cluster_requirement where course_id in (select DISTINCT course_id from   cluster_requirement)";
			List<HashMap<String, Object>> cc = db.executeQuery(selectCourse);			
			
			for(int i=0 ; i<3;i++)
			{
				HashMap<String, Object> row = cc.get(i);
				int course_id =(int) row.get("course_id");
				String insertInIntrestedTable = "insert into trainer_intrested_course (id, trainer_id, course_id) values((select COALESCE(max(id),0)+1 from trainer_intrested_course),"
						+ urseId + "," + course_id + ")";
				db.executeUpdate(insertInIntrestedTable);

				Course course = new CourseDAO().findById(course_id);
				String getAssessmentForCourse = "select distinct assessment_id from  course_assessment_mapping where course_id="
						+ course_id;
				List<HashMap<String, Object>> assessments = db.executeQuery(getAssessmentForCourse);
				for (HashMap<String, Object> assess : assessments) {
					int assessmentId = (int) assess.get("assessment_id");
					Assessment assessment = new AssessmentDAO().findById(assessmentId);
					String notificationTitle = "An assessment with title <b>"
							+ assessment.getAssessmenttitle() + "</b> of course <b>"
							+ course.getCourseName() + "</b> has been added to task list.";
					String notificationDescription = notificationTitle;
					String taskTitle = assessment.getAssessmenttitle();
					String taskDescription = notificationDescription;
					int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""),
							taskDescription.trim().replace("'", ""), 300 + "", urseId + "",
							assessmentId + "", "ASSESSMENT");
					IstarNotification istarNotification = notificationService.createIstarNotification(300,
							urseId, notificationTitle, notificationDescription, "UNREAD", null,
							NotificationType.ASSESSMENT, true, taskId, groupNotificationCode);
				}
			}
			
			String findDefaultAssessment = "select property_value from constant_properties where property_name ='default_assessment_for_trainer'";
			List<HashMap<String, Object>> defaultAssessment = db.executeQuery(findDefaultAssessment);
			if (defaultAssessment.size() > 0) {
				String defAssessments = defaultAssessment.get(0).get("property_value").toString();
				if (defAssessments != null) {
					for (String defAssess : defAssessments.split(",")) {
						int aid = Integer.parseInt(defAssess);
						Assessment assessment = new AssessmentDAO().findById(aid);
						if (assessment != null) {
							String notificationTitle = "An assessment with title <b>"
									+ assessment.getAssessmenttitle() + "</b> has been added to task list.";
							String notificationDescription = notificationTitle;
							String taskTitle = assessment.getAssessmenttitle();
							String taskDescription = notificationDescription;
							int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""),
									taskDescription.trim().replace("'", ""), 300 + "", urseId + "",
									aid + "", "ASSESSMENT");
							IstarNotification istarNotification = notificationService
									.createIstarNotification(300, urseId, notificationTitle,
											notificationDescription, "UNREAD", null,
											NotificationType.ASSESSMENT, true, taskId,
											groupNotificationCode);
						}

					}
				}
			}
			
			String selectPincode ="select pin from pincode where id in (select pincode_id from cluster_pincode_mapping)";
			List<HashMap<String, Object>> pincodeData = db.executeQuery(selectPincode);
			for(int i=0;i<5;i++)
			{
				
				String ssql = "INSERT INTO trainer_prefred_location ( 	ID, 	trainer_id, 	marker_id, 	prefred_location, pincode ) "
						+ "VALUES 	((SELECT COALESCE(max(id)+1,1) FROM trainer_prefred_location), "
						+ urseId + ", '" + UUID.randomUUID().toString() + "', '" + UUID.randomUUID().toString() + "',"+pincodeData.get(i).get("pin")+");";
				System.err.println(ssql);
				db.executeUpdate(ssql);
			}

			ArrayList<String>days = new ArrayList<>();
			days.add("Monday");
			days.add("Tuesday");
			days.add("Wednesday");
			days.add("Thursday");
			days.add("Friday");
			days.add("Saturday");
			for(int i=0;i<5;i++)
			{
				String ssql = "INSERT INTO trainer_available_time_sloat ( 	ID, 	trainer_id, 	DAY, 	t8am_9am, 	t9am_10am, 	t10am_11am, 	t11am_12pm, 	t12pm_1pm, 	t1pm_2pm, 	t2pm_3pm, 	t3pm_4pm, 	t4pm_5pm, 	t5pm_6pm ) VALUES 	( 		(SELECT COALESCE(max(id)+1,1) FROM trainer_available_time_sloat), 	  "
						+ urseId + ", 		'" + days.get(i) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'"
						+ Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0)
						+ "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'"
						+ Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0)
						+ "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "' 	);";

				System.err.println(ssql);
				db.executeUpdate(ssql);
			}

		}
		
		giveAllAssessment(urseId);
		giveL4Iterview(urseId);
		giveL5Interview(urseId);
		giveL6Interview(urseId);
	}






	private static void giveL6Interview(int urseId) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
				DBUTILS util = new DBUTILS();
				String findAllCoursesTrainerAppliedFor ="select course_id from trainer_empanelment_status where trainer_id = "+urseId+" and stage ='L5'";
				List<HashMap<String, Object>> data = util.executeQuery(findAllCoursesTrainerAppliedFor);
				for(HashMap<String, Object> row: data)
				{
					
					String findskills = "select id from interview_skill where  stage_type='L6'";
					List<HashMap<String, Object>> data111 = util.executeQuery(findskills);
					for(HashMap<String, Object> skll : data111)
					{
						String insert="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
								+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), "+urseId+", "+skll.get("id")+", 4.5, '300', 'L6', "+row.get("course_id")+");";
						util.executeUpdate(insert);
					}
					
					String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
							+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", 'SELECTED', now(), 'L6', "+row.get("course_id")+");";
					util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
				}
	}

	private static void giveL5Interview(int urseId) {
		// TODO Auto-generated method stub
		DBUTILS util = new DBUTILS();
		String findAllCoursesTrainerAppliedFor ="select course_id from trainer_empanelment_status where trainer_id = "+urseId+" and stage ='L4'";
		List<HashMap<String, Object>> data = util.executeQuery(findAllCoursesTrainerAppliedFor);
		for(HashMap<String, Object> row: data)
		{
			
			String findskills = "select id from interview_skill where  stage_type='L5'";
			List<HashMap<String, Object>> data111 = util.executeQuery(findskills);
			for(HashMap<String, Object> skll : data111)
			{
				String insert="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), "+urseId+", "+skll.get("id")+", 4.5, '300', 'L5', "+row.get("course_id")+");";
				util.executeUpdate(insert);
			}
			String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", 'SELECTED', now(), 'L5', "+row.get("course_id")+");";
			util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
		}
	}

	private static void giveL4Iterview(int urseId) {
		DBUTILS util = new DBUTILS();
		String findAllCoursesTrainerAppliedFor ="select course_id from trainer_empanelment_status where trainer_id = "+urseId+" and stage ='L3'";
		List<HashMap<String, Object>> data = util.executeQuery(findAllCoursesTrainerAppliedFor);
		for(HashMap<String, Object> row: data)
		{
			
			String findskills = "select id from interview_skill where course_id = 5 and stage_type='L4'";
			List<HashMap<String, Object>> data111 = util.executeQuery(findskills);
			for(HashMap<String, Object> skll : data111)
			{
				String insert="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), "+urseId+", "+skll.get("id")+", 4.5, '300', 'L4', "+row.get("course_id")+");";
				util.executeUpdate(insert);
			}
			
			String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", 'SELECTED', now(), 'L4', "+row.get("course_id")+");";
			util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
		}
	}

	private static void giveAllAssessment(int urseId) throws IOException {
		DBUTILS util = new DBUTILS();
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
			client.SubmitAssessment(taskId,urseId, asses_response, assessmentId);
			String selectCourseForAssessment ="select course_id from course_assessment_mapping where assessment_id = "+assessmentId+" limit 1";
			List<HashMap<String, Object>> cc = util.executeQuery(selectCourseForAssessment);
			String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", 'SELECTED', now(), 'L3', "+cc.get(0).get("course_id")+");";
			util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
		}
	}

	
	private static void jsontesting() {
		// TODO Auto-generated method stub
		AdminCMSessionSkillGraph graph = new AdminCMSessionSkillGraph();
		HashMap<String, ArrayList<AdminCMSessionSkillData>> data = new HashMap<>();
		
		ArrayList<AdminCMSessionSkillData> list = new ArrayList<>();
		{	
		AdminCMSessionSkillData dd= new AdminCMSessionSkillData();
		dd.setName("ROOKIE");
		
		ArrayList<ArrayList<Object>> data2 = new ArrayList<>(); 
		ArrayList<Object> kv = new ArrayList<>();
		kv.add("ASDasd");
		kv.add(2);
		data2.add(kv);
		
		dd.setData(data2);
		list.add(dd);
		
	}
		{
			AdminCMSessionSkillData dd= new AdminCMSessionSkillData();
			dd.setName("MAster");
			

			ArrayList<ArrayList<Object>>data2 = new ArrayList<>(); 
			ArrayList<Object> kv = new ArrayList<>();
			kv.add("sfsdfwrew");
			kv.add(2);
			data2.add(kv);
			
			dd.setData(data2);
			list.add(dd);
			
		}
		
		data.put("MOB", list);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		String result="";
		result = gson.toJson(data);
		
		System.out.println(result);
		
		
		
	}


	private static void ss() {
		// TODO Auto-generated method stub
		CustomReportUtils repUtils = new CustomReportUtils();
		CustomReport report = repUtils.getReport(26);
		String sql=report.getSql();
		System.out.println(sql);
		sql = sql.replaceAll(":user_id", "6044").replaceAll(":limit","10").replaceAll(":offset", "20");
		System.out.println(sql);
		
		
	}


	private static void reportUtilTesting() {
		// TODO Auto-generated method stub
		CustomReportUtils repUtils = new CustomReportUtils();
		CustomReport report = repUtils.getReport(26);
		String sql=report.getSql().replace(":user_id", "6044");
		System.out.println(sql);
	}


	private static void datlooper() {
		// TODO Auto-generated method stub
		Calendar startCal = Calendar.getInstance();
	    startCal.setTime(new Date());      
    	/* if (daysList.contains(startCal.get(Calendar.DAY_OF_WEEK)) && currentOrderId< lessons.size()) {
	        	Date taskDate = new Date(startCal.getInstance().getTimeInMillis());
	        	System.out.println("creatting task for date+"+taskDate);		        	
	        	for(int stid : users)
	        	{
	        		int cid=Integer.parseInt(scheduler_course_id);
	        		for(int i=0;i<freq;i++){
	        			int orderId = currentOrderId+i;
		        		if(orderId<lessons.size()){
		        			int mid = modules.get(orderId);
			        		int cms = cmsessions.get(orderId);
			        		int lid = lessons.get(orderId);
			        		scheduleTask(stid, cid, mid, cms, lid, taskDate);
		        		}
	        		}
	        	}		            
	            currentOrderId = currentOrderId+freq;
	            daysCount++;
	        }*/
			startCal.add(Calendar.DATE, 4);
    	 System.out.println("checkig for "+startCal.getTime());
    	 
		/*for(int daysCount=0; daysCount< 10; )
	    {
			
	    }*/
	}


	private static void asdas() {
		// TODO Auto-generated method stub
		Organization org = new OrganizationDAO().findById(2);
		for(BatchGroup bg : org.getBatchGroups())
		{
			if(bg.getBatchStudentses().size()>0){
			System.out.println(bg.getName()+ " "+bg.getId()+" "+bg.getType());
			
			}
		}
	}


	private static void dapoooo() {
		Organization college = new OrganizationDAO().findById(2);
		//String sql="SELECT id,email,gender,CAST (mobile AS INTEGER),name FROM org_admin where organization_id="+org_id;
		for(UserOrgMapping userOrg : college.getUserOrgMappings())
		{
			for(UserRole  userRole : userOrg.getIstarUser().getUserRoles())
			{
				if(userRole.getRole().getRoleName().equalsIgnoreCase("ORG_ADMIN"))
				{
					IstarUser orgadmin = userRole.getIstarUser(); 
					System.out.println(userRole.getIstarUser());
					System.out.println(orgadmin.getId());
					System.out.println(orgadmin.getEmail());
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					
				/*	orgAdminId=orgadmin.getId()+"";
					orgAdminEmail=orgadmin.getEmail();
					orgAdminMobile=orgadmin.getMobile()+"";
					if(orgadmin.getUserProfile()!=null){
					orgAdminGender=orgadmin.getUserProfile().getGender();					
					orgAdminFirstName = orgadmin.getUserProfile().getFirstName();	
					orgAdminLastName = orgadmin.getUserProfile().getLastName();*/
					}
				}
			}
		
		System.out.println("done");
		}
		
	


	public static CustomReport getReport(int reportID) {
		CustomReportList reportCollection = new CustomReportList();
		CustomReport report = new CustomReport();
		try {
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("custom_report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(CustomReportList.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (CustomReportList) jaxbUnmarshaller.unmarshal(file);

		} catch (URISyntaxException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		
		for (CustomReport r : reportCollection.getCustomReports()) {
			if (r.getId() == reportID) {
				report = r;
			}
		}
		return report;
	}
	
public static StringBuffer getAttendanceGraph(int reportID,HashMap<String, String> conditions){
		
		DBUTILS dbutils = new DBUTILS();
		StringBuffer out = new StringBuffer();
		
		
		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_"+id+"' ></div> ");
		out.append("<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"+id+"' data-y_axis_title='' data-report_title='' "
				+ " data-graph_holder='container" + id + "' id='chart_datatable_"+id+"'");
		out.append(" data-graph_type='area'>");	
		CustomReport report = getReport(reportID) ;
		String sql9 = report.getSql();
		for(String key : conditions.keySet())
		{
			sql9 = sql9.replaceAll(":"+key, conditions.get(key));
		}	
		ArrayList<String> batchNames = new ArrayList<>();
		ArrayList<String> createdAt = new ArrayList<>();
		List<HashMap<String, Object>> attendance_view = dbutils.executeQuery(sql9);
		HashMap<String, Integer> created_attendance = new HashMap<>();
		out.append(" <thead><tr>");	
		for(HashMap<String, Object>  rows : attendance_view)
		{
			if(!batchNames.contains(rows.get("batchname")))
			{
				batchNames.add(rows.get("batchname").toString());
				
			}
		}
		
		for(HashMap<String, Object>  rows : attendance_view)
		{
			if(!createdAt.contains(rows.get("created_at")))
			{
				createdAt.add(rows.get("created_at").toString());
			}
		}
		
		for(int i=0;i<batchNames.size();i++){
			
			out.append("<th>"+batchNames.get(i).trim()+"</th>");
		}
		out.append("</tr> </thead>");	
		out.append(" <tbody>");
		
		
			
			
			
			for(HashMap<String, Object>  rows1 : attendance_view)
			{
				out.append(" <tr>");
				for(int j = 0; j<createdAt.size();j++){
				
				System.out.println(createdAt.get(j)+"--"+rows1.get("created_at").toString());
				if(createdAt.get(j) == rows1.get("created_at").toString()){
					
					out.append( "<td>"+rows1.get("attendance")+"</td>");
					
				}else{
					out.append(" <tr><td>"+rows1.get("created_at")+"</td> ");
					  out.append( "<td>"+rows1.get("attendance")+"</td>");
				}
				
			}
			out.append( "</tr>");
		}
		
		out.append("</tbody></table>");
		
		//System.out.println(out);
		return out;
		
		
	}
	

	private static void nosense() {
		String sql1="	SELECT 	batch_group. NAME, 	CAST ( 		(SUM(master) * 100) / COUNT (*) AS INTEGER 	) AS master, 	CAST ( 		(SUM(rookie) * 100) / COUNT (*) AS INTEGER 	) AS rookie, 	CAST ( 		(SUM(apprentice) * 100) / COUNT (*) AS INTEGER 	) AS apprentice, 	CAST ( 		(SUM(wizard) * 100) / COUNT (*) AS INTEGER 	) AS wizard FROM 	mastery_level_per_course, 	batch_group WHERE 	mastery_level_per_course.college_id =:college_id AND course_id =:course_id AND batch_group. ID = mastery_level_per_course.batch_group_id GROUP BY 	batch_group. NAME";
		Transaction tx = null;
		Session session = new BaseHibernateDAO().getSession();
		try {
			tx = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(sql1);
			HashMap<String, String> conditions = new HashMap<>();
			conditions.put("course_id", "3");
			conditions.put("college_id", "3");
			for (String key : conditions.keySet()) {
				try {
					if (sql1.contains(key)) {
						System.out.println("key->" + key + "   value-> " + conditions.get(key));						
						//query.setParameter("course_id", Integer.parseInt(conditions.get(key)));
						query.setParameter("course_id", "3");
						query.setParameter("college_id", "3");
					}
				} catch (Exception e) {
					e.printStackTrace();
					query.setParameter(key, conditions.get(key));
				}
			}
			sql1= query.getQueryString();
			System.out.println("finalSql >>"+sql1);
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}				
		
	}

	private static void checkingReportUtils() {
		// TODO Auto-generated method stub
		
		//System.out.println("1>>>"+(new CMSRegistry()).getClass().getClassLoader());
		//System.out.println("2>>>"+(new CMSRegistry()).getClass().getClassLoader().getResource("report_list.xml"));
		ReportUtils utils = new ReportUtils();
		HashMap<String, String> conditions = new HashMap<>();
		
		System.err.println(utils.getHTML(3052, conditions));;
		
		/*int totalStudent=50;
		int nintyPercent = (int)(.9* totalStudent);		
		System.out.println(nintyPercent);
		
		
		double r = Math.random()*0.8;
		System.out.println(r);*/
	}
}
