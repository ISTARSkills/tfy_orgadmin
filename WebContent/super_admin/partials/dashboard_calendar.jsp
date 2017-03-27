<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.superadmin.services.SuperAdminDashboardServices"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	List<HashMap<String, Object>> lists = new SuperAdminDashboardServices().getAllAccount();
%>
<div class="ibox float-e-margins">
	<div class="ibox-title">
		<h5>Active Account</h5>

	</div>
	<div class="ibox-content">
		<p>
			<%
				for (HashMap<String, Object> item : lists) {
			%>
			<button type="button" class="btn btn-w-m lazur-bg activeaccount"
				data-id="<%=item.get("id")%>">
				<strong><%=item.get("name")%></strong>
			</button>
			<%
				}
			%>
		</p>
	</div>
</div>