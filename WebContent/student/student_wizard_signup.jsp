<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<!DOCTYPE html>
<html>

<head>
<style>
.wizard-big.wizard>.content {
	min-height: 440px !important;
}

.wizard>.steps .done a, .wizard>.steps .done a:hover, .wizard>.steps .done a:active
	{
	background: rgba(235, 56, 79, 0.61) !important;
	color: #fff;
}
</style>

<%
	String url = request.getRequestURL().toString();
	String cdnUrl = "http://cdn.talentify.in/";

	try {
		Properties properties = new Properties();
		String propertyFileName = "app.properties";
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
		if (inputStream != null) {
			properties.load(inputStream);
			cdnUrl = properties.getProperty("cdn_path");
		}
	} catch (IOException e) {
		e.printStackTrace();
	}
	String userType = request.getParameter("user_type");
	IstarUser user = null;
	String actionUrl = "user_signup";
	String buttonClick = "create";
	if (request.getParameterMap().containsKey("user_id") && request.getParameter("user_id") != null) {
		user = new IstarUserDAO().findById(Integer.parseInt(request.getParameter("user_id")));
		actionUrl = "profile_update";
		buttonClick = "edit";
	}
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	DBUTILS db = new DBUTILS();
	SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=cdnUrl%>assets/img/user_images/new_talentify_logo.png" />
<title>Talentify | Sign Up</title>
<link href="<%=cdnUrl%>assets/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
	rel="stylesheet">
<link
	href="<%=cdnUrl%>assets/css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">
<link
	href="<%=cdnUrl%>assets/css/plugins/jasny/jasny-bootstrap.min.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/plugins/datapicker/datepicker3.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/plugins/select2/select2.min.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/plugins/chosen/bootstrap-chosen.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/animate.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/style.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/custom.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/plugins/steps/jquery.steps.css" rel="stylesheet">

</head>

