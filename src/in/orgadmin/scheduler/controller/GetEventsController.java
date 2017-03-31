package in.orgadmin.scheduler.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class GetEventsController
 */
@WebServlet("/get_events_controller")
public class GetEventsController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetEventsController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//start=2016-05-01&end=2016-06-12&_=1489047943656
		String getEvent ="";
		if(request.getParameterMap().containsKey("org_id"))
		{
			if(request.getParameterMap().containsKey("course_id"))
			{
				//getting events for a course in a college
				String org_id = request.getParameter("org_id");
				String course_id = request.getParameter("course_id");
				getEvent="SELECT 	bse.eventdate AS START, 	bse.eventdate + ( 		( 			(bse.eventhour * 60) + bse.eventminute 		) * INTERVAL '1 minute' 	) AS END,  bse.event_name AS event_name,  CAST (bse. ID AS VARCHAR(50)) AS ID,  ( 	(bse.eventhour * 60) + bse.eventminute ) AS duration,  bse.status AS status,  org. ID AS org_id,  org. NAME AS orgname,  s. first_name AS trainer_name,  bse.batch_id AS batch_id,  s. user_id AS trainer_id,  CD.classroom_identifier AS classroom,  CD. ID AS class_id,  B. NAME AS batch_name,  B. NAME || ', ' || s. first_name AS title,  'Batch Name: ' || B. NAME || '<br/>Org Name: ' || org. NAME || ' <br/>Classroom (ID): Room No. ' || CD.classroom_identifier || '.<br/>Duration: ' || ( 	(bse.eventhour * 60) + bse.eventminute ) || ' mins.<br/> Event Time: ' || bse.eventdate || '<br/>Trainer: ' || s. first_name || ' <br/> Status: ' || bse.status AS description FROM 	user_profile s, user_role ur, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s.user_id AND s.user_id = ur.user_id AND ur.role_id = 14 AND event_name NOT LIKE '%TEST%' AND bse. TYPE LIKE '%EVENT_TRAINER%' AND org.id  = "+org_id+" AND b.course_id ="+course_id;
				System.out.println("on coursepage"+getEvent);	
			}
			else if (request.getParameterMap().containsKey("batch_id"))
			{
				//getting events for a batch
				String batch_id = request.getParameter("batch_id");
				getEvent="SELECT 	bse.eventdate AS START, 	bse.eventdate + ( 		( 			(bse.eventhour * 60) + bse.eventminute 		) * INTERVAL '1 minute' 	) AS END,  bse.event_name AS event_name,  CAST (bse. ID AS VARCHAR(50)) AS ID,  ( 	(bse.eventhour * 60) + bse.eventminute ) AS duration,  bse.status AS status,  org. ID AS org_id,  org. NAME AS orgname,  s. first_name AS trainer_name,  bse.batch_id AS batch_id,  s. user_id AS trainer_id,  CD.classroom_identifier AS classroom,  CD. ID AS class_id,  B. NAME AS batch_name,  B. NAME || ', ' || s. first_name AS title,  'Batch Name: ' || B. NAME || '<br/>Org Name: ' || org. NAME || ' <br/>Classroom (ID): Room No. ' || CD.classroom_identifier || '.<br/>Duration: ' || ( 	(bse.eventhour * 60) + bse.eventminute ) || ' mins.<br/> Event Time: ' || bse.eventdate || '<br/>Trainer: ' || s. first_name || ' <br/> Status: ' || bse.status AS description FROM 		user_profile s, user_role ur, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s.user_id AND s.user_id = ur.user_id AND ur.role_id = 14 AND event_name NOT LIKE '%TEST%' AND bse. TYPE LIKE '%EVENT_TRAINER%' AND bse.batch_id = "+batch_id;
				System.out.println("on batchpage"+getEvent);	
			}
			else
			{
				//getting events for an organization
				String org_id = request.getParameter("org_id");
				getEvent="SELECT 	bse.eventdate AS START, 	bse.eventdate + ( 		( 			(bse.eventhour * 60) + bse.eventminute 		) * INTERVAL '1 minute' 	) AS END,  bse.event_name AS event_name,  CAST (bse. ID AS VARCHAR(50)) AS ID,  ( 	(bse.eventhour * 60) + bse.eventminute ) AS duration,  bse.status AS status,  org. ID AS org_id,  org. NAME AS orgname,  s.first_name AS trainer_name,  bse.batch_id AS batch_id,  s. user_id AS trainer_id,  CD.classroom_identifier AS classroom,  CD. ID AS class_id,  B. NAME AS batch_name,  B. NAME || ', ' || s.first_name AS title,  'Batch Name: ' || B. NAME || '<br/>Org Name: ' || org. NAME || ' <br/>Classroom (ID): Room No. ' || CD.classroom_identifier || '.<br/>Duration: ' || ( 	(bse.eventhour * 60) + bse.eventminute ) || ' mins.<br/> Event Time: ' || bse.eventdate || '<br/>Trainer: ' || s. first_name || ' <br/> Status: ' || bse.status AS description FROM 	user_profile s, user_role ur, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s.user_id AND s.user_id = ur.user_id AND ur.role_id = 14 AND event_name NOT LIKE '%TEST%' AND bse. TYPE LIKE '%EVENT_TRAINER%' AND org. ID = "+org_id;
				System.out.println("on dashboard"+getEvent);
				
			}	
		}
		
		else 
		{
			//getting all events
			getEvent="SELECT 	bse.eventdate AS START, 	bse.eventdate + ( 		( 			(bse.eventhour * 60) + bse.eventminute 		) * INTERVAL '1 minute' 	) AS END,  bse.event_name AS event_name,  CAST (bse. ID AS VARCHAR(50)) AS ID,  ( 	(bse.eventhour * 60) + bse.eventminute ) AS duration,  bse.status AS status,  org. ID AS org_id,  org. NAME AS orgname,  s.first_name AS trainer_name,  bse.batch_id AS batch_id,  s. user_id AS trainer_id,  CD.classroom_identifier AS classroom,  CD. ID AS class_id,  B. NAME AS batch_name,  B. NAME || ', ' || s.first_name AS title,  'Batch Name: ' || B. NAME || '<br/>Org Name: ' || org. NAME || ' <br/>Classroom (ID): Room No. ' || CD.classroom_identifier || '.<br/>Duration: ' || ( 	(bse.eventhour * 60) + bse.eventminute ) || ' mins.<br/> Event Time: ' || bse.eventdate || '<br/>Trainer: ' || s. first_name || ' <br/> Status: ' || bse.status AS description FROM 	user_profile s, user_role ur, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s.user_id AND s.user_id = ur.user_id AND ur.role_id = 14 AND event_name NOT LIKE '%TEST%' AND bse. TYPE LIKE '%EVENT_TRAINER%'";
			System.out.println("on all events"+getEvent);
		}
		
		String rangeQuery="";
		if(request.getParameterMap().containsKey("start"))
		{
			String start = request.getParameter("start");
			rangeQuery+=" and cast ( bse.eventdate as date) >= cast('"+start+"' as date )";
		}
		if(request.getParameterMap().containsKey("end"))
		{
			String endDate = request.getParameter("end");
			rangeQuery+=" and cast ( bse.eventdate as date) <= cast('"+endDate+"' as date)";	
		}
		
		getEvent +=rangeQuery; 
				
				
		String mainJson = "";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(getEvent);
		HashMap<String, String> statusColor = new HashMap<>();
		statusColor.put("ASSESSMENT","#fbc02d");
		statusColor.put("SCHEDULED","#A9CCE3");
		statusColor.put("STARTED","#C0392B");
		statusColor.put("TEACHING","#58D68D");		
		statusColor.put("ATTENDANCE","#F7DC6F");
		statusColor.put("FEEDBACK","#DC7633");
		statusColor.put("COMPLETED","#626567");
		statusColor.put("REACHED","#FF00FF");
		
		

		
		// 
		for(HashMap<String, Object> row: data)
		{
			
			String eventJson="{";
			String status =(String)row.get("status");
			eventJson+="\"color\": \""+statusColor.get(status)+"\", "+System.lineSeparator();
			
			for(String key : row.keySet())
			{
			
				eventJson+="\""+key+"\": \""+row.get(key).toString().replaceAll("	", " ").replaceAll("\\+", "").trim()+"\","+System.lineSeparator();
			}			
			eventJson= eventJson.replaceAll(",$", "");
			
			//eventJson+="\"start\" : \""+row.get("start")+"\",";
			//eventJson+="\"title\" : \""+row.get("title").toString().replaceAll("	", " ").replaceAll("\\+", "").trim()+"\"";
			eventJson+="}"+System.lineSeparator();
			mainJson+=eventJson+",";
		}	
		mainJson = mainJson.replaceAll(",$", "");
		
		response.getWriter().println("["+mainJson+"]");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
