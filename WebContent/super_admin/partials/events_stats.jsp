<%@page import="java.math.BigInteger"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="com.istarindia.apps.dao.OrgAdmin"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.DBUTILS"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();
	List<HashMap<String, Object>> data = dashboardServices.getTodaysEventStats(-3);
	int totalEvents = 0;
	int cancelled = 0;
	int schedule = 0;
	int teaching = 0;
	if (data.size() > 0) {
		totalEvents = ((BigInteger) data.get(0).get("totevent")).intValue();
		cancelled = ((BigInteger) data.get(0).get("completed")).intValue();
		schedule = ((BigInteger) data.get(0).get("scheduled")).intValue();
		teaching = ((BigInteger) data.get(0).get("teaching")).intValue();
	}
%>



<div class="row">
	<div class="col-lg-12">
		<div class='col-lg-3'>
			<div class='widget style1 navy-bg'>
				<div class='row'>
					<div class='col-xs-2'>
						<i class='fa fa-calendar fa-2x'></i>
					</div>
					<div class='col-xs-9 text-right'>
						<span> Events Today </span>
						<h2 class='font-bold'><%=totalEvents%></h2>
					</div>
				</div>
			</div>
		</div>

		<div class='col-lg-3'>
			<div class='widget style1 navy-bg'>
				<div class='row'>
					<div class='col-xs-2'>
						<i class='fa fa-calendar fa-2x'></i>
					</div>
					<div class='col-xs-9 text-right'>
						<span> Events Cancelled </span>
						<h2 class='font-bold'>
							<%=cancelled%>
						</h2>
					</div>
				</div>
			</div>
		</div>

		<div class='col-lg-3'>
			<div class='widget style1 navy-bg'>
				<div class='row'>
					<div class='col-xs-2'>
						<i class='fa fa-calendar fa-2x'></i>
					</div>
					<div class='col-xs-9 text-right'>
						<span> SCHEDULED </span>
						<h2 class='font-bold'>
							<%=schedule%></h2>
					</div>
				</div>
			</div>
		</div>

		<div class='col-lg-3'>
			<div class='widget style1 navy-bg'>
				<div class='row'>
					<div class='col-xs-2'>
						<i class='fa fa-calendar fa-2x'></i>
					</div>
					<div class='col-xs-9 text-right'>
						<span>Events In Progress</span>
						<h2 class='font-bold'><%=teaching%></h2>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>