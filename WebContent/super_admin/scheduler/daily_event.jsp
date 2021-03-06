
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>


<%
	UIUtils ui = new UIUtils();
  boolean istrue = false;
  int colegeID = 0;
  String orgName = "Select Organization...";
	if (request.getParameterMap().containsKey("orgID") && !request.getParameter("orgID").equalsIgnoreCase("0")) {
		 colegeID = Integer.parseInt( request.getParameter("orgID"));
		
		 Organization college = new Organization();
		 OrganizationDAO collegeDAO = new OrganizationDAO();
		 college = collegeDAO.findById(colegeID);
		 orgName = college.getName();
		 
	}
%>

	<div class="panel-body border-event">

		<form id="idForm2" class="form">
			<input type="hidden" name="AdminUserID" value="300" />
			<input type="hidden" name="tabType" value="dailyEvent" />

<div class="form-group">
				<label>Choose Organization</label> <select
					class="form-control m-b org_holder scheduler_select" name="orgID">
					
					<option value="<%=!istrue?colegeID:""%>"><%=!istrue?orgName:"Select Organization..." %></option>
					<%=ui.getOrganization()%>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Trainer</label> <select class="form-control m-b scheduler_select"
					name="trainerID">
					<option value="">Select Trainer...</option>
					<%=ui.getAllTrainer(null)%>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="daily_associateTrainerID_holder" name="associateTrainerID" value="0"/>
				<select data-placeholder="Select Associate Trainer"  multiple
						tabindex="4" name="" id="daily_associateTrainerID" class="associateTrainer">
						<option value="">Select Associate Trainers...</option>
					       <%=ui.getAllTrainer(null)%>

					</select>
			</div>
			<div class="form-group">
				<label>Choose Section</label> <select
					class="form-control m-b batchGroupID scheduler_select" name="">
					<option value="">Select Section...</option>
					 <%=ui.getBatchGroups(colegeID,null)%> 

				</select>
			</div>
			<div class="form-group">
				<label>Select Course</label> <select
					class="form-control m-b courseID scheduler_select" name="batchID">
					<option value="">Select Course...</option>
					 <%=ui.getCoursesForBatches(colegeID)%> 

				</select>
			</div>
			<div class="form-group">
				<label>Select Event Type</label> <select
					class="form-control m-b eventType scheduler_select" name="eventType">
					<option value="session">Session</option>
					<option value="webinar">Webinar (TOT)</option>
					<option value="remote_class">Remote Class</option>

				</select>
			</div>
			

			<div class="form-group">
				<label>Select Class-Room</label> <select class="form-control m-b scheduler_select"
					name="classroomID">
					<option value="">Select Classroom...</option>
					<%=ui.getAllClassroom(colegeID)%>

				</select>
			</div>
			
			 <div class="form-group" id="data_5">
                                <label class="font-bold">Event Date Range</label>
                                <div class="input-daterange input-group" id="datepicker">
                                    <input type="text" class="input-sm form-control date_holder"  name="startEventDate" value="31/03/2017"/>
                                    <span class="input-group-addon">to</span>
                                    <input type="text" class="input-sm form-control date_holder"name="endEventDate" value="01/04/2017" />
                                </div>
                            </div>

			<div class="form-group">
				<label class="font-bold">Event Time</label>
				<div class="input-group" data-autoclose="true">
					 <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span>
					<!-- <input class='customcss_singlescheduler' type="text"  name="startTime" class="time_element"/> -->
					<input type="text" style="width: 100%; height: 28px;" name="startTime" class="time_element"/>
				</div> 
				

			</div>
			<div class="form-group form-inline">
				<label class="font-bold">Duration</label> <label class="sr-only">Hours</label>
				<input type="number" value="1" name="hours" placeholder="Hours" min="0"
					class="form-control duration_holder"> <label class="sr-only">minute</label>
				<input type="number" value="0" name="minute" placeholder="Minute" min="0"
					class="form-control duration_holder">
			</div>
			<button class="btn btn-danger form-submit-btn custom-theme-btn-primary" data-form="idForm2"
				type="button">Save changes</button>
		</form>

	</div>
