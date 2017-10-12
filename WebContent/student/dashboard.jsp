<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>

<body id="student_dashbard" ng-app="student_dashbard" ng-controller="student_dashbardCtrl">
	<%
		boolean flag = false;
		
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());
		if (cp == null) {
			flag = true;
			request.setAttribute("msg", "User Does Not Have Permission To Access");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
		request.setAttribute("cp", cp);
		StudentTrainerDashboardService studentsrainerdashboardservice = new StudentTrainerDashboardService();
		String	t2c_path = (AppProperies.getProperty("t2c_path"))+"/t2c/";
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row justify-content-md-center custom-no-margins">
				<%
				int countofcompletedTask = 0;
				int countoftotalTask = 0;
				if(cp.getEventsToday().size() != 0){
					countoftotalTask = cp.getEventsToday().size();
					for (DailyTaskPOJO dt : cp.getEventsToday()) {
						if (dt.getStatus().equalsIgnoreCase("COMPLETED")) {
							countofcompletedTask++;
						}
					}
					
				}
										  																								
				%>

				<div class='col-md-6 custom-no-padding'>
					<h1 class='custom-dashboard-header'>Today's Task</h1>
				</div>
				<div class='col-md-6 col-md-auto'>

					<h1 class='custom-task-counter' ng-init='countOfTaskCompeleted()' data-toggle="modal" data-target="#gridSystemModal"><%=countofcompletedTask%>
						of
						<%=countoftotalTask%>
						Tasks Completed
					</h1>
				</div>


			</div>
		</div>
		<!--/row-->
		<div class="container">
			<div id="carouselExampleControls" class="carousel slide" data-ride="carousel" data-interval="false">


				<%=studentsrainerdashboardservice.DashBoardCard(cp)%>


			</div>
		</div>

		<div class="container custom-dashboard-calender custom-scroll-holder" style="padding: 0px">


			<div class="row  pt-sm-3" style="background: white; display: flex; align-items: center;">

				<div class="col-md-3 m-0">
					<div class="row m-2">

						<div class="dropdown show calendar-sessiontype-dropdown">
							<a class="btn btn-secondary dropdown-toggle" style="font-family: avenir-light; font-size: 16px; text-align: left; color: #4a4a4a; font-weight: bolder; border-color: #fff; background-color: #fff;" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">July</a>

							<div class="dropdown-menu" style="width: 130px; font-size: 15px; text-align: left;" aria-labelledby="dropdownMenuLink">
								<a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='0'>January</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='1'>February </a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='2'>March</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='3'>April</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='4'>March</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='5'>June</a> <a
									style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='6'>July</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='7'>August</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='8'>September</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='9'>October</a> <a style="border-bottom: 1px solid lightgrey;" class="dropdown-item custom-month_drop" data-monthVal='10'>November</a> <a class="dropdown-item custom-month_drop" data-monthVal='11'>December</a>
							</div>
						</div>


					</div>
				</div>
			</div>
			<div id="userCalendarDataHolder"></div>
		</div>
	</div>




	<div id="gridSystemModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="gridModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content custom-modal-content">
				<div class="modal-header custom-modal-header">
				
				<%
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat time = new SimpleDateFormat("hh:mm a");
				List<TaskSummaryPOJO> filteredList = new ArrayList<>();
				if (cp.getTasks().size() != 0) {
					
					for (TaskSummaryPOJO dt : cp.getTasks()) {
						if(dt.getCompletedDate() !=null){
							
						if ((sdf.parse(sdf.format(dt.getCompletedDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0) && dt.getStatus().equalsIgnoreCase("COMPLETED")) {
							
							filteredList.add(dt);
						}
					}
					}
				}
				
				
				
				%>
				
					<h5 class="modal-title custom-modal-title" id="gridModalLabel"><%=filteredList.size()%>
						Tasks Completed
					</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body custom-scrollbar custom-scroll-holder" style="overflow: auto;">
					<div class="container">

						<%
							
							if (filteredList != null && filteredList.size() != 0) {

								for (TaskSummaryPOJO dt1 : filteredList) {

									String taskIcon = "/assets/images/video-icon.png";
									if (dt1.getItemType().equalsIgnoreCase("ASSESSMENT")) {

										taskIcon = "/assets/images/challenges-icon-copy.png";
									}
						%>
						<div class='row'>
							<div class='col-2'>
								<img class='card-img-top custom-task-icon' src='<%=taskIcon%>' alt=''>
							</div>
							<div class='col-10'>
								<div class='row' data-idd='<%=dt1.getCompletedDate()%>'>
									<p class='custom-task-titletext m-0'><%=dt1.getTitle()%></p>
								</div>
								<div class='row'>
									<p class='custom-task-subtitletext m-0'>
										at
										<%=time.format(dt1.getCompletedDate())%></p>
								</div>
							</div>
						</div>
						<hr>
						<%
							}
							} else {
						%>
						<img class='card-img-top custom-task-notask' src='/assets/images/note_graphic.png' alt=''>
						<h1 class='text-center text-muted custom-font-family-tag'>No Task Completed Today</h1>

						<%
							}
						%>




					</div>

				</div>
			</div>
		</div>
	</div>
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	
	<script>
		var app = angular.module("student_dashbard", []);
		app.controller("student_dashbardCtrl",function($scope, $http, $timeout) {
			
							$http.get('<%=t2c_path%>user/<%=user.getId()%>/complex').then(function(res) {

												$scope.courses = res.data.studentProfile;
												$scope.notifications = res.data.notifications;
												$scope.tasks = res.data.tasks;
												

											});
							
							$scope.countOfTaskCompeleted = function (){
								
								 var currentdate = "2017-09-28 21:59:00";
								 
								 for (i = 0; i < $scope.tasks.length; i++) {
									    if (currentdate > $scope.tasks[i].date) {
									            console.log('today');
									    }
									  }
								
							};
						

						});
	</script>
	
	
	
	<%-- <script>
	 var  d = new Date();
	 var day = d.getDate();
	
	 var m_names = ['January', 'February', 'March', 
         'April', 'May', 'June', 'July', 
         'August', 'September', 'October', 'November', 'December'];
	 var n = m_names[d.getMonth()]; 
		$(document).ready(function() {
			$('.carousel').carousel('pause');
			$('.popover-dismiss').popover();
         
		    $('#dropdownMenuLink').text(n);
		    calendarFunction(d.getMonth())
			$('.custom-month_drop').click(function(){				
				$('#dropdownMenuLink').text($(this).text());		
				  calendarFunction($(this).attr('data-monthVal'));
			});
			
			
		});
		
		
		function calendarFunction(month){
			var monthIndex = parseInt(month);
			 $('#userCalendarDataHolder').empty();
			$("#userCalendarDataHolder").append('<div class="loader mx-auto my-auto"></div>');
			 $.ajax({
				    url:"../get_user_service", 
				    data : {monthIndex:monthIndex,user_id:<%=user.getId()%>},
				    success:function(data) {
				     //custom-calendar-item-colums
				      $('#userCalendarDataHolder').empty();
				     if($(data).find('.custom-calendar-item-colums').length != 0){
				    	
					     $('#userCalendarDataHolder').html(data);
					     $('.find_currentDate_parent').each(function(i){  
					    	 if($(this).attr('data-currentDate').substr(0,2) == day && month == d.getMonth()){
					    		 $(this).css('background','rgba(33, 150, 242, 0.7)');
					    		 $(this).css('color','#fff');
					    		 $(this).append('  Today');
					    		
					             }  
					    	 });
					   
					     $('.find_currentDate_child').each(function(j){  
					    	 if($(this).attr('data-currentDate').substr(0,2) == day && month == d.getMonth()){
					    		 $(this).css('background','rgba(33, 150, 242, 0.04)');
					    		 } 
				    		 $('.custom-dashboard-calender').animate({scrollLeft: $(this).position().center}, 500);   

					    
					     
					     
					    
					     
					     });

					    
				     }else{
				    	 $("#userCalendarDataHolder").append('<h1 class="text-center m-5">No Event Found</h1>');
				     }
				     
				    }
				  });
			
		}
	</script> --%>
</body>
</html>