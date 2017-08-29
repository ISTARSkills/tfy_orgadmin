<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>


<jsp:include page="/inc/head.jsp"></jsp:include>

<body id='orgadmin_roles_report'>

	<%
		boolean flag = false;

		String url = request.getRequestURL().toString();

		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())

				+ request.getContextPath() + "/";

		IstarUser user = (IstarUser) request.getSession().getAttribute("user");

		RestClient rc = new RestClient();

		ComplexObject cp = rc.getComplexObject(user.getId());

		if (cp == null) {

			flag = true;

			request.setAttribute("msg", "User Does Not Have Permission To Access");

			request.getRequestDispatcher("/login.jsp").forward(request, response);

		}

		request.setAttribute("cp", cp);
	%>

	<jsp:include page="/inc/navbar.jsp"></jsp:include>



	<div class="jumbotron gray-bg">
		<div class="container">
			<ol class="nav breadcrumb  mt-lg-5 gray-bg">
				<li class="breadcrumb-item List"><a
					href="/orgadmin/report/roles_report.jsp" class="selected_report">Roles</a></li>
				<li class="breadcrumb-item List"><a
					href="/orgadmin/report/groups_report.jsp" class="unselected_report">Groups</a></li>
			</ol>
		</div>
		<%
			for (int i = 0; i < 10; i++) {
		%>
		<div class="container my-5">


			<div class="card  report_card p-0">
				<div class="card-body p-0">
					<div class='row report-roles-card'>
						<div class="col-md-2">
							<img class='report-role-image'
								src='http://cdn.talentify.in:9999/course_images/5.png'></img>
						</div>
						<div class="col-md-6">
							<h1 class='report-heading my-0'>Desktop Publishing</h1>
							<p class="stars">
								<i class="trainer-dash-star fa fa-star"></i><i
									class="trainer-dash-star fa fa-star"></i><i
									class="trainer-dash-star fa fa-star"></i><i
									class="trainer-dash-star fa fa-star-o"></i><i
									class="trainer-dash-star fa fa-star-o"></i>
							</p>
							<div class='row' style='margin-top: 30px'>

								<div class='col-md-3'>
									<img src="/assets/images/report/icons-8-groups.png"
										srcset="/assets/images/report/icons-8-groups@2x.png 2x,/assets/images/report/icons-8-groups@3x.png 3x"
										class="icons8-groups" />
									<h5 class='report-roles-sub-text'>
										<span class='spannable'>5</span> Groups
									</h5>
								</div>

								<div class='col-md-3'>
									<img src="/assets/images/report/icons-8-student.png"
										srcset="/assets/images/report/icons-8-student@2x.png 2x,/assets/images/report/icons-8-student@3x.png 3x"
										class="icons8-student" />
									<h5 class='report-roles-sub-text'>
										<span class='spannable'>200</span> Students
									</h5>
								</div>

								<div class='col-md-3'>
									<img src="/assets/images/report/icons-8-report-card.png"
										srcset="/assets/images/report/icons-8-report-card@2x.png 2x,/assets/images/report/icons-8-report-card@3x.png 3x"
										class="icons8-report_card" />
									<h5 class='report-roles-sub-text'>
										<span class='spannable'>68%</span> Attendance
									</h5>
								</div>

								<div class='col-md-3'>
									<img src="/assets/images/report/icons-8-discount.png"
										srcset="/assets/images/report/icons-8-discount@2x.png 2x,/assets/images/report/icons-8-discount@3x.png 3x"
										class="icons8-discount" />
									<h5 class='report-roles-sub-text'>
										<span class='spannable'>85%</span> Performance
									</h5>
								</div>

							</div>
						</div>
						<div class="col-md-4 mx-0 my-0 p-0">
							<div id="container<%=i%>" class='skill_graph'
								style='width: 100%; height: 151.3px;'></div>
						</div>
					</div>
					<div class='line'></div>
					<div class='row report-roles-card'>

						<div id="carouselExampleControls<%=i%>"
							class="carousel slide w-100" data-ride="carousel"
							data-interval="false">
							<div class="carousel-inner">

								<%
									for (int k = 0; k < 5; k++) {
								%>
								<div class="carousel-item <%=k == 0 ? "active" : ""%>">
									<div class='row custom-no-margins justify-content-md-center'>

										<%
											for (int j = 0; j < 3; j++) {
										%>
										<div class="card col-md-3 p-0 mx-5">
											<div class="card-header report-section-card-header">
												<h5 class='report-section-card-header-title'>FY BCom.
													Section 1</h5>
												<p class="stars">
													<i class="trainer-dash-star fa fa-star"></i><i
														class="trainer-dash-star fa fa-star"></i><i
														class="trainer-dash-star fa fa-star"></i><i
														class="trainer-dash-star fa fa-star-o"></i><i
														class="trainer-dash-star fa fa-star-o"></i>
												</p>
											</div>
											<div class="card-body">
												<div class='row p-3'>

													<div class='col-md-3'>
														<img src="/assets/images/report/icons-8-student.png"
															srcset="/assets/images/report/icons-8-student@2x.png 2x,/assets/images/report/icons-8-student@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'>25</h5>
													</div>

													<div class='col-md-3'>
														<img src="/assets/images/report/icons-8-report-card.png"
															srcset="/assets/images/report/icons-8-report-card@2x.png 2x,/assets/images/report/icons-8-report-card@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'>68%</h5>
													</div>

													<div class='col-md-3'>
														<img src="/assets/images/report/icons-8-discount.png"
															srcset="/assets/images/report/icons-8-discount@2x.png 2x,/assets/images/report/icons-8-discount@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'>85%</h5>
													</div>


												</div>
												<p class='report-section-completion mb-0'>Course
													completion</p>

												<div class='row p-0 m-0'>
													<div class='col-md-10 my-auto p-0'>
														<div class='progress'>
															<div class='progress-bar report-roles-progress'
																role='progressbar' style='width: 60%' aria-valuenow='60'
																aria-valuemin='0' aria-valuemax='100'></div>
														</div>
													</div>
													<div
														class='col-md-2 report-roles-course-completion text-center p-0 mx-auto'>80%</div>
												</div>

											</div>
										</div>

										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>
							</div>
							<a class="carousel-control-next custom-right-prev-section"
								href="#carouselExampleControls<%=i%>" role="button"
								data-slide="next"> <img
								src="/assets/images/report/icons-8-chevron-right-round.png"
								srcset="/assets/images/report/icons-8-chevron-right-round@2x.png 2x,
             /assets/images/report/icons-8-chevron-right-round@3x.png 3x"
								class="icons8-chevron_right_round" />

							</a> <a class="carousel-control-prev custom-left-prev-section"
								href="#carouselExampleControls<%=i%>" role="button"
								data-slide="prev"> <img
								src="/assets/images/report/icons-8-chevron-right-round.png"
								srcset="/assets/images/report/icons-8-chevron-right-round@2x.png 2x,
             /assets/images/report/icons-8-chevron-right-round@3x.png 3x"
								class="icons8-chevron_right_round" />
							</a>
						</div>

					</div>
				</div>
			</div>


		</div>
		<%
			}
		%>
	</div>

	<!--/row-->


	<jsp:include page="/inc/foot.jsp"></jsp:include>

	<script>
		Highcharts.setOptions({
			colors : [ '#fd6d81', '#7295fd', '#30beef', '#bae88a' ]
		});

		$(document).ready(
				function() {

					var chart;
					$('.skill_graph').each(
							function(index) {

								new Highcharts.Chart({
									legend : {
										layout : 'vertical',
										backgroundColor : '#ffffff',
										align : 'right',
										symbolHeight : 5,
										symbolRadius : 0,
										verticalAlign : 'middle',
										floating : true,
									},
									chart : {
										renderTo : 'container' + index,
										type : 'pie'
									},
									title : {
										text : ''
									},
									yAxis : {
										title : {
											text : ''
										}
									},
									plotOptions : {
										pie : {
											shadow : false
										}
									},
									tooltip : {
										formatter : function() {
											return '<b>' + this.point.name
													+ '</b>: ' + this.y + ' %';
										}
									},
									series : [ {
										name : 'Mastry Level',
										data : [ [ "Wizrard", 3 ],
												[ "Master", 4 ],
												[ "Apprentice", 7 ],
												[ "Rookie", 3 ] ],
										size : '121.3px',
										innerSize : '60%',
										showInLegend : true,
										dataLabels : {
											enabled : false
										}
									} ]
								});

							});

				});
	</script>

</body>

</html>