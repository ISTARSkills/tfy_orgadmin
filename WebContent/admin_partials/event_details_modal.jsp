<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
<%-- <%
int eventId = Integer.parseInt(request.getParameter("event_id"));
%> --%>
							  <div class="modal-dialog modal-lg">
							    <div class="modal-content custom-event-container">
							      <div class="modal-header custom-event-modal-header">
							      <div class="container">
							      <div class="row">
							      <div class="col-md-2"><img alt="image" class="img-thumbnail-medium" src="http://cdn.talentify.in:9999/course_images/m_106.png"></div>
											<div class="col-md-10">
												<div class="row">
													<div class="col-md-10">
														<div class="row custom-no-margins">
															<img src="/assets/images/icons_8_clock2.png"
																srcset="/assets/images/icons_8_clock2.png 2x, /assets/images/icons_8_clock3.png 3x"
																class="icons8-clock">
															<h1 class="am-hrs custom-no-margins">8 AM</h1>
															<img src="/assets/images/icons_8_empty_hourglass2.png"
																srcset="/assets/images/icons_8_empty_hourglass2.png 2x, /assets/images/icons_8_empty_hourglass3.png 3x"
																class="icons8-empty_hourglass">
															<h1 class="am-hrs custom-no-margins">8 Hrs</h1>
														</div>
													</div>
													<div class="col-md-2">
														<button type="button"
															class="close float-right custom-close-modal"
															data-dismiss="modal" aria-label="Close">X</button>
													</div>
												</div>
												<div class="row"><h1 class="custom-modal-header-trainer">Operations of Bank -2</h1> <div class="custom-oval-icon"><img src="/assets/images/icons_8_video_call2.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x" class=""></div></div>
												<div class="row m-0">
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Roles </h4><h4 class="modal-info-content mb-0">Retail Banking</h4></div></div>
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Group </h4><h4 class="modal-info-content mb-0">FY.BCom</h4></div></div>
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Trainer </h4><h4 class="modal-info-content mb-0">Miriam Thomas</h4></div></div>
												</div>
											</div>
										</div>
							      </div>
							        <!-- <h4 class="modal-title" id="myLargeModalLabel">Large modal</h4> -->
							        
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
												    <div class="col-md-3"><img alt="image" src="https://scontent.fblr2-1.fna.fbcdn.net/v/t31.0-8/1978390_691722690897867_9093125142540358371_o.jpg?oh=c72b63dc71cf2cb557e9eec7e57322fd&oe=5A5DDFC1" class="trainer-info-img"></div>
												    <div class="col-md-9">
												    	<h1 class="trainerinfo-trainername mb-0">Miriam Thomas</h1>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Skills</h4>
												    	<h4 class="trainerinfo-type-value mb-0">Certified Retail Banker ( CRB )</h4>
												    	</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0 mt-1">Average feedback</h4>
															<p class="stars float-right m-0">
																<i class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i>
															</p>
														</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Total Hours Taught</h4>
												    	<h4 class="trainerinfo-type-value mb-0">79 Hrs</h4>
												    	</div>
												    </div>
												    </div>
												  </div>
												</div>
												<div class="card trainerinfo-card mt-5">
												  <div class="card-block">
												    <div class="row">
												    <div class="col-md-3"><img alt="image" src="https://scontent.fblr2-1.fna.fbcdn.net/v/t31.0-8/1978390_691722690897867_9093125142540358371_o.jpg?oh=c72b63dc71cf2cb557e9eec7e57322fd&oe=5A5DDFC1" class="trainer-info-img"></div>
												    <div class="col-md-9">
												    	<h1 class="trainerinfo-trainername mb-0">Sandeep Sharma</h1>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Skills</h4>
												    	<h4 class="trainerinfo-type-value mb-0">Certified Retail Banker ( CRB )</h4>
												    	</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0 mt-1">Average feedback</h4>
															<p class="stars float-right m-0">
																<i class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i><i
																	class="trainer-dash-star fa fa-star-o mx-2"></i>
															</p>
														</div>
												    	<div class="row m-0 mt-3">
												    	<h4 class="trainerinfo-type-name mb-0">Total Hours Taught</h4>
												    	<h4 class="trainerinfo-type-value mb-0">79 Hrs</h4>
												    	</div>
												    </div>
												    </div>
												  </div>
												  <div class="trainerinfo-label text-center"><h3 class="trainerinfo-label-text text-center">Assistant Trainer</h3></div>
												</div>
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
																			<h2 class="attendance-card-count mb-0 float-right">46</h2>
																		</div>
																	</div>
																	<hr class="m-0">
																	<div class="attendance-scroll custom-scroll-holder p-3">
																	<%for(int i=0;i<15;i++){ %>
																		<div class="row m-0 py-1">
																			<div class="col-md-2 px-0 pr-3"><img class="attendance-user-img-small" alt="image" src="https://scontent.fblr2-1.fna.fbcdn.net/v/t31.0-8/1978390_691722690897867_9093125142540358371_o.jpg?oh=c72b63dc71cf2cb557e9eec7e57322fd&oe=5A5DDFC1"></div>
																			<div class="col-md-10 px-0 my-auto"><h2 class="attendance-user-name mb-0">Anu Agarwal</h2></div>
																		</div>
																	<%} %>
																	</div>
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
																			<h2 class="attendance-card-count mb-0 float-right">4</h2>
																		</div>
																	</div>
																	<hr class="m-0">
																	<div class="attendance-scroll custom-scroll-holder p-3">
																	<%for(int i=0;i<4;i++){ %>
																		<div class="row m-0 py-1">
																			<div class="col-md-2 px-0 pr-3"><img class="attendance-user-img-small" alt="image" src="https://scontent.fblr2-1.fna.fbcdn.net/v/t31.0-8/1978390_691722690897867_9093125142540358371_o.jpg?oh=c72b63dc71cf2cb557e9eec7e57322fd&oe=5A5DDFC1"></div>
																			<div class="col-md-10 px-0 my-auto"><h2 class="attendance-user-name mb-0">Anu Agarwal</h2></div>
																		</div>
																	<%} %>
																	</div>
																</div>
															</div>
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
																		<p class="stars float-right m-0">
																			<i class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star-o mx-2"></i><i
																				class="trainer-dash-star fa fa-star-o mx-2"></i>
																		</p>
																	</div>
																</div>
																<hr class="my-0">
																<div class="p-3">
																<h4 class="feedback-comment-title pt-2">Comments</h4>
																<div class="feedback-comment-box mt-3">Average attendance.. Lab session tomorrow.. Hopefully expect better attendence</div>
																</div>
															</div>
														</div>
													</div>
													<div class="col-md-6">
														<div class="card feedback-card-size">
															<div class="card-block">
																<div class="row m-0 p-3">
																	<div class="col-md-6 feedback-card-header p-0">Student</div>
																	<div class="col-md-6 p-0">
																		<p class="stars float-right m-0">
																			<i class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star mx-2"></i><i
																				class="trainer-dash-star fa fa-star-o mx-2"></i><i
																				class="trainer-dash-star fa fa-star-o mx-2"></i>
																		</p>
																	</div>
																</div>
																<hr class="my-0">
																
															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="tab-pane p-4" id="assessment" role="tabpanel">
												<div class="card">
													<div class="card-block px-4 pt-4">
														<h1 class="assessment-card-title mt-0">Learning Objective Covered In Event</h1>
														<p class="assessment-card-content">
														Understand how to build website pages and layouts using Weebly, understanding the use of a landing page, understanding the use of a website, understanding website and webpage design. Understand the importance of a domain name for a website, understand the practical applications of website creation using Weebly, understand the usage of an infomercial page, understand the usage of a squeezer page, understand the usage of a teaser landing page, understand the usage of a viral landing page, understand to how to create a website strategy.
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
