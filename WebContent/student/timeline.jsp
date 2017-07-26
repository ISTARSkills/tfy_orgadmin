<%@page import="com.viksitpro.core.dao.entities.TaskDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Task"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	request.setAttribute("cp", cp);
	boolean flag = false;
%>
<body class="top-navigation student_pages" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
                <div class="col-lg-10">
                    <h2>Timeline</h2><small>Here you can see all historical activity.</small>
                    
                </div>
                <div class="col-lg-2">

                </div>
            </div><div class="wrapper wrapper-content animated fadeInRight" style="padding: 10px;" id='equalheight'>
				<div class="ibox-content inspinia-timeline">
					<% 
					
					String taskIcon = "fa fa-desktop";
					String description="";
					String actionString = "";
					for(TaskSummaryPOJO task: cp.getTasks()) { 
						if(task.getItemType().equalsIgnoreCase("ASSESSMENT")){
							taskIcon = "fa fa-houzz";
							if(task.getStatus().equalsIgnoreCase("SCHEDULED")) {
								//description = "You were assigned an assessment titled <b>"+task.getTitle()+"</b> which you have to finish. Why dotn we just do it now. </b>";
								description = "Believe you can and you're half way there. Lets fiish what we have to finish.";
								//Because you can't do anything halfway, you've got to go all the way in anything you do
								Task taskObject = new TaskDAO().findById(task.getId());
								actionString = "<a class='btn btn-primary btn-sm' href='"+"/student/user_assessment.jsp?task_id="+task.getId()+
										"&assessment_id="+task.getItemId()+"&user_id="+taskObject.getIstarUserByActor().getId()+"'> Finish Now! </a>";
							} else {
								//description = "You were assigned an assessment titled <b>"+task.getTitle()+"</b> which you completed </b>";
								
								// Show score of  what you have gained 
								description = "That's the magic of revisions - every cut is necessary, and every cut hurts, but something new always grows.";
								actionString = "<a class='btn btn-primary btn-sm' href='/student/assessment_report.jsp?assessment_id="+task.getItemId()+"&user_id="+cp.getId()+"'> Revise </a>";

							}
							
						} else if(task.getItemType().equalsIgnoreCase("CLASSROOM_SESSION")) {
							taskIcon = "fa fa-houzz";
						}else if(task.getItemType().equalsIgnoreCase("LESSON_PRESENTATION")) {
							taskIcon = "fa fa-houzz";
							if(task.getStatus().equalsIgnoreCase("SCHEDULED")) {
								/* description = "You were assigned to study  a lesson titled <b>"+task.getTitle()+"</b> which you have to finish."+ 
										"Why don't we just do it now. </b>"; */
								description = "Better a little which is well done, than a great deal imperfectly.";	
								Task taskObject = new TaskDAO().findById(task.getId());
								actionString =  "<a class='btn btn-primary btn-sm'  href='/student/presentation.jsp?lesson_id="+task.getItemId()+"&task_id="+task.getId()+"'> Read </a> ";
							} else if(task.getStatus().equalsIgnoreCase("INCOMPLETE")) {
								//description = "You were assigned to study  a lesson titled <b>"+task.getTitle()+"</b>  which you completed </b>";
								// Add progress
								description = "Great job you have already crossed 50% of the learning journey..";
								actionString =  "<a class='btn btn-primary btn-sm'  href='/student/presentation.jsp?lesson_id="+task.getItemId()+"&task_id="+task.getId()+"'> Lets Finish what we started </a> ";

							} else {
								description = "Twice and thrice over, as they say, good is it to repeat and review what is good.";
								actionString =  "<a class='btn btn-primary btn-sm'  href='/student/presentation.jsp?lesson_id="+task.getItemId()+"&task_id="+task.getId()+"'> Revise </a> ";
							}

							

						} else if(task.getItemType().equalsIgnoreCase("ZOOM_INTERVIEW_INTERVIEWER") || task.getItemType().equalsIgnoreCase("ZOOM_INTERVIEW_INTERVIEWEE") ) {
							
							taskIcon = "fa fa-houzz";
							description = "Twice and thrice over, as they say, good is it to repeat and review what is good.";
							actionString =  "<a class='btn btn-primary btn-sm'  href='/student/presentation.jsp?lesson_id="+task.getItemId()+"&task_id="+task.getId()+"'> Revise </a> ";
						} else if(task.getItemType().equalsIgnoreCase("ZOOM_INTERVIEW_INTERVIEWER") || task.getItemType().equalsIgnoreCase("ZOOM_INTERVIEW_INTERVIEWEE") ) {
							taskIcon = "fa fa-houzz";
							description = "Twice and thrice over, as they say, good is it to repeat and review what is good.";
							actionString =  "<a class='btn btn-primary btn-sm'  href='/student/presentation.jsp?lesson_id="+task.getItemId()+"&task_id="+task.getId()+"'> Revise </a> ";
						}
						PrettyTime p = new PrettyTime();
						String prettyTime = p.format(task.getDate());
						String dateSTring = new SimpleDateFormat("EEE, d MMM yyyy").format(task.getDate());
						%>
					<div class="timeline-item">
						<div class="row">
							<div class="col-md-3 date">
								<i class="<%=taskIcon %>"></i> <%=dateSTring %> <br> <small class="text-navy"><%=prettyTime %></small>
							</div>
							<div class="col-md-9 content no-top-border">
								<p class="m-b-xs">
									<strong><%=task.getTitle() %></strong>
								</p>

								<p><%=description %></p>
								<p class='pull-right'><%=actionString %></p>

								
							</div>
						</div>
					</div>
					<% } %>

				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>

</body>
</html>