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
for(DailyTaskPOJO dt :cp.getEventsToday()){
	if(dt.getStatus().equalsIgnoreCase("COMPLETED")){
		countofcompletedTask ++;
	}
}

%>

<div class='col-md-6 custom-no-padding'>
				<h1 >Today's Task</h1>
			</div>	<div class='col-md-6 col-md-auto'>
			
				<h1 class='custom-task-counter' data-toggle="modal" data-target="#gridSystemModal" ><%=countofcompletedTask %> of <%=cp.getEventsToday().size() %> Tasks Completed</h1>
</div>


			</div>
		</div>
		<!--/row-->
<div class="container">
		<div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
			<div class="carousel-inner" role="listbox">
			
			
			<%= studentsrainerdashboardservice.DashBoardCard(cp) %>
				
				</div>
				
			
			 <a class="carousel-control-next custom-right-prev" href="#carouselExampleControls"
				role="button" data-slide="next"> <img class="" src="/assets/images/992180-200-copy.png" alt="">
			</a>
			<a class="carousel-control-prev custom-left-prev" href="#carouselExampleControls"
				role="button" data-slide="prev"> <img class="" src="/assets/images/992180-2001-copy.png" alt="">
			</a>
		</div></div>
</div>
		<div id="gridSystemModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="gridModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content custom-modal-content">
      <div class="modal-header custom-modal-header">
        <h5 class="modal-title custom-modal-title" id="gridModalLabel">5 Tasks Completed</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
      </div>
      <div class="modal-body custom-no-padding">
        <div class="container-fluid bd-example-row">
         <div class='row '>
         <div class='col-md-2 col-md-auto justify-content-md-center'>
        <img class='card-img-top custom-task-icon'src='/assets/images/video-icon.png' alt=''>
         </div>
         <div class='col-md-6 col-md-auto'>
          <p class='custom-task-titletext custom-no-margins' >Assessing Risk</p>
            <p class='custom-task-subtitletext custom-no-margins' >at 11:51 AM</p>
         </div>
         
          </div>
          <hr>
          <div class='row'>
         <div class='col-md-2 col-md-auto'>
         <img class='card-img-top custom-task-icon'src='/assets/images/challenges-icon-copy.png' alt=''>
         </div>
         <div class='col-md-6 col-md-auto'>
          <p class='custom-task-titletext custom-no-margins'  >Won against Siddharth</p>
            <p class='custom-task-subtitletext custom-no-margins' >at 11:51 AM</p>
         </div>
         
          </div>
          <hr>
          <div class='row'>
         <div class='col-md-2 col-md-auto'>
         <img class='card-img-top custom-task-icon'src='/assets/images/video-icon.png' alt=''>
         </div>
         <div class='col-md-6 col-md-auto'>
          <p class='custom-task-titletext custom-no-margins' >Assessing Risk</p>
            <p class='custom-task-subtitletext custom-no-margins' >at 11:51 AM</p>
         </div>
         
          </div>
           <hr>
        <div class='row'>
         <div class='col-md-2 col-md-auto'>
         <img class='card-img-top custom-task-icon'src='/assets/images/challenges-icon-copy.png' alt=''>
         </div>
         <div class='col-md-6 col-md-auto'>
          <p class='custom-task-titletext custom-no-margins'  >Won against Siddharth</p>
            <p class='custom-task-subtitletext' >at 11:51 AM</p>
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
		   $('.carousel').carousel('pause');
		});
</script>
</body>
</html>