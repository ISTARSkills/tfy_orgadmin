package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.DateUtils;

import com.istarindia.apps.dao.DBUTILS;

/**
 * Servlet implementation class ValidateEvent
 */
@WebServlet("/validate_event")
public class ValidateEvent extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ValidateEvent() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		//
		int duration_hour = 0;
		duration_hour = Integer.parseInt(request.getParameter("duration_hour"));
		int duration_min = 0;
		duration_min = Integer.parseInt(request.getParameter("duration_min"));
		String id__event_date_holder = request.getParameter("id__event_date_holder");
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		DateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat dateformatfrom = new SimpleDateFormat("MM/dd/yyyy");
		int classroom_id = Integer.parseInt(request.getParameter("id__class_id"));
		String hidden_batch_id = request.getParameter("hidden_batch_id");
		int trainer_id = Integer.parseInt(request.getParameter("id__trainer_id"));
		try {
			Date date = formatter.parse(dateformatto.format(dateformatfrom.parse(id__event_date_holder)) + " "
					+ request.getParameter("id__event_time"));
			System.out.println(date);
			Date upper_limit = DateUtils.addMinutes(date, duration_hour * 60 + duration_min);

			String class_and_time_available = "SELECT count(*) as countt FROM 	batch_schedule_event WHERE 	 eventdate  >= '"
					+ formatter1.format(date) + "' AND eventdate  <= '" + formatter1.format(upper_limit)
					+ "' and classroom_id = " + classroom_id + " ";

			String trainer_available = "SELECT count(*) as countt FROM 	batch_schedule_event WHERE 	actor_id = "
					+ trainer_id + " AND 	 eventdate >= '" + formatter1.format(date) + "' AND eventdate <= '"
					+ formatter1.format(upper_limit) + "' ";

			String batch_available = "SELECT count(*) as countt FROM 	batch_schedule_event WHERE 	 eventdate >= '"
					+ formatter1.format(date) + "' AND eventdate <= '" + formatter1.format(upper_limit)
					+ "' and batch_id =" + hidden_batch_id + " ";
			if (!request.getParameter("event_id").toString().equalsIgnoreCase("null")) {
				String event_id = request.getParameter("event_id");
				class_and_time_available = "SELECT count(*) as countt FROM 	batch_schedule_event WHERE 	 eventdate  >= '"
						+ formatter1.format(date) + "' AND eventdate  <= '" + formatter1.format(upper_limit)
						+ "' and classroom_id = " + classroom_id + " AND batch_schedule_event. ID != '" + event_id
						+ "' " + "and batch_schedule_event.event_name not like '%TESTING%' "
						+ "and batch_schedule_event.type='BATCH_SCHEDULE_EVENT_TRAINER'";

				trainer_available = "SELECT count(*) as countt FROM 	batch_schedule_event WHERE 	actor_id = "
						+ trainer_id + " AND 	 eventdate >= '" + formatter1.format(date) + "' AND eventdate <= '"
						+ formatter1.format(upper_limit) + "'  AND batch_schedule_event. ID != '" + event_id + "' "
						+ "and batch_schedule_event.event_name not like '%TESTING%' "
						+ "and batch_schedule_event.type='BATCH_SCHEDULE_EVENT_TRAINER'";

				batch_available = "SELECT count(*) as countt FROM 	batch_schedule_event WHERE 	 eventdate >= '"
						+ formatter1.format(date) + "' AND eventdate <= '" + formatter1.format(upper_limit)
						+ "' and batch_id =" + hidden_batch_id + " and   batch_schedule_event. ID != '" + event_id
						+ "' " + "and batch_schedule_event.event_name not like '%TESTING%' "
						+ "and batch_schedule_event.type='BATCH_SCHEDULE_EVENT_TRAINER'";
				System.out.println(class_and_time_available);
				System.out.println(trainer_available);
				System.out.println(batch_available);
			} else {
				System.out.println(class_and_time_available);
				System.out.println(trainer_available);
				System.out.println(batch_available);
			}

			PrintWriter writer = response.getWriter();
			try {
				if (((BigInteger) (new DBUTILS().executeQuery(class_and_time_available).get(0).get("countt")))
						.intValue() > 0) {
					writer.print("class_time_not_available");
				} else if (((BigInteger) (new DBUTILS().executeQuery(trainer_available).get(0).get("countt")))
						.intValue() > 0) {
					writer.print("trainer_not_available");
				} else if (((BigInteger) (new DBUTILS().executeQuery(batch_available).get(0).get("countt")))
						.intValue() > 0) {
					writer.print("batch_not_available");
				} else {
					writer.print("every_thing_fine");
				}
			} catch (Exception e) {
				writer.print("every_thing_fine");
			}
		} catch (ParseException e) {
		}

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
