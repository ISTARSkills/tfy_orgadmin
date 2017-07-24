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

import tfy.admin.services.StudentSkillMapService;

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
				sb.append("<option value='ALL_GROUP_OF_ORG_"+entityId+"'>Select All</option>");
				for(HashMap<String, Object> row: groups)
				{
					sb.append("<option value="+row.get("id")+">"+row.get("name")+" ("+row.get("type")+")</option>");
				}			
			}
			if(entityType.equalsIgnoreCase("ORG_STUDENTS"))
			{
				//return all sections/ roles
				String sql = "select distinct istar_user. ID, 	istar_user.email from istar_user, user_org_mapping where istar_user.id = user_org_mapping.user_id and user_org_mapping.organization_id = "+entityId;
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				for(HashMap<String, Object> row: groups)
				{
					sb.append(
							" <li><label class='checkbox-inline'> <input type='checkbox' class='student_checkbox_holder'  value='"
									+ row.get("id") + "' id='inlineCheckbox_" + row.get("id") + "'>"
									+ row.get("email") + "</label></li>");
				}			
			}
			else if(entityType.equalsIgnoreCase("GROUP"))
			{
				//return all students
				String sql="";
				if(entityId.contains("ALL_GROUP_OF_ORG_"))
				{
					entityId = entityId.replace("ALL_GROUP_OF_ORG_", "");
					sql = "select distinct istar_user. ID, 	istar_user.email from istar_user, user_org_mapping, user_role where istar_user.id = user_org_mapping.user_id and user_org_mapping.user_id = user_role.user_id and  user_role.role_id in (SELECT 		ID 	FROM 		ROLE 	WHERE 		role_name not IN ('PRESENTOR')) and user_org_mapping.organization_id = "+entityId+" order by email";
					//System.out.println("Get NotificationData 54>>sql"+sql);
				}
				else
				{
					 sql = "SELECT 	istar_user. ID, 	istar_user.email FROM 	batch_students, 	istar_user, 	user_role WHERE 	batch_students.batch_group_id = "+entityId+" AND batch_students.student_id = istar_user. ID AND istar_user. ID = user_role.user_id AND user_role.role_id IN ( 	SELECT 		ID 	FROM 		ROLE 	WHERE 		role_name not IN ('PRESENTOR') );";
					//System.out.println("Get NotificationData 54>>sql"+sql);
				}	
				
				
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
				//entity id is groupID in case select all is not selected
				String sql="";
				if(entityId.contains("ALL_GROUP_OF_ORG_"))
				{
					entityId = entityId.replace("ALL_GROUP_OF_ORG_", "");
					sql ="SELECT distinct 	course. ID, 	course_name FROM 	batch_group, 	batch, 	course WHERE  batch_group. ID = batch.batch_group_id AND batch.course_id = course. ID and batch_group.college_id = "+entityId;
				}
				else
				{
					 sql="select course.id , course_name from batch_group, batch, course where batch_group.id = "+entityId+" and batch_group.id = batch.batch_group_id and batch.course_id = course.id ";

				}	
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
				String sql= "select id, assessmenttitle from assessment where is_published='t'";
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select Assessment</option>");
				StudentSkillMapService serv= new StudentSkillMapService();
				for(HashMap<String, Object> row: groups)
				{
					int assessmentId = (int)row.get("id");
					
					Double maxPoints = serv.getMaxPointsOfAssessment(assessmentId)!=null?serv.getMaxPointsOfAssessment(assessmentId) : 0d ;
					if(maxPoints!=null &&(double)maxPoints!=0)
					{
					sb.append("<option value="+row.get("id")+">"+row.get("assessmenttitle")+"(Max Points: "+maxPoints +" )</option>");
					}
				}
			}	
			else if(entityType.equalsIgnoreCase("COURSE"))
			{
				//return cmsessions
				String sql ="select distinct cmsession.id , cmsession.title from module_course, cmsession_module, cmsession where module_course.course_id = "+entityId+" and module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = cmsession.id ";		
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select CMSession</option>");
				StudentSkillMapService serv= new StudentSkillMapService();

				for(HashMap<String, Object> row: groups)
				{
					
					sb.append("<option value="+row.get("id")+">"+row.get("title")+"</option>");
				}
			}
			else if(entityType.equalsIgnoreCase("ASSESSMENT_COURSE"))
			{
				//assessment from course
				String sql ="select distinct id, assessmenttitle from assessment where is_published='t' and course_id="+entityId;
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				StudentSkillMapService serv= new StudentSkillMapService();
				sb.append("<option value='null'>Select Assessment</option>");
				
				
				for(HashMap<String, Object> row: groups)
				{
						int assessmentId = (int)row.get("id");
					
					Double maxPoints = serv.getMaxPointsOfAssessment(assessmentId)!=null?serv.getMaxPointsOfAssessment(assessmentId) : 0d ;
					if(maxPoints!=null && (double)maxPoints!=0)
					{
						sb.append("<option value="+row.get("id")+">"+row.get("assessmenttitle")+"(Max Points: "+maxPoints+" )</option>");
					}
				}
			}			
			else if(entityType.equalsIgnoreCase("CMSESSION"))
			{
				//return lessons
				String sql="select distinct lesson.id , lesson.title from lesson_cmsession, lesson where lesson.is_published='t' and lesson.id = lesson_cmsession.lesson_id and lesson_cmsession.cmsession_id = "+entityId;
				//System.out.println("GetNotification 98"+sql);
				List<HashMap<String, Object>> groups = util.executeQuery(sql);
				sb.append("<option value='null'>Select Lesson</option>");
				StudentSkillMapService serv= new StudentSkillMapService();
				for(HashMap<String, Object> row: groups)
				{
					int lessonId = (int)row.get("id");
					Double maxPoints = serv.getMaxPointsOfLesson(lessonId)!=null?serv.getMaxPointsOfLesson(lessonId) : 0d ;
					//if(maxPoints!=null && (double)maxPoints!=0)
					//{
						sb.append("<option value="+row.get("id")+">"+row.get("title")+" (Max Points: "+maxPoints+")</option>");
					//}	
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
