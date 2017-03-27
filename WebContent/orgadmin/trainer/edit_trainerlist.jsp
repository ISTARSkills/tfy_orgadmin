<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="in.orgadmin.utils.BatchUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.dao.StudentProfileData"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Portal | Add/Edit TrainerList</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
<!-- DataTable -->

<link
	href="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/buttons/1.2.2/css/buttons.dataTables.min.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>css/jquery.contextMenu.css" rel="stylesheet"
	type="text/css" />
<link href="<%=baseURL%>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
</head>
	<%
	
	Student student = null;
	StudentProfileData studentProfileData= null;
	String trainerImage = "/img/user_images/student.png";
	String details = "";
	boolean newUser = true;
	
		if(request.getParameterMap().containsKey("trainer_id")){
			int trainer_id = Integer.parseInt(request.getParameter("trainer_id"));
			student = new StudentDAO().findById(trainer_id);
			
			studentProfileData = student.getStudentProfileData();
			
			trainerImage = studentProfileData.getProfileImage();
         	
         	if(trainerImage==null || trainerImage.trim().isEmpty()){
         		trainerImage = "/img/user_images/student.png";
         	}
         	
         	details = student.getUserType();
         	newUser = false;
		}
	%>

<body class="fixed-navigation">
	<div id="wrapper">
		<jsp:include page="../includes/sidebar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
				
				
				<div class="col-md-6">

                    <div class="profile-image">
                        <img src="<%=trainerImage %>" class="img-circle circle-border m-b-md" alt="profile">
                    </div>

                    
                    <div class="profile-info">
                        <div class="">
                            <div>

									<% if(newUser){ %>
										<h2>Create new user</h2>
									<%
										} else {
											%>
											<h2><%=details%>
												DETAILS
											</h2>
											<h4><%=studentProfileData.getFirstname()%></h4>
											<small> <%=studentProfileData.getEmail()%>
											</small>
											<%
										}
									%>
								</div>
                        </div>
                    </div>
                </div>

				

				</div>
			</div>
			<div class="row white-bg dashboard-header" style="padding: 0px">
				<div class="ibox float-e-margins">
					<div class="ibox-content">

						<form action="<%=baseURL%>update_trainer_details" method="get"
							class="form-horizontal">


							<div class="form-group">
								<label class="col-sm-2 control-label">Email</label>

								<div class="col-sm-3">



									<input type="text" id="email" name="email" class="form-control"
										data-validation="required" value="<%=newUser?"":studentProfileData.getEmail()%>">


								</div>
							</div>

							<div class="form-group">
								<label class="col-sm-2 control-label">Password</label>

								<div class="col-sm-3">

									<input type="text" id="password" name="password"
										data-validation="required" class="form-control" value="<%=newUser?"":student.getPassword()%>">


								</div>
							</div>


							<div class="form-group">
								<label class="col-sm-2 control-label">Name</label>

								<div class="col-sm-3">

									<input type="text" id="trainer_name" name="trainer_name"
										data-validation="required" class="form-control" value="<%=newUser?"":studentProfileData.getFirstname()%>">


								</div>
							</div>


							<div class="form-group">
								<label class="col-sm-2 control-label">Mobile</label>

								<div class="col-sm-3">

									<input type="number" id="mobile" name="mobile"
										data-validation="required" class="form-control" value="<%=newUser?"":studentProfileData.getMobileno()%>">


								</div>
							</div>

							<div class="form-group" id="form-gender">

								<label class="col-sm-2 control-label">Gender</label>
								<div class="col-sm-10">
									<%
									
									String isMale = "";
									String isFemale = "";
									if(!newUser){
									
									if(studentProfileData.getGender().equalsIgnoreCase("MALE")) {
										isMale = "checked='checked' ";
									} else if(studentProfileData.getGender().equalsIgnoreCase("FEMALE")) {
										isFemale = "checked='checked' ";
									}
									} else{
										isMale = "checked='checked' ";
									}
									%>

									<div>

										<label> <input type="radio" <%=isMale%> value="MALE"
											id="male" name="gender"> MALE
										</label> <label> <input type="radio" <%=isFemale%>
											value="FEMALE" id="female" name="gender"> FEMALE
										</label>
									</div>
								</div>
							</div>
							<%-- <div class="form-group">
								<label class="col-sm-2 control-label">Father Name</label>

								<div class="col-sm-3">

									<input type="text" id="father_name" name="father_name"
										data-validation="required" class="form-control" value="<%=student.getFatherName()%>">


								</div>
							</div> --%>

							<%-- <div class="form-group">
								<label class="col-sm-2 control-label">Mother Name</label>

								<div class="col-sm-3">

									<input type="text" id="mother_name" name="mother_name"
										data-validation="required" class="form-control" value="<%=student.getMotherName()%>">


								</div>
							</div> --%>
							
