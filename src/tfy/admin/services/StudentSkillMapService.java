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

	
	public List<HashMap<String, Object>> getCoursesOfUser(int userId)
	{
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> courses = new ArrayList<>();
		String sql="select id, trim(course_name) as course_name , (case when image_url is null or image_url ='' then 'http://api.talentify.in/video/android_images/'||substr(course_name, 1,1)||'.png' else 'http://api.talentify.in/'||image_url end ) as course_image from course where id in (select distinct course_id from student_playlist where student_id =  "+userId+")";
		System.out.println(">>>>>>>>>>>>>>>>>>>>>."+sql);
		courses = util.executeQuery(sql);
		return courses;
	}
	@SuppressWarnings("unchecked")
	public List<SkillReportPOJO> getSkillsMapOfUser(int istarUserId){
		
		List<SkillReportPOJO> allSkills = new ArrayList<SkillReportPOJO>();
		
		String sql = "select COALESCE(sum(user_gamification.points),0) as total_points, COALESCE(cast(sum(user_gamification.coins) as integer),0) as total_coins, so_session.name as session_so_name, so_session.id as session_so_id, so_module.name as module_so_name, so_module.id as module_so_id,  so_course.name as course_so_name, so_course.id as course_so_id, course_skill_objective.course_id as course_id from user_gamification, skill_objective so_session, skill_objective so_module, skill_objective so_course, course_skill_objective where user_gamification.skill_objective=so_session.id and so_module.id=so_session.parent_skill and so_module.parent_skill=so_course.id and so_course.id=course_skill_objective.skill_objective_id and istar_user= :istarUserId group by session_so_id,session_so_name, module_so_id, module_so_name, course_so_id, course_id, course_skill_objective.course_id order by course_so_id,module_so_id,session_so_id";
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
		DBUTILS util = new DBUTILS();
		String rank ="NA";
		String sql="select TFF.user_rank from  (SELECT 	*, COALESCE ( 		CAST ( 			RANK () OVER (ORDER BY total_points DESC) AS INTEGER 		), 		0 	) as user_rank FROM  ( 		SELECT 			user_gamification.istar_user, 			CAST ( 				SUM (user_gamification.points) AS INTEGER 			) AS total_points, 			CAST ( 				SUM (user_gamification.coins) AS INTEGER 			) AS total_coins 		FROM 			assessment, 			user_gamification 		WHERE 			user_gamification.item_id = assessment. ID 		AND course_id = "+course_id+" 		AND user_gamification.istar_user IN  ( 			SELECT 				student_id 			FROM 				batch_students 			WHERE 				batch_group_id IN  ( 					SELECT 						batch_group_id 					FROM 						batch_students 					WHERE 						batch_students.student_id = "+student_id+" 				) 		) 		GROUP BY 			user_gamification.istar_user 		ORDER BY 			total_points DESC 	) AS batch_ranks  )TFF where TFF. istar_user = "+student_id+"";
		List<HashMap<String, Object>> rankData = util.executeQuery(sql);
		if(rankData.size()>0 && rankData.get(0).get("user_rank")!=null)
		{
			rank = rankData.get(0).get("user_rank").toString();
		}
		return rank;
	}
	
	
	public SkillReportPOJO getSkillsReportForCourseOfUser(int istarUserId, int courseId){
		//long previousTime = System.currentTimeMillis();
		//System.err.println("500000000->" + "Time->"+(System.currentTimeMillis()-previousTime));
		List<SkillReportPOJO> allSkillsReport = new ArrayList<SkillReportPOJO>();
		HashMap<Integer, HashMap<String, Object>> skillsMap = getPointsAndCoinsOfCmsessionSkillsOfCourseForUser(istarUserId, courseId);
		Course course = getCourse(courseId);
		SkillReportPOJO courseSkill = new SkillReportPOJO();
		for(Module module : course.getModules()){			
			for(SkillObjective moduleSkillObjective : module.getSkillObjectives()){				
				SkillReportPOJO moduleSkillReportPOJO=null;				
				for(SkillReportPOJO tempModuleSkillReportPOJO :  allSkillsReport){
					if(tempModuleSkillReportPOJO.getId()==moduleSkillObjective.getId()){
						moduleSkillReportPOJO = tempModuleSkillReportPOJO;
					}
				}
								
				if(moduleSkillReportPOJO==null){
					moduleSkillReportPOJO = new SkillReportPOJO();
					moduleSkillReportPOJO.setId(moduleSkillObjective.getId());
					moduleSkillReportPOJO.setName(moduleSkillObjective.getName());
					
					List<SkillReportPOJO> allCmsessionSkills = new ArrayList<SkillReportPOJO>();
					
					for(Cmsession cmsession : module.getCmsessions()){
						for(SkillObjective cmsessionSkillObjective : cmsession.getSkillObjectives()){
							SkillReportPOJO cmsessionSkillReportPOJO = new SkillReportPOJO();
							
							cmsessionSkillReportPOJO.setId(cmsessionSkillObjective.getId());
							cmsessionSkillReportPOJO.setName(cmsessionSkillObjective.getName());
							//System.err.println("5->" + "Time->"+(System.currentTimeMillis()-previousTime));
							cmsessionSkillReportPOJO.setTotalPoints(getMaxPointsOfCmsessionSkill(cmsessionSkillObjective.getId()));
							//System.err.println("6->" + "Time->"+(System.currentTimeMillis()-previousTime));
					          if(skillsMap.containsKey(cmsessionSkillObjective.getId())){
					            cmsessionSkillReportPOJO.setUserPoints((Double) skillsMap.get(cmsessionSkillObjective.getId()).get("points"));
					          }else{
					        	  System.out.println("CMSESSION SKILL NOT PRESENT->" + cmsessionSkillObjective.getId());
					            cmsessionSkillReportPOJO.setUserPoints(0.0);
					          }					          
							allCmsessionSkills.add(cmsessionSkillReportPOJO);
						}
					}		
					moduleSkillReportPOJO.setSkills(allCmsessionSkills);
					moduleSkillReportPOJO.calculateUserPoints();
					moduleSkillReportPOJO.calculateTotalPoints();
					moduleSkillReportPOJO.calculatePercentage();
				}
				allSkillsReport.add(moduleSkillReportPOJO);				
			}
		}
		
		courseSkill.setSkills(allSkillsReport);
		courseSkill.calculateUserPoints();
		courseSkill.calculateTotalPoints();
		courseSkill.calculatePercentage();
		return courseSkill;
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
