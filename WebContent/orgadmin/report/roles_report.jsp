<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.talentify.admin.rest.pojo.AdminGroupThumb"%>
<%@page import="java.util.List"%>
<%@page import="com.talentify.admin.rest.pojo.AdminRole"%>
<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>


<jsp:include page="/inc/head.jsp"></jsp:include>

<body id='orgadmin_roles_report'>

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

		int orgId = (int) request.getSession().getAttribute("orgId");
		System.out.println(orgId);

		AdminRestClient adminClient = new AdminRestClient();
		ArrayList<AdminRole> roles = adminClient.getRolesReport(orgId);
	%>

	<jsp:include page="/inc/navbar.jsp"></jsp:include>



	<div class="jumbotron gray-bg">
		<div class="container">
			<ol class="nav breadcrumb  mt-lg-5 gray-bg">
				<li class="breadcrumb-item List"><a
					href="/orgadmin/report/roles_report.jsp" class="selected_report">Roles</a></li>
				<li class="breadcrumb-item List"><a
					href="/orgadmin/report/groups_report.jsp" class="unselected_report">Groups</a></li>
			</ol>
		</div>
		<%
			for (int i = 0; i < roles.size(); i++) {
				AdminRole adminRole = roles.get(i);
		%>
		<div class="container reprort-card-container ">


			<div class="card  report_card_role p-0">
				<div class="card-body p-0">
					<div class='row report-roles-card report-roles-card-click' data-courseID='<%=adminRole.getId()%>'>
						<div class="col-md-2">
							<img class='report-role-image'
								src='<%=adminRole.getImageUrl() != null
						? AppProperies.getProperty("media_url_path") + adminRole.getImageUrl()
						: ""%>'
								alt=''></img>
						</div>
						<div class="col-md-6">
							<h1 class='report-heading my-0'><%=adminRole.getName()%></h1>
							<p class="stars">


								<%
									if (adminRole.getAvgRating() != null && adminRole.getAvgRating() > 0) {
											int rating = (int) Math.ceil(adminRole.getAvgRating());
											for (int j = 0; j < rating; j++) {
								%><i class='dash-star-6x fa fa-star'></i>
								<%
									}
											if (rating < 5) {
												for (int j = rating; j < 5; j++) {
								%><i class='dash-star-6x fa fa-star-o'></i>
								<%
									}
											}
										} else {
								%><i class='dash-star-6x fa fa-star-o'></i><i
									class='dash-star-6x fa fa-star-o'></i><i
									class='dash-star-6x fa fa-star-o'></i><i
									class='dash-star-6x fa fa-star-o'></i><i
									class='dash-star-6x fa fa-star-o'></i>
								<%
									}
								%>
							</p>
							<div class='row' style='margin-top: 30px; margin-left: 5px;'>

								<div class='float-left'>
									<img src="/assets/images/report/icons-8-groups.png"
										srcset="/assets/images/report/icons-8-groups@2x.png 2x,/assets/images/report/icons-8-groups@3x.png 3x"
										class="icons8-groups" />
									<p class='report-roles-sub-text' style='width: 90px;'><span class='spannable'><%=adminRole.getGroups() != null && adminRole.getGroups().size() != 0? adminRole.getGroups().size(): 0%></span> Groups</p>
								</div>

								<div class='float-left'>
									<img src="/assets/images/report/icons-8-student.png"
										srcset="/assets/images/report/icons-8-student@2x.png 2x,/assets/images/report/icons-8-student@3x.png 3x"
										class="icons8-student" />
									<p class='report-roles-sub-text' style='width: 110px;'>
										<span class='spannable'><%=adminRole.getTotalStudents() != null ? adminRole.getTotalStudents() : 0%></span>
										Students
									</p>
								</div>

								<div class='float-left'>
									<img src="/assets/images/report/icons-8-report-card.png"
										srcset="/assets/images/report/icons-8-report-card@2x.png 2x,/assets/images/report/icons-8-report-card@3x.png 3x"
										class="icons8-report_card" />
									<p class='report-roles-sub-text' style='width: 140px;'>
										<span class='spannable'><%=adminRole.getAttendancePercentage() != null
						? (int) ((float) adminRole.getAttendancePercentage())
						: 0%>%</span> Attendance
									</p>
								</div>

								<div class='' style='width: 135px;'>
									<img src="/assets/images/report/icons-8-discount.png"
										srcset="/assets/images/report/icons-8-discount@2x.png 2x,/assets/images/report/icons-8-discount@3x.png 3x"
										class="icons8-discount" />
									<p class='report-roles-sub-text' style='width: 150px;'>
										<span class='spannable'><%=adminRole.getPerformance() != null ? (int) ((float) adminRole.getPerformance()) : 0%>%</span>
										Performance
									</p>
								</div>

							</div>
						</div>
						<div class="col-md-4 mx-0 my-0 p-0">
							<div id="container<%=i%>" class='skill_graph'
								data-master='<%=adminRole.getMaster() != null ? adminRole.getMaster() : 0%>'
								data-wizard='<%=adminRole.getWizard() != null ? adminRole.getWizard() : 0%>'
								data-rookie='<%=adminRole.getRookie() != null ? adminRole.getRookie() : 0%>'
								data-apprentice='<%=adminRole.getApprentice() != null ? adminRole.getApprentice() : 0%>'
								style='width: 100%; height: 151.3px;'></div>
						</div>
					</div>
					<div class='line'></div>
					<div class='row report-roles-card'>

						<%
							int groupsSize = adminRole.getGroups() != null && adminRole.getGroups().size() != 0
										? adminRole.getGroups().size()
										: 0;
								if (groupsSize != 0) {

									List<List<AdminGroupThumb>> partitions = new ArrayList<>();

									for (int j = 0; j < adminRole.getGroups().size(); j += 4) {
										partitions.add(adminRole.getGroups().subList(j, Math.min(j + 4, adminRole.getGroups().size())));
									}
						%>
						<div id="carouselExampleControls<%=i%>"
							class="carousel slide w-100 carousel-holder" data-ride="carousel"
							data-interval="false">
							<div class="carousel-inner">

								<%
									int k = 0;
											for (List<AdminGroupThumb> list : partitions) {
								%>
								<div class="carousel-item <%=k == 0 ? "active" : ""%>">
									<div class='row custom-no-margins'>

										<%
											k++;
														for (AdminGroupThumb adminGroupThumb : list) {
										%>
										<div class="card p-0 report-role-carousel-card">
											<div class="card-header report-section-card-header">
												<div
													class='report-section-card-header-title popover-dismiss'
													data-toggle="popover" title="Section" data-trigger="hover"
													data-placement="top"
													data-content="<%=adminGroupThumb.getName() != null ? adminGroupThumb.getName() : "Not Available"%>">
													<%
														if (adminGroupThumb.getName() != null && adminGroupThumb.getName().length() > 15) {
													%>
													<%=adminGroupThumb.getName().substring(0, 15)%>
													...
													<%
														} else if (adminGroupThumb.getName() != null) {
													%>
													<%=adminGroupThumb.getName()%>
													<%
														} else {
													%>
													Not Available
													<%
														}
													%>
												</div>
												<p class="stars">


													<%
														if (adminGroupThumb.getAvgRating() != null && adminGroupThumb.getAvgRating() > 0) {
																			float init_rating = adminGroupThumb.getAvgRating() % 20;
																			int rating = (int) Math.ceil(init_rating);

																			for (int j = 0; j < rating; j++) {
													%><i class='dash-star-6x fa fa-star'></i>
													<%
														}
																			if (rating < 5) {
																				for (int j = rating; j < 5; j++) {
													%><i class='dash-star-6x fa fa-star-o'></i>
													<%
														}
																			}
																		} else {
													%><i class='dash-star-6x fa fa-star-o'></i><i
														class='dash-star-6x fa fa-star-o'></i><i
														class='dash-star-6x fa fa-star-o'></i><i
														class='dash-star-6x fa fa-star-o'></i><i
														class='dash-star-6x fa fa-star-o'></i>
													<%
														}
													%>
												</p>
											</div>
											<div class="card-body">
												<div class='row pt-2 px-3 pb-3'>

													<div class='col-md-3'>
														<img src="/assets/images/report/icons-8-student.png"
															srcset="/assets/images/report/icons-8-student@2x.png 2x,/assets/images/report/icons-8-student@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'><%=adminGroupThumb.getTotalStudents() != null
									? adminGroupThumb.getTotalStudents()
									: 0%></h5>
													</div>

													<div class='col-md-3'>
														<img src="/assets/images/report/icons-8-report-card.png"
															srcset="/assets/images/report/icons-8-report-card@2x.png 2x,/assets/images/report/icons-8-report-card@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'><%=adminGroupThumb.getAttendancePercentage() != null
									? (int) ((float) adminGroupThumb.getAttendancePercentage())
									: 0%>%
														</h5>
													</div>

													<div class='col-md-3'>
														<img src="/assets/images/report/icons-8-discount.png"
															srcset="/assets/images/report/icons-8-discount@2x.png 2x,/assets/images/report/icons-8-discount@3x.png 3x"
															class="report-section-icon" />
														<h5 class='report-section-subtext'><%=adminGroupThumb.getPerformance() != null
									? (int) ((float) adminGroupThumb.getPerformance())
									: 0%>%
														</h5>
													</div>


												</div>
												<p class='report-section-completion mb-0'>Course
													completion</p>

												<div class='row p-0 m-0'>
													<div class='col-md-10 my-auto p-0'>
														<div class='progress'>
															<div class='progress-bar report-roles-progress'
																role='progressbar'
																style='width: <%=adminGroupThumb.getCompletionPercentage() != null
									? adminGroupThumb.getCompletionPercentage()
									: 0%>%'
																aria-valuenow='<%=adminGroupThumb.getCompletionPercentage() != null
									? adminGroupThumb.getCompletionPercentage()
									: 0%>'
																aria-valuemin='0' aria-valuemax='100'></div>
														</div>
													</div>
													<div
														class='col-md-2 report-roles-course-completion text-center p-0 mx-auto'><%=adminGroupThumb.getCompletionPercentage() != null
									? adminGroupThumb.getCompletionPercentage()
									: 0%>%
													</div>
												</div>

											</div>
										</div>

										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>
							</div>

							<%
								if (groupsSize > 4) {
							%>

							<a class="carousel-control-next custom-right-prev-section"
								href="#carouselExampleControls<%=i%>" role="button"
								id='carousel-control-next-<%=i%>' data-slide="next"> <img
								src="/assets/images/report/icons-8-chevron-right-round.png"
								srcset="/assets/images/report/icons-8-chevron-right-round@2x.png 2x,
             /assets/images/report/icons-8-chevron-right-round@3x.png 3x"
								class="icons8-chevron_right_round" />

							</a> <a class="carousel-control-prev custom-left-prev-section"
								href="#carouselExampleControls<%=i%>" role="button"
								id='carousel-control-prev-<%=i%>' data-slide="prev"> <img
								src="/assets/images/report/icons-8-chevron-right-round.png"
								srcset="/assets/images/report/icons-8-chevron-right-round@2x.png 2x,
             /assets/images/report/icons-8-chevron-right-round@3x.png 3x"
								class="icons8-chevron_right_round" />
							</a>

							<%
								}
							%>


						</div>

						<%
							} else {
						%>
						<div class="jumbotron m-auto w-100 text-center bg-white">
							<h1>No Sections Found!</h1>
						</div>

						<%
							}
						%>
					</div>
				</div>
			</div>


		</div>
		<%
			}
		%>
	</div>

	<!--/row-->


	<jsp:include page="/inc/foot.jsp"></jsp:include>

	<script>
		$(document).ready(function() {

					var chart;
					$('.skill_graph').each(
							function(index) {

								new Highcharts.Chart({
									credits:false,
									legend : {
										layout : 'vertical',
										backgroundColor : '#ffffff',
										align : 'right',
										symbolHeight : 5,
										symbolRadius : 0,
										verticalAlign : 'middle',
										floating : true,
									},
									chart : {
										renderTo : 'container' + index,
										type : 'pie'
									},
									title : {
										text : ''
									},
									yAxis : {
										title : {
											text : ''
										}
									},
									plotOptions : {
										pie : {
											shadow : false
										}
									},
									tooltip : {
										formatter : function() {
											return '<b>' + this.point.name
													+ '</b>: ' + this.y + ' %';
										}
									},
									series : [ {
										name : 'Mastry Level',
										data : [
												{
													y : parseInt($(this).data(
															'wizard')),
													name : "Wizrard",
													color : "#fd6d81"
												},
												{
													y : parseInt($(this).data(
															'master')),
													name : "Master",
													color : "#7295fd"
												},
												{
													y : parseInt($(this).data(
															'apprentice')),
													name : "Apprentice",
													color : "#30beef"
												},
												{
													y : parseInt($(this).data(
															'rookie')),
													name : "Rookie",
													color : "#bae88a"
												}

										],
										size : '121.3px',
										innerSize : '60%',
										showInLegend : true,
										dataLabels : {
											enabled : false
										}
									} ]
								});

							});

					$('.carousel-holder').each(function() {
						checkitem($(this));
					});

					$('.carousel-holder').bind('slid.bs.carousel', function(e) {
						checkitem($(this));
					});
					
					$('.pop_hover').each(function(){
						if($(this).data("show_more")==true)
						{
							var id  =$(this).attr("id").replace("bc_","");
							var htmlV = $('#mc_'+id).html();
							//alert(htmlV);
							$(this).popover({
								   html: true,
								   trigger: 'hover',
								   placement: 'top',
								   toggle: 'popover',
								   title: 'Exceptions in Event',
								   content:htmlV+''
							       		    
							});		
						}
						
						});
						
					$('.popover-dismiss').popover();
					
					//individual_group_report.jsp
					$('.report-roles-card-click').click(function(){
						var course_id = $(this).attr('data-courseid');
						alert('clicked'+course_id);
						window.location.href = "<%=baseURL%>/orgadmin/report/group_report/individual_group_report.jsp?course_id="+course_id;
					});

				});

		function checkitem($this) // check function
		{
			if ($this.find('.carousel-inner .carousel-item:first').hasClass(
					'active')) {
				$this.find('.carousel-control-prev').hide();
				$this.find('.carousel-control-next').show();
			} else if ($this.find('.carousel-inner .carousel-item:last')
					.hasClass('active')) {
				$this.find('.carousel-control-prev').show();
				$this.find('.carousel-control-next').hide();
			} else {
				$this.find('.carousel-control-next').show();
				$this.find('.carousel-control-prev').show();
			}
		}
	</script>

</body>

</html>