package in.orgadmin.tpo.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;
import in.orgadmin.services.InviteUser;

@WebServlet("/invite_recruiter")
public class InviteRecruiter extends IStarBaseServelet {

	private static final long serialVersionUID = 1L;

	public InviteRecruiter() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		printAttrs(request);
		printParams(request);
		
		String result = "";
		
		if(request.getParameterMap().containsKey("name") && request.getParameterMap().containsKey("email") && request.getParameterMap().containsKey("company_id")){
			
		System.out.println("Inviting Recruiter");
		String recruiterName = request.getParameter("name");
		String recruiterEmail = request.getParameter("email");		
		//int companyID = Integer.parseInt(request.getParameter("company_id"));
		String companyID = request.getParameter("company_id");
		int palcementOfficerCollegeID = Integer.parseInt(request.getParameter("tpo_college_id"));
		
		

		if (!(recruiterName.trim().equalsIgnoreCase("") && !recruiterEmail.trim().equalsIgnoreCase("")) && !companyID.trim().equalsIgnoreCase("") 
				&& !(palcementOfficerCollegeID<0)) {
			InviteUser inviteUser = new InviteUser();
			result = inviteUser.inviteCollegeRecruiter(recruiterName, recruiterEmail, Integer.parseInt(companyID), palcementOfficerCollegeID);
		} else {
			result = "Please enter valid Name and Email";
			System.out.println("enter Name and Email");
		}
		}
		
		response.getWriter().print(result);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
