<%@page import="java.util.HashMap"%>
<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.IstarTaskWorkflow"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	RecrutUtils utils = new RecrutUtils();
	String collegeID = "";
	String companyID = "";
	
	if (request.getParameterMap().containsKey("college_id")){
		collegeID = request.getParameter("college_id");
	}
	if (request.getParameterMap().containsKey("company_id")){
		companyID = request.getParameter("company_id");
	}
	
	int vacancyID = Integer.parseInt(request.getParameter("vacancy_id"));
	Vacancy vacancy = (new VacancyDAO()).findById(vacancyID);
%>


<div class="tabs-left">

		<ul class="nav nav-tabs stages_tab stages_tab<%=vacancyID%><%=companyID%>">
			<%
				for (IstarTaskWorkflow stage : vacancy.getIstarTaskType().fetchIstarTaskWorkflows()) {
			%>
						<li class="" data-stage="<%=stage.getId()%>" data-vacancy="<%=vacancyID%>" data-college="<%=companyID%>"><a data-toggle="tab"
							href="#tab-vacancy-workflow-<%=stage.getId()%>-<%=vacancyID%><%=companyID%>" data-stage="<%=stage.getId()%>"
							><%=stage.getStage()%><i></i></a></li>
			<%}							
			%>
		</ul>
	
	<div class="tab-content row" style="background-color:#f3f3f4;">
	
		<%
			for (IstarTaskWorkflow stage : vacancy.getIstarTaskType().fetchIstarTaskWorkflows()) {
		%>
			<div id="tab-vacancy-workflow-<%=stage.getId()%>-<%=vacancyID%><%=companyID%>"
				class="tab-pane row">								
				<div class="row stage_tabs_list panel-body">
					<div class="col-lg-4 student_list">
						<jsp:include page="recruiter_vacancy_users_list.jsp">
							<jsp:param value="<%=vacancy.getId()%>" name="vacancy_id" />
							<jsp:param value="<%=stage.getId()%>" name="stage_id" />
							<jsp:param value="<%=collegeID%>" name="college_id" />
							<jsp:param value="<%=companyID%>" name="company_id" />
						</jsp:include>
					</div>

					<div class="col-lg-6 hello"
						id="student_pane--<%=companyID%><%=vacancyID%>--<%=stage.getId()%>"></div>
			</div>
			</div>
			<%
					}
		%>
		</div>
	</div>