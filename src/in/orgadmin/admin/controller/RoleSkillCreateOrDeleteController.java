package in.orgadmin.admin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

import in.orgadmin.admin.services.OrgAdminSkillService;

/**
 * Servlet implementation class RoleSkillCreateOrDeleteController
 */
@WebServlet("/roleSkillCreateOrDelete")
public class RoleSkillCreateOrDeleteController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RoleSkillCreateOrDeleteController() {
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
			
			
			if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("create_role")){
				String role_name=request.getParameter("role_name");
				String role_desc=request.getParameter("role_desc");
				
				if(!role_name.equalsIgnoreCase("")){
					DBUTILS db = new DBUTILS();
					String sql="INSERT INTO course ( 	id, 	course_name, 	course_description, 	tags, 	created_at ) VALUES 	( 		(select COALESCE(max(id),1)+1 from course), 		'"+role_name+"',     '"+role_desc+"', 		NULL, 		now() 	);";
					db.executeUpdate(sql);
				}
				
			response.sendRedirect("orgadmin/admin.jsp");
			}
			
			
			
			if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("roles_map")){
				
				int skillId=Integer.parseInt(request.getParameter("skillId"));
				int roleId=Integer.parseInt(request.getParameter("roleId"));
				adminSkillService.createSkillAssosicatedRole(skillId,roleId);			

			}
			
					
			if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("content_map")){
				
				int skillId=Integer.parseInt(request.getParameter("skillId"));
				int typeId=Integer.parseInt(request.getParameter("typeId"));
				String userType=request.getParameter("userType");
				String skillType=request.getParameter("lessonType");
				
				StringBuffer out=adminSkillService.createContentAssosicatedSkill(userType,skillType,skillId,typeId);
					
				response.getWriter().print(out);
				
			}
			
			
			if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("delete_content_map")){
				int lessonId=Integer.parseInt(request.getParameter("lessonId"));
				int typeId=Integer.parseInt(request.getParameter("typeId"));
				String userType= request.getParameter("userType");
				
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
