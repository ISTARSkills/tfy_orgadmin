package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.BatchService;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class UpdateStudentInBatchGroup
 */
@WebServlet("/update_bg_student")
public class UpdateStudentInBatchGroup extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdateStudentInBatchGroup() {
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
		String batch_group_id = request.getParameter("batch_group_id");
		if(request.getParameter("user_id")!=null){
		String stu_ids[] = request.getParameterValues("user_id");
		
		List<Integer> studentList = new ArrayList<>();
		
		if(!(request.getParameter("user_id").equalsIgnoreCase(""))){
		for (String str : stu_ids) {
			studentList.add(Integer.parseInt(str));
			System.out.println(str);
		}
		}
		BatchService bc = new BatchService();
		bc.updateBatchGrpStudents(Integer.parseInt(batch_group_id), studentList);

		}else{
			
			DBUTILS util = new DBUTILS();
	    	String sql1 = "delete from batch_students where batch_group_id = "+batch_group_id;
	    	util.executeUpdate(sql1);
		}
		
		String referrer = request.getHeader("referer");
		response.sendRedirect(referrer);
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
