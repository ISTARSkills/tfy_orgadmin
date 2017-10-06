package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.cms.services.AssessmentEngineService;
import com.viksitpro.cms.services.LessonServices;
import com.viksitpro.cms.utilities.LessonTypeNames;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.AssessmentQuestion;
import com.viksitpro.core.dao.entities.AssessmentQuestionDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.QuestionDAO;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.dao.entities.TaskLog;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.factory.task.TaskEntityServices;

/**
 * Servlet implementation class AssessmentUpdateController
 */
@WebServlet("/update_assessment")
public class AssessmentUpdateController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AssessmentUpdateController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
		response.setContentType("text/html");
		if (request.getParameterMap().containsKey("assessment_id") && request.getParameterMap().containsKey("assessment_name") && request.getParameterMap().containsKey("assessment_type") && request.getParameterMap().containsKey("assessment_retriable") && request.getParameterMap().containsKey("assessment_duration") && request.getParameterMap().containsKey("assessment_category")
				&& request.getParameterMap().containsKey("question_list") && request.getParameterMap().containsKey("assessment_desc")) {
			AssessmentDAO assessmentDAO = new AssessmentDAO();
			Assessment assessment = assessmentDAO.findById(Integer.parseInt(request.getParameter("assessment_id")));
			AssessmentEngineService service = new AssessmentEngineService();
			String question_list = request.getParameter("question_list").toString();
			Set<AssessmentQuestion> assessmentQuestions = assessment.getAssessmentQuestions();
			//assessmentQuestions.clear();
			String sql = "DELETE from assessment_question where assessmentid = " + assessment.getId();
			(new DBUTILS()).executeUpdate(sql);
			assessmentQuestions = service.saveAssessmentQuestions(assessment, question_list, assessmentQuestions);
			assessment.setAssessmenttitle(request.getParameter("assessment_name").toString());
			assessment.setDescription(request.getParameter("assessment_desc").toString());
			assessment.setAssessmentType(request.getParameter("assessment_type").toString());
			assessment.setRetryAble(Boolean.parseBoolean(request.getParameter("assessment_retriable").toString()));
			assessment.setAssessmentdurationminutes(Integer.parseInt(request.getParameter("assessment_duration").toString()));
			assessment.setCategory(request.getParameter("assessment_category").toString());
			//assessment.setAssessmentQuestions(assessmentQuestions);
			assessment = service.saveAssessmentDetails(assessment, assessmentDAO);

			
			 LessonDAO lessonDAO = new LessonDAO(); 
			 LessonServices lessonServices = new LessonServices(); 
			 Lesson lesson = lessonServices.getLessonforAssessment(assessment);
			 if(lesson!=null){
				 lesson.setTitle(assessment.getAssessmenttitle());
				 lesson.setIsDeleted(false); 
				 lesson.setDuration(assessment.getAssessmentdurationminutes());
				 lesson.setDescription(assessment.getDescription());
				 lesson.setLessonXml(assessment.getId().toString());
				 lesson.setType(LessonTypeNames.ASSESSMENT);
				 lesson.setIsPublished(false);
				 lesson.setIsDeleted(false);
				 (new LessonServices()).saveLessonDetails(lesson, lessonDAO);
				 // task & task log generation
				 TaskEntityServices entityServices = new TaskEntityServices();
				 entityServices.updateLesson(lesson, request.getSession());				 
			 }
			out.println(assessment.getId().toString());
		} else {
			out.println("paramsmissing");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
