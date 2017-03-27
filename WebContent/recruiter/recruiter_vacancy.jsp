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
	
	if (request.getParameterMap().containsKey("college_id")){
		collegeID = request.getParameter("college_id");
	}
	
	int vacancyID = Integer.parseInt(request.getParameter("vacancy_id"));
	Vacancy vacancy = (new VacancyDAO()).findById(vacancyID);
	
	List<IstarTaskWorkflow> allTaskWorkflow = vacancy.getIstarTaskType().fetchIstarTaskWorkflows();
%>


<div class="tabs-left">

		<ul class="nav nav-tabs stages_tab stages_tab<%=vacancyID%><%=collegeID%>">
			<%
				for (IstarTaskWorkflow stage : allTaskWorkflow) {
			%>
						<li class="" data-stage="<%=stage.getId()%>" data-vacancy="<%=vacancyID%>" data-college="<%=collegeID%>"><a data-toggle="tab"
							href="#tab-vacancy-workflow-<%=stage.getId()%>-<%=vacancyID%><%=collegeID%>" data-stage="<%=stage.getId()%>"
							><%=stage.getStage().equalsIgnoreCase("TARGETED")?"Invited":stage.getStage()%><i></i></a></li>
			<%
				}
			%>
		</ul>
	
	<div class="tab-content row" style="background-color:#f3f3f4;">
	
		<%
			int intialIndex1 = 0;
			for (IstarTaskWorkflow stage : allTaskWorkflow) {
				if(stage.getStage().equalsIgnoreCase("TARGETED")){
					%>
		   <div id="tab-vacancy-workflow-<%=stage.getId()%>-<%=vacancyID%><%=collegeID%>"
				class="tab-pane row stage_tab_content" data-current="<%=intialIndex1%>" data-max="<%=allTaskWorkflow.size()-1%>">
				<div class="row stage_tabs_list panel-body">
					<div class="hello">							
						<jsp:include page="target_students.jsp">
							<jsp:param value="<%=vacancy.getId()%>" name="vacancy_id" />
							<jsp:param value="<%=stage.getId()%>" name="stage_id" />
							<jsp:param value="<%=vacancy.getRecruiter().getId()%>" name="recruiter_id" />
							<jsp:param value="<%=collegeID%>" name="college_id" />
						</jsp:include>
					</div>	
				</div>
			</div>
					<%
				} else{
		%>
			<div id="tab-vacancy-workflow-<%=stage.getId()%>-<%=vacancyID%><%=collegeID%>"
				class="tab-pane row stage_tab_content" data-current="<%=intialIndex1%>" data-max="<%=allTaskWorkflow.size()-1%>">								
				<div class="row stage_tabs_list panel-body">
					<div class="col-lg-4 student_list">
						<jsp:include page="recruiter_vacancy_users_list.jsp">
							<jsp:param value="<%=vacancy.getId()%>" name="vacancy_id" />
							<jsp:param value="<%=stage.getId()%>" name="stage_id" />
							<jsp:param value="<%=collegeID%>" name="college_id" />
						</jsp:include>
					</div>

					<div class="col-lg-6 hello"
						id="student_pane--<%=collegeID%><%=vacancyID%>--<%=stage.getId()%>"></div>
			</div>
			</div>
			<%
				}
			intialIndex1++;
			}
		%>
		</div>
	</div>