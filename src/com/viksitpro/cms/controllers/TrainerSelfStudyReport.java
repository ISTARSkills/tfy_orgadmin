package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.cms.services.CourseTreeServices;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;

/**
 * Servlet implementation class TrainerSelfStudyReport
 */
@WebServlet("/TrainerSelfStudyReport")
public class TrainerSelfStudyReport extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public TrainerSelfStudyReport() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		CourseTreeServices courseTreeServices = new CourseTreeServices();
		int course_id = 5;
		if (request.getParameterMap().containsKey("course")) {
			if (request.getParameter("course") != null) {
				course_id = Integer.parseInt(request.getParameter("course").toString());
			}
		}
		Course course = (new CourseDAO()).findById(course_id);
		List<HashMap<String, Object>> trainers = courseTreeServices.getTrainersforCourse(course);
		JSONObject trainerNames = new JSONObject();
		for(HashMap<String, Object> t : trainers){
			IstarUser trainer = (new IstarUserDAO()).findById(Integer.parseInt(t.get("trainer_id").toString()));
			try {
				trainerNames.put(trainer.getId().toString(), trainer.getUserProfile().getFirstName());
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		JSONObject trainerbrowses = null;
		try {
			trainerbrowses = courseTreeServices.totStatus(course);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		JSONObject allLessons = new JSONObject();
		try {
			allLessons = courseTreeServices.getallLessons(course);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		JSONObject resp = new JSONObject();
		try {
			resp.put("trainerNames", trainerNames);
			resp.put("trainerbrowses", trainerbrowses);
			resp.put("allLessons", allLessons);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.setContentType("application/json");
		response.getWriter().append(resp.toString());
		response.getWriter().flush();
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
