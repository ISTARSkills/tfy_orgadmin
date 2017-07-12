/**
 * 
 */
package tfy.admin.services;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import org.hibernate.SQLQuery;
import org.hibernate.Session;
import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchDAO;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.utils.user.IstarUserServices;
import com.viksitpro.core.utilities.DBUTILS;

import tfy.admin.studentmap.pojos.AdminCMSessionSkillData;
import tfy.admin.studentmap.pojos.AdminCMSessionSkillGraph;
import tfy.admin.studentmap.pojos.AdminModuleSkill;
import tfy.admin.studentmap.pojos.AdminSkillGraph;
import tfy.admin.studentmap.pojos.SkillReportPOJO;
import tfy.admin.studentmap.pojos.StudentRankPOJO;

/**
 * @author mayank
 *
 */
public class StudentSkillMapService {

public Double getMaxPointsOfLesson(Integer lessonId) {
		
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
					System.out.println("per_assessment_points"+per_assessment_points);
				}
			} catch (IOException e) {
				e.printStackTrace();			
		}
		String getTotalPoints ="SELECT CAST ( SUM (TFINAL.points_per_item) AS float8 ) AS tot_points FROM ( SELECT CAST ( custom_eval ( CAST ( TRIM ( REPLACE ( REPLACE ( REPLACE ( COALESCE (max_points, '0'), ':per_lesson_points', '"+per_lesson_points+"' ), ':per_assessment_points', '"+per_assessment_points+"' ), ':per_question_points', '"+per_question_points+"' ) ) AS TEXT ) ) AS INTEGER ) AS points_per_item FROM ( SELECT max_points, item_id, item_type FROM assessment_benchmark WHERE item_id = "+lessonId+" AND item_type = 'LESSON' ) TT ) TFINAL";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(getTotalPoints);
		if(data.size()>0 && data.get(0).get("tot_points")!=null)
		{
			totalPoints=(double)data.get(0).get("tot_points");
		}
			
		return totalPoints;
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
					System.out.println("per_assessment_points"+per_assessment_points);
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
	
	public List<HashMap<String, Object>> getCoursesOfUser(int userId)
	{
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> courses = new ArrayList<>();
		String sql="select id, trim(course_name) as course_name , (case when image_url is null or image_url ='' then (select property_value from constant_properties where property_name='media_url_path')||substr(course_name, 1,1)||'.png' else (select property_value from constant_properties where property_name='media_url_path')||image_url end ) as course_image from course where id in (select distinct course_id from student_playlist where student_id =  "+userId+")";
		System.out.println(">>>>>>>>>>>>>>>>>>>>>."+sql);
		courses = util.executeQuery(sql);
		return courses;
	}
	@SuppressWarnings("unchecked")
	public List<SkillReportPOJO> getSkillsMapOfUser(int istarUserId){
		
		List<SkillReportPOJO> allSkills = new ArrayList<SkillReportPOJO>();
		
		String sql = "select COALESCE(sum(user_gamification.points),0) as total_points, COALESCE(cast(sum(user_gamification.coins) as integer),0) as total_coins, so_session.name as session_so_name, so_session.id as session_so_id, so_module.name as module_so_name, so_module.id as module_so_id,  so_course.name as course_so_name, so_course.id as course_so_id, course_skill_objective.course_id as course_id from user_gamification, skill_objective so_session, skill_objective so_module, skill_objective so_course, course_skill_objective where user_gamification.skill_objective=so_session.id and so_module.id=so_session.parent_skill and so_module.parent_skill=so_course.id and so_course.id=course_skill_objective.skill_objective_id and istar_user= :istarUserId group by session_so_id,session_so_name, module_so_id, module_so_name, course_so_id, course_skill_objective.course_id order by course_so_id,module_so_id,session_so_id";
		BaseHibernateDAO baseHibernateDAO = new BaseHibernateDAO();
		Session session = baseHibernateDAO.getSession();
		
		SQLQuery query = session.createSQLQuery(sql);
		query.setParameter("istarUserId", istarUserId);
		
		List<Object[]> results = query.list();
		
		
		if(results.size()>0){
			for(Object[] element : results){
				Double userPoints = (Double) element[0];
				//Integer totalCoins = (Integer) element[1];
				String cmsessionSkillObjectiveName = (String) element[2];
				Integer cmsessionSkillObjectiveId = (Integer) element[3];
				String moduleSkillObjectiveName = (String) element[4];
				Integer moduleSkillObjectiveId = (Integer) element[5];
				String courseSkillObjectiveName = (String) element[6];
				Integer courseSkillObjectiveId = (Integer) element[7];
				Integer courseId = (Integer) element[8];
				
				SkillReportPOJO courseSkillPOJO = null;
				SkillReportPOJO moduleSkillPOJO = null;
				SkillReportPOJO cmsessionSkillPOJO = null;
				
				for(SkillReportPOJO tempCourseSkillReport : allSkills){
					if(tempCourseSkillReport.getId()==courseSkillObjectiveId){
						courseSkillPOJO = tempCourseSkillReport;
						break;
					}
				}
				
				if(courseSkillPOJO==null){					
					courseSkillPOJO = new SkillReportPOJO();
					courseSkillPOJO.setId(courseSkillObjectiveId);
					courseSkillPOJO.setName(courseSkillObjectiveName);
					Course course =new CourseDAO().findById(courseId);
					if(course!=null){
					String imageURL = course.getImage_url();
					courseSkillPOJO.setImageURL(imageURL);
					}					
					
					List<SkillReportPOJO> allModuleSkillReportPOJO = new ArrayList<SkillReportPOJO>();
					moduleSkillPOJO = new SkillReportPOJO();
					moduleSkillPOJO.setId(moduleSkillObjectiveId);
					moduleSkillPOJO.setName(moduleSkillObjectiveName);
					
					List<SkillReportPOJO> allCmsessionSkillReportPOJO = new ArrayList<SkillReportPOJO>();
					cmsessionSkillPOJO = new SkillReportPOJO();
								
					cmsessionSkillPOJO.setId(cmsessionSkillObjectiveId);
					cmsessionSkillPOJO.setName(cmsessionSkillObjectiveName);
					cmsessionSkillPOJO.setUserPoints(userPoints);
					cmsessionSkillPOJO.setTotalPoints(getMaxPointsOfCmsessionSkill(cmsessionSkillObjectiveId));
					allCmsessionSkillReportPOJO.add(cmsessionSkillPOJO);
					moduleSkillPOJO.setSkills(allCmsessionSkillReportPOJO);
					allModuleSkillReportPOJO.add(moduleSkillPOJO);
					courseSkillPOJO.setSkills(allModuleSkillReportPOJO);
					
					allSkills.add(courseSkillPOJO);
				}else{
					
					for(SkillReportPOJO tempModuleSkillReport : courseSkillPOJO.getSkills()){
						if(tempModuleSkillReport.getId()==moduleSkillObjectiveId){
							moduleSkillPOJO = tempModuleSkillReport;
						}
					}
					
					if(moduleSkillPOJO==null){
						moduleSkillPOJO = new SkillReportPOJO();
						moduleSkillPOJO.setId(moduleSkillObjectiveId);
						moduleSkillPOJO.setName(moduleSkillObjectiveName);
						
						List<SkillReportPOJO> allCmsessionSkillReportPOJO = new ArrayList<SkillReportPOJO>();
						cmsessionSkillPOJO = new SkillReportPOJO();
						
						cmsessionSkillPOJO.setId(cmsessionSkillObjectiveId);
						cmsessionSkillPOJO.setName(cmsessionSkillObjectiveName);
						cmsessionSkillPOJO.setUserPoints(userPoints);
						cmsessionSkillPOJO.setTotalPoints(getMaxPointsOfCmsessionSkill(cmsessionSkillObjectiveId));
						allCmsessionSkillReportPOJO.add(cmsessionSkillPOJO);
						moduleSkillPOJO.setSkills(allCmsessionSkillReportPOJO);
						courseSkillPOJO.getSkills().add(moduleSkillPOJO);
					}else{
						cmsessionSkillPOJO = new SkillReportPOJO();
						
						cmsessionSkillPOJO.setId(cmsessionSkillObjectiveId);
						cmsessionSkillPOJO.setName(cmsessionSkillObjectiveName);
						cmsessionSkillPOJO.setUserPoints(userPoints);
						cmsessionSkillPOJO.setTotalPoints(getMaxPointsOfCmsessionSkill(cmsessionSkillObjectiveId));
						moduleSkillPOJO.getSkills().add(cmsessionSkillPOJO);
					}
				}					
				courseSkillPOJO.calculateUserPoints();
				courseSkillPOJO.calculateTotalPoints();
				courseSkillPOJO.calculatePercentage();
				moduleSkillPOJO.calculateUserPoints();
				moduleSkillPOJO.calculateTotalPoints();
				moduleSkillPOJO.calculatePercentage();				
			}			
		}
		return allSkills;
	}	
	
