package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.cms.services.SessionServices;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;

/**
 * Servlet implementation class SessionUpdateController
 */
@WebServlet("/update_session")
public class SessionUpdateController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SessionUpdateController() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Cmsession cmsession = new Cmsession();
		if ((request.getParameterMap().containsKey("cmsession_id"))
				&& (request.getParameterMap().containsKey("cmsession_name"))
				&& (request.getParameterMap().containsKey("cmsession_desc"))
				&& (request.getParameterMap().containsKey("lesson_list"))
				&& (request.getParameterMap().containsKey("cmsession_image"))
				&& (request.getParameterMap().containsKey("skill_objective_list"))) {
			String[] lesson_ids = request.getParameter("lesson_list").toString().split(",");
			String[] skill_objective_ids = request.getParameter("skill_objective_list").toString().split(",");
			SessionServices cmsessionServices = new SessionServices();
			CmsessionDAO cmsessionDAO = new CmsessionDAO();
			cmsession = cmsessionDAO.findById(Integer.parseInt(request.getParameter("cmsession_id").toString()));
			cmsession.setTitle(request.getParameter("cmsession_name").toString());
			cmsession.setDescription(request.getParameter("cmsession_desc").toString());
			cmsession.setImage_url(request.getParameter("cmsession_image").toString());
			try {
				cmsession = cmsessionServices.editCmsessionLessonMapping(cmsession, cmsessionDAO, lesson_ids);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
			}
			cmsession = cmsessionServices.editCmsessionSkillObjectivesMapping(cmsession, cmsessionDAO, skill_objective_ids);
			cmsession = cmsessionServices.saveCmsessionDetails(cmsession, cmsessionDAO);
		}
		response.setContentType("text/html");
		// Actual logic goes here.
		PrintWriter out = response.getWriter();
		out.println(cmsession.getId());
	}

	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
