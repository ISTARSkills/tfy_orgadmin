<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	UIUtils ui = new UIUtils();
	/* OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user"); */
	int colegeID =(int)request.getSession().getAttribute("orgId");

	int userCount = new OrgAdminSkillService().getTotalUsers(colegeID);
%>

<div class="ibox">
	<h3 class="pull-left font-bold">Content Mapping</h3>

	<!-- tab start -->
	<div class="row m-t-lg">
		<div class="col-lg-12">
			<div
				class="tabs-container p-xs  b-r-lg border-left-right border-top-bottom">


				<ul class="nav nav-tabs gray-bg">
					<li class="active col-lg-1 text-center no-padding bg-muted"><a
						class="no-borders" data-toggle="tab"
						href="#admin_content_main_tab_1" aria-expanded="true">User</a></li>
					<li class="col-lg-1 text-center no-padding bg-muted"><a
						class="no-borders" data-toggle="tab"
						href="#admin_content_main_tab_2" aria-expanded="false">Section</a></li>
					<li class="col-lg-1 text-center no-padding bg-muted"><a
						class="no-borders" data-toggle="tab"
						href="#admin_content_main_tab_3" aria-expanded="false">Role</a></li>
				</ul>

				<div class="tab-content">
					<div id="admin_content_main_tab_1" class="tab-pane active">
						<div class="panel-body no-borders content-map-ajax-request"
							data-url="partials/map_inner_tab_content.jsp" data-type='User'
							data-org='<%=colegeID%>'>
							<%-- <jsp:include page="../partials/map_inner_tab_content.jsp">
								<jsp:param value='<%=colegeID%>' name="colegeID" />
								<jsp:param name="type" value="User" />
							</jsp:include> --%>

							<div class="text-center">
								<div id="page-selection" data-org='<%=colegeID%>'
									data-url="partials/map_inner_tab_content.jsp" data-type='User'
									data-size='<%=userCount%>'>
									
									<input type='text' id="content-user-search"
									placeholder=" Search Users..."
									class="form-control b-r-lg no-opaddings pull-right m-r-xl m-t-sm content-user-search-holder"
									data-org='<%=colegeID%>'
									data-url="partials/map_inner_tab_content.jsp" data-type='User'
									data-size='<%=userCount%>' />
									</div>

								

							</div>
							<div class="spiner-example spinner-animation-holder_User">
								<div class="sk-spinner sk-spinner-three-bounce">
									<div class="sk-bounce1"></div>
									<div class="sk-bounce2"></div>
									<div class="sk-bounce3"></div>
								</div>
							</div>
						</div>
					</div>

					<div id="admin_content_main_tab_2" class="tab-pane">
						<div class="panel-body no-borders content-map-ajax-request"
							data-url="partials/map_inner_tab_content_for_group.jsp" data-type='Group'
							data-org='<%=colegeID%>'>
							<%-- <jsp:include page="../partials/map_inner_tab_content.jsp">
								<jsp:param value='<%=colegeID%>' name="colegeID" />
								<jsp:param name="type" value="Group" />
							</jsp:include> --%>
							<div class="spiner-example spinner-animation-holder_Group">
								<div class="sk-spinner sk-spinner-three-bounce">
									<div class="sk-bounce1"></div>
									<div class="sk-bounce2"></div>
									<div class="sk-bounce3"></div>
								</div>
							</div>
						</div>
					</div>


					<div id="admin_content_main_tab_3" class="tab-pane">
						<div class="panel-body no-borders content-map-ajax-request"
							data-url="partials/map_inner_tab_content.jsp" data-type='Role'
							data-org='<%=colegeID%>'>

							<%--  <jsp:include page="../partials/map_inner_tab_content.jsp">
								<jsp:param value='<%=colegeID%>' name="colegeID" />
								<jsp:param name="type" value="Role" />
							</jsp:include>  --%>

							<div class="spiner-example spinner-animation-holder_Role">
								<div class="sk-spinner sk-spinner-three-bounce">
									<div class="sk-bounce1"></div>
									<div class="sk-bounce2"></div>
									<div class="sk-bounce3"></div>
								</div>
							</div>

						</div>
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

			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title pull-left">Create a Role</h4>
			</div>
			<div class="modal-body">

				<form class="form-horizontal">
					<div class="form-group">

						<div class="col-lg-12">
							<label>Role Name</label> <input type="text"
								placeholder="Enter Role Name.." name="r_name"
								class="form-control">
						</div>
						<br>
					</div>
					<div class="form-group">
						<div class="col-lg-6">
							<button type="button" class="btn btn-primary"
								data-dismiss="modal">Create</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

