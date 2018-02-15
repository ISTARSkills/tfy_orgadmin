package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
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
 * Servlet implementation class CreateNotofication
 */
@WebServlet("/create_notification")
public class CreateNotification extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public CreateNotification() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	printparams(request);
DBUTILS util = new DBUTILS(); 	
String notificationType =  request.getParameter("notification_type");
TaskServices taskService = new TaskServices();
IstarNotificationServices notificationService = new IstarNotificationServices();
StudentPlayListServicesAdmin playListService = new StudentPlayListServicesAdmin();
AndroidNoticeDelegator noticeDelegator = new AndroidNoticeDelegator();
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
		String module_id = lessonData.get(0).get("module_id").toString();
		String notificationTitle = "A lesson with title <b>"+lessonTitle+"</b> of course <b>"+courseTitle+"</b> has been added to task list.";
		String notificationDescription =  notificationTitle;
		String taskTitle = lessonData.get(0).get("lesson_title").toString();
		String taskDescription = lessonData.get(0).get("description")!=null ? lessonData.get(0).get("description").toString(): "NA";
		if(request.getParameterMap().containsKey("title") && !request.getParameter("title").toString().isEmpty())
		{
			notificationTitle =  request.getParameter("title");
		}
		if(request.getParameterMap().containsKey("comment") && !request.getParameter("comment").toString().isEmpty())
		{
			notificationDescription  = request.getParameter("comment");
		}
		 for(String studentId: studentIds.split(","))
			{
			 int itemId = Integer.parseInt(lessonId);
			 String itemType = "LESSON";
			 Lesson lesson = new LessonDAO().findById(itemId);
			 if(lesson.getType().equalsIgnoreCase("ASSESSMENT"))
			 {
				 itemId = Integer.parseInt(lesson.getLessonXml());
				 itemType ="ASSESSMENT";
			 }
			 int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""), taskDescription.trim().replace("'", ""), adminId, studentId, itemId+"", itemType);
			 IstarNotification istarNotification = notificationService.createIstarNotification(Integer.parseInt(adminId), Integer.parseInt(studentId), notificationTitle.trim().replace("'", ""), notificationDescription.trim().replace("'", ""), "UNREAD", null, NotificationType.LESSON, true, taskId, groupNotificationCode);
			 playListService.createStudentPlayList(Integer.parseInt(studentId),Integer.parseInt(courseId), Integer.parseInt(module_id), Integer.parseInt(cmsession_id),  Integer.parseInt(lessonId),taskId);	
			  
			  HashMap<String, Object> item = new HashMap<String, Object>();

				item.put("lessonId", Integer.parseInt(lessonId));
				item.put("cmsessionId", Integer.parseInt(cmsession_id));
				item.put("moduleId", Integer.parseInt(module_id));
				item.put("courseId", Integer.parseInt(courseId));
				item.put("taskId", taskId);
				noticeDelegator.sendNotificationToUser(istarNotification.getId(), studentId, notificationTitle.trim().replace("'", ""), NotificationType.LESSON, item);
			}
		
	}	
	
	
}
else if(notificationType.equalsIgnoreCase(NotificationType.ASSESSMENT))
{
	String assessmentID = request.getParameter("assessment_id");
	Assessment assessment = new AssessmentDAO().findById(Integer.parseInt(assessmentID));
	Course course = new CourseDAO().findById(assessment.getCourse());
	String notificationTitle = "An assessment with title <b>"+assessment.getAssessmenttitle()+"</b> of course <b>"+course.getCourseName()+"</b> has been added to task list.";
	String notificationDescription =  notificationTitle;
	String taskTitle = assessment.getAssessmenttitle();
	String taskDescription = notificationDescription;
	String studentIds = request.getParameter("studentlist_id");
	String adminId = request.getParameter("admin_id");
	String groupNotificationCode = UUID.randomUUID().toString();
	if(request.getParameterMap().containsKey("title") && !request.getParameter("title").toString().isEmpty())
	{
		notificationTitle =  request.getParameter("title");
	}
	if(request.getParameterMap().containsKey("comment") && !request.getParameter("comment").toString().isEmpty())
	{
		notificationDescription  = request.getParameter("comment");
	}
	for(String studentId: studentIds.split(","))
	{	
		int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""), taskDescription.trim().replace("'", ""), adminId, studentId, assessmentID, "ASSESSMENT");
		IstarNotification istarNotification = notificationService.createIstarNotification(Integer.parseInt(adminId), Integer.parseInt(studentId), notificationTitle, notificationDescription, "UNREAD", null, NotificationType.ASSESSMENT, true, taskId, groupNotificationCode);
		
		HashMap<String, Object> item = new HashMap<String, Object>();
		
		item.put("assessmentId", Integer.parseInt(assessmentID));
		item.put("courseId", course.getId());
		item.put("taskId", taskId);
		
		noticeDelegator.sendNotificationToUser(istarNotification.getId(), studentId, notificationTitle.trim().replace("'", ""), NotificationType.ASSESSMENT, item);		
		//noticeDelegator.sendAndroidNotification(NotificationType.ASSESSMENT, students, notificationTitle.trim().replace("'", ""),assessmentID);
	}
/*	ArrayList<String> students = new ArrayList<>();
	students = new ArrayList<String>(Arrays.asList(studentIds.split(",")));
	if(students.size()>0)
	{	
		HashMap<String, Object> item = new HashMap<String, Object>();
		
		item.put("assessmentId", Integer.parseInt(assessmentID));
		item.put("courseId", course.getId());
		item.put("taskId", taskId);
		
		noticeDelegator.sendNotificationToGroup(students, notificationTitle.trim().replace("'", ""), NotificationType.ASSESSMENT, item);		
		//noticeDelegator.sendAndroidNotification(NotificationType.ASSESSMENT, students, notificationTitle.trim().replace("'", ""),assessmentID);
	}	*/
	
}	
else if(notificationType.equalsIgnoreCase(NotificationType.COMPLEX_UPDATE))
{
	String adminId = request.getParameter("admin_id");
	String studentIds = request.getParameter("studentlist_id");
	ArrayList<String> students = new ArrayList<>();
	students = new ArrayList<String>(Arrays.asList(studentIds.split(",")));
	if(students.size()>0)
	{	
		HashMap<String, Object> item = new HashMap<String, Object>();
		
		noticeDelegator.sendNotificationToGroup(students, "NO_MESSAGE", NotificationType.COMPLEX_UPDATE, item);	
		//noticeDelegator.sendAndroidNotification(NotificationType.COMPLEX_UPDATE, students, "NO_MESSAGE","NO_ID");
	}	
}		
else if(notificationType.equalsIgnoreCase(NotificationType.MESSAGE))
{
	String title = request.getParameter("title");
	String comments = request.getParameter("comment");
	String studentIds = request.getParameter("studentlist_id");
	String adminId = request.getParameter("admin_id");
	String groupNotificationCode = UUID.randomUUID().toString();
	for(String studentId: studentIds.split(","))
	{
		HashMap<String, Object> item = new HashMap<String, Object>();
		IstarNotification notice = notificationService.createIstarNotification(Integer.parseInt(adminId), Integer.parseInt(studentId), title.trim().replace("'", ""), comments.trim().replace("'", ""), "UNREAD", null, NotificationType.GENERIC, true, null, groupNotificationCode);
		noticeDelegator.sendNotificationToUser(notice.getId(), studentId, title, NotificationType.GENERIC, item);
	}
		
}		
		
		

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
