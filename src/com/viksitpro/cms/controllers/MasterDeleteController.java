package com.viksitpro.cms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.cms.services.LessonServices;
import com.viksitpro.cms.services.ModuleServices;
import com.viksitpro.cms.services.SessionServices;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;

/**
 * Servlet implementation class MasterDeleteController
 */
@WebServlet("/master_delete")
public class MasterDeleteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MasterDeleteController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if(request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("module")){
			Module module = (new ModuleDAO().findById(Integer.parseInt(request.getParameter("id").toString())));
			module.setIsDeleted(true);
			System.err.println("The module's isz-deleted field is now >>" + module.getIsDeleted());
			ModuleDAO dao = new ModuleDAO();
			ModuleServices moduleServices = new ModuleServices();
			moduleServices.saveModuleDetails(module, dao);
		}else if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("session")) {
			Cmsession cmsession = (new CmsessionDAO().findById(Integer.parseInt(request.getParameter("id").toString())));
			cmsession.setIsDeleted(true);
			System.err.println("The cmsession's is_deleted field is now >>" + cmsession.getIsDeleted());
			CmsessionDAO dao = new CmsessionDAO();
			SessionServices services = new SessionServices();
			services.saveCmsessionDetails(cmsession, dao);
		}else if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("lesson")) {
			Lesson lesson = (new LessonDAO().findById(Integer.parseInt(request.getParameter("id").toString())));
			lesson.setIsDeleted(true);
			LessonDAO dao = new LessonDAO();
			LessonServices lessonServices = new LessonServices();
			lessonServices.saveLessonDetails(lesson, dao);
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
