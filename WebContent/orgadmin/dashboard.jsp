<%@page import="com.talentify.admin.rest.pojo.EventError"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.viksitpro.core.utilities.TrainerWorkflowStages"%>
<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="java.util.List"%>
<%@page import="com.talentify.admin.rest.pojo.EventsCard"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
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
		
		int orgId = (int)request.getSession().getAttribute("orgId");
		System.out.println(orgId);
		
		AdminRestClient adminClient  = new AdminRestClient();
		ArrayList<EventsCard> events = adminClient.getEventsForToday(orgId);
		System.out.println("event size "+events.size());
		
		
		List<List<EventsCard>> partitions = new ArrayList<>();
		

		for (int j = 0; j < events.size(); j += 3) {
			partitions.add(events.subList(j, Math.min(j + 3, events.size())));
		}

		
		
		
		
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
					<div class="row mt-4">

						<a class="btn btn-default green-border"><i
							class="fa fa-circle green-dot" aria-hidden="true"></i>Ongoing</a> <a
							class="btn btn-default blue-border"><i
							class="fa fa-circle blue-dot" aria-hidden="true"></i>Scheduled</a> <a
							class="btn btn-default red-border"><i
							class="fa fa-circle red-dot" aria-hidden="true"></i>Completed</a>
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
						for (int i = 0; i < partitions.size(); i++) {
							List<EventsCard> actualEvents = partitions.get(i);
					%>

					
					<div class="carousel-item <%=i==0?"active":""%>">
						<div class="row">
							<%
							for(EventsCard event : actualEvents)
							{
								%>
								<div class="col-md-4">
							<div class="card card-w370-h240 event_card"  id="event_<%=event.getEventId()%>">
									<div class="card-body">
										
										<%
										switch (event.getStatus())
										{
										case "SCHEDULED":
											%>
											<div class="top-right-label-semi-circle-blue p-3">
											<img src="/assets/images/completed_shape.png"
												srcset="/assets/images/completed_shape2.png 2x, /assets/images/completed_shape3.png 3x"
												class="float-right">
											</div>	
											<%
											break;
										
										case TrainerWorkflowStages.COMPLETED:
											%>
											<div class="top-right-label-semi-circle-red p-3">
											<img src="/assets/images/icons_8_video_call2.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x"
												class="float-right">
											</div>	
											<%
											break;
									
										case TrainerWorkflowStages.TEACHING:
											%>
											<div class="top-right-label-semi-circle-green p-3">
											<img src="/assets/images/icons_8_video_call2.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x"
												class="float-right">
											</div>	
											<%
											break;
										default:
											
											break;
											
											
										}
										%>
										
										<div class="row custom-no-margins">
											<img src="/assets/images/icons_8_clock2.png"
												srcset="/assets/images/icons_8_clock2.png 2x, /assets/images/icons_8_clock3.png 3x"
												class="icons8-clock">
											<h1 class="am-hrs custom-no-margins"><%=event.getTime() %></h1>
											<img src="/assets/images/icons_8_empty_hourglass2.png"
												srcset="/assets/images/icons_8_empty_hourglass2.png 2x, /assets/images/icons_8_empty_hourglass3.png 3x"
												class="icons8-empty_hourglass">
											<h1 class="am-hrs custom-no-margins"><%=event.getDuration() %> Hrs</h1>
										</div>
										<div class="row mt-sm-3">
											<div class="col-md-3">
												<img alt="image" class="img-thumbnail-small"
													src="<%=AppProperies.getProperty("media_url_path") %><%=event.getImageUrl()%>">
											</div>
											<div class="col-md-9 pl-0">
												<div class="custom-trainer-card-title m-0"><%=event.getCourse()%></div>
												<div class="custom-trainer-card-header popover-dismiss" data-toggle="popover" 
												title="Sessions" 
												data-trigger="hover" 
												data-placement="top"
												data-content="<%=event.getSessionName()%>">												
												<%if(event.getSessionName().length()>25)
													{
													%>
													<%=event.getSessionName().substring(0, 25)%> ...
													<%
													}
													else
													{
														%>
														<%=event.getSessionName()%>
														<%
													}
													%>
												</div>
												<div class="row m-0">
													<div class="custom-trainer-card-info"><%=event.getGroupName()%></div>
													<div class="mr-md-3">
														<span class="oval-small"></span>
													</div>
													<div class="custom-trainer-card-info"><%=event.getTrainerName()%></div>
													<div class="mr-md-3">
														<span class="oval-small"></span>
													</div>
													<%
													if(event.getAssociateTrainerName()!=null)
													{
														%>
														<div class="custom-trainer-card-info"><%=event.getAssociateTrainerName()%></div>
														<% 
													}	
													%>
												</div>
											</div>
										</div>
										<hr class="my-3">
										<div class="row">
											<div class="col-md-3 pr-3">
												<div class="trainer-dash-attendance-head">
													Attendance
													<p class="trainer-dash-attendance-value">
													<%if(event.getAttendancePercentage()!=null)
													{
														%>
														<%=event.getAttendancePercentage()%>%
														<%
													}
													else
													{
													%>N/A<%	
													}%>
													</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Performance
													<p class="trainer-dash-attendance-value">
													
													</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">Student<p class="stars">
													
													<%
													int stuRating = 0; 
													if(event.getStudentRating()!=null)
													{
														stuRating= (int)Math.ceil(event.getStudentRating());	
													}
													
													for(int j=1; j<= 5; j++)
													{
														if(j<=stuRating)
														{
															%>
															<i class="trainer-dash-star fa fa-star"></i>
															<% 
														}
														else
														{
															%>
															<i class="trainer-dash-star fa fa-star-o"></i>
															<% 
														}	
													}
													
													%>
														
													</p>
												</div>
											</div>
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Trainer
													<p class="stars">
														<%
													int trainerRating = 0; 
													if(event.getTrainerRating()!=null)
													{
														trainerRating= (int)Math.ceil(event.getTrainerRating());	
													}
													
													for(int j=1; j<= 5; j++)
													{
														if(j<=trainerRating)
														{
															%>
															<i class="trainer-dash-star fa fa-star"></i>
															<% 
														}
														else
														{
															%>
															<i class="trainer-dash-star fa fa-star-o"></i>
															<% 
														}	
													}
													
													%>
													</p>
												</div>
											</div>
										</div>
										<hr class="my-3">
										<%
										boolean hasMoreThanTwoError = false;
										if(event.getErrorFlags()!=null &&event.getErrorFlags().size()>2)
										{
											hasMoreThanTwoError= true;
										}	
										%>
										<div class="pop_hover popover-dismiss" id="bc_<%=event.getEventId()%>" data-show_more="<%=hasMoreThanTwoError%>">
										<%
										int countter =0;
										if(event.getErrorFlags()!=null)
										{
											for(EventError error : event.getErrorFlags())
											{
												String flagColor =error.getErrorColor().toLowerCase();
												
												if(countter <2)
												{
												%>
													<p class="trainer-dash-note">
													<i class="fa fa-flag <%=flagColor%>-flag" aria-hidden="true"></i>
														<%=error.getErrorValue() %>
													</p>
													
												<%	countter++;
												}
												
											}
											
											
											%>
											<div class="mc" id="mc_<%=event.getEventId()%>" style="display:none">
											<%
											for(EventError error : event.getErrorFlags())
											{
												String flagColor =error.getErrorColor().toLowerCase();
												%>
													<p class="trainer-dash-note">
													<i class="fa fa-flag <%=flagColor%>-flag" aria-hidden="true"></i>
														<%=error.getErrorValue() %>
													</p>
												<%
											}
											%>
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
					</div>
					<%} %>
					<!-- Modal start -->
							<div class="modal fade bd-example-modal-lg" id="event_details_modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
							
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
		
		$('.event_card').on("click",function(){
			$.get('../admin_partials/event_details_modal.jsp').done( function(data){
				$('#event_details_modal').html(data);
				$('#event_details_modal').modal('toggle');
				navbar_selector();
				$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
					navbar_selector();
				});
				$('.show-more').on("click",function(){
					if($('.show-more u').text() == 'Show more'){
						$('.collapsable').css('display','block');
						$('.show-more u').text('Show less');
					}else{
						$('.collapsable').css('display','none');
						$('.show-more u').text('Show more');
					}
				});
			});
			
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
	function navbar_selector(){
		$('.nav.nav-tabs li').css('cssText','background-color: #eefef;box-shadow:inset 0 -2px 0 0  #f7f7f7;');
		$('.nav.nav-tabs li>a').css('cssText','background-color:#f7f7f7 !important;color:rgba(153, 153, 153, 0.7)  !important;');
		$('.nav.nav-tabs li>.active').parent().css('cssText','background-color: #ffffff;box-shadow: inset 0 -2px 0 0 #eb384f;');
		$('.nav.nav-tabs li>.active').css('cssText','background-color: #ffffff !important;color:#eb384f !important;');
	}
</script>
</body>
</html>