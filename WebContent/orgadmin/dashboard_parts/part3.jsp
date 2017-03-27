
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
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><div class="col-lg-6"
	style="margin-top: 109px; max-height: 650px; min-height: 650px">
	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<h5>Current Events</h5>
			<div class="ibox-tools">
				<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
				</a> <a class="dropdown-toggle" data-toggle="dropdown" href="#"
					aria-expanded="false"> <i class="fa fa-wrench"></i>
				</a>
				<ul id="org_filter_event" class="dropdown-menu dropdown-user"
					style="width: 301px;">
					<li><a value="None" href="#">Select College</a> <%
 	for (College c : colleges) {
 		String collegeName = c.getName().trim();
 		if (collegeName.trim().length() > 40) {
 			collegeName = collegeName.substring(0, 40).trim();
 		}
 %> <label style="width: 100%; margin-left: 10px;"> <input
							value="<%=c.getId()%>" type="checkbox" checked="checked"
							class="i-checks"> <%=collegeName.trim()%></label> <%
 	}
 %></li>
				</ul>
				<a class="close-link"> <i class="fa fa-times"></i>
				</a>
			</div>
		</div>
		<div class="ibox-content"
			style="display: block; max-height: 435px; min-height: 590px;">
			<div class="tabs-container" style="background: #23c6c8"
				id="dashboard3">
				<ul class="nav nav-tabs" id="event_data">
					<li class="" value="all" id="all"><a data-toggle="tab"
						href="#tab-3" aria-expanded="false">ALL</a></li>
					<li class="active" id="today" value="today"><a
						data-toggle="tab" href="#tab-4" aria-expanded="true">Today</a></li>
					<li class="" value="currentweek"><a data-toggle="tab"
						href="#tab-5" aria-expanded="false">Current Week</a></li>
					<li class="" value="month"><a data-toggle="tab" href="#tab-6"
						aria-expanded="false">Month</a></li>
				</ul>
				<div class="tab-content">
					<div id="tab-3" class="tab-pane "
						style="padding-right: 0px !important; padding-left: 0px !important;">
						<div class="list-group col-lg-12" id="tab-3-group"
							style="display: inline-block; overflow: auto; max-height: 40em;"></div>
					</div>
					<div id="tab-4" class="tab-pane active"
						style="padding-right: 0px !important; padding-left: 0px !important;">
						<div class="list-group col-lg-12" id="tab-4-group"
							style="display: inline-block; overflow: auto; max-height: 40em;">
							<div class="well">
								<h1 class="text-center">NO DATA</h1>
							</div>
						</div>
					</div>
					<div id="tab-5" class="tab-pane"
						style="padding-right: 0px !important; padding-left: 0px !important;">
						<div class="list-group col-lg-12" id="tab-5-group"
							style="display: inline-block; overflow: auto; max-height: 40em;">
							<div class="well">
								<h1 class="text-center">NO DATA</h1>
							</div>
						</div>
					</div>
					<div id="tab-6" class="tab-pane"
						style="padding-right: 0px !important; padding-left: 0px !important;">
						<div class="list-group col-lg-12" id="tab-6-group"
							style="display: inline-block; overflow: auto; max-height: 40em;">
							<div class="well">
								<h1 class="text-center">NO DATA</h1>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal inmodal fade" id="myModal6" tabindex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog modal-lg">
					<div class="modal-content" >
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title">Attendance</h4>
						</div>
						<div class="modal-body" >
						<table class="table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>First Name</th>
                                <th>Attendance</th>
                            </tr>
                            </thead>
                            <tbody id="attendance-data" >
                            
                            
                            </tbody>
                        </table>
							
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-white" data-dismiss="modal">Close</button>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>