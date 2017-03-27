package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.Assessment;
import com.istarindia.apps.dao.AssessmentDAO;
import com.istarindia.apps.dao.Campaigns;
import com.istarindia.apps.dao.CampaignsDAO;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.CollegeRecruiter;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.RecruiterDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/getRemaningColleges")
public class GetRemaningCollegeNames extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		printAttrs(request);

		if (request.getParameterMap().containsKey("vacancy_id")) {
			
			Vacancy vacancy= null;
			
			if (request.getParameter("vacancy_id") != null) {
				int vacancyId = Integer.parseInt(request.getParameter("vacancy_id"));
				
				StringBuffer sb = new StringBuffer();

				vacancy= (new VacancyDAO()).findById(vacancyId);

				Set<Campaigns> allCampaigns = vacancy.getCampaignses();

				ArrayList<Integer> already_listed_college = new ArrayList<>();
				for (Campaigns c : allCampaigns) {
					already_listed_college.add(c.getCollege().getId());
					System.out.println("COllege with ID already exists: " + c.getCollege().getId());
				}

				RecruiterServices service = new RecruiterServices();
				for (College college : service.getCollegesForRecruiter(vacancy.getRecruiter())) {
					System.out.println("College Name:" + college.getId());
					if (!already_listed_college.contains(college.getId())) {
						System.out.println("Adding College");
						sb.append("<option value='" + college.getId() + "'>" + college.getName() + "</option>");
					} else {
						System.out.println("College already Exists");
					}
				}
				if(sb.length() > 0){
				response.getWriter().print(sb);
				}else{
					response.getWriter().print("<option hidden selected disabled>All Colleges Already Added</option>");
				}
			}
		} else {
			System.out.println("Invalid URL");
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
