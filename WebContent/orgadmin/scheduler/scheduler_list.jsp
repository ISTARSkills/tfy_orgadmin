<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>
<%@page import="com.talentify.admin.services.AdminUIServices"%>


<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="org_scheduler">
	<%
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		int orgId = (int) request.getSession().getAttribute("orgId");
		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());
		if (cp == null) {
			flag = true;
			request.setAttribute("msg", "User Does Not Have Permission To Access");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
		request.setAttribute("cp", cp);
		AdminUIServices uiservices=new AdminUIServices();
		String	admin_rest_url = (AppProperies.getProperty("admin_rest_url"));

	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<ol class="nav breadcrumb  mt-lg-5 gray-bg" >
				<li class="breadcrumb-item List"><a href="/orgadmin/scheduler/scheduler_list.jsp" class=" selected_report bottom">List</a></li>
				<li class="breadcrumb-item List"><a href="/orgadmin/scheduler/scheduler_month.jsp" class="unselected_report">Month</a></li>
			</ol>
			
		</div>
		<div class="container">
		<div style=" border-radius: 4px;background-color: rgba(216, 216, 216, 0.05);box-shadow: 0 10px 24px 0 rgba(0, 0, 0, 0.05), 0 6px 8px 0 rgba(0, 0, 0, 0.04);">
		<div class="row m-0 pt-sm-3 pb-sm-3" style="background: white; display: flex;align-items: center;">
			<div class="col-md-2 pr-0">
			<div class="row m-0">
			
			
			<img src="/assets/images/calendar2x.png" alt="image"  id='daterange' class="calendar_open calendar-icon mr-4">
			<i class="fa fa-long-arrow-left custom-arrow-style"  aria-hidden="true"></i> <h2 class="calendar-date-size mx-auto mb-0" data-calStartDate='1' data-calEndDate='1'>28 July - 4 Aug</h2>
			<i class="fa fa-long-arrow-right custom-arrow-style"  aria-hidden="true"></i>	
			</div>		
			</div>
			<div class="col-md-3 m-0">
						<div class="row m-0"><label class="calendar-session-type-label mx-auto my-auto">Session type</label>
			
			<select class="calendar-sessiontype-dropdown" id="session-select" data-college_id="<%=orgId%>">
								<option value="session">Session</option>
					<option value="assessment">Assessment</option>
					
							
							</select>
							
							</div>
			</div>
			<div class="col-md-3 m-0 ">
						<div class="row m-0"><label class="calendar-session-type-label mx-auto my-auto">Courses</label>
			<select class="calendar-role-dropdown" id="role-select">
			                                <option value="0">All</option>
								<%	
										ArrayList<Course> courses = uiservices.getCoursesInCollege(orgId);
										for(Course course : courses)
										{
										%>
										<option value="<%=course.getId()%>"><%=course.getCourseName().trim()%></option>
										<%
										} %>
							</select></div>
			</div>
			<div class="col-md-4 custom-no-padding p-2">
            <!-- <a class="filterbutton btn btn-default green-border default-border-dashboard" ><i class="fa fa-circle green-dot" aria-hidden="true"></i>Ongoing</a>
            <a class="filterbutton btn btn-default blue-border default-border-dashboard" ><i class="fa fa-circle blue-dot" aria-hidden="true"></i>Scheduled</a>
            <a class="filterbutton btn btn-default red-border default-border-dashboard" ><i class="fa fa-circle red-dot" aria-hidden="true"></i>Completed</a>
            <a class="filterbutton btn btn-default default-border-dashboard" data-type='clearall'><i class="fa fa-circle default-dot" aria-hidden="true"></i>All</a> -->
            <a class="filterbutton btn btn-default green-border-dashboard" data-type='ongoing'><i class="fa fa-circle green-dot"  aria-hidden="true"></i>Ongoing</a> 
            <a class="filterbutton btn btn-default blue-border-dashboard" data-type='scheduled'><i class="fa fa-circle blue-dot"  aria-hidden="true"></i>Scheduled</a> 
            <a class="filterbutton btn btn-default red-border-dashboard" data-type='completed'><i class="fa fa-circle red-dot"  aria-hidden="true"></i>Completed</a>
            <a class="filterbutton btn btn-default default-border-dashboard" data-type='clearall'><i class="fa fa-circle default-dot" aria-hidden="true"></i>All</a>
			</div>


			</div>
			<div class="row m-0">
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Monday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Tuesday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Wednesday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Thursday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Friday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Saturday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Sunday</div>
			</div>
			<div class="row m-0 p-0 " id="calendar_holder"  data-url='<%=admin_rest_url%>'>
			
		
			</div>
		</div>
	</div>
	</div>
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
	$(document).ready(function() { 
	
		   
	$('.applyBtn').click(function (){    
		
		
	});
		

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