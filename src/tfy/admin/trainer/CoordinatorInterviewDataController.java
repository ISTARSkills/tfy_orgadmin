package tfy.admin.trainer;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class CoordinatorInterviewDataController
 */
@WebServlet("/coordinator_interview_data")
public class CoordinatorInterviewDataController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public CoordinatorInterviewDataController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		DBUTILS dbutils = new DBUTILS();
		StringBuffer sb = new StringBuffer();

		if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("trainer")) {
			String stage = request.getParameter("stage");
			int courseId = Integer.parseInt(request.getParameter("course"));
			List<HashMap<String, Object>> data = new CoordinatorSchedularUtil().getTrainerLists(stage, courseId);

			sb.append("<option value=''>Select Trainer...</option>");

			if (data != null && data.size() != 0) {
				for (HashMap<String, Object> item : data) {
					sb.append("<option value='" + item.get("trainer_id") + "'>" + item.get("email") + "</option>");
				}
			}

		} else if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("submit")) {
			int coordinatorId = Integer.parseInt(request.getParameter("coordinator_id"));
			int interviewerId = Integer.parseInt(request.getParameter("interviewer_id"));
			int intervieweeId = Integer.parseInt(request.getParameter("trainerID"));
			int durationInMinutes = Integer.parseInt(request.getParameter("duration"));
			int courseId = Integer.parseInt(request.getParameter("course_id"));
			String date = request.getParameter("date");
			String time = request.getParameter("time");
			CreateInterviewSchedule schedule = new CreateInterviewSchedule();
			schedule.createInterviewForTrainer(coordinatorId, interviewerId, intervieweeId, durationInMinutes, date,
					time, courseId);
			sb.append("Success");
		}
		response.getWriter().print(sb);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
