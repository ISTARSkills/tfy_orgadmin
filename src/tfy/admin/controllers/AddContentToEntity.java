package tfy.admin.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jgroups.util.UUID;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportUtils;
import in.talentify.core.controllers.IStarBaseServelet;
import in.talentify.core.utils.AndroidNoticeDelegator;
import tfy.admin.services.StudentPlayListServicesAdmin;

/**
 * Servlet implementation class AddContentToEntity
 */
@WebServlet("/add_content_to_entity")
public class AddContentToEntity extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddContentToEntity() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		
		int skillId = Integer.parseInt(request.getParameter("skill_id"));
		int entityId = Integer.parseInt(request.getParameter("entity_id"));
		String entityType = request.getParameter("entity_type");
		Integer adminId = Integer.parseInt(request.getParameter("admin_id")); 
		CustomReportUtils repUtils = new CustomReportUtils();
		CustomReport rep = repUtils.getReport(15); 				
		String sql = rep.getSql();
		sql = sql.replaceAll(":skill_objective_id", skillId+"");
		System.err.println(sql);
		DBUTILS db = new  DBUTILS();
		List<HashMap<String, Object>> contentRelatedToSkill = db.executeQuery(sql);
		if(entityType.equalsIgnoreCase("User"))
		{
			int studentId = entityId;
			mapContent(contentRelatedToSkill, studentId,adminId);
		}
		else if(entityType.equalsIgnoreCase("group"))
		{
			CustomReport report = repUtils.getReport(16); 				
			sql = report.getSql();
			sql = sql.replaceAll(":batch_group_id", entityId+"");				
			System.err.println(sql);
			List<HashMap<String, Object>> result = db.executeQuery(sql);
			for (HashMap<String, Object> studnetRow : result) {
				int studentId = (int)studnetRow.get("student_id");
				mapContent(contentRelatedToSkill, studentId,adminId);
			}
			
			handleBatchCreation(contentRelatedToSkill,entityType, entityId);
		}
		else if(entityType.equalsIgnoreCase("role"))
		{
			CustomReport report = repUtils.getReport(16); 				
			sql = report.getSql();
			sql = sql.replaceAll(":batch_group_id", entityId+"");				
			System.err.println(sql);
			List<HashMap<String, Object>> result = db.executeQuery(sql);
			for (HashMap<String, Object> studnetRow : result) {
				int studentId = (int)studnetRow.get("student_id");
				mapContent(contentRelatedToSkill, studentId,adminId);
			}
			handleBatchCreation(contentRelatedToSkill,entityType, entityId);
		}
	}

	private void handleBatchCreation(List<HashMap<String, Object>> contentRelatedToSkill, String entityType, int entityId) {
		CustomReportUtils repUtils = new CustomReportUtils();
		DBUTILS util = new DBUTILS();
		if(entityType.equalsIgnoreCase("role"))
		{
			ArrayList<Integer> coursesTraversed = new ArrayList<>();
			BatchGroup role = new BatchGroupDAO().findById(entityId);
			String findCoursesInRoles ="select distinct course_id from batch where batch_group_id="+entityId;
			List<HashMap<String, Object>> coursesAvailableInRole = util.executeQuery(findCoursesInRoles);  
			ArrayList<Integer>courseIdAvailabe = new ArrayList<>();
			for(HashMap<String, Object> course : coursesAvailableInRole)
			{
				int cId = (int)course.get("course_id");
				if(!courseIdAvailabe.contains(cId))
				{
					courseIdAvailabe.add(cId);
				}
			}
			
			for(HashMap<String, Object> content : contentRelatedToSkill)
			{
				int courseId = (int)content.get("course_id");
				
				if(!courseIdAvailabe.contains(courseId) && !coursesTraversed.contains(courseId))
				{
					coursesTraversed.add(courseId);
					//then create batch in role 
					
					Course course = new CourseDAO().findById(courseId);
					CustomReport rep2 = repUtils.getReport(18);
					String insertIntoBatch=rep2.getSql();
					insertIntoBatch = insertIntoBatch.replaceAll(":batch_name", role.getName()+" - "+course.getCourseName().replaceAll("'",""));
					insertIntoBatch = insertIntoBatch.replaceAll(":bg_id", entityId+"");
					insertIntoBatch = insertIntoBatch.replaceAll(":course_id", courseId+"");
					int year = Calendar.getInstance().get(Calendar.YEAR);
					insertIntoBatch = insertIntoBatch.replaceAll(":year", year+"");
					util.executeUpdate(insertIntoBatch);
					
					//lets check for section under this role
					CustomReport childRep= repUtils.getReport(19);
					String getChildGroup=childRep.getSql();
					getChildGroup = getChildGroup.replaceAll(":parent_group_id", entityId+"");
					List<HashMap<String, Object>> childGroups = util.executeQuery(getChildGroup);
					for(HashMap<String, Object> childGroupRow : childGroups)
					{
						int childbgId = (int)childGroupRow.get("id");
						String childBGName = (String)childGroupRow.get("name").toString().replaceAll("'","");
						CustomReport dd = repUtils.getReport(20);
						String qq = dd.getSql().replaceAll(":course_id", courseId+"").replaceAll(":batch_group_id", childbgId+"");
						if((int)util.executeQuery(qq).get(0).get("count") == 0)
						{
							//create batch for child group
							CustomReport rep3 = repUtils.getReport(18);
							String insertIntoChildBatch=rep3.getSql();
							insertIntoChildBatch = insertIntoChildBatch.replaceAll(":batch_name", childBGName+" - "+course.getCourseName().replaceAll("'",""));
							insertIntoChildBatch = insertIntoChildBatch.replaceAll(":bg_id", childbgId+"");
							insertIntoChildBatch = insertIntoChildBatch.replaceAll(":course_id", courseId+"");							
							insertIntoChildBatch = insertIntoChildBatch.replaceAll(":year", year+"");
							util.executeUpdate(insertIntoChildBatch);
						}
						
					}
					
				}
				
			}
		}
		else if(entityType.equalsIgnoreCase("group"))
		{
			ArrayList<Integer> coursesTraversed = new ArrayList<>();			
			//create batch in only group
			BatchGroup section = new BatchGroupDAO().findById(entityId);
			
			String findCoursesInRoles ="select distinct course_id from batch where batch_group_id="+entityId;
			List<HashMap<String, Object>> coursesAvailableInRole = util.executeQuery(findCoursesInRoles);  
			ArrayList<Integer>courseIdAvailabe = new ArrayList<>();
			for(HashMap<String, Object> course : coursesAvailableInRole)
			{
				int cId = (int)course.get("course_id");
				if(!courseIdAvailabe.contains(cId))
				{
					courseIdAvailabe.add(cId);
				}
			}
			
			for(HashMap<String, Object> content : contentRelatedToSkill)
			{
				int courseId = (int)content.get("course_id");
				if(!courseIdAvailabe.contains(courseId) && !coursesTraversed.contains(courseId))
				{				
					coursesTraversed.add(courseId);
					//add batch in this section					
					Course course = new CourseDAO().findById(courseId);
					CustomReport rep2 = repUtils.getReport(18);
					String insertIntoBatch=rep2.getSql();
					insertIntoBatch = insertIntoBatch.replaceAll(":batch_name", section.getName()+" - "+course.getCourseName().replaceAll("'",""));
					insertIntoBatch = insertIntoBatch.replaceAll(":bg_id", entityId+"");
					insertIntoBatch = insertIntoBatch.replaceAll(":course_id", courseId+"");
					int year = Calendar.getInstance().get(Calendar.YEAR);
					insertIntoBatch = insertIntoBatch.replaceAll(":year", year+"");
					util.executeUpdate(insertIntoBatch);
				}
			}	
				
		}
		
	}

	private void mapContent(List<HashMap<String, Object>> contentRelatedToSkill, int studentId, int adminId) {
		StudentPlayListServicesAdmin playListService = new StudentPlayListServicesAdmin();
		TaskServices taskService = new TaskServices();
		IstarNotificationServices notificationService = new IstarNotificationServices();
		AndroidNoticeDelegator noticeDelegator = new AndroidNoticeDelegator();
		for(HashMap<String, Object> content : contentRelatedToSkill)
		{
			int courseId =(int)content.get("course_id");
			int moduleId=(int)content.get("module_id");
			int sessionId =(int)content.get("cmsession_id");
			int itemId=(int)content.get("lesson_id");
			int lessonId = (int)content.get("lesson_id");
			String courseTitle = (String)content.get("course_name");
			String lessonTitle = (String)content.get("lesson_title");
			String lessonType="LESSON";
			if(content.get("lesson_type")!=null && content.get("lesson_type").toString().equalsIgnoreCase("ASSESSMENT"))
			{
				lessonType=(String)content.get("lesson_type");
				Lesson lesson = new LessonDAO().findById(lessonId);
				itemId = Integer.parseInt(lesson.getLessonXml());
			}
			String lessonDescription = content.get("lesson_desc")!=null ? content.get("lesson_desc").toString().trim():"No Description Available";
			String taskTitle = lessonTitle;
			String taskDescription = "A lesson with title "+lessonTitle+" of course "+courseTitle+" has been added to task list.";
			int tasId = taskService.createTodaysTask(taskTitle, taskDescription, adminId+"", studentId+"", itemId+"", lessonType);
			playListService.createStudentPlayList(studentId, courseId, moduleId, sessionId, lessonId, tasId);			
		}
		
		if(contentRelatedToSkill.size()>0)
		{
			HashMap<String, Object> content = contentRelatedToSkill.get(0);
			int courseId =(int)content.get("course_id");
			int moduleId=(int)content.get("module_id");
			int sessionId =(int)content.get("cmsession_id");
			int lessonId=(int)content.get("lesson_id");
			String courseTitle = (String)content.get("course_name");
			String lessonTitle = (String)content.get("lesson_title");
			String lessonDescription = content.get("lesson_desc")!=null ? content.get("lesson_desc").toString().trim():"No Description Available";
			String taskTitle = lessonTitle;
			String taskDescription = "Lessons added to playlist of course "+courseTitle+".";
			
			
			String notificationTitle = "Lessons added to playlist of course "+courseTitle+".";
			String notificationDescription =  lessonDescription;
									
			String groupNotificationCode = UUID.randomUUID().toString();						
			IstarNotification notice = notificationService.createIstarNotification(adminId, studentId, notificationTitle.trim().replace("'", ""), notificationDescription.trim().replace("'", ""), "UNREAD", null, NotificationType.CONTENT_ASSIGNED, true, null, groupNotificationCode);
			HashMap<String, Object> item = new HashMap<String, Object>();			
			
			item.put("courseId", courseId);						
			noticeDelegator.sendNotificationToUser(notice.getId(),studentId+"", notificationTitle.trim().replace("'", ""), NotificationType.CONTENT_ASSIGNED, item);
		}
		

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
