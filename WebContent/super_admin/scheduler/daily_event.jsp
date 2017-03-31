
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

		<form id="idForm2" class="form">
			<input type="hidden" name="orgAdminUserID" value="300" />
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
					<%=ui.getAllTrainer()%>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="daily_associateTrainerID_holder" name="associateTrainerID" value=""/>
				<select data-placeholder="select Groups AssociateTrainerID"  multiple
						tabindex="4" name="" id="daily_associateTrainerID" class="associateTrainer">
						<option value="">Select Associate Trainers...</option>
					       <%=ui.getAllTrainer()%>

					</select>
			</div>
			<div class="form-group">
				<label>Choose Batches</label> <select
					class="form-control m-b batchGroupID scheduler_select" name="">
					<option value="">Select BatchGroup...</option>
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
				<label>Select Type</label> <select
					class="form-control m-b eventType scheduler_select" name="eventType">
					<option value="session">Session</option>
					<!-- <option value="assessment">Assessment</option> -->

				</select>
			</div>
			<!-- <div class="assessment_list" id="assessment_list"
				style="display: none;">
				<div class="form-group">
					<label>Select Assessment</label> <select
						class="form-control m-b assessment scheduler_select" name="assessmentID">
						<option value="null">Select Assessment</option>

					</select>
				</div>
			</div> -->

			<div class="form-group">
				<label>Select Class-Room</label> <select class="form-control m-b scheduler_select"
					name="classroomID">
					<option value="">Select classroom...</option>
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
				<label class="font-bold">Start Time</label>
				<div class="input-group clockpicker" data-autoclose="true">
					<input type="text" class="form-control time_holder" name="startTime"
						value="09:30"> <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span>
				</div>

			</div>
			<div class="form-group form-inline">
				<label class="font-bold">Duration</label> <label class="sr-only">Hours</label>
				<input type="number" value="" name="hours" placeholder="Hours"
					class="form-control duration_holder"> <label class="sr-only">minute</label>
				<input type="number" value="" name="minute" placeholder="Minute"
					class="form-control duration_holder">
			</div>
			<button class="btn btn-primary form-submit-btn" data-form="idForm2"
				type="button">Save changes</button>
		</form>

	</div>
