<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	int colegeID = Integer.parseInt(request.getParameter("colegeID"));
	List<HashMap<String, Object>> listlessons = new OrgAdminSkillService().getAllLessonSkills(colegeID);
%>

<div class="ibox-content no-borders">

	<div
		class="col-lg-12 p-xs  b-r-lg border-left-right border-top-bottom border-size-small div-height">

		<div class="col-lg-6 m-b-md">
			<h3>Content Available</h3>

			<div class="input-group">
				<input type="text" name="input-role-skill"
					data-role="${param.role_id}" placeholder="Search Skill..."
					class=" form-control b-r-lg"> <span class="input-group-btn">
					<button type="button" class="btn btn-white b-r-lg">
						<span><i class="fa fa-search"></i></span>
					</button>
				</span>
			</div>

		</div>


		<div class="col-lg-12">
			<div class="full-height div-scroll-height-2">
				<div class="full-height-scroll" id="skill_${param.role_id}">
					<%
						for (HashMap<String, Object> item : listlessons) {
					%>
					<div
						class="alert gray-bg p-xs  b-r-lg border-left-right border-top-bottom skill-avilable">
						<button aria-hidden="true" data-dismiss="alert"
							data-type="content" data-role-id="${param.role_id}"
							data-lesson-type="<%=item.get("parent_type")%>"
							data-skill-id="<%=item.get("id")%>" class="close role-skill"
							type="button">
							<i class="fa fa-chevron-circle-right"></i>
						</button>
						<%=item.get("name")%></div>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>
</div>