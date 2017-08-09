<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.*"%>

<% 

int colegeID = -3;


UIUtils ui_Util = new UIUtils();
 %>
<div class="row border-bottom white-bg">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-content">

			<div class="row">
			<div class="col-lg-2">
			<div class="form-group">
				<label>Choose Organization</label> 
				<select class="form-control m-b org_holder_programTab " name="orgID">
				
					<%= ui_Util.getOrganization() %>

				</select>
			</div>
			</div>
			
				<div class="col-lg-2">
					<div class="form-group">
						<label>Choose Program</label> <select
							class="form-control m-b course_holder " name="courseID">
							
							<%= ui_Util.getCourses(colegeID) %>

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
			<h5></h5>
		</div>
		<div class="ibox-content ">
			<div class="row">
			
			
			
			
			<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");			
				%>
				
				<%=util.getTableOuterHTML(3047, conditions)%>
			
			
			
			</div>
		</div>
	</div>
</div>
<br>
<br>
<br>
