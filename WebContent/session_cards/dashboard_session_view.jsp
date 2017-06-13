<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String liveSessionLogUrl ="";
try {
	Properties properties = new Properties();
	String propertyFileName = "app.properties";
	InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
	if (inputStream != null) {
		properties.load(inputStream);
		liveSessionLogUrl = properties.getProperty("live_session_log_url");
	}
} catch (IOException e) {
	e.printStackTrace();
}
	String eventId = "";
	OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();

	if (request.getParameterMap().containsKey("eventId") && request.getParameter("eventId") != null) {
		eventId = request.getParameter("eventId");
		
		String sql2 = "SELECT slide_id, lesson_id FROM slide_change_log WHERE event_id = '" + eventId+"' ORDER BY created_at DESC LIMIT 1";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql2);
		if(data.size()>0 && data.get(0).get("slide_id")!=null)
		{
			String slideId = data.get(0).get("slide_id").toString();
			String lessonId = data.get(0).get("lesson_id").toString();
			%>
			<iframe id='session-iframe' style='width:100%; min-height: 73vh!important;pointer-events: none;' src='<%=liveSessionLogUrl%>?lesson_id=<%=lessonId%>&current_slide_id=<%=slideId%>'></iframe>
			<%		
		}
	}else
	{
		%>
		<p>No Event Session Log Found</p>
		<% 
	}	
	
	
	
	
	
%>

