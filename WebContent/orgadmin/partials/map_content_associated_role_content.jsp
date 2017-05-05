<%@page import="tfy.admin.services.AdminServices"%>
<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
String collegeID = request.getParameter("college_id");
String entityType = request.getParameter("entity_type");
String entityId = request.getParameter("entity_id");

List<HashMap<String, Object>> list = new AdminServices().getAllContentAssosicatedSkills(Integer.parseInt(collegeID),Integer.parseInt(entityId),entityType);
%>

	<div
		class="col-lg-12 p-xs  b-r-lg border-left-right border-top-bottom border-size-small div-height">
		<h3>Content associated with <%=entityType %></h3>
		<div class="full-height div-scroll-height">
			<div class="full-height-scroll" id="role_associated_<%=entityType%>_<%=entityId%>">
				<% for (HashMap<String, Object> item : list) {%>
				<div class="alert alert-dismissable gray-bg">
				
				
					<%=item.get("content_title")%>
				</div>
				<% } if (list.size() == 0) {
				%>

				<div
					class="alert gray-bg p-xs  b-r-lg border-left-right border-top-bottom">No Content Associated with Role</div>

				<%
					}
				%>
			</div>
		</div>
	</div>
