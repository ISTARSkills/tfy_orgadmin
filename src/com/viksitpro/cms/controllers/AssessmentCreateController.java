package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.cms.services.AssessmentEngineService;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.AssessmentQuestion;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.factory.task.TaskEntityServices;

/**
 * Servlet implementation class AssessmentCreateController
 */
@WebServlet("/create_assessment")
public class AssessmentCreateController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AssessmentCreateController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
		if (request.getParameterMap().containsKey("assessment_name")
				&& request.getParameterMap().containsKey("assessment_type")
				&& request.getParameterMap().containsKey("assessment_retriable")
				&& request.getParameterMap().containsKey("assessment_duration")
				&& request.getParameterMap().containsKey("assessment_category")
				&& request.getParameterMap().containsKey("question_list")
				&& request.getParameterMap().containsKey("assessment_desc")
				&& request.getParameterMap().containsKey("course")) {
			

			Assessment assessment = new Assessment();
			Set<AssessmentQuestion> assessmentQuestions = new HashSet<>();
			AssessmentDAO assessmentDAO = new AssessmentDAO();
			AssessmentEngineService service = new AssessmentEngineService();
			Lesson lesson = new Lesson();
			LessonDAO lessonDAO = new LessonDAO();
			String question_list = request.getParameter("question_list").toString();
			assessment.setAssessmenttitle(request.getParameter("assessment_name").toString());
			assessment.setDescription(request.getParameter("assessment_desc").toString());
			assessment.setAssessmentType(request.getParameter("assessment_type").toString());
			assessment.setRetryAble(Boolean.parseBoolean(request.getParameter("assessment_retriable").toString()));
			assessment.setAssessmentdurationminutes(
					Integer.parseInt(request.getParameter("assessment_duration").toString()));
			assessment.setCategory(request.getParameter("assessment_category").toString());
			assessment.setCourse(Integer.parseInt(request.getParameter("course").toString()));
			assessment = service.saveAssessmentDetails(assessment, assessmentDAO);
			assessmentQuestions = service.saveAssessmentQuestions(assessment, question_list, assessmentQuestions);

			assessment.setAssessmentQuestions(assessmentQuestions);
			assessment = service.saveAssessmentDetails(assessment, assessmentDAO);
			lesson = service.createAssessmentLesson(lesson, lessonDAO, assessment);

			// task & task log generation
			TaskEntityServices entityServices = new TaskEntityServices();
			entityServices.createLesson(lesson, request.getSession());
			response.setContentType("text/html");
			out.println(assessment.getId().toString());
		} else {
			out.println("paramsmissing");
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
