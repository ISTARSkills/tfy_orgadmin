package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

@WebServlet("/LoadCollegeTabContent")
public class LoadCollegeTabContent extends IStarBaseServelet{
	private static final long serialVersionUID = 1L;

    public LoadCollegeTabContent() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String collegeID = request.getParameter("college_id");
		String recruiterID = request.getParameter("recruiter_id");
		
		System.out.println(collegeID);
		System.out.println(recruiterID);
		
		System.out.println("Requesting Ajax Call for college tab");
		
		response.sendRedirect("/recruiter/recruiter_college.jsp?college_id="+collegeID+"&recruiter_id="+recruiterID);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
