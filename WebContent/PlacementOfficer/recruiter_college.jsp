<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%@page import="com.istarindia.apps.dao.PlacementOfficer"%>
<%@page import="com.istarindia.apps.dao.PlacementOfficerDAO"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@page import="com.istarindia.apps.dao.College"%>
<%@page import="com.istarindia.apps.dao.RecruiterDAO"%>
<%@page import="com.istarindia.apps.dao.CollegeDAO"%>
<%@page import="com.istarindia.apps.dao.Campaigns"%>
<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
	RecrutUtils utils = new RecrutUtils();
	int companyID = Integer.parseInt(request.getParameter("company_id"));
	int collegeID = Integer.parseInt(request.getParameter("college_id"));
	int recruiter_id = Integer.parseInt(request.getParameter("recruiter_id"));
	Recruiter recruiter = (new RecruiterDAO()).findById(recruiter_id);
	College college = (new CollegeDAO()).findById(collegeID);
	RecruiterServices recruiterServices = new RecruiterServices();
%>
<div class="tabs-container jobs_tab">
	<div class="vacancy_tabs_pane">
	<ul class="nav nav-tabs jobs_tab_nav">
		<%
			for (Vacancy vacancy : recruiter.getVacancies()) {
				if(recruiterServices.hasCampaigns(vacancy.getId(), collegeID)){
						%>
						<li class=""><a data-toggle="tab"
							href="#tab-vacancy-<%=vacancy.getId()%><%=companyID%>" data-vacancy_id="<%=vacancy.getId()%>" data-college="<%=companyID%>"><%=vacancy.getProfileTitle().length()>10?vacancy.getProfileTitle().substring(0,10):vacancy.getProfileTitle()%><%=vacancy.getId()%></a></li>
						<%
				}
			}
		%>
	</ul>
	</div>
	<div class="tab-content jobs_tab_content">
		<%
			for (Vacancy vacancy : recruiter.getVacancies()) {
				if(recruiterServices.hasCampaigns(vacancy.getId(), collegeID)){
		%>
		<div id="tab-vacancy-<%=vacancy.getId()%><%=companyID%>" class="tab-pane">
			<div class="panel-body jobs_tab_content_panel_body">
				<div class="tabs-container">
					<jsp:include page="recruiter_vacancy.jsp">
						<jsp:param value="<%=vacancy.getId()%>" name="vacancy_id" />
						<jsp:param value="<%=companyID%>" name="company_id" />
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