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