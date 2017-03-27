package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.services.controllers.IStarBaseServelet;
import in.recruitor.utils.RecrutUtils;

@WebServlet("/StudentPaginatorPlacementOfficer")
public class StudentPaginatorPlacementOfficer extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		printAttrs(request);
		
		int thresholdLimit = 15;
		int startIndex = Integer.parseInt(request.getParameter("startIndex"));
		int endIndex = startIndex + thresholdLimit;
			
		String stageID = request.getParameter("stageID");
		String vacancyID = request.getParameter("vacancyID");
		String collegeID = request.getParameter("collegeID");
		String companyID = request.getParameter("companyID");
		
		RecrutUtils recruiterUtils = new RecrutUtils();
		ArrayList<Student> listOfStudents = null;
		
		listOfStudents = recruiterUtils.getUsersForVacancyPaginated(Integer.parseInt(vacancyID), stageID, Integer.parseInt(collegeID), Integer.parseInt(companyID));

		HashMap<Integer, Student> paginatedListOfStudents = new HashMap<Integer, Student>();
		
		System.out.println("All Students: " + listOfStudents.size());
		
		if(startIndex < listOfStudents.size()){
		for(int i=startIndex; i < endIndex && i < listOfStudents.size(); i++){
			//System.out.println("Start index:" + startIndex);
			//System.out.println("Paginated Students: " + paginatedListOfStudents.size());
			paginatedListOfStudents.put(listOfStudents.get(i).getId(), listOfStudents.get(i));
		}
		
		System.out.println("Paginated Students: " + paginatedListOfStudents.size());
		
		request.setAttribute("listOfStudents", paginatedListOfStudents);
		request.setAttribute("stage_id", stageID);
		request.setAttribute("vacancyID",vacancyID);
		request.setAttribute("collegeID",collegeID);
		request.setAttribute("companyID", companyID);
		request.setAttribute("endIndex", endIndex);
		request.getRequestDispatcher("/PlacementOfficer/student_list.jsp").forward(request, response);
		}else{
			System.out.println("All students displayed");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
