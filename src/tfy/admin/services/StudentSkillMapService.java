/**
 * 
 */
package tfy.admin.services;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.utils.user.IstarUserServices;
import com.viksitpro.core.utilities.DBUTILS;
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
		String sql="select id, trim(course_name) as course_name , (case when image_url is null or image_url ='' then 'http://cdn.talentify.in/course_images/'||substr(course_name, 1,1)||'.png' else 'http://cdn.talentify.in/'||image_url end ) as course_image from course where id in (select distinct course_id from student_playlist where student_id =  "+userId+")";
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
					System.err.println("in cmsession shell tree "+ll.getName()+" - "+ll.getId());
					System.err.println("in cmsession shell tree "+" "+ll.getUserPoints()+" "+ll.getTotalPoints()+" "+ll.getPercentage());
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
	
	String getDataForTree="SELECT * FROM ( SELECT T1. ID, T1.skill_objective, T1.points, T1.max_points, cmsession_module.module_id FROM ( WITH summary AS ( SELECT P . ID, P .skill_objective, custom_eval( cast (replace(replace(replace(COALESCE(P .points,'0'),':per_lesson_points','"+per_lesson_points+"'),':per_assessment_points','"+per_assessment_points+"'),':per_question_points','"+per_question_points+"') as text)) as points, custom_eval( cast (replace(replace(replace(COALESCE(P .max_points,'0'),':per_lesson_points','"+per_lesson_points+"'),':per_assessment_points','"+per_assessment_points+"'),':per_question_points','"+per_question_points+"') as text)) as max_points, ROW_NUMBER () OVER ( PARTITION BY P .skill_objective,  P.item_id ORDER BY P . TIMESTAMP DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+courseId+" AND P .item_type = 'QUESTION' ) SELECT s.* FROM summary s WHERE s.rk = 1 ) T1 JOIN cmsession_skill_objective ON ( T1.skill_objective = cmsession_skill_objective.skill_objective_id ) JOIN cmsession_module ON ( cmsession_module.cmsession_id = cmsession_skill_objective.cmsession_id ) ) LT UNION  SELECT QT. ID, QT.skill_objective, QT.points, QT.max_points, QT.module_id FROM  ( WITH summary AS ( SELECT P . ID, P .skill_objective, custom_eval( cast (replace(replace(replace(P .points,':per_lesson_points','"+per_lesson_points+"'),':per_assessment_points','"+per_assessment_points+"'),':per_question_points','"+per_question_points+"') as text)) as points, custom_eval( cast (replace(replace(replace(P .max_points,':per_lesson_points','"+per_lesson_points+"'),':per_assessment_points','"+per_assessment_points+"'),':per_question_points','"+per_question_points+"') as text)) as max_points, P .module_id, ROW_NUMBER () OVER ( PARTITION BY P .skill_objective ORDER BY P . TIMESTAMP DESC ) AS rk FROM user_gamification P WHERE P .course_id = "+courseId+" AND P .item_type = 'LESSON' ) SELECT s.* FROM summary s WHERE s.rk = 1 ) QT";
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
}
