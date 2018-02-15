package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.cms.services.ModuleServices;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;

/**
 * Servlet implementation class ModuleCreateController
 */
@WebServlet("/create_module")
public class ModuleCreateController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ModuleCreateController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if ((request.getParameterMap().containsKey("module_name")) 
				&& (request.getParameterMap().containsKey("module_desc")) 
				&& (request.getParameterMap().containsKey("session_list")) 
				&& (request.getParameterMap().containsKey("module_image"))) {
			String[] cmsession_ids = request.getParameter("session_list").toString().split(",");
			//String[] skill_objective_ids = request.getParameter("skill_objective_list").toString().split(",");
			ModuleServices moduleServices = new ModuleServices();
			ModuleDAO moduleDAO = new ModuleDAO();
			Module module = new Module();
			module.setModuleName(request.getParameter("module_name").toString());
			module.setModule_description(request.getParameter("module_desc").toString());
			module.setImage_url(request.getParameter("module_image").toString());
			module.setIsDeleted(false);
			//module = moduleServices.saveModuleSkillObjectivesMapping(module, moduleDAO, skill_objective_ids);
			try {
				module = moduleServices.saveModuleCMSessionMapping(module, moduleDAO, cmsession_ids);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
			}
			module = moduleServices.saveModuleDetails(module, moduleDAO);
			response.setContentType("text/html");
			// Actual logic goes here.
			PrintWriter out = response.getWriter();
			out.println(module.getId());
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
