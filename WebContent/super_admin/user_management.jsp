<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	AdminUIServices adminUiServcies = new AdminUIServices();
%>

<body class="top-navigation" id="super_admin_user_managment">
	<div id="wrapper" class="white-bg">
		<div id="page-wrapper" class="white-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content white-bg">
				<div class="ibox">
					<div class="col-lg-12">
						<div class="col-lg-3">
							<h3 class="font-bold">Filter</h3>
							<div class="form-group">
								<label class="font-bold">by Organization</label>
								<div>
									<select data-placeholder="select Orgs" multiple tabindex="4"
										id='admin_page_orgs'>
										<%=adminUiServcies.getAllOrganizations()%>
									</select>
								</div>
								<br> <label class="font-bold">by Course</label>
								<div>
									<select data-placeholder="select course" multiple tabindex="4"
										id='admin_page_course'>
										<%=adminUiServcies.getCourses(-3)%>
									</select>
								</div>
								<br> <label class="font-bold">by Batch Group</label>
								<div>
									<select data-placeholder="select Groups" multiple tabindex="4"
										id='admin_page_batchgroup'>
										<%=adminUiServcies.getBatchGroups(-3, null)%>
									</select>
								</div>
							</div>
						</div>
						<div class="col-lg-9">
							<button class="btn btn-default pull-right" data-toggle="modal"
								data-target="#create_user_model" type="button">
								<i class="fa fa-plus-circle"></i>
							</button>

							<br /> <br />
							<div class="row">
								<br>
								<table class="table table-bordered datatable_istar"
									id='student_list' data-url='../get_list_of_users?college_id=-3'>
									<thead>
										<tr>
											<th data-visisble='true'>#</th>
											<th data-visisble='true'>Name</th>
											<th data-visisble='true'>Attendance</th>
											<th data-visisble='true'>E-mail</th>
											<th data-visisble='true'>Batch Group</th>
											<th data-visisble='true'>Organization</th>
											<th data-visisble='true'>Action</th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table>

							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal inmodal" id="create_user_model" tabindex="-1"
		role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content animated flipInY">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title pull-left">Create a user</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal"
						action="<%=baseURL%>createOrUpdateUser" method="post">

						<input type="hidden" value="super_admin" name="creation_type" />
					<!-- 	<input type="hidden" value="STUDENT" name="user_type" /> -->

						<div class="form-group">
							<div class="col-lg-6">
								<label>First Name</label> <input type="text"
									placeholder="First Name.." name="user_f_name"
									class="form-control">
							</div>
							<div class="col-lg-6">
								<label>Last Name</label> <input type="text"
									placeholder="Last Name.." name="user_l_name"
									class="form-control">
							</div>

							<br>

							<div class="col-lg-12">
								<label class="control-label">Gender</label> <select
									class="form-control m-b" name="user_gender">
									<option value="MALE">Male</option>
									<option value="FEMALE">Female</option>
								</select>
							</div>

							<br>

							<div class="col-lg-12">
								<label>Email</label> <input type="email"
									placeholder="joe@schmoe.com" name="user_email"
									class="form-control">
							</div>

						</div>

						<div class="form-group">
						<input type="hidden" value="STUDENT" id="user_type" name="user_type"/>
							<label>Select User Type</label> <select
								class="form-control m-b userType" >
								<option value="STUDENT">Student</option>
								<option value="TRAINER">Trainer</option>

							</select>
						</div>

						<div class="form-group" id="hide_group_holder">
							<h3 class="m-b-n-md">Group</h3>
							<hr class="m-b-xs">
							<div class="col-lg-12">
								<label class="font-noraml">Select Groups the student
									will belong to:</label>
								<div>
									<select data-placeholder="group..." class="select2-dropdown"
										multiple tabindex="4">
										<%=adminUiServcies.getBatchGroups(-3, null)%>
									</select>
								</div>
								<input type="hidden" value="" name="batch_groups" />
							</div>
						</div>

						<div class="form-group" id="hide_college_holder">
							<div class="col-lg-12">
								<label class="font-noraml">Organization</label>
								<div>
									<select name="college_id" class="form-control m-b">
										<%=adminUiServcies.getAllOrganizations()%>
									</select>
								</div>
							</div>
						</div>

						<div class="form-group" id="hide_role_holder">
							<h3 class="m-b-n-md">Role(only for corporate)</h3>
							<hr class="m-b-xs">
							<div class="col-lg-12">
								<label class="font-noraml">Select Roles the student will
									belong to:</label>
								<div>
									<select data-placeholder="roles..." class="chosen-select"
										name="role_name" multiple tabindex="4">
										<option value="">Select</option>
										<option value="">Account Manager</option>
										<option value="">Account Manager</option>
									</select>
								</div>
							</div>
						</div>

						<div class="form-group">
							<button type="submit" class="btn btn-primary">Save
								changes</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>

</body>
</html>