<body class="top-navigation" id="">
	<div id="wrapper">
		<div id="page-wrapper" class="white-bg">
			<%
				if (request.getParameterMap().containsKey("msg")) {
			%>
			<div class="alert alert-danger">
				<%=request.getParameter("msg")%>
			</div>
			<%
				}
			%>
			<div class="row">
				<div class="row wrapper border-bottom white-bg page-heading">
					<div class="col-lg-10">
					<%if(user !=null) {%>
						<h2 style="margin-left: 31px;">Edit Profile</h2>
					<%}else{ %>
						<h2 style="margin-left: 31px;">Student Sign Up</h2>
					<%} %>
					</div>
				</div>
				
	<!-- wizard start here -->
				<div class="col-lg-12">
					<form id="form" action="#" class="wizard-big" method="post">
				<input type="hidden" id="user_type" name="user_type" value="STUDENT">
						<h1>Account</h1>
						<fieldset>
							<div class="row">
								<div class="col-lg-6">
									<div class="form-group">
										<label>First name *</label> <input id="name" name="f_name"
											type="text" value="<%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getFirstName()!=null){%><%=user.getUserProfile().getFirstName() %><%} %>" class="form-control required">
									</div>

									<div class="form-group">
										<label>Email *</label> <input id="email" name="email"
											type="email" class="form-control required email"  value="<%if(user!=null && user.getEmail() !=null){%><%=user.getEmail() %><%} %>">
									</div>
									<div class="form-group">
										<label>Mobile Number *</label> <input id="mobile" min='0' value="<%if(user!=null && user.getMobile()!=null){%><%=user.getMobile() %><%}%>"
											name="mobile" type="number" class="form-control required">
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label>Last name *</label> <input id="surname" name="l_name"
											type="text" value="<%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getLastName()!=null){%><%=user.getUserProfile().getLastName() %><%} %>" class="form-control required">
									</div>
									<div class="form-group">
										<label>Password *</label> <input id="password" name="password"
											type="password" value="<%if(user!=null && user.getPassword()!=null){%><%=user.getPassword() %><%}%>" class="form-control required">
									</div>
									<div class="form-group">
										<label>Gender *</label> <select
											class="form-control m-b" required name="gender">
											<option value="FEMALE"
												<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getGender() != null
					&& user.getUserProfile().getGender().equalsIgnoreCase("FEMALE")) {%>
												selected <%}%>>FEMALE</option>
											<option value="MALE"
												<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getGender() != null
					&& user.getUserProfile().getGender().equalsIgnoreCase("MALE")) {%>
												selected <%}%>>MALE</option>
										</select>

									</div>
								</div>
							</div>

						</fieldset>
						<h1>Personal</h1>
						<fieldset>
							<div class="row">
								<div class="col-lg-6">
									<div class="form-group" id="data_2"
										style='margin-right: 0px !important;'>
										<label>Date of Birth *</label>
										<div class="input-group date">
											<span class="input-group-addon"><i
												class="fa fa-calendar"></i></span><input name="dob" required
												type="text" class="form-control date_holder"
												value="<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getDob() != null) {%><%=df.format(user.getUserProfile().getDob())%><%}%>">
										</div>
									</div>
									<div class="form-group">
										<label>Pincode *</label>
											<select class="js-data-example-ajax  form-control"
												data-pin_uri="<%=baseURL%>" name="pincode"
												data-validation="required" required>
												<option value="">Select Pincode</option>
												<%
													if (user != null && user.getUserProfile() != null && user.getUserProfile().getAddress() != null
															&& user.getUserProfile().getAddress().getPincode() != null) {
												%>
												<option
													value="<%=user.getUserProfile().getAddress().getPincode().getPin()%>"
													selected><%=user.getUserProfile().getAddress().getPincode().getPin()%>
												</option>
												<%
													}
												%>
											</select>
									</div>
									<div class="form-group">
										<label>Aadhar No *</label>
											<input type="number" placeholder="Aadhar No." name="aadharno"
												value="<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getAadharNo() != null) {%><%=user.getUserProfile().getAadharNo()%><%}%>"
												required class="form-control">
									</div>
									<div class="form-group">
										<label>Religion *</label> <select
											class="form-control m-b" required
											name="religion">
										
											<%
												for (String key : AppProperies.getProperty("religion").toString().split("!#")) {
											%>
											<option value="<%=key%>" <%if (user != null && user.getUserProfile() != null && user.getUserProfile().getReligion() != null && user.getUserProfile().getReligion().equalsIgnoreCase(key)) {%>selected<%}%>><%=key%></option>
											<%} %>
										</select>
									</div>
									<div class="form-group">
										<label>Caste Category *</label> <select
											class="form-control m-b" required
											name="caste_category">
											
											<%
												for (String key : AppProperies.getProperty("caste_category").toString().split("!#")) {
											%>
											<option value="<%=key%>" <%if (user != null && user.getUserProfile() != null && user.getUserProfile().getCasteCategory() != null && user.getUserProfile().getCasteCategory().equalsIgnoreCase(key)) {%>selected<%}%>><%=key%></option>
											<%} %>
										</select>
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label>Address Line 1 *</label> <input type="text" required
											placeholder="Address Line 1" name="address_line1"
											class="form-control"
											value="<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getAddress() != null
					&& user.getUserProfile().getAddress().getAddressline1() != null) {%><%=user.getUserProfile().getAddress().getAddressline1()%>   <%}%>">
									</div>
									<div class="form-group">
										<label>Address Line 2 *</label>
											<input type="text" required placeholder="Address Line 2"
												name="address_line2" class="form-control"
												value="<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getAddress() != null
					&& user.getUserProfile().getAddress().getAddressline2() != null) {%><%=user.getUserProfile().getAddress().getAddressline2()%>   <%}%>">
									</div>
									<div class="form-group">
										<label>Fathers Name *</label> <input type="text" required
											placeholder="Father's Name" name="father_name"
											class="form-control"
											value="<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getFatherName() != null) {%><%=user.getUserProfile().getFatherName	()%>   <%}%>">
									</div>
									<div class="form-group">
										<label>Place of Birth *</label> <input type="text" required
											placeholder="Place of Birth" name="place_of_birth"
											class="form-control"
											value="<%if (user != null && user.getUserProfile() != null && user.getUserProfile().getPlaceOfBirth() != null
					&& user.getUserProfile().getPlaceOfBirth() != null) {%><%=user.getUserProfile().getPlaceOfBirth()%>   <%}%>">
									</div>
									<div class="form-group">
										<label>Below Poverty Line *</label> <select class="form-control m-b" required
											name="below_poverty_line">
											<option value="true" <%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getBelowPovertyLine() != null && user.getProfessionalProfile().getBelowPovertyLine()==true) {%>selected<%}%>>Yes</option><option value="false" <%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getBelowPovertyLine() != null && user.getProfessionalProfile().getBelowPovertyLine()==false) {%>selected<%}%>>No</option></select>
									</div>
								</div>
							</div>
						</fieldset>

						<h1>Education Info</h1>
						<fieldset>
							<div class="row">
								<div class="col-lg-6">
									<div class="form-group">
										<label>10th Marks *</label> <input type="number" min='0'
											max='100' placeholder="10th Marks (in %)" name="marks10"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getMarks10() != null) {%><%=user.getProfessionalProfile().getMarks10()%><%}%>"
											required class="form-control">
									</div>
									<div class="form-group">
										<label>12th Marks *</label> <input type="number" min='0'
											max='100' placeholder="12th Marks (in %)" name="marks12"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getMarks12() != null) {%><%=user.getProfessionalProfile().getMarks12()%><%}%>"
											required class="form-control">
									</div>
									<div class="form-group">
										<label>UG Degree Name *</label> <select
											class="form-control m-b" required name="ug_degree"
											id='ug_degree'>
											<option value="">Select UG Degree</option>
											<%
												if (user != null && user.getProfessionalProfile() != null
														&& user.getProfessionalProfile().getUnderGraduateDegreeName() != null) {
											%>
											<option selected
												value="<%=user.getProfessionalProfile().getUnderGraduateDegreeName()%>"><%=user.getProfessionalProfile().getUnderGraduateDegreeName()%></option>
											<%
												}
											%>
											<option value="BCOM">BCOM</option>
											<option value="BA">BA</option>
											<option value="BSC">BSC</option>
											<option value="BTECH">BTECH</option>
											<option value="BE">BE</option>
											<option value="BBA">BBA</option>
											<option value="BBM">BBM</option>
											<option value="BED">BED</option>
											<option value="BSW">BSW</option>
											<option value="BCA">BCA</option>
											<option value="OTHERS">OTHERS</option>
										</select>
									</div>
									<div class="form-group">
										<label>UG Specialization Name *</label> <select
											class="form-control m-b" required
											name="underGraduationSpecializationName" id="underGraduationSpecializationName"
											>
											<%
											if(user!= null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getUnderGraduateDegreeName()!=null && user.getProfessionalProfile().getUnderGraduationSpecializationName()!=null )
											{
												String value = AppProperies.getProperty(user.getProfessionalProfile().getUnderGraduateDegreeName());
												String[] lists = value.split("!#");
												for (String key : lists) {
												
												%>
												<option value="<%=key%>" <%if(user.getProfessionalProfile().getUnderGraduationSpecializationName().equalsIgnoreCase(key) ){%>selected<%} %>><%=key %></option>
												<% 
												}
											}
											%>
											

										</select>
									</div>
									<div class="form-group">
										<label>UG Marks *</label> <input type="number" min='0'
											max='100' placeholder="UG Marks (in %)"
											name="underGradutionMarks"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getUnderGradutionMarks() != null) {%><%=user.getProfessionalProfile().getUnderGradutionMarks()%><%}%>"
											required class="form-control">
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label>10th Year of Passing *</label> <input type="number"
											min='1900' placeholder="10th Year of Passing" name="yop10"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getYop10() != null) {%><%=user.getProfessionalProfile().getYop10()%><%}%>"
											required class="form-control">
									</div>
									<div class="form-group">
										<label>12th Year of Passing *</label> <input type="number"
											min='1900' placeholder="12th Year of Passing" name="yop12"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getYop12() != null) {%><%=user.getProfessionalProfile().getYop12()%><%}%>"
											required class="form-control">
									</div>

									<div class="form-group">
										<label>PG Degree Name *</label> <select
											class="form-control m-b" required name="pg_degree"
											id='pg_degree'>
											<option value="">Select PG Degree</option>
											<%
												if (user != null && user.getProfessionalProfile() != null
														&& user.getProfessionalProfile().getPgDegreeName() != null) {
											%>
											<option selected
												value="<%=user.getProfessionalProfile().getPgDegreeName()%>"><%=user.getProfessionalProfile().getPgDegreeName()%></option>
											<%
												}
											%>
											<option value="MTECH">MTECH</option>
											<option value="MA">MA</option>
											<option value="MCOM">MCOM</option>
											<option value="MBA">MBA</option>
											<option value="ME">ME</option>
											<option value="MSC">MSC</option>
											<option value="MCA">MCA</option>
											<option value="MSW">MSW</option>
											<option value="OTHERS">OTHERS</option>
										</select>
									</div>
									<div class="form-group">
										<label>PG Specialization Name *</label> <select
											class="form-control m-b" required
											name="postGraduationSpecializationName" id="postGraduationSpecializationName"
											>
											<%
											if(user!= null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getPgDegreeName()!=null && user.getProfessionalProfile().getPostGraduationSpecializationName()!=null )
											{
												String value = AppProperies.getProperty(user.getProfessionalProfile().getPgDegreeName());
												String[] lists = value.split("!#");
												for (String key : lists) {
												
												%>
												<option value="<%=key%>" <%if(user.getProfessionalProfile().getPostGraduationSpecializationName().equalsIgnoreCase(key) ){%>selected<%} %>><%=key %></option>
												<% 
												}
											}
											%>
											
										</select>
									</div>
									<div class="form-group">
										<label>PG Marks *</label> <input type="number" min='0'
											max='100' placeholder="PG Marks (in %)"
											name="postGradutionMarks"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getPostGradutionMarks() != null) {%><%=user.getProfessionalProfile().getPostGradutionMarks()%><%}%>"
											required class="form-control">
									</div>
								</div>
							</div>
						</fieldset>

						<h1>Job Info</h1>
						<fieldset>
							<div class="row">
								<div class="col-lg-6">
									<div class="form-group">
										<label>Job Sector *</label> <select class="form-control m-b"
											required name="jobSector">
											<option value="">Select Job Sector</option>
											<%
												for (String key : AppProperies.getProperty("JOB_SECTOR").toString().split("!#")) {
											%>
											<option value="<%=key%>" <%if(user!=null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getJobSector()!=null && user.getProfessionalProfile().getJobSector().equalsIgnoreCase(key)){%>selected<%}%>><%=key%></option>
											<%
												}
											%>
										</select>
									</div>
									<div class="form-group">
										<h4 style="margin-top: 22px !important;">WORK EXPERIENCE :</h4>
									</div>
									<div class="form-group">
										<label>Company Name</label> <input type="text"
											placeholder="Company Name" name="companyName"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getCompanyName() != null) {%><%=user.getProfessionalProfile().getCompanyName()%><%}%>"
											 class="form-control">
									</div>
									<div class="form-group">
										<label>Position</label> <input type="text"
											placeholder="Position" name="position"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getPosition() != null) {%><%=user.getProfessionalProfile().getPosition()%><%}%>"
											 class="form-control">
									</div>
								</div>

								<div class="col-lg-6">
									<div class="form-group">
										<label>Preferred Location *</label> <select
											class="form-control m-b" required name="preferredLocation">
											<option value="">Select Preferred Location</option>
											<%
												for (String key : AppProperies.getProperty("JOB_LOCATION").toString().split("!#")) {
											%>
											<option value="<%=key%>" <%if(user!=null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getPreferredLocation()!=null && user.getProfessionalProfile().getPreferredLocation().equalsIgnoreCase(key)){%>selected<%}%>><%=key%></option>
											<%
												}
											%>
										</select>
									</div>
									<div class="form-group" style="visibility: hidden !important;"><input></div>
									<div class="form-group">
										<label>Duration (in Months)</label> <input type="number"
											placeholder="Duration" min='0' name="duration"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getDuration() != null) {%><%=user.getProfessionalProfile().getDuration()%><%}%>"
											 class="form-control">
									</div>
									<div class="form-group">
										<label>Description</label> <input type="text"
											placeholder="Description" name="description"
											value="<%if (user != null && user.getProfessionalProfile() != null && user.getProfessionalProfile().getDescription() != null) {%><%=user.getProfessionalProfile().getDescription()%><%}%>"
											 class="form-control">
									</div>
								</div>
							</div>
						</fieldset>

						<h1>Further Studies Info</h1>
						<fieldset>
							<div class="row">
								<div class="col-lg-6">
									<div class="form-group">
										<label>Is Studying Further After Degree? *</label> <select
											class="form-control m-b" required
											name="isStudyingFurtherAfterDegree">
											<option value="true" <%if(user!= null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getIsStudyingFurtherAfterDegree()!=null && user.getProfessionalProfile().getIsStudyingFurtherAfterDegree()) {%>selected<%}%>>Yes</option>
											<option value="false" <%if(user!= null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getIsStudyingFurtherAfterDegree()!=null && !user.getProfessionalProfile().getIsStudyingFurtherAfterDegree()) {%>selected<%}%>>No</option>
										</select>
									</div>
									<div class="form-group">
										<label>Area of Interest *</label> <select
											class="form-control m-b" required name="areaOfInterest">
											<option value="">Select Area of Interest</option>
											<%
												for (String key : AppProperies.getProperty("AREAS_OF_INTEREST").toString().split("!#")) {
											%>
											<option value="<%=key%>" <%if(user!= null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getAreaOfInterest()!=null && user.getProfessionalProfile().getAreaOfInterest().equalsIgnoreCase(key)){%>selected<% }%>> <%=key%></option>
											<%
												}
											%>
										</select>
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label>Interested In Type of Course :</label> <select
											class="form-control m-b" required
											name="interestedInTypeOfCourse">
											<option value="">Select any one Course</option>
											<%
												for (String key : AppProperies.getProperty("FURTHER_STUDIES").toString().split("!#")) {
											%>
											<option value="<%=key%>" <%if(user!= null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getInterestedInTypeOfCourse()!=null && user.getProfessionalProfile().getInterestedInTypeOfCourse().equalsIgnoreCase(key)) {%>selected<%}%> ><%=key%></option>
											<%} %>
										</select>
									</div>
								</div>
							</div>
						</fieldset>
						
						<h1>Upload</h1>
						<fieldset>
							<div class="row">
								<div class="col-lg-6">
									<label>Upload Profile Image *</label>
									<div class="fileinput fileinput-new input-group" data-provides="fileinput">
										<div class="form-control" data-trigger="fileinput">
											<i class="glyphicon glyphicon-file fileinput-exists"></i> <span
												class="fileinput-filename"></span>
										</div>
										<span class="input-group-addon btn btn-default btn-file"><span
											class="fileinput-new">Select file</span><span
											class="fileinput-exists">Change</span><input type="hidden"
											id='profile_image' name='profile_image' value=''><input
											type="file" name="" class='stu_file_uploader'
											data-type='profile_image' data-url='profile_image_url'
											accept="image/jpg,image/png,image/jpeg"></span> <a href="#"
											class="input-group-addon btn btn-default fileinput-exists"
											data-dismiss="fileinput">Remove</a>
									</div>
									<label>Resume Upload :</label>
									<div class="fileinput fileinput-new input-group" data-provides="fileinput">
										<div class="form-control" data-trigger="fileinput">
											<i class="glyphicon glyphicon-file fileinput-exists"></i> <span
												class="fileinput-filename"></span>
										</div>
										<span class="input-group-addon btn btn-default btn-file"><span
											class="fileinput-new">Select file</span><span
											class="fileinput-exists">Change</span><input type="hidden"
											id='resume_url' name='resume_url' value=''><input
											type="file" class='stu_file_uploader' data-type='resume'
											data-url='resume_url' accept=".doc,.pdf,.docx"></span> <a
											href="#"
											class="input-group-addon btn btn-default fileinput-exists"
											data-dismiss="fileinput">Remove</a>
									</div>
								</div>
								<div class="col-lg-6">
								<label>Upload 10th Marksheet *</label>
									<div class="fileinput fileinput-new input-group" data-provides="fileinput">
										<div class="form-control" data-trigger="fileinput">
											<i class="glyphicon glyphicon-file fileinput-exists"></i> <span
												class="fileinput-filename"></span>
										</div>
										<span class="input-group-addon btn btn-default btn-file"><span
											class="fileinput-new">Select file</span><span
											class="fileinput-exists">Change</span><input type="hidden"
											id='marks_10_url' name='marks_10_url' value=''><input
											type="file" name="" class='stu_file_uploader'
											data-type='marks_10' data-url='marks_10_url'
											accept="image/jpg,image/png,image/jpeg"></span> <a href="#"
											class="input-group-addon btn btn-default fileinput-exists"
											data-dismiss="fileinput">Remove</a>
									</div>
								
									<label>Upload 12th Marksheet *</label>
									<div class="fileinput fileinput-new input-group" data-provides="fileinput">
										<div class="form-control" data-trigger="fileinput">
											<i class="glyphicon glyphicon-file fileinput-exists"></i> <span
												class="fileinput-filename"></span>
										</div>
										<span class="input-group-addon btn btn-default btn-file"><span
											class="fileinput-new">Select file</span><span
											class="fileinput-exists">Change</span><input type="hidden"
											id='marks_12_url' name='marks_12_url' value=''><input
											type="file" class='stu_file_uploader' data-type='marks_12'
											data-url='marks_12_url'
											accept="image/jpg,image/png,image/jpeg"></span> <a href="#"
											class="input-group-addon btn btn-default fileinput-exists"
											data-dismiss="fileinput">Remove</a>
									</div>
								</div>
							</div>
						</fieldset>
						<h1>Batch Code</h1>
						<fieldset>
						<%if(user != null) {
							DBUTILS util = new DBUTILS();
							String checkIfBatchCodeExist ="select batch_group.name, batch_group.batch_code from batch_group, batch_students where batch_group.id = batch_students.batch_group_id and batch_students.student_id = "+user.getId()+" and batch_group.is_primary = 't'";
							List<HashMap<String,Object>> batchCodeDetails = util.executeQuery(checkIfBatchCodeExist);
							if(batchCodeDetails.size()>0)
							{
								String groupName =  batchCodeDetails.get(0).get("name").toString();
								String code  = batchCodeDetails.get(0).get("batch_code").toString();
								%>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-2 control-label">Primary Group Name:</label>
										<div class="col-sm-5">
											<input type="text" disabled value="<%=groupName %>"  required class="form-control">
										</div>
									</div>

								</div>
								
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-2 control-label">Batch Code:</label>
										<div class="col-sm-5">
											<input type="text" disabled value ="<%=code%>"  required class="form-control">
										</div>
									</div>

								</div>
								<% 
							}else
							{
								%>
								<div class="row">
								<div class="col-lg-6">
									<div class="form-group">
										<label>Enter Batch Code</label> <input type="text"
											placeholder="Enter Batch Code" name="batch_code"
											value="" id="batch_code"
											class="form-control">
									</div>
									<button type="button" id="batch_code_button" class="btn btn-w-m btn-danger">Join Batch</button>
								</div>
							</div>	
								<%
							}	
						%>
						
						
							
						</fieldset>
						<%} %>
						<input type="hidden" id="user_id" name="user_id" value="<%if(user!=null){%><%=user.getId() %><%}%>">
					</form>
					
					<input type="hidden" id="student_id" value="<%if(user!=null){%><%=user.getId() %><%}%>">
				</div>
				<!-- wizard end here -->
				
				
			</div>
		</div>
	</div>


	<!-- Mainly scripts -->
