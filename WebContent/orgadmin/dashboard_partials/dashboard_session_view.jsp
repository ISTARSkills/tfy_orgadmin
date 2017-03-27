<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	String eventId = "";
	OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();

	if (request.getParameterMap().containsKey("eventId") && request.getParameter("eventId") != null) {
		eventId = request.getParameter("eventId");
	}
%>
<%=dashboardServices.getEventSessionLog(eventId)%>
