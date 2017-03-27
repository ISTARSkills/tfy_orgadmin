<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%@page import="java.util.Date"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
<%@page import="com.istarindia.apps.dao.IstarUserDAO"%>
<%@page import="com.istarindia.apps.dao.RecruiterDAO"%>
<%@page import="com.istarindia.apps.dao.IstarNotification"%>
<%@page import="java.util.ArrayList"%>
<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%     //http://localhost:8080/recruiter/right_side_pane.jsp?student_id=1793&stage_id=1--14653f79-03bf-4e7e-ac4e-0618421c7816 
	
	int studentID = Integer.parseInt(request.getParameter("student_id"));
	String stage_ID = (request.getParameter("stage_id").toString().split("--")[1]);
	int vacancy_ID = Integer.parseInt(request.getParameter("stage_id").toString().split("--")[0]);
	int recID = (new VacancyDAO()).findById(vacancy_ID).getRecruiter().getId();
	
	RecrutUtils utils = new RecrutUtils();
	ArrayList<IstarNotification> items = utils.getMessagesByRecruiterStudent(studentID,recID);
	%>
	
	<div class="chat-discussion" style="height: 100% !important; background: #fff;  padding: 0px; " >
<% for(IstarNotification notif : items) { 
	
	Recruiter sender = (new RecruiterDAO()).findById(notif.getSenderId());
	String senderName = sender.getName();
	String senderImage = sender.getImage_url();
	
	if(senderImage==null){
		senderImage = "/img/user_images/recruiter.png";
	}

	PrettyTime p = new PrettyTime();
	Date date = new Date(notif.getCreatedAt().getTime());%>
		<div class="chat-message left" style="padding: 0px; margin-bottom: 8px;">
			<img class="message-avatar" src="<%=senderImage %>" alt="<%=senderName %>">
			<div class="message">
				<span class="message-author" ><%=senderName %></span> <span
					class="message-date"><%=p.format(date) %></span> <span
					class="message-content"><%=notif.getDetails() %></span>
			</div>
		</div>
	<% } %>

	</div>

