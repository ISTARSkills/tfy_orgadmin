package tfy.admin.trainer;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

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
import com.viksitpro.core.dao.entities.UserRole;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;
import com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes;

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
		DBUTILS util = new DBUTILS();
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
		for(UserRole userRole :user.getUserRoles())
		{
			if(userRole.getRole().getRoleName().equalsIgnoreCase("TRAINER"))
			{
				String getAssessment ="select course_id, assessment_id from course_assessment_mapping where assessment_id = "+assessmentId;
				List<HashMap<String, Object>>courseAssessment = util.executeQuery(getAssessment);
				for(HashMap<String, Object> row: courseAssessment)
				{
					String courseId = row.get("course_id").toString();
					String findPercentage="select (case when count(*) >0  then cast (((count(*) filter(where correct='t'))*100)/(count(*)) as integer)  else 0 end) as percentage from student_assessment where assessment_id= "+assessmentId+" and student_id = "+user.getId();
					List<HashMap<String, Object>> percentageData = util.executeQuery(findPercentage);
					if(percentageData.size()>0 && percentageData.get(0).get("percentage")!=null)
					{
						int perc = (int)percentageData.get(0).get("percentage");
						int percBenchMark = 0; 
						try {
							Properties  properties = new Properties();
							String propertyFileName = "app.properties";
							InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
							if (inputStream != null) {
								properties.load(inputStream);
								percBenchMark = Integer.parseInt(properties.getProperty("percentage_benchmark"));
							}
						} catch (IOException e) {
							e.printStackTrace();
						}
						String status =TrainerEmpanelmentStatusTypes.REJECTED;
						if(perc>=percBenchMark)
						{
							status = TrainerEmpanelmentStatusTypes.SELECTED;
						}
						String insertIntoEmpanelMentStatus = "INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
								+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+user.getId()+", '"+status+"', now(), 'L3', "+courseId+");";
						util.executeUpdate(insertIntoEmpanelMentStatus);
					}
					
				}
				break;
			}
		}
		response.sendRedirect("/student/dashboard.jsp");
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
