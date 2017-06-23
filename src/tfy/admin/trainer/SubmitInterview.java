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
import com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes;

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
		/*course_id
user_id
interviewer_id
comments
is_selected
ratingSkill
   course_id:
14
user_id:
7035
interviewer_id:
3658
comments:
good
is_selected:
true
ratingSkill:
151:4.9,152:0,153:0,154:0,155:0,156:4.7,157:0,158:0,159:3.5,160:0,*/
		String interviewerId = request.getParameter("interviewer_id");
		String stage =request.getParameter("stage");
		String trainerId = request.getParameter("user_id");
		String courseId = request.getParameter("course_id");
		String comments =request.getParameter("comments")!=null? request.getParameter("comments"): "";;
		comments = comments.replaceAll("'", "");
		String isSelected = request.getParameter("is_selected");
		String ratingSkill =  request.getParameter("ratingSkill");
		DBUTILS util = new DBUTILS();
		
		String findPreviousEntries ="select * from interview_rating where trainer_id = "+trainerId+" and course_id = "+courseId+" and stage_type ='"+stage+"'";
		List<HashMap<String, Object>> prevData = util.executeQuery(findPreviousEntries);
		if(prevData.size()==0)
		{
			for(String skillData : ratingSkill.split(",")){
				String skillId = skillData.split(":")[0];
				String  rating = skillData.split(":")[1];
			String insertInInterviewRating ="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), '"+trainerId+"', '"+skillId+"', "+rating+", "+interviewerId+", '"+stage+"', "+courseId+");";
			util.executeUpdate(insertInInterviewRating);
			
			}
			
			String insertComments ="INSERT INTO trainer_comments (id, trainer_id, interviewer_id, stage, course_id, comments)"
					+ " VALUES ((select COALESCE(max(id),0)+1 from trainer_comments), "+trainerId+", "+interviewerId+", '"+stage+"', "+courseId+", '"+comments+"')";
			util.executeUpdate(insertComments);
			String status = TrainerEmpanelmentStatusTypes.REJECTED;
			if(isSelected!=null && Boolean.parseBoolean(isSelected))
			{
				//selected
				status = TrainerEmpanelmentStatusTypes.SELECTED;	
			}
			
			
			String insertIntoStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+trainerId+", '"+status+"', now(), '"+stage+"', "+courseId+");";
			util.executeUpdate(insertIntoStatus);
			
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
