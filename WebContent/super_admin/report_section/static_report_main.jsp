<%@page import="in.talentify.core.utils.UIUtils"%>
<% 


UIUtils ui_Util = new UIUtils();
 %>
 <div class="row border-bottom white-bg report-padding ">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-content">
			
				<div class="row">
					<div class="col-lg-4">
			<div class="form-group">
				<label>Choose Organization</label> 
				<select class="form-control m-b org_holder " name="orgID">
			<%= ui_Util.getOrganization() %>

				</select>
			</div>
			</div>
				</div>
				
			</div>
		</div>
	</div> 

	
	
	<div class="row border-bottom white-bg ">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-title">
				<h2 class="text-center">PROGRAMS</h2>
			</div>
			<div class="ibox-content " style="overflow: auto;">
			
				<div class="row " style="display: flex;" id="course_event_card" >
					
				</div>
				
			</div>
		</div>
	</div>
	<div class="row border-bottom white-bg ">
	
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-title">
				<h2 class="text-center">BATCHES</h2>
			</div>
			<div class="ibox-content " style="overflow: auto;">
				<div class="row " style="display: flex;" id="batch_event_card">
					
				</div>
			</div>
		</div>
	</div>
	<br>
	<br>
	<br>
