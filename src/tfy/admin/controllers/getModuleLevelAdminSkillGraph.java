package tfy.admin.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import in.talentify.core.controllers.IStarBaseServelet;
import tfy.admin.services.StudentSkillMapService;
import tfy.admin.studentmap.pojos.AdminCMSessionSkillData;
import tfy.admin.studentmap.pojos.AdminSkillGraph;

/**
 * Servlet implementation class getAdminSkillGraph
 */
@WebServlet("/get_admin_skill_graph")
public class getModuleLevelAdminSkillGraph extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getModuleLevelAdminSkillGraph() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		StudentSkillMapService serv = new StudentSkillMapService();
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		String result="";
		if(request.getParameter("type").toString().equalsIgnoreCase("MODULE_LEVEL"))
		{
			if(request.getParameterMap().containsKey("course_id"))
			{
				int collegeId = Integer.parseInt(request.getParameter("college_id"));
				int courseId = Integer.parseInt(request.getParameter("course_id"));
			
				List<AdminSkillGraph> moduleSkillGraph = serv.getModuleSkillGraphForCourse(courseId, collegeId);						
				result = gson.toJson(moduleSkillGraph);

			}else if (request.getParameterMap().containsKey("batch_id"))
			{
				int collegeId = Integer.parseInt(request.getParameter("college_id"));
				int batchId = Integer.parseInt(request.getParameter("batch_id"));
				List<AdminSkillGraph> moduleSkillGraph = serv.getModuleSkillGraphForBatch(batchId, collegeId);
				result = gson.toJson(moduleSkillGraph);
			}
		}
		else
		{
			if(request.getParameterMap().containsKey("course_id"))
			{
				int collegeId = Integer.parseInt(request.getParameter("college_id"));
				int courseId = Integer.parseInt(request.getParameter("course_id"));
				
				HashMap<String, ArrayList<AdminCMSessionSkillData>> cmsessionSkillGraph = serv.getCMSessionSkillGraphForCourse(courseId, collegeId);						
				result = gson.toJson(cmsessionSkillGraph);

			}else if (request.getParameterMap().containsKey("batch_id"))
			{
				int collegeId = Integer.parseInt(request.getParameter("college_id"));
				int batchId = Integer.parseInt(request.getParameter("batch_id"));
				HashMap<String, ArrayList<AdminCMSessionSkillData>> cmsessionSkillGraph = serv.getCMSessionSkillGraphForBatch(batchId, collegeId);	
				result = gson.toJson(cmsessionSkillGraph);
			}
		}	
		
		
		response.getWriter().write(result);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
