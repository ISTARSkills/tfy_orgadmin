package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.Date;
import java.util.HashSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

/**
 * Servlet implementation class PublishVacancy
 */
@WebServlet("/publish_vacancy")
public class PublishVacancy extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PublishVacancy() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		//final_student
		//fina_vacancy_id
		RecruiterServices serv = new RecruiterServices();
		List<Student> studensts = new ArrayList<>();
		Set<College> targetedStudentColleges = new HashSet<College>();
		//ArrayList<String> already_added = new ArrayList<>();
		int vacancy_id = Integer.parseInt(request.getParameter("final_vacancy_id"));
		VacancyDAO  vacancyDAO= new VacancyDAO();
		Vacancy vacancy = vacancyDAO.findById(vacancy_id);
		if(request.getParameter("final_student")!=null)
		{
			String stud_ids = request.getParameter("final_student");
			
			if(stud_ids.contains(","))
			{
				for(String str : stud_ids.split(","))
				{
					//if(!already_added.contains(str))
					if(!str.trim().isEmpty())
					{
						Student st = new StudentDAO().findById(Integer.parseInt(str));
						studensts.add(st);
						targetedStudentColleges.add(st.getCollege());
					}					
				}
			}
		}		
		if(studensts.size()>0)
		{
			System.out.println("student size"+studensts.size());
			String jobStage = "TARGETED";

			for (Student student : studensts) {
				if (jobStage != null) {
					serv.createJobsEventForEachStudent(new Date(), 2, 40, vacancy.getRecruiter().getId(), vacancy_id, vacancy.getIstarTaskType().getId().toString(),jobStage, student);
				}
			}
		}

		if(targetedStudentColleges.size() > 0){
			System.out.println("Launching Campaign for Targeted Students College");
		for(College college: targetedStudentColleges){
			serv.addCampaignForTargetedStudents(vacancy_id, college.getId());
		}
		}else{
			System.out.println("NO Campaign Launched for this vacancy");
		}
		
		
		System.out.println("Publishing Vacancy");
		vacancy.setStatus("PUBLISHED");
		
		Session vacanySession = vacancyDAO.getSession();
		
		Transaction addtx = null;
		try {
			addtx = vacanySession.beginTransaction();
			vacancyDAO.attachDirty(vacancy);
			addtx.commit();
		} catch (HibernateException e) {
			if (addtx != null)
				addtx.rollback();
			e.printStackTrace();
		} finally {
			vacanySession.close();
		}
		
		System.out.println("Vacancy Published");
		
		String url = "/recruiter/dashboard.jsp";
		//request.getRequestDispatcher(url).forward(request, response);
		response.sendRedirect(url);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
