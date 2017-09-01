<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="org_scheduler">
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
			<ol class="nav breadcrumb  mt-lg-5 gray-bg" >
				<li class="breadcrumb-item List"><a href="#" class=" selected_report bottom">List</a></li>
				<li class="breadcrumb-item List"><a href="#" class="unselected_report">Month</a></li>
			</ol>
			
		</div>
		<div class="container">
		<div class="row m-0 pt-sm-3 pb-sm-3" style="background: white; display: flex;align-items: center;">
			<div class="col-md-2 pr-0">
			<div class="row m-0">
			
			
			<img src="/assets/images/calendar2x.png" alt="image"  id='daterange' class="calendar_open calendar-icon mr-4">
			<i class="fa fa-long-arrow-left custom-arrow-style" aria-hidden="true"></i> <h2 class="calendar-date-size mx-auto mb-0">28 July - 4 Aug</h2>
			<i class="fa fa-long-arrow-right custom-arrow-style" aria-hidden="true"></i>	
			</div>		
			</div>
			<div class="col-md-3 m-0">
						<div class="row m-0"><label class="calendar-session-type-label mx-auto my-auto">Session type</label>
			
			<select class="calendar-sessiontype-dropdown" id="session-select">
								<option>BCom . Section 1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select></div>
			</div>
			<div class="col-md-3 m-0 ">
						<div class="row m-0"><label class="calendar-session-type-label mx-auto my-auto">Roles</label>
			<select class="calendar-role-dropdown" id="role-select">
								<option>BCom . Section 1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select></div>
			</div>
			<div class="col-md-4 custom-no-padding p-2">
            <a class="btn btn-default green-border" ><i class="fa fa-circle green-dot" aria-hidden="true"></i>Ongoing</a>
            <a class="btn btn-default blue-border" ><i class="fa fa-circle blue-dot" aria-hidden="true"></i>Scheduled</a>
            <a class="btn btn-default red-border" ><i class="fa fa-circle red-dot" aria-hidden="true"></i>Completed</a>
			</div>


			</div>
			<div class="row m-0">
			<div class="col-md-7 m-0 pt-4 pb-4 text-center">Monday</div>
			<div class="col-md-7 m-0 pt-4 pb-4 text-center">Tuesday</div>
			<div class="col-md-7 m-0 pt-4 pb-4 text-center">Wednesday</div>
			<div class="col-md-7 m-0 pt-4 pb-4 text-center">Thursday</div>
			<div class="col-md-7 m-0 pt-4 pb-4 text-center">Friday</div>
			<div class="col-md-7 m-0 pt-4 pb-4 text-center">Saturday</div>
			<div class="col-md-7 m-0 pt-4 pb-4 text-center">Sunday</div>
			</div>
			<div class="row m-0 p-0 ">
			<div class="col-md-7 m-0 text-center">
			
			<%for(int i=0; i <10 ; i++){ 
				String top_border = "top-border-green";
				if(i%2 == 0){
					top_border ="top-border-blue";
				}else if(i % 3 ==0){
					top_border ="top-border-red";
				}
			
			%>
			
			<div id="homepageNotification" class="panel panel-default panel-floating panel-floating-fixed animated px-0 <%=top_border%>">
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
			<div class="col-md-7 m-0  text-center">
			
			<%for(int i=0; i <10 ; i++){ %>
			<div id="homepageNotification" class="panel panel-default panel-floating panel-floating-fixed animated px-0">
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
			<div class="col-md-7 m-0 text-center">
			<%for(int i=0; i <10 ; i++){ %>
			<div id="homepageNotification" class="panel panel-default panel-floating panel-floating-fixed animated px-0">
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
			<div class="col-md-7 m-0  text-center">
			<%for(int i=0; i <10 ; i++){ %>
			<div id="homepageNotification" class="panel panel-default panel-floating panel-floating-fixed animated px-0">
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
			<div class="col-md-7 m-0 text-center">
			<%for(int i=0; i <10 ; i++){ %>
			<div id="homepageNotification" class="panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %></div>
			<div class="col-md-7 m-0  text-center">
			<%for(int i=0; i <10 ; i++){ %>
			
			
			<div id="homepageNotification" class="panel panel-default panel-floating panel-floating-fixed animated px-0">
 		   <div class="row calendar-event-header m-0 p-2" >
 		   <i class="fa fa-clock-o aligncenter" aria-hidden="true"></i> <h2 class=" calendar-time-size mx-auto mb-0 aligncenter">28 July - 4 Aug</h2>
			<i class="fa fa-video-camera aligncenter" aria-hidden="true"></i>	
 		   </div>
 		   <h2 class="w-100 cal-event-name p-2">opertation bank 2</h2>
       		   <h2 class="w-100 cal-event-batch p-2">FY Bcom . Section 1</h2>
       		   <h2 class="w-100 cal-event-trainer p-2">By Sandeep Sharma</h2>
      
  			</div>
			<%} %></div>
			<div class="col-md-7 m-0  text-center">
			<%for(int i=0; i <10 ; i++){ %>
			<div id="homepageNotification" class="panel panel-default panel-floating panel-floating-fixed animated px-0">
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
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
	$(document).ready(function() {
	
		   
	
		

		$('.breadcrumb-item').click(function (){
			 $('.breadcrumb-item').each(function(index){
				  $(this).children().removeClass('bottom');
			  });
				$(this).children().addClass('bottom');

		});
		 
		});
</script>
</body>
</html>