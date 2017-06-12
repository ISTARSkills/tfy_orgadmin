<%@page import="org.jgroups.util.UUID"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String collegeID = request.getParameter("college_id");
String entityType = request.getParameter("entity_type");
String entityId = request.getParameter("entity_id");
//List<HashMap<String, Object>> listSkills = new OrgAdminSkillService().getAllSkills(Integer.parseInt(collegeID));
List<HashMap<String, Object>> listSkills = new OrgAdminSkillService().getAllSkillsForEntity(Integer.parseInt(collegeID), Integer.parseInt(entityId), entityType);
IstarUser user = (IstarUser) request.getSession().getAttribute("user");
%>
<div
		class="col-lg-12 p-xs  b-r-lg border-left-right border-top-bottom border-size-small div-height">
		<div class="col-lg-6 m-b-md" >
			<h3>Skills Available</h3>
			<div class="input-group">
				<input type="text" name="input-role-skill"
					data-entity_id="<%=entityId %>" data-entity_type="<%=entityType%>" placeholder="Search Skill..."
					class=" form-control b-r-lg"> <span class="input-group-btn">
					<button type="button" class="btn btn-white b-r-lg">
						<span><i class="fa fa-search"></i></span>
					</button>
				</span>
			</div>
		</div>
		<div class="col-lg-12">
			<div class="full-height div-scroll-height-2">
				<div class="full-height-scroll" id="skill_<%=entityType%>_<%=entityId%>">
					<%
						for (HashMap<String, Object> item : listSkills) {
					%>
					<div
						class="alert gray-bg p-xs  b-r-lg border-left-right border-top-bottom skill-avilable" >
						<button aria-hidden="true" data-dismiss="alert"	 class="close role-skill add_content" type="button" 
					data-href="partials/available_mapped_content.jsp" data-college_id="<%=collegeID %>"	 
					data-skill_id="<%=item.get("id")%>" data-entity_type="<%=entityType%>" data-entity_id="<%=entityId%>" data-admin_id="<%=user.getId()%>">
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
