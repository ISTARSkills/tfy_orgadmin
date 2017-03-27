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

@WebServlet("/StudentPaginatorRecruiter")
public class StudentPaginatorRecruiter extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		printAttrs(request);
		
		int thresholdLimit = 15;
		int startIndex = Integer.parseInt(request.getParameter("startIndex"));
		int endIndex = startIndex + thresholdLimit;
			
		String stageID = request.getParameter("stageID");
		String vacancyID = request.getParameter("vacancyID");
		String collegeID = "";
		
		RecrutUtils recruiterUtils = new RecrutUtils();
		ArrayList<Student> listOfStudents = null;
		
	if (request.getParameterMap().containsKey("collegeID")) {
			collegeID = request.getParameter("collegeID");
			if(!collegeID.toString().trim().isEmpty()){
				listOfStudents = recruiterUtils.getUsersForVacancyPaginated(Integer.parseInt(vacancyID), stageID, Integer.parseInt(collegeID.toString()));
			}
			else{
				listOfStudents = recruiterUtils.getUsersForVacancyPaginated(Integer.parseInt(vacancyID), stageID);
			}
		}else{
			listOfStudents = recruiterUtils.getUsersForVacancyPaginated(Integer.parseInt(vacancyID), stageID);
		}

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
		request.setAttribute("endIndex", endIndex);
		request.getRequestDispatcher("/recruiter/student_list.jsp").forward(request, response);
		}else{
			System.out.println("All students displayed");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
