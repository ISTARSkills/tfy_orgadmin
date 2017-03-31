package in.orgadmin.controller;

import java.io.IOException;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.ClassroomDetails;
import com.viksitpro.core.dao.entities.ClassroomDetailsDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;


/**
 * Servlet implementation class DashboardEventsList
 */
@WebServlet("/dashboard_events_list")
public class DashboardEventsList extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
  
    public DashboardEventsList() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		StringBuffer sb = new StringBuffer();
		String sql= "";
		DBUTILS db = new DBUTILS();

		String event_type = request.getParameter("selectedtab");
		String org_val = request.getParameter("ids");
		
		
		
     if(request.getParameterMap().containsKey("ids") && !(org_val.equalsIgnoreCase(""))){
			

			String col_id =request.getParameter("ids");
			
			String[] seperate_ids = col_id.split(",");
		
			for(String Colid : seperate_ids){
				
				
				if(event_type.equalsIgnoreCase("today")){
				
					
					 sql = "SELECT cast (bse.id as varchar (50)) as eve_id,	bse.eventdate AS bse_event_date, SUBSTRING( bse.event_name, 22) as e_name, 	bse.classroom_id AS class_id,   bse.status as status,  bse.eventhour as d_hrs, bse.eventminute as d_min, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	s. ID AS trainer_id, pin. city AS city, pin.state as state, CAST ( EQE.event_queue_id AS VARCHAR (50) 	) AS event_que "
							+ "FROM 	student s, 	address addr,   pincode pin, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	college org, 	event_queue_events EQE WHERE 	EQE.event_id = bse. ID AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.eventdate >= CURRENT_DATE + INTERVAL '0 hour' AND bse.eventdate <= CURRENT_DATE + INTERVAL '23 hour' AND bse.actor_id = s. ID AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND org.address_id = addr. ID AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND addr.pincode_id = pin.id AND org.id = "+Colid+" ORDER BY 	bse.eventdate 	";
					
					// System.out.println("------------------------------"+sql);
					 
					}else if(event_type.equalsIgnoreCase("all")){
						
						
					sql = "SELECT 	cast (bse.id as varchar (50)) as eve_id, bse.eventdate AS bse_event_date, SUBSTRING( bse.event_name, 22) as e_name,	bse.classroom_id AS class_id,   bse.status as status,  bse.eventhour as d_hrs, bse.eventminute as d_min, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	s. ID AS trainer_id, pin. city AS city, pin.state as state, CAST ( EQE.event_queue_id AS VARCHAR (50) 	) AS event_que"
							+ " FROM 	student s, 	address addr,   pincode pin, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	college org, 	event_queue_events EQE WHERE 	EQE.event_id = bse. ID AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND org.address_id = addr. ID AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND addr.pincode_id = pin.id AND org.id = "+Colid+" ORDER BY 	bse.eventdate DESC	";
				
					// System.out.println("------------------------------"+sql);
					 
					}else if (event_type.equalsIgnoreCase("currentweek")){
						
						Calendar c = GregorianCalendar.getInstance();
				        c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
				      
				        DateFormat dfw = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
				       
				        String startDate = "", endDate = "";
				        startDate = dfw.format(c.getTime());
				        c.add(Calendar.DATE, 5);
				        endDate = dfw.format(c.getTime());
				       
				        
						sql= "SELECT cast (bse.id as varchar (50)) as eve_id,	bse.eventdate AS bse_event_date, 	SUBSTRING (bse.event_name, 22) AS e_name, 	bse.classroom_id AS class_id, 	bse.status AS status, 	bse.eventhour AS d_hrs, 	bse.eventminute AS d_min, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	s. ID AS trainer_id, 	pin.city AS city, 	pin. STATE AS STATE, CAST ( EQE.event_queue_id AS VARCHAR (50) 	) AS event_que "
								+ " FROM 	student s, 	address addr, 	pincode pin, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	college org, 	event_queue_events EQE WHERE 	EQE.event_id = bse. ID AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.eventdate >= '%"+startDate+"%' AND bse.eventdate <= '%"+endDate+"%' AND bse.actor_id = s. ID AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND org.address_id = addr. ID AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND addr.pincode_id = pin. ID AND org.id = "+Colid+" ORDER BY 	bse.eventdate ";
				
						 System.out.println("------------------------------"+sql);
						 
					}else if(event_type.equalsIgnoreCase("month")){
						Calendar c = GregorianCalendar.getInstance();
						String startDate = "", endDate = "";
						     c.set(Calendar.DAY_OF_MONTH,1);
						     DateFormat dfw = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
						     startDate = dfw.format(c.getTime());
						     c.set(Calendar.DAY_OF_MONTH,31);
					         endDate = dfw.format(c.getTime());
					   
						sql= "SELECT cast (bse.id as varchar (50)) as eve_id,	bse.eventdate AS bse_event_date, 	SUBSTRING (bse.event_name, 22) AS e_name, 	bse.classroom_id AS class_id, 	bse.status AS status, 	bse.eventhour AS d_hrs, 	bse.eventminute AS d_min, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	s. ID AS trainer_id, 	pin.city AS city, 	pin. STATE AS STATE, CAST ( EQE.event_queue_id AS VARCHAR (50) 	) AS event_que "
								+ " FROM 	student s, 	address addr, 	pincode pin, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	college org, 	event_queue_events EQE WHERE 	EQE.event_id = bse. ID AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.eventdate >= '%"+startDate+"%' AND bse.eventdate < '%"+endDate+"%' AND bse.actor_id = s. ID AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND org.address_id = addr. ID AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND addr.pincode_id = pin. ID AND org.id = "+Colid+" ORDER BY 	bse.eventdate ";
				
						 System.out.println("------------------------------"+sql);
						
					}
				
		
			
				
		
				
		
		
		List<HashMap<String, Object>> e_data = db.executeQuery(sql);
		
		for (HashMap<String, Object> row : e_data) {
			
			Timestamp event_date = (Timestamp) row.get("bse_event_date");
			SimpleDateFormat dateFormat_new = new SimpleDateFormat("dd MMM yyyy");
			SimpleDateFormat dateFormat_time = new SimpleDateFormat("hh:mm  aa");
			String oldstatus = (String) row.get("status");
			String location = (String) row.get("state");
			String city = (String) row.get("city");
			int org_id = (int) row.get("org_id");
			String org_name = (String) row.get("org_name");
			String e_name = (String) row.get("e_name");
			int trainer_id = (int) row.get("trainer_id");
			String trainer = (String) row.get("trainer_name");
			int class_id = (int)row.get("class_id");
			int duration_min = (int)row.get("d_min");
			int duration_hrs = (int)row.get("d_hrs");
			String event_id = row.get("eve_id").toString().trim();
			String event_que = row.get("event_que").toString().trim();
			String NODATA = "";
			String present = "";
			String absent = "";
			String rating = "N/A";
			String status = "";
			String attendance = "" ;
			String new_ename = e_name.substring(e_name.lastIndexOf("-Ilab") + 1);
			ClassroomDetails cRoom = new ClassroomDetails();
			ClassroomDetailsDAO cRomdao = new ClassroomDetailsDAO();
			cRoom = cRomdao.findById(class_id);
			String classroom_name = cRoom.getClassroomIdentifier();
			if(oldstatus.equalsIgnoreCase("SCHEDULED")){
				status = "SCHEDULED";
			}
			else if(oldstatus.equalsIgnoreCase("STARTED")){
				status = "STARTED";
			}
			else if(oldstatus.equalsIgnoreCase("TEACHING")){
				status = "TEACHING";
			}
			else if(oldstatus.equalsIgnoreCase("REACHED")){
				status = "REACHED";
			}
			else if(oldstatus.equalsIgnoreCase("FEEDBACK")){
				status = " FEEDBACK ";
			}
			else if(oldstatus.equalsIgnoreCase("ATTENDANCE")){
				status = "ATTENDANCE ";
			}
			else if(oldstatus.equalsIgnoreCase("COMPLETED")){
				status = "COMPLETED";
			}
			
			String a_sql = "SELECT 	COUNT (*) FILTER ( WHERE attendance.status = 'PRESENT' ) AS present, 	COUNT (*) FILTER ( WHERE attendance.status = 'ABSENT' ) AS absent FROM 	attendance WHERE 	event_id = '"+event_id+"'";
			
			List<HashMap<String, Object>> a_data = db.executeQuery(a_sql);
			 
			if(a_data.size() != 0 ){
				for (HashMap<String, Object> row1 : a_data) {
					
				present = (BigInteger) row1.get("present")!= BigInteger.valueOf(0) ? row1.get("present").toString() : "0";
				absent = (BigInteger) row1.get("absent")!= BigInteger.valueOf(0) ? row1.get("absent").toString() : "0";
				attendance = present +"/"+absent;
				}
				
			}
		    String f_sql = "SELECT rating FROM trainer_feedback WHERE event_id= '"+event_id+"'";
		    
		    List<HashMap<String, Object>> f_data = db.executeQuery(f_sql);
			 
			if(f_data.size() != 0 ){
				for (HashMap<String, Object> row2 : f_data) {
					
					rating = (int) row2.get("rating")!= 0 ? row2.get("rating").toString() : "0";
				
				}
				
			}
		
			
			if(present.equalsIgnoreCase("0") && absent.equalsIgnoreCase("0")){
				attendance="";
				NODATA = "N/A";
			}
			

			String cStatus = "<button type='button' class='btn btn-primary btn-xs clickable-event' data-event-q='"+event_que+"' style='float: right;'onclick='showSlide(\""+event_id+"\")'>  "+ status  +"</button>";
		
			
			
		sb.append("<div class='contact-box'>");
				
		 sb.append( "<p><i class='fa fa-bank'></i><strong> "+org_name +"</strong><i class='fa fa-slideshare' style='float: right;'> ClassRoom "+classroom_name +"</i></p>");	 
					sb.append( "<p><i class='fa fa-calendar-o'></i> " +new_ename + "</p>");
					sb.append( "<p><i class='fa fa-user'></i> " +trainer + "</p>");
					 sb.append( "<p><a data-toggle='modal' data-attendance-id='"+event_id+"' onclick='showAttendance(\""+event_id+"\")' data-target='#myModal6'><i class='fa fa-slideshare'>Attendance </i> "+attendance + NODATA +""
							+ "</a><i class='fa fa-star'  style=' margin-left: 114px;'></i>Rating "+ rating  +"</p>");	        
		                sb.append( "<p><i class='fa fa-clock-o'></i> "+dateFormat_new.format(event_date) +" - "+dateFormat_time.format(event_date) +
				 "<i class='fa fa-map-marker' style=' margin-left: 60px;'> "+location +","+ city + "</i>"+cStatus+"</p>");	
	
            sb.append( "</div>");

		}
	}
     }
     if(request.getParameterMap().containsKey("event_id")){
    	 
    	 System.out.println(request.getParameter("event_id"));
    	 
    	 String eventID = request.getParameter("event_id");
    	 
    	 String att_sql ="SELECT student.id as s_id, 	student.name as s_name, attendance.status as status FROM 	attendance,   student WHERE student.id = attendance.user_id AND attendance.event_id = '"+eventID+"'";
    	 
    	 List<HashMap<String, Object>> a_data = db.executeQuery(att_sql);
		 
    	 int id = 0 ;
    	 String s_name = "";
    	 String status="";
			if(a_data.size() != 0 ){
				for (HashMap<String, Object> row2 : a_data) {
					
					 id = (int) row2.get("s_id");
					 s_name = (String) row2.get("s_name");
					 status = (String) row2.get("status");
			
				
				
				sb.append("<tr>");
				sb.append("<td>"+id+"</td>");
				sb.append("<td>"+s_name+"</td>");
				sb.append("<td>"+status+"</td>");
				sb.append("</tr>");
				}
       	
			}
    	 
    	 
     }
			
		response.getWriter().print(sb);
    
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
