package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.services.OrgadminCourseService;

/**
 * Servlet implementation class AddTrainerToCourse
 */
@WebServlet("/add_trainer_course")
public class AddTrainerToCourse extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AddTrainerToCourse() {
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
		String stu_ids[] = request.getParameterValues("stu_id");
		String course_id = request.getParameter("course_id");
		List<Integer> trainerList = new ArrayList<>();
		for (String str : stu_ids) {
			trainerList.add(Integer.parseInt(str));
		}
		new OrgadminCourseService().updateTrainerCourse(Integer.parseInt(course_id), trainerList);
		String referrer = request.getHeader("referer");
		response.sendRedirect(referrer);
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
