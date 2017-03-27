package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/initializeInterview")
public class InitializeInterview extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public InitializeInterview() {
        super();
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		System.out.println("Initializing Interview Screen");
		RecruiterServices recruiterServices = new RecruiterServices();		
		HttpSession session = request.getSession(true);
		
		if(request.getParameterMap().containsKey("id")){
		String uniqueURLCode = request.getParameter("id");
		
		HashMap<String, Object> interviewDetails = recruiterServices.getInterviewDetails(uniqueURLCode);
		
		System.out.println("Interview DEtails are:");
		
		
		System.out.println("HOST URL:" + interviewDetails.get("hostURL"));
		System.out.println("JOIN URL:" +interviewDetails.get("joinURL"));
		
		session.setAttribute("interviewDetails", interviewDetails);
		
		System.out.println("Opening Panelist Screen");		
		response.sendRedirect("/recruiter/panelist.jsp");
		
		}else{
			System.out.println("Invalid Meeting URL");
		}		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
