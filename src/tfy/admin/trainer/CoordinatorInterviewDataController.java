package tfy.admin.trainer;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		StringBuffer sb = new StringBuffer();

		int coordinatorId = Integer.parseInt(request.getParameter("coordinator_id"));
		int interviewerId = Integer.parseInt(request.getParameter("interviewer_id"));
		int intervieweeId = Integer.parseInt(request.getParameter("trainerID"));
		int durationInMinutes = Integer.parseInt(request.getParameter("duration"));
		int courseId = Integer.parseInt(request.getParameter("course_id"));
		String stage_id=request.getParameter("stage_id");
		String date = request.getParameter("date");
		String time = request.getParameter("time");
		CreateInterviewSchedule schedule = new CreateInterviewSchedule();
		schedule.createInterviewForTrainer(coordinatorId, interviewerId, intervieweeId, durationInMinutes, date, time,
				courseId,stage_id);
		sb.append("Success");
		response.getWriter().print(sb);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
