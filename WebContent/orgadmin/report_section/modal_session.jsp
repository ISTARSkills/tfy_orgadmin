<%@page import="com.viksitpro.core.dao.entities.BatchDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Batch"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.sql.Date"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String eventId = request.getParameter("event_id");
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	DBUTILS dbutils = new DBUTILS();
	OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();
%>

<div class="modal inmodal session_modal_holder"
	id="session_modal_<%=eventId%>" tabindex="-1" role="dialog"
	aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content animated flipInY">
			<!-- start -->
			<div class="panel-body">

				<%
					List<HashMap<String, Object>> items = dashboardServices.getEvenetDetailsFromEvent(eventId);
					for (HashMap<String, Object> item : items) {
						int batch_id = (int) item.get("batch_id");
						int trainerId = (int) item.get("actor_id");
						Batch bb = new BatchDAO().findById(batch_id);%>

				<div
					class="col-lg-12 white-bg p-xs border-top-bottom border-left-right border-size-sm p-xs b-r-md dash_notification_holder">

					<div class="row show-grid ">

						<h3 class="m-b-xxs">
							<%=item.get("title")%>
							<span class="label label-info"> <%=item.get("status")%></span>
						</h3>

						<p class="pull-right fa fa-clock-o">
							<b><%=item.get("eventdate").toString().substring(11, 16)%>
								for <%=item.get("eventhour")%> hours </b>
						</p>

						<ul class="list-unstyled m-t-md">
							<li><label>Batch: </label> <%=item.get("batchname")%></li>
							<li><label>Classroom: </label> <%=item.get("classroom_identifier")%></li>
							<li><label>Trainer: </label> <%=item.get("trainername")%></li>
						</ul>
					</div>
				</div>

				<div class="row">
					<div class="no-paddings col-lg-12">
						<div class="tabs-container ">
							<div
								class="no-paddings bg-muted tab-content p-xs border-top-bottom border-left-right b-r-md">
								<div id="child<%="tab1" + eventId%>" class="tab-pane ">
									<div class="panel-body white-bg">
										<div class="col-lg-12 no-padding bg-muted">
											<div class="tabs-container">
												<ul class="nav nav-tabs dash_tab_holder">
													<li class="active col-lg-2 text-center no-padding bg-muted"><a
														data-toggle="tab" href="#grandchild<%="tab1" + eventId%>">Session
															View</a></li>
													<li class="col-lg-2 text-center no-padding bg-muted"><a
														data-toggle="tab" href="#grandchild<%="tab2" + eventId%>">Session
															logs</a></li>
													<li class="col-lg-2 text-center no-padding bg-muted"><a
														data-toggle="tab" href="#grandchild<%="tab3" + eventId%>">Camera
															View</a></li>
												</ul>
												<div class="tab-content">
													<div id="grandchild<%="tab1" + eventId%>"
														class="tab-pane active">
														<div class="panel-body ajax-session-holder"
															id="ajax-session-holder_<%=eventId%>"
															data-event-id="<%=eventId%>"
															data-url="<%=baseURL%>super_admin/dashboard_partials/dashboard_session_view.jsp">
															<jsp:include
																page="../dashboard_partials/dashboard_session_view.jsp">
																<jsp:param value="<%=eventId%>" name="eventId" />
															</jsp:include>
														</div>
													</div>
													<div id="grandchild<%="tab2" + eventId%>" class="tab-pane">
														<div class="panel-body">
															<h3>Slide Log</h3>
															<hr>
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
															<div class="full-height"
																style="height: 300px !important;">
																<ul
																	class="sortable-list connectList agile-list ui-sortable full-height-scroll"
																	id="todo">
																	
																	<li class="info-element">No Logs Found</li>
																	<%-- <%
																		Date slide_start;
																				for (HashMap<String, Object> log : logs) {
																					SlideDAO slideDAO = new SlideDAO();
																					try {
																						Slide slide = slideDAO.findById(Integer.parseInt(log.get("slide_id").toString()));
																						if(slide != null){
																	%>
																	<li class="info-element" id="">Slide Title : <%=slide.getTitle()!= null ?slide.getTitle().toUpperCase():""%>
																		<div class="agile-detail">
																			Time Started: <i class="fa fa-clock-o"></i>
																			<%=log.get("created_at").toString().substring(11)%>
																		</div>
																	</li>
																	<%
																		
																				}else{
																					%>		<ul>
																						<li class="info-element">No Logs Found</li>
																					</ul>	
																				<%		
																					break;}
																				}catch (Exception e) {
																						e.printStackTrace();
																					}
																				}
																	%>
 --%>
																</ul>
															</div>
															<%
																}
															%>


														</div>
													</div>
													<div id="grandchild<%="tab3" + eventId%>" class="tab-pane">
														<div class="panel-body">
															<img alt="image" class="img-responsive"
																src="../img/classroom.jpg">
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
												<img alt="image" class="img-circle m-t-xs img-responsive"
													src="<%=item.get("trainer_image").toString()%>">
											</div>

											<div class="col-md-8">

												<div>
													<h3>
														<strong><%=item.get("trainername")%></strong>
													</h3>

													<p>
														Skills:
														<%
														try {
																List<HashMap<String, Object>> skills = dashboardServices.getSkillsForTrainer(trainerId);
																for (HashMap<String, Object> skill : skills) {
													%>
														<%=skill.get("name")%>,
														<%
															}
																} catch (Exception e) {
																	e.printStackTrace();
																}
														%>
													</p>
													<p>
														<i class="fa fa-star"> </i> <i class="fa fa-star"></i> <i
															class="fa fa-star"></i> <i class="fa fa-star"></i> <i
															class="fa fa-star-half-full"></i>
													</p>
													<%
														List<HashMap<String, Object>> trainerhours = dashboardServices
																	.getSessionsCompletedByTrainerInBatch(trainerId, bb.getBatchGroup().getId(), bb.getCourse().getId());
													%>
													<p>
														Sessions Taught:
														<%=trainerhours.iterator().next().get("sessions").toString()%></p>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div id="child<%="tab3" + eventId%>" class="tab-pane">
									<div class="panel-body white-bg">
										<h1 class="forum-item-title">
											<%
												String sql5 = "SELECT 	name AS title FROM 	skill_objective WHERE 	ID IN ( 		SELECT DISTINCT 			learning_objectiveid 		FROM 			lesson_skill_objective 		WHERE 			lessonid IN ( 				SELECT DISTINCT 					lesson_id AS lesson_id 				FROM 					event_log 				WHERE 					event_log.event_id = "+eventId+" 			) 	) AND type= 'LEARNING_BASED'";
													List<HashMap<String, Object>> learningobjs = dbutils.executeQuery(sql5);
											%>
											<strong>Learning Objective Covered In Lesson</strong>
										</h1>
										<hr>
										<div class="ibox-content no-borders no-padding">
											<ul class="list-group">
												<%
													for (HashMap<String, Object> learningobj : learningobjs) {
												%>
												<li class="list-group-item no-borders">

													<p class="pull-right">
														<i class="fa fa-star"> </i> <i class="fa fa-star"></i> <i
															class="fa fa-star"></i> <i class="fa fa-star"></i> <i
															class="fa fa-star-half-full"></i>
													</p> <%=learningobj.get("title")%>
												</li>
												<%
													}
												%>
												</ul>
												<% if (learningobjs.size() == 0) {
												%>
												<p class="text-center">Learning Objective Covered In
													Lesson Not Available</p>
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
											<a href="#"><img alt="member" data-toggle="tooltip"
												data-placement="top" title="<%=absent.get("name")%>"
												class="img-circle img-sm"
												src="<%=absent.get("profile_image").toString()%>"></a>
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
											<a href="#"><img alt="member" data-toggle="tooltip"
												data-placement="top" title="<%=absent.get("name")%>"
												class="img-circle img-sm"
												src="<%=absent.get("profile_image").toString()%>"></a>
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
										%>

										<h2 class="forum-item-title">
											<strong>Trainer FeedBack</strong>
										</h2>
										<p class="pull-right">

											<%
												if (feedbackData.size() > 0) {
														int feedback_rating = Integer.parseInt(feedbackData.get(0).get("rating").toString());
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
															if (feedback.get(feedback_key).toString().equalsIgnoreCase("TRUE")) {
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
										<hr>

										<h2 class="forum-item-title">
											<strong>Student FeedBack</strong>
										</h2>
										<p class="pull-right">

											<%
												if (feedbackData.size() > 0) {
														int feedback_rating = Integer.parseInt(feedbackData.get(0).get("rating").toString());
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
															if (feedback.get(feedback_key).toString().equalsIgnoreCase("TRUE")) {
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
									</div>
								</div>
							</div>
							<ul class="nav nav-tabs tooltip-demo dash_tab_holder">
								<li
									class="text-center col-md-2 no-padding bg-muted session_card_tabs"
									data-toggle="tooltip" data-placement="top" title="Session Info"><a
									data-toggle="tab" href="#child<%="tab1" + eventId%>"> <i
										class="fa fa-laptop"></i>
								</a></li>
								<li class="text-center col-md-2 no-padding bg-muted"
									data-toggle="tooltip" data-placement="top" title="Trainer Info"><a
									data-toggle="tab" href="#child<%="tab2" + eventId%>"><i
										class="fa fa-user"></i></a></li>
								<li class="text-center col-md-2 no-padding bg-muted"
									data-toggle="tooltip" data-placement="top"
									title="Assessment Info"><a data-toggle="tab"
									href="#child<%="tab3" + eventId%>"><i
										class="fa fa-mortar-board"></i></a></li>
								<li class="text-center col-md-2 no-padding bg-muted"
									data-toggle="tooltip" data-placement="top"
									title="Attendance Info"><a data-toggle="tab"
									href="#child<%="tab4" + eventId%>"><i class="fa fa-users"></i></a></li>
								<li class="text-center col-md-2 no-padding bg-muted"
									data-toggle="tooltip" data-placement="top"
									title="Feedback Info"><a data-toggle="tab"
									href="#child<%="tab5" + eventId%>"><i
										class="fa fa-database"></i></a></li>
							</ul>

						</div>
					</div>
				</div>
				<hr>
				<%
					}
					if (items.size() == 0) {
				%>
				Event Information is Not Available
				<%
					}
				%>
			</div>
			<!-- end -->
		</div>
	</div>
</div>