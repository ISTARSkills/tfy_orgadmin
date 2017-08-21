package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.util.HashMap;
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

import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.QuestionDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
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
			String searchString = request.getParameter("searchString").toString().toLowerCase();
			Set<Question> questions = new HashSet<Question>();
			QuestionDAO dao = new QuestionDAO();
			Question question;
			List all_questions = dao.findAll();
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
			Set<SkillObjective> objectives = new HashSet<SkillObjective>();
			for (SkillObjective objective : new SkillObjectiveDAO().findAll()) {
				if (objective.getName().toLowerCase().contains(searchString)) {
					objectives.add(objective);
				}
			}
			Set<SkillObjective> learningObjectives = new HashSet<SkillObjective>();
			for (SkillObjective objective : objectives) {
				String sql = "";
				switch (objective.getSkillLevelType()) {
				case "MODULE":
					sql = "select id from skill_objective where parent_skill in (select id from skill_objective where parent_skill = "
							+ objective.getId() + ")";
					List<HashMap<String, Object>> executeQuery = dbutils.executeQuery(sql);
					for (HashMap<String, Object> hashMap : executeQuery) {
						SkillObjective objective2 = (new SkillObjectiveDAO()
								.findById(Integer.parseInt(hashMap.get("id").toString())));
						if (objective2 != null) {
							learningObjectives.add(objective2);
						}
					}
					break;
				case "CMSESSION":
					sql = "select * from skill_objective where parent_skill = " + objective.getId()
							+ " and type = 'LEARNING_OBJECTIVE' and skill_level_type = 'LESSON'";
					List<HashMap<String, Object>> executeQuery2 = dbutils.executeQuery(sql);
					for (HashMap<String, Object> hashMap : executeQuery2) {
						SkillObjective objective2 = (new SkillObjectiveDAO())
								.findById(Integer.parseInt(hashMap.get("id").toString()));
						if (objective2 != null) {
							learningObjectives.add(objective2);
						}
					}
					break;
				case "LESSON":
					learningObjectives.add(objective);
					break;
				default:
					break;
				}
			}
			for (SkillObjective skillObjective : learningObjectives) {
				Set<Question> questions2 = skillObjective.getQuestions();
				for (Question question2 : questions2) {
					questions.add(question2);
				}
			}
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
