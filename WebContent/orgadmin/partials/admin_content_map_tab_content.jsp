<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	UIUtils ui = new UIUtils();	
	int colegeID =(int)request.getSession().getAttribute("orgId");
	int userCount = new OrgAdminSkillService().getTotalUsers(colegeID);
%>
<div class="panel-body">
<div class="col-lg-12" style="padding-left: 0px; padding-right: 0px;">
	<div class="tabs-container p-xs  b-r-lg border-left-right border-top-bottom">
<ul class="nav nav-tabs gray-bg">
			<li class="active col-lg-1 text-center no-padding bg-muted"><a class="no-borders" data-target="#admin_content_main_tab_1" data-type='User' data-org='<%=colegeID%>' data-toggle="tabajax_content_mapping" href="partials/map_inner_tab_content.jsp" aria-expanded="true">User</a></li>
			<li class="col-lg-1 text-center no-padding bg-muted"><a class="no-borders" data-target="#admin_content_main_tab_2" data-type='Group' data-size='<%=userCount%>' data-org='<%=colegeID%>' data-toggle="tabajax_content_mapping" href="partials/map_inner_tab_content_for_group.jsp" aria-expanded="false">Section</a></li>
			<li class="col-lg-1 text-center no-padding bg-muted"><a class="no-borders" data-target="#admin_content_main_tab_3" data-type='Role' data-org='<%=colegeID%>' data-toggle="tabajax_content_mapping" href="partials/map_inner_tab_content_for_role.jsp" aria-expanded="false">Role</a></li>
		</ul>
		<div class="tab-content">
			<div id="admin_content_main_tab_1" class="tab-pane active">
							</div>

			<div id="admin_content_main_tab_2" class="tab-pane">
				
					
				
			</div>


			<div id="admin_content_main_tab_3" class="tab-pane">			

			</div>

		</div>

	</div>
</div>
</div>