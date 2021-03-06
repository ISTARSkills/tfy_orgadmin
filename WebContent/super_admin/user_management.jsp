<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	AdminUIServices adminUiServcies = new AdminUIServices();
%>
<div class="modal inmodal" id="admin_student_card_modal" role="dialog"
	aria-hidden="true"></div>
<body class="top-navigation" id="super_admin_user_managment">
	<div id="wrapper" class="white-bg">
		<div id="page-wrapper" class="white-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content white-bg custom_css-wrapper-content">
				<%
					String[] brd = { "Dashboard" };
				%>
				<%=UIUtils.getPageHeader("User Management", brd)%>
				<div class="ibox">
					<div class="col-lg-12 no-padding bg-muted">
						<div class="col-lg-3  customcss_p-xs bg-muted">
							<div class='card-box'>
								<button type="button" class="btn btn-w-m btn-danger m-t-md bg-muted"
									data-toggle="modal" data-target="#create_user_model">Add User</button>
								<hr />

								<h3 class="font-bold">Filter by</h3>
								<div class="form-group">
									<label class="font-bold">Organization</label>
									<div>
										<select data-placeholder="Select Organizations" multiple
											tabindex="4" id='admin_page_orgs'>
											<%=adminUiServcies.getAllOrganizations(0)%>
										</select>
									</div>
									<br> <label class="font-bold">Course</label>
									<div>
										<select data-placeholder="Select Course" multiple tabindex="4"
											id='admin_page_course'>
											<%=adminUiServcies.getCourses(-3)%>
										</select>
									</div>
									<br> <label class="font-bold">Section</label>
									<div>
										<select data-placeholder="Select Section" multiple
											tabindex="4" id='admin_page_batchgroup'>
											<%=adminUiServcies.getBatchGroups(-3, null)%>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-9">
							
							<div class="row card-box">
								<br>
								<%
									ReportUtils util = new ReportUtils();
									HashMap<String, String> conditions = new HashMap();
									conditions.put("limit", "12");
									conditions.put("offset", "0");
								%>

								<%=util.getTableOuterHTML(3046, conditions)%>


							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal inmodal" id="create_user_model" role="dialog"
		aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content animated flipInY">
				<div class="panel panel-primary custom-theme-panel-primary customcss_m-b-none">
					<div class="panel-heading custom-theme-panal-color">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title text-center">Create User</h4>
					</div>
					<div class="modal-body">
						<form class="form-horizontal"
							action="<%=baseURL%>createOrUpdateUser" method="post">

							<input type="hidden" value="super_admin" name="creation_type" />
							<!-- 	<input type="hidden" value="STUDENT" name="user_type" /> -->

							<div class="form-group">
								<div class="col-lg-6">
									<label class="control-label">First Name</label> <input
										type="text" placeholder="First Name.." required
										name="user_f_name" class="form-control">
								</div>
								<div class="col-lg-6">
									<label class="control-label">Last Name</label> <input
										type="text" placeholder="Last Name.." name="user_l_name"
										class="form-control">
								</div>

								<br>


								<div class="col-lg-6">
									<label class="control-label">Mobile No</label> <input
										type="number" name="user_mobile" required class="form-control"
										placeholder="Mobile Number">

								</div>

								<br>

								<div class="col-lg-6">
									<label class="control-label">Email</label> <input type="email"
										placeholder="joe@schmoe.com" required name="user_email"
										class="form-control">
								</div>


							</div>

							<div class="form-group">

								<div class="col-lg-2">
									<label class="control-label">Gender</label> <select
										class="form-control m-b" name="user_gender">
										<option value="MALE">Male</option>
										<option value="FEMALE">Female</option>
									</select>
								</div>


								<div class="col-lg-4">
									<input type="hidden" id='user_type' value="" name="user_type" />
									<label class="control-label">Select User Type</label> <select
										data-placeholder="User Type..." multiple tabindex="4"
										class="select2-dropdown multi_user_type">
										<%=new UIUtils().getAllRoles(null)%>


									</select>
								</div>
								<div id="hide_college_holder">
									<div class="col-lg-6">
										<label class="control-label">Organization</label>
										<div>
											<select name="college_id" id="college_id" required
												class="form-control m-b college_id">
												<%=adminUiServcies.getAllOrganizations(0)%>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="batch_group_holder">
									<div id="hide_group_holder">
										<div class="col-lg-6">
											<h3 class="m-b-n-md">Section</h3>
											<hr class="m-b-xs">
											<div class="col-lg-12">
												<label class="font-noraml">Select Section the
													student will belong to:</label>
												<div>
													<select data-placeholder="Section..."
														id="main_batch_group_holder"
														class="select2-dropdown multi_batch_groups main_batch_group_holder" multiple
														tabindex="4">
													</select>
												</div>
												<input type="hidden" id='batch_groups' value=""
													name="batch_groups" />
											</div>
										</div>
									</div>
								</div>


								<div id="hide_role_holder">
									<div class="col-lg-6">
										<h3 class="m-b-n-md">Role(only for corporate)</h3>
										<hr class="m-b-xs">
										<div class="col-lg-12">
											<label class="font-noraml">Select Roles the student
												will belong to:</label>
											<div>
												<select data-placeholder="Roles..." class="chosen-select"
													name="role_name" multiple tabindex="4">
													<option value="">Select</option>
													<option value="">Account Manager</option>
													<option value="">Account Manager</option>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<div class="form-group">
									<button type="submit" class="btn btn-danger">Save
										changes</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>

</body>
</html>
