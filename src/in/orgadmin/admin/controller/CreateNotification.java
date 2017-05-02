package in.orgadmin.admin.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.chat.services.NotificationService;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportUtils;
import in.talentify.core.utils.PublishDelegator;

/**
 * Servlet implementation class CreateNotofication
 */
@WebServlet("/create_notification")
public class CreateNotification extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CreateNotification() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
DBUTILS util = new DBUTILS(); 	
String notificationType =  request.getParameter("notification_type");
TaskServices taskService = new TaskServices();
IstarNotificationServices notificationService = new IstarNotificationServices();
if(notificationType.equalsIgnoreCase(NotificationType.LESSON))
{
	String courseId = request.getParameter("course_id");
	String groupId = request.getParameter("group_id");
	String cmsession_id = request.getParameter("cmsession_id");
	String lessonId = request.getParameter("lesson_id");
	String adminId = request.getParameter("admin_id");
	String studentIds = request.getParameter("studentlist_id");
	CustomReportUtils repUtils = new CustomReportUtils();
	CustomReport report = repUtils.getReport(21);
	String sql = report.getSql().replaceAll(":course_id", courseId).replaceAll(":lesson_id", lessonId);
	List<HashMap<String, Object>> lessonData = util.executeQuery(sql);
	String groupNotificationCode = UUID.randomUUID().toString();
	
	if(lessonData.size()>0)
	{
		String lessonTitle = lessonData.get(0).get("lesson_title").toString();
		String courseTitle = lessonData.get(0).get("course_name").toString();
		String notificationTitle = "A lesson with title "+lessonTitle+" of course "+courseTitle+" has been added to task list.";
		String notificationDescription =  lessonData.get(0).get("description")!=null ? lessonData.get(0).get("description").toString(): "NA";
		String taskTitle = lessonData.get(0).get("lesson_title").toString();
		String taskDescription = lessonData.get(0).get("description")!=null ? lessonData.get(0).get("description").toString(): "NA";
		
		 for(String studentId: studentIds.split(","))
			{
				//create Notification and Tasks for all students  
			 //Task task  = taskService.createTask(taskTitle, taskDescription, "SCHEDULED", null, "LESSON", null, Integer.parseInt(lessonId), Integer.parseInt(adminId), Integer.parseInt(studentId), null, null, null, null, null, null, null, true, false, false, new Timestamp(System.currentTimeMillis()), new Timestamp(System.currentTimeMillis()), null);
			 int taskId = taskService.createTodaysTask(taskTitle, taskDescription, studentId, studentId, lessonId, "LESSON");
			 notificationService.createIstarNotification(Integer.parseInt(adminId), Integer.parseInt(studentId), notificationTitle, notificationDescription, "UNREAD", null, NotificationType.LESSON, true, taskId, groupNotificationCode);
			 
			}
		
	}	
	
	
}
else if(notificationType.equalsIgnoreCase(NotificationType.ASSESSMENT))
{
	String assessmentID = request.getParameter("assessment_id");
	Assessment assessment = new AssessmentDAO().findById(Integer.parseInt(assessmentID));
	Course course = new CourseDAO().findById(assessment.getCourse());
	String notificationTitle = "An assessment with title "+assessment.getAssessmenttitle()+" of course "+course.getCourseName()+" has been added to task list.";
	String notificationDescription =  assessment.getDescription()!=null ? assessment.getDescription(): "NA";
	String taskTitle = assessment.getAssessmenttitle();
	String taskDescription = notificationDescription;
	String studentIds = request.getParameter("studentlist_id");
	String adminId = request.getParameter("admin_id");
	String groupNotificationCode = UUID.randomUUID().toString();
	for(String studentId: studentIds.split(","))
	{
		//create Notification and Tasks for all students  
	 //Task task  = taskService.createTask(taskTitle, taskDescription, "SCHEDULED", null, "ASSESSMENT", null, assessment.getId(), Integer.parseInt(adminId), Integer.parseInt(studentId), null, null, null, null, null, null, null, true, false, false, new Timestamp(System.currentTimeMillis()), new Timestamp(System.currentTimeMillis()), null);
	 int taskId = taskService.createTodaysTask(taskTitle, taskDescription, studentId, studentId, assessmentID, "ASSESSMENT");

	 notificationService.createIstarNotification(Integer.parseInt(adminId), Integer.parseInt(studentId), notificationTitle, notificationDescription, "UNREAD", null, NotificationType.LESSON, true, taskId, groupNotificationCode);
	 
	}
	
}	
else if(notificationType.equalsIgnoreCase(NotificationType.COMPLEX_UPDATE))
{
	
}		
else if(notificationType.equalsIgnoreCase(NotificationType.MESSAGE))
{
	
}		
		
		

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
