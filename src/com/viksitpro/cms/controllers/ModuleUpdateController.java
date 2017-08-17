package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.cms.services.ModuleServices;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;

/**
 * Servlet implementation class ModuleUpdateController
 */
@WebServlet("/update_module")
public class ModuleUpdateController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ModuleUpdateController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if ((request.getParameterMap().containsKey("module_id"))
				&& (request.getParameterMap().containsKey("module_name"))
				&& (request.getParameterMap().containsKey("module_desc"))
				&& (request.getParameterMap().containsKey("session_list"))
				&& (request.getParameterMap().containsKey("module_image"))
				&& (request.getParameterMap().containsKey("skill_objective_list"))) {
			String[] cmsession_ids = request.getParameter("session_list").toString().split(",");
			String[] skill_objective_ids = request.getParameter("skill_objective_list").toString().split(",");
			ModuleServices moduleServices = new ModuleServices();
			ModuleDAO moduleDAO = new ModuleDAO();
			Module module = moduleDAO.findById(Integer.parseInt(request.getParameter("module_id").toString()));
			module.setModuleName(request.getParameter("module_name").toString());
			module.setModule_description(request.getParameter("module_desc").toString());
			module.setImage_url(request.getParameter("module_image").toString());
			try {
				module = moduleServices.saveModuleCMSessionMapping(module, moduleDAO, cmsession_ids);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
			}
			module = moduleServices.saveModuleSkillObjectivesMapping(module, moduleDAO, skill_objective_ids);
			module = moduleServices.saveModuleDetails(module, moduleDAO);
		}

		response.setContentType("text/html");

		// Actual logic goes here.
		PrintWriter out = response.getWriter();
		out.println("success");
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
