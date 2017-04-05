package in.orgadmin.admin.controller;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.orgadmin.admin.services.AssessmentSchedulerService;
import in.orgadmin.admin.services.EventSchedulerService;
import in.talentify.core.utils.UIUtils;

@WebServlet("/event_utility_controller")
public class EventUtilityController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public EventUtilityController() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String deleteEventid = null;
		int courseID;
		int batchGroupID;
		int orgID;
		String editEventId = null;
		String eventDateTime = null;

		if (request.getParameterMap().containsKey("type")
				&& request.getParameter("type").equalsIgnoreCase("userOrgfilter")) {
			UIUtils uiUtils = new UIUtils();
			int org = request.getParameter("college_id") != "" ?Integer.parseInt(request.getParameter("college_id")):-3;
			StringBuffer out = new StringBuffer();
		
			out.append("<div class='form-group' id='hide_group_holder'>");
			out.append("<h3 class='m-b-n-md'>Group</h3>");
			out.append("<hr class='m-b-xs'>");
			out.append("<div class='col-lg-12'>");
			out.append("<label class='font-noraml'>Select Groups the student will belong to:</label>");
			out.append("<div>");
			out.append("<select data-placeholder='group...'id='main_batch_group_holder' class='select2-dropdown' multiple tabindex='4'>");
			out.append(uiUtils.getBatchGroups(org, null));
			out.append("</select>");
			out.append("</div>");
			out.append("<input type='hidden' value='' name='batch_groups' />");
			out.append("</div>");
			out.append("</div>");
			
			response.getWriter().print(out);

		}

		if (request.getParameterMap().containsKey("program_tab_getcourse")
				&& !request.getParameter("program_tab_getcourse").equalsIgnoreCase("")) {

			orgID = Integer.parseInt(request.getParameter("program_tab_getcourse"));
			UIUtils uiUtils = new UIUtils();

			response.getWriter().print(uiUtils.getCourses(orgID));

		}

		// change event date from fullCalendar

		if (request.getParameterMap().containsKey("editEventId")
				&& !request.getParameter("editEventId").equalsIgnoreCase("")) {

			SimpleDateFormat formaterFrom = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
			DateFormat dateformatto = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat timeto = new SimpleDateFormat("HH:mm");
			EventSchedulerService ess = new EventSchedulerService();
			eventDateTime = request.getParameter("eventDateTime");
			editEventId = request.getParameter("editEventId");

			Date data = null;
			try {
				data = formaterFrom.parse(eventDateTime);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			String formattedDate = dateformatto.format(data);
			String formattedTime = timeto.format(data);

			ess.editEvent(editEventId, formattedDate, formattedTime);

		}

		// org id

		if (request.getParameterMap().containsKey("orgID") && !request.getParameter("orgID").equalsIgnoreCase("")) {

			orgID = request.getParameter("orgID") != "" ? Integer.parseInt(request.getParameter("orgID")) : 0;

			UIUtils ui = new UIUtils();

			response.getWriter().print(ui.getCourseEventCard(orgID));

		}
		// delete event
		if (request.getParameterMap().containsKey("deleteEventid")
				&& !request.getParameter("deleteEventid").equalsIgnoreCase("")) {

			deleteEventid = request.getParameter("deleteEventid") != "" ? request.getParameter("deleteEventid") : "";

			if (request.getParameterMap().containsKey("status")
					&& request.getParameter("status").equalsIgnoreCase("ASSESSMENT")) {
				int assessmentEventID = Integer.parseInt(request.getParameter("deleteEventid"));
				AssessmentSchedulerService asservice = new AssessmentSchedulerService();

				asservice.deleteAssessment(null, assessmentEventID);

			} else {

				EventSchedulerService ess = new EventSchedulerService();
				ess.deleteEvent(deleteEventid);
			}

			// response.getWriter().print();
		}
		//

		// delete assessment
		if (request.getParameterMap().containsKey("deleteAssessment")
				&& !request.getParameter("deleteAssessment").equalsIgnoreCase("")) {

			String assessmentData = request.getParameter("deleteAssessment");
			AssessmentSchedulerService asservice = new AssessmentSchedulerService();
			HashMap<String, String> innerData = new HashMap<>();

			for (String assessmentSplitData : assessmentData.split(",")) {

				String[] data = assessmentSplitData.split("_");
				innerData.put(data[0], data[1]);

			}

			asservice.deleteAssessment(innerData, -01);

			// response.getWriter().print();
		}
		//

		// course filter
		if (request.getParameterMap().containsKey("batchGroupID")
				&& !request.getParameter("batchGroupID").equalsIgnoreCase("")) {

			batchGroupID = request.getParameter("batchGroupID") != ""
					? Integer.parseInt(request.getParameter("batchGroupID")) : 0;

			EventSchedulerService ess = new EventSchedulerService();

			response.getWriter().print(ess.getBatch(batchGroupID));
		}
		//

		// batchGroup filter
		if (request.getParameterMap().containsKey("courseID")
				&& !request.getParameter("courseID").equalsIgnoreCase("")) {

			courseID = request.getParameter("courseID") != "" ? Integer.parseInt(request.getParameter("courseID")) : 0;

			EventSchedulerService ess = new EventSchedulerService();

			response.getWriter().print(ess.getBatchGroups(courseID));
		}
		//

		// assessmentData filter
		if (request.getParameterMap().containsKey("assessmentData")
				&& !request.getParameter("assessmentData").equalsIgnoreCase("")) {

			int assessmentData = request.getParameter("assessmentData") != ""
					? Integer.parseInt(request.getParameter("assessmentData")) : 0;

			EventSchedulerService ess = new EventSchedulerService();

			response.getWriter().print(ess.getAssessment(assessmentData));
		}
		//
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
