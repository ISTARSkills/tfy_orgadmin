<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	int roleId = Integer.parseInt(request.getParameter("role_id"));
	int colegeID = Integer.parseInt(request.getParameter("colegeID"));
	List<HashMap<String, Object>> batchList =  new OrgAdminSkillService().getAllBatchesAvailable(roleId);
%>
<div class="ibox-content no-borders">
	<div
		class="col-lg-12 p-xs  b-r-lg border-left-right border-top-bottom div-height">
		<h3>Batches Associated with Group</h3>
		<div class="full-height div-scroll-height">
			<div class="full-height-scroll" id="batch_associated_<%=roleId%>">

				<%
					for (HashMap<String, Object> item : batchList) {
				%>
				<div class="alert alert-dismissable gray-bg">
					<button aria-hidden="true" data-dismiss="alert"
						data-role="<%=roleId%>" data-course="<%=item.get("course_id")%>" data-role_skill="<%=item.get("id")%>"
						class="close role-map" type="button"></button>
					<%=item.get("name")%>
				</div>
				<%
					}
					if (batchList.size() == 0) {
				%>

				<div
					class="alert gray-bg p-xs  b-r-lg border-left-right border-top-bottom">No
					Batches Associated with BatchGroup</div>

				<%
					}
				%>
			</div>
		</div>

	</div>
</div>