<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="org_scheduler_month">
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
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		String yearInString = String.valueOf(year);
		int month_nos =Calendar.getInstance().get(Calendar.MONTH);
		String monthString = "";
        switch (month_nos) {
            case 1:  monthString = "January";       break;
            case 2:  monthString = "February";      break;
            case 3:  monthString = "March";         break;
            case 4:  monthString = "April";         break;
            case 5:  monthString = "May";           break;
            case 6:  monthString = "June";          break;
            case 7:  monthString = "July";          break;
            case 8:  monthString = "August";        break;
            case 9:  monthString = "September";     break;
            case 10: monthString = "October";       break;
            case 11: monthString = "November";      break;
            case 12: monthString = "December";      break;
            default: monthString = "Invalid month"; break;
        }
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<ol class="nav breadcrumb  mt-lg-5 gray-bg" >
				<li class="breadcrumb-item List"><a href="#" class=" unselected_report bottom">List</a></li>
				<li class="breadcrumb-item List"><a href="#" class="selected_report">Month</a></li>
			</ol>
			
		</div>
		<div class="container">
		<div class="row m-0 pt-sm-3 pb-sm-3" style="background: white; display: flex;align-items: center;">
			<div class="col-md-2 pr-0">
			<div class="row m-0">
			
			
			<i class="fa fa-long-arrow-left custom-arrow-style" aria-hidden="true"></i> 
			<h2 class="calendar-date-size mx-auto mb-0" data-currentyear="<%=yearInString %>" data-monthnos="<%=month_nos-1 %>"><%=monthString %> <%=yearInString %></h2>
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
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Monday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Tuesday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Wednesday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Thursday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Friday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Saturday</div>
			<div class="custom-col-md-7 m-0 pt-4 pb-4 text-center">Sunday</div>
			</div>
			<div  id="main-content">
				
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