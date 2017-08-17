package com.viksitpro.lesson.controllers;

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

import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;

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
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONArray lesson_array = new JSONArray();
		if (request.getParameterMap().containsKey("searchString")) {
			String[] searchString = request.getParameter("searchString").toString().split(" ");
			Set<Lesson> lessons = new HashSet<Lesson>();
			LessonDAO dao = new LessonDAO();
			Lesson lesson;
			List all_lessons = dao.findAll();
			for (Object object : all_lessons) {
				lesson = (Lesson) object;
				boolean is_contained = false;
				for (String search : searchString) {
					if (lesson.getTitle().toLowerCase().contains(search)) {
						is_contained = true;
					}
					if (lesson.getDescription().toLowerCase().contains(search)) {
						is_contained = true;
					}
					if (lesson.getId().toString().contains(search)) {
						is_contained = true;
					}					
				}
				if (is_contained) {
					lessons.add(lesson);
				}
			}
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
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
