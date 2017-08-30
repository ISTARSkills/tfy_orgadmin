<%@page import="com.viksitpro.user.service.UserSkillProfile"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>


<style>
.jstree-open .jstree-icon.jstree-ocl {
	background: url(/assets/images/expanded.png) 0px 0px no-repeat
		!important;
}
</style>

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
				<div class="card custom-skill-profile-card justify-content-md-center mt-lg-5">
					<div class="card-block">
						<div class="row justify-content-md-center">
							<div class="col-4 col-md-auto text-center m-5">
								<h1 class='custom-skill-profile-batch-raking'>
									#
									<%=cp.getStudentProfile().getBatchRank()%></h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">Batch Rank</h3>
							</div>
							<div class="col-3 col-md-auto text-center m-5">
								<img class='img-circle custom-skill-profile-img' src='<%=cp.getStudentProfile().getProfileImage()%>' alt='No Image Available'>
								<div class="img-circle" style="width: 40.8px; height: 40.8px; background-color: #eb384f; bottom: 70px; right: 12px; position: absolute;">
									<img class='img-circle mt-3' style="width: 23px; height: 23px; object-fit: contain;" src='/assets/images/group-5.png' alt='No Image Available'>
								</div>
								<h1 class='custom-skill-profile-name'><%=cp.getStudentProfile().getFirstName()%></h1>
							</div>
							<div class="col-4 col-md-auto text-center m-5">
								<h1 class='custom-skill-profile-batch-raking'><%=cp.getStudentProfile().getExperiencePoints()%></h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">XP Earned</h3>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>



		<%-- <div class="container">
			<div class="row">

				<h1>Badges</h1>


			</div>
		</div>

		<div class="container">

			<div class="row ">
				<div class="card custom-skill-badges-card justify-content-md-center">
					<div class="card-block">
						<div class="row custom-no-margins">


							<div id="carouselExampleControls" class="carousel slide  w-100" data-ride="carousel" data-interval="false">
								<div class="carousel-inner" role="listbox">
									<%=userskillprofile.StudentRoles(cp)%>

								</div>
								<a class="carousel-control-prev custom-arrows-width" href="#carouselExampleControls" role="button" data-slide="prev"> <img class="custom-skillprofile-arrow-img" src="/assets/images/992180-2001-copy.png" alt="">
								</a> <a class="carousel-control-next custom-arrows-width" href="#carouselExampleControls" role="button" data-slide="next"><img class="custom-skillprofile-arrow-img" src="/assets/images/992180-200-copy.png" alt=""> </a>
							</div>


						</div>
					</div>
				</div>
			</div>


		</div> --%>

		<div class="container">
			<div class="row">

				<h1>Skills</h1>


			</div>
		</div>


		<div class="container">

			<div class="row ">
				<div class="col-3 pl-0">
					<nav class="nav flex-column">

						<%=userskillprofile.getSkillList(cp)%>
					
					</nav>

				</div>
				<div class="col-9">
					<div class="card custom-skill-tree ml-5">
						<div class="card-block" id='skillTreeHolder'>
							


							<div class="container mt-5">
								<div class="row">
									<div class="col-12">
										<ul id="tree1">

											<li>Risk Management 1 <small class='custom-skillprofile-subskills'>3 subskills</small> <small class='custom-skillprofile-xp_points'>250/500 XP</small>
												<div class="progress ml-5">
													<div class="progress-bar custom-skillprofile-skill-progress" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
												</div>
												<ul>
													<li>Company Maintenance
														<div class="progress ml-5">
															<div class="progress-bar custom-skillprofile-skill-progress" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
														</div>
													</li>
													<li>Company Maintenance
														<div class="progress ml-5">
															<div class="progress-bar custom-skillprofile-skill-progress" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
														</div>
													</li>

												</ul>
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


	</div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document)
				.ready(
						function() {

							$('.skill_list').click(function() {
												$('.skill_list').removeClass('skill_list_active');
												$('.skill_list').addClass('skill_list_disable');
												$('.skill_list').children().removeClass('custom-skill-list-active').addClass('custom-skill-list-disabled');
												$(this).removeClass('skill_list_disable');
												$(this).addClass('skill_list_active');
												$(this).children().removeClass('custom-skill-list-disabled');
												$(this).children().addClass('custom-skill-list-active');
												
												

											

											});

							$.fn.extend({
										treed : function(o) {

											var openedClass = 'glyphicon-minus-sign';
											var closedClass = 'glyphicon-plus-sign';

											if (typeof o != 'undefined') {
												if (typeof o.openedClass != 'undefined') {
													openedClass = o.openedClass;
												}
												if (typeof o.closedClass != 'undefined') {
													closedClass = o.closedClass;
												}
											}
											;

											//initialize each of the top levels
											var tree = $(this);
											tree.addClass("tree");
											tree
													.find('li')
													.has("ul")
													.each(
															function() {
																var branch = $(this); //li with children ul
																branch
																		.prepend("<i class='indicator glyphicon " + closedClass + "'></i>");
																branch
																		.addClass('branch');
																branch
																		.on(
																				'click',
																				function(
																						e) {
																					if (this == e.target) {
																						var icon = $(
																								this)
																								.children(
																										'i:first');
																						icon
																								.toggleClass(openedClass
																										+ " "
																										+ closedClass);
																						$(
																								this)
																								.children()
																								.children()
																								.toggle();
																					}
																				})
																branch
																		.children()
																		.children()
																		.toggle();
															});
											//fire event from the dynamically added icon
											tree
													.find('.branch .indicator')
													.each(
															function() {
																$(this)
																		.on(
																				'click',
																				function() {
																					$(
																							this)
																							.closest(
																									'li')
																							.click();
																				});
															});
											//fire event to open branch if the li contains an anchor instead of text
											tree
													.find('.branch>a')
													.each(
															function() {
																$(this)
																		.on(
																				'click',
																				function(
																						e) {
																					$(
																							this)
																							.closest(
																									'li')
																							.click();
																					e
																							.preventDefault();
																				});
															});
											//fire event to open branch if the li contains a button instead of text
											tree
													.find('.branch>button')
													.each(
															function() {
																$(this)
																		.on(
																				'click',
																				function(
																						e) {
																					$(
																							this)
																							.closest(
																									'li')
																							.click();
																					e
																							.preventDefault();
																				});
															});
										}
									});

							//Initialization of treeviews

							$('#tree1').treed();

						});
	</script>
</body>
</html>