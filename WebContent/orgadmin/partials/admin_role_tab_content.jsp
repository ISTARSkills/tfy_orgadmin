<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	UIUtils ui = new UIUtils();
/* 	OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user");
 */
 int colegeID =(int)request.getSession().getAttribute("orgId");
	OrgAdminSkillService orgSkillService = new OrgAdminSkillService();
	List<HashMap<String, Object>> roleList=orgSkillService.getAdminRoleList(colegeID);	

%>



<div class="ibox">
<!-- 	<h3 class="pull-left">Roles</h3>
<br/><br/><br/> -->
<button type="button" class="btn btn-w-m btn-danger" data-toggle="modal"
								data-target="#create_role_model" style="margin-bottom: 10px;">Add Role</button>
	<!-- <button class="btn btn-default pull-right m-b-sm" data-toggle="modal"
		data-target="#create_role_model" type="button">
		<i class="fa fa-plus-circle"></i>
	</button> -->

	<!-- tab start -->
	<div class="row m-t-lg">
		<div class="col-lg-12">
			<div
				class="tabs-container p-xs  b-r-lg border-left-right border-top-bottom">

				<div class="tabs-left">
					<ul class="nav nav-tabs gray-bg tab-display-width">

						<%
						int i=0;
							for (HashMap<String, Object> item : roleList) {
						%>
						<li class="<%=i == 0 ? "active" : ""%>"><a data-toggle="tab"
							href="#admin_role_tab_<%=i%>" data-role="<%=item.get("id")%>" aria-expanded="false"><%=item.get("role_name")%> <span class="label" id="role_skill_count_<%=item.get("id")%>"><%=item.get("role_skill_count")%></span>
						</a></li>
						<%
						i++;
							}
						%>

					</ul>
					<div class="tab-content">

						<%
						int j=0;
							for (HashMap<String, Object> item : roleList) {
						%>
						<div id="admin_role_tab_<%=j%>"
							class="tab-pane <%=j == 0 ? "active" : ""%>">
							<div class="panel-body admin-border">

								<div class="col-lg-6">
									<jsp:include page="../partials/role_skill_available_content.jsp" >
									<jsp:param value='<%=item.get("id")%>' name="role_id"/>
									</jsp:include>
								</div>

								<div class="col-lg-6">
									<jsp:include page="../partials/role_skill_associated_role_content.jsp">
									<jsp:param value='<%=item.get("id")%>' name="role_id"/>
									<jsp:param value='<%=colegeID%>' name="colegeID"/>
									</jsp:include>
										
								</div>

							</div>
						</div>

						<%
						j++;
							}
						%>
					</div>

				</div>

			</div>
		</div>

	</div>
	<!-- tab end -->
</div>

<div class="modal inmodal" id="create_role_model" tabindex="-1"
	role="dialog" aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-lg">


		<div class="modal-content animated flipInY">
			<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title text-center">Create Role</h4>
			</div>
			<div class="modal-body" style="padding-bottom: 0px;">
				<form class="form-horizontal" action="../roleSkillCreateOrDelete" method="post">
					<div class="form-group">
					<div class="col-lg-4">
						<input type="hidden" name="type" value="create_role">
						<div class="col-lg-12">
							<label class="control-label">Role Name</label> <input type="text"
								placeholder="Enter Role Name.." name="role_name"
								class="form-control">
						</div>
						</div>
					
						<div class="col-lg-8">
							<label class="control-label">Role Description</label> <input type="text"
								placeholder="Enter Short Description.." name="role_desc"
								class="form-control">
						</div>
						<br>
					</div>
					 <div class="modal-footer" style="padding-bottom: 0px">
					<div class="form-group">
						
							<button type="submit" class="btn btn-danger">Create</button>
						</div>
					</div>
				</form>
			</div>
		</div></div>
	</div>
</div>
