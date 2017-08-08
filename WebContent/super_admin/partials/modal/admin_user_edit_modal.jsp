<%@page import="com.viksitpro.core.dao.entities.UserRole"%>
<%@page import="com.viksitpro.core.dao.entities.UserProfile"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="in.orgadmin.admin.services.OrgAdminBatchGroupService"%>
<%@page import="java.util.ArrayList"%>

<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int user_id = 2;
	if (request.getParameter("user_id") != null) {
		user_id = Integer.parseInt(request.getParameter("user_id"));
	}

	IstarUser user = new IstarUserDAO().findById(user_id);

	int colegeID = user.getUserOrgMappings().iterator().next().getOrganization().getId();

	ArrayList<Integer> userRoles = new ArrayList<Integer>();
	try {

		for (UserRole role : user.getUserRoles()) {
			userRoles.add(role.getRole().getId());
		}

	} catch (Exception e) {

	}

	ArrayList<Integer> selectedBG = new ArrayList<Integer>();
	try {
		selectedBG = new OrgAdminBatchGroupService().getSelectedBatchBgoups(user_id);
	} catch (Exception e) {

	}
	UserProfile stuProfileData = user.getUserProfile();
	String lastName = "";
	if (stuProfileData != null) {
		lastName = stuProfileData.getLastName();
	}
	AdminUIServices ui = new AdminUIServices();
	
%>


<div id="edit_user_model_<%=user.getId()%>"
	class="modal inmodal edit_modal" role="dialog">
	<div class='modal-dialog modal-lg'>
		<div class='modal-content animated flipInY'>

			<div class="panel panel-primary custom-theme-panel-primary customcss_m-b-none">
				<div class="panel-heading custom-theme-panal-color">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title text-center">Edit User</h4>
				</div>
				<div class="modal-body customcss_p-b-none">

					<form class="form-horizontal"
						action="<%=baseURL%>createOrUpdateUser" method="post">
						<input type="hidden" value="super_admin" name="creation_type" />
						<input type="hidden" value="<%=colegeID%>" name="college_id" /> <input
							type="hidden" value="<%=user_id%>" name="user_id" />
						<div class="form-group">

							<div class="col-lg-6">

								<label class="control-label">First Name</label> <input
									type="text" placeholder="First Name.." name="user_f_name"
									class="form-control" required
									value="<%=stuProfileData.getFirstName()%>">
							</div>

							<div class="col-lg-6">
								<label class="control-label">Last Name</label> <input
									type="text" placeholder="Last Name.." name="user_l_name"
									class="form-control" required value="<%=lastName%>">
							</div>

							<br>


							<div class="col-lg-6">
								<label class="control-label">Mobile No</label> <input
									type="number" name="user_mobile" class="form-control"
									value="<%=user.getMobile()%>" required
									placeholder="Mobile Number">

							</div>
							<br>

							<div class="col-lg-6">
								<label class="control-label">Email</label> <input type="email"
									placeholder="joe@schmoe.com" name="user_email"
									class="form-control" required value="<%=user.getEmail()%>">
							</div>


							<div class="col-lg-2">
								<label class="control-label">Gender</label> <select
									class="form-control m-b" name="user_gender">
									<option value="MALE"
										<%=stuProfileData.getGender() == "MALE" ? "selected" : ""%>>Male</option>
									<option value="FEMALE"
										<%=stuProfileData.getGender() == "FEMALE" ? "selected" : ""%>>Female</option>
								</select>
							</div>
							<div class="col-lg-4">
								<input type="hidden" id='user_type' value="" name="user_type" />
								<label class="control-label">Select User Type</label> <select
									data-placeholder="User Type..." multiple tabindex="4"
									class="select2-dropdown multi_user_type">
									<%=new UIUtils().getAllRoles(userRoles)%>


								</select>
							</div>

						</div>
						<div class="form-group">
							<div class="col-lg-6">
								<h3 class="m-b-n-md">Section</h3>
								<hr class="m-b-xs">
								<div class="col-lg-12">
									<label class="font-noraml">Select Section the student
										will belong to:</label>
									<div>
										<select data-placeholder="Section..." class="select2-dropdown"
											multiple tabindex="4">
											<%=ui.getBatchGroups(colegeID, selectedBG)%>
										</select>
									</div>
									<input type="hidden" value="" name="batch_groups" />
								</div>
							</div>
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
						<div class="modal-footer customcss_p-b-none">
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