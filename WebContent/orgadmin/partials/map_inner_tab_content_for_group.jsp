<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	int colegeID = Integer.parseInt(request.getParameter("colegeID"));
	String type = request.getParameter("type");
	int offset = 0;
	if (request.getParameter("offset") != null) {
		offset = Integer.parseInt(request.getParameter("offset"));
	}

	String searchKey = "";
	if (request.getParameter("searchkey") != null) {
		searchKey = request.getParameter("searchkey").toString().replaceAll("%20", "");
	}

	List<HashMap<String, Object>> list = new OrgAdminSkillService().getAllContentUserList(colegeID, type,
			offset, searchKey);
%>

<div class="tabs-container">

	<div class="tabs-left">
	
	
		<ul class="nav nav-tabs gray-bg tab-width-custom" style="padding: 5px;">

			<%
			
			if(list.size()>0)
			{
				int i = 0;
				for (HashMap<String, Object> item : list) {
			%>

			<li class="<%=i == 0 ? "active" : ""%> no-padding bg-muted"><a
				data-toggle="tab" href="#admin_content_inner_tab_<%=i + type%>"
				aria-expanded="false"><%=item.get("name")%>  <span class="label"
					id="role_skill_count_<%=type + item.get("id")%>"><%=item.get("count")%></span>
			</a></li>
			<%
				i++;
				}
			}
			else
			{
				%>
				<li><a>No Section Available</a></li>
				<% 
			}	
			
			%>
		</ul>
		<div class="tab-content">
			<%
			int 	i = 0;
				for (HashMap<String, Object> item : list) {
			%>

			<div id="admin_content_inner_tab_<%=i + type%>"
				class="tab-pane <%=i == 0 ? "active" : ""%>">
				<div class="panel-body custom-body-style-3">

										<div class="col-lg-6" style="padding: 0px;
    margin-top: -15px;
    margin-left: -15px;">
											<jsp:include page="./map_content_available_content.jsp">
												<jsp:param value='<%=type + item.get("id")%>' name="role_id" />
												<jsp:param value='<%=colegeID%>' name="colegeID" />
											</jsp:include>
										</div>

										<div class="col-lg-6" style="padding: 0px;
    margin-top: -15px;
    margin-left: 4px;">
											<jsp:include page="./map_content_associated_role_content.jsp">
												<jsp:param value='<%=item.get("id")%>' name="type_id" />
												<jsp:param value='<%=type%>' name="type" />
												<jsp:param value='<%=colegeID%>' name="colegeID" />
											</jsp:include>
										</div>
									</div>
			</div>
			<%
				i++;
				}
			%>
		</div>
	</div>
</div>




