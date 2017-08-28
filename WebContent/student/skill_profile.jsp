<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>

<body id="student_skill_profile">
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
			<div class="row ">
				<div class="card custom-skill-profile-card justify-content-md-center">
					<div class="card-block">
					<div class="row justify-content-md-center">
						<div class="col-md-4 col-md-auto text-center">
							<h1 class='custom-skill-profile-batch-raking'>#3</h1>
							<h3 class="text-muted custom-skill-profile-batch-raking-title">Batch Rank</h3>
						</div>
						<div class="col-md-3 col-md-auto text-center">
							<img class='img-circle custom-skill-profile-img' src='http://cdn.talentify.in:9999//course_images/6.png' alt='No Image Available'>
							<h1 class='custom-skill-profile-name'>Chaitanya Alluru</h1>
						</div>
						<div class="col-md-4 col-md-auto text-center">
							<h1 class='custom-skill-profile-batch-raking'>5105</h1>
							<h3 class="text-muted custom-skill-profile-batch-raking-title">XP Earned</h3>
						</div>
						</div>
					</div>
				</div>
			</div>
		</div>



		<div class="container">
			<div class="row">

				<h1>Badges</h1>


			</div>
		</div>

		<div class="container"></div>


	</div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
		});
	</script>
</body>
</html>