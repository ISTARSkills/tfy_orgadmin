<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<% String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	

int colegeID = (int)request.getSession().getAttribute("orgId");
IstarUser orgadmin = (IstarUser) request.getSession().getAttribute("user");
AdminUIServices adminUiServcies = new AdminUIServices();


%>
<div class="panel-body">
<div class="modal inmodal"
									id="admin_student_card_modal" tabindex="-1"
										role="dialog" aria-hidden="true">
</div>
<div class="ibox">
	<div class="col-lg-12">
		<div class="col-lg-2">
		
			
			<div class="form-group">
			<h3 class="font-bold">Filter by</h3>
				<label class="font-bold">Program</label>
				<div>
					<select data-placeholder="Select Course" multiple
						tabindex="4" id='admin_page_course'>
						<%=adminUiServcies.getCourses(colegeID) %>
					</select>
				</div>
				<br> <label class="font-bold">Section</label>
				<div>
					<select data-placeholder="Select Section"  multiple
						tabindex="4" id='admin_page_batchgroup'>
						<%=adminUiServcies.getBatchGroups(colegeID,null) %>
					</select>
				</div>
				<div><button type="button" class="btn btn-w-m btn-danger" data-toggle="modal"
								data-target="#create_user_model" style="margin-top: 16px;">Add New User</button></div>
				
			</div>
		</div>
		<div class="col-lg-10">
			
			


			<div class="row">
				<br>
				<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");
				conditions.put("college_id", colegeID+"");
				
				%>
				
				<%=util.getTableOuterHTML(3042, conditions)%>
			</div>
		</div>

	</div>
</div>

<div class="modal inmodal" id="create_user_model" tabindex="-1"
	role="dialog" aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-lg">


		<div class="modal-content animated flipInY">

			<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title text-center">Create User</h4>
			</div>
			<div class="modal-body" style="padding-bottom: 0px;">

				<form class="form-horizontal"
					action="<%=baseURL%>createOrUpdateUser" method="post">
                 <input type="hidden" value="STUDENT" name="user_type" />
					<input type="hidden" value="<%=colegeID%>" name="college_id" />
					<div class="form-group">

						<div class="col-lg-6">

							<label  class="control-label">First Name</label> <input type="text"
								placeholder="First Name.." name="user_f_name"
								class="form-control">
						</div>

						<div class="col-lg-6">
							<label  class="control-label" >Last Name</label> <input type="text"
								placeholder="Last Name.." name="user_l_name"
								class="form-control">
						</div>

						<div class="col-lg-6">
								<label class="control-label">Mobile No</label> <input type="number"
									name="user_mobile" class="form-control"
									placeholder="Mobile Number">

						</div>

                       <div class="col-lg-6">
							<label  class="control-label">Email</label> <input type="email"
								placeholder="joe@schmoe.com" name="user_email"
								class="form-control">
						</div>
						 <div class="col-lg-2">
								<label class="control-label">Gender</label> <select
									class="form-control m-b" name="user_gender">
									<option value="MALE">Male</option>
									<option value="FEMALE">Female</option>
								</select>
							</div> 

					</div>
					<div class="form-group">
					<div class="col-lg-6">
						<h3 class="m-b-n-md">Section</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<label class="font-noraml">Select Section the student will
								belong to:</label>
							<div>
								<select data-placeholder="Section..."  class="select2-dropdown" multiple tabindex="4" name="batch_groups">
									<%=adminUiServcies.getBatchGroups(colegeID,null) %>
								</select>
							</div>
							<input type="hidden" value=""  />
						</div>
					</div>

					
					<div class="col-lg-6">
						<h3 class="m-b-n-md">Role(only for corporate)</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<label class="font-noraml">Select Roles the student will
								belong to:</label>
							<div>
								<select data-placeholder="Roles..." class="chosen-select"
									name="role_name" multiple tabindex="4">
									<option value="">Select</option>
									<option value="">Account Manager</option>
									<option value="">Account Manager</option>
								</select>
							</div></div>
						</div>


					</div>
<div class="modal-footer" style="padding-bottom: 0px;">
					<div class="form-group">
						<button type="submit" class="btn btn-danger">Save
							changes</button>
					</div></div>
				</form>
			</div>
		</div></div>
	</div>
</div>
</div>