<%-- 							 <% String isAddress1= "";
                               String isAddress2= "";
                               String isCity= "";
                               String isState= "";
                               String isCountry= "";
                               int isPin= 0;
   
                               if(request.getParameterMap().containsKey("trainer_id")){
                            	   
                               
                          if(student.getAddress().getAddressline1()!=null && student.getAddress().getAddressline1()!=null && student.getAddress().getPincode().getCity()!=null 
                        		  
                        		  && student.getAddress().getPincode().getState()!=null && student.getAddress().getPincode().getCountry()!=null){
	   
	                      isAddress1=student.getAddress().getAddressline1();
	                      isAddress2=student.getAddress().getAddressline2();
	                      isCity= student.getAddress().getPincode().getCity();
                          isState= student.getAddress().getPincode().getState();
                          isCountry= student.getAddress().getPincode().getCountry();
                          isPin= student.getAddress().getPincode().getPin();
	   
    					}
   
                	
                               }
                               
                               else{
                               	
                         		  isAddress1= "";
                                   isAddress2= "";
                                   isCity= "";
                                   isState= "";
                                   isCountry= "";
                                   isPin= 0;
                          
                          			} 
                 
  							 %>  --%>
 
 
							<%-- <div class="form-group" id="address_id"
								value="">
								<label class="col-sm-2 control-label">Address Line 1</label>

								<div class="col-sm-5">

									<input type="text" id="address_line1" name="address_line1"
										data-validation="required" class="form-control"
										value="<%=isAddress1%>">


								</div>
							</div> --%>

							<%-- <div class="form-group">
								<label class="col-sm-2 control-label">Address Line 2</label>

								<div class="col-sm-5">

									<input type="text" id="address_line2" name="address_line2"
										data-validation="required" class="form-control"
										value="<%=isAddress2%>">


								</div>
							</div> --%>

							<%-- <div class="form-group">
                            <label class="col-sm-2 control-label">Address Line 3</label>
                            
                            
                            
                            
								<div class="col-sm-10" id="pincode_id"
									value="">
									<div class="row">

										<div class="col-md-2">
											<input type="text" placeholder="City" class="form-control"
												data-validation="required" id="city" name="city"
												value="<%=isCity%>">
										</div>

										<div class="col-md-2">
											<input type="text" placeholder="State" class="form-control"
												data-validation="required" id="state" name="state"
												value="<%=isState%>">
										</div>

										<div class="col-md-2">
											<input type="text" placeholder="Country" class="form-control"
												data-validation="required" id="country" name="country"
												value="<%=isCountry%>">
										</div>

										<div class="col-md-2">
											<input type="text" placeholder="PinCode" class="form-control"
												data-validation="required" id="pincode" name="pincode"
												value="<%=isPin%>">
										</div>
									</div>
								</div>
							</div> --%>

							<div class="form-group" id="form-Utype">
							
							

								<label class="col-sm-2 control-label">User Type:</label>
								<div class="col-sm-3" id="user-type" user-type="<%=newUser?"":newUser?"":student.getUserType()%>">

									<div >
										
										<label> <input type="radio" data-validation="required"
											data-validation="radio_button" value="TRAINER"  id="TRAINER" name="Utype"> TRAINER
										</label>
									</div>
									<div>
										
										<label> <input type="radio" value="STUDENT" id="STUDENT"
											data-validation="radio_button" data-validation="required" name="Utype">
											STUDENT
										</label>
										
									</div>
								</div>
							</div>
							<%if (request.getParameterMap().containsKey("org_id")) {
								int org_id = Integer.parseInt(request.getParameter("org_id"));
								Organization o = new OrganizationDAO().findById(org_id);
 							%>

							<input type="hidden" name="org_id" value="<%=o.getId()%>">

							<%} else { %>
							<input type="hidden" name="trainer_id" 
								value="<%=newUser?"":student.getId()%>">
							<%} %>

							<button class="btn btn-primary" id="send_data" type="submit">Save
								changes</button>
												</form>
					</div>
				</div>
			</div>
		</div>

	</div>

	</div>
	</div>
	<!-- Mainly scripts -->


	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=baseURL%>js/jquery.contextMenu.js"
		type="text/javascript"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<script src="<%=baseURL%>js/plugins/jeditable/jquery.jeditable.js"></script>



	<script
		src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>


	<script
		src="https://cdn.datatables.net/buttons/1.2.2/js/dataTables.buttons.min.js"></script>
	<script
		src="//cdn.datatables.net/buttons/1.2.2/js/buttons.flash.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script>
	<script
		src="//cdn.rawgit.com/bpampuch/pdfmake/0.1.18/build/pdfmake.min.js"></script>
	<script
		src="//cdn.rawgit.com/bpampuch/pdfmake/0.1.18/build/vfs_fonts.js"></script>
	<script
		src="//cdn.datatables.net/buttons/1.2.2/js/buttons.html5.min.js"></script>
	<script
		src="//cdn.datatables.net/buttons/1.2.2/js/buttons.print.min.js"></script>

	<script src="<%=baseURL%>js/highcharts-custom.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>





	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>
	
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>

	 
        
	<script>
	
	 
        
		 $(document).ready(function() {
			 
			 var userType = $('#user-type').attr('user-type');
			     $('#'+userType).attr('checked', 'checked');
	            
			 $.validate();
			 
						});
	</script>
     

	</script>



</body>
</html>