public StudentRankPOJO getStudentRankPOJOOfAUser(Integer istarUserId){
		
		StudentRankPOJO studentRankPOJO = null;
		
		String sql = "select * from (select *, COALESCE(cast(rank() over (order by total_points desc) as integer),0) from "
				+ "(select user_gamification.istar_user, cast(sum(user_gamification.points) as integer)as total_points, cast(sum(user_gamification.coins) as integer) as total_coins "
				+ "from assessment,user_gamification where user_gamification.item_id=assessment.id  and user_gamification.istar_user in "
				+ "(select student_id from batch_students where batch_group_id in "
				+ "(select batch_group_id from batch_students where batch_students.student_id= :istarUserId)) "
				+ "group by user_gamification.istar_user order by total_points desc) as batch_ranks) as user_rank where istar_user=:istarUserId";
		
		System.out.println("Student Rank pojo "+sql);
		
		BaseHibernateDAO baseHibernateDAO = new BaseHibernateDAO();
		Session session = baseHibernateDAO.getSession();
		
		SQLQuery query = session.createSQLQuery(sql);
		query.setParameter("istarUserId",istarUserId);
		
		List results = query.list();
		
		if(results.size() > 0){
		Object[] studentData = (Object[]) results.get(0);
		
		Integer istarUserInBatchId = (Integer) studentData[0];
		Integer points = (Integer) studentData[1];
		Integer coins = (Integer) studentData[2];
		Integer rank = (Integer) studentData[3];
		
		IstarUserServices istarUserServices = new IstarUserServices();
		IstarUser istarUserInBatch = istarUserServices.getIstarUser(istarUserInBatchId);
		
		studentRankPOJO = new StudentRankPOJO();

		studentRankPOJO.setId(istarUserInBatch.getId());
		
		if(istarUserInBatch.getUserProfile()!=null){
			studentRankPOJO.setName(istarUserInBatch.getUserProfile().getFirstName());
			studentRankPOJO.setImageURL(istarUserInBatch.getUserProfile().getProfileImage());
		}else{
			studentRankPOJO.setName(istarUserInBatch.getEmail());
		}
		
		studentRankPOJO.setPoints(points);
		studentRankPOJO.setCoins(coins);
		studentRankPOJO.setBatchRank(rank);
		}
		return studentRankPOJO;
	}
	
	public String getUserRankInCourse(int student_id, int course_id)
	{
		
		String mediaUrlPath ="";
		int per_assessment_points=5,
				per_lesson_points=5,
				per_question_points=1,
				per_assessment_coins=5,
				per_lesson_coins=5,
				per_question_coins=1;
		try{
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
				if (inputStream != null) {
					properties.load(inputStream);
					mediaUrlPath =  properties.getProperty("media_url_path");
					per_assessment_points = Integer.parseInt(properties.getProperty("per_assessment_points"));
					per_lesson_points = Integer.parseInt(properties.getProperty("per_lesson_points"));
					per_question_points = Integer.parseInt(properties.getProperty("per_question_points"));
					per_assessment_coins = Integer.parseInt(properties.getProperty("per_assessment_coins"));
					per_lesson_coins = Integer.parseInt(properties.getProperty("per_lesson_coins"));
					per_question_coins = Integer.parseInt(properties.getProperty("per_question_coins"));
					System.out.println("media_url_path"+mediaUrlPath);
				}
			} catch (IOException e) {
				e.printStackTrace();
			
		}
		DBUTILS util = new DBUTILS();
		String getRankPointsForUser="SELECT * FROM ( SELECT istar_user, user_points, total_points, CAST (coins AS INTEGER) AS coins, perc, CAST ( RANK () OVER (ORDER BY user_points DESC) AS INTEGER ) AS user_rank FROM ( SELECT istar_user, user_points, total_points, coins, (case when total_points!= 0 then CAST ( (user_points * 100) / total_points AS INTEGER ) else 0 end )AS perc FROM ( SELECT T1.istar_user, SUM (T1.points) AS user_points, SUM (T1.max_points) AS total_points, SUM (T1.coins) AS coins FROM ( WITH summary AS ( SELECT P .istar_user, P .skill_objective, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', '"+per_lesson_points+"' ), ':per_assessment_points', '"+per_assessment_points+"' ), ':per_question_points', '"+per_question_points+"' ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .coins, '0'), ':per_lesson_coins', '"+per_lesson_coins+"' ), ':per_assessment_coins', '"+per_assessment_coins+"' ), ':per_question_coins', '"+per_assessment_coins+"' ) AS TEXT ) ) AS coins, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', '"+per_lesson_points+"' ), ':per_assessment_points', '"+per_assessment_points+"' ), ':per_question_points', '"+per_question_points+"' ) AS TEXT ) ) AS max_points, P .item_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id ORDER BY P . TIMESTAMP DESC ) AS rk FROM user_gamification P WHERE item_type IN ('QUESTION', 'LESSON') AND batch_group_id = ( SELECT batch_group. ID FROM batch_students, batch_group WHERE batch_students.batch_group_id = batch_group. ID AND batch_students.student_id = "+student_id+" AND batch_group.is_primary = 't' LIMIT 1 ) ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 GROUP BY istar_user  ) T2 ORDER BY user_points DESC, perc DESC, total_points DESC ) T3 ) T4 WHERE istar_user = "+student_id;
		System.out.println("get getRankPointsForUser"+getRankPointsForUser);
		List<HashMap<String, Object>> rankPointsData = util.executeQuery(getRankPointsForUser);
		int rank = 0;
		int coins = 0;
		double userPoints = 0;
		double totalPoints = 0;
		if(rankPointsData.size()>0)
		{
			rank = (int)rankPointsData.get(0).get("user_rank");
			coins = (int)rankPointsData.get(0).get("coins");
			userPoints = (double) rankPointsData.get(0).get("user_points");
			totalPoints= (double) rankPointsData.get(0).get("total_points");
		}
		return rank+"";
	}
	
	
	
	public SkillReportPOJO getSkillsReportForCourseOfUser(int istarUserId, int courseId){
		
		String mediaUrlPath ="";
		try{
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
				if (inputStream != null) {
					properties.load(inputStream);
					mediaUrlPath =  properties.getProperty("media_url_path");
					System.out.println("media_url_path"+mediaUrlPath);
				}
			} catch (IOException e) {
				e.printStackTrace();
			
		}
		
		
		Course course = new CourseDAO().findById(courseId);		
		if (course != null) {
			SkillReportPOJO courseSkillPOJO = new SkillReportPOJO();
			courseSkillPOJO.setId(course.getId());
			courseSkillPOJO.setName(course.getCourseName());
			String imageURL = mediaUrlPath+course.getImage_url();
			courseSkillPOJO.setImageURL(imageURL);
			List<SkillReportPOJO> shellTree = getShellSkillTreeForCourse(courseId);
			for(SkillReportPOJO dd : shellTree)
			{
				System.err.println("in mod shell tree "+dd.getName()+" - "+dd.getId());
				System.err.println("in mod shell tree "+" "+dd.getUserPoints()+" "+dd.getTotalPoints()+" "+dd.getPercentage());
				for(SkillReportPOJO ll: dd.getSkills())
				{
					//System.err.println("in cmsession shell tree "+ll.getName()+" - "+ll.getId());
					//System.err.println("in cmsession shell tree "+" "+ll.getUserPoints()+" "+ll.getTotalPoints()+" "+ll.getPercentage());
				}
			}
			DBUTILS utils = new DBUTILS();
			
			
			List<SkillReportPOJO> moduleLevelSkillReport= fillShellTreeWithData(shellTree, istarUserId, courseId);
			
			for(SkillReportPOJO dd : moduleLevelSkillReport)
			{
				System.err.println("in filled mod tree "+dd.getName()+" - "+dd.getId());
				System.err.println("in filled mod tree "+" "+dd.getUserPoints()+" "+dd.getTotalPoints()+" "+dd.getPercentage());
				for(SkillReportPOJO ll: dd.getSkills())
				{
					System.err.println("in filled sms tree "+ll.getName()+" - "+ll.getId());
					System.err.println("in filled sms tree "+" "+ll.getUserPoints()+" "+ll.getTotalPoints()+" "+ll.getPercentage());
				}
			}
			
			courseSkillPOJO.setSkills(moduleLevelSkillReport);
			courseSkillPOJO.calculateUserPoints();
			courseSkillPOJO.calculateTotalPoints();
			courseSkillPOJO.calculatePercentage();
			System.err.println("courseSkillPOJO.gettotal points"+courseSkillPOJO.getTotalPoints());
			System.err.println("courseSkillPOJO.getUserPoints points"+courseSkillPOJO.getUserPoints());
			
			return courseSkillPOJO;
		}
		else
		{
			return new SkillReportPOJO();
		}
		
	}


