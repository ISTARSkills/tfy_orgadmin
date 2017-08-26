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
			<div class="row custom-margin-rolescard">
				<% for(int i=0; i< 40; i++) { %>
				<a href='./edit_course.jsp'>
				<div class="card-deck">
					<div class="custom-roles-cards-450">
						<img class="img-rounded custom-roles-img" src="http://cdn.talentify.in:9999//course_images/6.png" alt="No Image Available">
						<div class="card-block">
							<h4 class=" custom-roles-subtitle">Taxation</h4>
							<h1 class="card-title custom-roles-titletext">Direct Tax Skill Workshop</h1>
							<h4 class="custom-roles-progress">10 Modules . 10 Session . 10 Lessons</h4>
						
						</div>
						
					</div>
					
				</div>
				</a>
				<% } %>
			</div>
			
		</div>


	</div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
		});
	</script>
</body>
</html>