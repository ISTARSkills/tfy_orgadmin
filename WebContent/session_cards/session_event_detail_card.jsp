<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroupDAO"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%

String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
String status = request.getParameter("status");
String title = request.getParameter("title");
String eventDate = request.getParameter("eventdate");
String eventHour = request.getParameter("eventhour");
String eventMin = request.getParameter("eventminute");
String batchName = request.getParameter("batchname");
String classroomIdentifier = request.getParameter("classroom_identifier");
String trainerName = request.getParameter("trainername");
String eventId = request.getParameter("event_id");
String trainerImage = request.getParameter("trainer_image");
String trainerId = request.getParameter("trainer_id");
String batchGroupId = request.getParameter("batch_group_id");
String courseId = request.getParameter("course_id");
OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();
List<HashMap<String, Object>> slideCount = dashboardServices.getSlideCount(eventId);
List<HashMap<String, Object>> currentCMsession = dashboardServices.getCurrentCMSession(Integer.parseInt(batchGroupId), Integer.parseInt(courseId));
List<HashMap<String, Object>> cmsessionsCovered = dashboardServices.getSessionsCoveredInEvent(Integer.parseInt(eventId));
BatchGroup bg = new BatchGroupDAO().findById(Integer.parseInt(batchGroupId));
%>
<div class="col-lg-12 white-bg p-xs border-top-bottom border-left-right border-size-sm p-xs b-r-md dash_notification_holder">
	<div class="row show-grid ">
		<h3 class="m-b-xxs">
			<%=title%>
			<span class="label label-info"> <%=status%></span>
		</h3>
		<i class="pull-right fa fa-clock-o"> </i>
		<p style="float: right; margin-top: -4px;"><%=eventDate.substring(11, 16)%>
			for
			<%=eventHour%>
			hours <%=eventMin %> minutes
		</p>
		<ul class="list-unstyled m-t-md">
			<li><label>Organization: </label> <%=bg.getOrganization().getName()%></li>
			<li><label>Group: </label> <%=batchName%></li>
			<li><label>Classroom: </label> <%=classroomIdentifier%></li>
			<li><label>Trainer: </label> <%=trainerName%></li>
			<%
							if(!status.equalsIgnoreCase("ASSESSMENT"))
							{	
								if(currentCMsession.size()>0 && currentCMsession.get(0).get("title")!=null){
								%>
			<li><label>Current Session For Batch: </label> <%=currentCMsession.get(0).get("title")%></li>
			<%
								}
								if(cmsessionsCovered.size()>0 && cmsessionsCovered.get(0).get("sessions")!=null)
								{
									%>
			<li><label>Sessions Covered in Event: </label> <%=cmsessionsCovered.get(0).get("sessions")%></li>
			<% 
								}
								%>
			<%if(slideCount.size()>0 && slideCount.get(0).get("slide_count")!=null)
								{
									 %>
			<li><label>Slide Covered In Event:</label> <%=slideCount.get(0).get("slide_count")%></li>
			<% 
								}
							}
							%>
		</ul>
	</div>
