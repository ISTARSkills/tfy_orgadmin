<%@page import="com.istarindia.apps.dao.OrgAdmin"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.DBUTILS"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	int colegeID = -3;
	UIUtils uiUtil = new UIUtils();
	DBUTILS dbutils1 = new DBUTILS();
	if (request.getParameterMap().containsKey("colegeID")) {
		colegeID = Integer.parseInt(request.getParameter("colegeID"));
	}
%>
<div class="col-lg-6">
	<div class="row">
		<jsp:include page="./dashboard_calendar.jsp" />
	</div>

	<hr>
	<div class="row">
		<div class="col-md-12">
			<div class="ibox">
				<div class="ibox-content">
					<%
						CalenderUtils calUtil = new CalenderUtils();
						HashMap<String, String> input_params = new HashMap();
						//input_params.put("org_id",college_id+"");
					%>
					<%=calUtil.getCalender(input_params).toString()%>
				</div>
			</div>
		</div>
	</div>
</div>

