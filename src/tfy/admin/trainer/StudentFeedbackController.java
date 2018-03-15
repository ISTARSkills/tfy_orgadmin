package tfy.admin.trainer;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class StudentFeedbackController
 */
@WebServlet("/student_feedback")
public class StudentFeedbackController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StudentFeedbackController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		DBUTILS dbutils = new DBUTILS();
		int batch_id = Integer.parseInt(request.getParameter("batch_grp_id"));
		int student_id = Integer.parseInt(request.getParameter("user_id"));
		int trainer_id = Integer.parseInt(request.getParameter("trainer_id"));
		int event_id = Integer.parseInt(request.getParameter("event_id"));

		String comments = request.getParameter("comments");
		String ratingSkill = request.getParameter("rating_skill");

		float projector = 5;
		float internet = 5;
		float trainer_knowledge = 5;
		float trainer_too_fast = 5;
		float class_control_by_trainer = 5;
		float too_tough_content = 5;
		float too_much_theoritic = 5;
		float no_fun_in_class = 5;
		float enough_examples = 5;
		float outside_disturbance = 5;
		float rating = 5;
		float food = 5;
		float hostel = 5;

		if (ratingSkill != null && !ratingSkill.equalsIgnoreCase("")) {
			for (String skillData : ratingSkill.split(",")) {
				String skillId = (skillData.split(":")[0]).trim();
				float skill_value = Float.parseFloat(skillData.split(":")[1]);

				switch (skillId) {
				case "projector":
					projector = skill_value;
					break;
				case "internet":
					internet = skill_value;
					break;
				case "trainer_knowledge":
					trainer_knowledge = skill_value;
					break;
				case "trainer_too_fast":
					trainer_too_fast = skill_value;
					break;
				case "class_control_by_trainer":
					class_control_by_trainer = skill_value;
					break;
				case "too_tough_content":
					too_tough_content = skill_value;
					break;
				case "too_much_theoritic":
					too_much_theoritic = skill_value;
					break;
				case "no_fun_in_class":
					no_fun_in_class = skill_value;
					break;
				case "enough_examples":
					enough_examples = skill_value;
					break;
				case "outside_disturbance":
					outside_disturbance = skill_value;
					break;
				case "food":
					food = skill_value;
					break;
				case "hostel":
					hostel = skill_value;
					break;
				}
			}
		}

		rating =( (projector + internet + trainer_knowledge  + class_control_by_trainer
				+ too_tough_content   + no_fun_in_class  + food + hostel)/ 8);
		
		
		//check if exist ---> delete existed data
		String checkAlreadyGiven="SELECT * from student_feedback where student_id="+student_id+" and event_id="+event_id+" and trainer_id="+trainer_id;
		List<HashMap<String, Object>> data=dbutils.executeQuery(checkAlreadyGiven);
		if(data!=null && data.size()!=0){
			String deleteFeedback="DELETE from student_feedback where student_id="+student_id+" and event_id="+event_id+" and trainer_id="+trainer_id;
			dbutils.executeUpdate(deleteFeedback);
		}

		
		//insert 
		String sql = "INSERT INTO student_feedback (id, batch_id, student_id, projector, internet, trainer_knowledge, trainer_too_fast, class_control_by_trainer, too_tough_content, too_much_theoritic, no_fun_in_class, enough_examples, outside_disturbance, rating, event_id, trainer_id, comment,food,hostel) VALUES ((select COALESCE(max(id),0)+1 from student_feedback),"
				+ " " + batch_id + ", " + student_id + ", " + projector + ", " + internet + ", " + trainer_knowledge
				+ ", " + trainer_too_fast + ", " + class_control_by_trainer + ", " + too_tough_content + ", "
				+ too_much_theoritic + ", " + no_fun_in_class + ", " + enough_examples + ", " + outside_disturbance
				+ ", " + rating + ", " + event_id + ", " + trainer_id + ", '" + comments + "', '" + food + "', '" + hostel + "');";
		ViksitLogger.logMSG(this.getClass().getName(),(sql));
		dbutils.executeUpdate(sql);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
