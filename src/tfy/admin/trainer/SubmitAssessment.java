package tfy.admin.trainer;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.android.pojo.AssessmentPOJO;
import com.istarindia.android.pojo.QuestionPOJO;
import com.istarindia.android.pojo.QuestionResponsePOJO;
import com.istarindia.android.pojo.RestClient;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class SubmitAssessment
 */
@WebServlet("/submit_assessment")
public class SubmitAssessment extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SubmitAssessment() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		/*Param -> question_time_taken_1 : Value ->-6
Param -> option_for_question_385 : Value ->1695
Param -> question_time_taken_2 : Value ->-8
Param -> option_for_question_386 : Value ->1700
Param -> question_time_taken_3 : Value ->-11*/
		String assessmentId = request.getParameter("assessment_id");
		IstarUser user = (IstarUser)request.getSession().getAttribute("user"); 
		String taskId = request.getParameter("task_id");
		RestClient client = new  RestClient();
		AssessmentPOJO assessment = client.getAssessment(Integer.parseInt(assessmentId), user.getId());
		ArrayList<QuestionResponsePOJO> asses_response = new ArrayList<>();
		for(QuestionPOJO que : assessment.getQuestions())
		{
			QuestionResponsePOJO queResponse = new QuestionResponsePOJO();
			queResponse.setQuestionId(que.getId());			
			if(request.getParameterMap().containsKey("option_for_question_"+que.getId()))
			{
				
				if(request.getParameterValues("option_for_question_"+que.getId())!=null)
				{	ArrayList<Integer>options = new ArrayList<>();
					String ops[] = request.getParameterValues("option_for_question_"+que.getId()); 
					for(String optionId : ops)
					{
						options.add(Integer.parseInt(optionId));
					}
					queResponse.setOptions(options);
				}
				if(request.getParameterMap().containsKey("question_time_taken_"+que.getId()))
				{
					if(request.getParameter("question_time_taken_"+que.getId())!=null)
					{
						String timeTaken = request.getParameter("question_time_taken_"+que.getId());
						queResponse.setDuration(Integer.parseInt(timeTaken));
					}
				}
			}
			asses_response.add(queResponse);						
		}				
		client.SubmitAssessment(Integer.parseInt(taskId),user.getId(), asses_response, Integer.parseInt(assessmentId));
		response.sendRedirect("/index.jsp");
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
