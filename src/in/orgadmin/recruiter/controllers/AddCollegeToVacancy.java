package in.orgadmin.recruiter.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/add_college")
public class AddCollegeToVacancy extends IStarBaseServelet{
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		printAttrs(request);
		printParams(request);
		
		if(request.getParameterMap().containsKey("vacancy_id") && request.getParameterMap().containsKey("college_id")){
		if(!request.getParameter("vacancy_id").toString().trim().isEmpty() && !request.getParameter("vacancy_id").equalsIgnoreCase("undefined") && 
				!request.getParameter("college_id").toString().trim().isEmpty() && !request.getParameter("college_id").equalsIgnoreCase("undefined")
				&& request.getParameter("college_id")!=null && !request.getParameter("college_id").equalsIgnoreCase("null")){
		int vacancyId = Integer.parseInt(request.getParameter("vacancy_id"));
		int collegeId = Integer.parseInt(request.getParameter("college_id"));
		
		RecruiterServices recruiterServices = new RecruiterServices();
		recruiterServices.addCampaign(vacancyId, collegeId);
		
		System.out.println("Jobs Event Created for all the students");
		
		}else{
			System.out.println("Invalid details!");
		}
		}
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
	
	

}

