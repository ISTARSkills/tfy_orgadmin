package in.talentify.core.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class GetNotificationData
 */
@WebServlet("/get_notification_data")
public class GetNotificationData extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetNotificationData() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String entityId = request.getParameter("entity_id");
		String entityType = request.getParameter("entity_type");
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		if(entityId!=null)
		{	
			if(entityType.equalsIgnoreCase("ORG"))
			{
				//return all sections/ roles
				String sql = "SELECT id,name, type FROM batch_group WHERE college_id = "+entityId;
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select Section / Roles</option>");
				for(HashMap<String, Object> row: groups)
				{
					sb.append("<option value="+row.get("id")+">"+row.get("name")+" ("+row.get("type")+")</option>");
				}			
			}
			else if(entityType.equalsIgnoreCase("GROUP"))
			{
				//return all students
				String sql = "select istar_user.id , istar_user.email from batch_students, istar_user, user_role where batch_students.batch_group_id = "+entityId+" and batch_students.student_id = istar_user.id and istar_user.id = user_role.user_id and user_role.role_id = (select id from role where role_name='STUDENT' limit 1);";
				System.out.println("Get NotificationData 54>>sql"+sql);
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				for(HashMap<String, Object> row: groups)
				{
					sb.append(
							" <li><label class='checkbox-inline'> <input type='checkbox' class='student_checkbox_holder'  value='"
									+ row.get("id") + "' id='inlineCheckbox_" + row.get("id") + "'>"
									+ row.get("email") + "</label></li>");
				}			
			}
			else if (entityType.equalsIgnoreCase("LESSON"))
			{
				//this is one of value of drop down "lesson", "assessment", "message"
				// return courses
				//entity id is groupID 
				String sql="select course.id , course_name from batch_group, batch, course where batch_group.id = "+entityId+" and batch_group.id = batch.batch_group_id and batch.course_id = course.id ";
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select Course</option>");
				for(HashMap<String, Object> row: groups)
				{
					sb.append("<option value="+row.get("id")+">"+row.get("course_name")+"</option>");
				}	
				
			}
			else if(entityType.equalsIgnoreCase("ASSESSMENT"))
			{
				//return assessments
				String sql= "select id, assessmenttitle from assessment";
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select Assessment</option>");
				for(HashMap<String, Object> row: groups)
				{
					sb.append("<option value="+row.get("id")+">"+row.get("assessmenttitle")+"</option>");
				}
			}	
			else if(entityType.equalsIgnoreCase("COURSE"))
			{
				//return cmsessions
				String sql ="select distinct cmsession.id , cmsession.title from module_course, cmsession_module, cmsession where module_course.course_id = "+entityId+" and module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = cmsession.id ";		
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select CMSession</option>");
				for(HashMap<String, Object> row: groups)
				{
					sb.append("<option value="+row.get("id")+">"+row.get("title")+"</option>");
				}
			}
			else if(entityType.equalsIgnoreCase("CMSESSION"))
			{
				//return lessons
				String sql="select distinct lesson.id , lesson.title from lesson_cmsession, lesson where lesson.id = lesson_cmsession.lesson_id and lesson_cmsession.cmsession_id = "+entityId;
				System.out.println("GetNotification 98"+sql);
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select Lesson</option>");
				for(HashMap<String, Object> row: groups)
				{
					sb.append("<option value="+row.get("id")+">"+row.get("title")+"</option>");
				}
			}
		}		
		response.getWriter().write(sb.toString());
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
