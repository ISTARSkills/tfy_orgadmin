package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.IStarBaseServelet;

import in.orgadmin.admin.services.OrgAdminBatchGroupService;
import in.orgadmin.admin.services.OrgAdminUserService;

/**
 * Servlet implementation class CreateOrUpdateUserController
 */
@WebServlet("/createOrUpdateUser")
public class CreateOrUpdateUserController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateOrUpdateUserController() {
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
		int userID = 0;

		if (request.getParameterMap().containsKey("user_email")
				&& !request.getParameter("user_f_name").equalsIgnoreCase("")
								
				&& !request.getParameter("user_email").equalsIgnoreCase("")
				&& !request.getParameter("user_mobile").equalsIgnoreCase("")) {

			String user_f_name = request.getParameter("user_f_name");
			String user_l_name = request.getParameter("user_l_name")!=null ? request.getParameter("user_l_name").toString(): " ";
			String user_gender = request.getParameter("user_gender");
			
			String user_email = request.getParameter("user_email");
			user_email = user_email.toLowerCase().trim();
			
			Integer college_id = request.getParameter("college_id") != ""
					? Integer.parseInt(request.getParameter("college_id")) : 2;
			String user_types;
			String user_mobile = request.getParameter("user_mobile");
			String batch_groups;
			List<Integer> bg_list = new ArrayList<Integer>();
			List<String> user_type = new ArrayList<String>();
			
			if (request.getParameterMap().containsKey("batch_groups")
					&& !request.getParameter("batch_groups").equalsIgnoreCase("")) {
				batch_groups = request.getParameter("batch_groups");
				for (int i = 0; i < batch_groups.split(",").length; i++) {
					try {
						bg_list.add(Integer.parseInt(batch_groups.split(",")[i]));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			
			if (request.getParameterMap().containsKey("user_type")
					&& !request.getParameter("user_type").equalsIgnoreCase("")) {
				user_types = request.getParameter("user_type");
				for (int i = 0; i < user_types.split(",").length; i++) {
					try {
						user_type.add(user_types.split(",")[i]);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			if (request.getParameterMap().containsKey("user_id")) {
				int user_id = Integer.parseInt(request.getParameter("user_id"));
				userID = new OrgAdminUserService().UpdateUsersForAdminPortal(user_id, user_f_name, user_l_name,
						user_email, "test123", user_mobile, user_gender, user_type, college_id);

			} else {

				userID = new OrgAdminUserService().CreateUsersForAdminPortal(user_f_name, user_l_name, user_email,
						"test123", user_mobile, user_gender, user_type, college_id);
			}

			if (userID != 0) {
				
					new OrgAdminBatchGroupService().createorUpdateBGStudents(bg_list, userID);
				
			}

		} else if(request.getParameterMap().containsKey("key")){
			
			int user_id = Integer.parseInt(request.getParameter("user_id"));
			ViksitLogger.logMSG(this.getClass().getName(),">>>>>>>>>>>>>>>>>>>>>>>> "+user_id);
			new OrgAdminUserService().deleteIstarUser(user_id);
		}
		
		else {
			ViksitLogger.logMSG(this.getClass().getName(),"Not Created");
		}

		if (request.getParameterMap().containsKey("creation_type")
				&& request.getParameter("creation_type").equalsIgnoreCase("super_admin")) {
			response.sendRedirect("super_admin/user_management.jsp");
		} else {
			response.sendRedirect("orgadmin/admin.jsp");
		}

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
