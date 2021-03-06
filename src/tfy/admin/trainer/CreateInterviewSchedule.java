/**
 * 
 */
package tfy.admin.trainer;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Random;

import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TaskItemCategory;

/**
 * @author ISTAR-SKILL
 *
 */
public class CreateInterviewSchedule {

	
	public void createInterviewForTrainer(int coordinatorId, int interviewerId, int intervieweeId, int durationInMinutes, String date, String time, int courseId, String stage)
	{
		DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");
		
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		
		//2012-11-25T12:00:00Z
		
		String dateForDB="";
		try{
			dateForDB = dateformatto.format(dateformatfrom.parse(date));
		}catch(Exception ee)
		{
			ee.printStackTrace();
		}
		
		String dateTime =dateForDB+"T"+time+":00Z";		
		IstarUser interviewer = new IstarUserDAO().findById(interviewerId);
		IstarUser interviewee = new IstarUserDAO().findById(intervieweeId);
		DBUTILS util = new DBUTILS();
		Course course = new CourseDAO().findById(courseId);
		String topic = "Scheduled interview for the profile of Trainer for course "+course.getCourseName();
		topic="";
		String taskTitleForInterviewer = "Scheduled interview with <strong>"+interviewee.getUserProfile().getFirstName()+" ["+interviewee.getEmail()+"]</strong> for the profile of Trainer for Course - <strong>"+course.getCourseName()+"</strong> at "+date+" "+time;
		String taskTitleForInterviee = "Scheduled interview with <strong>"+interviewer.getUserProfile().getFirstName()+" ["+interviewer.getEmail()+"]</strong> for the profile of Trainer for Course - <strong>"+course.getCourseName()+"</strong> at "+date+" "+time;
		
		String interviewData = createZoomSchedule(dateTime, topic, durationInMinutes, interviewer);
		Integer meetingId = null;
		String startUrl = "";
		String joinUrl = "";
		JSONObject data;
		try {
			data = new JSONObject(interviewData);
			 meetingId = (int)data.getInt("id");
			 startUrl = data.getString("start_url");
			 joinUrl = data.getString("join_url");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		if(meetingId!=null)
		{
			{
				//for interviewer			
				String sql ="INSERT INTO task (id, name, description, owner, actor, state,  start_date, end_date, is_active,  created_at, updated_at, item_id, item_type) "
						+ "VALUES ((select COALESCE(max(id),0) +1 from task), '"+taskTitleForInterviewer+"', '"+taskTitleForInterviewer+"', "
								+ ""+coordinatorId+", "+interviewerId+", 'SCHEDULED',CAST ( '"+dateForDB+"' AS TIMESTAMP ) ,(CAST ( '("+dateForDB+")' AS TIMESTAMP ) + INTERVAL '1' MINUTE * ( 60 + "+durationInMinutes+")), 't', now(), now(), "+meetingId+", '"+TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWER+"') returning id;";
				//ViksitLogger.logMSG(this.getClass().getName(),">>>"+sql);
				int taskId =util.executeUpdateReturn(sql);
				
				String insertTaskDetails ="INSERT INTO interview_task_details (id, task_id, course_id, interviewer_id,interviewee_id, start_url, join_url,meeting_id,stage) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_task_details), "+taskId+", "+courseId+", "+interviewerId+","+intervieweeId+",'"+startUrl+"','"+joinUrl+"',"+meetingId+",'"+stage+"');";
				util.executeUpdate(insertTaskDetails);
				
			}
			
			{
				//for interviewee
				String sql ="INSERT INTO task (id, name, description, owner, actor, state,  start_date, end_date, is_active,  created_at, updated_at, item_id, item_type) "
						+ "VALUES ((select COALESCE(max(id),0) +1 from task), '"+taskTitleForInterviee+"', '"+taskTitleForInterviee+"', "
								+ ""+coordinatorId+", "+intervieweeId+", 'SCHEDULED',CAST ( '"+dateForDB+"' AS TIMESTAMP ) ,(CAST ( '("+dateForDB+")' AS TIMESTAMP ) + INTERVAL '1' MINUTE * ( 60 + "+durationInMinutes+")), 't', now(), now(), "+meetingId+", '"+TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWEE+"') returning id;";
				//ViksitLogger.logMSG(this.getClass().getName(),">>>"+sql);
				int taskId =util.executeUpdateReturn(sql);
				
				String insertTaskDetails ="INSERT INTO interview_task_details (id, task_id, course_id, interviewer_id,interviewee_id, start_url, join_url,meeting_id,stage) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_task_details), "+taskId+", "+courseId+", "+interviewerId+","+intervieweeId+",'"+startUrl+"','"+joinUrl+"',"+meetingId+",'"+stage+"');";
				util.executeUpdate(insertTaskDetails);
			}
		}	
		
	}
	
	
	
	public String createZoomSchedule(String dateTime, String topic, int durationInminutes , IstarUser interviewer )
	{
		String tempHostIds[] = {"iVdopKgbTECciWQIe19wHw","J8jNaBXoQTO9UQn-_dv5og","PKXx0r9TQKquG8GYBejRpA","xWB8iMpgSZGpdVXwDIjrag"} ;
		Random r = new Random();
		int Low = 0;
		int High = 3;
		int Result = r.nextInt(High-Low) + Low;
		String hostId = tempHostIds[Result];
		
		String getListOfUsers ="https://api.zoom.us/v1/user/list?api_key=-eTYTcttSBy5NOzlRQNOcg&api_secret=Qb72BtJiGLuOEIN7fAO1mWxUXbSlurNHYNX3";
		ViksitLogger.logMSG(this.getClass().getName(),"get list of users--"+ getListOfUsers);
		try {
			URL obj1 = new URL(getListOfUsers);
			HttpURLConnection con1 = (HttpURLConnection) obj1.openConnection();
			con1.setRequestMethod("POST");
			int responseCode = con1.getResponseCode();
				BufferedReader in1 = new BufferedReader(new InputStreamReader(
						con1.getInputStream()));
				String inputLine1;
				StringBuffer response1 = new StringBuffer();
				while ((inputLine1 = in1.readLine()) != null) {
					response1.append(inputLine1);
				}
				in1.close();					
					
				try {
					org.json.JSONObject	jsonObj = new org.json.JSONObject(response1);
					org.json.JSONArray arr = jsonObj.getJSONArray("users");
					for(int i =0 ; i < arr.length(); i++)
					{
						org.json.JSONObject user = arr.getJSONObject(i);
						String email = user.getString("email");
						String trainerHostId = user.getString("id");
						if(email.trim().equalsIgnoreCase(interviewer.getEmail()))
						{
							hostId= trainerHostId;
							break;
						}								
					}	
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
    			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		String url = "https://api.zoom.us/v1/meeting/create?host_id="+hostId+"&topic="+topic+"&type=2&api_key=-eTYTcttSBy5NOzlRQNOcg&api_secret=Qb72BtJiGLuOEIN7fAO1mWxUXbSlurNHYNX3&start_time="+dateTime+"&duration="+durationInminutes+"&timezone=Asia/Kolkata";
		//ViksitLogger.logMSG(this.getClass().getName(),"c,s,s,,s "+url);
		try {
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			con.setRequestMethod("POST");
			int responseCode = con.getResponseCode();
				BufferedReader in = new BufferedReader(new InputStreamReader(
						con.getInputStream()));
				String inputLine;
				StringBuffer response = new StringBuffer();
				while ((inputLine = in.readLine()) != null) {
					response.append(inputLine);
				}
				in.close();					
				//ViksitLogger.logMSG(this.getClass().getName(),response.toString());
				
    			return response.toString();
    			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		return null;
	}
}
