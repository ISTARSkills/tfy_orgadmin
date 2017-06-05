<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="in.talentify.core.utils.ColourCodeUitls"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int colegeID = (int)request.getSession().getAttribute("orgId");
%>
					<div class="ibox float-e-margins no-margins bg-muted">
						<div class="ibox-content">
						<div class="row show-grid white-bg" style="    margin: 0px;">
								<div class="col-lg-3 white-bg no-borders whit-bg-schedular" style="    padding-left: 1px;
    padding-top: 0px;">
									<h1 class="text-danger font-bold">Create A New Event</h1>
									<div class="tabs-container">
										<ul class="nav nav-tabs gray-bg-schedular">
											<li class="active"><a data-toggle="tab" href="#tab-1">Single
													Event</a></li>
											<li class=""><a data-toggle="tab" href="#tab-2">Daily</a></li>
											<li class=""><a data-toggle="tab" href="#tab-3">Weekly</a></li>
										</ul>
										<div class="tab-content">

											<jsp:include page="single_event.jsp"></jsp:include>
											<jsp:include page="daily_event.jsp"></jsp:include>
											<jsp:include page="weekly_event.jsp"></jsp:include>




										</div>


									</div>


								</div>
								<div class="col-lg-9 no-padding bg-muted">
									<div class="ibox no-padding no-margins bg-muted p-xs" style="padding-top: 5px;">
										<%=new ColourCodeUitls().getColourCode() %>
										 <div class="ibox-content">
											<%
											CalenderUtils  calUtil = new CalenderUtils();
											HashMap<String, String> input_params = new HashMap();
											
											input_params.put("org_id",colegeID+"");
											%>
											<%=calUtil.getCalender(input_params).toString()%>
										</div> 
									</div>
								</div>

								<!-- Events details modal -->
								<div class="modal inmodal fade" id="myModal5" tabindex="-1"
									role="dialog" aria-hidden="true">
									<input id="idOfForm" type="hidden" value="" />
									<div class="modal-dialog modal-lg">
										<div class="modal-content">
											<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
												<button type="button" class="close" data-dismiss="modal">
													<span aria-hidden="true">&times;</span><span
														class="sr-only">Close</span>
												</button>
												<h4 class="modal-title text-center">Event Details</h4>
												<h4 class="text-danger modal-subTitle"></h4>
											</div>
											<div class="modal-body">
												<div class="row" id="modal_data"></div>
											</div>

											<div class="modal-footer">
											  <h4 class="text-danger modal-subTitle pull-left"></h4>
												<button type="button" class="btn  btn-danger"
													data-dismiss="modal">Close</button>
												<button type="button" id="final_submit_btn" data-dismiss="modal"
													class="btn btn-primary custom-theme-btn-primary final-submit-btn">Save
													changes</button>
											</div>
										</div></div>
									</div>
								</div>

								<!--  -->

								<!-- modal -->

								<div class="modal inmodal" id="myModal2" tabindex="-1"
									role="dialog" aria-hidden="true">
													<input type="hidden" value="<%=colegeID%>" id="org_id">
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event-edit-modal">

										</div>
									</div>
								</div>


								<!--  -->

<!-- event details modal -->

								<div class="modal inmodal" id="event_details" tabindex="-1"
									role="dialog" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event_details">

										</div>
									</div>
								</div>


		<!--  -->
							</div>

						</div>


					</div>
				