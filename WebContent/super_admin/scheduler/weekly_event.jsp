<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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

		<form id="idForm3" class="form">
			<input type="hidden" name="AdminUserID" value="300" />
			<input type="hidden" name="tabType" value="weeklyEvent" />
			
			<div class="form-group">
				<label>Choose Organization</label> <select
					class="form-control m-b org_holder scheduler_select" name="orgID">
					
					<option value="<%=!istrue?colegeID:""%>"><%=!istrue?orgName:"Select Organization..." %></option>
					<%=ui.getOrganization()%>

				</select>
			</div>
			
			<div class="form-group">
				<label>Choose Trainer</label> <select class="form-control m-b"
					name="trainerID">
					<option value="">Select Trainer...</option>
					<%=ui.getAllTrainer(null)%>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="weekly_associateTrainerID_holder" name="associateTrainerID" value="0"/>
				<select data-placeholder="Select Associate Trainer"  multiple
						tabindex="4" name="" id="weekly_associateTrainerID" class="associateTrainer">
						<option value="">Select Associate Trainers...</option>
					       <%=ui.getAllTrainer(null)%>

					</select>
			</div>
			<div class="form-group">
				<label>Choose Section</label> <select
					class="form-control m-b batchGroupID" name="">
					<option value="">Select Section...</option>
					<%=ui.getBatchGroups(colegeID,null)%>

				</select>
			</div>
			<div class="form-group">
				<label>Select Course</label> <select
					class="form-control m-b courseID" name="batchID">
					<option value="">Select Course...</option>
					<%=ui.getCoursesForBatches(colegeID)%>

				</select>
			</div>
			<div class="form-group">
				<label>Select Event Type</label> <select
					class="form-control m-b eventType" name="eventType">
					<option value="session">Session</option>
					<!-- <option value="assessment">Assessment</option> -->

				</select>
			</div>
			<!-- <div class="assessment_list" id="assessment_list"
				style="display: none;">
				<div class="form-group">
					<label>Select Assessment</label> <select
						class="form-control m-b assessment" name="assessmentID">
						<option value="">Select Assessment</option>

					</select>
				</div>
			</div> -->

			<div class="form-group">
				<label>Select Class-Room</label> <select class="form-control m-b"
					name="classroomID">
					<option value="">Select Classroom...</option>
					<%=ui.getAllClassroom(colegeID)%>

				</select>
			</div>
			<!-- <div class="form-group" id="data_2">
				<label class="font-bold">Start Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" name="startEventDate" class="form-control date_holder"
						value="03/03/2017">
				</div>
				<label class="font-bold">End Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" name="endEventDate" class="form-control date_holder"
						value="03/03/2017">
				</div>
			</div> -->
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
				<div class="input-group clockpicker" data-autoclose="true">
					<input type="text" class="form-control time_holder" name="startTime"
						value="09:30"> <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span>
				</div>

			</div>
			<div class="form-group form-inline">
				<label class="font-bold">Duration</label> <label class="sr-only">Hours</label>
				<input type="number" value="1" name="hours" placeholder="Hours"
					class="form-control duration_holder"> <label class="sr-only">minute</label>
				<input type="number" value="0" name="minute" placeholder="Minute"
					class="form-control duration_holder">
			</div>

			<div class="form-group">

				<label>Select Day</label> <select
					class="form-control m-b eventType" name="day">
					<option value="1">Monday</option>
					<option value="2">Tuesday</option>
					<option value="3">Wednesday</option>
					<option value="4">Thursday</option>
					<option value="5">Friday</option>
					<option value="6">Saturday</option>
					<option value="7">Sunday</option>


				</select>

			</div>
			<button class="btn btn-danger form-submit-btn custom-theme-btn-primary" data-form="idForm3"
				type="button">Save changes</button>
		</form>

	</div>
