<jsp:include page="/inc/head.jsp"></jsp:include>
<body ng-cloak id="student_begin_skill" ng-app="student_begin_skill"
	ng-controller="student_begin_skillCtrl">

	<!-- 	<page-loader flag="isLoading" bg-color='whitesmoke'>
	<div class="pacman"></div>
	<div class="dot"></div>
	<div class="sk-folding-cube text-center" ng-if='isLoading'>
		<div class="sk-cube1 sk-cube"></div>
		<div class="sk-cube2 sk-cube"></div>
		<div class="sk-cube4 sk-cube"></div>
		<div class="sk-cube3 sk-cube"></div>
	</div>
	</page-loader>
 -->
	<%
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
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
							<h1 class='custom-beginskill-course-heading'>{{course.name}}</h1>
						</div>
					</div>
				</div>
				<div class='col-6 custom-no-padding'>
					<div class="row ml-0">
						<div class='col-4 my-auto custom-no-padding text-center'>
							<h1 class='custom-beginskill-xp'>{{roundNumber(course.userPoints)}}
								XP</h1>
							<small class="text-muted custom-beginskill-xp-title">of
								{{course.totalPoints}} XP earned </small>
						</div>
						<div class='col-4 my-auto custom-no-padding text-center'>
							<h1 class='custom-beginskill-progress'>{{course.progress}}%
							</h1>
							<small class="text-muted custom-beginskill-progess-title">Progress</small>
						</div>
						<div class='col-4 my-auto custom-no-padding text-center'>
							<h1 class='custom-beginskill-rank'>{{course.rank}}th</h1>
							<small class="text-muted custom-beginskill-rank-title">Rank</small>
						</div>
					</div>
				</div>

			</div>
		</div>
		<!--/row-->
		<div class="container">
			<div id='accordion{{$index}}' student-begin-skill-setup
				ng-repeat='module in course.modules' ng-init="outerIndex=$index"
				role='tablist' aria-multiselectable='true'>
				<div class='card custom-card-height-expand'>
					<div class='card-header custom-module_card-header' role='tab'
						id='heading{{outerIndex}}'>
						<div class='row justify-content-md-center mt-3'>
							<div class='col-2 my-auto custom-no-padding text-center'>
								<img class=' custom-beginskill-module-img'
									src='{{module.imageURL}}' alt='No Image Available'>
							</div>
							<div class='col-8 my-auto custom-no-padding text-center'>
								<div class='row'>
									<h1 class='custom-beginskill-module-title'>{{module.name}}</h1>
								</div>
								<div class='row '>

									<span ng-if='module.skillObjectives!=0'
										ng-repeat='skillobj in module.skillObjectives'
										class='badge badge-pill badge-default custom-beginskill-badge text-center mr-2 mb-2'>{{skillobj}}</span>

								</div>

							</div>

							<div class='col-2 my-auto custom-no-padding text-center'>
								<a data-toggle='collapse' data-parent='#accordion{{outerIndex}}'
									href='#collapse{{outerIndex}}' aria-expanded='true'
									aria-controls='collapse{{outerIndex}}'><img
									class='img-circle custom-beginskill-collapsed-img'
									src='/assets/images/collapsed.png' alt='No Image Available'></a>
							</div>
						</div>
					</div>

					<div id='collapse{{outerIndex}}' class='collapse show'
						role='tabpanel' aria-labelledby='heading{{outerIndex}}'>

						<div id='carouselExampleControls{{outerIndex}}'
							class='carousel slide' data-interval='false' data-ride='carousel'>
							<div class='carousel-inner' role='listbox'>

								<div ng-if='module.sessions.length==1'
									class='carousel-item active'>
									<div class='card-block'>
										<div class='row custom-beginskill-row'>

											<div class='col-4 my-auto custom-no-padding'></div>

											<div class='col-4 my-auto custom-no-padding'>

												<div
													class='card mb-5 mt-5 custom-beginskill-lesson-cards-forground'>
													<div class='progress'>
														<div class='progress-bar' role='progressbar'
															style='width: {{module.sessions[0].progress'
															aria-valuenow='{{module.sessions[0].progress}}'
															aria-valuemin='0' aria-valuemax='100'></div>
													</div>
													<img ng-if='checkIsCompleted(module.sessions[pos])'
														class='student-beginskill-banner'
														src="./assets/images/checked_banner.png" />
													<div class='card-block text-center my-auto'>

														<h1
															class='card-title custom-task-title mx-auto text-center'>{{module.sessions[0].name}}</h1>
														<p class='card-text custom-task-desc ml-4 mr-4'>{{module.sessions[0].description}}</p>
														<h2 class='take-a-shortcut'></h2>
													</div>
													<div class='custom-beginskill-forgroundbutton'>
														<a
															href='/student/presentation.jsp?lesson_id={{module.sessions[0].lessons[0].id}}&cmsession_id={{module.sessions[0].id}}&module_id={{module.id}}&course_id={{course_id}}'
															data-cmsId='1'
															class='btn btn-danger custom-beginskill-button'><span
															class='custom-begin-skill'>Begin Skill</span></a>
													</div>
												</div>


											</div>
											<div class='col-4 my-auto custom-no-padding'></div>
										</div>
									</div>
								</div>



								<div
									ng-if='module.sessions.length!=1 && module.sessions.length!=0'
									ng-repeat='sessionObj in module.sessions' class='carousel-item'
									ng-class='(innerIndex==0?"active":"")'>
									<div class='card-block' ng-init='innerIndex=$index'>
										<div class='row custom-beginskill-row'>
											<div ng-repeat='j in iteration'
												class='col-4 my-auto custom-no-padding'>

												<!-- cards starts -->
												<div ng-if='(innerIndex==0) && j==0'
													class='card custom-beginskill-lesson-cards-background-left'>
													<img ng-if='checkIsCompleted(module.sessions[pos])'
														class='student-beginskill-banner-disabled'
														src="./assets/images/checked_banner.png" />
													<div class='card-block my-auto text-center'>
														{{pos=(module.sessions.length)-1;""}}
														<h1 class='card-title custom-task-title mt-5'>{{module.sessions[pos].name}}</h1>
														<h1 class='  custom-progress-color'>{{module.sessions[pos].progress}}%</h1>
														<h2>Accuracy</h2>
														<p class=' dont-stop-There-is'>{{module.sessions[pos].description}}</p>
													</div>
													<div class='custom-beginskill-leftbutton'>
														<button type='button'
															class='btn btn-danger custom-beginskill-button'>Improve
															Score</button>
													</div>
												</div>

												<div
													ng-else-if='j==2 && innerIndex== (module.sessions.length-1)'
													class='card custom-beginskill-lesson-cards-background-right'>
													{{pos=0;""}} <img
														ng-if='checkIsCompleted(module.sessions[pos])'
														class='student-beginskill-banner-disabled'
														src="./assets/images/checked_banner.png" />
													<div class='card-block my-auto text-center'>
														<h1 class='card-title custom-task-title mt-5'>{{module.sessions[pos].name}}</h1>
														<h1 class=' custom-progress-color'>{{module.sessions[pos].progress}}%</h1>
														<h2>Accuracy</h2>
														<p class=' dont-stop-There-is'>{{module.sessions[pos].description}}</p>
													</div>
													<div class='custom-beginskill-rightbutton'>
														<button type='button'
															class='btn btn-danger custom-beginskill-button'>Improve
															Score</button>
													</div>
												</div>

												<div ng-else-if='j==0'
													class='card custom-beginskill-lesson-cards-background-left'>
													{{pos=(innerIndex-1);""}} <img
														ng-if='checkIsCompleted(module.sessions[pos])'
														class='student-beginskill-banner-disabled'
														src="./assets/images/checked_banner.png" />
													<div class='card-block my-auto text-center'>
														<h1 class='card-title custom-task-title mt-5'>{{module.sessions[pos].name}}</h1>
														<h1 class='  custom-progress-color'>{{module.sessions[pos].progress}}%</h1>
														<h2>Accuracy</h2>
														<p class=' dont-stop-There-is'>{{module.sessions[pos].description}}</p>
													</div>
													<div class='custom-beginskill-leftbutton'>
														<button type='button'
															class='btn btn-danger custom-beginskill-button'>Improve
															Score</button>
													</div>
												</div>


												<div ng-else-if='j==1'
													class='card mb-5 mt-5 custom-beginskill-lesson-cards-forground'>
													{{ pos=((innerIndex+j)-1);""}}
													<div class='progress'>
														<div class='progress-bar' role='progressbar'
															style='width: {{module.sessions[pos].progress'
															aria-valuenow='{{module.sessions[pos].progress}}'
															aria-valuemin='0' aria-valuemax='100'></div>
													</div>
													<img ng-if='checkIsCompleted(module.sessions[pos])'
														class='student-beginskill-banner'
														src="./assets/images/checked_banner.png" />

													<div class='card-block text-center my-auto'>
														<h1
															class='card-title custom-task-title mx-auto text-center'>{{module.sessions[pos].name}}</h1>
														<p class='card-text custom-task-desc ml-4 mr-4'>{{module.sessions[pos].description}}</p>
														<h2 class='take-a-shortcut'></h2>
													</div>
													<div class='custom-beginskill-forgroundbutton'>
														<a
															href='/student/presentation.jsp?lesson_id={{module.sessions[pos].lessons[0].id}}&cmsession_id={{module.sessions[pos].id}}&module_id={{module.id}}&course_id={{course_id}}'
															data-cmsId='1'
															class='btn btn-danger custom-beginskill-button'><span
															class='custom-begin-skill'>Begin Skill</span></a>
													</div>
												</div>

												<div ng-else-if='j==2'
													class='card custom-beginskill-lesson-cards-background-right'>
													{{pos=((innerIndex + j) -1);""}} <img
														ng-if='checkIsCompleted(module.sessions[pos])'
														class='student-beginskill-banner-disabled'
														src="./assets/images/checked_banner.png" />
													<div class='card-block my-auto text-center'>
														<h1 class='card-title custom-task-title mt-5'>{{module.sessions[pos].name}}</h1>
														<h1 class=' custom-progress-color'>{{module.sessions[pos].progress}}%</h1>
														<h2>Accuracy</h2>
														<p class=' dont-stop-There-is'>{{module.sessions[pos].description}}</p>
													</div>
													<div class='custom-beginskill-rightbutton'>
														<button type='button'
															class='btn btn-danger custom-beginskill-button'>Improve
															Score</button>
													</div>
												</div>


												<!-- cards ends -->
											</div>


										</div>
									</div>
								</div>


							</div>

							<a ng-if='module.sessions.length>1'
								class='carousel-control-next custom-right-prev'
								href='#carouselExampleControls{{outerIndex}}' role='button'
								data-slide='next'> <img class=''
								src='/assets/images/992180-200-copy.png' alt=''></a> <a
								ng-if='module.sessions.length>1'
								class='carousel-control-prev custom-left-prev'
								href='#carouselExampleControls{{outerIndex}}' role='button'
								data-slide='prev'> <img class=''
								src='/assets/images/992180-2001-copy.png' alt=''>
							</a>


						</div>
					</div>

				</div>
			</div>
		</div>

	</div>
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		/* 
			$(document).ready(function() {
				$('.collapse').collapse();
				$('.custom-beginskill-collapsed-img').click(function() {

					if ($(this).attr("src") == '/assets/images/expanded.png') {

						$(this).attr("src", "/assets/images/collapsed.png
						

					} else {
						$(this).attr("src", "/assets/images/expanded.png
						
					}

				});
			}); */
	</script>
</body>
</html>