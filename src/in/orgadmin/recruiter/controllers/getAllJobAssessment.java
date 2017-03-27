package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.Assessment;
import com.istarindia.apps.dao.AssessmentDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class getAllJobAssessment
 */
@WebServlet("/get_all_job_assessment")
public class getAllJobAssessment extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getAllJobAssessment() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		List<Assessment> assess = new AssessmentDAO().findByProperty("category", "JOBS");
		
		StringBuffer sb = new StringBuffer();
		sb.append("<option value='none' disabled selected>Select Test</option>");
		
		for(Assessment ass:assess){
			
			sb.append("<option value='"+ass.getId()+"'>"+ass.getLesson().getTitle()+"</option>");
		}
		
		response.getWriter().print(sb);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
