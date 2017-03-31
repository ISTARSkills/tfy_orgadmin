<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.talentify.core.utils.ReportUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%><div class="row">
						<div class="col-lg-12 no-padding bg-muted">
							<div class="tabs-container">
								<ul class="nav nav-tabs">
									<li class="active"><a data-toggle="tab" href="#tab-11">Progress View</a></li>
									<li class=""><a data-toggle="tab" href="#tab-12">Competition View</a></li>
									<li class=""><a data-toggle="tab" href="#tab-13">Program View</a></li>
									<li class=""><a data-toggle="tab" href="#tab-14">Course View</a></li>

								</ul>
								<div class="tab-content">
									<div id="tab-11" class="tab-pane active">
										<div class="panel-body">
										<% HashMap<String, String> conditions = new HashMap(); %>
											<%=(new ReportUtils()).getHTML(4001, conditions).toString() %>
			

										</div>
									</div>
									<div id="tab-12" class="tab-pane">
										<div class="panel-body">
											<div id="competition_view"></div>
										</div>
									</div>
									<div id="tab-13" class="tab-pane">
										<div class="panel-body">
											<div class="form-group">
												<label class="col-sm-3 control-label">Select Course</label>

												<div class="col-sm-4">
													<select class="form-control m-b" name="account">
														<option>option 1</option>
														<option>option 2</option>

													</select>

												</div>
											</div>
											<div id="program_view"></div>
										</div>
									</div>
									<div id="tab-14" class="tab-pane">
										<div class="panel-body">

											<div class="form-group">
												<label class="col-sm-3 control-label">Select Batch Group</label>

												<div class="col-sm-4">
													<select class="form-control m-b" name="account">
														<option>option 1</option>
														<option>option 2</option>

													</select>

												</div>
											</div>
											<div id="course_view"></div>
										</div>
									</div>
								</div>


							</div>
						</div>