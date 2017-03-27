package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.service.EventService;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class CreateEditAssessment
 */
@WebServlet("/create_edit_assessment_event")
public class CreateEditAssessment extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateEditAssessment() {
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

		/*
		 * param_name -> date_10108 : param_value ->09/20/2016 param_name ->
		 * time_10108 : param_value -> param_name -> assessment_id[] :
		 * param_value ->10109 param_name -> date_10109 : param_value
		 * ->09/14/2016 param_name -> time_10109 : param_value ->14:20
		 * param_name -> date_10112 : param_value ->09/19/2016 param_name ->
		 * time_10112 : param_value ->22:15 param_name -> date_10113 :
		 * param_value -> param_name -> time_10113 : param_value -> param_name
		 * -> date_10114 : param_value ->09/27/2016 param_name -> time_10114 :
		 * param_value ->03:15
		 * 
		 */

		int batch_id = Integer.parseInt(request.getParameter("batch_id"));
	
	
		try {
			String[] assessment_id = request.getParameterValues("assessment_id");
			DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			DateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			System.out.println(assessment_id.length);
			for (String str : assessment_id) {
				if (request.getParameterMap().containsKey("date_" + str)
						&& request.getParameterMap().containsKey("time_" + str)) {
					Date date = formatter
							.parse(request.getParameter("date_" + str) + " " + request.getParameter("time_" + str));
					int ass_id = Integer.parseInt(str);
					new EventService().createAssessment(batch_id, ass_id, date);
				}
			}

		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		}
		response.sendRedirect("/orgadmin/batch/dashboard.jsp?batch_id=" + batch_id);
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
