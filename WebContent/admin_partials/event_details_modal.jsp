<%@page import="com.talentify.admin.rest.pojo.EventFeedback"%>
<%@page import="com.viksitpro.core.utilities.TrainerWorkflowStages"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
<%@page import="com.talentify.admin.rest.pojo.EventDetail"%>
<%
int eventId = Integer.parseInt(request.getParameter("event_id"));
System.out.println("event_id------->"+eventId);

AdminRestClient adminClient  = new AdminRestClient();
EventDetail events = adminClient.getEventsDetails(eventId);
%>
							  <div class="modal-dialog modal-lg" style="width: 660px;">
							    <div class="modal-content custom-event-container">
							      <div class="modal-header custom-event-modal-header">
							      <div class="container">
							      <div class="row">
							      <div class="col-md-2"><img alt="image" class="img-thumbnail-medium" src="<%=AppProperies.getProperty("media_url_path") %><%=events.getImageUrl() %>"></div>
											<div class="col-md-10">
												<div class="row">
													<div class="col-md-10">
														<div class="row custom-no-margins">
															<img src="/assets/images/icons_8_clock2.png"
																srcset="/assets/images/icons_8_clock2.png 2x, /assets/images/icons_8_clock3.png 3x"
																class="icons8-clock">
															<h1 class="am-hrs custom-no-margins"><%=events.getTime() %></h1>
															<img src="/assets/images/icons_8_empty_hourglass2.png"
																srcset="/assets/images/icons_8_empty_hourglass2.png 2x, /assets/images/icons_8_empty_hourglass3.png 3x"
																class="icons8-empty_hourglass">
															<h1 class="am-hrs custom-no-margins"><%=events.getDuration() %> Hrs</h1>
														</div>
													</div>
													<div class="col-md-2">
														<button type="button"
															class="close float-right custom-close-modal"
															data-dismiss="modal" aria-label="Close">X</button>
													</div>
												</div>
												<div class="row m-0"><h1 class="custom-modal-header-trainer popover-dismiss" data-toggle="popover" title="Sessions" data-trigger="hover" data-placement="bottom" data-content="<%=events.getSessionName()%>">
												<%if(events.getSessionName().length()>25)
													{
													%>
													<%=events.getSessionName().substring(0, 25)%> ...
													<%
													}
													else
													{
														%>
														<%=events.getSessionName()%>
														<%
													}
													%></h1> 
												<!-- <div class="custom-oval-icon"><img src="/assets/images/icons_8_video_call2.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x" class="video-icon"></div>
												 -->
												<%
										switch (events.getStatus())
										{
										case "SCHEDULED":
											%>
											<div class="custom-oval-icon-blue">
											<img src="/assets/images/completed_shape3.png"
												srcset="/assets/images/completed_shape2.png 2x, /assets/images/completed_shape3.png 3x"
												class="completed-icon">
											</div>	
											<%
											break;
										
										case TrainerWorkflowStages.COMPLETED:
											%>
											<div class="custom-oval-icon-red">
											<img src="/assets/images/icons_8_video_call3.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x"
												class="video-icon">
											</div>	
											<%
											break;
									
										case TrainerWorkflowStages.TEACHING:
											%>
											<div class="custom-oval-icon-green">
											<img src="/assets/images/icons_8_video_call3.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x"
												class="video-icon">
											</div>	
											<%
											break;
										default:
											
											break;
											
											
										}
										%></div>
												<div class="row m-0">
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Role </h4><h4 class="modal-info-content mb-0"><%=events.getCourseName() %></h4></div></div>
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Group </h4><h4 class="modal-info-content mb-0"><%=events.getGroupName() %></h4></div></div>
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Trainer </h4><h4 class="modal-info-content mb-0"><%=events.getTrainer().getTrainerName() %></h4></div></div>
												</div>
											</div>
										</div>
							      </div>
							      </div>
								<div class="modal-body p-0 custom-event-modal-body">
									<div class="container px-0">
									<ul class="nav nav-tabs" style="flex-wrap: nowrap;">
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text active p-0" data-toggle="tab" href="#presentation" role="tab">Presentation</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#trainerinfo" role="tab">Trainer Info</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#attendance" role="tab">Attendance</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#feedback" role="tab">Feedback</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#assessment" role="tab">Assessment</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#sessionlog" role="tab">Session Log</a>
										</li>
									</ul>
									</div>
									<div class="tab-content custom-tab-content-size">
											<div class="tab-pane active" id="presentation" role="tabpanel">.fedfc.</div>
											<div class="tab-pane p-5" id="trainerinfo" role="tabpanel">
												<div class="card trainerinfo-card">
												  <div class="card-block">
												    <div class="row">
												    <div class="col-md-3"><img alt="image" src="<%=events.getTrainer() %>" class="trainer-info-img"></div>
												    <div class="col-md-9">
												    	<h1 class="trainerinfo-trainername mb-0"><%=events.getTrainer().getTrainerName() %></h1>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Skills</h4>
												    	
												    	
												    	<h4 class="trainerinfo-type-value mb-0"><%=events.getTrainer().getSkills()!=null && events.getTrainer().getSkills().size()!=0 ? StringUtils.join(events.getTrainer().getSkills(), ",") : "N/A"%></h4>
												    	
												    	
												    	</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0 mt-1">Average feedback</h4>
															<!-- <p class="stars float-right m-0">
																<i class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i>
															</p> -->
															
															<p class="stars float-right m-0">
																<%
																	if (events.getTrainer().getAverageFeedback() != null && events.getTrainer().getAverageFeedback() > 0) {
																			int rating = (int) ((float) events.getTrainer().getAverageFeedback());
																			for (int j = 0; j < rating; j++) {
																%><i class='trainer-dash-star fa fa-star  mx-2'></i>
																<%
																	}
																			if (rating < 5) {
																				for (int j = rating; j < 5; j++) {
																%><i class='trainer-dash-star fa fa-star-o  mx-2'></i>
																<%
																	}
																			}
																		} else {
																%><i class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i>
																<%
																	}
																%>
															</p>
														</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Total Hours Taught</h4>
												    	<h4 class="trainerinfo-type-value mb-0"><%=events.getTrainer().getTotalHoursTaught()!=null ?events.getTrainer().getTotalHoursTaught():0%> Hrs</h4>
												    	</div>
												    </div>
												    </div>
												  </div>
												</div>
												
												<%if(events.getAssociateTrainer()!=null){ %>
												<div class="card trainerinfo-card mt-5">
												  <div class="card-block">
												    <div class="row">
												    <div class="col-md-3"><img alt="image" src="https://scontent.fblr2-1.fna.fbcdn.net/v/t31.0-8/1978390_691722690897867_9093125142540358371_o.jpg?oh=c72b63dc71cf2cb557e9eec7e57322fd&oe=5A5DDFC1" class="trainer-info-img"></div>
												    <div class="col-md-9">
												    	<h1 class="trainerinfo-trainername mb-0"><%=events.getAssociateTrainer().getTrainerName()%></h1>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Skills</h4>
												    	<h4 class="trainerinfo-type-value mb-0"><%=events.getAssociateTrainer().getSkills()!=null && events.getAssociateTrainer().getSkills().size()!=0 ? StringUtils.join(events.getAssociateTrainer().getSkills(), ",") : "N/A"%></h4>
												    	</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0 mt-1">Average feedback</h4>
															<!-- <p class="stars float-right m-0">
																<i class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i>
															</p> -->
															
															<p class="stars float-right m-0">
																<%
																	if (events.getAssociateTrainer().getAverageFeedback() != null && events.getAssociateTrainer().getAverageFeedback() > 0) {
																			int rating = (int) ((float) events.getAssociateTrainer().getAverageFeedback());
																			for (int j = 0; j < rating; j++) {
																%><i class='trainer-dash-star fa fa-star  mx-2'></i>
																<%
																	}
																			if (rating < 5) {
																				for (int j = rating; j < 5; j++) {
																%><i class='trainer-dash-star fa fa-star-o  mx-2'></i>
																<%
																	}
																			}
																		} else {
																%><i class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																	class='trainer-dash-star fa fa-star-o  mx-2'></i>
																<%
																	}
																%>
															</p>
														</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Total Hours Taught</h4>
												    	<h4 class="trainerinfo-type-value mb-0"><%=events.getAssociateTrainer().getTotalHoursTaught()!=null ?events.getAssociateTrainer().getTotalHoursTaught():0%> Hrs</h4>
												    	</div>
												    </div>
												    </div>
												  </div>
												  <div class="trainerinfo-label text-center"><h3 class="trainerinfo-label-text text-center">Assistant Trainer</h3></div>
												</div>
											
											<%}%>
											</div>
											
												<div class="tab-pane p-5" id="attendance" role="tabpanel">
													<div class="row">
														<div class="col-md-6">
															<div class="card attendance-card-size">
																<div class="card-block">
																	<div class="row m-0 p-3">
																		<div class="col-md-9 pl-0">
																			<h2 class="attendance-card-label mb-0">Present</h2>
																		</div>
																		<div class="col-md-3 pr-0">
																			<h2 class="attendance-card-count mb-0 float-right"><%=events.getEventAttendance()!=null && events.getEventAttendance().getPresentStudents()!=null ? events.getEventAttendance().getPresentStudents().size():0%></h2>
																		</div>
																	</div>
																	<hr class="m-0">
																	<div class="attendance-scroll custom-scroll-holder p-3">
																		<%
																			if (events.getEventAttendance() != null && events.getEventAttendance().getPresentStudents() != null) {
																				for (int i = 0; i < events.getEventAttendance().getPresentStudents().size(); i++) {
																		%>
																		<div class="row m-0 py-1">
																			<div class="col-md-2 px-0 pr-3">
																				<img class="attendance-user-img-small" alt="image"
																					src="<%=events.getEventAttendance().getPresentStudents().get(i).getImageUrl() != null
															? (events.getEventAttendance().getPresentStudents().get(i).getImageUrl().startsWith("http")
																	? events.getEventAttendance().getPresentStudents().get(i).getImageUrl()
																	: AppProperies.getProperty("media_url_path")
																			+ events.getEventAttendance().getPresentStudents().get(i).getImageUrl())
															: ""%>">
																			</div>
																			<div class="col-md-10 px-0 my-auto">
																				<h2 class="attendance-user-name mb-0"><%=events.getEventAttendance().getPresentStudents().get(i).getName()%></h2>
																			</div>
								
								
																		</div>
																		<%
																			}
								
																			}
																		%>
																	</div>
																	<div class="fadeout-area"></div>
																</div>
															</div>
														</div>
														<div class="col-md-6">
															<div class="card attendance-card-size">
																<div class="card-block">
																	<div class="row m-0 p-3">
																		<div class="col-md-9 pl-0">
																			<h2 class="attendance-card-label mb-0">Absent</h2>
																		</div>
																		<div class="col-md-3 pr-0">
																			<h2 class="attendance-card-count mb-0 float-right"><%=events.getEventAttendance()!=null && events.getEventAttendance().getAbsentStudents()!=null ? events.getEventAttendance().getAbsentStudents().size():0%></h2>
																		</div>
																	</div>
																	<hr class="m-0">
																	<div class="attendance-scroll custom-scroll-holder p-3">
																		<%
																			if (events.getEventAttendance() != null && events.getEventAttendance().getAbsentStudents() != null) {
																				for (int i = 0; i < events.getEventAttendance().getAbsentStudents().size(); i++) {
																		%>
																		<div class="row m-0 py-1">
																			<div class="col-md-2 px-0 pr-3">
																				<img class="attendance-user-img-small" alt="image"
																					src="<%=events.getEventAttendance().getAbsentStudents().get(i).getImageUrl() != null
															? (events.getEventAttendance().getAbsentStudents().get(i).getImageUrl().startsWith("http")
																	? events.getEventAttendance().getAbsentStudents().get(i).getImageUrl()
																	: AppProperies.getProperty("media_url_path")
																			+ events.getEventAttendance().getAbsentStudents().get(i).getImageUrl())
															: ""%>">
																			</div>
																			<div class="col-md-10 px-0 my-auto">
																				<h2 class="attendance-user-name mb-0"><%=events.getEventAttendance().getAbsentStudents().get(i).getName()%></h2>
																			</div>
								
								
																		</div>
																		<%
																			}
								
																			}
																		%>
																	</div>
																</div>
															</div>
															<div class="fadeout-area"></div>
														</div>
													</div>
												</div>
											<div class="tab-pane p-5" id="feedback" role="tabpanel">
												<div class="row">
													<div class="col-md-6">
														<div class="card feedback-card-size">
															<div class="card-block">
																<div class="row m-0 p-3">
																	<div class="col-md-6 feedback-card-header p-0">Trainer</div>
																	<div class="col-md-6 p-0">
																		<!-- <p class="stars float-right m-0">
																			<i class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star-o mx-2"></i><i
																				class="trainer-dash-star fa fa-star-o mx-2"></i>
																		</p> -->
																		
																		<p class="stars float-right m-0">
																			<%
																				if (events.getTrainerFeedback() != null && events.getTrainerFeedback().getRating()!=null &&events.getTrainerFeedback().getRating() > 0) {
																						int rating = (int) ((float) events.getTrainerFeedback().getRating());
																						for (int j = 0; j < rating; j++) {
																			%><i class='trainer-dash-star fa fa-star  mx-2'></i>
																			<%
																				}
																						if (rating < 5) {
																							for (int j = rating; j < 5; j++) {
																			%><i class='trainer-dash-star fa fa-star-o  mx-2'></i>
																			<%
																				}
																						}
																					} else {
																			%><i class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i>
																			<%
																				}
																			%>
																		</p>
																	</div>
																</div>
																<hr class="my-0">
																<div class="p-3">
																<h4 class="feedback-comment-title pt-2">Comments</h4>
																<div class="feedback-comment-box mt-3 popover-dismiss" data-toggle="popover" data-trigger="hover" data-placement="top" data-content="<%=events.getTrainerFeedback()!=null && events.getTrainerFeedback().getComment()!=null && events.getTrainerFeedback().getComment().length()>0?events.getTrainerFeedback().getComment():"N/A"%>"><%=events.getTrainerFeedback()!=null && events.getTrainerFeedback().getComment()!=null && events.getTrainerFeedback().getComment().length()>0 ?events.getTrainerFeedback().getComment():"N/A"%></div>
																</div>
															</div>
														</div>
													</div>
													
													
													
													<div class="col-md-6">
													<div class="student-feedback-scroll custom-scroll-holder">
													<%for(int i=0;events.getStudentFeedback()!=null && i<events.getStudentFeedback().size();i++){ 
														String style = "";
														String collapseThis ="";
														if(i != 0){
															style = "style='display:none !important;'";
															collapseThis = "collapsable";
														}
														
														EventFeedback eventFeedback=events.getStudentFeedback().get(i);
														
														%>
														<div class="card feedback-card-size <%=collapseThis %> mb-2"  <%=style %>>
															<div class="card-block">
																<div class="row m-0 p-3">
																	<div class="col-md-6 feedback-card-header p-0">Student</div>
																	<div class="col-md-6 p-0">
																		<p class="stars float-right m-0">
																			<%
																				if (eventFeedback.getRating()!=null &&eventFeedback.getRating() > 0) {
																						int rating = (int) ((float) eventFeedback.getRating());
																						for (int j = 0; j < rating; j++) {
																			%><i class='trainer-dash-star fa fa-star  mx-2'></i>
																			<%
																				}
																						if (rating < 5) {
																							for (int j = rating; j < 5; j++) {
																			%><i class='trainer-dash-star fa fa-star-o  mx-2'></i>
																			<%
																				}
																						}
																					} else {
																			%><i class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i><i
																				class='trainer-dash-star fa fa-star-o  mx-2'></i>
																			<%
																				}
																			%>
																		</p>
																	</div>
																</div>
																<hr class="my-0">
																<div class="p-3">
																<h4 class="feedback-comment-title pt-2">Comments</h4>
																<div class="feedback-comment-box mt-3 popover-dismiss" data-toggle="popover" data-trigger="hover" data-placement="top" data-content="<%=eventFeedback.getComment()!=null?eventFeedback.getComment():"N/A"%>"><%=eventFeedback.getComment()!=null?eventFeedback.getComment():"N/A"%></div>
																</div>
															</div>
														</div>
															<%} %>
															</div>
														
														<%if(events.getStudentFeedback()!=null && events.getStudentFeedback().size()>1){%>	
														<div class="float-right" style="position: relative"><a class="attendance-card-count show-more" style="cursor: pointer;"><u>Show more</u></a></div>
														<%}%>
														
													</div>
												</div>
											</div>
											<div class="tab-pane p-4" id="assessment" role="tabpanel" style="height: 385px;">
												<div class="card">
													<div class="card-block px-4 pt-4">
														<h1 class="assessment-card-title mt-0">Learning Objective Covered In Event</h1>
														<p class="assessment-card-content">
														<%=events.getLearningObjCovered()!=null && events.getLearningObjCovered().size()>0? StringUtils.join(events.getLearningObjCovered(), ","):"N/A" %>
														</p>
													</div>
												</div>
											</div>
											<div class="tab-pane px-5 py-4 event-session-holder custom-scroll-holder" id="sessionlog" role="tabpanel">
												
												<%for(int i=0;i<100;i++){ %>
												<div class="card session-log-card mb-4">
												  <div class="card-block">
												    <div class="row m-0 p-3">
												    	<div class="col-md-6 p-0">
												    		<div class="row m-0">
												    		<img src="/assets/images/icons_8_clock2.png" srcset="/assets/images/icons_8_clock2.png 2x, /assets/images/icons_8_clock3.png 3x" class="icons8-clock" style='align-self: center;'>
												    		<p class="session-log-timestamp m-0">14 : 09 : 00</p>
												    		</div>
												    	</div>
														<div class="col-md-6 p-0">
															<div class="row m-0 float-right">
																<div class="session-log-slidetime">Total Time Spent on
																	Slide :</div>
																<p class="session-log-timestamp my-auto">5 Sec</p>
															</div>
														</div>
													</div>
												    <hr class="m-0">
												    <div class="p-3">
													<div class="row m-0 mb-1">
														<h4 class="event-session-log-title m-0">Slide Title</h4>
														<h4 class="event-session-log-desc m-0">Website strategy   (Id :17473)</h4>
													</div>
													<div class="row m-0 mb-1">
														<h4 class="event-session-log-title m-0">Lesson Title</h4>
														<h4 class="event-session-log-desc m-0">Website strategy   (Id :17473)</h4>
													</div>
													<div class="row m-0 mb-1">
														<h4 class="event-session-log-title m-0">Session Title</h4>
														<h4 class="event-session-log-desc m-0">Website strategy   (Id :17473)</h4>
													</div>
													</div>
												</div>
												</div>
												<%} %>
												
											</div>
									</div>
								</div>
							</div>
							  </div>
