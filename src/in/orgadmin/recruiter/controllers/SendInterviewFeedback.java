package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/sendInterviewFeedback")
public class SendInterviewFeedback extends IStarBaseServelet{
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		printParams(request);
		String result = "";
		String failed = "";
		boolean invalidRequest = false;

		
		if(request.getParameterMap().containsKey("interviewResult")){
		String interviewResult = request.getParameter("interviewResult");
		String skillRating= request.getParameter("interviewResultMap");
		String interviewFeedback = request.getParameter("interviewFeedback");
		String uniqueURLCode = request.getParameter("uniqueURLCode");
		
		System.out.println(interviewResult);
		HashMap<String, String> skillRatingMap = new HashMap<String, String>();
		
		System.out.println("SkillRating" +skillRating);
		
		skillRating = skillRating.substring(1).substring(0, (skillRating.length()-2));
		
		System.out.println("SkillRating" +skillRating);
		
		if(!skillRating.trim().isEmpty()){
			for(String element : skillRating.split(",")){
				if(!element.trim().isEmpty()){
					System.out.println("SKILL->" + element);
				String[] skill = element.split(":");
				
				if(!skill[0].equalsIgnoreCase("undefined") && !skill[1].equalsIgnoreCase("undefined") && (skill[0]!=null && skill[1]!=null)){
				skillRatingMap.put(skill[0], skill[1]);
				System.out.println("ID->" +skill[0] +" and Rating->"+ skill[1]);
				}else{
					System.out.println("Please enter rating for all the skills");
					failed = "Please enter rating for all the skills.";
					invalidRequest = true;
				}
				}
			}
		}
		
		RecruiterServices recruiterServices = new RecruiterServices();
		
			if (!uniqueURLCode.trim().isEmpty() && !interviewResult.trim().isEmpty() && !skillRatingMap.isEmpty()) {
				recruiterServices.sendInterviewFeedback(uniqueURLCode, interviewResult, interviewFeedback);
				recruiterServices.insertMultipleSkillRatingsFromPanelist(uniqueURLCode, skillRatingMap);
				result = "Feedback Submitted! Thanks for your efforts. You can close the browser window now";
			}

		}
		
		if(invalidRequest){
			response.getWriter().print(failed);
		}else{
		response.getWriter().print(result);	
		}
	}
}
