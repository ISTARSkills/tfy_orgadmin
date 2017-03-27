package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.Panelist;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

/**
 * Servlet implementation class InviteHiringTeam
 */
@WebServlet("/invite_hiring_team")
public class InviteHiringTeam extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InviteHiringTeam() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String email_ids = request.getParameter("hiring_team_email");
		String vac_id = request.getParameter("vac_id");
		RecruiterServices serv = new RecruiterServices();
		if(!vac_id.equalsIgnoreCase("none") && !email_ids.equalsIgnoreCase("none"))
		{
			Vacancy vacancy = new  VacancyDAO().findById(Integer.parseInt(vac_id));
			String panelist_emails[]= email_ids.split(",");
			IstarUserDAO userdao = new IstarUserDAO();
			for(String emails : panelist_emails)
			{
				List<IstarUser> users = userdao.findByEmail(emails);
				if(users.size()>0)
				{
					IstarUser panelist = users.get(0);
					serv.updateVacancyPanelist(vacancy.getId(),panelist.getId(),vacancy.getRecruiter().getId());
				}
				else
				{
					Panelist panelist = serv.createPanenlist(emails,"Panelist",vacancy);
					serv.updateVacancyPanelist(vacancy.getId(),panelist.getId(),vacancy.getRecruiter().getId());
				}	
			}
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
