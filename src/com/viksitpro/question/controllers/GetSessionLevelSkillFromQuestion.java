package com.viksitpro.question.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.QuestionDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.question.services.QuestionServices;

/**
 * Servlet implementation class GetSessionLevelSkillFromQuestion
 */
@WebServlet("/session_skills_from_question")
public class GetSessionLevelSkillFromQuestion extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetSessionLevelSkillFromQuestion() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(request.getParameterMap().containsKey("question")){
			JSONObject resp = new JSONObject();
			JSONArray array = new JSONArray();
			Question question = (new QuestionDAO()).findById(Integer.parseInt(request.getParameter("question").toString()));
			QuestionServices questionServices = new QuestionServices();
			HashSet<SkillObjective> session_skills = questionServices.getSessionSkillsfromQuestion(question);
			for(SkillObjective session_skill : session_skills){
				JSONObject item = new JSONObject();
				try {
					item.put("id", session_skill.getId());
					item.put("text", session_skill.getName());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				array.put(item);
			}
			try {
				resp.put("selected_session_skills", array);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			response.setContentType("application/json");
			response.getWriter().write(resp.toString());
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