</body>

<script src="<%=cdnUrl%>assets/js/jquery-2.1.1.js"></script>
<script src="<%=cdnUrl%>assets/js/bootstrap.min.js"></script>
<!-- Chosen -->
<script src="<%=cdnUrl%>assets/js/plugins/chosen/chosen.jquery.js"></script>
<!-- Input Mask-->
<script src="<%=cdnUrl%>assets/js/plugins/jasny/jasny-bootstrap.min.js"></script>
<!-- Jquery Validate -->
<script
	src="<%=cdnUrl%>assets/js/plugins/validate/jquery.validate.min.js"></script>
<!-- Select2 -->
<script src="<%=cdnUrl%>assets/js/plugins/select2/select2.full.min.js"></script>

<!-- Steps -->
<script src="<%=cdnUrl%>assets/js/plugins/steps/jquery.steps.min.js"></script>

<script
	src="<%=cdnUrl%>assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>

<script type="text/javascript">
	var map = {};
	function formatRepo(repo) {
		if (repo.loading)
			return repo.text;

		var markup = "<div class='select2-result-repository clearfix'>"
				+ repo.id + "</div>";

		if (repo.description) {
			markup += "<div class='select2-result-repository__description'>"
					+ repo.id + "</div>";
		}
		return markup;
	}

	function formatRepoSelection(repo) {
		return repo.id;
	}
	$(document)
			.ready(
					function() {
						var ll;
						$("#wizard").steps();
						ll=$("#form")
								.steps(
										{
											bodyTag : "fieldset",
											onStepChanging : function(event,
													currentIndex, newIndex) {
												// Always allow going backward even if the current step contains invalid fields!
												if (currentIndex > newIndex) {
													return true;
												}
												if (newIndex === 5) {
													//$('#form').submit();
													
													return true;
												}
												// Forbid suppressing "Warning" step if the user is to young
												/* 	if (newIndex === 3
															&& Number($("#age")
																	.val()) < 18) {
														return false;
													} */
												
												var form = $(this);

												// Clean up if user went backward before
												if (currentIndex < newIndex) {
													// To remove error styles
													$(
															".body:eq("
																	+ newIndex
																	+ ") label.error",
															form).remove();
													$(
															".body:eq("
																	+ newIndex
																	+ ") .error",
															form).removeClass(
															"error");
												}

												// Disable validation on fields that are disabled or hidden.
												form.validate().settings.ignore = ":disabled,:hidden";

												// Start validation; Prevent going forward if false
												return form.valid();
											},
											onStepChanged : function(event,
													currentIndex, priorIndex) {
												// Suppress (skip) "Warning" step if the user is old enough.
												if (currentIndex === 2
														&& Number($("#age")
																.val()) >= 18) {
													$(this).steps("next");
												}
												
												if (currentIndex === 5 && priorIndex === 4){
													//$('.steps ul li .done').nextAll().addClass('disabled');
													$('.steps ul li').each(function(){
														if($(this).hasClass('done')){
															$(this).addClass('disabled');
														}
													});
													
													var form = $(this);
													var serialized = form.serialize();
													$.ajax({
														url : '/<%=actionUrl%>',
														data : serialized,
														type : 'POST',
														success : function(data) {
															//alert('submited and id - '+data);
															$('#student_id').val(data);
														}
													});
													
													
													$('.actions ul li a').each(function() {
														if ($(this).prop('href').indexOf('previous') != -1) {
															$(this).hide();
														}
													});
												}
												
												if(currentIndex === 5){
													
													$('.actions ul li a').each(function() {
														if ($(this).prop('href').indexOf('finish') != -1) {
															$(this).show();
														}
													});
													
												}

												
											},
											onFinishing : function(event,
													currentIndex) {
												//var form = $(this);
												$("a[href]").each(function (){
													if($(this).html()=='Finish')
													{
														var redirectVal = '<%=buttonClick%>';
														var stuId = $('#student_id').val();
														$(this).unbind().on("click",function(){
															$.ajax({
																type : 'GET',
														        url: '/student_signup_ui?stu_id='+stuId+'&redirect='+redirectVal,
																cache : false,
																contentType : false,
																processData : false
														        ,success: function(response) {
														            //alert(response);
														            if (response !== undefined) {
														                window.location.href = '<%=baseURL%>'+response;
														            }
														        }
														     });
														});
													}
												});
												// Disable validation on fields that are disabled.
												// At this point it's recommended to do an overall check (mean ignoring only disabled fields)
												//form.validate().settings.ignore = ":disabled";

												// Start validation; Prevent form submission if false
												//return form.valid();
											},
											onFinished : function(event,
													currentIndex) {
												//var form = $(this);
												
												
												
												// Submit form input
												//form.submit();
											},
                                            enableCancelButton:false
										}).validate({
									errorPlacement : function(error, element) {
										element.before(error);
									},
									rules : {
										password : {
											required : true,
											minlength : 6
										},

										mobile : {
											required : true,
											minlength : 10,
											maxlength : 10

										},
										confirm : {
											equalTo : "#password"
										}
									}
								});
						 $('.actions ul li a').each(function() {
							if ($(this).prop('href').indexOf('finish') != -1) {
								$(this).hide();
							}
						}); 

						$('.signup_button').unbind().click(function() {
							$('#signup_form').submit();
						});

						//$('select').select2();
						$('#data_2 .input-group.date').datepicker({
							startView : 1,
							todayBtn : "linked",
							keyboardNavigation : false,
							forceParse : false,
							autoclose : true,
							format : "dd/mm/yyyy"
						});
						var baseURL = $(".js-data-example-ajax")
								.data("pin_uri");
						var urlPin = baseURL + "PinCodeController";

						$(".js-data-example-ajax")
								.select2(
										{
											ajax : {
												url : urlPin,
												dataType : 'json',
												delay : 250,
												data : function(params) {
													return {
														q : params.term, // search term
														page : params.page
													};
												},
												processResults : function(data,
														params) {
													params.page = params.page || 1;
													return {
														results : data.items,
														pagination : {
															more : (params.page * 30) < data.total_count
														}
													};
												},
												cache : true
											},
											escapeMarkup : function(markup) {
												return markup;
											},
											minimumInputLength : 1,
											templateResult : formatRepo,
											templateSelection : formatRepoSelection
										});
						//$('.js-data-example-ajax').select2();

						$("#signup_form").validate({
							rules : {
								password : {
									required : true,
									minlength : 6
								},

								mobile : {
									required : true,
									minlength : 10,
									maxlength : 10

								}

							}
						});

						$(".select2_demo_1").select2();

						$('.chosen-select').chosen({
							width : "70%"
						});

						$.validator.setDefaults({
							ignore : ":hidden:not(select)"
						});

						// validation of chosen on change
						if ($("select.chosen-select").length > 0) {
							$("select.chosen-select").each(function() {
								if ($(this).attr('required') !== undefined) {
									$(this).on("change", function() {
										$(this).valid();
									});
								}
							});
						}

						$('.course_holder').change(function() {

							$('#session_id').val($(this).val());
						});
						var sThisVal = {};

						$('.chechbox')
								.change(
										function() {
											var row = $(this).parent().parent()
													.children().index(
															$(this).parent());
											var th = $("#mytable thead tr th")
													.eq(row);
											var time = th.text();
											var day = $(this).parent().closest(
													'tr').children('td:first')
													.text();
											if (this.checked) {

												if (sThisVal
														.hasOwnProperty(day))
													sThisVal[day] = sThisVal[day]
															+ '##' + time;
												else
													sThisVal[day] = time;
												console.log(th.text());
												console.log($(this).parent()
														.closest('tr')
														.children('td:first')
														.text());
											} else {
												if (sThisVal
														.hasOwnProperty(day)) {
													var list_of_values = sThisVal[day]
															.split('##');
													var index = list_of_values
															.indexOf(time);
													list_of_values.splice(
															index, 1);
													if (list_of_values.length > 0)
														sThisVal[day] = list_of_values
																.join('##');
													else
														delete sThisVal[day];
												}

											}
											console.log('kahatm');

											//	sThisVal.push($($('.chechbox:checkbox:checked')[i]).val());
											var sThisVal1 = JSON
													.stringify(sThisVal);
											$('#avaiable_time').val(sThisVal1);
										});

						init_form();

					});

	function init_form() {

		
		
		$('#batch_code_button').unbind().on('click', function() {
			
			if($('#student_id')!=null && $('#student_id').val()!=null)
			{
				var stuId = $('#student_id').val();
				var batchCode = $('#batch_code').val();
				$.ajax({
					type : "GET",
					url : "/edit_batch_code",
					data : {
						student_id : stuId,
						batch_code : batchCode	
					},
					success : function(data) {
						if ($(data) != undefined) {
						window.location.reload;	
						}
					}
				});
			}		
			
		});
		
		
		$('#ug_degree').unbind().on('change', function() {
			$.ajax({
				type : "GET",
				url : "/student_signup_ui",
				data : {
					type : "ug_degree",
					value : $(this).val()
				},
				success : function(data) {
					if ($(data) != undefined) {
						$('#underGraduationSpecializationName').html("");
						$('#underGraduationSpecializationName').html(data);
						$('#underGraduationSpecializationName').select2();
					}
				}
			});
		});

		$('#pg_degree').unbind().on('change', function() {
			$.ajax({
				type : "GET",
				url : "/student_signup_ui",
				data : {
					type : "pg_degree",
					value : $(this).val()
				},
				success : function(data) {
					if ($(data) != undefined) {
						$('#postGraduationSpecializationName').html("");
						$('#postGraduationSpecializationName').html(data);
						$('#postGraduationSpecializationName').select2();
					}
				}
			});
		});

		$('.stu_file_uploader').unbind().on('change', function() {
			var file = $(this).prop('files')[0];
			var type = $(this).data('type');
			var urlPath = $(this).data('url');
			var student_id = $('#student_id').val();

			if (file != undefined) {

				var data = new FormData();
				data.append('type', type);
				data.append('image', file);
				data.append('student_id', student_id);
				$.ajax({
					url : '/student_signup_ui',
					data : data,
					cache : false,
					contentType : false,
					processData : false,
					type : 'POST',
					success : function(data) {
						console.log('type : ' + type + '    url----' + data);
						$('#' + urlPath).val(data);
					}
				});
			} else {
				$('#' + urlPath).val('');
			}
		});
	}
</script>

</html>