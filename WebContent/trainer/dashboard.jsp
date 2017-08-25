<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<body>
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
			<div class="row justify-content-md-center custom-no-margins">
				<%

%>

				<div class='col-md-8 custom-no-padding'>
					<h1>Today's Events</h1>
				</div>
				<div class='col-md-4 col-md-auto'>
					<div class="row">
						<div class="col-md-4">
							<h1>
								<button class="label-info-green">
									<div class="row mx-0">
										<div class="oval-big-green ml-sm-2"></div>
										<div class="ongoing ml-sm-3">Ongoing</div>
									</div>
								</button>
							</h1>
						</div>
						<div class="col-md-4 pl-sm-2">
							<h1>
								<button class="label-info-blue">
									<div class="row mx-0">
										<div class="oval-big-blue ml-sm-2"></div>
										<div class="ongoing ml-sm-3">Scheduled</div>
									</div>
								</button>
							</h1>
						</div>
						<div class="col-md-4">
							<h1>
								<button class="label-info-red">
									<div class="row mx-0">
										<div class="oval-big-red ml-sm-2"></div>
										<div class="ongoing ml-sm-3">Completed</div>
									</div>
								</button>
							</h1>
						</div>

					</div>
				</div>


			</div>
		</div>
		<!--/row-->
		<div class="container">

			<div id="carouselExampleControls" class="carousel slide"
				data-ride="carousel">
				<div class="carousel-inner">


					<%
						for (int i = 0; i < 15; i++) {
							String temp = "";
							if (i == 0) {
								temp = "active";
							} else {
								temp = "";
							}
					%>

					<%
						if (i % 3 == 0) {
					%>
					<div class="carousel-item <%=temp%>">
						<div class="row">
							<%
								}
							%>
							<div class="col-md-4">
								<div class="card card-w370-h240">
									<div class="card-body">
										<div class="top-right-label-semi-circle-green p-3">
											<img src="/assets/images/icons_8_video_call2.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x"
												class="float-right">
											<!-- for schedule use img 
											/assets/images/completed_shape2.png
											-->
										</div>
										<div class="row custom-no-margins">
											<img src="/assets/images/icons_8_clock2.png"
												srcset="/assets/images/icons_8_clock2.png 2x, /assets/images/icons_8_clock3.png 3x"
												class="icons8-clock">
											<h1 class="am-hrs custom-no-margins">8 AM</h1>
											<img src="/assets/images/icons_8_empty_hourglass2.png"
												srcset="/assets/images/icons_8_empty_hourglass2.png 2x, /assets/images/icons_8_empty_hourglass3.png 3x"
												class="icons8-empty_hourglass">
											<h1 class="am-hrs custom-no-margins">8 Hrs</h1>
										</div>
										<div class="row mt-sm-3">
											<div class="col-md-3">
												<img alt="image" class="img-thumbnail-small"
													src="http://cdn.talentify.in:9999/course_images/m_106.png">
											</div>
											<div class="col-md-9 pl-0">
												<div class="custom-trainer-card-title m-0">Retail
													Banking</div>
												<div class="custom-trainer-card-header">Operation of
													Banks - 2</div>
												<div class="row m-0">
													<div class="custom-trainer-card-info">FY BCom .
														Section 1</div>
													<div class="mr-md-3">
														<span class="oval-small"></span>
													</div>
													<div class="custom-trainer-card-info">Miriam Thomas</div>
												</div>
											</div>
										</div>
										<hr class="my-3">
										<div class="row">
											<div class="col-md-3 pr-3">
												<div class="trainer-dash-attendance-head">
													Attendance
													<p class="trainer-dash-attendance-value">68%</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Attendance
													<p class="trainer-dash-attendance-value">68%</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Student
													<p class="stars">
														<i class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star-o"></i><i
															class="trainer-dash-star fa fa-star-o"></i>
													</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Trainer
													<p class="stars">
														<i class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star-o"></i><i
															class="trainer-dash-star fa fa-star-o"></i>
													</p>
												</div>
											</div>
										</div>
										<hr class="my-3">
										<p class="trainer-dash-note">
											<i class="fa fa-flag yellow-flag" aria-hidden="true"></i>
											Classes started 10 min late
										</p>
										<p class="trainer-dash-note">
											<i class="fa fa-flag red-flag" aria-hidden="true"></i>
											Teaching was slow
										</p>
									</div>
								</div>
							</div>



							<%
								if (i % 3 == 2) {
							%>
						</div>
					</div>
					<%}} %>
				</div>
				<a class="carousel-control-next custom-right-prev-trainer"
					href="#carouselExampleControls" role="button" data-slide="next">
					<img class="" src="/assets/images/992180-200-copy.png" alt="">
				</a> <a class="carousel-control-prev custom-left-prev-trainer"
					href="#carouselExampleControls" role="button" data-slide="prev">
					<img class="" src="/assets/images/992180-2001-copy.png" alt="">
				</a>
			</div>

		</div>
		<div class="container">
		<h1 class="mt-lg-5">Performance Metrics</h1>
		</div>
		<div class="container">
			<div class="row">
				<div class="col-md-6"></div>
				<div class="col-md-6"></div>
			</div>
		</div>
	</div>
	<!--/row-->
		
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
	$(document).ready(function() {      
		   $('.carousel').carousel('pause');
		});
</script>
</body>
</html>