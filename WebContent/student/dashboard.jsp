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
					<h1>Today's Task</h1>
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
									if ((sdf.parse(sdf.format(dt.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0)) {									
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
						<h1 class='text-center text-muted custom-font-family-tag'>No Task For Today</h1>

						<%
							}
						%>




					</div>

				</div>
			</div>
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