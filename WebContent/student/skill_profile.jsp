<%@page import="com.viksitpro.user.service.UserSkillProfile"%>
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
		UserSkillProfile userskillprofile = new UserSkillProfile();
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">

		<div class="container">
			<div class="row ">
				<div
					class="card custom-skill-profile-card justify-content-md-center mt-lg-5">
					<div class="card-block">
						<div class="row justify-content-md-center">
							<div class="col-4 col-md-auto text-center m-5">
								<h1 class='custom-skill-profile-batch-raking'>
									#
									<%=cp.getStudentProfile().getBatchRank()%></h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">Batch
									Rank</h3>
							</div>
							<div class="col-3 col-md-auto text-center m-5">
								<img class='img-circle custom-skill-profile-img'
									src='<%=cp.getStudentProfile().getProfileImage()%>'
									alt='No Image Available'>
								<h1 class='custom-skill-profile-name'><%=cp.getStudentProfile().getFirstName()%></h1>
							</div>
							<div class="col-4 col-md-auto text-center m-5">
								<h1 class='custom-skill-profile-batch-raking'><%=cp.getStudentProfile().getExperiencePoints()%></h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">XP
									Earned</h3>
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

		<div class="container">

			<div class="row ">
				<div class="card custom-skill-badges-card justify-content-md-center">
					<div class="card-block">
						<div class="row custom-no-margins">


							<div id="carouselExampleControls" style="width: 100%;"
								class="carousel slide" data-ride="carousel"
								data-interval="false">
								<div class="carousel-inner" role="listbox">
									<%=userskillprofile.StudentRoles(cp)%>

								</div>
								<a style="width: 3%" class="carousel-control-prev"
									href="#carouselExampleControls" role="button" data-slide="prev">
									<span style="background: gray no-repeat center center"
									class="carousel-control-prev-icon" aria-hidden="true"></span> <span
									class="sr-only">Previous</span>
								</a> <a style="width: 3%" class="carousel-control-next"
									href="#carouselExampleControls" role="button" data-slide="next">
									<span style="background: gray no-repeat center center"
									class="carousel-control-next-icon" aria-hidden="true"></span> <span
									class="sr-only">Next</span>
								</a>
							</div>


						</div>
					</div>
				</div>
			</div>


		</div>
		
		<div class="container">
			<div class="row">

				<h1>Skills</h1>


			</div>
		</div>
		
		
		<div class="container">

			<div class="row ">
			  <div class="col-4 pl-0">
			  <nav class="nav flex-column">
  <a class="nav-link skill_list skill_list_active active pt-0 pb-0 pl-0" href="#">
  <div class="card custom-skill-list-active justify-content-md-center">
  <div class="card-block">
   <div class="row custom-no-margins">
			  <div class="col-4">
			  <img class='img-circle custom-skill-tree-img' src='http://cdn.talentify.in:9999//course_images/6.png' alt='No Image Available'>
			  </div>
			  <div class="col-8" style="margin: auto;">
			  <h3  class='custom-skill-tree-title' >Java Script wizard</h3>
			  </div>
			  
			  </div>
  </div>
</div>
  
  </a>
  <a class="nav-link skill_list  disabled pt-0 pb-0 pl-0" href="#">
   <div class="card justify-content-md-center custom-skill-list-disabled" >
  <div class="card-block">
     <div class="row custom-no-margins">
			  <div class="col-4">
			  <img class='img-circle custom-skill-tree-img' src='http://cdn.talentify.in:9999//course_images/6.png' alt='No Image Available'>
			  </div>
			  <div class="col-8" style="margin: auto;">
			  <h3  class='custom-skill-tree-title' >Java Script wizard</h3>
			  </div>
			  
			  </div>
  </div>
</div>
  </a>
</nav>
			  
			  </div>
			
			 <div class="col-8">
			 <div class="card custom-skill-tree">
			 <div class="card-block">
			 
			 </div>
			 </div>
			 </div>
			</div>


		</div>


	</div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			
			$('.skill_list').click(function(){
				$('.skill_list').removeClass('skill_list_active');
				$('.skill_list').children().removeClass('custom-skill-list-active').addClass('custom-skill-list-disabled');
				$(this).addClass('skill_list_active');
				$(this).children().removeClass('custom-skill-list-disabled');
				$(this).children().addClass('custom-skill-list-active');
				
			});
			
		});
	</script>
</body>
</html>