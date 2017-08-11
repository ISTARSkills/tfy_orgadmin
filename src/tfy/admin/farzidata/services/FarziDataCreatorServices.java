/**
 * 
 */
package tfy.admin.farzidata.services;

import java.util.Date;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.github.javafaker.Faker;
import com.istarindia.android.pojo.AssessmentPOJO;
import com.istarindia.android.pojo.OptionPOJO;
import com.istarindia.android.pojo.QuestionPOJO;
import com.istarindia.android.pojo.QuestionResponsePOJO;
import com.istarindia.android.pojo.RestClient;

import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.AssessmentOption;
import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.BatchStudents;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.QuestionDAO;
import com.viksitpro.core.dao.entities.Report;
import com.viksitpro.core.dao.entities.ReportDAO;
import com.viksitpro.core.dao.entities.StudentAssessment;
import com.viksitpro.core.dao.entities.StudentAssessmentDAO;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.dao.utils.user.IstarUserServices;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;

/**
 * @author ISTAR-SKILL
 *
 */
public class FarziDataCreatorServices {
	
	public  Connection getConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://localhost:5432/talentify","postgres", "4a626021-e55a");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
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
		String email = faker.name().firstName().toLowerCase()+"@istarindia.com".replace("'", "");
		String mobile = faker.number().digits(10);
		
		
		String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) "
				+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+email+"', 'test123', 		now(), 		'"+mobile+"', 		NULL,    'f' 	)RETURNING ID;";
		
		//System.out.println(istarStudentSql);
		int userID  = db.executeUpdateReturn(istarStudentSql);
			
		String insertIntoUserProfile ="INSERT INTO user_profile (id, first_name, last_name,  gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"+firstName+"', '"+lastName+"', 'MALE', "+userID+");";
		db.executeUpdate(insertIntoUserProfile);

		//Student User Role Mapping
			String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
			//System.out.println(userRoleMappingSql);
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
		System.out.println(insert_into_bg);
		util.executeUpdate(insert_into_bg);		
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
			
			users.add(userID);
			
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
		System.err.println(sql);
		
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		
		if(data.size()==0){
		sql = "INSERT INTO batch ( 	ID, 	createdat, 	NAME, 	updatedat, 	batch_group_id, 	course_id ) VALUES 	((select COALESCE(max(id),0)+1 from batch) 		, 		'now()', 		'"+batchName+"', 		'now()', 		'"+bgId+"', 		'"+courseId+"')returning id";
		System.err.println(sql);
		int batchId = (int) db.executeUpdateReturn(sql);
		
		sql="UPDATE batch SET order_id='"+batchId+"' WHERE (id='"+batchId+"')";
		System.err.println(sql);
		db.executeUpdate(sql);				
		}
	}
	
	
	public int createTaskForDate(String name, String description, String owner, String actor, String itemId, String itemType, String date)
	{
		DBUTILS util = new DBUTILS();
		String sql ="INSERT INTO task (id, name, description, owner, actor, state,  start_date, end_date, is_active,  created_at, updated_at, item_id, item_type) "
				+ "VALUES ((select COALESCE(max(id),0) +1 from task), '"+name+"', '"+description+"', "+owner+", "+actor+", 'SCHEDULED', now(),now(), 't', '"+date+"', now(), "+itemId+", '"+itemType+"') returning id;";
		int taskId = util.executeUpdateReturn(sql);		
		return taskId ;
	}
	public static void main(String args [])
	{
		
		System.out.println("start");
		FarziDataCreatorServices serv = new FarziDataCreatorServices();
		/*String orgName = "Oganzation2";
		
		String[] batches = {"NORTH","SOUTH","EAST","WEST"};
		int[] batcheCounts = {10,20,30,40};
		int courses[] = {10,8};
		
		
		
		
		int orgID =serv.createOrganization(orgName);
		//278
		for (int k=0; k< batches.length;k++) {
			int bgId = serv.createBGsInOrganization(orgID, batcheCounts[k], batches[k]);
			for(int courseId : courses)
			{
				serv.addCourseInGroup(bgId,courseId);
			}	
		}*/
		int orgID = 282;
		//serv.createAssesssmentTaskForAllBgs(orgID);
		 int aPlusPercentage = 25;
		    int APercentage =50;
		    int BPlusPercentage = 20;
		    int BPercenatge =5;
		int bgId = 164;    
		serv.submitAssessment(bgId, aPlusPercentage,APercentage, BPlusPercentage, BPercenatge);
		
		
		
		System.out.println("end");
	}

	private void submitAssessment(int bgId, int aPlusPercentage, int aPercentage, int bPlusPercentage, int bPercenatge ) {
		DBUTILS util = new DBUTILS();
		
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
							assessmentIds.add(Integer.parseInt(lesson.getLessonXml()));
						}	
					}	
				}	
			}
		}
		
		for(int assessId : assessmentIds)
		{
			geiveFarziAssessment(assessId,studentsInBg, aPlusPercentage,aPercentage, bPlusPercentage, bPercenatge);
		}	
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
		System.out.println("FARZI DATA STARAT HERE");
		FarziDataCreatorServices mm = new FarziDataCreatorServices();
		for(Integer userId : students){
		Integer percentageRequired  = percentageRequiredfORgRADE;		
		String findAssessmentTasks = "select id from task where item_type='ASSESSMENT' and actor="+userId+" and item_id="+assessmentId+"";
		System.out.println(findAssessmentTasks);
		try {
			Statement statement3 = mm.getConnection().createStatement();				
			ResultSet rs3 = statement3.executeQuery(findAssessmentTasks);
			while(rs3.next())
			{
				
				int taskId = (int)rs3.getInt("id");
				RestClient client = new  RestClient();
				AssessmentPOJO assessment = client.getAssessment(assessmentId, userId);
				int questionsToAttend = (percentageRequired * assessment.getQuestions().size())/100;
				System.out.println("percebtage ="+percentageRequired+" queswtion atten ="+questionsToAttend+ " total questions ="+assessment.getQuestions().size());
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
				
				mm.submitAssessment(taskId,userId, asses_response, assessmentId);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
		System.out.println("giveFarziData ENDS HERE ");
		
	}

	public HashMap<String, Boolean> getAnsweredOptionsMap(Question question, List<Integer> options) {
		boolean isCorrect = false;

		HashMap<String, Boolean> optionsMap = new HashMap<String, Boolean>();
		List<Boolean> incorrectAnswers = new ArrayList<Boolean>();
		if (options!=null && options.size() > 0) {
			//System.out.println("Checking Options with MaRKED Answers");
			ArrayList<AssessmentOption> allOptions = new ArrayList<AssessmentOption>(question.getAssessmentOptions());

			for (int i = 0; i < 5; i++) {
				////System.out.println("Option ID--->"+allOptions.get(i).getId());
				if (i < allOptions.size() && allOptions.get(i).getMarkingScheme() == 1) {
					if (options.contains(allOptions.get(i).getId())) {
						optionsMap.put("option" + i, true);
					  //System.out.println(i + " Answer is Correct and user marked it correct too!");
						isCorrect = true;
					} else {
						optionsMap.put("option" + i, false);
						//System.out.println(i +" Answer is Correct and user did not marked it correct!");
						isCorrect = false;
					}
				} else if (i < allOptions.size()) {
					if (options.contains(allOptions.get(i).getId())) {
						optionsMap.put("option" + i, true);
					 //System.out.println(i+" Answer is Not Correct and but user marked it correct!");
						isCorrect = false;
						incorrectAnswers.add(isCorrect);
					} else {
						optionsMap.put("option" + i, false);
					 //System.out.println(i+" Answer is Not Correct and and user did not marked it also!");
					}
				} else {
					//System.out.println(i+" Less Than 5 Options, so setting it to false");
					optionsMap.put("option" + i, false);
				}
			}
		} else {
			 //System.out.println("User did not attempt the question");
			for (int i = 0; i < 5; i++) {
				 //System.out.println(i+" Setting All Options to false");
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
					//System.out.println("per_assessment_points"+per_assessment_points);
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
		
		FarziDataCreatorServices serv = new FarziDataCreatorServices();
		IstarUser istarUser = new IstarUserDAO().findById(userId);	
		Assessment assessment = new AssessmentDAO().findById(assessmentId);
		int correctAnswersCount = 0;
			int assessmentDuration = 0;
			for (QuestionResponsePOJO questionResponsePOJO : asses_response) {
				Question question = new QuestionDAO().findById(questionResponsePOJO.getQuestionId());

				HashMap<String, Boolean> optionsMap = serv.getAnsweredOptionsMap(question,
						questionResponsePOJO.getOptions());

				StudentAssessment studentAssessment = serv
						.getStudentAssessmentOfQuestionForUser(userId, assessmentId, question.getId());

				if (studentAssessment != null) {
					if(assessment.getRetryAble()!=null && assessment.getRetryAble())
					{
						studentAssessment = serv.updateStudentAssessment(studentAssessment,
								optionsMap.get("isCorrect"), optionsMap.get("option0"), optionsMap.get("option1"),
								optionsMap.get("option2"), optionsMap.get("option3"), optionsMap.get("option4"), null, null,
								null, questionResponsePOJO.getDuration());
					}
					
				} else {
					studentAssessment = serv.createStudentAssessment(assessment, question,
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

			Double maxPoints = serv.getMaxPointsOfAssessment(assessment.getId());			
			Report report = serv.getAssessmentReportForUser(userId, assessmentId);			
			
			if (report == null) {
				//System.out.println("Report is null, creating new report");
				serv.createReport(istarUser, assessment, correctAnswersCount, assessmentDuration,
						maxPoints.intValue());
				serv.updateUserGamificationAfterAssessment(istarUser,assessment);
			} else {
				//System.out.println("Report exists, updating report");
				if(assessment.getRetryAble()!=null && assessment.getRetryAble())
				{
					serv.updateReport(report, istarUser, assessment, correctAnswersCount, assessmentDuration,maxPoints.intValue());
					serv.updateUserGamificationAfterAssessment(istarUser,assessment);
				}	
			}

			TaskServices taskServices = new TaskServices();
			taskServices.completeTask("COMPLETED", false, taskId, istarUser.getAuthToken());

		
	}

	private void updatePointsAndCoinsForAssessment(IstarUser istarUser, Assessment assessment) {
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
					//System.out.println("per_assessment_points"+per_assessment_points);
				}
			} catch (IOException e) {
				e.printStackTrace();			
		}*/
		DBUTILS util = new DBUTILS();
		String findPrimaryGroupsOfUser = "SELECT distinct	batch_group.id, batch_group.college_id FROM 	batch_students, 	batch_group WHERE 	batch_group. ID = batch_students.batch_group_id AND batch_students.student_id = "+istarUser.getId()+" and batch_group.is_primary='t'";
		//System.out.println("findPrimaryGroupsOfUser>>"+findPrimaryGroupsOfUser);
		List<HashMap<String, Object>> primaryBG = util.executeQuery(findPrimaryGroupsOfUser);
		
		for(HashMap<String, Object>primaryG : primaryBG)
		{
			int groupId = (int)primaryG.get("id");
			int orgId = (int)primaryG.get("college_id");
			String findSkillsInAssesssment = "select skill_objective_id, max_points from assessment_benchmark where "
					+ "item_id = "+assessment.getId()+" and item_type ='ASSESSMENT'";
			//System.out.println("findSkillsInAssesssment>>>>>>"+findSkillsInAssesssment);
			List<HashMap<String, Object>> skillsData = util.executeQuery(findSkillsInAssesssment);
			for(HashMap<String, Object> skills : skillsData)
			{
				int skillObjectiveId = (int)skills.get("skill_objective_id");
				String maxPoints = (String)skills.get("max_points");				
				String coins = "( :per_assessment_coins )";
				String getPreviousCoins="select * from user_gamification where item_id ='"+assessment.getId()+"' and item_type='ASSESSMENT' and "
						+ "istar_user='"+istarUser.getId()+"' and batch_group_id="+groupId+" and skill_objective="+skillObjectiveId+"  order by timestamp desc limit 1";
				//System.out.println("getPreviousCoins"+getPreviousCoins);
				List<HashMap<String, Object>> coinsData = util.executeQuery(getPreviousCoins);
				if(coinsData.size()>0)
				{
					String prevCoins = (String)coinsData.get(0).get("coins");
					coins= coins+" + "+prevCoins;
 				}
				
				String insertIntoGamification="INSERT INTO user_gamification (id,istar_user, skill_objective, points, coins, created_at, updated_at, item_id, item_type,  course_id, batch_group_id, org_id, timestamp,max_points) VALUES "
						+ "((SELECT COALESCE(MAX(ID),0)+1 FROM user_gamification),"+istarUser.getId()+", "+skillObjectiveId+",'"+maxPoints+"' , '"+coins+"', now(), now(), "+assessment.getId()+", 'ASSESSMENT', "+assessment.getCourse()+", "+groupId+", "+orgId+", now(),'"+maxPoints+"');";
				//System.out.println("insertIntoGamification>>>>"+insertIntoGamification);
				util.executeUpdate(insertIntoGamification);
			}			
		}
		
	}

	public void updateUserGamificationAfterAssessment(IstarUser istarUser, Assessment assessment) {
		updatePointsAndCoinsForAssessment(istarUser, assessment);
		updatePointsAndCoinsForQuestion(istarUser,assessment);
	}

	private void updatePointsAndCoinsForQuestion(IstarUser istarUser, Assessment assessment) {
		
		
		DBUTILS util = new DBUTILS();
		String findPrimaryGroupsOfUser = "SELECT distinct	batch_group.id, batch_group.college_id FROM 	batch_students, 	batch_group WHERE 	batch_group. ID = batch_students.batch_group_id AND batch_students.student_id = "+istarUser.getId()+" and batch_group.is_primary='t'";
		//System.out.println("findPrimaryGroupsOfUser>>"+findPrimaryGroupsOfUser);
		List<HashMap<String, Object>> primaryBG = util.executeQuery(findPrimaryGroupsOfUser);
		
		for(HashMap<String, Object>primaryG : primaryBG)
		{
			int groupId = (int)primaryG.get("id");
			int orgId = (int)primaryG.get("college_id");
			ArrayList<Integer> questionAnsweredCorrectly = new ArrayList<>();
			String findQueAnsweredCorrectly= "select distinct question_id from student_assessment where assessment_id ="+assessment.getId()+" and student_id="+istarUser.getId()+" and correct='t'";
			//System.out.println("correct que id "+findQueAnsweredCorrectly );
			List<HashMap<String, Object>> correctQueAnsweredData = util.executeQuery(findQueAnsweredCorrectly);
			for(HashMap<String, Object> qro : correctQueAnsweredData)
			{
				//System.out.println("correct que id"+(int)qro.get("question_id"));
				questionAnsweredCorrectly.add((int)qro.get("question_id"));
			}
			
			String findQuestionForAssessment="select distinct questionid from assessment_question, question, assessment where assessment_question.questionid = question.id and assessment_question.assessmentid = assessment.id and assessment.course_id = question.context_id and assessment.id = "+assessment.getId();
			List<HashMap<String, Object>> questionData = util.executeQuery(findQuestionForAssessment);
			for(HashMap<String, Object> qRow: questionData)
			{
				int questionId = (int)qRow.get("questionid");
				
				
				String findSkillsInQuestion = "select skill_objective_id, max_points from assessment_benchmark where item_id = "+questionId+" and item_type ='QUESTION'";
				//System.out.println("findSkillsInAssesssment>>>>>>"+findSkillsInQuestion);
				List<HashMap<String, Object>> skillsData = util.executeQuery(findSkillsInQuestion);
				for(HashMap<String, Object> skills : skillsData)
				{
					int skillObjectiveId = (int)skills.get("skill_objective_id");
					String maxPoints = (String)skills.get("max_points");
					String pointsScored = maxPoints;
					String coins = "( :per_question_coins )";
					
											
					String getPreviousCoins="select * from user_gamification where item_id ='"+questionId+"' and item_type='QUESTION' and istar_user='"+istarUser.getId()+"' and batch_group_id="+groupId+" and skill_objective="+skillObjectiveId+"  order by timestamp desc limit 1";
					//System.out.println("getPreviousCoins"+getPreviousCoins);
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
								//System.out.println("questionAnsweredCorrectly contains "+ questionId);
								pointsScored = maxPoints;
							}
							else
							{
								//System.out.println("questionAnsweredCorrectl do not  contains "+ questionId);
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
							+ "((SELECT COALESCE(MAX(ID),0)+1 FROM user_gamification),"+istarUser.getId()+", "+skillObjectiveId+",'"+pointsScored+"' , '"+coins+"', now(), now(), "+questionId+", 'QUESTION', "+assessment.getCourse()+", "+groupId+", "+orgId+", now(),'"+maxPoints+"');";
					//System.out.println("insertIntoGamification>>>>"+insertIntoGamification);
					util.executeUpdate(insertIntoGamification);
				}
			}						
		}		
	}	
	
public Report createReport(IstarUser istarUser, Assessment assessment, Integer score,  Integer timeTaken, Integer totalPoints){
		
		Report report = new Report();
		
		java.util.Date date = new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		report.setIstarUser(istarUser);
		report.setAssessment(assessment);
		report.setTotalPoints(totalPoints);
		report.setCreatedAt(current);
		report.setScore(score);
		report.setTimeTaken(timeTaken);		
		
		report = saveReportToDAO(report);
		
		return report;
	}
	
	public Report updateReport(Report report, IstarUser istarUser, Assessment assessment, Integer score,  Integer timeTaken, Integer totalPoints){

		java.util.Date date = new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		report.setIstarUser(istarUser);
		report.setAssessment(assessment);
		report.setTotalPoints(totalPoints);
		report.setScore(score);
		report.setTimeTaken(timeTaken);	
		report.setCreatedAt(current);
		
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
		
		//System.out.println("Updating to DAO");
		
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
							if(lesson.getType().equalsIgnoreCase("ASSESSMENT"))
							{
								assessmentIds.add(Integer.parseInt(lesson.getLessonXml()));
							}	
						}	
					}	
				}
			}
			
			System.out.println("assessments size ="+assessmentIds.size());
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
				
				System.out.println(statrtDate);
				System.out.println(endDate);
				
				int assessmentCounter = 0;
				
				
				for (Date date = statrtDate; date.before(endDate); start.add(Calendar.DATE, 1), date = start.getTime()) {				    
				    System.out.println(date);
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
				System.out.println("no assessment is thr ");
			}	

		}
	}	
}
