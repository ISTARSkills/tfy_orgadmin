
<jsp:include page="/inc/head.jsp"></jsp:include>



<body id="student_skill_profile" ng-app="student_skill_profile"
	ng-controller="student_skill_profileCtrl">
	<%
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
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
								<h1 class='custom-skill-profile-batch-raking'>{{'#'+studentProfile.batchRank
									}}</h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">Batch
									Rank</h3>
							</div>
							<div class="col-3 col-md-auto text-center m-5">
								<div class='row mx-auto text-center'>
									<img class='img-circle custom-skill-profile-img mx-auto'
										src='{{studentProfile.profileImage}}'
										alt='{{studentProfile.firstName}}'>
									<div id='skill_profile_uploadicon'
										class="img-circle custom-skillprofile-uploadicon">
										<form method="POST" enctype="multipart/form-data"
											id="fileUploadForm">



											<button id="btnfile" class='p-0 m-0 border-0'
												style='background: transparent;'>
												<img class='img-circle mt-3 custom-skillprofile-icontag'
													src='/assets/images/group-5.png'
													alt='{{studentProfile.firstName}}'>
											</button>
											<div class="wrapper" style='display: none !important;'>
												<input id="uploadfile" type="file" name="files"
													accept="image/x-png,image/jpg,image/jpeg" /> <input
													name='user_id' type="hidden" value="{{studentProfile.id}}" />
											</div>



										</form>
									</div>
								</div>
								<div class='row'>
									<h1 class='custom-skill-profile-name mx-auto'>{{studentProfile.firstName
										!= '' && studentProfile.firstName+' '+ studentProfile.lastName
										|| studentProfile.email}}</h1>


								</div>
							</div>
							<div class="col-4 col-md-auto text-center m-5">
								<h1 class='custom-skill-profile-batch-raking'>{{studentProfile.experiencePoints}}</h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">XP
									Earned</h3>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div ng-if='(courses!=undefined && courses.length!=0)'
			class="container">
			<div class="row">
				<h1 class='custom-dashboard-header'>Skills</h1>
			</div>
		</div>

		<div ng-if='(courses==undefined || courses.length==0)'
			class="container">
			<div class="row w-100">
				<div
					class='card custom-skill-profile-card justify-content-md-center mt-lg-5'>
					<h1 class='custom-dashboard-header w-100 text-center'>No
						Skills Are Associated.</h1>
				</div>
			</div>
		</div>

		<div ng-if='(courses!=undefined && courses.length!=0)'
			class="container">
			<div class="row ">
				<div class="col-3 pl-0">
					<nav class="nav flex-column" ng-init="skills_highlighter = 0">

						<div class='nav-link skill_list  pt-0 pb-0 pl-0 '
							ng-click="skillFunction($index)"
							ng-class="($index ==skills_highlighter ? 'skill_list_active active' : 'skill_list_disable disabled')"
							data-courseId='{{course.id}}'
							ng-repeat="course in courses track by $index">
							<div class='card justify-content-md-center'
								ng-class="($index==skills_highlighter ? 'custom-skill-list-active' : 'custom-skill-list-disabled') ">
								<div class='card-block'>
									<div class='row custom-no-margins'>
										<div class='col-4'>
											<img class='custom-skill-tree-img' src='{{course.imageURL}}'
												alt='No Image Available'>
										</div>
										<div class='col-8 my-auto'>
											<h3 class='custom-skill-tree-title'>{{course.name}}</h3>
										</div>
									</div>
								</div>
							</div>
						</div>

					</nav>

				</div>
				<div class="col-9">
					<div class="card custom-skill-tree ml-5 custom-scroll-holder">
						<div class="card-block" id='skillTreeHolder'>
							<div class='container mt-5'>
								<div class='row'>
									<div class='col-12'>
										<ul id='tree1'>

											<li student-skill-setup ng-repeat="top_skill in skills">{{top_skill.name}}
												<small class='custom-skillprofile-subskills'>{{top_skill.length}}
													subskills</small> <small class='custom-skillprofile-xp_points'>
													{{top_skill.userPoints}} / {{top_skill.totalPoints}} XP</small><i
												class='point-div'></i>


												<div class='progress ml-5'>
													<div
														class='progress-bar custom-skillprofile-skill-progress'
														role='progressbar'
														ng-style="{ 'width': {{top_skill.percentage}} + '%' }"
														aria-valuenow='{{top_skill.percentage}}' aria-valuemin='0'
														aria-valuemax='100'></div>
												</div>

												<ul>


													<li ng-repeat="sub_skill in top_skill.skills"
														style='padding-left: 30px; padding-top: 13px;'>{{sub_skill.name}}
														<div class='progress ml-5'>
															<div
																class='progress-bar custom-skillprofile-skill-progress'
																role='progressbar'
																ng-style="{ 'width': {{sub_skill.percentage}} + '%' }"
																aria-valuenow='{{sub_skill.percentage}}'
																aria-valuemin='0' aria-valuemax='100'></div>
														</div>
													</li>


												</ul>
												<hr>
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

</body>
</html>