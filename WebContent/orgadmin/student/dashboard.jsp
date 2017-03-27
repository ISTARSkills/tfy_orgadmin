<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="in.orgadmin.utils.TrainerUtils"%>
<%@page import="in.orgadmin.utils.BatchUtils"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.math.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.hibernate.Query"%>
<%@page import="in.orgadmin.utils.BatchGroupUtils"%>






<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Portal | User Dashboard</title>
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />
<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>
<!-- DataTable -->
<link href="<%=baseURL%>css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css">
<link
	href="<%=baseURL%>css/plugins/dataTables/editor.dataTables.min.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>css/jquery.contextMenu.css" rel="stylesheet"
	type="text/css" />
	
	<link
	href="<%=baseURL%>css/plugins/daterangepicker/daterangepicker-bs3.css"
	rel="stylesheet">
	

</head>

<body class="fixed-sidebar no-skin-config full-height-layout">
	<%
	
	String drange="";
	String start_date="";
	String end_date="";
	String trainer_id="";
	
	
	
	
		
		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd");

		 
	
	
	if(request.getParameterMap().containsKey("daterange"))
	{
		System.out.println(request.getParameter("daterange"));
		drange = request.getParameter("daterange");
		start_date = drange.split("-")[0].trim();
		end_date = drange.split("-")[1].trim();
		 
		  start_date = formatter1.format(formatter.parse(start_date));
		  end_date = formatter1.format(formatter.parse(end_date));
		 
		 
		 System.out.println(start_date+"---------------------------------"+end_date);
	}
	
	OrgadminUtil ou = new OrgadminUtil();
	Student student = new Student();
	String user_id = "";
	if(request.getParameterMap().containsKey("student_id") ){
		
		user_id = request.getParameter("student_id");
				
	
	}else if(request.getParameterMap().containsKey("trainer_id")){
		
		user_id = request.getParameter("trainer_id");
						
		
	}else if(request.getParameterMap().containsKey("user_id")){
		
		user_id = request.getParameter("user_id");
						
		
	}
	//Integer user_id1 = Integer.valueOf(user_id);
	student = new StudentDAO().findById(Integer.valueOf(user_id));
	StudentProfileData profile = student.getStudentProfileData();
     
     String mobileNo ="N/A";
     String Aadharno = "N/A";
     String Gender = "N/A";
     String Fname = "N/A";
     String Lname = "N/A";
     String UGSName = "N/A";
     String PGSName = "N/A";
     String SFADegree = "N/A";
     String ITCourse = "N/A";
     String AOInterest = "N/A";
     String date ="N/A";
     

     if(student.getStudentProfileData()!=null)
     {
    	 if(profile.getAadharno()!=null)
         {
        	 Aadharno = profile.getAadharno()+""; 
         } 
         
          if(profile.getMobileno()!=null)
         {
         	mobileNo = profile.getMobileno()+""; 
         }
    	 
          if(profile.getGender()!=null)
          {
        	  Gender = profile.getGender(); 
          }
         
          if(profile.getFirstname()!=null)
          {
        	  Fname = profile.getFirstname(); 
          }
          if(profile.getLastname()!=null)
          {
        	  Lname = profile.getLastname(); 
          }
          if(profile.getUnderGraduationSpecializationName()!=null)
          {
        	  UGSName =  profile.getUnderGraduationSpecializationName(); 
          }
          if( profile.getPostGraduationSpecializationName()!=null)
          {
        	  PGSName =   profile.getPostGraduationSpecializationName(); 
          }
          
          if( profile.getIsStudyingFurtherAfterDegree()!=null)
          {
        	  SFADegree =  profile.getIsStudyingFurtherAfterDegree()+""; 
          }
          if(  profile.getInterestedInTypeOfCourse()!=null)
          {
        	  ITCourse =   profile.getInterestedInTypeOfCourse(); 
          }
          if(profile.getAreaOfInterest()!=null)
          {
        	  AOInterest =   profile.getAreaOfInterest(); 
          }
          

if(profile.getDob() != null){
	String pattern = "dd-MM-yyyy";
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

	 date = simpleDateFormat.format(profile.getDob());
	
}
    	 
     }
     
     
   

