<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="http://localhost:8080/img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="http://localhost:8080/assets/css/bootstrap.min.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/timepicki.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/dataTables/datatables.min.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.min.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.print.css" rel='stylesheet' media='print'>

<link href="http://localhost:8080/assets/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<link href="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />

<link href="http://localhost:8080/assets/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/animate.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/style.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/toastr/toastr.min.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/chosen/bootstrap-chosen.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link rel="stylesheet" href="http://localhost:8080/assets/css/jquery.rateyo.min.css">
<link href="http://localhost:8080/assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/steps/jquery.steps.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">


</head>



<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">



			<div class="row border-bottom white-bg">





				<nav class="navbar navbar-static-top" role="navigation">
					<div class="navbar-header">
						<button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
							<i class="fa fa-reorder"></i>
						</button>
						<a href="/coordinator/dashboard.jsp" class="navbar-brand">Talentify</a>
					</div>
					<div class="navbar-collapse collapse" id="navbar">
						<ul class="nav navbar-nav">

							<li><a id="Dashboard" href="/coordinator/dashboard.jsp">Dashboard</a></li>




							<li><a id="Requirement" href="/coordinator/requirement.jsp">Requirement</a></li>




							<li><a id="TrianerWiseDetails" href="/coordinator/trainer_wise_details.jsp">Trianer Wise Details</a></li>




							<li><a id="ClusterandCourseWiseDetails" href="/coordinator/course_city_wise_details.jsp">Cluster and Course Wise Details</a></li>




						</ul>


						<ul class="nav navbar-top-links navbar-right">
							<li><a href="/auth/logout"> <i class="fa fa-sign-out"></i> Log out
							</a></li>
						</ul>


					</div>
				</nav>

				<div style="display: none" id="admin_page_loader">
					<div style="width: 100%; z-index: 6; position: fixed;" class="spiner-example">
						<div style="width: 100%;" class="sk-spinner sk-spinner-three-bounce">
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
					<div class='col-md-4'>
						<div class="widget-head-color-box navy-bg p-lg text-center">
                            <div class="m-b-md">
                            <h2 class="font-bold no-margins">
                                ppppp
                            </h2>
                                <small>datto@istarindia.com</small>
                            </div>
                            <img src="img/a4.jpg" class="img-circle circle-border m-b-md" alt="profile">
                            <div>
                                <span>1234567890</span> 
                              
                            </div>
                        </div>
						
						<div class='product-box '>
							<div class='ibox' style='height: 100%;'>
								<div class='ibox-content ' style='height: 100%; min-height: 500px'>
									<h3>Trainer Name : ppppp</h3>
									<ul class='list-group clear-list m-t'>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Email</b>
												</div>
												<div class='col-md-8	 no-padding'>datto@istarindia.com</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Mobile</b>
												</div>
												<div class='col-md-8	 no-padding'>1234567890</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Gender</b>
												</div>
												<div class='col-md-8	 no-padding'>MALE</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>UG Degree</b>
												</div>
												<div class='col-md-8	 no-padding'>BCOM</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>PG Degree</b>
												</div>
												<div class='col-md-8	 no-padding'>MA</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Experience</b>
												</div>
												<div class='col-md-8	 no-padding'>2 years 3 months</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Interested Courses</b>
												</div>
												<div class='col-md-8	 no-padding'>Business Communication, Data Analytics, Direct Tax Theory, Retail Banking, Wealth management Level II</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-8 no-padding'>
													<h3>Available Days and Time Slots</h3>
												</div>
												<div class='col-md-3	 no-padding'></div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Tuesday</b>
												</div>
												<div class='col-md-8	 no-padding'>10am - 11am</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Wednesday</b>
												</div>
												<div class='col-md-8	 no-padding'>8am - 6pm</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Friday</b>
												</div>
												<div class='col-md-8	 no-padding'>10am - 12pm</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Thrusday</b>
												</div>
												<div class='col-md-8	 no-padding'>10am - 12pm</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Monday</b>
												</div>
												<div class='col-md-8	 no-padding'>10am - 11am, 12pm - 1pm, 2pm - 3pm, 4pm - 5pm</div>
											</div>
										</li>
										<li class='list-group-item' style='margin-left: -16px; margin-right: -13px;'>
											<div class='row'>
												<div class='col-md-1  no-padding'></div>
												<div class='col-md-3 no-padding'>
													<b>Saturday</b>
												</div>
												<div class='col-md-8	 no-padding'>10am - 11am</div>
											</div>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>



				</div>
			</div>
		</div>
	</div>



	<!-- Mainly scripts -->





	<script src="http://localhost:8080/assets/js/plugins/fullcalendar/moment.min.js"></script>

	<script src="http://localhost:8080/assets/js/jquery-2.1.1.js"></script>



	<script src="http://localhost:8080/assets/js/bootstrap.min.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="http://localhost:8080/assets/js/inspinia.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/pace/pace.min.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/dataTables/datatables.min.js"></script>
	<script type="text/javascript" src="http://localhost:8080/assets/js/jquery.bootpag.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>
	<!-- Clock picker -->
	<script src="http://localhost:8080/assets/js/plugins/clockpicker/clockpicker.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/select2/select2.full.min.js"></script>

	<script src="http://localhost:8080/assets/js/app.js"></script>
	<script>
		(function(i, s, o, g, r, a, m) {
			i['GoogleAnalyticsObject'] = r;
			i[r] = i[r] || function() {
				(i[r].q = i[r].q || []).push(arguments)
			}, i[r].l = 1 * new Date();
			a = s.createElement(o), m = s.getElementsByTagName(o)[0];
			a.async = 1;
			a.src = g;
			m.parentNode.insertBefore(a, m)
		})(window, document, 'script',
				'https://www.google-analytics.com/analytics.js', 'ga');

		ga('create', 'UA-101170072-1', 'auto');
		ga('send', 'pageview');
	</script>
</body>

</html>
