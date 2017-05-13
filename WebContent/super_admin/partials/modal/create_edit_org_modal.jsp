<%@page import="com.viksitpro.core.dao.entities.UserRole"%>
<%@page import="com.viksitpro.core.dao.entities.UserOrgMapping"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int org_id = 0;
	if (request.getParameter("org_id") != null) {
		org_id = Integer.parseInt(request.getParameter("org_id"));
	}

	String type = "Create";
	if (request.getParameter("type") != null) {
		type = request.getParameter("type");
	}
DBUTILS util = new DBUTILS();
	Organization college = new Organization();
	IstarUser orgadmin = new IstarUser();
	String orgAdminId="0",orgAdminEmail="",orgAdminGender="",orgAdminMobile="", orgAdminFirstName="", orgAdminLastName="" ;
	
	if (!type.equalsIgnoreCase("Create")) {
		college = new OrganizationDAO().findById(org_id);
		String sql="select istar_user.id , istar_user.email, istar_user.mobile, user_profile.gender, user_profile.first_name, user_profile.last_name from  istar_user, user_profile, user_org_mapping, user_role where user_org_mapping.organization_id = "+org_id+" and user_role.role_id = (select id from role where role_name='ORG_ADMIN') and user_org_mapping.user_id = istar_user.id and istar_user.id = user_role.user_id and istar_user.id = user_profile.user_id";
		List<HashMap<String, Object>> adminData = util.executeQuery(sql);
		if(adminData.size()>0)
		{
			
			orgAdminId=adminData.get(0).get("id").toString();
			orgAdminEmail=adminData.get(0).get("email").toString();
			orgAdminMobile=adminData.get(0).get("mobile").toString();
			
			orgAdminGender=adminData.get(0).get("gender").toString();					
			orgAdminFirstName = adminData.get(0).get("first_name").toString();	
			orgAdminLastName = adminData.get(0).get("last_name").toString();
			
		}
		
		
	}
%>


<div id="edit_org_model" class="modal edit_org_model inmodal"
	role="dialog" aria-hidden="true">
	<div class='modal-dialog'>
		<div class='modal-content animated flipInY'>

			<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                 <div class="panel-heading custom-theme-panal-color">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title text-center"><%=type%> Organization
				</h4>
			</div>
			<div class="modal-body" style="padding-bottom: 0px">

				<form class="form-horizontal"
					action="../create_or_update_organization" id="edit_org_model_form"
					method="post">
					<input type="hidden" value="<%=org_id%>" name="college_id" />
					<div class="form-group">

						<div class="col-lg-12">
							<label class="control-label">Name *</label> <input type="text"
								placeholder="College Name" name="org_name" class="form-control"
								value="<%=(college != null && college.getName() != null) ? college.getName() : ""%>">
						</div>
						<br> <br>

						<div class="col-lg-12">
							<label class="control-label">Address Line 1 *</label> <input type="text"
								placeholder="Infosys Gate 1, 1st Main Rd" name="org_addr1"
								class="form-control"
								value='<%=(college != null && college.getAddress() != null && college.getAddress().getAddressline1() != null)
							? college.getAddress().getAddressline1() : ""%>'>
						</div>
						<br> <br>

						<div class="col-lg-12">
							<label class="control-label">Address Line 2 *</label> <input type="text"
								placeholder="Electronics City Phase 1, Electronic City"
								name="org_addr2" class="form-control"
								value='<%=(college != null && college.getAddress() != null && college.getAddress().getAddressline1() != null)
							? college.getAddress().getAddressline2() : ""%>'>
						</div>
						<br> <br>

						<div class="col-lg-6">
							<label class="control-label">Pincode *</label> <select
								class="js-data-example-ajax  form-control"
								 data-pin_uri="<%=baseURL%>" name="pincode"
								data-validation="required">
								<option>Select Pincode</option>
								<option value="<%=(college != null && college.getAddress() != null && college.getAddress().getPincode() != null) ? college.getAddress().getPincode().getPin() : ""%>"
									<%=(college != null && college.getAddress() != null && college.getAddress().getPincode() != null) ? "selected" : ""%> style="width: 350px;" tabindex="2">
									<%=(college != null && college.getAddress() != null && college.getAddress().getPincode() != null) ? college.getAddress().getPincode().getPin() : "Select Pincode"%></option>
							</select>
						</div>

						<div class="col-lg-6">
							<label class="control-label" >Max Students *</label> <input type="number"
								placeholder="0-10000" name="max_students" class="form-control"
								value='<%=(college != null)? college.getMaxStudent() : ""%>'>
						</div>
						<br> <br>
                      <div class="col-lg-6">
							<label class="control-label">Select Organization Type</label> <select
								class="form-control m-b" name="org_type">
								<option value="COLLEGE"
									<%=college.getOrgType() == "COLLEGE" ? "selected" : ""%>>COLLEGE</option>
								<option value="COMPANY"
									<%=college.getOrgType() == "COMPANY" ? "selected" : ""%>>COMPANY</option>
							</select>
						</div> 
						<br> <br>
						<div class="col-lg-12">
							<label class="control-label">Organization Profile</label>
							<textarea class="form-control" id="org_profile" placeholder="Organization Profile..."
								style="margin: 0px -5px 0px 0px;"><%=(college != null && college.getProfile()!=null && !college.getProfile().equalsIgnoreCase("null"))? college.getProfile() : ""%></textarea>
						</div>
						<br> <br>
						
						<input type="hidden" value='<%=(college != null && college.getProfile()!=null && !college.getProfile().equalsIgnoreCase("null"))? college.getProfile() : ""%>'
							name="org_profile"/>
							
						<!--  <input type="hidden" value="COLLEGE" name="org_type" /> -->
							
							<input type="hidden" value="<%=orgAdminId%>"
							name="org_admin_id"/>
														
							
						<div class="col-lg-6">
							<label class="control-label">First Name *</label> <input type="text"
								placeholder="First Name"
								name="org_admin_first_name" class="form-control"
								value='<%=orgAdminFirstName%>'>
						</div>
						
						<div class="col-lg-6">
							<label class="control-label">Last Name </label> <input type="text"
								placeholder="Last Name"
								name="org_admin_last_name" class="form-control"
								value='<%=orgAdminLastName%>'>
						</div>
						<div class="col-lg-6">
							<label class="control-label">Principal/HR Manager Email *</label> <input type="email"
								placeholder="principal_org_name@istarindia.com"
								name="org_admin_email" class="form-control"
								value='<%=orgAdminEmail%>'>
						</div>
						<br> <br>
						
						<div class="col-lg-6">
							<label class="control-label">Gender *</label> <select
								class="form-control m-b" name="org_admin_gender">
								<option value="MALE"
									<%=orgAdminGender.equalsIgnoreCase("MALE") ? "selected" : ""%>>Male</option>
								<option value="FEMALE"
									<%=orgAdminGender.equalsIgnoreCase("FEMALE") ? "selected" : ""%>>Female</option>
							</select>
						</div>
						
						<div class="col-lg-6">
							<label class="control-label">Principal/HR Manager Mobile *</label> <input type="number"
								placeholder="9876543210"
								name="org_admin_mobile" class="form-control"
								value='<%=orgAdminMobile%>'>
						</div>		
						
						<br>
					</div>
                <div class="modal-footer" style="padding-bottom: 0px">
					<div class="form-group">
						<button type="button" id="org_modal_submit"
							class="btn btn-primary custom-theme-btn-primary"><%=(type.equalsIgnoreCase("Create")?"Create":"Update")%></button>
					</div></div>
				</form>
			</div>
		</div>
		</div>
	</div>
</div>