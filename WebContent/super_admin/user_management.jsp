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
<div class="modal inmodal"
									id="admin_student_card_modal" 
										role="dialog" aria-hidden="true">


</div>
<body class="top-navigation" id="super_admin_user_managment">
	<div id="wrapper" class="white-bg">
		<div id="page-wrapper" class="white-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content white-bg" style="padding: 4px;">
				<div class="ibox">
					<div class="col-lg-12" style="padding: 0px;">
						<div class="col-lg-3">
							<button type="button" class="btn btn-w-m btn-danger"
								data-toggle="modal" data-target="#create_user_model"
								style="margin-top: 16px;">Add User</button>
								<hr/>
							
							<h3 class="font-bold">Filter by</h3>
							<div class="form-group">
								<label class="font-bold">Organization</label>
								<div>
									<select data-placeholder="Select Organizations" multiple
										tabindex="4" id='admin_page_orgs'>
										<%=adminUiServcies.getAllOrganizations()%>
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
									<select data-placeholder="Select Section" multiple tabindex="4"
										id='admin_page_batchgroup'>
										<%=adminUiServcies.getBatchGroups(-3, null)%>
									</select>
								</div>
							</div>
						</div>
						<div class="col-lg-9">
							<!-- <button class="btn btn-default pull-right" data-toggle="modal"
								data-target="#create_user_model" type="button">
								<i class="fa fa-plus-circle"></i>
							</button> -->

							<!-- <br /> <br /> -->
							<div class="row">
								<br>
								<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");			
				%>
				
				<%=util.getTableOuterHTML(3046, conditions)%>
								<!-- <table class="table table-bordered datatable_istar"
									id='student_list' data-url='../get_list_of_users?college_id=-3'>
									<thead>
										<tr>
											<th data-visisble='true'>#</th>
											<th data-visisble='true'>Name</th>
											<th data-visisble='true' style="width: 80px !important;">Attendance</th>
											<th data-visisble='true'>E-mail</th>
											<th data-visisble='true'>Section</th>
											<th data-visisble='true'>Organization</th>
											<th data-visisble='true' style="width: 50px !important;">Action</th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table> -->

							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal inmodal" id="create_user_model" 
		role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content animated flipInY">
				<div class="panel panel-primary custom-theme-panel-primary"
					style="margin-bottom: 0px;">
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
									<label class="control-label">First Name</label> <input type="text"
										placeholder="First Name.." required name="user_f_name"
										class="form-control">
								</div>
								<div class="col-lg-6">
									<label class="control-label">Last Name</label> <input type="text"
										placeholder="Last Name.." name="user_l_name"
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
									<input type="hidden" value="STUDENT" id="user_type"
										name="user_type" /> <label class="control-label">Select User Type</label> <select
										class="form-control m-b userType">
										<option value="STUDENT">Student</option>
										<option value="TRAINER">Trainer</option>

									</select>
								</div>
								<div id="hide_college_holder">
									<div class="col-lg-6">
										<label class="control-label">Organization</label>
										<div>
											<select name="college_id" id="college_id" required
												class="form-control m-b college_id">
												<%=adminUiServcies.getAllOrganizations()%>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group">
							<div id="batch_group_holder">
								<div  id="hide_group_holder">
									<div class="col-lg-6">
										<h3 class="m-b-n-md">Section</h3>
										<hr class="m-b-xs">
										<div class="col-lg-12">
											<label class="font-noraml">Select Section the student
												will belong to:</label>
											<div>
												<select data-placeholder="Section..."
													id="main_batch_group_holder" class="select2-dropdown"
													multiple tabindex="4" name="batch_groups">
												</select>
											</div>
											<input type="hidden" value="" />
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
