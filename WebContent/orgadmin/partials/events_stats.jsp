<%@page import="java.math.BigInteger"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	/* OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user"); */

	int colegeID = (int) request.getSession().getAttribute("orgId");
%>

		<%
			OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();
			List<HashMap<String, Object>> data = dashboardServices.getTodaysEventStats(colegeID);
			int totalEvents = 0;
			int cancelled = 0;
			int schedule = 0;
			int teaching = 0;
			int completed=0;
			if (data.size() > 0) {
				totalEvents = ((BigInteger) data.get(0).get("totevent")).intValue();
				cancelled = ((BigInteger) data.get(0).get("cancelled")).intValue();
				schedule = ((BigInteger) data.get(0).get("scheduled")).intValue();
				teaching = ((BigInteger) data.get(0).get("teaching")).intValue();
				completed=((BigInteger) data.get(0).get("completed")).intValue();
			}
		%>
		<div class="row">
	<div class="col-lg-12">
		<div class='custom-colum-grid'>
			<div class='widget style1 navy-bg custom-theme-color'>
				<div class='row'>
					<div class='col-xs-2' style="float: right;">
						<i class='fa fa-calendar fa-2x'></i>
					</div>
					<div class='col-xs-9 text-right' style="text-align: left !important;">
						<span> Scheduled Events </span>
						<h2 class='font-bold'><%=totalEvents%></h2>
					</div>
				</div>
			</div>
		</div>

		<div class='custom-colum-grid'>
			<div class='widget style1 navy-bg custom-theme-color'>
				<div class='row'>
					<div class='col-xs-2' style="float: right;">
						<i class='fa fa-pause fa-2x' style="float: right;"></i>
					</div>
					<div class='col-xs-9 text-right' style="text-align: left !important;">
						<span> Pending Events </span>
						<h2 class='font-bold'>
							<%=schedule%></h2>
					</div>
				</div>
			</div>
		</div>

		<div class='custom-colum-grid'>
			<div class='widget style1 navy-bg custom-theme-color'>
				<div class='row'>
					<div class='col-xs-2' style="float: right;">
						<i class='fa fa-play fa-2x' style="float: right;"></i>
					</div>
					<div class='col-xs-9 text-right' style="text-align: left !important;">
						<span>Events In Progress</span>
						<h2 class='font-bold'><%=teaching%></h2>
					</div>
				</div>
			</div>
		</div>


		<div class='custom-colum-grid'>
			<div class='widget style1 navy-bg custom-theme-color'>
				<div class='row'>
					<div class='col-xs-2' style="float: right;">
						<i class='fa fa-check-square-o fa-2x' style="float: right;"></i>
					</div>
					<div class='col-xs-9 text-right' style="text-align: left !important;">
						<span>Events Completed</span>
						<h2 class='font-bold'><%=completed%></h2>
					</div>
				</div>
			</div>
		</div>

		<div class='custom-colum-grid'>
			<div class='widget style1 navy-bg custom-theme-color'>
				<div class='row'>
					<div class='col-xs-2' style="float: right;">
						<i class='fa fa-trash fa-2x' ></i>
					</div>
					<div class='col-xs-9 text-right' style="text-align: left !important;">
						<span> Events Cancelled </span>
						<h2 class='font-bold'>
							<%=cancelled%>
						</h2>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>