<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="com.istarindia.apps.dao.StudentProfileData"%>
<%@page import="in.orgadmin.admin.services.OrgAdminBatchGroupService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="com.istarindia.apps.dao.StudentDAO"%>
<%@page import="com.istarindia.apps.dao.OrgAdmin"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int user_id = 2;
	if (request.getParameter("user_id") != null) {
		user_id = Integer.parseInt(request.getParameter("user_id"));
	}

	Student user = new StudentDAO().findById(user_id);

	int colegeID = user.getCollege().getId();

	ArrayList<Integer> selectedBG = new OrgAdminBatchGroupService().getSelectedBatchBgoups(user_id);
	StudentProfileData stuProfileData = user.getStudentProfileData();
	String lastName = "";
	if (stuProfileData != null) {
		lastName = stuProfileData.getLastname();
	}
	AdminUIServices ui = new AdminUIServices();
%>


<div id="edit_user_model_<%=user.getId()%>"
	class="modal inmodal edit_modal" role="dialog">
	<div class='modal-dialog modal-lg'>
		<div class='modal-content animated flipInY'>

			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title pull-left">Edit a user</h4>
			</div>
			<div class="modal-body">

				<form class="form-horizontal"
					action="<%=baseURL%>createOrUpdateUser" method="post">
					<input type="hidden" value="super_admin" name="creation_type" /> <input
						type="hidden" value="<%=colegeID%>" name="college_id" /> <input
						type="hidden" value="<%=user_id%>" name="user_id" />
					<div class="form-group">

						<div class="col-lg-6">

							<label>First Name</label> <input type="text"
								placeholder="First Name.." name="user_f_name"
								class="form-control" value="<%=user.getName()%>">
						</div>

						<div class="col-lg-6">
							<label>Last Name</label> <input type="text"
								placeholder="Last Name.." name="user_l_name"
								class="form-control" value="<%=lastName%>">
						</div>

						<br>

						<div class="col-lg-12">
							<label class="control-label">Gender</label> <select
								class="form-control m-b" name="user_gender">
								<option value="MALE"
									<%=user.getGender() == "MALE" ? "selected" : ""%>>Male</option>
								<option value="FEMALE"
									<%=user.getGender() == "FEMALE" ? "selected" : ""%>>Female</option>
							</select>
						</div>

						<br>

						<div class="col-lg-12">
							<label>Email</label> <input type="email"
								placeholder="joe@schmoe.com" name="user_email"
								class="form-control" value="<%=user.getEmail()%>">
						</div>

					</div>
					<div class="form-group">
						<h3 class="m-b-n-md">Group</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<label class="font-noraml">Select Groups the student will
								belong to:</label>
							<div>
								<select data-placeholder="group..." class="select2-dropdown"
									multiple tabindex="4">
									<%=ui.getBatchGroups(-3, selectedBG)%>
								</select>
							</div>
							<input type="hidden" value="" name="batch_groups" />
						</div>
					</div>

					<div class="form-group">
						<h3 class="m-b-n-md">Role(only for corporate)</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<label class="font-noraml">Select Roles the student will
								belong to:</label>
							<div>
								<select class="" name="role_name" multiple tabindex="4">
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