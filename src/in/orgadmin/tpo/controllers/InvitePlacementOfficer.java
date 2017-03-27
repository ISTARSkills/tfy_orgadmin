package in.orgadmin.tpo.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.PlacementOfficer;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;


@WebServlet("/invitePlacementOfficer")
public class InvitePlacementOfficer extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		printAttrs(request);
		printParams(request);
		
		String result = "";
			
			if(request.getParameterMap().containsKey("college_id") && request.getParameterMap().containsKey("name") && 
					request.getParameterMap().containsKey("email")){
				
				String collegeID = request.getParameter("college_id");
				String placementOfficerName = request.getParameter("name");
				String placementOfficerEmail = request.getParameter("email");
				
				if(collegeID!=null && placementOfficerName!=null && placementOfficerEmail!=null
						&& !collegeID.trim().isEmpty() && !placementOfficerName.trim().isEmpty() && !placementOfficerEmail.trim().isEmpty()){
					
					RecruiterServices recruiterServices = new RecruiterServices();
					PlacementOfficer placementOfficer = recruiterServices.createPlacementOfficer(Integer.parseInt(collegeID), placementOfficerEmail, placementOfficerName);
					
					if(placementOfficer==null){
						result = "A user with this email already exists, please provide valid email address.";
					}else{
						result = "Thanks! An invitation has been sent to the Placement Officer with password. ";
					}					
				}else{
					result = "Please enter valid Name and Email address.";
				}
				
				response.getWriter().print(result);
				
			}else{
				System.out.println("All required parameters not passed");
			}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
