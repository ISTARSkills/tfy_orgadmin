<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>

<body id="student_dashbard">
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
		StudentTrainerDashboardService studentsrainerdashboardservice = new StudentTrainerDashboardService();
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row justify-content-md-center custom-no-margins">
				<%
					int countofcompletedTask = 0;
					for (DailyTaskPOJO dt : cp.getEventsToday()) {
						if (dt.getStatus().equalsIgnoreCase("COMPLETED")) {
							countofcompletedTask++;
						}
					}
				%>

				<div class='col-md-6 custom-no-padding'>
					<h1 class='custom-dashboard-header'>Today's Task</h1>
				</div>
				<div class='col-md-6 col-md-auto'>

					<h1 class='custom-task-counter' data-toggle="modal" data-target="#gridSystemModal"><%=countofcompletedTask%>
						of
						<%=cp.getEventsToday().size()%>
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
		
		<div class="container custom-dashboard-calender custom-scroll-holder">
		
		
		<div class="row  pt-sm-3 pb-sm-3" style="background: white; display: flex;align-items: center;">
			
			<div class="col-md-3 m-0">
						<div class="row m-0">
			
			<select class="calendar-sessiontype-dropdown" id="event-select">
								<option>January</option>
								<option>February</option>
								<option>March</option>
								<option>April</option>
								<option>March</option>
								<option>April</option>
								<option>June</option>
								<option>July</option>
								<option>August</option>
								<option>September</option>
								<option>October</option>
								<option>November</option>
								<option>December</option>
							</select></div>
			</div>
			</div>
		
			<div class="row " >
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center lightgray-bg">Monday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center lightgray-bg">Tuesday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center lightgray-bg">Wednesday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center lightgray-bg">Thursday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center lightgray-bg">Friday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center lightgray-bg">Saturday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center lightgray-bg">Sunday</div>
			</div>
			<div class="row " style="background-color: #fff;">
			<div class="custom-col-md-7 mx-auto text-center p-0 ">
			
			<%for(int i=0; i <5 ; i++){ 
				String top_border = "top-border-green";
				if(i%2 == 0){
					top_border ="top-border-blue";
				}else if(i % 3 ==0){
					top_border ="top-border-red";
				}
			
			%>
			
			<div id="homepageNotification" class=" mt-1 mx-auto text-center  panel panel-default panel-floating panel-floating-fixed animated px-0 <%=top_border%>">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %>
			
			
			</div>
			<div class="custom-col-md-7  mx-auto text-center p-0 ">
			
			<%for(int i=0; i <5; i++){ %>
			<div id="homepageNotification" class="mt-1 mx-auto text-center  panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2 mx-auto text-center" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %>
			
			</div>
			<div class="custom-col-md-7 mx-auto text-center p-0">
			<%for(int i=0; i <5 ; i++){ %>
			<div id="homepageNotification" class="mt-1 mx-auto text-center panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %>
			</div>
			<div class="custom-col-md-7 mx-auto text-center p-0">
			<%for(int i=0; i <5 ; i++){ %>
			<div id="homepageNotification" class="mt-1 mx-auto text-center panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %>
			</div>
			<div class="custom-col-md-7 mx-auto text-center p-0">
			<%for(int i=0; i <5 ; i++){ %>
			<div id="homepageNotification" class="mt-1 mx-auto text-center panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %></div>
			<div class="custom-col-md-7 mx-auto text-center p-0">
			<%for(int i=0; i <5 ; i++){ %>
			
			
			<div id="homepageNotification" class="mt-1 mx-auto text-center  panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %></div>
			<div class="custom-col-md-7 mx-auto text-center p-0">
			<%for(int i=0; i <5 ; i++){ %>
			<div id="homepageNotification" class="mt-1 mx-auto text-center panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %></div>
			</div>
		</div>
	</div>
	
	
	
	
	<div id="gridSystemModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="gridModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content custom-modal-content">
				<div class="modal-header custom-modal-header">
					<h5 class="modal-title custom-modal-title" id="gridModalLabel"><%=countofcompletedTask%>
						Tasks Completed
					</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body custom-no-padding custom-scrollbar">
					<div class="container">

						<%
						List<TaskSummaryPOJO> filteredList = new ArrayList<>();
							if (cp.getTasks().size() != 0) {
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
								for (TaskSummaryPOJO dt : cp.getTasks()) {                                 
									if ((sdf.parse(sdf.format(dt.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0) && dt.getStatus().equalsIgnoreCase("COMPLETED")) {									
										filteredList.add(dt);
									       }
									}
							}
								if(filteredList != null && filteredList.size() !=0 ){
									
									for (TaskSummaryPOJO dt : filteredList) {
										
										String taskIcon = "/assets/images/video-icon.png";
										if (dt.getItemType().equalsIgnoreCase("ASSESSMENT")) {

											taskIcon = "/assets/images/challenges-icon-copy.png";
										}
						%>
						<div class='row '>
							<div class='col-2'>
								<img class='card-img-top custom-task-icon' src='<%=taskIcon%>' alt=''>
							</div>
							<div class='col-10'>
								<div class='row'>
									<p class='custom-task-titletext m-0'><%=dt.getTitle()%></p>
								</div>
								<div class='row'>
									<p class='custom-task-subtitletext m-0'>
										at
										<%=dt.getTime()%></p>
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
			</div></div>
		</div>
		<!--/row-->

		<jsp:include page="/inc/foot.jsp"></jsp:include>
		<script>
			$(document).ready(function() {
				$('.carousel').carousel('pause');
			});
		</script>
</body>
</html>