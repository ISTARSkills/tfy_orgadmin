package tfy.admin.controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.controllers.IStarBaseServelet;
import tfy.admin.services.StudentPlayListServicesAdmin;
import tfy.admin.services.StudentSkillMapService;

/**
 * Servlet implementation class AutoSchedule
 */
@WebServlet("/auto_schedule")
public class AutoSchedule extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AutoSchedule() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/*Parameter Name - schedule_days, Value - scheduled_days=MON&scheduled_days=FRI
Parameter Name - start_date, Value - 05/02/2017
Parameter Name - end_date, Value - 05/17/2017
Parameter Name - scheduler_total_lessons, Value - 23
Parameter Name - type, Value - checking*/
		printparams(request);
		DBUTILS util= new DBUTILS();
		String start_date= request.getParameter("start_date");
		String end_date= request.getParameter("end_date");
		int scheduler_total_lessons= Integer.parseInt(request.getParameter("scheduler_total_lessons"));
		String type= request.getParameter("type");
		String days [] = request.getParameterValues("scheduled_days[]");
		ArrayList<Integer> daysList = new ArrayList<>();
		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
		if(days==null)
		{
			daysList.add(Calendar.SUNDAY);
			daysList.add(Calendar.MONDAY);
			daysList.add(Calendar.TUESDAY);
			daysList.add(Calendar.WEDNESDAY);
			daysList.add(Calendar.THURSDAY);
			daysList.add(Calendar.FRIDAY);
			daysList.add(Calendar.SATURDAY);
		}
		else
		{
			//ViksitLogger.logMSG(this.getClass().getName(),days.length);
			for(String day: days)
			{
				if(day.equalsIgnoreCase("SUN"))
				{
					daysList.add(Calendar.SUNDAY);
				}else if(day.equalsIgnoreCase("MON"))
				{
					daysList.add(Calendar.MONDAY);
				}else if(day.equalsIgnoreCase("TUE"))
				{
					daysList.add(Calendar.TUESDAY);
				}else if(day.equalsIgnoreCase("WED"))
				{
					daysList.add(Calendar.WEDNESDAY);
				}else if(day.equalsIgnoreCase("THU"))
				{
					daysList.add(Calendar.THURSDAY);
				}else if(day.equalsIgnoreCase("FRI"))
				{
					daysList.add(Calendar.FRIDAY);
				}else if(day.equalsIgnoreCase("SAT"))
				{
					daysList.add(Calendar.SATURDAY);
				} 
			}
		}	
		
		
		Date startDate = new Date();
		Date endDate= new Date();
		try {
			startDate = df.parse(start_date);
			endDate = df.parse(end_date);;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		if(type.equalsIgnoreCase("checking"))
		{
									
			int workingDays = getWorkingDaysBetweenTwoDates(startDate, endDate, daysList);
			//ViksitLogger.logMSG(this.getClass().getName(),"woking days"+workingDays);
			if(workingDays!=0){
				if(scheduler_total_lessons<=workingDays)
				{
					response.getWriter().write("1 task can be scheduled per available day."); 
				}
				else
				{
					int freq = (int)Math.ceil((double)scheduler_total_lessons/workingDays); 
					response.getWriter().write(freq+" task can be scheduled per day for "+workingDays+" days"); 
				}
			}
			else
			{
				response.getWriter().write("No days found to schedule learn task."); 
			}	
		}
		else 
		{
			String scheduler_course_id = request.getParameter("scheduler_course_id");
			String scheduler_entity_id = request.getParameter("scheduler_entity_id");
			String scheduler_entity_type = request.getParameter("scheduler_entity_type");
			int stuCount=0;
			ArrayList<Integer> users = new ArrayList<>();
			if(scheduler_entity_type.equalsIgnoreCase("USER"))
			{
				users.add(Integer.parseInt(scheduler_entity_id));
				stuCount = 1;
			}
			else
			{
				String sql= "select distinct student_id from batch_students where batch_group_id= "+scheduler_entity_id;
				List<HashMap<String, Object>> data = util.executeQuery(sql);
				for(HashMap<String, Object> row: data)
				{
					int stuId = (int) row.get("student_id");
					users.add(stuId);
					stuCount++;
				}
			}
			ArrayList<Integer> modules = new ArrayList<>();
			ArrayList<Integer> cmsessions = new ArrayList<>();
			ArrayList<Integer> lessons = new ArrayList<>();
			String playListData = "SELECT 	lesson_cmsession.lesson_id, 	lesson_cmsession.cmsession_id, 	cmsession_module.module_id, 	module_course.course_id FROM 	module_course, 	cmsession_module, 	lesson_cmsession, lesson WHERE lesson.is_published = 't' and lesson.is_deleted!='t' and lesson.id = lesson_cmsession.lesson_id AND module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND module_course.course_id = "+scheduler_course_id+" ORDER BY 	module_course.oid, 	cmsession_module.oid, 	lesson_cmsession.oid";
			List<HashMap<String, Object>>  pldata = util.executeQuery(playListData);
			for(HashMap<String, Object> cdata : pldata)
			{
				int mid = (int)cdata.get("module_id");
				modules.add(mid);
				int cmid = (int)cdata.get("cmsession_id");
				cmsessions.add(cmid);
				int lid = (int)cdata.get("lesson_id");
				lessons.add(lid);
			}
			int workingDays = getWorkingDaysBetweenTwoDates(startDate, endDate, daysList);
			int freq =0;
			int total_scheduled_days = 0;
			if(workingDays>0)
			{
				freq = (int)Math.ceil((double)scheduler_total_lessons/workingDays);
				
				total_scheduled_days = (int)Math.ceil((double)scheduler_total_lessons/freq);
				//ViksitLogger.logMSG(this.getClass().getName(),"freq>>"+freq);
				String autoData ="INSERT INTO auto_scheduler_data (id, entity_type, entity_id, course_id, student_count, start_date, end_date, scheduled_days, scheduled_days_count,tasks_per_day) VALUES "
						+ "((select COALESCE(max(id),0)+1 from auto_scheduler_data), '"+scheduler_entity_type+"', "+scheduler_entity_id+", "+scheduler_course_id+", "+stuCount+", '"+new Timestamp(startDate.getTime())+"', '"+new Timestamp(endDate.getTime())+"', '"+ String.join(",", days)+"', "+total_scheduled_days+","+freq+");";
				//ViksitLogger.logMSG(this.getClass().getName(),autoData);
				util.executeUpdate(autoData);				
				createTaskBetweenTwoDates(startDate, endDate, daysList,workingDays,users, modules, cmsessions, lessons, scheduler_course_id, freq);
			}		
			
			response.getWriter().write(freq+"!#"+total_scheduled_days);
			 
		}	
		
	}
	
	private void createTaskBetweenTwoDates(Date startDate, Date endDate, ArrayList<Integer> daysList, int totalDays, ArrayList<Integer> users, 
			ArrayList<Integer> modules, ArrayList<Integer> cmsessions, ArrayList<Integer> lessons, String scheduler_course_id, int freq) {
	    Calendar startCal = Calendar.getInstance();
	    startCal.setTime(startDate);        
	    Calendar endCal = Calendar.getInstance();
	    endCal.setTime(endDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+startDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+endDate);
	    int workDays = 0;
	    int currentOrderId=0;
	    //Return 0 if start and end are the same
	    if (startCal.getTimeInMillis() == endCal.getTimeInMillis()) {
	        return ;
	    }

	    if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
	        startCal.setTime(endDate);
	        endCal.setTime(startDate);
	    }
	    
	    
	    endCal.add(Calendar.DATE, 1);
	    
	    
	    
	    int daysCount=0;
	    DBUTILS util = new DBUTILS();
	    String insertIntoProject ="INSERT INTO project (id, name, created_at, updated_at, creator, active) VALUES ((select COALESCE(max(id),0)+1 from project), 'Auto Schedule of Course with id "+scheduler_course_id+"', now(), now(),  300, 't') returning id;";
		 int projectId = util.executeUpdateReturn(insertIntoProject);
	    
		 
	    for(Date sd = startCal.getTime(); sd.before(endCal.getTime()); )
	    {
	    	//ViksitLogger.logMSG(this.getClass().getName(),"chedking for "+sd);
	    	if(daysCount<=totalDays)
	    	{
	    		if (daysList.contains(startCal.get(Calendar.DAY_OF_WEEK))) {
		    		Date taskDate = startCal.getTime();
		        	//ViksitLogger.logMSG(this.getClass().getName(),"creatting task for date+"+taskDate);		        	
		        	for(int stid : users)
		        	{
		        		int cid=Integer.parseInt(scheduler_course_id);
		        		for(int i=0;i<freq;i++){
		        			int orderId = currentOrderId+i;
			        		if(orderId<lessons.size()){
			        			int mid = modules.get(orderId);
				        		int cms = cmsessions.get(orderId);
				        		int lid = lessons.get(orderId);
				        		scheduleTask(stid, cid, mid, cms, lid, taskDate,projectId);
			        		}
			        			
		        		}
		        	}
		        	currentOrderId = currentOrderId+freq;
		        	daysCount++;
		        }
	    	}
	    	else
	    	{
	    		break;
	    	}	
	    	
	    	startCal.add(Calendar.DATE, 1);
	    	sd = startCal.getTime();
	    }
	    
	    /*for(int daysCount=0; daysCount< totalDays; )
	    {
	    	
	    	 if (daysList.contains(startCal.get(Calendar.DAY_OF_WEEK)) && currentOrderId< lessons.size()) {
		        	Date taskDate = startCal.getTime();
		        	//ViksitLogger.logMSG(this.getClass().getName(),"creatting task for date+"+taskDate);		        	
		        	for(int stid : users)
		        	{
		        		int cid=Integer.parseInt(scheduler_course_id);
		        		for(int i=0;i<freq;i++){
		        			int orderId = currentOrderId+i;
			        		if(orderId<lessons.size()){
			        			int mid = modules.get(orderId);
				        		int cms = cmsessions.get(orderId);
				        		int lid = lessons.get(orderId);
				        		scheduleTask(stid, cid, mid, cms, lid, taskDate);
			        		}
			        			
		        		}
		        	}		            
		            currentOrderId = currentOrderId+freq;
		            daysCount++;
		        }
	    	 startCal.add(Calendar.DATE, 1);
	    	 //ViksitLogger.logMSG(this.getClass().getName(),"checkig for "+startCal.getTime());
	    }*/
	    
	   
	}

	private void scheduleTask(int stid, int cid, int mid, int cms, int lid, Date taskDate, int projectId) {
		Date endate = new Date();
		Calendar c = Calendar.getInstance(); 
		c.setTime(taskDate); 
		c.add(Calendar.DATE, 1);
		endate = c.getTime();
		
		DBUTILS util = new DBUTILS();
		Integer taskId = null;
		Lesson lesson = new LessonDAO().findById(lid);
		String taskTitle = lesson.getTitle().toString();
		String taskDescription = lesson.getDescription()!=null ? lesson.getDescription(): "NA";
		String lessonType = "LESSON";
		int itemId = lesson.getId();
		boolean createEvent = false;;
		StudentSkillMapService serv = new StudentSkillMapService();
		
		if(lesson.getType().equalsIgnoreCase("ASSESSMENT"))
		{
			lessonType = "ASSESSMENT";
			itemId = Integer.parseInt(lesson.getLessonXml());
			Double maxPointsForItem = serv.getMaxPointsOfAssessment(itemId);
			if(maxPointsForItem!=null && maxPointsForItem>0)
			{
				createEvent = true;
			}
		}
		else
		{
			createEvent= true;
		}	
		
		if(createEvent)
		{
			String checkIfTaskExist ="select id from task where actor="+stid+" and item_id="+itemId+" and item_type='"+lessonType+"' and cast (start_date  as date) = cast (now() as date)";
			List<HashMap<String, Object>> alreadyAvailbleTask = util.executeQuery(checkIfTaskExist);
			if(alreadyAvailbleTask.size()==0)
			{
				String sql ="INSERT INTO task (id, name, description, owner, actor, state,  start_date, end_date, is_active,  created_at, updated_at, item_id, item_type, project_id) "
						+ "VALUES ((select COALESCE(max(id),0) +1 from task), '"+taskTitle.replaceAll("'", "")+"', '"+taskDescription.replaceAll("'", "")+"', 300, "+stid+", 'SCHEDULED', '"+new Timestamp(taskDate.getTime())+"','"+new Timestamp(endate.getTime()) +"', 't', now(), now(), "+itemId+", '"+lessonType+"', "+projectId+") returning id;";
				//ViksitLogger.logMSG(this.getClass().getName(),">>>"+sql);
				taskId = util.executeUpdateReturn(sql); 
				
				//TaskServices taskService = new TaskServices();
				StudentPlayListServicesAdmin playListService = new StudentPlayListServicesAdmin();
				playListService.createStudentPlayList(stid,cid, mid, cms,  lid,taskId);
			}
		}			
		
		
		
	}

	public static int getWorkingDaysBetweenTwoDates(Date startDate, Date endDate, ArrayList<Integer> days) {
	    Calendar startCal = Calendar.getInstance();
	    startCal.setTime(startDate);        

	    Calendar endCal = Calendar.getInstance();
	    endCal.setTime(endDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+startDate);
	    //ViksitLogger.logMSG(this.getClass().getName(),">>"+endDate);
	    int workDays = 0;

	    //Return 0 if start and end are the same
	    if (startCal.getTimeInMillis() == endCal.getTimeInMillis()) {
	        return 0;
	    }

	    if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
	        startCal.setTime(endDate);
	        endCal.setTime(startDate);
	    }
	    
	    endCal.add(Calendar.DATE, 1);
	    for(Date sd = startCal.getTime(); sd.before(endCal.getTime()); )
	    {
	    	if (days.contains(startCal.get(Calendar.DAY_OF_WEEK))) {
	        	////ViksitLogger.logMSG(this.getClass().getName(),"checming for "+startCal.get(Calendar.DAY_OF_WEEK));
	            ++workDays;
	        }
	    	startCal.add(Calendar.DATE, 1);
	    	sd = startCal.getTime();
	    }
	    
	    return workDays;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