DatatableUtils dtUtils = new DatatableUtils();
HashMap<String, String> conditions = new HashMap<>();
TrainerUtils util = new TrainerUtils();





%>


	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg" style="height: auto;">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>

			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>Profile</h2>

				</div>
				<div class="col-lg-2"></div>

			</div>

			<div class="wrapper wrapper-content">
				<div class="row animated fadeInRight">
					<div class="col-md-4">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Profile Detail</h5>
							</div>
							<div>
								<div class="ibox-content no-padding border-left-right">
									<img alt="image" class="img-responsive"
										src="img/profile_big.jpg">
								</div>
								<div class="ibox-content profile-content">
									<h4>
										<strong><%=student.getName()%></strong>
									</h4>
									<p>
										<i class="fa fa-map-marker"></i>
										<%=student.getAddress().getAddressline1()%><%=student.getAddress().getAddressline2()%>
										<%=student.getAddress().getPincode().getCity()%>
										<%=student.getAddress().getPincode().getState()%>
										<%=student.getAddress().getPincode().getCountry()%>
										<%=student.getAddress().getPincode().getPin()%></p>
									<ul class="list-group clear-list">
										<li class="list-group-item fist-item"><span
											class="pull-right"><%=student.getCollege().getName()%></span>
											College:</li>
										<li class="list-group-item"><span class="pull-right">
												<%=student.getEmail()%>
										</span> Email Id:</li>
										<li class="list-group-item"><span class="pull-right"><%=Fname%></span>
											First Name:</li>
										<li class="list-group-item"><span class="pull-right">
												<%=Lname %></span> Last Name:</li>
										<li class="list-group-item"><span class="pull-right"><%=Gender%></span>
											Gender:</li>
										<li class="list-group-item"><span class="pull-right"><%=date%></span>
											DOB:</li>
										<li class="list-group-item"><span class="pull-right"><%=mobileNo%></span>
											Mobile:</li>
											
											<li class="list-group-item"><span class="pull-right"><%=Aadharno%></span>
											Aadhar Card No:</li>
										
										<li class="list-group-item"><span class="pull-right"><%=UGSName%></span>
											Under Graduation Specialization Name:</li>
									
										
											<li class="list-group-item"><span class="pull-right"><%=PGSName%>
												</span> Post Graduation Specialization Name :
										</li>
											
										
											
										<li class="list-group-item"><span class="pull-right"><%=SFADegree%>
												</span> Further Studies :
										</li>
										
										<li class="list-group-item"><span class="pull-right"><%=ITCourse%>
												</span> Interested Course :
										</li>
										<li class="list-group-item"><span class="pull-right"><%=AOInterest%>
												</span> Area Interested :
										</li>
										
										
										
										

									</ul>

									<!-- <strong>Last Activity In Class</strong>
									<div class="row m-t-lg">

										<div class="col-md-4">
											<span class="bar">Retail Banking Report</span>
											<h5>
												<strong>Score: </strong> 25
											</h5>
										</div>
										<div class="col-md-4">
											<span class="line">Retail Banking Attendance</span>
											<h5>
												<strong>28/50 </strong>Class
											</h5>
										</div>
										<div class="col-md-4">
											<span class="bar">Retail Banking</span>
											<h5>
												<strong>Session Name</strong>Accounting concept-12
											</h5>
										</div>
									</div> -->
									<!-- <div class="user-button">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <button type="button" class="btn btn-primary btn-sm btn-block"><i class="fa fa-envelope"></i> Send Message</button>
                                        </div>
                                        <div class="col-md-6">
                                            <button type="button" class="btn btn-default btn-sm btn-block"><i class="fa fa-coffee"></i> Buy a coffee</button>
                                        </div>
                                    </div>-->
                                </div> 
								</div>
							</div>
						</div>
					<div class="col-md-8">
					
					<%  if(student.getUserType().equalsIgnoreCase("STUDENT")){ %>
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Batches Associated With This Student</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">

								<div>
									<div class="feed-activity-list" style="height: auto;">

										<div class="feed-element">

											<div class="project-list">
												<h5></h5>
												<table class="table table-hover">
													<tbody>
														<%
																out.println(util.PrintStudentBatchList(student, baseURL).toString());
															%>
													</tbody>
												</table>
											</div>
										</div>


									</div>
								</div>
							</div>
						</div>
						<% } if(student.getUserType().equalsIgnoreCase("TRAINER")){ %>
						
						
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Duration Report Associated With This Users</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							 <div class="ibox-content">

								<div>
									<div class="feed-activity-list" style="height: auto;">

										<div class="feed-element">

											<div class="project-list">
											
											<form action="<%=baseURL%>orgadmin/student/dashboard.jsp" method="get" class="form-horizontal">
							                 <input type="hidden" name="user_id" id="user_id" value="<%=user_id%>">
							
							               <h3>Date Range Picker</h3>

								        	<input class="form-control" type="text" name="daterange" id="daterange" 	value="07/01/2016 - 07/01/2016" />


								   	<button class="btn btn-primary " type="submit" id="show_table"><i class="fa fa-check"></i>&nbsp;Generate Report</button>
									
									

												<table class="table table-hover">
													<tbody>
													
													<%
									if(start_date.equalsIgnoreCase("") && end_date.equalsIgnoreCase(""))
									{
									
											conditions.clear();
											conditions.put("user_id", user_id);
											
											
											%>
											<%=dtUtils.getReport(220, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
											
												
											

									<%
									}
									else
									{	
									//2016-10-01
									//2016-09-30
									
									System.out.println("--"+user_id);
										conditions.clear();
										conditions.put("start_date", start_date);
										conditions.put("end_date", end_date);
										conditions.put("trainer_id", user_id);
										%>
									<%=(new DatatableUtils()).getReport(219, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
										<% 		
									
									}
									%>
									
													
													</tbody>
												</table>
												 </form>
											</div>
										</div>


									</div>
								</div>
							</div> 
							</div>
							
							

						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>ToT-Batchs Associated With This Trainer</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">

								<div>
									<div class="feed-activity-list" style="height: auto;">

										<div class="feed-element">

											<div class="project-list">
												<h5></h5>
												<table class="table table-hover">
													<tbody>
														<%
																out.println(util.PrintTrainerToTBatchList(student, baseURL).toString());
															
															%>
													</tbody>
												</table>
											</div>
										</div>


									</div>
								</div>
							</div>
						</div>
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Batchs Associated With This Trainer</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">

								<div>
									<div class="feed-activity-list" style="height: auto;">

										<div class="feed-element">

											<div class="project-list">
												<h5></h5>
												<table class="table table-hover">
													<tbody>
														<%
																out.println(util.PrintTrainerBatchList(student, baseURL).toString());
															
																
															%>
													</tbody>
												</table>
											</div>
										</div>


									</div>
								</div>
							</div>
						</div>

						<% }%>
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Assessment Report Associated With This Users</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">

								<div>
									<div class="feed-activity-list" style="height: auto;">

										<div class="feed-element">

											<div class="project-list">

												<table class="table table-hover">
													<tbody>
														<%
										conditions.clear();
									conditions.put("user_id", user_id + "");
									%>
														<%=dtUtils.getReport(212, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
													</tbody>
												</table>
											</div>
										</div>


									</div>
								</div>
							</div>
						</div>
						
						
							
							
						
						
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Calendar Of Events</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">

								<div id="calendar"></div>
							</div>
						</div>



					</div>
</div>
</div>
</div>
</div>



					<!-- Mainly scripts -->

					<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>
					<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
					<script src="<%=baseURL%>js/bootstrap.min.js"></script>
					<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
					<script src="<%=baseURL%>js/jquery.contextMenu.js"
						type="text/javascript"></script>
						
							<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Date range use moment.js same as full calendar plugin -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>
	
	<script type="text/javascript"
						src="<%=baseURL%>js/plugins/dataTables/dataTables.editor.min.js"></script>
	
					<script
						src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
					<script src="<%=baseURL%>js/plugins/dataTables/datatables.min.js"></script>
					<script type="text/javascript" language="javascript"
						src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js">
	</script>
					
					<script src="<%=baseURL%>js/highcharts-custom.js"></script>
					<!-- Custom and plugin javascript -->
					<script src="<%=baseURL%>js/inspinia.js"></script>
					<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

					<!-- jQuery UI custom -->
					<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>
					
					

					<!-- iCheck -->
					<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

					<!-- Full Calendar -->
					<script
						src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>
					
					
					<!-- Date range picker -->
					<script src="<%=baseURL%>js/plugins/daterangepicker/daterangepicker.js"></script>
<script>
	$(document).ready(function() {
		
		$('input[name="daterange"]').daterangepicker({
		    startDate: new Date(),
		    endDate: new Date()
		});
		
		
		$('.i-checks').iCheck({
			checkboxClass : 'icheckbox_square-green',
			radioClass : 'iradio_square-green'
		});

		/* initialize the external events
		 -----------------------------------------------------------------*/
  
		
	});
	</script>

					<script>

/* initialize the external events
-----------------------------------------------------------------*/
$('#external-events div.external-event').each(function() {
	// store data so the calendar knows to render an event upon drop
	$(this).data('event', {
		title : $.trim($(this).text()), // use the element's text as the event title
		stick : true
	// maintain when user navigates (see docs on the renderEvent method)
	});
	// make the event draggable using jQuery UI
	$(this).draggable({
		zIndex : 1111999,
		revert : true, // will cause the event to go back to its
		revertDuration : 0
	//  original position after the drag
	});
});
/* initialize the calendar
-----------------------------------------------------------------*/
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
$('#calendar').fullCalendar({
	header : {
		left : 'prev,next today',
		center : 'title',
		right : 'month,agendaWeek,agendaDay'
	},

	events : [ 
<%

List<HashMap<String, Object>> res = ou.getEventPerUser(student);
int count = 0;
for (HashMap<String, Object> row : res) {
	String batchgroupname = (String) row.get("batchgroupname");
	String batchname = (String) row.get("batchname");
	String type = (String) row.get("type");
	Integer duration = 0;
	if(row.get("duration")!=null)
	{
		BigInteger  d = (BigInteger)row.get("duration") ;
		duration = d.intValue();
	}
	
	
	 
	
	long t = ((Timestamp) row.get("eventdate")).getTime();
	long m = duration * 60 * 1000;
	Timestamp end_time = new Timestamp(t + m);
	String desc ="";
	desc = desc+"Batch Group Name: "+batchgroupname+"<br/>Batch Name: "+batchname+"<br/> Event Time: "+t+"<br/>Event Type: "+type+"<br/>Duration: "+duration;
	String col = "#A9CCE3";
	if (type.equalsIgnoreCase("ASSESSMENT_EVENT")) {
		col = "#A9CCE3";
	} else {
		col = "#58D68D";
	}
	%>          					           
{		
start: '<%=(Timestamp) row.get("eventdate")%>',
end: '<%=end_time%>',

description: '<%=desc%>',
id: '<%=(String) row.get("id")%>',
batch_id:	<%=(Integer) row.get("batch_id")%>, 
color: '<%=col%>',
textColor: 'black',
batchgroupname: '<%=batchgroupname%>',
batchname: '<%=batchname%>',

type :'<%=type%>',

duration :'<%=duration%>',
title:'<%=type %> <%=batchname %>'
},
<%}%>], 
eventRender: function(event, element) {
//var icon  = 'The icon you want, HTML is possile';
// element.find('.fc-content').data("event_id", event.id );
//element.attr("categories",event.categoryname)
element.find('.fc-title').append("");  
element.attr("event_id",event.id);
element.attr("batch_id",event.batch_id);
}
});

</script>
</body>
</html>