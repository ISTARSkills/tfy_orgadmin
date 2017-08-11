<!DOCTYPE html>
<%@page import="com.viksitpro.core.dao.entities.Batch"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="http://localhost:8080/img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="http://localhost:8080/assets/css/bootstrap.min.css"
	rel="stylesheet">
<link href="http://localhost:8080/assets/css/timepicki.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">

<link
	href="http://localhost:8080/assets/css/plugins/select2/select2.min.css"
	rel="stylesheet">

<link
	href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.min.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>

<link
	href="http://localhost:8080/assets/css/plugins/datapicker/datepicker3.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/clockpicker/clockpicker.css"
	rel="stylesheet">
<link
	href="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.css"
	rel="stylesheet" type="text/css" />

<link
	href="http://localhost:8080/assets/font-awesome/css/font-awesome.css"
	rel="stylesheet">
<link href="http://localhost:8080/assets/css/animate.css"
	rel="stylesheet">
<link href="http://localhost:8080/assets/css/style.css" rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/toastr/toastr.min.css"
	rel="stylesheet">

<link
	href="http://localhost:8080/assets/css/plugins/chosen/bootstrap-chosen.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="http://localhost:8080/assets/css/jquery.rateyo.min.css">
<link
	href="http://localhost:8080/assets/css/plugins/sweetalert/sweetalert.css"
	rel="stylesheet">

<link
	href="http://localhost:8080/assets/css/plugins/daterangepicker/daterangepicker-bs3.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/steps/jquery.steps.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css"
	rel="stylesheet">


</head>


<%
int orgId = Integer.parseInt(request.getParameter("org_id"));
Organization org = new OrganizationDAO().findById(orgId);
DBUTILS util = new DBUTILS();
String findAdmin ="select email, password from user_org_mapping, user_role, istar_user where organization_id = "+orgId+"  and user_org_mapping.user_id = user_role.user_id and user_role.role_id = (select id from role where role_name ='ORG_ADMIN') and user_role.user_id = istar_user.id";
List<HashMap<String, Object>> adminData = util.executeQuery(findAdmin);
String adminEmail = adminData.get(0).get("email").toString();
String adminPwd = adminData.get(0).get("password").toString();
%>
<body class="top-navigation">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom white-bg">
				<nav class="navbar navbar-static-top" role="navigation">
					<div class="navbar-header">
						<button aria-controls="navbar" aria-expanded="false"
							data-target="#navbar" data-toggle="collapse"
							class="navbar-toggle collapsed" type="button">
							<i class="fa fa-reorder"></i>
						</button>
						<a href="/coordinator/dashboard.jsp" class="navbar-brand">Talentify</a>
					</div>
					<div class="navbar-collapse collapse" id="navbar">
						<ul class="nav navbar-nav">

							<li><a id="Dashboard" href="/coordinator/dashboard.jsp">Dashboard</a></li>
						</ul>


						<ul class="nav navbar-top-links navbar-right">
							<li><a href="/auth/logout"> <i class="fa fa-sign-out"></i>
									Log out
							</a></li>
						</ul>


					</div>
				</nav>

				<div style="display: none" id="admin_page_loader">
					<div style="width: 100%; z-index: 6; position: fixed;"
						class="spiner-example">
						<div style="width: 100%;"
							class="sk-spinner sk-spinner-three-bounce">
							<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
							<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
							<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
						</div>
					</div>
				</div>
			</div>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Org Details</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<form role="form" class="form-inline">
									<div class="form-group">
										<label for="exampleInputEmail2">Org Name</label> <input
											type="text" id="exampleInputEmail2" class="form-control"
											value="<%=org.getName()%>">
									</div>
									<div class="form-group">
										<label for="exampleInputEmail2">Org Admin Email</label> <input
											type="email" id="exampleInputEmail2" class="form-control"
											value="<%=adminEmail%>">
									</div>
									<div class="form-group">
										<label for="exampleInputEmail2">Org Admin Password</label> <input
											type="text" id="exampleInputEmail2" class="form-control"
											value="<%=adminPwd%>">
									</div>
								</form>
							</div>
						</div>
					</div>
					
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Section Details</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<%
								for(BatchGroup bg : org.getBatchGroups())
								{
									%>
								<form role="form" class="form-inline">
									<div class="form-group">
										<label for="exampleInputEmail2"><%=bg.getId()%></label> 
									</div>
									<div class="form-group">
										<label for="exampleInputEmail2">Section Name</label> <input
											type="text" id="exampleInputEmail2" class="form-control"
											value="<%=bg.getName()%>">
									</div>
									<div class="form-group">
										<label for="exampleInputEmail2">Student Count</label> <input
											type="text" id="exampleInputEmail2" class="form-control"
											value="<%=bg.getBatchStudentses().size()%>">
									</div>
									<div class="form-group">
										<label for="exampleInputEmail2">Courses</label> 
										<select>
										<%
										for(Batch batch :bg.getBatchs())
										{
											%>
											<option value="<%=batch.getCourse().getId()%>"><%=batch.getCourse().getCourseName()%></option>
											<%
										}	
										%>
										</select>
										
									</div>
								</form>
								<%
								}	
								%>
							</div>
						</div>
					</div>



				</div>
			</div>

		</div>

	</div>




	<!-- Mainly scripts -->





	<script
		src="http://localhost:8080/assets/js/plugins/fullcalendar/moment.min.js"></script>

	<script src="http://localhost:8080/assets/js/jquery-2.1.1.js"></script>



	<script src="http://localhost:8080/assets/js/bootstrap.min.js"></script>
	<script
		src="http://localhost:8080/assets/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script
		src="http://localhost:8080/assets/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="http://localhost:8080/assets/js/inspinia.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/pace/pace.min.js"></script>
	<script
		src="http://localhost:8080/assets/js/plugins/dataTables/datatables.min.js"></script>
	<script type="text/javascript"
		src="http://localhost:8080/assets/js/jquery.bootpag.js"></script>
	<script
		src="http://localhost:8080/assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>
	<!-- Clock picker -->
	<script
		src="http://localhost:8080/assets/js/plugins/clockpicker/clockpicker.js"></script>
	<script
		src="http://localhost:8080/assets/js/plugins/select2/select2.full.min.js"></script>
	<script
		src="http://localhost:8080/assets/js/plugins/nestable/jquery.nestable.js"></script>

	<script src="http://localhost:8080/assets/js/app.js"></script>
	<script>
         $(document).ready(function(){

            
        	


             // output initial serialised data
            

             /* $('#nestable-menu').on('click', function (e) {
                 var target = $(e.target),
                         action = target.data('action');
                 if (action === 'expand-all') {
                     $('.dd').nestable('expandAll');
                 }
                 if (action === 'collapse-all') {
                     $('.dd').nestable('collapseAll');
                 }
             }); */
         });
    </script>


	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

		  ga('create', 'UA-103015121-1', 'auto');
		  ga('send', 'pageview');
		  ga('set', 'userId', 'NOT_LOGGED_IN_USER'); // Set the user ID using signed-in user_id.

	</script>
</body>

</html>
