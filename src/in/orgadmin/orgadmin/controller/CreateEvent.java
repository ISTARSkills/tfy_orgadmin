package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.services.EventServiceNew;

/**
 * Servlet implementation class CreateEvent
 */
@WebServlet("/create_event")
public class CreateEvent extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateEvent() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		printAttrs(request);
		DBUTILS util = new DBUTILS();
		int batch_iddd = Integer.parseInt(request.getParameter("batch_id"));
		int hours = 0;
		int min = 0;
		if (request.getParameter("duration_hour") != "") {
			hours = Integer.parseInt(request.getParameter("duration_hour"));
		}
		if (request.getParameter("duration_min") != "") {
			min = Integer.parseInt(request.getParameter("duration_min"));
		}
		if (request.getParameterMap().containsKey("allow_pointer_update")
				&& request.getParameter("allow_pointer_update").equalsIgnoreCase("on")
				&& request.getParameter("lesson_id") != null) {
			int lesson_id = Integer.parseInt(request.getParameter("lesson_id"));
			String sql = "select lesson.id as lesson_id, cmsession.id as session_id,  module.id as module_id, course.id as course_id, presentaion.id as ppt_id, slide.id as slide_id  from lesson, cmsession, module, course, presentaion, slide where lesson.session_id = cmsession.id and cmsession.module_id = module.id and course.id = module.course_id and presentaion.lesson_id = lesson.id and slide.presentation_id = presentaion.id and lesson.id = "
					+ lesson_id + " order by slide.order_id limit 1;";
			
			List<HashMap<String, Object>> res = util.executeQuery(sql);
			if (res.size() > 0) {
				for (HashMap<String, Object> row : res) {
					int session_id = (int) row.get("session_id");
					int module_id = (int) row.get("module_id");
					int course_id = (int) row.get("course_id");
					int ppt_id = (int) row.get("ppt_id");
					int slide_id = (int) row.get("slide_id");

					String insert_sql = "INSERT INTO event_session_log ( 	trainer_id, 	event_id, 	course_id, 	cmsession_id, 	lesson_id, 	ppt_id, 	slide_id, 	created_at, 	updated_at, 	batch_id, 	module_id, 	assessment_id, 	lesson_type, 	url ) VALUES 	( 		 		'174', 		'ed6dda46-6fdf-49e5-9356-665d8499bf72', 		'"
							+ course_id + "', 		'" + session_id + "', 		'" + lesson_id + "', 		'" + ppt_id
							+ "', 		'" + slide_id
							+ "', 		'2016-07-30 21:01:11', 		'2016-07-30 21:01:11', 		'" + batch_iddd
							+ "', 		'" + module_id
							+ "', 		'0', 		'PPT', 		'http://192.168.100.124/play_iframe_trainer.jsp?course_id=5&cmsession_id=89&module_id=49&event_id=ed6dda46-6fdf-49e5-9356-665d8499bf72&last_slide_id=6367&current_slide_id=5778&lesson_id=524!#5778' 	);";
					System.out.println(insert_sql);
					util.executeUpdate(insert_sql);
				}
			}
		}

		
			for (String dateStr : request.getParameter("event_date").split(",")) {
				try {
					DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					DateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
					DateFormat dateformatfrom = new SimpleDateFormat("MM/dd/yyyy");
					System.out.println("00" + dateStr);
					Date date = formatter.parse(dateformatto.format(dateformatfrom.parse(dateStr)) + " "
							+ request.getParameter("event_time"));
					int trainer_id = Integer.parseInt(request.getParameter("trainer_id"));
					int classroom_id = Integer.parseInt(request.getParameter("class_id"));
					int batch_id = Integer.parseInt(request.getParameter("batch_id"));
					String sql_t_b = "SELECT count(*) as count FROM trainer_batch WHERE trainer_id="+trainer_id+" AND batch_id="+batch_id+"";
					
					List<HashMap<String, Object>> tb = util.executeQuery(sql_t_b);
					if (tb.size() > 0 ) {
						for(HashMap<String, Object> row : tb)
                    	{
							BigInteger count= (BigInteger)row.get("count");
							
							
                    	if(count.intValue() == 0){
						String sql_I_t_b = "INSERT INTO trainer_batch (id, batch_id, trainer_id) VALUES ((SELECT max(id) +1 FROM trainer_batch ), "+batch_id+", "+trainer_id+");";
						System.out.println("----------------->"+sql_I_t_b);
						util.executeUpdate(sql_I_t_b);
						}
                    	}
						
					}
					if (request.getParameterMap().containsKey("event_id")) {
						new EventServiceNew().updateEvent(request.getParameter("event_id"), formatter1.format(date),
								trainer_id, -1, classroom_id, hours, min);
					} else {
						new EventServiceNew().createEvent(trainer_id, formatter1.format(date), -1, classroom_id,
								batch_id, hours, min);
					}

				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		

		response.sendRedirect("/orgadmin/events/create_events.jsp?batch_id=" + batch_iddd);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
