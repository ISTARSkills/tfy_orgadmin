package tfy.admin.utilities.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class DeleteTrainer
 */
@WebServlet("/delete_trainer")
public class DeleteTrainer extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteTrainer() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String trainerId = request.getParameter("trainer_id");
		DBUTILS util = new DBUTILS();
		String sql ="delete from batch_students where student_id = "+trainerId+"; "
				+ "delete from trainer_presentor where trainer_id = "+trainerId+";"
				+ "  delete from user_org_mapping  where user_id = "+trainerId+";"
				+ " delete from user_role where user_id ="+trainerId+";"
				+ " delete from attendance where user_id ="+trainerId+";"
				+ " delete from attendance where taken_by ="+trainerId+";"
				+ " delete from trainer_feedback where user_id ="+trainerId+";"
				+ " delete from batch_schedule_event where actor_id ="+trainerId+";"
				+ " delete from task_log where task in (select id from task where actor ="+trainerId+");"
				+ " delete from task_log where pm_member ="+trainerId+";"
				+ " delete from task where actor ="+trainerId+";"
				+ " delete from user_profile where user_id ="+trainerId+";"
				+ " delete from professional_profile where user_id ="+trainerId+"; "
				+ "delete from student_assessment where student_id ="+trainerId+";"
				+ " delete from report where user_id ="+trainerId+";"
				+ " delete from istar_user where id = "+trainerId+"";
		
		util.executeUpdate(sql);
		
		response.sendRedirect("/super_admin/utilities/admin_page.jsp");
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
