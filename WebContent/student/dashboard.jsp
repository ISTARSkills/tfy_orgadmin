<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>

<body id="student_dashbard" ng-app="student_dashbard"
	ng-controller="student_dashbardCtrl">
	<%
		boolean flag = false;

		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		IstarUser user = (IstarUser) request.getSession().getAttribute("user");

		String t2c_path = (AppProperies.getProperty("t2c_path")) + "/t2c/";
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row justify-content-md-center custom-no-margins">
				<%-- <%
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
										  																								
				%> --%>

				<div class='col-md-6 custom-no-padding'>
					<h1 class='custom-dashboard-header'>Today's Task</h1>
				</div>
				<div class='col-md-6 col-md-auto'>

					<h1 class='custom-task-counter'
						ng-init='completed="0 of 0 tasks Completed"' data-toggle="modal"
						data-target="#gridSystemModal">{{completed}}</h1>
				</div>


			</div>
		</div>
		<!--/row-->
		<div class="container">
			<div id="carouselExampleControls" class="carousel slide"
				data-ride="carousel" data-interval="false">
				<div class='carousel-inner' role='listbox'>
					<div class='carousel-item' ng-class='($index == 0 ? "active":"")'
						dashbord-task-directive
						ng-repeat='task in incompletedTasks track by $index'>
						<div class='row custom-no-margins'>
							<!-- inner start -->
							<div class='col custom-no-padding custom-colmd-css'
								ng-repeat='item in task track by $index'>
								<div class='card custom-cards_css'>

									<h6
										class='card-subtitle custom-card-subtitle mb-2 text-muted popover-dismiss'
										data-toggle='popover' data-trigger='hover'
										data-placement='top' data-content='{{item.header}}'>{{(item.header.length>25?item.header.substring(0,
										25)+"...":item.header)}}</h6>
									<h4 class='card-title custom-card-title popover-dismiss'
										data-toggle='popover' data-trigger='hover'
										data-placement='top' data-content='{{item.title}}'>{{(item.title.length>25?item.title.substring(0,
										25)+"...":item.title)}}</h4>


									<img ng-if="item.itemType == 'LESSON_PRESENTATION' "
										class='card-img-top custom-primary-img'
										src='{{item.imageURL}}' alt='{{item.title}}'> <img
										ng-if="item.itemType == 'ASSESSMENT' "
										class='card-img-top custom-primary-img'
										src="{{cdnPath+'course_images/assessment.png'}}"
										alt='{{item.title}}'> <img
										ng-if="item.itemType == 'CUSTOM_TASK' "
										class='card-img-top custom-primary-img'
										src='{{item.imageURL}}' alt='{{item.title}}'>


									<p class='card-text custom-card-text'>{{item.description}}</p>


									<div ng-switch='item.itemType'>
										<a ng-switch-when='ASSESSMENT' href='#'
											class='btn btn-danger custom-primary-btn btn-round-lg btn-lg'><img
											class='card-img-top custom-secoundary-img'
											src='/assets/images/ic_assignment_white_48dp.png' alt=''><span
											class='custom-primary-btn-text'>START ASSESSMENT</span></a> <a
											ng-switch-when='LESSON_PRESENTATION'
											href='/student/presentation.jsp?task_id={{item.id}}&lesson_id={{item.itemId}}'
											class='btn btn-danger custom-primary-btn btn-round-lg btn-lg'><img
											class='card-img-top custom-secoundary-img'
											src='/assets/images/presentation-icon.png' alt=''><span
											class='custom-primary-btn-text'>WATCH PRESENTATION</span></a> <a
											ng-switch-when='CUSTOM_TASK' href='#'
											class='btn btn-danger custom-primary-btn btn-round-lg btn-lg'><img
											class='card-img-top custom-secoundary-img'
											src='/assets/images/ic_assignment_white_48dp.png' alt=''><span
											class='custom-primary-btn-text'>START TASK</span></a>
									</div>
								</div>
							</div>


							<!-- inner end -->
						</div>
					</div>
				</div>
				<a class='carousel-control-next custom-right-prev'
					href='#carouselExampleControls' role='button' data-slide='next'>
					<img class='' src='/assets/images/992180-200-copy.png' alt=''>
				</a> <a class='carousel-control-prev custom-left-prev'
					href='#carouselExampleControls' role='button' data-slide='prev'>
					<img class='' src='/assets/images/992180-2001-copy.png' alt=''>
				</a>

			</div>


		</div>
		<div class="container custom-dashboard-calender custom-scroll-holder"
			style="padding: 0px">


			<div class="row  pt-sm-3"
				style="background: white; display: flex; align-items: center;">

				<div class="col-md-3 m-0">
					<div class="row m-2">

						<div class="dropdown show calendar-sessiontype-dropdown">
							<a class="btn btn-secondary dropdown-toggle"
								style="font-family: avenir-light; font-size: 16px; text-align: left; color: #4a4a4a; font-weight: bolder; border-color: #fff; background-color: #fff;"
								id="dropdownMenuLink" data-toggle="dropdown"
								aria-haspopup="true" aria-expanded="false">July</a>

							<div class="dropdown-menu"
								style="width: 130px; font-size: 15px; text-align: left;"
								aria-labelledby="dropdownMenuLink">
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='0'>January</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='1'>February
								</a> <a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='2'>March</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='3'>April</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='4'>March</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='5'>June</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='6'>July</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='7'>August</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='8'>September</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='9'>October</a>
								<a style="border-bottom: 1px solid lightgrey;"
									class="dropdown-item custom-month_drop" data-monthVal='10'>November</a>
								<a class="dropdown-item custom-month_drop" data-monthVal='11'>December</a>
							</div>
						</div>


					</div>
				</div>
			</div>
			<div id="userCalendarDataHolder"></div>
		</div>
	</div>




	<%-- <div id="gridSystemModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="gridModalLabel">
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
	</div> --%>
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>

	<%-- <script>
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
	</script> --%>



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