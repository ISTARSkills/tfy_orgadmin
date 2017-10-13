
<jsp:include page="/inc/head.jsp"></jsp:include>

<body id="student_dashbard" ng-app="student_dashbard"
	ng-controller="student_dashbardCtrl">
	<%
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row justify-content-md-center custom-no-margins">
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
				<div class='carousel-inner' role='listbox'
					ng-if='incompletedTasks!=0'>
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

				<div class='carousel-inner' role='listbox'
					ng-if='incompletedTasks==0'>

					<div class='carousel-item active'>
						<div class='row custom-no-margins'>
							<div class='col-12 custom-no-padding custom-colmd-css'>
								<div class='card custom-cards_css mx-auto'>
									<div class='row mx-auto'>
										<h1
											class=' text-muted text-center mx-auto custom-font-family-tag '>
											You don't have any tasks lined up for today.</h1>
									</div>
									<div class='row mx-auto my-auto'>
										<img class='card-img-top custom-notask-imgtag mx-auto'
											src='/assets/images/zzz_graphic.png' alt=''>
									</div>
									<div class='row mx-auto'>
										<h1
											class=' text-muted text-center mx-auto custom-font-family-tag'>
											Get out and have some fun.</h1>
									</div>

								</div>
							</div>
						</div>
					</div>
				</div>



				<a class='carousel-control-next custom-right-prev'
					ng-if='incompletedTasks!=0' href='#carouselExampleControls'
					role='button' data-slide='next'> <img class=''
					src='/assets/images/992180-200-copy.png' alt=''>
				</a> <a class='carousel-control-prev custom-left-prev'
					ng-if='incompletedTasks!=0' href='#carouselExampleControls'
					role='button' data-slide='prev'> <img class=''
					src='/assets/images/992180-2001-copy.png' alt=''>
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
								aria-haspopup="true" aria-expanded="false">{{currentMonth}}</a>

							<div class="dropdown-menu"
								style="width: 130px; font-size: 15px; text-align: left;"
								aria-labelledby="dropdownMenuLink">
								<a style="border-bottom: 1px solid lightgrey;"
									ng-repeat='month in m_names track by $index'
									ng-click="monthChange($index)"
									class="dropdown-item custom-month_drop" data-monthVal='$index'>{{month}}</a>
							</div>
						</div>


					</div>
				</div>
			</div>
			<div id="userCalendarDataHolder">

				<div ng-if='currentMonthDates.length!=0' class='row m-0 p-0 w-100'
					style='display: -webkit-inline-box; align-items: center; background: rgba(250, 250, 250, 0.99);'>

					<div class='' ng-repeat='day in currentMonthDates'
						style='width: 180px; display: grid; line-height: 3.5; border-right: 1px solid #eee; background: rgba(250, 250, 250, 0.99);'>

						<div class='w-100 h-100 text-center m-auto'>
							<p class='p-0 m-0 find_currentDate_parent'
								ng-style='{{todayDate(day)}}'>{{day | date: 'dd MMM'}}</p>
						</div>
					</div>



				</div>

				<div ng-if='currentMonthDates.length!=0'
					class='row m-0 p-0 custom-scroll-holder'
					style='display: -webkit-inline-box; align-items: center;'>
					<div ng-repeat='day in currentMonthDates'
						class='custom-calendar-item-colums find_currentDate_child'
						ng-style='{{todayDate(day)}}'
						style='width: 180px; border-left: 1px solid #eee;'>

						<!-- inner starts-->

						<div ng-if='map_events[day]' ng-repeat='event in map_events[day]'
							class=''
							style='border-top: 5px solid #39b26a; justify-self: start; width: 160px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>

							<div class='row calendar-event-header m-0 p-2'
								data-eventID='{{event}}'>
								<i class='fa fa-clock-o aligncenter' style='color: #2196f2;'
									aria-hidden='true'></i>
								<h2 class=' calendar-time-size  mb-0 ml-2 aligncenter'>{{startEndTime(event.startDate)|
									date: 'HH:mm'}}-{{startEndTime(event.endDate)| date: 'HH:mm'}}</h2>
							</div>

							<h1 class='w-100 cal-event-name p-2' style='font-weight: bolder;'
								ng-bind-html='formatMessage(event.name)'></h1>
							<!-- <h2 class='w-100 cal-event-batch p-2'>{{event.}}</h2> -->

						</div>

						<!-- inner end -->

					</div>
				</div>
				<h1 ng-if='currentMonthDates.length==0' class="text-center m-5">No
					Events Found</h1>
			</div>


		</div>
	</div>




	<div id="gridSystemModal" class="modal fade" tabindex="-1"
		role="dialog" aria-labelledby="gridModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content custom-modal-content">
				<div class="modal-header custom-modal-header">
					<h5 class="modal-title custom-modal-title" id="gridModalLabel">{{todayCompletedTasks.length}}
						Tasks Completed</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body custom-scrollbar custom-scroll-holder"
					style="overflow: auto;">
					<div class="container">
						<div class='row' ng-if='todayCompletedTasks.length!=0'
							ng-repeat='task in todayCompletedTasks'>
							<div class='col-2'>
								<img class='card-img-top custom-task-icon'
									src="{{(task.itemType=='ASSESSMENT'?'/assets/images/challenges-icon-copy.png':'/assets/images/video-icon.png')}}"
									alt='{{task.title}}' />
							</div>
							<div class='col-10'>
								<div class='row' data-idd='{{task.completedDate}}'>
									<p class='custom-task-titletext m-0'>{{task.title}}</p>
								</div>
								<div class='row'>
									<p class='custom-task-subtitletext m-0 w-100'>at
										{{task.completedDate}}</p>
								</div>
							</div>
						</div>
						<hr>

						<div ng-if='todayCompletedTasks.length==0'>
							<img class='card-img-top custom-task-notask'
								src='/assets/images/note_graphic.png' alt=''>
							<h1 class='text-center text-muted custom-font-family-tag'>No
								Task Completed Today</h1>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>

</body>
</html>