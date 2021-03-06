package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.cms.services.CourseServices;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class CourseCreateController
 */
@WebServlet("/create_course")
public class CourseCreateController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CourseCreateController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if ((request.getParameterMap().containsKey("course_name"))
				&& (request.getParameterMap().containsKey("course_desc"))
				&& (request.getParameterMap().containsKey("module_list"))
				&& (request.getParameterMap().containsKey("course_name"))
				&& (request.getParameterMap().containsKey("course_image"))
				&& (request.getParameterMap().containsKey("course_category"))) {
			String[] module_ids = request.getParameter("module_list").toString().split(",");
			CourseDAO courseDAO = new CourseDAO();
			Course course = new Course();
			course.setCourseName(request.getParameter("course_name").toString());
			course.setCourseDescription(request.getParameter("course_desc").toString());
			course.setImage_url(request.getParameter("course_image").toString());
			course.setCategory(request.getParameter("course_category").toString());
			CourseServices courseServices = new CourseServices();
			course = courseServices.saveCourseDetails(course, courseDAO);
			try {
				course = courseServices.createCourseDetailsModule(course, courseDAO, module_ids);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
			}
			//course = courseServices.createCourseDetailsSkillObjectives(course, courseDAO, skill_objective_ids);
			course = courseServices.saveCourseDetails(course, courseDAO);
			//(new TaskEntityServices()).createCourse(course, request.getSession());
		response.setContentType("text/html");
		String sql = "INSERT INTO public.context (id, title) VALUES ('"+course.getId()+"', '"+course.getCourseName()+"');";
		(new DBUTILS()).executeUpdate(sql);
		// Actual logic goes here.
		PrintWriter out = response.getWriter();
		out.println(course.getId());
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
