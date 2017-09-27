<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.talentify.admin.services.AdminUIServices"%>
<%@page import="com.talentify.admin.rest.pojo.EventsCard"%>
<%@page import="com.talentify.admin.rest.pojo.EventError"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.viksitpro.core.utilities.TrainerWorkflowStages"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="orgadmin_dashbard">
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
		
		AdminUIServices uiservices=new AdminUIServices();
		ReportUtils reportUtils=new ReportUtils();		
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row justify-content-md-center custom-no-margins">
				<%

%>

				<div class='col-md-6 custom-no-padding'>
					<h1>Today's Events</h1>
				</div>
				<div class='col-md-6 col-md-auto'>
					<div class="row mt-4 float-right">
						<a class="filterbutton btn btn-default green-border-dashboard" data-type='ongoing'><i
							class="fa fa-circle green-dot"  aria-hidden="true"></i>Ongoing</a> <a
							class="filterbutton btn btn-default blue-border-dashboard" data-type='scheduled'><i
							class="fa fa-circle blue-dot"  aria-hidden="true"></i>Scheduled</a> <a
							class="filterbutton btn btn-default red-border-dashboard" data-type='completed'><i
							class="fa fa-circle red-dot"  aria-hidden="true"></i>Completed</a><a
							class="filterbutton btn btn-default default-border-dashboard" data-type='clearall'><i
							class="fa fa-circle default-dot" aria-hidden="true"></i>All</a>
					</div>
				</div>


			</div>
		</div>
		<!--/row-->
		
		<%if(events.size()>0){ %>
		<div class="container">

			<div id="carouselExampleControls" class="carousel slide org_dash_cards"
				data-ride="carousel" data-interval="false"
				>
				<div class="carousel-inner">


					<%
						for (int i = 0; i < partitions.size(); i++) {
							List<EventsCard> actualEvents = partitions.get(i);
					%>

					
					<div class="carousel-item all-dashboard-cards <%=i==0?"active":""%>" >
						 <!-- <div class="row"> -->
							<%
							int k=0;
							for(EventsCard event : actualEvents)
							{
								%>
								<div class="col-md-4 <%=event.getStatus()%>" style="<%=k==0?"margin-left: -10px;":""%>">
							<div class="card card-w370-h240 event_card"  id="<%=event.getEventId()%>">
									<div class="card-body">
										
										<%
										k++;
										switch (event.getStatus())
										{
										case "SCHEDULED":
											%>
											<div class="top-right-label-semi-circle-blue p-3">
											<img src="/assets/images/completed_shape3.png"
												srcset="/assets/images/completed_shape2.png 2x, /assets/images/completed_shape3.png 3x"
												class="float-right">
											</div>	
											<%
											break;
										
										case TrainerWorkflowStages.COMPLETED:
											%>
											<div class="top-right-label-semi-circle-red p-3">
											<img src="/assets/images/icons_8_video_call3.png"
												srcset="/assets/images/icons_8_video_call2.png 2x, /assets/images/icons_8_video_call3.png 3x"
												class="float-right">
											</div>	
											<%
											break;
									
										case TrainerWorkflowStages.TEACHING:
											%>
											<div class="top-right-label-semi-circle-green p-3">
											<img src="/assets/images/icons_8_video_call3.png"
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
													<div class="custom-trainer-card-info ml-2"><%=event.getTrainerName()%></div>
													<div class="mr-md-3">
														<span class="oval-small"></span>
													</div>
													<%
													if(event.getAssociateTrainerName()!=null)
													{
														%>
														<div class="custom-trainer-card-info ml-2"><%=event.getAssociateTrainerName()%></div>
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
											<%if(false){ %> 
											<div class="col-md-3 px-3">
												<div class="trainer-dash-attendance-head">
													Performance
													<p class="trainer-dash-attendance-value">
													
													</p>
												</div>
											</div>
											<%} %>
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
							

						
						 <!-- </div> --> 
					</div>
					<%} %>
					
				</div>
				<%if(events.size() > 3){%>
				<a class="carousel-control-next custom-right-prev-trainer"
					href="#carouselExampleControls" role="button" data-slide="next">
					<img src="/assets/images/report/icons-8-chevron-right-round@3x.png"
					srcset="/assets/images/report/icons-8-chevron-right-round@2x.png 2x,
             /assets/images/report/icons-8-chevron-right-round@3x.png 3x"
					class="icons8-chevron_right_round" />
				</a> <a class="carousel-control-prev custom-left-prev-trainer"
					href="#carouselExampleControls" role="button" data-slide="prev">
					<img src="/assets/images/report/icons-8-chevron-right-round@3x.png"
					srcset="/assets/images/report/icons-8-chevron-right-round@2x.png 2x,
             /assets/images/report/icons-8-chevron-right-round@3x.png 3x"
					class="icons8-chevron_right_round" />
				</a>
				<%} %>
			</div>

		</div>
		<%}else { %>
		<div class="container">
			<div class="card no-event-card">
				<div class="card-block m-auto"><h1>No Event Scheduled for Today</h1></div>
			</div>
		</div>
		<%} %>
		<!-- Modal start -->
							<div class="modal fade bd-example-modal-lg" id="event_details_modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
							
							</div>
					<!-- Modal end -->
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
								<div class="col-md-12 pl-0"><h3 class="card-header-box">Section wise performance of students</h3></div>
<!-- 								<div class="col-md-2"><img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container"></div>
 -->							</div>
							
								<select class="form-control select-dropdown-style graph_filter_selector" data-report_id="3041" name="batch_group_id" data-college_id="<%=orgId%>"
									id="graph_section">
									<%
										ArrayList<BatchGroup> batchGroups = uiservices.getBatchGroupInCollege(orgId);
										for(BatchGroup batchGroup : batchGroups)
										{ if (batchGroup.getType().equalsIgnoreCase("SECTION")){
										%>
										<option value="<%=batchGroup.getId()%>"><%=batchGroup.getName().trim()%></option>
										<%}
										} %>
								</select>

								<div id="columnchartcontainer1">
								
								
								
								</div>
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
							<select class="form-control select-dropdown-style graph_filter_selector"  data-report_id="3040" name="course_id" id='graph_program' data-college_id="<%=orgId%>">										
										<%										
										ArrayList<Course> courses = uiservices.getCoursesInCollege(orgId);
										for(Course course : courses)
										{
										%>
										<option value="<%=course.getId()%>"><%=course.getCourseName().trim()%></option>
										<%
										} %>
									</select>
								<div id="columnchartcontainer2">
								
								
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="container pt-xl-5">
				<div class="card w-100">
					<div class="card-block">
						<div class="card-body">
							<div class="row m-0">
								<div class="col-md-10 pl-0">
									<h3 class="card-header-box">Master level per skill</h3>
								</div>
								<div class="col-md-2">
									<img src="/assets/images/ic_more2.png"
										srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x"
										class="float-right options-img-container">
								</div>
							</div>
							<div class='row m-0 p-0'>

							<div class="col-12 p-1" style='min-height: 400px; background-color: #fff;'>
								<select class="form-control select-dropdown-style"
									id="graph_role" name="role_id" data-college_id="<%=orgId%>">
									<%
										ArrayList<Course> roles = uiservices.getCoursesInCollege(orgId);
										for (Course role : roles) {
									%>
									<option value="<%=role.getId()%>"><%=role.getCourseName().trim()%></option>
									<%
										}
									%>
								</select>
								<div id="columnchartcontainer3" class='w-100 m-0 p-0'>
								</div>
							</div>
							</div>
						</div>
					</div>
			</div>
		</div>
	</div>
	<!--/row-->
		
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
	
	var skillChart;
	var ongoing={};
	var completed={};
	var allDashboardCards={};
	var scheduled={};
	
	function initDashboardCards(){
		allDashboardCards=$('.all-dashboard-cards')
		ongoing=allDashboardCards.find('.TEACHING');
		completed=allDashboardCards.find('.COMPLETED');
		scheduled=allDashboardCards.find('.SCHEDULED');
		
		$('.filterbutton').unbind().on('click',function(){
			var type=$(this).data('type');
			var data="";
			if(type=='ongoing'){
				if(ongoing!=undefined && ongoing.length!=0){
					generateCards(ongoing,'TEACHING');
				}else if(allDashboardCards!=undefined && allDashboardCards.length!=0){
					data='<div class="carousel-item all-dashboard-cards active"><div class="card no-event-card w-100"> <div class="card-block m-auto"><h1>No Events in Ongoing State.</h1></div></div>';
					$('#carouselExampleControls').find('.carousel-inner').html(data);
				}
			}else if(type=='scheduled'){
				if(scheduled!=undefined && scheduled.length!=0){
					generateCards(scheduled,'SCHEDULED');	
				}else if(allDashboardCards!=undefined && allDashboardCards.length!=0){
					data='<div class="carousel-item all-dashboard-cards active"><div class="card no-event-card w-100"> <div class="card-block m-auto"><h1>No Events in Scheduled State.</h1></div></div>';
					$('#carouselExampleControls').find('.carousel-inner').html(data);
				}				
			}else if(type=='completed'){
				if(completed!=undefined && completed.length!=0){
					generateCards(completed,'COMPLETED');
				}else if(allDashboardCards!=undefined && allDashboardCards.length!=0){
					data='<div class="carousel-item all-dashboard-cards active"><div class="card no-event-card w-100"> <div class="card-block m-auto"><h1>No Event in Completed State.</h1></div></div>';
					$('#carouselExampleControls').find('.carousel-inner').html(data);
				}
			}else if(type=='clearall'){
				if(allDashboardCards!=undefined && allDashboardCards.length!=0){
					$('#carouselExampleControls').find('.carousel-inner').html(allDashboardCards);
				}
			}
			
			$('.org_dash_cards').each(function() {
				checkitem($(this));
				
				if($(this).find('.carousel-inner .carousel-item').length==1){
					$(this).find('.carousel-control-next').hide();
					$(this).find('.carousel-control-prev').hide();
				}
		 	});
			event_cardFunction();
		});
	}
	
	function generateCards(listData,type){
		var partitions = [];
		for (var j = 0; j < listData.length; j += 3) {
			partitions.push(listData.slice(j, Math.min(j + 3, listData.length)));
		}
		var data="";
		for(var i=0;i<partitions.length;i++){
			data+='<div class="carousel-item all-dashboard-cards '+(i==0?"active":"")+'" >';

			for(j=0;j<partitions[i].length;j++){
				data+='<div class="col-md-4 '+type+'" style="'+(j==0?"margin-left:-10px;":"")+'">';
				data+=$(partitions[i][j]).html();
				data+='</div>';
			}
			data+='</div>';
		}
		$('#carouselExampleControls').find('.carousel-inner').html(data);
	}
	
	$(document).ready(function() {
		
		$.fn.scrollBottom = function() { 
		 	return $(document).height() - this.scrollTop() - this.height(); 
		}
		
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
			
		event_cardFunction();
		
		$('.popover-dismiss').popover();
		   $('.carousel').carousel('pause');
		   $('.org_dash_cards').each(function() {
				checkitem($(this));
			});
			$('.org_dash_cards').bind('slid.bs.carousel', function(e) {
				checkitem($(this));
			});
			
			initDashboardCards();
			
			
			scectionWisePerformanceOfStudents($('#graph_section').val(),$('#graph_section').attr('data-college_id'));
			programWisePerformanceOfStudents($('#graph_program').val(),$('#graph_program').attr('data-college_id'));
			masterLevelPerSkill($('#graph_role').val(),$('#graph_role').attr('data-college_id'));
			//roleWisePerformanceOfStudents();
			//programWisePerformanceOfStudents();
			
			$( "#graph_section" ).change(function() {
				 alert( $(this).val() );
				 scectionWisePerformanceOfStudents($(this).val(),$(this).attr('data-college_id'));
				});
			$( "#graph_program" ).change(function() {
				  alert( $(this).val() );
				  programWisePerformanceOfStudents($(this).val(),$(this).attr('data-college_id'));
				});
			$( "#graph_role" ).change(function() {
				  alert( $(this).val() );
				  masterLevelPerSkill($(this).val(),$(this).attr('data-college_id'));
				});
		
		});
	
	 function masterLevelPerSkill(role_id,college_id) {

		   	  $.ajax({
					    url: 'http://localhost:8080/a/admin/dashboard/'+college_id+'/skill_performance/'+role_id+'',
					    type: 'GET',
					    async: true,
					    dataType: "json",
					    success: function (data) {				    					    	
					    	google.charts.load('current', {'packages':['corechart']});
					          google.charts.setOnLoadCallback(drawStuff);

					          function drawStuff() {
					        	 
					            var tabledData = google.visualization.arrayToDataTable( data.first_level );				      
					            var classicOptions = {
					            		tooltip: {isHtml: true},
					            		height: 270,
					            		 legend: 'none',
							                colors: ['#30beef','#bae88a','#fd6d81','#7295fd'],
								       	    fontName: 'avenir-light',	
								       	 vAxis: {title: ' Percentage Of Student'},						       
								         seriesType: 'bars',								      								         
					            };					           
					            function drawClassicChart(jsonData) {
					             
					            	 var chart = new google.visualization.ColumnChart(document.getElementById('columnchartcontainer3'));
								          chart.draw(tabledData, classicOptions);
								        if(jsonData != null){
								        	google.visualization.events.addListener(chart, 'select', function () {
							            	selectHandler(chart, tabledData,jsonData);
								        	
						                });	
								        }
					            }
					            
					           
					            function selectHandler(chart, data,jsonData) {
					                var selectedItem = chart.getSelection()[0];
					                var selectedModule =  selectedItem.row
					                if (selectedItem) {         					              
									    	tabledData = google.visualization.arrayToDataTable( jsonData.second_level[selectedModule] );								                
						                    drawClassicChart();
						                    GenerateBack();					                	
					                }
					     
					            }
					            
					            function GenerateBack() {
					                $('.backButtonContainer').remove();
					                //Create new Back Button
					               
					                    var $back = $('<button/>').text('Back').addClass('reportBack').click(function () {
					                    	
					                    	            masterLevelPerSkill();
					                                    $(this).parent().remove();
					                                });
					                    var $div = $('<div/>').addClass('backButtonContainer').css({ 'width': '90%', 'text-align': 'right', 'padding': '5px' }).append($back);
					                    $('#columnchartcontainer3').before($div);
					     
					               
					            }

					            drawClassicChart(data);
					         
					        };
					    	
					    	}
					  });
		   	  
		   	  
		       
		       }
	
	
	 function programWisePerformanceOfStudents(course_id,college_id) {

   	//  $.ajax({
			//    url: '',
			 //   type: 'GET',
			 //   async: true,
			 //   dataType: "json",
			  //  success: function (data) {				    					    	
			    	google.charts.load('current', {'packages':['corechart']});
			          google.charts.setOnLoadCallback(drawStuff);

			          function drawStuff() {
			            var tabledData = google.visualization.arrayToDataTable( 
			            		[
			            	          ['Year', 'Wizard', 'Master', 'Apprentice', 'Rookie'],
			            	          ['EAST', 1000, 400, 200, 100],
			            	          ['WEST', 1170, 460, 250, 340],
			            	          ['NORTH', 660, 1120, 300, 200],
			            	          ['SOUTH', 1030, 540, 350, 250]
			            	        ]
			            );				      
			            var classicOptions = {
			            		tooltip: {isHtml: true},
			            		 legend: 'none',
					                colors: ['#30beef','#bae88a','#fd6d81','#7295fd'],
						       	    fontName: 'avenir-light',	
						       	 vAxis: {title: ' Percentage Of Student'},						       
						         seriesType: 'bars',		            		
			            };
			           
			            function drawClassicChart() {
			             
			            	 var chart = new google.visualization.ColumnChart(document.getElementById('columnchartcontainer2'));
						        chart.draw(tabledData, classicOptions);
						       
						       var legendHtml =  "<div class='row'>";
						    	   legendHtml += "<div class='col-12 text-center'>";
						    		   legendHtml += "<span class='btn btn-default m-0 graph-border-1 mr-3'><i class='fa fa-circle graph-dot-1'></i>'Wizard'</span>";
						    			   legendHtml += "<span class='btn btn-default m-0 graph-border-2 mr-3'><i class='fa fa-circle graph-dot-2'></i>'Master'</span> ";
						    				   legendHtml += "<span class='btn btn-default m-0 graph-border-3 mr-3'><i class='fa fa-circle graph-dot-3'></i>'Apprentice'</span>";
						    					   legendHtml +=  "<span class='btn btn-default m-0 graph-border-4 mr-3'><i class='fa fa-circle graph-dot-4'></i>'Rookie'</span>";
						    						   legendHtml += "</div></div>";
						        $('#columnchartcontainer2').append(legendHtml);
			            }

			            drawClassicChart();
			        };
			    	
			    	//}
			//  });
   	  
   	  
       
       }
	 
	 function scectionWisePerformanceOfStudents(section_id,college_id) {

		   	//  $.ajax({
					//    url: '',
					 //   type: 'GET',
					 //   async: true,
					 //   dataType: "json",
					  //  success: function (data) {				    					    	
					    	google.charts.load('current', {'packages':['corechart']});
					          google.charts.setOnLoadCallback(drawStuff);

					          function drawStuff() {
					            var tabledData = google.visualization.arrayToDataTable( 
					            		[
					            	          ['Sesction', 'Wizard', 'Master', 'Apprentice', 'Rookie'],
					            	          ['EAST', 1000, 400, 200, 100],
					            	          ['WEST', 1170, 460, 250, 340],
					            	          ['NORTH', 660, 1120, 300, 200],
					            	          ['SOUTH', 1030, 540, 350, 250]
					            	        ]
					            );				      
					            var classicOptions = {
					            		tooltip: {isHtml: true},
					            		 legend: 'none',
							                colors: ['#30beef','#bae88a','#fd6d81','#7295fd'],
								       	    fontName: 'avenir-light',	
								       	 vAxis: {title: ' Percentage Of Student'},						       
								         seriesType: 'bars',		            		
					            };
					           
					            function drawClassicChart() {
					             
					            	 var chart = new google.visualization.ColumnChart(document.getElementById('columnchartcontainer1'));
								        chart.draw(tabledData, classicOptions);
								       
								        var legendHtml =  "<div class='row'>";
								    	   legendHtml += "<div class='col-12 text-center'>";
								    		   legendHtml += "<span class='btn btn-default m-0 graph-border-1 mr-3'><i class='fa fa-circle graph-dot-1'></i>'Wizard'</span>";
								    			   legendHtml += "<span class='btn btn-default m-0 graph-border-2 mr-3'><i class='fa fa-circle graph-dot-2'></i>'Master'</span> ";
								    				   legendHtml += "<span class='btn btn-default m-0 graph-border-3 mr-3'><i class='fa fa-circle graph-dot-3'></i>'Apprentice'</span>";
								    					   legendHtml +=  "<span class='btn btn-default m-0 graph-border-4 mr-3'><i class='fa fa-circle graph-dot-4'></i>'Rookie'</span>";
								    						   legendHtml += "</div></div>";
								        $('#columnchartcontainer1').append(legendHtml);
					            }

					            drawClassicChart();
					        };
					    	
					    	//}
					//  });
		   	  
		   	  
		       
		       }
	
	function event_cardFunction(){
		$('.event_card').on("click",function(){
			var id = $(this).attr("id");
			$.get('../admin_partials/event_details_modal.jsp?event_id='+id).done( function(data){
				$('#event_details_modal').html(data);
				$('#event_details_modal').modal('toggle');
				navbar_selector();
				$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
					navbar_selector();
					
				});
				$('.popover-dismiss').popover();
				$('.student-feedback-scroll').css('cssText','overflow:hidden');
				
				$('.show-more').on("click",function(){
					if($('.show-more u').text() == 'Show more'){
						$('.collapsable').css('display','block');
						$('.show-more u').text('Show less');
						$('.student-feedback-scroll').css('cssText','overflow:auto');
					}else{
						$('.collapsable').css('display','none');
						$('.student-feedback-scroll').css('cssText','overflow:hidden');
						$('.show-more u').text('Show more');
					}
				});
				$('.attendance-scroll').scroll(function(){
					var divHeight=$(this).children().length * $($(this).children()[0]).height();
					var total=(divHeight+ $(this).scrollBottom())-divHeight;
					var dd="";
					if($(this).scrollBottom() == total && $(this).scrollTop() > 0){
						dd="display: none !important;";
					}else{
						dd="display: block !important;";
					}
					$(this).parent().find('.fadeout-area').css('cssText',dd);
			    });
			});
			
		});
	}
	
	
	
	function navbar_selector(){
		$('.nav.nav-tabs li').css('cssText','background-color: #eefef;box-shadow:inset 0 -2px 0 0  #f7f7f7;');
		$('.nav.nav-tabs li>a').css('cssText','background-color:#f7f7f7 !important;color:rgba(153, 153, 153, 0.7)  !important;');
		$('.nav.nav-tabs li>.active').parent().css('cssText','background-color: #ffffff;box-shadow: inset 0 -2px 0 0 #eb384f;');
		$('.nav.nav-tabs li>.active').css('cssText','background-color: #ffffff !important;color:#eb384f !important;');
	}
	
	function checkitem($this) // check function
	{
		if ($this.find('.carousel-inner .carousel-item:first').hasClass('active')) {
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