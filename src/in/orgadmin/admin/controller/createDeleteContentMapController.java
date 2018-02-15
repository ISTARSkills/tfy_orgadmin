package in.orgadmin.admin.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.IStarBaseServelet;

import in.orgadmin.admin.services.OrgAdminSkillService;

/**
 * Servlet implementation class RoleSkillCreateOrDeleteController
 */
@WebServlet("/create_delete_content_map")
public class createDeleteContentMapController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public createDeleteContentMapController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		try {

			
			OrgAdminSkillService adminSkillService=new OrgAdminSkillService();
			if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("content_map")){
				
				int skillId=Integer.parseInt(request.getParameter("skillId"));
				int typeId=Integer.parseInt(request.getParameter("entityId"));
				String userType=request.getParameter("entityType");
				String skillType=request.getParameter("skillType");
				
				StringBuffer out=adminSkillService.createContentAssosicatedSkill(userType,skillType,skillId,typeId);
					
				response.getWriter().print(out);
				
			}
			
			
			if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("delete_content_map")){
				int lessonId=Integer.parseInt(request.getParameter("lessonId"));
				int typeId=Integer.parseInt(request.getParameter("entityId"));
				String userType= request.getParameter("entityType");
				
				adminSkillService.deleteContentAssosicatedSkill(userType,typeId,lessonId);
			}
			
			
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
