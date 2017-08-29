<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<body>
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
			<div class="row justify-content-md-center custom-no-margins">
				<%

%>

				<div class='col-md-8 custom-no-padding'>
					<h1>Today's Events</h1>
				</div>
				<div class='col-md-4 col-md-auto'>
					<div class="row">
						<div class="col-md-4">
							<h1>
								<button class="label-info-green">
									<div class="row mx-0">
										<div class="oval-big-green ml-sm-2"></div>
										<div class="ongoing ml-sm-3">Ongoing</div>
									</div>
								</button>
							</h1>
						</div>
						<div class="col-md-4 pl-sm-2">
							<h1>
								<button class="label-info-blue">
									<div class="row mx-0">
										<div class="oval-big-blue ml-sm-2"></div>
										<div class="ongoing ml-sm-3">Scheduled</div>
									</div>
								</button>
							</h1>
						</div>
						<div class="col-md-4">
							<h1>
								<button class="label-info-red">
									<div class="row mx-0">
										<div class="oval-big-red ml-sm-2"></div>
										<div class="ongoing ml-sm-3">Completed</div>
									</div>
								</button>
							</h1>
						</div>

					</div>
				</div>


			</div>
		</div>
		<!--/row-->
		<div class="container">

			<div id="carouselExampleControls" class="carousel slide"
				data-ride="carousel" data-interval="false"
				>
				<div class="carousel-inner">


					<%
						for (int i = 0; i < 15; i++) {
							String temp = "";
							if (i == 0) {
								temp = "active";
							} else {
								temp = "";
							}
					%>

					<%
						if (i % 3 == 0) {
					%>
					<div class="carousel-item <%=temp%>">
						<div class="row">
							<%
								}
							%>
							<div class="col-md-4">
							<a data-toggle="modal" data-target=".bd-example-modal-lg">
								<div class="card card-w370-h240">
									<div class="card-body">
										<div class="top-right-label-semi-circle-green p-3">
											<img src="/assets/images/icons_8_video_call2.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x"
												class="float-right">
											<!-- for schedule use img 
											/assets/images/completed_shape2.png
											-->
										</div>
										<div class="row custom-no-margins">
											<img src="/assets/images/icons_8_clock2.png"
												srcset="/assets/images/icons_8_clock2.png 2x, /assets/images/icons_8_clock3.png 3x"
												class="icons8-clock">
											<h1 class="am-hrs custom-no-margins">8 AM</h1>
											<img src="/assets/images/icons_8_empty_hourglass2.png"
												srcset="/assets/images/icons_8_empty_hourglass2.png 2x, /assets/images/icons_8_empty_hourglass3.png 3x"
												class="icons8-empty_hourglass">
											<h1 class="am-hrs custom-no-margins">8 Hrs</h1>
										</div>
										<div class="row mt-sm-3">
											<div class="col-md-3">
												<img alt="image" class="img-thumbnail-small"
													src="http://cdn.talentify.in:9999/course_images/m_106.png">
											</div>
											<div class="col-md-9 pl-0">
												<div class="custom-trainer-card-title m-0">Retail Banking</div>
												<div class="custom-trainer-card-header popover-dismiss" 
												data-toggle="popover" 
												title="Sessions" 
												data-trigger="hover" 
												data-placement="top"
												data-content="And here's some amazing content. It's very engaging. Right?">Operation of Banks - 2</div>
												<div class="row m-0">
													<div class="custom-trainer-card-info">FY BCom .
														Section 1</div>
													<div class="mr-md-3">
														<span class="oval-small"></span>
													</div>
													<div class="custom-trainer-card-info">Miriam Thomas</div>
												</div>
											</div>
										</div>
										<hr class="my-3">
										<div class="row">
											<div class="col-md-3 pr-3">
												<div class="trainer-dash-attendance-head">
													Attendance
													<p class="trainer-dash-attendance-value">68%</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Performance
													<p class="trainer-dash-attendance-value">68%</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Student
													<p class="stars">
														<i class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star-o"></i><i
															class="trainer-dash-star fa fa-star-o"></i>
													</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Trainer
													<p class="stars">
														<i class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star"></i><i
															class="trainer-dash-star fa fa-star-o"></i><i
															class="trainer-dash-star fa fa-star-o"></i>
													</p>
												</div>
											</div>
										</div>
										<hr class="my-3">
										<div class="pop_hover popover-dismiss" id="bc_<%=i%>" data-show_more="true">
										<p class="trainer-dash-note">
											<i class="fa fa-flag yellow-flag" aria-hidden="true"></i>
											Classes started 10 min late
										</p>
										<p class="trainer-dash-note">
											<i class="fa fa-flag red-flag" aria-hidden="true"></i>
											Teaching was slow
										</p>
										
										<div class="mc" id="mc_<%=i%>" style="display:none">
											<p class="trainer-dash-note">
											<i class="fa fa-flag yellow-flag" aria-hidden="true"></i>
											Classes started 10 min late
										</p>
										<p class="trainer-dash-note">
											<i class="fa fa-flag red-flag" aria-hidden="true"></i>
											Teaching was slow
										</p>
										<p class="trainer-dash-note">
											<i class="fa fa-flag yellow-flag" aria-hidden="true"></i>
											Classes started 10 min late
										</p>
										<p class="trainer-dash-note">
											<i class="fa fa-flag red-flag" aria-hidden="true"></i>
											Teaching was slow
										</p>
										</div>
										</div>
									</div>
								</div>
								</a>
							</div>

							<%
								if (i % 3 == 2) {
							%>
						</div>
					</div>
					<%}} %>
					<!-- Modal start -->
							<div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
							  <div class="modal-dialog modal-lg">
							    <div class="modal-content custom-event-container">
							      <div class="modal-header custom-event-modal-header">
							      <div class="container">
							      <div class="row">
							      <div class="col-md-2"><img alt="image" class="img-thumbnail-medium" src="http://cdn.talentify.in:9999/course_images/m_106.png"></div>
											<div class="col-md-10">
												<div class="row">
													<div class="col-md-10">
														<div class="row custom-no-margins">
															<img src="/assets/images/icons_8_clock2.png"
																srcset="/assets/images/icons_8_clock2.png 2x, /assets/images/icons_8_clock3.png 3x"
																class="icons8-clock">
															<h1 class="am-hrs custom-no-margins">8 AM</h1>
															<img src="/assets/images/icons_8_empty_hourglass2.png"
																srcset="/assets/images/icons_8_empty_hourglass2.png 2x, /assets/images/icons_8_empty_hourglass3.png 3x"
																class="icons8-empty_hourglass">
															<h1 class="am-hrs custom-no-margins">8 Hrs</h1>
														</div>
													</div>
													<div class="col-md-2">
														<button type="button"
															class="close float-right custom-close-modal"
															data-dismiss="modal" aria-label="Close">X</button>
													</div>
												</div>
												<div class="row"><h1 class="custom-modal-header-trainer">Operations of Bank -2</h1> <div class="custom-oval-icon"><img src="/assets/images/icons_8_video_call2.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x" class=""></div></div>
												<div class="row m-0">
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Roles </h4><h4 class="modal-info-content mb-0">Retail Banking</h4></div></div>
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Group </h4><h4 class="modal-info-content mb-0">FY.BCom</h4></div></div>
												<div class="col-md-4"><div class="row"><h4 class="modal-info-header mr-1 mb-0">Trainer </h4><h4 class="modal-info-content mb-0">Miriam Thomas</h4></div></div>
												</div>
											</div>
										</div>
							      </div>
							        <!-- <h4 class="modal-title" id="myLargeModalLabel">Large modal</h4> -->
							        
							      </div>
								<div class="modal-body p-0">
									<div class="container px-0">
									<ul class="nav nav-tabs" style="flex-wrap: nowrap;">
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text active p-0" data-toggle="tab" href="#presentation" role="tab">Presentation</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#trainerinfo" role="tab">Trainer Info</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#attendance" role="tab">Attendance</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#feedback" role="tab">Feedback</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#assessment" role="tab">Assessment</a>
										</li>
										<li class="nav-item nav-item-modal-box m-0"><a class="nav-link nav-modal-text p-0" data-toggle="tab" href="#sessionlog" role="tab">Session Log</a>
										</li>
									</ul>
									</div>
									<div class="tab-content">
										<div class="tab-pane active" id="presentation" role="tabpanel">.fedfc.</div>
										<div class="tab-pane" id="trainerinfo" role="tabpanel">dsvds vs..</div>
										<div class="tab-pane" id="attendance" role="tabpanel">..cdsvds.</div>
										<div class="tab-pane" id="feedback" role="tabpanel">...v s d dsf</div>
										<div class="tab-pane" id="assessment" role="tabpanel">..vcsdvsdv.</div>
										<div class="tab-pane" id="sessionlog" role="tabpanel">..fcdsvsd.</div>
									</div>
								</div>
							</div>
							  </div>
							</div>
					<!-- Modal end -->
				</div>
				<a class="carousel-control-next custom-right-prev-trainer"
					href="#carouselExampleControls" role="button" data-slide="next">
					<img class="" src="/assets/images/992180-200-copy.png" alt="">
				</a> <a class="carousel-control-prev custom-left-prev-trainer"
					href="#carouselExampleControls" role="button" data-slide="prev">
					<img class="" src="/assets/images/992180-2001-copy.png" alt="">
				</a>
			</div>

		</div>
		<div class="container">
		<h1 class="mt-lg-5">Performance Metrics</h1>
		</div>
		<div class="container">
			<div class="row">
				<div class="col-md-6">
					<div class="card">
						<div class="card-block">
						<div class="card-body">
							<div class="row m-0">
								<div class="col-md-10 pl-0"><h3 class="card-header-box">Section wise performance of students</h3></div>
								<div class="col-md-2"><img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container"></div>
							</div>
							<select class="form-control select-dropdown-style" id="exampleSelect1">
								<option>Desktop Publishing</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select>
								<div id="highchartcontainer"></div>
									<table id="datatable" class="hidden-content">
										<thead>
											<tr>
												<th></th>
												<th>Wizard</th>
												<th>Master</th>
												<th>Apprentice</th>
												<th>Rookie</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th>Combined Batch A</th>
												<td>3</td>
												<td>4</td>
												<td>7</td>
												<td>3</td>
											</tr>
											<tr>
												<th>Combined Batch B</th>
												<td>2</td>
												<td>0</td>
												<td>5</td>
												<td>1</td>
											</tr>
										</tbody>
									</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card">
						<div class="card-block">
						<div class="card-body">
							<div class="row m-0">
								<div class="col-md-10 pl-0"><h3 class="card-header-box">Program wise performance of students</h3></div>
								<div class="col-md-2"><img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container"></div>
							</div>
							<select class="form-control select-dropdown-style" id="exampleSelect1">
								<option>BCom . Section 1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select>
								<div id="highchartcontainer2"></div>
									<table id="datatable2" class="hidden-content">
										<thead>
											<tr>
												<th></th>
												<th>Wizard</th>
												<th>Master</th>
												<th>Apprentice</th>
												<th>Rookie</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th>Desktop Publishing</th>
												<td>3</td>
												<td>4</td>
												<td>7</td>
												<td>3</td>
											</tr>
											<tr>
												<th>Marketing Strategy</th>
												<td>2</td>
												<td>0</td>
												<td>5</td>
												<td>1</td>
											</tr>
										</tbody>
									</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="container pt-xl-5">
		<div class="row">
			<div class="col-md-6">
					<div class="card">
						<div class="card-block">
						<div class="card-body">
							<div class="row m-0">
								<div class="col-md-10 pl-0"><h3 class="card-header-box">Competitive performance with other organizations</h3></div>
								<div class="col-md-2"><img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container"></div>
							</div>
							<br/>
								<div id="highchartcontainer3"></div>
									<table id="datatable3" class="hidden-content">
										<thead>
											<tr>
												<th></th>
												<th>Rajagiri College of Social Science</th>
												<th>Other Colleges</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th>Desktop Publishing</th>
												<td>3</td>
												<td>3</td>
											</tr>
											<tr>
												<th>Digital Marketing</th>
												<td>5</td>
												<td>1</td>
											</tr>
											<tr>
												<th>Marketing Strategy</th>
												<td>2</td>
												<td>1</td>
											</tr>
										</tbody>
									</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card">
						<div class="card-block">
						<div class="card-body">
							<div class="row m-0">
								<div class="col-md-10 pl-0"><h3 class="card-header-box">Role wise performance of students</h3></div>
								<div class="col-md-2"><img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container"></div>
							</div>
							<select class="form-control select-dropdown-style" id="exampleSelect1">
								<option>Retail Banking - 2</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select>
								<div id="highchartcontainer4"></div>
									<table id="datatable4" class="hidden-content">
										<thead>
											<tr>
												<th></th>
												<th>Wizard</th>
												<th>Master</th>
												<th>Apprentice</th>
												<th>Rookie</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th>Combined Batch A</th>
												<td>3</td>
												<td>4</td>
												<td>7</td>
												<td>3</td>
											</tr>
											<tr>
												<th>Combined Batch B</th>
												<td>2</td>
												<td>0</td>
												<td>5</td>
												<td>1</td>
											</tr>
										</tbody>
									</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--/row-->
		
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
	$(document).ready(function() {
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
		
		   $('.carousel').carousel('pause');
		   Highcharts.chart('highchartcontainer', {
			    data: {
			        table: 'datatable'
			    },
			    chart: {
			        type: 'column'
			    },
			    title: {
			        text: ''
			    },
			    yAxis: {
			        alowDecimals: false,
			        title: {
			        	text: 'Percentage of Students' 
			        }
			    },
			    tooltip: {
			        formatter: function () {
			            return '<b>' + this.series.name + '</b><br/>' +
			                this.point.y + ' ' + this.point.name.toLowerCase();
			        }
			    }
			});
		   Highcharts.chart('highchartcontainer2', {
			    data: {
			        table: 'datatable2'
			    },
			    chart: {
			        type: 'column'
			    },
			    title: {
			        text: ''
			    },
			    yAxis: {
			        alowDecimals: false,
			        title: {
			        	text: 'Percentage of Students' 
			        }
			    },
			    tooltip: {
			        formatter: function () {
			            return '<b>' + this.series.name + '</b><br/>' +
			                this.point.y + ' ' + this.point.name.toLowerCase();
			        }
			    }
			});
		   Highcharts.chart('highchartcontainer3', {
			    data: {
			        table: 'datatable3'
			    },
			    chart: {
			        type: 'column'
			    },
			    title: {
			        text: ''
			    },
			    yAxis: {
			        alowDecimals: false,
			        title: {
			        	text: 'Average Adjusted Score' 
			        }
			    },
			    tooltip: {
			        formatter: function () {
			            return '<b>' + this.series.name + '</b><br/>' +
			                this.point.y + ' ' + this.point.name.toLowerCase();
			        }
			    }
			});
		   Highcharts.chart('highchartcontainer4', {
			    data: {
			        table: 'datatable4'
			    },
			    chart: {
			        type: 'column'
			    },
			    title: {
			        text: ''
			    },
			    yAxis: {
			        alowDecimals: false,
			        title: {
			        	text: 'Percentage of Students' 
			        }
			    },
			    tooltip: {
			        formatter: function () {
			            return '<b>' + this.series.name + '</b><br/>' +
			                this.point.y + ' ' + this.point.name.toLowerCase();
			        }
			    }
			});
		});
</script>
</body>
</html>