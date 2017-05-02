<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
				if(request.getParameterMap().containsKey("eventid") && request.getParameter("eventid") !=null ){
					
					 data = new UIUtils().getALLEventDetails(request.getParameter("eventid"));
					
					 status = request.getParameter("status");
				
					
					
				}
			%>
			
			<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
                                 <h4 class="modal-title text-center">Events Details</h4>
                                        </div>
                                        <div class="panel-body">
                                    <p><strong>Organization Name: </strong> <%=data.get("colname") %></p>    
                                           <p><strong>Batch Name: </strong> <%=data.get("batchname") %></p>
<p><strong>Course Name: </strong> <%=data.get("coursename") %></p>
<p><strong>Class Room: </strong> <%=data.get("classroom") %></p>

<p><strong>Trainer Name: </strong> <%=data.get("trainername") %> (<%=data.get("traineremail") %>)</p>
<p><strong>Date/Time: </strong> <%=dateformatter.format(todate.parse(data.get("evedate"))) %> - <%=timeformatter.format(todate.parse(data.get("evedate"))) %></p>
<p><strong>Duration: </strong> <%=data.get("duration") %></p>
<%if(!data.get("status").equalsIgnoreCase("ASSESSMENT")){%>
<p><strong>Status: </strong><%=data.get("status") %></p>
<p><strong>Total Student In Section: </strong> <%=data.get("totstudent") %></p>
<%
	if(status.equalsIgnoreCase("TEACHING") ||status.equalsIgnoreCase("ATTENDANCE") ||status.equalsIgnoreCase("FEEDBACK") ||status.equalsIgnoreCase("COMPLETED"))
	{
		%>
		<p><strong>Sessions Covered: </strong> <%=data.get("sessions_covered") != null ? data.get("sessions_covered"): 0 %></p>
		<p><strong>Next Session: </strong> <%=data.get("next_session") %></p>
		<% 
	}
}else{
	%>
	<p><strong>Assessment Title : </strong> <%=data.get("assessment_title") %></p>
	<p><strong>Number of Students Events Assigned To : </strong> <%=data.get("totstudent") %></p>
	<% 
} %>

<p><strong>Associate Trainer: </strong><%=data.get("asoctrainername") %> (<%=data.get("asoctraineremail") %>)</p>


                                        </div>
                                        <div class="modal-footer">
                                          <button type="button" class="btn btn-primary custom-theme-btn-primary" data-dismiss="modal">Close</button>
                                          <%if(!status.equalsIgnoreCase("ASSESSMENT")){ %>
                                           <button type="button" class="btn btn-primary custom-theme-btn-primary  key" id="edit" data-dismiss="modal">Edit Event</button>
                                           <%} %>
                                            <button type="button" class="btn btn-primary custom-theme-btn-primary key" id="delete" data-dismiss="modal">Delete Event</button>
                                            
                                        </div>
                                    </div>