</div>
<div class="row">
	<div class="no-paddings col-lg-12">
		<div class="tabs-container ">
			<div class="no-paddings bg-muted tab-content p-xs border-top-bottom border-left-right b-r-md" style="padding: 0px !important" >
				<div id="child<%="tab1" + eventId%>" class="tab-pane" style="padding: 0px !important" >
					<div class="panel-body white-bg" style="padding: 0px !important" >
						<div class="col-lg-12 no-padding bg-muted" style="padding: 0px !important" >
							<div class="tabs-container" style="padding: 0px !important" >
								<ul class="nav nav-tabs dash_tab_holder">
									<li class="active col-lg-2 text-center no-padding bg-muted"><a data-toggle="tab" href="#grandchild<%="tab1" + eventId%>">Session View</a></li>
									<li class="col-lg-2 text-center no-padding bg-muted"><a data-toggle="tab" href="#grandchild<%="tab2" + eventId%>">Session logs</a></li>

								</ul>
								<div class="tab-content" style="padding: 0px !important" >
									<div id="grandchild<%="tab1" + eventId%>" class="tab-pane active" style="padding: 0px !important" >
										<div class="panel-body ajax-session-holder" id="ajax-session-holder_<%=eventId%>" data-event-id="<%=eventId%>" data-url="<%=baseURL%>session_cards/dashboard_session_view.jsp">
											<jsp:include page="/session_cards/dashboard_session_view.jsp">
												<jsp:param value="<%=eventId%>" name="eventId" />
											</jsp:include>
										</div>
									</div>
									<div id="grandchild<%="tab2" + eventId%>" class="tab-pane" style="padding: 0px !important" >
										<div class="panel-body">
											<h3>Slide Log</h3>

											<%
																List<HashMap<String, Object>> logs = dashboardServices.getSlideLogs(eventId);
																	if (logs.size() == 0) {
															%>

											<ul>
												<li class="info-element">No Logs Found</li>
											</ul>
											<%
																} else {
															%>
											<div class="full-height" style="height: 300px !important;">
												<ul class="sortable-list connectList agile-list ui-sortable full-height-scroll" id="todo">
													<%
																		
																					int slideCoveredProcessed = 0;
																				for (HashMap<String, Object> log : logs) {
																					try {
																						String slideId = log.get("slide_id").toString();
																						String slideTitle = "NA";
																						String lessonTitle = "NA";
																						String cmsesisonTitle = "NA";
																						String lessonId ="";
																						String cmsession_id ="";
																						String timeSpentOnSlide ="";
																						if(slideCoveredProcessed + 1 < logs.size())
																						{
																							Timestamp curentSlideMovementTime = (Timestamp)log.get("created_at");
																							Timestamp nextSlideMovementTime = (Timestamp)logs.get(slideCoveredProcessed+1).get("created_at");
																							 //diff =(int)((nextSlideMovementTime.getTime() - curentSlideMovementTime.getTime()) / (24*60 * 60));
																							long diff = nextSlideMovementTime.getTime() - curentSlideMovementTime.getTime();
																							long diffSeconds = diff / 1000 % 60;
																							long diffMinutes = diff / (60 * 1000) % 60;
																							
																							if(Math.abs(diffMinutes)>0)
																							{
																								timeSpentOnSlide = Math.abs(diffMinutes)+" min ";
																							}
																							if(Math.abs(diffSeconds)>0)
																							{
																								timeSpentOnSlide += Math.abs(diffSeconds)+" sec";
																							}	
																							
																							 //diff = Math.abs(diff);
																						}
																						
																						String differenceInTime = "0";
																						
 																						if(log.get("slide_title") != null){
 																							 
																							slideTitle = log.get("slide_title").toString();
																							lessonTitle = log.get("lesson_title").toString();;
																							cmsesisonTitle = log.get("cmsession_title").toString();
																							lessonId = log.get("lesson_id").toString();
																							cmsession_id = log.get("cmsession_id").toString();
																	%>
													<li class="info-element" id=""><b>Slide Title</b> : <%=slideTitle%> (Id :<%=slideId %>) <br> <b>Lesson Title</b> : <%=lessonTitle%> (Id :<%=lessonId %>) <br> <b>Session Title</b> : <%=cmsesisonTitle%> (Id :<%=cmsession_id %>)
														<div class="agile-detail" style="float: right; margin-left: 14px;">
															<b>Start Time</b>:
															<%=log.get("created_at").toString().substring(11,19)%>

														</div>

														<div class="agile-detail" style="float: right;">
															<b>Total Time Spent on Slide</b>:
															<%=timeSpentOnSlide%>
														</div></li>
													<%
																						}else{
																					%>
													<ul>
														<li class="info-element">No Logs Found</li>
													</ul>
													<%		
																					break;}
																				}catch (Exception e) {
																						e.printStackTrace();
																					}
																					slideCoveredProcessed++;
																				}
																	%>

												</ul>
											</div>
											<%
																}
															%>
										</div>
									</div>

								</div>


							</div>
						</div>


					</div>
				</div>
				<div id="child<%="tab2" + eventId%>" class="tab-pane">
					<div class="panel-body white-bg">
						<div class="row ">
							<div class="col-md-4">
								<img alt="image" class="img-circle m-t-xs img-responsive" src="<%=trainerImage%>">
							</div>

							<div class="col-md-8">

								<div>
									<h3>
										<strong><%=trainerName%></strong>
									</h3>
									<p>
										<b>Skills</b>:
										<%
														try {
																List<HashMap<String, Object>> skills = dashboardServices.getSkillsForTrainer(Integer.parseInt(trainerId));
																for (HashMap<String, Object> skill : skills) {
													%>
										<%=skill.get("courses")%>,
										<%
															}
																} catch (Exception e) {
																	e.printStackTrace();
																}
														%>
									</p>
									<%
													List<HashMap<String, Object>> trainerfeedback = dashboardServices.getAverageFeedbackofTrainer(Integer.parseInt(trainerId));
													int percentage = 0;
													if(trainerfeedback.size()>0){
														 percentage = (int)trainerfeedback.get(0).get("percentage");
													}
													int starCount = (int)Math.ceil(((float)percentage)/20);	
													%>
									<p>
										<b>Average Feedback of Trainer</b> :
										<%for(int i=0 ;i<starCount;i++ ){ 
													%>
										<i class="fa fa-star"> </i>
										<% 
													}%>
									</p>
									<%
														List<HashMap<String, Object>> trainerhours = dashboardServices
																	.getTotalHoursTaughtByTrainer(Integer.parseInt(trainerId));
														String totalHours = trainerhours.iterator().next().get("sessions").toString();
														if(totalHours.length()>5)
														{
															totalHours = totalHours.substring(0,5);
														}
													%>
									<p>
										<b>Total Hours Taught by Trainer</b>:
										<%=totalHours%></p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="child<%="tab3" + eventId%>" class="tab-pane">
					<div class="panel-body white-bg">
						<h1 class="forum-item-title">
							<%
							
							
							List<HashMap<String, Object>> lobjCovered = 	dashboardServices.learningObjectiveCoveredInEvent(Integer.parseInt(eventId), status);		
											%>
							<strong>Learning Objective Covered In Event</strong>
						</h1>

						<div class="ibox-content no-borders no-padding">
							<ul class="list-group">
								<%
													for (HashMap<String, Object> learningobj : lobjCovered) {
												%>
								<li class="list-group-item no-borders" style="padding-bottom: 1px;"><%=learningobj.get("lobs")%></li>
								<%
													}
												%>
							</ul>
							<% if (lobjCovered.size() == 0) {
												%>
							<p class="text-center">Learning Objective Covered In Lesson Not Available</p>
							<%
													}
												%>
						</div>
					</div>
				</div>

				<%
									List<HashMap<String, Object>> attendanceData = dashboardServices.getStudentAttendanceStatus(eventId);
								%>

				<div id="child<%="tab4" + eventId%>" class="tab-pane">
					<div class="panel-body white-bg">
						<div class=" col-md-2 pull-right">
							<span class="views-number"> <%
 	if (attendanceData.size() > 0) {
 %> <%=attendanceData.get(0).get("absent")%> <%
 	} else {
 %> N/A <%
 	}
 %>
							</span>
							<div>
								<small>Absent</small>

							</div>
						</div>
						<div class=" col-md-2 pull-right">
							<span class="views-number"> <%
 	if (attendanceData.size() > 0) {
 %> <%=attendanceData.get(0).get("present")%> <%
 	} else {
 %> N/A <%
 	}
 %></span>
							<div>
								<small>Present</small>

							</div>
						</div>
						<h1 class="forum-item-title">
							<strong>Attendance status</strong>
						</h1>
						<hr>
						<div class="team-members tooltip-demo">
							<h2 class="forum-item-title">Present List</h2>
							<%
												if (attendanceData.size() > 0) {
														for (HashMap<String, Object> absent : attendanceData) {
															if (absent.get("status").toString().equalsIgnoreCase("PRESENT")) {
											%>
							<a href="#"><img alt="member" data-toggle="tooltip" data-placement="top" title="<%=absent.get("name")%>" class="img-circle img-sm" src="<%=absent.get("profile_image").toString()%>"></a>
							<%
												}
											%>

							<%
												}
													} else {
											%>
							N/A
							<%
												}
											%>
						</div>
						<hr>
						<div class="team-members tooltip-demo">
							<h2 class="forum-item-title">Absent List</h2>
							<%
												if (attendanceData.size() > 0) {
														for (HashMap<String, Object> absent : attendanceData) {
															if (absent.get("status").toString().equalsIgnoreCase("ABSENT")) {
											%>
							<a href="#"><img alt="member" data-toggle="tooltip" data-placement="top" title="<%=absent.get("name")%>" class="img-circle img-sm" src="<%=absent.get("profile_image").toString()%>"></a>
							<%
												}
											%>

							<%
												}
													} else {
											%>
							N/A
							<%
												}
											%>
						</div>
					</div>
				</div>
				<div id="child<%="tab5" + eventId%>" class="tab-pane">
					<div class="panel-body white-bg">
						<%
											List<HashMap<String, Object>> feedbackData = dashboardServices.getFeedbackDataForEvent(eventId);
						              List<HashMap<String, Object>> feedbackText = dashboardServices.getFeedbackTextForEvent(eventId);
										%>

						<h2 class="forum-item-title">
							<strong>Trainer FeedBack</strong>
						</h2>
						<p class="pull-right">

							<%
												if (feedbackData.size() > 0) {
													
														int feedback_rating = (int)feedbackData.get(0).get("rating");
														for (int k = 0; k < feedback_rating; k++) {
											%>
							<i class="fa fa-star"> </i>
							<%
												}
													} else {
											%>
							Feedback Rating Not Available
							<%
												}
											%>
						</p>
						<p>
							<%
												if (feedbackData.size() > 0) {
														HashMap<String, Object> feedback = feedbackData.get(0);
														for (String feedback_key : feedback.keySet()) {
															
															if (!feedback_key.equalsIgnoreCase("rating") && (float)feedback.get(feedback_key)>2.5 ) {
											%>
							<span class="badge"> <%=feedback_key%>
							</span> &nbsp;
							<%
												}
														}
													} else {
											%>
							<span class="badge"> N/A </span>
							<%
												}
											%>

							<%
												
											%>
						</p>
						<p><strong>Trainer Feedback:</strong> <%if (feedbackText != null && feedbackText.size()>0){%><%=feedbackText.get(0).get("comments") %><%} %></p>
						<hr>

						<h2 class="forum-item-title">
							<strong>Student FeedBack</strong>
							<%
											List<HashMap<String, Object>> studentFeedbackData = dashboardServices.getStundentFeedbackDataForEvent(Integer.parseInt(eventId));
										%>
						</h2>
						<p class="pull-right">

							<%
												if (studentFeedbackData.size() > 0) {
														double feedback_rating = (double)studentFeedbackData.get(0).get("rating");
														for (int k = 0; k < feedback_rating; k++) {
											%>
							<i class="fa fa-star"> </i>
							<%
												}
													} else {
											%>
							Feedback Rating Not Available
							<%
												}
											%>
						</p>

						<p>
							<%
												if (studentFeedbackData.size() > 0) {
														HashMap<String, Object> feedback = studentFeedbackData.get(0);
														for (String feedback_key : feedback.keySet()) {
															double keyData = (double)feedback.get(feedback_key);
															if (keyData>2.5) {
															
											%>
							<span class="badge"> <%=feedback_key.replace("_", " ")%>
							</span> &nbsp;
							<%
												}
														}
													} else {
											%>
							<span class="badge"> N/A </span>
							<%
												}
											%>

							<%
												
											%>
						</p>
					</div>
				</div>
			</div>
			<ul class="nav nav-tabs tooltip-demo dash_tab_holder">
				<li class="text-center col-md-2 no-padding bg-muted session_card_tabs" data-toggle="tooltip" data-placement="top" title="Session Info"><a data-toggle="tab" href="#child<%="tab1" + eventId%>"> <i class="fa fa-laptop"></i>
				</a></li>
				<li class="text-center col-md-2 no-padding bg-muted" data-toggle="tooltip" data-placement="top" title="Trainer Info"><a data-toggle="tab" href="#child<%="tab2" + eventId%>"><i class="fa fa-user"></i></a></li>
				<li class="text-center col-md-2 no-padding bg-muted" data-toggle="tooltip" data-placement="top" title="Assessment Info"><a data-toggle="tab" href="#child<%="tab3" + eventId%>"><i class="fa fa-mortar-board"></i></a></li>
				<li class="text-center col-md-2 no-padding bg-muted" data-toggle="tooltip" data-placement="top" title="Attendance Info"><a data-toggle="tab" href="#child<%="tab4" + eventId%>"><i class="fa fa-users"></i></a></li>
				<li class="text-center col-md-2 no-padding bg-muted" data-toggle="tooltip" data-placement="top" title="Feedback Info"><a data-toggle="tab" href="#child<%="tab5" + eventId%>"><i class="fa fa-database"></i></a></li>
			</ul>

		</div>
	</div>
</div>