<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="student_role">
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
		StudentRolesService studentrolesservice = new StudentRolesService();
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row">
				<h1>Course List</h1>
			</div>
		</div>
		<div class="container">
			<div class="row custom-margin-rolescard" id="courseCards">

				<a href='./editCourse.jsp'>
					<div class="card-deck">
						<div class="custom-roles-cards-450">
							<img class="img-rounded custom-roles-img"
								src="http://cdn.talentify.in:9999/course_images/plusIcon.png"
								alt="No Image Available" style="background-color: white;">
							<div class="card-block">
								<!-- <h4 class=" custom-roles-subtitle">Create Course</h4> -->
								<h1 class="card-title custom-roles-titletext">Create Course</h1>
								<!-- <h4 class="custom-roles-progress">10 Modules . 10 Session .
									10 Lessons</h4> -->
							</div>
						</div>
					</div>
				</a>

			</div>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			var url = '../tfy_content_rest/course/getAll';
			$.get(url, function(data) {
				$(data.courses).each(function(key, value) {
					addCourseCard(value);
				});
			});
		});

		function addCourseCard(course) {
			var addition = '';
			addition += '<a href="./editCourse.jsp?course=' + course.id + '">';
			addition += '<div class="card-deck">';
			addition += '<div class="custom-roles-cards-450">';
			addition += '<img class="img-rounded custom-roles-img" src="'+course.imageURL+'" alt="No Image Available">';
			addition += '<div class="card-block">';
			addition += '<h4 class=" custom-roles-subtitle">' + course.category
					+ '</h4>';
			addition += '<h1 class="card-title custom-roles-titletext">'
					+ course.title + '</h1>';
			addition += '<h4 class="custom-roles-progress">'
					+ course.moduleCount + ' Modules . ' + course.sessionCount
					+ ' Session . ' + course.lessonCount + ' Lessons</h4>';
			addition += '</div></div></div>';
			$('#courseCards').append(addition);
		}
	</script>
</body>
</html>