private List<SkillReportPOJO> fillShellTreeWithData(List<SkillReportPOJO> shellTree, int istarUserId, int courseId) {
	int per_assessment_points=5,
			per_lesson_points=5,
			per_question_points=1,
			per_assessment_coins=5,
			per_lesson_coins=5,
			per_question_coins=1;
	try{
		Properties properties = new Properties();
		String propertyFileName = "app.properties";
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
				
				per_assessment_points = Integer.parseInt(properties.getProperty("per_assessment_points"));
				per_lesson_points = Integer.parseInt(properties.getProperty("per_lesson_points"));
				per_question_points = Integer.parseInt(properties.getProperty("per_question_points"));
				per_assessment_coins = Integer.parseInt(properties.getProperty("per_assessment_coins"));
				per_lesson_coins = Integer.parseInt(properties.getProperty("per_lesson_coins"));
				per_question_coins = Integer.parseInt(properties.getProperty("per_question_coins"));
				
			}
		} catch (IOException e) {
			e.printStackTrace();
		
	}
	
	String getDataForTree="SELECT 	T1. ID, 	T1.skill_objective, 	T1.points, 	T1.max_points, 	module_skill. ID AS module_id FROM 	( 		WITH summary AS ( 			SELECT 				P . ID, 				P .skill_objective, 				custom_eval ( 					CAST ( 						TRIM ( 							REPLACE ( 								REPLACE ( 									REPLACE ( 										COALESCE (P .points, '0'), 										':per_lesson_points', 										'"+per_lesson_points+"' 									), 									':per_assessment_points', 									'"+per_assessment_points+"' 								), 								':per_question_points', 								'"+per_question_points+"' 							) 						) AS TEXT 					) 				) AS points, 				custom_eval ( 					CAST ( 						TRIM ( 							REPLACE ( 								REPLACE ( 									REPLACE ( 										COALESCE (P .max_points, '0'), 										':per_lesson_points', 										'"+per_lesson_points+"' 									), 									':per_assessment_points', 									'"+per_assessment_points+"' 								), 								':per_question_points', 								'"+per_question_points+"' 							) 						) AS TEXT 					) 				) AS max_points, 				ROW_NUMBER () OVER ( 					PARTITION BY P .skill_objective, 					P .item_id 				ORDER BY 					P . TIMESTAMP DESC 				) AS rk 			FROM 				user_gamification P, 				assessment_question, 				question 			WHERE 				P .course_id = "+courseId+" 			AND P .istar_user = "+istarUserId+" 			AND P .item_id = assessment_question.questionid 			AND assessment_question.assessmentid in (select distinct item_id from user_gamification where course_id = "+courseId+" and istar_user = "+istarUserId+" and item_type='ASSESSMENT') 			AND assessment_question.questionid = question. ID 			AND question.context_id = "+courseId+" 			AND P .item_type = 'QUESTION' 		) SELECT 			s.* 		FROM 			summary s 		WHERE 			s.rk = 1 	) T1 JOIN skill_objective cmsession_skill ON ( 	T1.skill_objective = cmsession_skill. ID ) JOIN skill_objective module_skill ON ( 	module_skill. ID = cmsession_skill.parent_skill )";
	System.out.println("getDataForTree in course"+getDataForTree);
	DBUTILS util = new DBUTILS();
	List<HashMap<String, Object>> data = util.executeQuery(getDataForTree);
	for(HashMap<String, Object> row: data)
	{
		int skillId = (int)row.get("skill_objective");
		double userPoints = (double)row.get("points");			
		double maxPoints = (double)row.get("max_points");
		int moduleId = (int)row.get("module_id");
		
		for(SkillReportPOJO mod : shellTree)
		{
			if(mod.getId() == moduleId)
			{
				List<SkillReportPOJO> cmsSkills = mod.getSkills();
				for(SkillReportPOJO cmsSkill: cmsSkills)
				{
					if(cmsSkill.getId()== skillId)
					{
						
						if(cmsSkill.getAccessedFirstTime()==true)
						{
							
							cmsSkill.setUserPoints(Math.ceil(userPoints));
							cmsSkill.setTotalPoints(Math.ceil(maxPoints));				
							cmsSkill.setAccessedFirstTime(false);
						}
						else
						{
							System.err.println(cmsSkill.getId()+" is accessed for the second time"+cmsSkill.getAccessedFirstTime());
							double oldUserPoint = cmsSkill.getUserPoints()!=null?cmsSkill.getUserPoints() : 0d;
							double userPoints1 = userPoints+oldUserPoint;
							double oldTotalPoint = cmsSkill.getTotalPoints()!=null?cmsSkill.getTotalPoints() : 0d;
							double maxPoints1 = maxPoints+oldTotalPoint;
							
							cmsSkill.setUserPoints(Math.ceil(userPoints1));
							cmsSkill.setTotalPoints(Math.ceil(maxPoints1));		
						}
						
								
						cmsSkill.calculatePercentage();
						//cmsSkills.add(cmsSkill);
						break;
					}
				}
				mod.calculateUserPoints();
				mod.calculateTotalPoints();
				mod.calculatePercentage();
				
				break;
			}
		}
	}
	
	return shellTree;
}

