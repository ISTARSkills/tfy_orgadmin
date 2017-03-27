
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.utils.*"%>
<%@page import="java.util.*"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");

	OrgadminUtil util = new OrgadminUtil();
	ArrayList<College> colleges = util.getOrgInFilter(user, baseURL);
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><div class="col-lg-6" style="margin-top: 10px; max-height: 650px; min-height: 650px">
	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<h5>Reports</h5>
			<div class="ibox-tools">
				<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
				</a> <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false"> <i class="fa fa-wrench"></i>
				</a>
				<ul id="org_filter_report" class="dropdown-menu dropdown-user" style="width: 301px;">
					<li><a value="None" href="#">Select College</a> <%
 	for (College c : colleges) {
 		String collegeName = c.getName().trim();
 		if (collegeName.trim().length() > 40) {
 			collegeName = collegeName.substring(0, 40).trim();
 		}
 %> <label style="width: 100%; margin-left: 10px;"> <input value="<%=c.getId()%>" type="checkbox" checked = "checked" class="i-checks"> <%=collegeName.trim()%></label> <%
 	}
 %></li>
				</ul>
				<a class="close-link"> <i class="fa fa-times"></i>
				</a>
			</div>
		</div>
		<div class="ibox-content" style="display: block; max-height: 500px; min-height: 500px; padding: 0px">
			<div class="tabs-container" style="background: #23c6c8" id="dashboard2">
				<ul class="nav nav-tabs" id="r_data">
					<li value="program" class="active"><a data-toggle="tab" href="#tab-2">Report of Programs</a></li>
					<li value="student" class=""><a data-toggle="tab" href="#tab-1">Student Report</a></li>
				</ul>
				<div class="tab-content">
					
				
			<div id="tab-2" class="tab-pane active">
				<select class="form-control m-b  pull-right" onchange='getBatchGroups()' id="batch_filter1" name="select_drop" value="" Selected="selected" style="    width: 140px;">
					<option value="NONE" selected="selected">Select Programs</option>
				</select>
				<div id="Bgraph">
					<div class="well">
						<h1 class="text-center">NO DATA</h1>
					</div>
				</div>
			</div>
			<div id="tab-1" class="tab-pane ">
						<select class="form-control m-b pull-right" onchange='getStudent()' id="stud_filter1" name="select_drop" value="" Selected="selected" style="    width: 140px;">
							<option value="NONE" selected="selected">Select Student</option>
						</select>
						<div id="Sgraph">
							<div class="well">
								<h1 class="text-center">NO DATA</h1>
							</div>
						</div>
					</div>
		</div>
	</div>
</div>
</div>
</div>