<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.TaskDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Task"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.UUID"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
			
				HashMap<String, String> data = new HashMap<String, String>();
				DateFormat todate = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				DateFormat dateformatter = new SimpleDateFormat("yyyy-MM-dd");
				DateFormat timeformatter = new SimpleDateFormat("hh:mm a");
				String status = null;
				OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();
				 List<HashMap<String, Object>> slideCount = new  ArrayList<HashMap<String, Object>>();
				if(request.getParameterMap().containsKey("eventid") && request.getParameter("eventid") !=null ){
					
					 data = new UIUtils().getALLEventDetails(request.getParameter("eventid"));
					  slideCount = dashboardServices.getSlideCount(request.getParameter("eventid"));
					 status = request.getParameter("status");
				}
				
				boolean isDeletable=true;
				if(status.equalsIgnoreCase("ASSESSMENT")){
					DBUTILS dbutils = new DBUTILS();
					String sql = "SELECT 	task. ID FROM 	batch_schedule_event, 	batch_students, 	task WHERE 	batch_schedule_event.batch_group_id = batch_students.batch_group_id AND batch_students.student_id = task.actor AND batch_schedule_event.eventdate = task.start_date AND task. STATE = 'COMPLETED' AND batch_schedule_event. ID = "+ request.getParameter("eventid")+" UNION 	SELECT 		task. ID 	FROM 		batch_schedule_event, 		task 	WHERE 		batch_schedule_event.actor_id = task.actor 	AND batch_schedule_event.eventdate = task.start_date 	AND task. STATE = 'COMPLETED' 	AND batch_schedule_event. ID = "+ request.getParameter("eventid");
					List<HashMap<String, Object>> list=dbutils.executeQuery(sql);
					if(list!=null && list.size()!=0){
						isDeletable=false;
					}
				}

				
			%>
			
			<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
                                 <h4 class="modal-title text-center">Events Details</h4>
                                        </div>
                                        <div class="panel-body">
                                    <p><strong>Organization Name: </strong> <%=data.get("colname") %></p>    
                                           <p><strong>Group Name: </strong> <%=data.get("batch_group_name") %>(<%=data.get("batch_group_id") %>)</p>
<p><strong>Course Name: </strong> <%=data.get("coursename") %>(<%=data.get("course_id") %>)</p>
<p><strong>Class Room: </strong> <%=data.get("classroom") %>(<%=data.get("class_id") %>)</p>

<p><strong>Trainer Name: </strong> <%=data.get("trainername") %> (<%=data.get("traineremail") %>) (<%=data.get("trainer_id") %>)</p>
<p><strong>Date/Time: </strong> <%=dateformatter.format(todate.parse(data.get("evedate"))) %> - <%=timeformatter.format(todate.parse(data.get("evedate"))) %></p>
<p><strong>Duration: </strong> <%=data.get("duration") %></p>
<%if(!data.get("status").equalsIgnoreCase("ASSESSMENT")){%>
<p><strong>Status: </strong><%=data.get("status") %></p>
<p><strong>Total Student In Section: </strong> <%=data.get("totstudent") %></p>
<%
	if(status.equalsIgnoreCase("TEACHING") ||status.equalsIgnoreCase("ATTENDANCE") ||status.equalsIgnoreCase("FEEDBACK") ||status.equalsIgnoreCase("COMPLETED"))
	{
		%>
		<p><strong>Sessions Covered: </strong> <%=data.get("sessions_covered") %></p>
		<p><strong>Next Session: </strong> <%=data.get("next_session") %></p>
		<p><strong>Slides Covered: </strong> <%=slideCount.get(0).get("slide_count")%></p>
		<% 
	}
}else{
	%>
	<p><strong>Assessment Title : </strong> <%=data.get("assessment_title") %></p>
	<p><strong>Number of Students Events Assigned To : </strong> <%=data.get("totstudent") %></p>
	<% 
} %>

<p><strong>Associate Trainer: </strong><%=data.get("asoctraineremail") %></p>


                                        </div>
                                        <div class="modal-footer">
                                          <button type="button" class="btn btn-primary custom-theme-btn-primary" data-dismiss="modal">Close</button>
                                          <%if(!status.equalsIgnoreCase("ASSESSMENT") && (status.equalsIgnoreCase("SCHEDULED"))){ %>
                                           <button type="button" class="btn btn-primary custom-theme-btn-primary  key" data-status="<%=status%>" id="edit" data-dismiss="modal">Edit Event</button>
                                           <%} 
                                           if(status.equalsIgnoreCase("SCHEDULED") ||(isDeletable && status.equalsIgnoreCase("ASSESSMENT"))){
                                           %>
                                            <button type="button" class="btn btn-primary custom-theme-btn-primary key" data-status="<%=status%>" id="delete" data-dismiss="modal">Delete Event</button>
                                            <%} %>
                                        </div>
                                    </div>