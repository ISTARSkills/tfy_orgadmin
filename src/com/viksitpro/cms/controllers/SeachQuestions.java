package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class SeachQuestions
 */
@WebServlet("/SeachQuestions")
public class SeachQuestions extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SeachQuestions() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		DBUTILS dbutils = new DBUTILS();
		JSONArray question_array = new JSONArray();
		if (request.getParameterMap().containsKey("searchString")) {
			String searchString = request.getParameter("searchString").toString().toLowerCase().trim();
			Set<Question> questions = new HashSet<Question>();
			Question question;
			String hql = "from Question order by id desc";
			List all_questions = (new DBUTILS()).executeHQL(hql);
			for (Object object : all_questions) {
				question = (Question) object;
				boolean is_contained = false;
				if (question.getQuestionText().toLowerCase().contains(searchString)) {
					is_contained = true;
				}
				if (question.getId().toString().contains(searchString)) {
					is_contained = true;
				}
				if (is_contained) {
					questions.add(question);
				}
			}
			/*Set<SkillObjective> learningObjectives = (new SkillChildrenServices()).SearchLearningObjectivesFromAnySkillString(searchString);
			for (SkillObjective skillObjective : learningObjectives) {
				Set<Question> questions2 = skillObjective.getQuestions();
				for (Question question2 : questions2) {
					questions.add(question2);
				}
			}*/
			for (Question q : questions) {
				JSONObject question_object = new JSONObject();
				try {
					question_object.put("id", q.getId());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					question_object.put("name", q.getQuestionText());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				question_array.put(question_object);
			}
		}
		JSONObject resp = new JSONObject();
		try {
			resp.put("questions", question_array);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("application/json");
		response.getWriter().write(resp.toString());
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
