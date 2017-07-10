package tfy.admin.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TaskItemCategory;

import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class StartRemoteClass
 */
@WebServlet("/start_remote_class")
public class StartRemoteClass extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StartRemoteClass() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		int taskId = Integer.parseInt(request.getParameter("task_id"));
		boolean isAndroidRequest = false;
		if(request.getParameterMap().containsKey("android_request"))
		{
			isAndroidRequest= true;
		}
		
		DBUTILS utils = new DBUTILS();			
		String getTrainerIdForWebinar = "select actor, item_id from task where project_id = (select project_id from task where id = "+taskId+") and item_type ='"+TaskItemCategory.REMOTE_CLASS_TRAINER+"'";
		List<HashMap<String, Object>> trainerData = utils.executeQuery(getTrainerIdForWebinar);
		String trainerId  = "";
		String eventId ="";
		if(trainerData.size()>0)
		{
			trainerId = trainerData.get(0).get("actor").toString();
			eventId =  trainerData.get(0).get("item_id").toString();
		}		
		
		String getStartUrl ="select action, actor_id from batch_schedule_event where id = (select item_id from task where id = "+taskId+")";
		List<HashMap<String, Object>> webinarData = utils.executeQuery(getStartUrl);
		String Url ="";
		
		String actor = "";
		if(webinarData.size()>0)
		{
			Url = webinarData.get(0).get("action").toString();
			
			actor =  webinarData.get(0).get("actor_id").toString();
		}
		if(!trainerId.equalsIgnoreCase("") && !actor.equalsIgnoreCase(""))
		{
			if(trainerId.equalsIgnoreCase(actor))
			{
				//this is trainer who clicked on start url 
				//mark attendance of all students as absent if no entry is thr.
				//if already an entry is thr then dont do any thing.
				String findAllWebinarAttendees="select distinct  actor from task where project_id =(select project_id from task where id = "+taskId+") and item_type !='"+TaskItemCategory.REMOTE_CLASS_PRESENTOR+"'";
				List<HashMap<String, Object>> attendeesData = utils.executeQuery(findAllWebinarAttendees);
				for(HashMap<String, Object> attendeeRow : attendeesData)
				{
					int attendee = (int)attendeeRow.get("actor");
					
						String findIfRecordExist="select cast( count(*) as integer) as already_count from attendance where user_id="+attendee+" and event_id="+eventId+"";
						List<HashMap<String, Object>> prevData = utils.executeQuery(findIfRecordExist);
						if(prevData!=null && prevData.size()>0 && (int)prevData.get(0).get("already_count")==0){
							if(attendee==Integer.parseInt(trainerId))
							{
								//mark as trainer as  present
								/*String insertIntoAttendance="INSERT INTO attendance (id, taken_by, user_id, status, created_at, updated_at, event_id) "
										+ "VALUES ((select  COALESCE(max(id),0)+1 from attendance), "+trainerId+", "+attendee+", 'PRESENT', now(), now(), "+eventId+");";
								utils.executeUpdate(insertIntoAttendance);*/
							}
							else
							{
								//mark as student as absent default
								String insertIntoAttendance="INSERT INTO attendance (id, taken_by, user_id, status, created_at, updated_at, event_id) "
										+ "VALUES ((select  COALESCE(max(id),0)+1 from attendance), "+trainerId+", "+attendee+", 'ABSENT', now(), now(), "+eventId+");";
								utils.executeUpdate(insertIntoAttendance);															
							}	
						}
					
				}
				
			}else
			{
				Url = "/student/sync_class.jsp?task_id="+taskId;
				
				//mark attendance as present if not record is thr 
				String findIfRecordExist="select cast( count(*) as integer) as already_count from attendance where user_id="+actor+" and event_id="+eventId+"";
				List<HashMap<String, Object>> prevData = utils.executeQuery(findIfRecordExist);
				if(prevData!=null && prevData.size()>0 && (int)prevData.get(0).get("already_count")==0){
					//insert one as present
					String insertIntoAttendance="INSERT INTO attendance (id, taken_by, user_id, status, created_at, updated_at, event_id) "
							+ "VALUES ((select  COALESCE(max(id),0)+1 from attendance), "+trainerId+", "+actor+", 'PRESENT', now(), now(), "+eventId+");";
					utils.executeUpdate(insertIntoAttendance);
				}
				else
				{
					//update as present
					String updateAttendance="update attendance set status ='PRESENT' where event_id="+eventId+" and user_id="+actor;
					utils.executeUpdate(updateAttendance);
				}	
			}	
		}
		if(!isAndroidRequest)
		{
			response.sendRedirect(Url);
		}
		else
		{
			response.getWriter().write("200");
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
