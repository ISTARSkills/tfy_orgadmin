package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/promote_students")
public class PromoteStudentController extends IStarBaseServelet{
	private static final long serialVersionUID = 1L;
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HashMap<String, String> result = new HashMap<String, String>();
		String studentIDsResult="";
		//String studentMessageResult="";
		
		String stageID = (request.getParameter("stage_id").toString());
		int vacanyID = Integer.parseInt((request.getParameter("vacancy_id").toString()));
		String studentIDs = request.getParameter("students").toString();
		System.out.println("Vacancy ID: " + vacanyID);
		System.out.println("Student ID: " + studentIDs);
		RecruiterServices recruiterService = new RecruiterServices();
		result = recruiterService.promoteStudents(vacanyID, stageID, studentIDs);
		
		for (HashMap.Entry<String, String> entry : result.entrySet()) {
			studentIDsResult= studentIDsResult + (entry.getKey()+","+entry.getValue()) + "##";
			//studentMessageResult = studentMessageResult +","+entry.getValue();
		}
		System.out.println("Output" + studentIDsResult);
		response.getWriter().print(studentIDsResult);
	}
		
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
	
	

}
