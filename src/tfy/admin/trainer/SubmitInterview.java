package tfy.admin.trainer;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class SubmitInterview
 */
@WebServlet("/submit_interview")
public class SubmitInterview extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SubmitInterview() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String interviewerId = request.getParameter("interviewer_id");
		String stage =request.getParameter("stage");
		String trainerId = request.getParameter("trainer_id");
		String courseId = request.getParameter("course_id");
		DBUTILS util = new DBUTILS();
		
		String findPreviousEntries ="select * from interview_rating where trainer_id = "+trainerId+" and course_id = "+courseId+" and stage_type ='"+stage+"'";
		List<HashMap<String, Object>> prevData = util.executeQuery(findPreviousEntries);
		if(prevData.size()==0)
		{
			for(int i =0; i<10;i++){
				int skillId = i;
				float rating = 0f;
			String insertInInterviewRating ="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), '"+trainerId+"', '"+skillId+"', "+rating+", "+interviewerId+", '"+stage+"', "+courseId+");";
			util.executeUpdate(insertInInterviewRating);
			
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
