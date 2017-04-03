package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.Address;
import com.viksitpro.core.dao.entities.AddressDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
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
		int userID=0;

		if (request.getParameterMap().containsKey("user_email")
				&& !request.getParameter("user_email").equalsIgnoreCase("")) {

			String user_f_name = request.getParameter("user_f_name");
			String user_l_name = request.getParameter("user_l_name");
			String user_gender = request.getParameter("user_gender");
			String user_email = request.getParameter("user_email");
			Integer college_id = request.getParameter("college_id")!= ""? Integer.parseInt(request.getParameter("college_id")):2;
			String user_type = request.getParameter("user_type");
			String batch_groups;

			List<Integer> bg_list = new ArrayList<Integer>();

			if (request.getParameterMap().containsKey("batch_groups") && !request.getParameter("batch_groups").equalsIgnoreCase("")) {
				batch_groups = request.getParameter("batch_groups");
				for (int i = 0; i < batch_groups.split(",").length; i++) {
					try {
						bg_list.add(Integer.parseInt(batch_groups.split(",")[i]));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			
			if (request.getParameterMap().containsKey("user_id")) {
				int user_id = Integer.parseInt(request.getParameter("user_id"));
				userID = new OrgAdminUserService().UpdateUsersForAdminPortal(user_id, user_f_name, user_l_name, user_email,
						"test123", "9999999999", user_gender, user_type, college_id);

			} else {
				
				userID = new OrgAdminUserService().CreateUsersForAdminPortal(user_f_name, user_l_name, user_email, "test123",
						"9999999999", user_gender, user_type, college_id);
			}

			if (userID != 0) {
				if (bg_list.size() > 0) {
						new OrgAdminBatchGroupService().createorUpdateBGStudents(bg_list, userID);
				}
			}

		} else {
			System.out.println("Not Created");
		}
		
		if(request.getParameterMap().containsKey("creation_type") && request.getParameter("creation_type").equalsIgnoreCase("super_admin")){
			response.sendRedirect("super_admin/user_management.jsp");
		}else{
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
