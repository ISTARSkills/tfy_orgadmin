package in.talentify.core.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class DeleteGroup
 */
@WebServlet("/delete_group")
public class DeleteGroup extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteGroup() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		String groupId = request.getParameter("group_id");
		DBUTILS util = new DBUTILS();
		String finalSql="";
		String eventSessionLogs = "delete from event_session_log where batch_id in (select id from batch where batch_group_id="+groupId+");";
		finalSql +=eventSessionLogs; 
		String trainerEventLog = "delete from trainer_event_log where batch_id in (select id from batch where batch_group_id="+groupId+");";
		finalSql +=trainerEventLog; 
		String deleteBatchStudents = "delete from batch_students where batch_group_id="+groupId+";";
		finalSql +=deleteBatchStudents; 
		String deleteBatchScheduleEvent ="delete from batch_schedule_event where  batch_group_id="+groupId+";";
		finalSql +=deleteBatchScheduleEvent; 
		String deleteFromBatchStats ="delete from batch_stats where batch_group_id="+groupId+";";
		finalSql +=deleteFromBatchStats; 
		String deleteFromAttendaceStats="delete from attendance_stats where batch_group_id="+groupId+";";
		finalSql +=deleteFromAttendaceStats; 
		String deleteFromBgProgress ="delete from bg_progress where batch_group_id="+groupId+";";
		finalSql +=deleteFromBgProgress; 
		String deleteFromCourseStats ="delete from course_stats where batch_group_id="+groupId+";";
		finalSql +=deleteFromCourseStats; 
		String deleteFromAssessmentEvent ="delete from istar_assessment_event where batch_id in (select id from batch where batch_group_id ="+groupId+");";
		finalSql +=deleteFromAssessmentEvent; 
		String slideChangeLog ="delete from slide_change_log where batch_id in (select id from batch where batch_group_id ="+groupId+");";		
		finalSql +=slideChangeLog; 
		String deleteFromMastery= "delete from mastery_level_per_course where batch_group_id ="+groupId+";";
		finalSql +=deleteFromMastery; 
		String batchGroupMessages ="delete from batch_group_messages where batch_group_id="+groupId+";";
		finalSql +=batchGroupMessages; 
		String deleteFromTrainerBatch= "delete from trainer_batch where batch_id in (select id from batch where batch_group_id="+groupId+");";
		finalSql +=deleteFromTrainerBatch; 
		String deleteBatch = "delete from batch where batch_group_id="+groupId+";";
		finalSql +=deleteBatch; 
		String deleteGroup = "delete from batch_group where id ="+groupId+";";
		finalSql +=deleteGroup;			
		System.out.println(finalSql);
		util.executeUpdate(finalSql);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
