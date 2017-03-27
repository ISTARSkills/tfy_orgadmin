
<%@page import="com.istarindia.apps.dao.OrgAdmin"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<% /* OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user"); */
int college_id = (int)request.getSession().getAttribute("orgId");
UIUtils ui_Util = new UIUtils();
 %>
<div class="row border-bottom white-bg ">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-title">
				<h2 class="text-center">PROGRAMS</h2>
			</div>
			<div class="ibox-content " style="overflow: auto;">
			
				<div class="row " style="display: flex;">
					<%= ui_Util.getCourseEventCard(college_id) %>
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
				<div class="row " style="display: flex;">
					<%= ui_Util.getBatchCard(college_id) %>
				</div>
			</div>
		</div>
	</div>
	<br>
	<br>
	<br>
