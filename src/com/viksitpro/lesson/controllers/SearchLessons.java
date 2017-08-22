package com.viksitpro.lesson.controllers;

import java.io.IOException;
import java.util.ArrayList;
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

import com.viksitpro.cms.services.SkillChildrenServices;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class SearchLessons
 */
@WebServlet("/SearchLessons")
public class SearchLessons extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SearchLessons() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		JSONArray lesson_array = new JSONArray();
		if (request.getParameterMap().containsKey("searchString")) {
			String searchString = request.getParameter("searchString").toString().toLowerCase().trim();
			List<Lesson> lessons = new ArrayList<Lesson>();
			Lesson lesson;
			String hql = "from Lesson order by id desc";
			List all_lessons = (new DBUTILS()).executeHQL(hql);
			for (Object object : all_lessons) {
				lesson = (Lesson) object;
				boolean is_contained = false;
				if (lesson.getTitle().toLowerCase().contains(searchString)) {
					is_contained = true;
				}
				if (lesson.getId().toString().contains(searchString)) {
					is_contained = true;
				}
				if (is_contained) {
					lessons.add(lesson);
				}
			}
			/*Set<SkillObjective> learningObjectives = (new SkillChildrenServices()).SearchLearningObjectivesFromAnySkillString(searchString);
			for (SkillObjective skillObjective : learningObjectives) {
				Set<Lesson> lessons2 = skillObjective.getLessons();
				for (Lesson lesson2 : lessons2) {
					lessons.add(lesson2);
				}
			}*/
			for (Lesson l : lessons) {
				JSONObject lesson_object = new JSONObject();
				try {
					lesson_object.put("id", l.getId());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					lesson_object.put("name", l.getTitle());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				lesson_array.put(lesson_object);
			}
		}
		JSONObject resp = new JSONObject();
		try {
			resp.put("lessons", lesson_array);
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
