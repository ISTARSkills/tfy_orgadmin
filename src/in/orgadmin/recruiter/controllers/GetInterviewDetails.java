package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.RecruiterPanelistMapping;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class GetInterviewDetails
 */
@WebServlet("/get_interview_details")
public class GetInterviewDetails extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetInterviewDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		/**
		 * vacancy_id: vacancy_id,
		            	 stage_id: stage_id,
		            	 student_id
		 **/
		
		String vacancy_id = request.getParameter("vacancy_id");
		String stage_id = request.getParameter("stage_id");
		String student_id = request.getParameter("student_id");
		
		Vacancy v = new VacancyDAO().findById(Integer.parseInt(vacancy_id));
		Recruiter r = v.getRecruiter();
		
		
		
		String panelist_emails = "";
		String date="none";
		String time ="none";
		String sql = "select panelist.email, panelist_schedule.event_date from panelist, panelist_schedule "
				+ "where panelist_id = panelist.id and student_id="+student_id+" and vacancy_id = "+vacancy_id+" and stage_id='"+UUID.fromString(stage_id)+"'";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		if(data.size()>0)
		{
			for(HashMap<String, Object> row: data)
			{
				String email = (String) row.get("email");
				panelist_emails+=email+",";
				Timestamp event_date = (Timestamp) row.get("event_date");
				//2016-10-25 23:10:39.845
				String pattern  = "MM-dd-yyyy HH:mm";
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
				String date_time =   simpleDateFormat.format(event_date);//10-25-2016 23:10
				
				 date= date_time.split(" ")[0];
				 time = date_time.split(" ")[1];			
			}
		}
		else
		{
			for(RecruiterPanelistMapping map : r.getRecruiterPanelistMappings())
			{
				panelist_emails+=map.getPanelist().getEmail()+",";
			}
		}	
		
		if(panelist_emails.endsWith(","))
		{
			panelist_emails = panelist_emails.substring(0, panelist_emails.lastIndexOf(","));
		}
		String patter_from ="MM-dd-yyyy";
		String pattern_to  = "MM/dd/yyyy";
		SimpleDateFormat to_format = new SimpleDateFormat(pattern_to);
		SimpleDateFormat from_format = new SimpleDateFormat(patter_from);
		String final_date ="none" ;
		try {
			if(!date.equalsIgnoreCase("none"))
			{
			 final_date = to_format.format(from_format.parse(date));
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			response.getWriter().print(panelist_emails+"##"+final_date+"##"+time);
		
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
