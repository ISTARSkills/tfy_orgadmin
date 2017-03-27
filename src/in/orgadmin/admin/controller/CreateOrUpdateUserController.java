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

import com.istarindia.apps.UserTypes;
import com.istarindia.apps.dao.Address;
import com.istarindia.apps.dao.AddressDAO;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

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

		if (request.getParameterMap().containsKey("user_email")
				&& !request.getParameter("user_email").equalsIgnoreCase("")) {

			String user_f_name = request.getParameter("user_f_name");
			String user_l_name = request.getParameter("user_l_name");
			String user_gender = request.getParameter("user_gender");
			String user_email = request.getParameter("user_email");
			Integer college_id = Integer.parseInt(request.getParameter("college_id"));
			String batch_groups;

			List<Integer> bg_list = new ArrayList<Integer>();

			if (request.getParameterMap().containsKey("batch_groups")) {
				batch_groups = request.getParameter("batch_groups");

				for (int i = 0; i < batch_groups.split(",").length; i++) {
					try {
						bg_list.add(Integer.parseInt(batch_groups.split(",")[i]));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			Address add_id = new AddressDAO().findById(2);
			College college = new CollegeDAO().findById(college_id);
			Student student = null;
			if (request.getParameterMap().containsKey("user_id")) {
				int student_id = Integer.parseInt(request.getParameter("user_id"));
				student = new OrgAdminUserService().updateOnlyStudent(student_id, user_f_name, user_l_name, user_email,
						"test123", "9999999999", user_gender, UserTypes.STUDENT, add_id, college);

			} else {
				student = new OrgAdminUserService().CreateOnlyStudent(user_f_name, user_l_name, user_email, "test123",
						"9999999999", user_gender, UserTypes.STUDENT, add_id, college);
			}

			if (student != null) {
				if (bg_list.size() > 0) {
						new OrgAdminBatchGroupService().createorUpdateBGStudents(bg_list, student.getId());
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
