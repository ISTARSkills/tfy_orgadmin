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

		<form id="idForm1" class="form">
			<input type="hidden" name="AdminUserID" value="300" /> <input
				type="hidden" name="tabType" value="singleEvent" />

			<div class="form-group">
				<label>Choose Organization</label> <select
					class="form-control m-b org_holder scheduler_select" name="orgID">	
					<option value="<%=!istrue?colegeID:""%>"><%=!istrue?orgName:"Select Organization..." %></option>
					<%=ui.getOrganization()%>

				</select>
			</div>

			<div class="form-group">
				<label>Choose Trainer</label> <select
					class="form-control m-b scheduler_select" name="trainerID">
					<option value="">Select Trainer...</option>
					<%=ui.getAllTrainer(null)%>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="single_associateTrainerID_holder" name="associateTrainerID" value="0"/>
				<select data-placeholder="Select Associate Trainer"  multiple
						tabindex="4" name="" id="single_associateTrainerID" class="associateTrainer">
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
					<%= ui.getCoursesForBatches(colegeID)%>

				</select>
			</div>
			<div class="form-group">
				<label>Select Event Type</label> <select
					class="form-control m-b eventType" name="eventType">
					<option value="session">Session</option>
					<option value="assessment">Assessment</option>
<option value="webinar">Webinar (TOT)</option>
					<option value="remote_class">Remote Class</option>
				</select>
			</div>
			<div class="form-group">
				<div class="assessment_list" id="assessment_list"
					style="display: none;">

					<label>Select Assessment</label> <select
						class="form-control m-b assessment scheduler_select "
						style="width: 100%" name="assessmentID">
                      <option value='0'> Select Assessment...</option>

					</select>
				</div>
			</div>

			<div class="form-group">
				<label>Select Class-Room</label> <select class="form-control m-b"
					name="classroomID">
					 <option value="">Select Classroom...</option> 
					<%=ui.getAllClassroom(colegeID)%>

				</select>
			</div>
			
			<div class="form-group" id="data_2">
				<label class="font-bold">Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						name="eventDate" type="text" class="form-control date_holder"
						value="">
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
				<input type="number" value="1" name="hours" placeholder="Hours"
					class="form-control duration_holder" min="0"> <label
					class="sr-only">minute</label> <input type="number" value="0" min="0"
					name="minute" placeholder="Minute"
					class="form-control duration_holder">
			</div>
			<h4 class="text-danger display-error"></h4>
			<button class="btn btn-danger form-submit-btn custom-theme-btn-primary" data-form="idForm1"
				type="button">Save changes</button>
		</form>
	</div>

