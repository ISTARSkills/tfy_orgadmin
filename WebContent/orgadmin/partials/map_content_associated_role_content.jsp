<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
int colegeID = Integer.parseInt(request.getParameter("colegeID"));
int type_id = Integer.parseInt(request.getParameter("type_id"));
String type = request.getParameter("type");

List<HashMap<String, Object>> list = new OrgAdminSkillService().getAllContentAssosicatedSkills(colegeID,type_id,type);

%>

	<div
		class="col-lg-12 p-xs  b-r-lg border-left-right border-top-bottom border-size-small div-height">
		<h3>Content associated with ${param.type}</h3>
		<div class="full-height div-scroll-height">
			<div class="full-height-scroll" id="role_associated_${param.type}${param.type_id}">
				<% for (HashMap<String, Object> item : list) {%>
				<div class="alert alert-dismissable gray-bg">
				
				<%if(!type.equalsIgnoreCase("Role")) {%>
					<button aria-hidden="true" data-dismiss="alert" class="close skill-map" data-content-type="${param.type}" data-role="${param.type_id}" data-role_skill="<%=item.get("lesson_id")%>"
						type="button">x</button>
						<%}%>
					<%=item.get("lesson_title")%>
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