private List<SkillReportPOJO> getShellSkillTreeForCourse(int courseId) {
	String mediaUrlPath ="";
	int per_assessment_points=5,
			per_lesson_points=5,
			per_question_points=1,
			per_assessment_coins=5,
			per_lesson_coins=5,
			per_question_coins=1;
	try{
		Properties properties = new Properties();
		String propertyFileName = "app.properties";
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
				mediaUrlPath =  properties.getProperty("media_url_path");
				per_assessment_points = Integer.parseInt(properties.getProperty("per_assessment_points"));
				per_lesson_points = Integer.parseInt(properties.getProperty("per_lesson_points"));
				per_question_points = Integer.parseInt(properties.getProperty("per_question_points"));
				per_assessment_coins = Integer.parseInt(properties.getProperty("per_assessment_coins"));
				per_lesson_coins = Integer.parseInt(properties.getProperty("per_lesson_coins"));
				per_question_coins = Integer.parseInt(properties.getProperty("per_question_coins"));
				System.out.println("media_url_path"+mediaUrlPath);
			}
		} catch (IOException e) {
			e.printStackTrace();
		
	}
	
	List<SkillReportPOJO> skillsReport = new ArrayList<SkillReportPOJO>();
	DBUTILS utils = new DBUTILS();
	String getEmptyTreeStructure ="select * from  (SELECT distinct module_skill.id as module_id, module_skill.name as module_name, cmsession_skill.id as cmsession_skill_id, cmsession_skill.name as cmsession_skill_name FROM skill_objective module_skill, skill_objective cmsession_skill WHERE module_skill.context = "+courseId+" AND module_skill.context = "+courseId+" AND module_skill.id = cmsession_skill.parent_skill AND cmsession_skill.skill_level_type ='CMSESSION' and module_skill.skill_level_type ='MODULE' order by module_id ) T1 JOIN ( SELECT skill_objective_id, SUM ( custom_eval ( CAST ( TRIM ( REPLACE ( REPLACE ( REPLACE ( COALESCE (max_points, '0'), ':per_lesson_points', '"+per_lesson_points+"' ), ':per_assessment_points', '"+per_assessment_points+"' ), ':per_question_points', '"+per_question_points+"' ) ) AS TEXT ) ) ) AS max_points FROM assessment_benchmark WHERE context_id = "+courseId+" GROUP BY skill_objective_id ) AB ON ( AB.skill_objective_id = T1.cmsession_skill_id )"; 		
			System.out.println("getEmptyTreeStructure>>>"+getEmptyTreeStructure);
	List<HashMap<String, Object>> treeStructure = utils.executeQuery(getEmptyTreeStructure);
	for(HashMap<String, Object> treeRow: treeStructure)
	{
		int moduleId = (int)treeRow.get("module_id");
		String module_name = (String)treeRow.get("module_name");
		String moduleDesc = "";
		String moduleImage =null;
		
		String skillName = (String)treeRow.get("cmsession_skill_name");
		int skillId = (int)treeRow.get("cmsession_skill_id");
		double maxPoints = (double)treeRow.get("max_points");
		
		//lets create a mod pojo by default
		SkillReportPOJO modPojo = new SkillReportPOJO();
		modPojo.setName(module_name.trim());
		modPojo.setId(moduleId);
		modPojo.setSkills(new ArrayList<>());
		modPojo.setDescription(moduleDesc);
		modPojo.setImageURL(moduleImage);
		
		boolean moduleAlreadyPresentInTree = false;
		//we will check if this module pojo already exist in tree or not.
		//if exist then we will add cmsessions skills only to it
		//if do not exist then we will create one.
		for(SkillReportPOJO mod : skillsReport)
		{
			if(mod.getId()==moduleId)
			{
				modPojo = mod;
				moduleAlreadyPresentInTree= true;
				break;
			}									
		}
		
		
		boolean skillAlreadyPresent = false;
		if(modPojo.getSkills()!=null)
		{
			for(SkillReportPOJO cmsessionSkill : modPojo.getSkills())
			{
				if(cmsessionSkill.getId()== skillId)
				{
					skillAlreadyPresent = true;
					break;
				}
			}
		}
		
		//if session skill is not present in module tree then we will add session skill to module tree.
		if(!skillAlreadyPresent)
		{
			SkillReportPOJO sessionSkill = new SkillReportPOJO();
			sessionSkill.setId(skillId);
			sessionSkill.setName(skillName);
			sessionSkill.setUserPoints((double)0);
			sessionSkill.setTotalPoints(maxPoints);				
			List<SkillReportPOJO> sessionsSkills = modPojo.getSkills();
			sessionsSkills.add(sessionSkill);
			modPojo.setSkills(sessionsSkills);
		}
		modPojo.calculatePercentage();
		modPojo.calculateUserPoints();
		modPojo.calculateTotalPoints();
		
		if(!moduleAlreadyPresentInTree)
		{
			skillsReport.add(modPojo);
		}
		
	}
	 return skillsReport;
}

	
	public Course getCourse(int courseId) {
		Course course;
		CourseDAO courseDAO = new CourseDAO();
		try {
			course = courseDAO.findById(courseId);
		} catch (IllegalArgumentException e) {
			course = null;
		}
		return course;
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<Integer, HashMap<String, Object>> getPointsAndCoinsOfCmsessionSkillsOfCourseForUser(int istarUserId, int courseId){
		
		HashMap<Integer, HashMap<String, Object>> skillsMap = new HashMap<Integer, HashMap<String, Object>>();

		String sql = "select COALESCE(sum(points),0) as points, COALESCE(cast(sum(coins) as integer),0) as coins, skill_objective from user_gamification where istar_user= :istarUserId and item_id in (select id from assessment where course_id= :courseId) group by skill_objective";

		BaseHibernateDAO baseHibernateDAO = new BaseHibernateDAO();
		Session session = baseHibernateDAO.getSession();
		
		SQLQuery query = session.createSQLQuery(sql);
		query.setParameter("istarUserId", istarUserId);
		query.setParameter("courseId", courseId);
		
		List<Object[]> result = query.list();
		
		for(Object[] obj : result){
			HashMap<String, Object> map = new HashMap<String, Object>();

			map.put("points", (Double) obj[0]);
			map.put("coins", (Integer) obj[1]);
			
			skillsMap.put((Integer)obj[2], map);
		}
		return skillsMap;
	}
	
	@SuppressWarnings("unchecked")
	public Double getMaxPointsOfCmsessionSkill(int cmsessionSkillObjectiveId){
		
		Double maxPoints = 0.0;
		
		String sql = "select COALESCE(cast(sum(question.difficulty_level) as integer),0) as difficulty_level, "
				+ "COALESCE(cast(count(distinct lesson_skill_objective.lessonid) as integer),0) as number_of_lessons from "
				+ "lesson_skill_objective,question_skill_objective,question,skill_objective where "
				+ "lesson_skill_objective.learning_objectiveid=question_skill_objective.learning_objectiveid and "
				+ "question_skill_objective.questionid=question.id and question_skill_objective.learning_objectiveid=skill_objective.id and "
				+ "skill_objective.parent_skill= :cmsessionSkillObjectiveId";
		
		System.out.println(sql);
		BaseHibernateDAO baseHibernateDAO = new BaseHibernateDAO();
		Session session = baseHibernateDAO.getSession();
		
		SQLQuery query = session.createSQLQuery(sql);
		query.setParameter("cmsessionSkillObjectiveId", cmsessionSkillObjectiveId);

		List<Object[]> result = query.list();
		
		if(result.size()>0){
			Integer difficultyLevelSum = (Integer) result.get(0)[0];		
			Integer numberOfLessons = (Integer) result.get(0)[1];
			
			try{
				Properties properties = new Properties();
				String propertyFileName = "app.properties";
				InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
					if (inputStream != null) {
						properties.load(inputStream);
						String pointsBenchmark = properties.getProperty("pointsBenchmark");				
						Integer benchmark = Integer.parseInt(pointsBenchmark);
						
						maxPoints = (difficultyLevelSum + (numberOfLessons* benchmark))*1.0;		
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
		}		
		return maxPoints;
	}


	public List<AdminSkillGraph> getModuleSkillGraphForCourse(int courseId, int collegeId) {
		// TODO Auto-generated method stub
		DBUTILS util = new DBUTILS();
		List<AdminSkillGraph> moduleSkillGraph = new ArrayList<>();
		
		int stuCount =0;
		String totalUserIncourse ="select cast (count(distinct student_id) as integer) as stu_count from batch, batch_group, batch_students where batch.batch_group_id = batch_group.id and batch_group.id = batch_students.batch_group_id and batch_group.college_id = "+collegeId+" and batch.course_id ="+courseId;
		List<HashMap<String, Object>> stuData = util.executeQuery(totalUserIncourse);
		if(stuData.size()>0 && (int)stuData.get(0).get("stu_count")>0)
		{
			stuCount = (int)stuData.get(0).get("stu_count");
		}
		{	
			String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'rookie_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'rookie_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+courseId+" 							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
			List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
			ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
			for(HashMap<String, Object> row: modData)
			{
				AdminModuleSkill modSkill = new AdminModuleSkill();
				modSkill.setDrilldown(true);
				modSkill.setName(row.get("name").toString());
				int rookieCount = (int)row.get("rookie_count"); 
				float percenatge = 0f;
				if(stuCount!=0)
				{
					percenatge = (rookieCount*100)/stuCount;
				}
				DecimalFormat df = new DecimalFormat("#.##");
				modSkill.setY(new Float(df.format(percenatge)));
				moduleSkills.add(modSkill);
			}
			
			AdminSkillGraph rookie = new AdminSkillGraph();
			rookie.setName("ROOKIE");		
			rookie.setData(moduleSkills);
			moduleSkillGraph.add(rookie);
	}
		
		
		{
			
			String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'apprentice_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'apprentice_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+courseId+" 							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
			List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
			ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
			for(HashMap<String, Object> row: modData)
			{
				AdminModuleSkill modSkill = new AdminModuleSkill();
				modSkill.setDrilldown(true);
				modSkill.setName(row.get("name").toString());
				int rookieCount = (int)row.get("rookie_count"); 
				float percenatge = 0f;
				if(stuCount!=0)
				{
					percenatge = (rookieCount*100)/stuCount;
				}
				DecimalFormat df = new DecimalFormat("#.##");
				modSkill.setY(new Float(df.format(percenatge)));
				moduleSkills.add(modSkill);
			}
			
		AdminSkillGraph apprentice = new AdminSkillGraph();
		apprentice.setName("APPRENTICE");		
		apprentice.setData(moduleSkills);
		moduleSkillGraph.add(apprentice);
		}
		
		{
			
			String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'master_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'master_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+courseId+" 							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
			List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
			ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
			for(HashMap<String, Object> row: modData)
			{
				AdminModuleSkill modSkill = new AdminModuleSkill();
				modSkill.setDrilldown(true);
				modSkill.setName(row.get("name").toString());
				int rookieCount = (int)row.get("rookie_count"); 
				float percenatge = 0f;
				if(stuCount!=0)
				{
					percenatge = (rookieCount*100)/stuCount;
				}
				DecimalFormat df = new DecimalFormat("#.##");
				modSkill.setY(new Float(df.format(percenatge)));
				moduleSkills.add(modSkill);
			}
			
		AdminSkillGraph master = new AdminSkillGraph();
		master.setName("MASTER");		
		master.setData(moduleSkills);
		moduleSkillGraph.add(master);
		}
		
		{
			
			String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'wizard_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'wizard_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+courseId+" 							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
			List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
			ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
			for(HashMap<String, Object> row: modData)
			{
				AdminModuleSkill modSkill = new AdminModuleSkill();
				modSkill.setDrilldown(true);
				modSkill.setName(row.get("name").toString());
				int rookieCount = (int)row.get("rookie_count"); 
				float percenatge = 0f;
				if(stuCount!=0)
				{
					percenatge = (rookieCount*100)/stuCount;
				}
				DecimalFormat df = new DecimalFormat("#.##");
				modSkill.setY(new Float(df.format(percenatge)));
				moduleSkills.add(modSkill);
			}
		AdminSkillGraph wizard = new AdminSkillGraph();
		wizard.setName("WIZARD");		
		wizard.setData(moduleSkills);
		moduleSkillGraph.add(wizard);
		}
		return moduleSkillGraph;
	}


	public List<AdminSkillGraph> getModuleSkillGraphForBatch(int batchId, int collegeId) {
		// TODO Auto-generated method stub
				DBUTILS util = new DBUTILS();
				List<AdminSkillGraph> moduleSkillGraph = new ArrayList<>();
				Batch b = new BatchDAO().findById(batchId);
				int stuCount =0;
				String totalUserIncourse ="select cast (count(distinct student_id) as integer) as stu_count from batch, batch_group, batch_students where batch.batch_group_id = batch_group.id and batch_group.id = batch_students.batch_group_id and batch_group.college_id = "+collegeId+" and batch.id="+batchId;
				List<HashMap<String, Object>> stuData = util.executeQuery(totalUserIncourse);
				if(stuData.size()>0 && (int)stuData.get(0).get("stu_count")>0)
				{
					stuCount = (int)stuData.get(0).get("stu_count");
				}
				{	
					String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'rookie_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'rookie_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+b.getCourse().getId()+"    and P.batch_group_id="+b.getBatchGroup().getId()+"							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
					List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
					ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
					for(HashMap<String, Object> row: modData)
					{
						AdminModuleSkill modSkill = new AdminModuleSkill();
						modSkill.setDrilldown(true);
						modSkill.setName(row.get("name").toString());
						int rookieCount = (int)row.get("rookie_count"); 
						float percenatge = 0f;
						if(stuCount!=0)
						{
							percenatge = (rookieCount*100)/stuCount;
						}
						DecimalFormat df = new DecimalFormat("#.##");
						modSkill.setY(new Float(df.format(percenatge)));
						moduleSkills.add(modSkill);
					}
					
					AdminSkillGraph rookie = new AdminSkillGraph();
					rookie.setName("ROOKIE");		
					rookie.setData(moduleSkills);
					moduleSkillGraph.add(rookie);
			}
				
				
				{
					
					String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'apprentice_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'apprentice_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+b.getCourse().getId()+"  and P.batch_group_id="+b.getBatchGroup().getId()+"							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
					List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
					ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
					for(HashMap<String, Object> row: modData)
					{
						AdminModuleSkill modSkill = new AdminModuleSkill();
						modSkill.setDrilldown(true);
						modSkill.setName(row.get("name").toString());
						int rookieCount = (int)row.get("rookie_count"); 
						float percenatge = 0f;
						if(stuCount!=0)
						{
							percenatge = (rookieCount*100)/stuCount;
						}
						DecimalFormat df = new DecimalFormat("#.##");
						modSkill.setY(new Float(df.format(percenatge)));
						moduleSkills.add(modSkill);
					}
					
				AdminSkillGraph apprentice = new AdminSkillGraph();
				apprentice.setName("APPRENTICE");		
				apprentice.setData(moduleSkills);
				moduleSkillGraph.add(apprentice);
				}
				
				{
					
					String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'master_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'master_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+b.getCourse().getId()+" and P.batch_group_id="+b.getBatchGroup().getId()+"							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
					List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
					ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
					for(HashMap<String, Object> row: modData)
					{
						AdminModuleSkill modSkill = new AdminModuleSkill();
						modSkill.setDrilldown(true);
						modSkill.setName(row.get("name").toString());
						int rookieCount = (int)row.get("rookie_count"); 
						float percenatge = 0f;
						if(stuCount!=0)
						{
							percenatge = (rookieCount*100)/stuCount;
						}
						DecimalFormat df = new DecimalFormat("#.##");
						modSkill.setY(new Float(df.format(percenatge)));
						moduleSkills.add(modSkill);
					}
					
				AdminSkillGraph master = new AdminSkillGraph();
				master.setName("MASTER");		
				master.setData(moduleSkills);
				moduleSkillGraph.add(master);
				}
				
				{
					
					String findModuleSkill = " select id , name, COALESCE(rookie_count,0) as rookie_count from (	select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='MODULE' ) TL left join (select module_skill_id , CAST ( 		COUNT (*) FILTER (  			WHERE 				percentage >= ( 					SELECT 						CAST (property_value AS INTEGER) 					FROM 						constant_properties 					WHERE 						property_name = 'wizard_min' 				) 			AND percentage < ( 				SELECT 					CAST (property_value AS INTEGER) 				FROM 					constant_properties 				WHERE 					property_name = 'wizard_max' 			) 		) AS INTEGER 	) rookie_count  from (select istar_user, module_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, module_skill.id as  module_skill_id, module_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (					WITH summary AS ( 							SELECT 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS points, 								custom_eval ( 									CAST ( 										REPLACE ( 											REPLACE ( 												REPLACE ( 													COALESCE (P .max_points, '0'), 													':per_lesson_points', 													( 														SELECT 															CAST (property_value AS VARCHAR) 														FROM 															constant_properties 														WHERE 															property_name = 'per_lesson_points' 													) 												), 												':per_assessment_points', 												( 													SELECT 														CAST (property_value AS VARCHAR) 													FROM 														constant_properties 													WHERE 														property_name = 'per_assessment_points' 												) 											), 											':per_question_points', 											( 												SELECT 													CAST (property_value AS VARCHAR) 												FROM 													constant_properties 												WHERE 													property_name = 'per_question_points' 											) 										) AS TEXT 									) 								) AS max_points, 								P .istar_user, 								P .skill_objective, 								P .item_id, 								P .item_type, 								P .batch_group_id, 								ROW_NUMBER () OVER ( 									PARTITION BY P .istar_user, 									P .skill_objective, 									P .item_id, 									P .item_type, 									P .batch_group_id 								ORDER BY 									P .created_at DESC 								) AS rk 							FROM 								user_gamification P 							WHERE 								P .course_id = "+b.getCourse().getId()+" and P.batch_group_id="+b.getBatchGroup().getId()+"							AND P .org_id = "+collegeId+" 						) SELECT 							s.* 						FROM 							summary s 						WHERE 							s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id group by istar_user, module_skill.id, module_skill.name ) TBF ) TF group by Tf.module_skill_id )TR on (TL.id =TR.module_skill_id)";
					List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkill);
					ArrayList<AdminModuleSkill> moduleSkills = new ArrayList<>(); 
					for(HashMap<String, Object> row: modData)
					{
						AdminModuleSkill modSkill = new AdminModuleSkill();
						modSkill.setDrilldown(true);
						modSkill.setName(row.get("name").toString());
						int rookieCount = (int)row.get("rookie_count"); 
						float percenatge = 0f;
						if(stuCount!=0)
						{
							percenatge = (rookieCount*100)/stuCount;
						}
						DecimalFormat df = new DecimalFormat("#.##");
						modSkill.setY(new Float(df.format(percenatge)));
						moduleSkills.add(modSkill);
					}
				AdminSkillGraph wizard = new AdminSkillGraph();
				wizard.setName("WIZARD");		
				wizard.setData(moduleSkills);
				moduleSkillGraph.add(wizard);
				}
				return moduleSkillGraph;
	}


	public HashMap<String, ArrayList<AdminCMSessionSkillData>> getCMSessionSkillGraphForCourse(int courseId, int collegeId) {
		DBUTILS util = new DBUTILS();
		HashMap<String, ArrayList<AdminCMSessionSkillData>> data = new HashMap<>();
	
		int stuCount =0;
		String totalUserIncourse ="select cast (count(distinct student_id) as integer) as stu_count from batch, batch_group, batch_students where batch.batch_group_id = batch_group.id and batch_group.id = batch_students.batch_group_id and batch_group.college_id = "+collegeId+" and batch.course_id ="+courseId;
		List<HashMap<String, Object>> stuData = util.executeQuery(totalUserIncourse);
		if(stuData.size()>0 && (int)stuData.get(0).get("stu_count")>0)
		{
			stuCount = (int)stuData.get(0).get("stu_count");
		}
		
		String findModuleSkills = "select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='MODULE'";
		List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkills);
		for(HashMap<String, Object> mod: modData)
		{
			int modId = (int)mod.get("id");
			ArrayList<AdminCMSessionSkillData> list = new ArrayList<>();
			{
				// rookie starts here
				
				AdminCMSessionSkillData rookie= new AdminCMSessionSkillData();
				rookie.setName("ROOKIE");			
				ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
				String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'rookie_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'rookie_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+courseId+" AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
				List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
				for(HashMap<String, Object> cms : cmsData)
				{

					int rookieCount = (int)cms.get("rookie_count"); 
					float percenatge = 0f;
					if(stuCount!=0)
					{
						percenatge = (rookieCount*100)/stuCount;
					}
					DecimalFormat df = new DecimalFormat("#.##");
					String skillName = cms.get("name").toString();
					ArrayList<Object> cmsSkill = new ArrayList<>();
					cmsSkill.add(skillName);
					cmsSkill.add(new Float(df.format(percenatge)));
					cmsessionData.add(cmsSkill);		
				}							
				rookie.setData(cmsessionData);
				list.add(rookie);
		 }
			// rookie ends here
			
			// apprentice starts here
			{	
				
				
				AdminCMSessionSkillData apprentice= new AdminCMSessionSkillData();
				apprentice.setName("APPRENTICE");			
				ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
				String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'apprentice_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'apprentice_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+courseId+" AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
				List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
				for(HashMap<String, Object> cms : cmsData)
				{
					int rookieCount = (int)cms.get("rookie_count"); 
					float percenatge = 0f;
					if(stuCount!=0)
					{
						percenatge = (rookieCount*100)/stuCount;
					}
					DecimalFormat df = new DecimalFormat("#.##");
					String skillName = cms.get("name").toString();
					ArrayList<Object> cmsSkill = new ArrayList<>();
					cmsSkill.add(skillName);
					cmsSkill.add(new Float(df.format(percenatge)));
					cmsessionData.add(cmsSkill);
				}							
				apprentice.setData(cmsessionData);
				list.add(apprentice);
			}		
						// apprentice ends here
						
						// master starts here
			{			
						AdminCMSessionSkillData master= new AdminCMSessionSkillData();
						master.setName("MASTER");			
						ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
						String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'master_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'master_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+courseId+" AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
						List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
						for(HashMap<String, Object> cms : cmsData)
						{
							int rookieCount = (int)cms.get("rookie_count"); 
							float percenatge = 0f;
							if(stuCount!=0)
							{
								percenatge = (rookieCount*100)/stuCount;
							}
							DecimalFormat df = new DecimalFormat("#.##");
							String skillName = cms.get("name").toString();
							ArrayList<Object> cmsSkill = new ArrayList<>();
							cmsSkill.add(skillName);
							cmsSkill.add(new Float(df.format(percenatge)));
							cmsessionData.add(cmsSkill);	
						}							
						master.setData(cmsessionData);
						list.add(master);
			}		
						// master ends here
						
						
						// wizard starts here
			{		
						AdminCMSessionSkillData wizard= new AdminCMSessionSkillData();
						wizard.setName("WIZARD");			
						ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
						String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+courseId+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'wizard_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'wizard_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+courseId+" AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
						List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
						for(HashMap<String, Object> cms : cmsData)
						{
							int rookieCount = (int)cms.get("rookie_count"); 
							float percenatge = 0f;
							if(stuCount!=0)
							{
								percenatge = (rookieCount*100)/stuCount;
							}
							DecimalFormat df = new DecimalFormat("#.##");
							String skillName = cms.get("name").toString();
							ArrayList<Object> cmsSkill = new ArrayList<>();
							cmsSkill.add(skillName);
							cmsSkill.add(new Float(df.format(percenatge)));
							cmsessionData.add(cmsSkill);
						}							
						wizard.setData(cmsessionData);
						list.add(wizard);
			}		
						// wizard ends here			
			data.put(mod.get("name").toString(),list);
		}
		
		return data;
	}


	public HashMap<String, ArrayList<AdminCMSessionSkillData>> getCMSessionSkillGraphForBatch(int batchId, int collegeId) {
		DBUTILS util = new DBUTILS();
		HashMap<String, ArrayList<AdminCMSessionSkillData>> data = new HashMap<>();
		Batch b = new BatchDAO().findById(batchId);
		int stuCount =0;
		String totalUserIncourse ="select cast (count(distinct student_id) as integer) as stu_count from batch, batch_group, batch_students where batch.batch_group_id = batch_group.id and batch_group.id = batch_students.batch_group_id and batch_group.college_id = "+collegeId+" and batch.id ="+batchId;
		List<HashMap<String, Object>> stuData = util.executeQuery(totalUserIncourse);
		if(stuData.size()>0 && (int)stuData.get(0).get("stu_count")>0)
		{
			stuCount = (int)stuData.get(0).get("stu_count");
		}
		
		String findModuleSkills = "select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='MODULE'";
		List<HashMap<String, Object>> modData= util.executeQuery(findModuleSkills);
		for(HashMap<String, Object> mod: modData)
		{
			int modId = (int)mod.get("id");
			ArrayList<AdminCMSessionSkillData> list = new ArrayList<>();
			{
				// rookie starts here
				
				AdminCMSessionSkillData rookie= new AdminCMSessionSkillData();
				rookie.setName("ROOKIE");			
				ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
				String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'rookie_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'rookie_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+b.getCourse().getId()+" and P.batch_group_id ="+b.getBatchGroup().getId()+" AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
				List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
				for(HashMap<String, Object> cms : cmsData)
				{

					int rookieCount = (int)cms.get("rookie_count"); 
					float percenatge = 0f;
					if(stuCount!=0)
					{
						percenatge = (rookieCount*100)/stuCount;
					}
					DecimalFormat df = new DecimalFormat("#.##");
					String skillName = cms.get("name").toString();
					ArrayList<Object> cmsSkill = new ArrayList<>();
					cmsSkill.add(skillName);
					cmsSkill.add(new Float(df.format(percenatge)));
					cmsessionData.add(cmsSkill);		
				}							
				rookie.setData(cmsessionData);
				list.add(rookie);
		 }
			// rookie ends here
			
			// apprentice starts here
			{	
				
				
				AdminCMSessionSkillData apprentice= new AdminCMSessionSkillData();
				apprentice.setName("APPRENTICE");			
				ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
				String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'apprentice_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'apprentice_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+b.getCourse().getId()+" and P.batch_group_id = "+b.getBatchGroup().getId()+" AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
				List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
				for(HashMap<String, Object> cms : cmsData)
				{
					int rookieCount = (int)cms.get("rookie_count"); 
					float percenatge = 0f;
					if(stuCount!=0)
					{
						percenatge = (rookieCount*100)/stuCount;
					}
					DecimalFormat df = new DecimalFormat("#.##");
					String skillName = cms.get("name").toString();
					ArrayList<Object> cmsSkill = new ArrayList<>();
					cmsSkill.add(skillName);
					cmsSkill.add(new Float(df.format(percenatge)));
					cmsessionData.add(cmsSkill);
				}							
				apprentice.setData(cmsessionData);
				list.add(apprentice);
			}		
						// apprentice ends here
						
						// master starts here
			{			
						AdminCMSessionSkillData master= new AdminCMSessionSkillData();
						master.setName("MASTER");			
						ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
						String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'master_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'master_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+b.getCourse().getId()+" and P.batch_group_id="+b.getBatchGroup().getId()+" AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
						List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
						for(HashMap<String, Object> cms : cmsData)
						{
							int rookieCount = (int)cms.get("rookie_count"); 
							float percenatge = 0f;
							if(stuCount!=0)
							{
								percenatge = (rookieCount*100)/stuCount;
							}
							DecimalFormat df = new DecimalFormat("#.##");
							String skillName = cms.get("name").toString();
							ArrayList<Object> cmsSkill = new ArrayList<>();
							cmsSkill.add(skillName);
							cmsSkill.add(new Float(df.format(percenatge)));
							cmsessionData.add(cmsSkill);	
						}							
						master.setData(cmsessionData);
						list.add(master);
			}		
						// master ends here
						
						
						// wizard starts here
			{		
						AdminCMSessionSkillData wizard= new AdminCMSessionSkillData();
						wizard.setName("WIZARD");			
						ArrayList<ArrayList<Object>> cmsessionData = new ArrayList<>(); 			
						String findCMSessionData =" select id , name, COALESCE(rookie_count,0) as rookie_count from (select distinct id, name from skill_objective where context ="+b.getCourse().getId()+" and skill_level_type='CMSESSION' and parent_skill="+modId+" ) TL left join (select cms_skill_id , CAST ( COUNT (*) FILTER (  WHERE percentage >= ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'wizard_min' ) AND percentage < ( SELECT CAST (property_value AS INTEGER) FROM constant_properties WHERE property_name = 'wizard_max' ) ) AS INTEGER ) rookie_count  from (select istar_user, cms_skill_id, case when max_points is  null or max_points =0 then 0 else (points*100/(max_points)) end  as percentage    from (select istar_user, cms_skill.id as  cms_skill_id, cms_skill.name, sum (points) as points, sum(max_points) as max_points from (select istar_user, skill_objective, sum(points) as points, sum(max_points) as max_points from (WITH summary AS ( SELECT custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS points, custom_eval ( CAST ( REPLACE ( REPLACE ( REPLACE ( COALESCE (P .max_points, '0'), ':per_lesson_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_lesson_points' ) ), ':per_assessment_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_assessment_points' ) ), ':per_question_points', ( SELECT CAST (property_value AS VARCHAR) FROM constant_properties WHERE property_name = 'per_question_points' ) ) AS TEXT ) ) AS max_points, P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id, ROW_NUMBER () OVER ( PARTITION BY P .istar_user, P .skill_objective, P .item_id, P .item_type, P .batch_group_id ORDER BY P .created_at DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+b.getCourse().getId()+" and P.batch_group_id ="+b.getBatchGroup().getId()+"  AND P .org_id = "+collegeId+" ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 group by istar_user, skill_objective )T2, skill_objective cms_skill, skill_objective module_skill where T2.skill_objective = cms_skill.id and cms_skill.parent_skill = module_skill.id and module_skill.id ="+modId+"  group by istar_user, cms_skill.id, cms_skill.name ) TBF ) TF group by Tf.cms_skill_id )TR on (TL.id =TR.cms_skill_id)";
						List<HashMap<String, Object>> cmsData = util.executeQuery(findCMSessionData);
						for(HashMap<String, Object> cms : cmsData)
						{
							int rookieCount = (int)cms.get("rookie_count"); 
							float percenatge = 0f;
							if(stuCount!=0)
							{
								percenatge = (rookieCount*100)/stuCount;
							}
							DecimalFormat df = new DecimalFormat("#.##");
							String skillName = cms.get("name").toString();
							ArrayList<Object> cmsSkill = new ArrayList<>();
							cmsSkill.add(skillName);
							cmsSkill.add(new Float(df.format(percenatge)));
							cmsessionData.add(cmsSkill);
						}							
						wizard.setData(cmsessionData);
						list.add(wizard);
			}		
						// wizard ends here			
			data.put(mod.get("name").toString(),list);
		}
		
		return data;

	}
}
