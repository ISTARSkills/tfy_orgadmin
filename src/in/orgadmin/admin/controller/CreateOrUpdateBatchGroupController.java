package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.admin.services.OrgAdminBatchGroupService;

/**
 * Servlet implementation class CreateOrUpdateBatchGroupController
 */
@WebServlet("/createOrUpdateBatchGroup")
public class CreateOrUpdateBatchGroupController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateOrUpdateBatchGroupController() {
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
		Integer college_id = Integer.parseInt(request.getParameter("college_id"));
		if (request.getParameterMap().containsKey("group_name")
				&& !request.getParameter("group_name").equalsIgnoreCase("")) {

			List<Integer> list = new ArrayList<Integer>();

			String group_name = request.getParameter("group_name");
			String group_desc = request.getParameter("group_desc");
			String student_list;
			if(request.getParameterMap().containsKey("select_all") && request.getParameter("select_all").equalsIgnoreCase("on"))
			{
				String sql = "select id from student where organization_id = "+college_id;
				DBUTILS dbutils=new DBUTILS();
				List<HashMap<String, Object>> data=dbutils.executeQuery(sql);
				for (HashMap<String, Object> item : data) {
					list.add((int)item.get("id"));
				}
			}
			else
			{
				if (request.getParameterMap().containsKey("student_list") && ! request.getParameter("student_list").equalsIgnoreCase("")) {
					student_list = request.getParameter("student_list");

					for (int i = 0; i < student_list.split(",").length; i++) {
						try {
							list.add(Integer.parseInt(student_list.split(",")[i]));
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}

			}	
			
			
			

			OrgAdminBatchGroupService batchGroupService = new OrgAdminBatchGroupService();
			BatchGroup batchGroup=null;
			if(request.getParameterMap().containsKey("bg_id") && !request.getParameter("bg_id").equalsIgnoreCase("")){
				//update
				int bg_id=Integer.parseInt(request.getParameter("bg_id"));
				batchGroup=batchGroupService.updateBatchGroup(bg_id,group_name, group_desc, 1000, college_id, 10195);
			}else{
				
				//create
				batchGroup= batchGroupService.createBatchGroup(group_name, group_desc, 1000, college_id, 10195);
			}
			
			if (batchGroup != null) {
				batchGroupService.createBGStudents(batchGroup.getId(), list);
			}
		}
	
		response.sendRedirect("orgadmin/admin.jsp");
		/*request.setAttribute("tab","group");
		RequestDispatcher requestDispatcher = request.getRequestDispatcher("orgadmin/admin.jsp");
		requestDispatcher.forward(request, response);
		*/
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
