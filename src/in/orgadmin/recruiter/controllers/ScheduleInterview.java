package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Panelist;
import com.istarindia.apps.dao.PanelistDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.service.NotificationService;
import com.istarindia.apps.services.controllers.IStarBaseServelet;
import com.publisher.utils.PublishDelegator;

import in.orgadmin.zoom.ZoomService;
import in.recruiter.services.RecruiterServices;

/**
 * Servlet implementation class ScheduleInterview
 */
@WebServlet("/schedule_interview")
public class ScheduleInterview extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       

    public ScheduleInterview() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		
		printParams(request);

		String student_id = request.getParameter("student_id");
		String panelist = request.getParameter("panelist");
		String date = request.getParameter("date");//11/17/2016
		String time = request.getParameter("time");
		boolean threwException = false;
		
		String result = "";
		try{
		if(!date.trim().isEmpty() && !time.trim().isEmpty() && !panelist.trim().isEmpty() && !student_id.trim().isEmpty())
		{
			String pattern_from = "MM/dd/yyyy";
			String pattern_to = "yyyy-MM-dd";
			SimpleDateFormat simpleDateFormat_to = new SimpleDateFormat(pattern_to);
			SimpleDateFormat simpleDateFormat_from = new SimpleDateFormat(pattern_from);
			String d="";
			try {
				 d = simpleDateFormat_to.format(simpleDateFormat_from.parse(date));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			String vacancy_id = request.getParameter("vacancy_id");
			String stage_id = request.getParameter("stage_id");
			//String check_if_exist ="select cast (jobs_event_id  as varchar(50)) from panelist_schedule where panelist_schedule.stage_id='"+stage_id+"' and panelist_schedule.student_id="+student_id;	
			//System.out.println(check_if_exist);
			DBUTILS util = new DBUTILS();
			//List<HashMap<String, Object>> data = util.executeQuery(check_if_exist);
			String jobs_event_id="";
			//if(data.size()>0 && data.get(0).get("jobs_event_id")!=null)
			//{
				
				//delete old schedule 
				String delete_schedule= "delete from panelist_schedule where panelist_schedule.stage_id='"+UUID.fromString(stage_id)+"' and panelist_schedule.student_id="+student_id;	
				util.executeUpdate(delete_schedule);
		//	}
			
				System.out.println("Entered Scheduled Interiew Servlet");
			
			String get_jobs_event_id="select cast (jobs_event.id as varchar) from   jobs_event, istar_task_workflow where jobs_event.status= istar_task_workflow.stage  and jobs_event.task_id = istar_task_workflow.task_id and jobs_event.actor_id = "+student_id+" and istar_task_workflow.id  = '"+UUID.fromString(stage_id)+"'  limit 1";
			System.out.println(get_jobs_event_id);
			List<HashMap<String, Object>> je_data = util.executeQuery(get_jobs_event_id);
			
			if(je_data.size()>0)
			{
				jobs_event_id= (String)je_data.get(0).get("id");
			}	
			
			//Zoom Service Integration
			System.out.println("Integrating ZOom Service");
			StudentDAO studentDAO = new StudentDAO();
			Student student = studentDAO.findById(Integer.parseInt(student_id));
			
			ZoomService zoomService = new ZoomService();
			
			PanelistDAO panelistDAO = new PanelistDAO();
			
			boolean host = true;
			String hostEmail = "";
			for(String str:panelist.split(",")){
				if(str!=null && !str.equalsIgnoreCase("null")){
				System.out.println("Host Email is:" + str);
				Panelist tempPanelist = panelistDAO.findByEmail(str).get(0);
				
				if(host){
					hostEmail = tempPanelist.getEmail();
					System.out.println("Assigning Zoom Host");
					host = false;
				}
				threwException = false;
				}else{
					threwException = true;
				}
			}
			
			HashMap<String, String> meetingURLs = zoomService.createMeeting(hostEmail);
			
			if(!meetingURLs.get("hostURL").trim().toString().isEmpty() && !meetingURLs.get("joinURL").trim().toString().isEmpty() && 
					meetingURLs.get("hostURL")!=null && meetingURLs.get("joinURL")!=null){

			//create new schedule for all panelist
			String insert_panelist_schedule="";
			RecruiterServices serv = new RecruiterServices();
			for(String str: panelist.split(","))
			{
				if(!hostEmail.trim().isEmpty()){
				String uuid= UUID.randomUUID().toString();
				 insert_panelist_schedule+="INSERT INTO panelist_schedule ( 	ID, 	panelist_id, 	student_id, 	event_date, 	vacancy_id, 	stage_id, 	jobs_event_id, 	created_at, 	updated_at, 	url_code, status, zoom_host_url, zoom_join_url, meeting_id, meeting_password) VALUES 	( 		(SELECT 			COALESCE (MAX(ID) + 1, 0) 		FROM 			panelist_schedule), 			(SELECT 				ID 			FROM 				panelist 			WHERE 				email LIKE '%"+str+"%'), 				'"+student_id+"', 				'"+d+" "+time+"',"
						+ " 				'"+vacancy_id+"', 				'"+UUID.fromString(stage_id)+"', 				'"+jobs_event_id+"', 				now(), 				now(),'"+uuid+"','SCHEDULED','"+meetingURLs.get("hostURL")+"','"+meetingURLs.get("joinURL")+"','"+meetingURLs.get("meetingID")+"','"+meetingURLs.get("meetingPassword")+"');  ";						
			
				 	String subject ="Interview Schedule";
					String message="An interview has been scheduled at "+d+" "+time+System.lineSeparator()+""
							+ "Click on this <a href='"+baseURL+"initializeInterview?id="+uuid+"'>Link</a> to start interview.";
					System.out.println(message);
					System.out.println("sending email to "+str);
		        	serv.sendEmail(str, subject, message);
				}else{
					threwException = true;
				}
			}
			
			System.out.println(insert_panelist_schedule);
			util.executeUpdate(insert_panelist_schedule);

			// update jobs event for student
			
			String update_for_student ="update jobs_event set eventdate = '"+d+" "+time+"' where id ='"+UUID.fromString(jobs_event_id)+"';";
			System.out.println(update_for_student);
			util.executeUpdate(update_for_student);
			
			int senderId = Integer.parseInt(request.getParameter("recruiter_id"));
			String notificationMessage = "An interview has been scheduled at "+d+" "+time+System.lineSeparator();
			String notificationSubject = "Job Notification";
			String notificationType = "JOBS";
			String notificationAction = "No Action Required"; // To be done later
			String hiddenID = "No Session";
			ArrayList<String>allReceiverIds = new ArrayList<>();
			allReceiverIds.add(student_id);
			NotificationService service = new NotificationService();
			
					System.out.println("Sending Notification after scheduling inetrview");
					service.createNONEventBasedNotification(notificationMessage, Integer.parseInt(student_id), senderId,
							notificationSubject, notificationType, notificationAction);
					PublishDelegator pd = new PublishDelegator();
					pd.publishAfterCreatingNotification(allReceiverIds, notificationSubject, notificationMessage, hiddenID);				
					System.out.println("Notification Sent after scheduling inetrview");
					
					result = "Interview Scheduled. A notification has been sent to the Student and Panelist(s).";
		}else{
			result = "Oops! Something went wrong with this request while scheduling interview. Please contact Technical Support immediately.";
			System.out.println(result + "Something went wrong with ZOOM SERVICES");
		}
		}
		else{
			threwException = true;
		}
		}catch(Exception e){
			threwException = true;
		}finally{
			
		}
		if(threwException){
		response.getWriter().print("Invalid Request! Please enter all the details correctly!");
		}else{
			response.getWriter().print(result);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
