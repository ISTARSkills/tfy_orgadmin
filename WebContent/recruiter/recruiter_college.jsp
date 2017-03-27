<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@page import="com.istarindia.apps.dao.RecruiterDAO"%>
<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
	RecrutUtils utils = new RecrutUtils();
	int collegeID = Integer.parseInt(request.getParameter("college_id"));
	int recruiter_id = Integer.parseInt(request.getParameter("recruiter_id"));
	Recruiter recruiter = (new RecruiterDAO()).findById(recruiter_id);
	RecruiterServices recruiterServices = new RecruiterServices();
%>

<div class="tabs-container jobs_tab">
	<div class="vacancy_tabs_pane">	
	<ul class="nav nav-tabs jobs_tab_nav">	
		<%
			for (Vacancy vacancy : recruiter.getVacancies()) {
				if(vacancy.getStatus().equalsIgnoreCase("PUBLISHED") && recruiterServices.hasCampaigns(vacancy.getId(), collegeID)){
		%>
		<li class=""><a data-toggle="tab"
			href="#tab-vacancy-<%=vacancy.getId()%><%=collegeID%>" data-vacancy_id="<%=vacancy.getId()%>" data-college="<%=collegeID%>"><%=vacancy.getProfileTitle().length()>10?vacancy.getProfileTitle().substring(0,10):vacancy.getProfileTitle()%><%=vacancy.getId()%></a></li>
		<%
				}
			}
		%>
	</ul>
	</div>
	<div class="tab-content jobs_tab_content">
		<%
			for (Vacancy vacancy : recruiter.getVacancies()) {
			if(vacancy.getStatus().equalsIgnoreCase("PUBLISHED") && recruiterServices.hasCampaigns(vacancy.getId(), collegeID)){
		%>
		<div id="tab-vacancy-<%=vacancy.getId()%><%=collegeID%>" class="tab-pane">
			<div class="panel-body jobs_tab_content_panel_body">
				<div class="tabs-container jobs_tabs">
					<jsp:include page="recruiter_vacancy.jsp">
						<jsp:param value="<%=vacancy.getId()%>" name="vacancy_id" />
						<jsp:param value="<%=collegeID%>" name="college_id" />
					</jsp:include>
				</div>
			</div>
		</div>
		<%
		}
				}
		%>
	</div>
</div>