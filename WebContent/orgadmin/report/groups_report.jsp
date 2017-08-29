<%@page import="java.util.Random"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<%@page import="com.istarindia.android.pojo.*"%>

<%@page import="com.viksitpro.user.service.*"%>


<jsp:include page="/inc/head.jsp"></jsp:include>

<body id='orgadmin_groups_report'>

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
			<ol class="nav breadcrumb mt-lg-5 gray-bg">
				<li class="breadcrumb-item List"><a
					href="/orgadmin/report/roles_report.jsp" class="unselected_report">Roles</a></li>
				<li class="breadcrumb-item List"><a
					href="/orgadmin/report/groups_report.jsp" class="selected_report">Groups</a></li>
			</ol>
		</div>

		<%
			for (int i = 0; i < 10; i++) {
		%>
		<div class="container reprort-card-container">
			<div class="card  report_card_group p-0">
				<div class="card-body p-0">
					<div class='row report-roles-card mb-1'>
						<div class='row m-0 p-0 w-100'>
							<h1 class='report-heading my-0 w-100'>FY BCom . Section 1</h1>
							<p class="stars">
								<i class="dash-star-6x fa fa-star"></i><i
									class="dash-star-6x fa fa-star"></i><i
									class="dash-star-6x fa fa-star"></i><i
									class="dash-star-6x fa fa-star-o"></i><i
									class="dash-star-6x fa fa-star-o"></i>
							</p>
						</div>
						<div class='row m-0 p-0 w-100'>
							<div class="col-6 p-0 w-100 m-0">
								<div class='row p-0 mx-0 w-100 my-2'>
									<div class='m-0 p-0' style='width: 75px;'>
										<img src="/assets/images/report/icons-8-saving-book.png"
											srcset="/assets/images/report/icons-8-saving-book@2x.png 2x,/assets/images/report/icons-8-saving-book@3x.png 3x"
											class="icons8-saving_book">
										<p class='report-roles-sub-text'>
											<span class='spannable'>5</span> Roles
										</p>
									</div>

									<div class='m-0 p-0' style='width: 100px;'>
										<img src="/assets/images/report/icons-8-student.png"
											srcset="/assets/images/report/icons-8-student@2x.png 2x,/assets/images/report/icons-8-student@3x.png 3x"
											class="icons8-student" />
										<p class='report-roles-sub-text'>
											<span class='spannable'>200</span> Students
										</p>
									</div>

									<div class='m-0 p-0' style='width: 130px;'>
										<img src="/assets/images/report/icons-8-report-card.png"
											srcset="/assets/images/report/icons-8-report-card@2x.png 2x,/assets/images/report/icons-8-report-card@3x.png 3x"
											class="icons8-report_card" />
										<p class='report-roles-sub-text'>
											<span class='spannable'>68%</span> Attendance
										</p>
									</div>

									<div class='m-0 p-0' style='width: 135px;'>
										<img src="/assets/images/report/icons-8-discount.png"
											srcset="/assets/images/report/icons-8-discount@2x.png 2x,/assets/images/report/icons-8-discount@3x.png 3x"
											class="icons8-discount" />
										<p class='report-roles-sub-text'>
											<span class='spannable'>85%</span> Performance
										</p>
									</div>

								</div>
							</div>
						</div>
					</div>
					<div class='line'></div>
					<div class='row report-roles-card mb-0'>


						<%
							Random rn = new Random();
								int size = rn.nextInt(4);
								if (size != 0) {
						%>


						<div id="carouselExampleControls<%=i%>"
							class="carousel slide w-100 carousel-holder" data-ride="carousel"
							data-interval="false">
							<div class="carousel-inner">

								<%
									for (int k = 0; k < size; k++) {
								%>

								<div class="carousel-item <%=k == 0 ? "active" : ""%>">
									<div class='row custom-no-margins'>

										<%
											for (int j = 0; j < 4; j++) {
										%>
										<div class="card p-0 report-section-carousel-card">
											<div class="card-header report-section-card-header">
												<div class='row p-3 m-0 w-100'>
													<div class='col-2 p-0 m-0'>

														<img class='report-group-image'
															src='http://cdn.talentify.in:9999/course_images/5.png'
															alt='image'></img>

													</div>
													<div class='col-1 p-0 m-0'></div>
													<div class='col-9 p-0 m-0'>
														<h5 class='report-section-card-header-title'>Desktop
															Publishing</h5>
														<p class="stars">
															<i class="dash-star-6x fa fa-star"></i><i
																class="dash-star-6x fa fa-star"></i><i
																class="dash-star-6x fa fa-star"></i><i
																class="dash-star-6x fa fa-star-o"></i><i
																class="dash-star-6x fa fa-star-o"></i>
														</p>
													</div>
												</div>
											</div>
											<div class="card-body">
												<div class='row pt-2 px-3 pb-3 '>

													<div class='col-3'>
														<img src="/assets/images/report/icons-8-student.png"
															srcset="/assets/images/report/icons-8-student@2x.png 2x,/assets/images/report/icons-8-student@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'>25</h5>
													</div>

													<div class='col-3'>
														<img src="/assets/images/report/icons-8-report-card.png"
															srcset="/assets/images/report/icons-8-report-card@2x.png 2x,/assets/images/report/icons-8-report-card@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'>68%</h5>
													</div>

													<div class='col-3'>
														<img src="/assets/images/report/icons-8-discount.png"
															srcset="/assets/images/report/icons-8-discount@2x.png 2x,/assets/images/report/icons-8-discount@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'>85%</h5>
													</div>


												</div>
												<p class='report-section-completion mb-0'>Course
													completion</p>

												<div class='row p-0 m-0'>
													<div class='col-10 my-auto p-0'>
														<div class='progress'>
															<div class='progress-bar report-roles-progress'
																role='progressbar' style='width: 60%' aria-valuenow='60'
																aria-valuemin='0' aria-valuemax='100'></div>
														</div>
													</div>
													<div
														class='col-2 report-roles-course-completion text-center p-0 mx-auto'>80%</div>
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
								class="icons8-chevron_right_round">

							</a> <a class="carousel-control-prev custom-left-prev-section"
								href="#carouselExampleControls<%=i%>" role="button"
								data-slide="prev"> <img
								src="/assets/images/report/icons-8-chevron-right-round.png"
								srcset="/assets/images/report/icons-8-chevron-right-round@2x.png 2x,
             /assets/images/report/icons-8-chevron-right-round@3x.png 3x"
								class="icons8-chevron_right_round" />
							</a>
						</div>

						<%
							} else {
						%>
						<div class="jumbotron m-auto w-100 text-center bg-white">
							<h1>No Roles Found!</h1>
						</div>

						<%
							}
						%>

					</div>
				</div>
			</div>


		</div>
		<%
			}
		%>

	</div>




	<jsp:include page="/inc/foot.jsp"></jsp:include>

	<script>
		$(document).ready(function() {
			$('.carousel-holder').each(function() {
				checkitem($(this));
			});

			$('.carousel-holder').bind('slid.bs.carousel', function(e) {
				checkitem($(this));
			});
		});

		function checkitem($this) // check function
		{
			if ($this.find('.carousel-inner .carousel-item:first').hasClass(
					'active')) {
				$this.find('.carousel-control-prev').hide();
				$this.find('.carousel-control-next').show();
			} else if ($this.find('.carousel-inner .carousel-item:last')
					.hasClass('active')) {
				$this.find('.carousel-control-prev').show();
				$this.find('.carousel-control-next').hide();
			} else {
				$this.find('.carousel-control-next').show();
				$this.find('.carousel-control-prev').show();
			}
		}
	</script>

</body>

</html>