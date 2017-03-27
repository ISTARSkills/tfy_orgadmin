package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/create_update_vacancy")
public class CreateORUpdateVacancy extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
	
    public CreateORUpdateVacancy() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		System.out.println("Creating new Vacancy0");
		String vacancyTitle = request.getParameter("title");
		int numberOfPositions = Integer.parseInt(request.getParameter("position"));
		String positionType = request.getParameter("position_type");
		String experienceLevel = request.getParameter("experience_level");
		String positionCategory = request.getParameter("position_category");
		String vacancyDescription = request.getParameter("description");
		String location = request.getParameter("location");
		String salary_range = request.getParameter("salary_range");
		String vacancyID = null;
		int recruiterID = Integer.parseInt(request.getParameter("recruiter_id"));
		boolean isNewVacancy = true;
		Vacancy vacancy;
		System.out.println("Creating new Vacancy1");
		String minimumSalary = salary_range.split(";")[0];
		String maximumSalary = salary_range.split(";")[1];
		System.out.println("Creating new Vacancy2");
		if(request.getParameterMap().containsKey("vacancy_id")){
			System.out.println("New Vacancy");
			isNewVacancy = false;
			vacancyID = request.getParameter("vacancy_id");
		}
		
		RecruiterServices recruiterService = new RecruiterServices();
		
		if(vacancyID==null)
		{		
			vacancy = recruiterService.createVacancy(vacancyTitle, location, vacancyDescription, recruiterID, numberOfPositions, positionCategory, 
					positionType, experienceLevel, minimumSalary, maximumSalary);
			System.out.println("Creating new Vacancy");
		}else
		{
			vacancy = recruiterService.updateVacancy(Integer.parseInt(vacancyID),vacancyTitle, location, vacancyDescription, recruiterID, numberOfPositions, positionCategory, 
					positionType, experienceLevel, minimumSalary, maximumSalary);
			System.out.println("Updating exisiting Vacancy");
		}
		
		vacancyID = vacancy.getId().toString();
		
		response.sendRedirect("/recruiter/vacancy/create_new_vacancy.jsp?vacancy_id="+vacancyID);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
