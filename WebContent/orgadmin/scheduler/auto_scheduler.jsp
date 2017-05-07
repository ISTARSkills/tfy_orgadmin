<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<div class="row">
	<div class="col-lg-12">
		<div class="col-lg-12">
			<div class="ibox">
				<div class="ibox-content">
					<div id="wizard">
						<h1>Select Entity</h1>
						<div class="step-content" style="position: relative !important;">

							<div class="row">
								<div class="col-lg-4">
									<div class="form-group">
										<label>Entity Type*</label> <select class="select2_demo_1 form-control">
											<option value="USER">User</option>
											<option value="SECTION">Section</option>
											<option value="ROLE">Role</option>
										</select>

									</div>
									<div class="form-group">
										<label>Select Entity*</label> <select class="select2_demo_1 form-control">
											<%for(int i=0; i<10;i++){
	                                       %>
											<option value="mayank1@istarindia.com">Mahyank
												<%=i%></option>
											<% }%>
										</select>

									</div>
								</div>
							</div>
						</div>

						<h1>Select Course</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="text-center m-t-md">
								<div class="row">
									<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");							
				%>
									<%=util.getTableOuterHTML(3056, conditions)%>
								</div>

							</div>
						</div>
						<h1>Edit Course</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="row m-b-lg m-t-lg">
								<div class="col-lg-3">
									<div class="col-md-12">


										<div class="profile-info" style="margin-left: 0px !important;">
											<div class="">
												<div>
													<h2 class="no-margins">Direct Tax Theory</h2>
													<h3>Section : BCOM Final Year</h3>

												</div>
											</div>
										</div>
										<div class="row  m-t-sm">
											<div class="col-sm-4">
												<div class="font-bold">#Students</div>
												55
											</div>
											<div class="col-sm-4">
												<div class="font-bold">#Sessions</div>
												22
											</div>
											<div class="col-sm-4">
												<div class="font-bold">#Lessons</div>
												12
											</div>
										</div>
										<br>
										<div class="form-group">
											<label>Select Start Date</label> <select class="select2_demo_1 form-control">
												<%for(int i=0; i<10;i++){
	                                       %>
												<option value="mayank1@istarindia.com">Mahyank
													<%=i%></option>
												<% }%>
											</select>

										</div>
										<div class="form-group">
											<label>Select End Date</label> <select class="select2_demo_1 form-control">
												<%for(int i=0; i<10;i++){
	                                       %>
												<option value="mayank1@istarindia.com">Mahyank
													<%=i%></option>
												<% }%>
											</select>

										</div>
										<div class="form-group">
											<label>Select Days of Week &nbsp;</label><br> <label class="checkbox-inline"> <input type="checkbox" value="SUN" name="scheduled_days"> SUN
											</label> <label class="checkbox-inline"> <input type="checkbox" value="MON" name="scheduled_days"> MON
											</label> <label class="checkbox-inline"> <input type="checkbox" value="TUE" name="scheduled_days"> TUE
											</label> <label class="checkbox-inline"> <input type="checkbox" value="WED" name="scheduled_days"> WED
											</label><br> <label class="checkbox-inline"> <input type="checkbox" value="THU" name="scheduled_days"> THU
											</label> <label class="checkbox-inline"> <input type="checkbox" value="FRI" name="scheduled_days"> FRI
											</label> <label class="checkbox-inline"> <input type="checkbox" value="SAT" name="scheduled_days"> SAT
											</label>
										</div>
										<div class="form-group">
											<label>Tasks Per Day</label>
											<input type="text" class="form-control" name="frequency">
										</div>
								<div class="form-group">
                                    <button class="btn btn-primary" type="submit">Save </button>
                                </div>
									</div>




								</div>
								<%-- <div class="row">
								
								 <div class="col-lg-4">
								 
								  <div class="form-group">
										<label>Entity Name </label> BTech 2nd Year

									</div>
									<div class="form-group">
										<label>Entity Type </label> Section

									</div>
									<div class="form-group">
										<label>Course Name </label> Direct Tax Theory

									</div>
								 
								
                                
                                
                            </div>
									<div class="form-group">
										<label>Course Name*</label> Direct Tax Theory
									</div>
									<div class="form-group">
										<label>Select Entity*</label> <select class="select2_demo_1 form-control">
											<%for(int i=0; i<10;i++){
	                                       %>
											<option value="mayank1@istarindia.com">Mahyank
												<%=i%></option>
											<% }%>
										</select>

									</div>
								</div> 
								
							</div> --%>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>

	</div>