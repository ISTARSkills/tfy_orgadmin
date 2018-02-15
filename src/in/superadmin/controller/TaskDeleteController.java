package in.superadmin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.DBUTILS;

@WebServlet("/task_delete")
public class TaskDeleteController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public TaskDeleteController() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		DBUTILS db = new DBUTILS();
		String task_id = "";
		String student_playlist_id = "";
		String start_date = "";
		String end_date = "";
		String course = "";
		String entity_type = "";
		String entity_id = "";
		//
		if (request.getParameter("key") != null && request.getParameter("key").equalsIgnoreCase("task_delete")) {

			task_id = request.getParameter("task_id");
			student_playlist_id = request.getParameter("student_playlist_id");

			String sql = "DELETE FROM task WHERE id ='" + task_id + "'";
			ViksitLogger.logMSG(this.getClass().getName(),sql);
			db.executeUpdate(sql);

			sql = "DELETE FROM student_playlist WHERE id ='" + student_playlist_id + "'";
			ViksitLogger.logMSG(this.getClass().getName(),sql);
			db.executeUpdate(sql);

		} else if (request.getParameter("key") != null
				&& request.getParameter("key").equalsIgnoreCase("auto_scheduler_task_delete")) {

			start_date = request.getParameter("start_date");
			end_date = request.getParameter("end_date");
			course = request.getParameter("course");
			entity_type = request.getParameter("entity_type");
			entity_id = request.getParameter("entity_id");

			if (entity_type.equalsIgnoreCase("USER")) {

				String sql = "DELETE FROM student_playlist WHERE task_id in (  SELECT 	id FROM 	task WHERE 	task.item_type IN ( 			'LESSON', 			'ASSESSMENT', 			'CUSTOM_TASK' 		) AND actor = '"
						+ entity_id + "' AND start_date = '" + start_date + "' AND end_date = '" + end_date + "' )";
				ViksitLogger.logMSG(this.getClass().getName(),sql);
				db.executeUpdate(sql);
				sql = "DELETE FROM 	task WHERE 	task.item_type IN ( 			'LESSON', 			'ASSESSMENT', 			'CUSTOM_TASK' 		) AND actor = '"
						+ entity_id + "' AND start_date = '" + start_date + "' AND end_date = '" + end_date + "'";
				ViksitLogger.logMSG(this.getClass().getName(),sql);
				db.executeUpdate(sql);
				sql = "DELETE FROM auto_scheduler_data WHERE entity_id ='" + entity_id + "' AND entity_type = '"
						+ entity_type + "' AND course_id ='" + course + "' AND start_date = '" + start_date
						+ "' AND end_date = '" + end_date + "'";
				ViksitLogger.logMSG(this.getClass().getName(),sql);
				db.executeUpdate(sql);

			} else if (entity_type.equalsIgnoreCase("SECTION")) {

				String sqql = "SELECT student_id FROM batch_students WHERE batch_students.batch_group_id ='" + entity_id
						+ "'";

				List<HashMap<String, Object>> data = db.executeQuery(sqql);
				if (data.size() > 0) {
					for (HashMap<String, Object> row : data) {

						String sql = "DELETE FROM student_playlist WHERE task_id in (  SELECT 	id FROM 	task WHERE 	task.item_type IN ( 			'LESSON', 			'ASSESSMENT', 			'CUSTOM_TASK' 		) AND actor = '"
								+ row.get("student_id") + "' AND start_date = '" + start_date + "' AND end_date = '"
								+ end_date + "' )";
						ViksitLogger.logMSG(this.getClass().getName(),sql);
						db.executeUpdate(sql);

						sql = "DELETE FROM task_log WHERE task in (SELECT id FROM 	task WHERE 	task.item_type IN ( 			'LESSON', 			'ASSESSMENT', 			'CUSTOM_TASK' 		) AND actor = '"
								+ row.get("student_id") + "' AND start_date = '" + start_date + "' AND end_date = '"
								+ end_date + "') ";
						ViksitLogger.logMSG(this.getClass().getName(),sql);
						db.executeUpdate(sql);

						sql = "DELETE FROM 	task WHERE 	task.item_type IN ( 			'LESSON', 			'ASSESSMENT', 			'CUSTOM_TASK' 		) AND actor = '"
								+ row.get("student_id") + "' AND start_date = '" + start_date + "' AND end_date = '"
								+ end_date + "'";
						ViksitLogger.logMSG(this.getClass().getName(),sql);
						db.executeUpdate(sql);

					}
					String sql = "DELETE FROM auto_scheduler_data WHERE entity_id ='" + entity_id
							+ "' AND entity_type = '" + entity_type + "' AND course_id ='" + course
							+ "' AND start_date = '" + start_date + "' AND end_date = '" + end_date + "'";
					ViksitLogger.logMSG(this.getClass().getName(),sql);
					db.executeUpdate(sql);

				}

				String sql = "DELETE FROM student_playlist WHERE task_id in (  SELECT 	id FROM 	task WHERE 	item_type = 'LESSON' AND actor = '"
						+ entity_id + "' AND start_date = '" + start_date + "' AND end_date = '" + end_date + "' )";
				db.executeUpdate(sql);
				sql = "DELETE FROM 	task WHERE 	item_type = 'LESSON' AND actor = '" + entity_id + "' AND start_date = '"
						+ start_date + "' AND end_date = '" + end_date + "'";
				db.executeUpdate(sql);
				sql = "DELETE FROM auto_scheduler_data WHERE entity_id ='" + entity_id + "' AND entity_type = '"
						+ entity_type + "' AND course_id ='" + course + "' AND start_date = '" + start_date
						+ "' AND end_date = '" + end_date + "'";
				db.executeUpdate(sql);

			}

		} else if (request.getParameter("key") != null
				&& request.getParameter("key").equalsIgnoreCase("view_attendance")) {

			StringBuffer stringBuffer = new StringBuffer();
			StringBuffer present = new StringBuffer();
			StringBuffer absent = new StringBuffer();

			int eventId = Integer.parseInt(request.getParameter("eventId"));
			String sql = "SELECT DISTINCT 	user_profile.first_name, 	attendance.status FROM 	attendance, 	user_profile WHERE 	attendance.user_id = user_profile.user_id AND attendance.event_id ="
					+ eventId;
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			
			stringBuffer.append("<div class='ibox-content'>"
					+ "<table class='table'>"
					+ "<thead><tr><th>User Name</th>" 
					+ " <th>Attendance</th>"
					+ "</tr></thead><tbody>");
			
			if (data.size() != 0) {

				
				for (HashMap<String, Object> row : data) {
					String style = "";
					if(row.get("status").toString().equalsIgnoreCase("ABSENT")) {
						style = "class='text-danger'";
					}else {
						
					}

					
						stringBuffer.append("<tr><td "+style+">"+row.get("first_name").toString()+"</td>");
						stringBuffer.append("<td "+style+">"+row.get("status").toString()+"</td></tr>");

				

					

				}

			} else {
				stringBuffer.append("<tr><td>No Data Found</td>");
				stringBuffer.append("<td><span class='text-muted'>No Data Found</span></td></tr>");
			}
			
			
			
			stringBuffer.append(" </tbody></table> </div>");

			ViksitLogger.logMSG(this.getClass().getName(),stringBuffer);
			response.getWriter().println(stringBuffer);

		}

		response.getWriter().append("");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
