<%@page import="in.talentify.core.utils.UIUtils"%>
<% 


UIUtils ui_Util = new UIUtils();
 %>
 <div class="row border-bottom white-bg">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-content">
			
				<div class="row">
					<div class="col-lg-2">
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
<div class="row border-bottom white-bg">
	<div id="super_admin_batch_programs" style="    background: white;">
	</div>
	</div>
	<br>
	<br>
	<br>
