<%@page import="com.istarindia.apps.dao.RecruiterPanelistMapping"%>
<%@page import="com.istarindia.apps.dao.RecruiterDAO"%>
<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%@page import="com.istarindia.apps.dao.IstarTaskWorkflow"%>
<%@page import="java.util.UUID"%>
<%@page import="com.istarindia.apps.dao.IstarTaskTypeDAO"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.istarindia.apps.dao.IstarTaskType"%>
<%@page import="java.util.Set"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%

int recruiter_id = Integer.parseInt(request.getParameter("recruiter_id"));
Recruiter rec = new RecruiterDAO().findById(recruiter_id);
String panelist="";
for(RecruiterPanelistMapping map : rec.getRecruiterPanelistMappings())
{
	panelist+= map.getPanelist().getName()+",";	
}
%>
<div class="panel-body" style="width: 100%;">
	<h2>Pipeline Stages</h2>
	<div id="work_flow_stages">
		<div class="tabs-container">
			<ul class="nav nav-tabs" id="stage_tab">
				<li class="active tab_number_1" id="tab_number" data-tab_number="1"><a data-toggle="tab" href="#stage_1"> Stage 1</a></li>				
			</ul>
			<div class="tab-content concrete_stage_content">
				<div id="stage_1" class="tab-pane active">
					<div class="panel-body tab_number_1" data-tab_number="1" style="margin-left: 0%; min-height: 150px;" >
						<div class="form-group">
							<label>Stage Name *</label> <label class="error" for="stageName"
								style="display: none;"></label> <input id="stage_name_1"
								name="stage_title_1" type="text"
								class="form-control required valid concrete_stages" aria-required="true"
								aria-invalid="false" placeholder="Stage Name" data-validation="required">
						</div>
						<div class="row">
							<div class="form-group col-md-6">
								<select class="form-control m-b stage_selector" id="id_stage_selector_1"  name="stage_type_1" data-validation="required">
									<option hidden selected disabled>Select Stage Type</option>
									<option value="assessment">Test</option>
									<option value="external_assessment">External Assessment Test</option>
									<option value="interview">Interview</option>	
									<option value="other">Other</option>
								</select>
							</div>
							<div class="form-group col-md-6 test_action_form"  id="test_action_form_1">
								<select class="form-control m-b" name="stage_action_1" id="id_stage_action_1">																										
								</select>
							</div>
						</div>
						<div class="form-group interview_action_form" id="interview_action_form_1">
							<label>Select Interviewer *</label> <input
								class="tagsinput form-control" type="text"
								name="stage_interviewer_1" id="stage_interviewer_id_1" value="<%=panelist%>" />
						</div>
						
						<div class="form-group url_action_form" id="url_action_form_1">
						<label> URL </label>
						<input type="text" name="stage_external_assesment_1" placeholder="https://www.topcoder.com/" class="form-control" id="stage_external_assesment_id_1"/>						
						</div>
						
						<div class="form-group other_action_form" id="other_action_form_1">
							<label>Enter Details about stage*</label>
							<textarea rows="4" cols="50" class="form-control"
								name="stage_other_1" id="stage_other__id_1">
							Details about stage.
							</textarea>
						</div>
								
					</div>
				</div>
			</div>
			<br/>
			<div class="form-group">
			<button class="btn btn-primary" type="button" id="btnAdd">Add Stage</button>
			<button class="btn btn-primary" type="button" id="btnDel">Remove Stage</button>
			<button class="btn btn-primary confirmStageSubmission" type="submit" id="create_update_stages" data-loading-text="Submitting">Submit</button>													
			</div>
		</div>
	</div>

</div>


	        