package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.utils.PublishDelegator;

/**
 * Servlet implementation class CreateNotofication
 */
@WebServlet("/get_notification")
public class CreateNotification extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CreateNotification() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		DBUTILS dbutils = new DBUTILS();
		System.out.println("get_notification");

		if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("sendNotification")) {

			int lessonID = 0;
			int collegeID = 0;
			int batchGroupID = 0;
			int courseID = 0;
			String studentlistID = null;
			String title = "UPDATE_COMPLEX_OBJECT";
			String comment = null;
			String hidden_id = "No_Session";
			String courseName = null;
			String lessonName = null;
			if (request.getParameterMap().containsKey("batchGroupID")) {
				batchGroupID = request.getParameter("batchGroupID") != ""
						? Integer.parseInt(request.getParameter("batchGroupID")) : 0;
			}

			if (request.getParameterMap().containsKey("courseID")) {
				courseID = request.getParameter("courseID") != "" ? Integer.parseInt(request.getParameter("courseID")): 0;
			}

			if (request.getParameterMap().containsKey("cmsessionID")) {
				lessonID = request.getParameter("lessonID") != ""
						? Integer.parseInt(request.getParameter("lessonID")) : 0;
			}

			if (request.getParameterMap().containsKey("collegeID")) {
				collegeID = request.getParameter("collegeID") != ""
						? Integer.parseInt(request.getParameter("collegeID")) : 0;
			}

			if (request.getParameterMap().containsKey("title")) {
				title = request.getParameter("title") != "" ? request.getParameter("title") : "UPDATE_COMPLEX_OBJECT";
			}

			if (request.getParameterMap().containsKey("comment")) {
				comment = request.getParameter("comment") != "" ? request.getParameter("comment") : "";
			}

			if (request.getParameterMap().containsKey("studentlistID")) {
				studentlistID = request.getParameter("studentlistID") != "" ? request.getParameter("studentlistID"): "";
			}
			
			ArrayList<String> studentIDs = new ArrayList<>();
			for (String str : studentlistID.split(",")) {
				if (!str.equalsIgnoreCase("")) {
					studentIDs.add(str);
				}
			}

			if (courseID != 0 && lessonID != 0) {

				hidden_id = courseID + ";" + lessonID;
                 
				Course course = new CourseDAO().findById(courseID);
				courseName = course.getCourseName();
				Lesson lesson = new LessonDAO().findById(lessonID);
				lessonName = lesson.getTitle();
			}
			
			new PublishDelegator().publishAfterCreatingNotification(studentIDs, title, comment, hidden_id,courseName,lessonName);
			
		

		}

		else if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("org")
				&& request.getParameter("orgId") != null) {

			int orgId = Integer.parseInt(request.getParameter("orgId"));
			
			String sql = "SELECT id,name FROM batch_group WHERE college_id in (SELECT id FROM organization where id = "
					+ orgId + " )";

			List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
			StringBuffer out = new StringBuffer();
			out.append("<option value='null'>Select BatchGroup</option>");
			for (HashMap<String, Object> item : data) {
				out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
			}
			out.append("");
			response.getWriter().print(out);
		}

		else if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("batchGroup")
				&& request.getParameter("batchGroup") != null) {

			int batchGroup = Integer.parseInt(request.getParameter("batchGroup"));
			String sql = "SELECT id , course_name FROM course WHERE id in (SELECT course_id FROM batch WHERE batch_group_id in (SELECT id FROM batch_group WHERE id = "
					+ batchGroup + "))";

			List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
			StringBuffer out = new StringBuffer();

			out.append(
					"<select data-placeholder='select Course' tabindex='4' data-course='course' id='course_holder'>");
			out.append("<option value=''>Select Course</option>");
			for (HashMap<String, Object> item : data) {
				out.append("<option value='" + item.get("id") + "'>" + item.get("course_name") + "</option>");
			}
			out.append("</select>");

			String sql1 = "SELECT id,email FROM istar_user WHERE id in (SELECT student_id FROM batch_students WHERE batch_group_id in (SELECT course_id FROM batch WHERE batch_group_id in (SELECT id FROM batch_group WHERE id = "
					+ batchGroup + ")) AND user_type = 'STUDENT')";
			List<HashMap<String, Object>> data1 = dbutils.executeQuery(sql1);
			out.append("<ul data-student='student_list' class='todo-list m-t small-list ui-sortable'>");
			for (HashMap<String, Object> item1 : data1) {
				out.append(
						" <li><label class='checkbox-inline'> <input type='checkbox' class='student_checkbox_holder'  value='"
								+ item1.get("id") + "' id='inlineCheckbox_" + item1.get("id") + "'>"
								+ item1.get("email") + "</label></li>");
			}
			out.append("</ul>");
			out.append("");
			response.getWriter().print(out);
		}

		else if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("course")
				&& request.getParameter("course") != null) {

			int course = Integer.parseInt(request.getParameter("course"));
			String sql = "SELECT DISTINCT 	cmsession. ID, 	cmsession.title FROM 	course, 	MODULE, 	module_course, 	cmsession, 	cmsession_module WHERE 	course. ID = module_course.course_id AND module_course.module_id = MODULE . ID AND MODULE . ID = cmsession_module.module_id AND cmsession_module.cmsession_id = cmsession. ID AND course. ID ="
					+ course + "";

			List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
			StringBuffer out = new StringBuffer();
			out.append("<option value=''>Select lesson</option>");
			for (HashMap<String, Object> item : data) {
				out.append("<option value='" + item.get("id") + "'>" + item.get("title") + "</option>");
			}
			out.append("");
			response.getWriter().print(out);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
