<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>

<body id="student_begin_skill">
	<%
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";

		int course_id = 0;
		if (request.getParameter("course_id") != null) {
			course_id = Integer.parseInt(request.getParameter("course_id"));
		}

		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());
		if (cp == null) {
			flag = true;
			request.setAttribute("msg", "User Does Not Have Permission To Access");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
		request.setAttribute("cp", cp);

		/* Course course = new Course();
		course = new CourseDAO().findById(course_id); */
		UserSkillProfile userskillprofile =new UserSkillProfile();
		String courseName = "";
		String courseImg = "";
		int userCourseRank = 0;
		Double userCourseProgress = .0;
		Double userTotalPoints = .0;
		Double userUserPoints = .0;
		for (CoursePOJO student_course : cp.getCourses()) {

			if (student_course.getId() == course_id) {

				userCourseRank = student_course.getRank();
				userCourseProgress = student_course.getProgress();
				userUserPoints = student_course.getUserPoints();
				userTotalPoints = student_course.getTotalPoints();
				courseName = student_course.getName();
				courseImg = student_course.getImageURL();
				

			}

		}
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row justify-content-md-center custom-no-margins">
				<div class='col-6 custom-no-padding'>
					<div class="row ml-0">
						<a class='col-2 my-auto custom-no-padding'
							href="<%=baseURL%>student/roles.jsp"> <img
							class="custom-beginskill-backarrow"
							src="/assets/images/1165040-200.png" alt="">
						</a>
						<div class='col-10 custom-no-padding'>
							<h1 class='custom-beginskill-course-heading'><%=courseName%></h1>
						</div>
					</div>
				</div>
				<div class='col-6 custom-no-padding'>
					<div class="row ml-0">
						<div class='col-4 my-auto custom-no-padding text-center'>
							<h1 class='custom-beginskill-xp'><%= Math.round(userUserPoints)%>
								XP
							</h1>
							<small class="text-muted custom-beginskill-xp-title">of <%=userTotalPoints%>
								XP earned
							</small>
						</div>
						<div class='col-4 my-auto custom-no-padding text-center'>
							<h1 class='custom-beginskill-progress'><%=userCourseProgress%>%
							</h1>
							<small class="text-muted custom-beginskill-progess-title">Progress</small>
						</div>
						<div class='col-4 my-auto custom-no-padding text-center'>
							<h1 class='custom-beginskill-rank'><%=userCourseRank%>th
							</h1>
							<small class="text-muted custom-beginskill-rank-title">Rank</small>
						</div>
					</div>
				</div>

			</div>
		</div>
		<!--/row-->
		<div class="container">
		
		<%=userskillprofile.StudentModuleList(cp,course_id) %>

			<!-- <div id="accordion1" role="tablist" aria-multiselectable="true">
				<div class="card custom-card-height-expand">
					<div class="card-header custom-module_card-header" role="tab"
						id="headingOne">
						<div class="row justify-content-md-center mt-3">
							<div class='col-2 my-auto custom-no-padding text-center'>
								<img class='img-circle custom-beginskill-module-img'
									src='http://cdn.talentify.in:9999//course_images/6.png'
									alt='No Image Available'>
							</div>
							<div class='col-8 my-auto custom-no-padding text-center'>
								<div class="row">
									<h1 class='custom-beginskill-module-title'>Introduction to
										Risk</h1>
								</div>
								<div class="row ">
									<span
										class="badge badge-pill badge-default custom-beginskill-badge text-center mr-2">Default</span>
									<span
										class="badge badge-pill badge-default custom-beginskill-badge text-center ">Default</span>
								</div>
							</div>
							<div class='col-2 my-auto custom-no-padding text-center'>
								<a data-toggle="collapse" data-parent="#accordion1" href="#collapse1" aria-expanded="true" aria-controls="collapse1">
								<img class='img-circle custom-beginskill-collapsed-img' src='/assets/images/collapsed.png' alt='No Image Available'></a>
							</div>
						</div>
					</div>

					<div id="collapse1" class="collapse show" role="tabpanel"
						aria-labelledby="headingOne">

						<div id="carouselExampleControls" class="carousel slide"
							data-interval="false" data-ride="carousel">
							<div class="carousel-inner" role="listbox">
								<div class="carousel-item active">
									<div class="card-block">
										<div class="row custom-beginskill-row">
											<div class='col-4 my-auto custom-no-padding'>
												<div
													class="card custom-beginskill-lesson-cards-background-left">
													<div class="card-block">
													<h1 class="card-title custom-task-title mt-5">Direct Tax Skill Work shop Direct Tax</h1>
														<h1 class=" ml-2 mr-2">71%</h1>
														<h2>Accuracy</h2>
														<p class=' dont-stop-There-is'>Don't stop! There is still room to grow.</p>
													
													</div>
													<div class='custom-beginskill-leftbutton'>
														<button type="button" class="btn btn-danger custom-beginskill-button">Improve Score</button>
													</div>
												</div>
											</div>
											<div class='col-4 my-auto custom-no-padding text-center'>
												<div
													class="card mb-5 mt-5 custom-beginskill-lesson-cards-forground">
													<div class="card-block ">
														<div class="progress">
															<div class="progress-bar" role="progressbar"
																style="width: 25%" aria-valuenow="25" aria-valuemin="0"
																aria-valuemax="100"></div>
														</div>
														<h1 class="card-title custom-task-title mt-5 text-center">Direct Tax Skill Work shop Direct Tax</h1>
														<p class="card-text custom-task-desc ml-2 mr-2">A brief
															introduction to the various channels of banking
															operations</p>
														<h2 class='take-a-shortcut'>TAKE A SHORTCUT</h2>
													</div>
													<div class='custom-beginskill-forgroundbutton'>
														<button type="button"
															class="btn btn-danger custom-beginskill-button">Begin
															Skill</button>
													</div>
												</div>
											</div>
											<div class='col-4 my-auto custom-no-padding'>
												<div
													class="card custom-beginskill-lesson-cards-background-right">
													<div class="card-block text-right">
													<h1 class="card-title custom-task-title mt-5">Direct Tax Skill Work shop Direct Tax</h1>
														<h1 class=" ml-2 mr-2">71%</h1>
														<h2>Accuracy</h2>
														<p class=' dont-stop-There-is'>Don't stop! There is still room to grow.</p>
													
													</div>
													<div class='custom-beginskill-rightbutton'>
														<button type="button" class="btn btn-danger custom-beginskill-button">Improve Score</button>
													</div>
												</div>
											</div>

										</div>
									</div>

								</div>
								
								
							</div>
							<a class="carousel-control-next custom-right-prev"
								href="#carouselExampleControls" role="button" data-slide="next">
								<img class="" src="/assets/images/992180-200-copy.png" alt="">
							</a> <a class="carousel-control-prev custom-left-prev"
								href="#carouselExampleControls" role="button" data-slide="prev">
								<img class="" src="/assets/images/992180-2001-copy.png" alt="">
							</a>
						</div>






					</div>
				</div>
			</div> -->
		</div>
	</div>
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			$('.collapse').collapse();
			$('.custom-beginskill-collapsed-img').click(function() {

				if ($(this).attr("src") == '/assets/images/expanded.png') {

					$(this).attr("src", "/assets/images/collapsed.png");
					

				} else {
					$(this).attr("src", "/assets/images/expanded.png");
					
				}

			});
		});
	</script>
</body>
</html>