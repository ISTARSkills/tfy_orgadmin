package com.viksitpro.cms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;

import com.viksitpro.cms.services.CourseTreeServices;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;

/**
 * Servlet implementation class GetCourseStructure
 */
@WebServlet("/batch_report")
public class BatchProgressReport extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BatchProgressReport() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		CourseTreeServices courseTreeServices = new CourseTreeServices();
		int course_id = 5;
		if(request.getParameterMap().containsKey("course")){
			if(request.getParameter("course")!=null){
				course_id = Integer.parseInt(request.getParameter("course").toString());	
			}
		}
		Course course = (new CourseDAO()).findById(course_id);
		JSONArray array = new JSONArray();
		try {
			array = courseTreeServices.getBatchProgressReport(course);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("application/json");
		response.getWriter().append(array.toString());
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
