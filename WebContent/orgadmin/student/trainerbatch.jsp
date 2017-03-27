<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="in.orgadmin.utils.BatchUtils"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="java.util.*"%>
<%@page import="org.hibernate.Query"%>

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

<title>Admin Portal | Course Dashboard</title>
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

</head>

<body class="fixed-sidebar no-skin-config full-height-layout">
	
	<%
		BatchUtils batchutils = new BatchUtils();
		DatatableUtils dtUtils = new DatatableUtils();
		OrgadminUtil orgadminUtil = new OrgadminUtil();
		
		HashMap<String, String> conditions = new HashMap<>();
		BatchUtils bu = new BatchUtils();
		
		int batch_id = Integer.parseInt(request.getParameter("batch_id"));
		Batch batch = new BatchDAO().findById(batch_id);
		
		int user_id = Integer.parseInt(request.getParameter("user_id"));
		Student student = new StudentDAO().findById(user_id);
	%>
	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg" style="    height: auto;">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			
            <div class="row wrapper border-bottom white-bg page-heading">
               <div class="col-lg-10">
					<h2><%=batch.getName()%></h2>
					<p><%=batch.getBatchGroup().getCollege().getName()%></p>
				</div>
                <div class="col-lg-2"> </div>
            </div>

	        <div class="wrapper wrapper-content  animated fadeInRight">
	            <div class="row">
	                <div class="col-lg-3">
	                    <div class="ibox">
	                        <div class="ibox-content">
	                            <h3>Session list</h3>
	
	                            <div class="input-group search-bar">
	                                <input type="text" placeholder="Start typing to search... " class="input input-sm form-control">
	                                <span class="input-group-btn">
	                                        <button type="button" class="btn input-sm btn-white"> <i class="fa fa-search"></i></button>
	                                </span>
	                            </div>
	
	                            <ul class="sortable-list connectList agile-list ui-sortable" id="todo">
	                            
	                                <%
	                                		ArrayList<HashMap<String , Object>> lesson_list = orgadminUtil.getSessionListForBatch(batch);
											for (HashMap<String , Object> lesson : lesson_list) {
									%>
		                                <li class="<%=lesson.get("status").toString().toLowerCase() %>" id="<%=lesson.get("id")%>"> <label><%=lesson.get("title")%></label>
		                                <p> <%=lesson.get("session_desc") %> </p>
		                                    <div class="agile-detail">
		                                        <img alt='img' style='width: 25px; margin-top: 7px;' src="<%=baseURL %><%=lesson.get("lesson_type")%>"> <%=lesson.get("session_title") %>
		                                    </div>
		                                    <div class="agile-detail">
		                                       <span class='label label-info ' style="float: right;   margin-left: 1%;" > <%=lesson.get("teaching_status") %> </span> &nbsp;&nbsp;
		                                       <span class='label label-primary ' style="float: right"   > <%=lesson.get("status") %> </span>
		                                    </div>
		                                </li>
	                                <%	} %>
	                                
	                            </ul>
	                        </div>
	                    </div>
	                </div>
	                
	                <!--  Trainers associated with this batch -->
	                <div class="col-sm-9">
		                <div class="row">
							<div class="col-lg-12">
						        <div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>Trainers associated with this batch</h5>
										<div class="ibox-tools">
											<a class="collapse-link">
												<i class="fa fa-chevron-down"></i>
											</a>
										</div>
									</div>
									<div class="ibox-content" style="display: none;">
											<%
												conditions.clear();
												conditions.put("batch_id", batch_id + "");
											%>
										<%=(new DatatableUtils()).getReport(203, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
									</div>
						        </div>
						    </div>
						</div>
					</div>
					
	                <!--  Attendance associated with this batch -->
	                <div class="col-sm-9">
		                <div class="row">
							<div class="col-lg-12">
						        <div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>Attendance associated with this batch</h5>
										<div class="ibox-tools">
											<a class="collapse-link">
												<i class="fa fa-chevron-up"></i>
											</a>
										</div>
									</div>
									<div class="ibox-content">
										<%
											conditions.clear();
											conditions.put("batch_id", batch_id+"");
										%>
										<%=(new DatatableUtils()).getReport(200, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
									</div>
						        </div>
						    </div>
						</div>
					</div>
					
	                <!--  Feedback by trainer for this batch -->
	                <div class="col-sm-9">
		                <div class="row">
							<div class="col-lg-12">
						        <div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>Feedback by trainer for this batch</h5>
										<div class="ibox-tools">
											<a class="collapse-link">
												<i class="fa fa-chevron-up"></i>
											</a>
										</div>
									</div>
									<div class="ibox-content">
										<%
											conditions.clear();
											conditions.put("batch_id", batch_id+"");
										%>
										<%=(new DatatableUtils()).getReport(193, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
									</div>
						        </div>
						    </div>
						</div>
					</div>
					
	                <!--  Assessment Report associated with this batch -->
	                <div class="col-sm-9">
		                <div class="row">
							<div class="col-lg-12">
						        <div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>Assessment Report associated with this batch</h5>
										<div class="ibox-tools">
											<a class="collapse-link">
												<i class="fa fa-chevron-up"></i>
											</a>
										</div>
									</div>
									<div class="ibox-content">
									
									
										<%
										
											conditions.clear();
											conditions.put("batch_id", batch_id+"");
										%>
										<%=(new DatatableUtils()).getReport(208, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
									</div>
						        </div>
						    </div>
						</div>
					</div>
					
	                <!--  Events associated with this batch -->
	                
	                <div class="col-sm-9">
		                <div class="row">
							<div class="col-lg-12">
						        <div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>Events associated with this batch</h5>
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
	<script src="<%=baseURL%>js/plugins/dataTables/datatables.min.js"></script>
	<script type="text/javascript" language="javascript"
		src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js">
	</script>
	<script type="text/javascript"
		src="<%=baseURL%>js/plugins/dataTables/dataTables.editor.min.js"></script>
	  <script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>
	<script>

	$(document).ready(function() {
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
	 eventClick:  function(event, jsEvent, view) {
           $('#modalTitle').html(event.title);				         
           $('#batchName').html(event.batch_name);
           $('#orgName').html(event.orgname);
           $('#class_room').html(event.classroom);
           $('#duration').html(event.duration); 
          // $('#eventTime').html(event.start);
           $('#trainer').html(event.trainer_name);
           $('#status').html(event.status);
           $('#eventDetails').attr('href',event.view_url);
           $('#eventDelete').attr('href',event.delete_url);
           $('#eventEdit').attr('href',event.edit_url);
           $('#fullCalModal').modal();
       },
	editable : true,
	droppable : true, // this allows things to be dropped onto the calendar
	drop : function() {
		// is the "remove after drop" checkbox checked?
		if ($('#drop-remove').is(':checked')) {
			// if so, remove the element from the "Draggable Events" list
			$(this).remove();
		}
	},
	events : [ 
<%List<HashMap<String, Object>> res = bu.getEventPerBatchTrainer(batch,student);
int count = 0;
for (HashMap<String, Object> row : res) {
	String part1[] = (row.get("event_name")).toString().split("-");
	String status = (String) row.get("bse_status");
	int batch_iddd = (int) row.get("batch_id");
	String batch_name = (String) row.get("batch_name");
	int class_id = (int) row.get("class_id");
	String classroom_identifier = (String) row.get("classroom_identifier");
	classroom_identifier =  classroom_identifier+"-"+class_id;
	int duration = (int) row.get("bse_eventhour") * 60 + (int) row.get("bse_eventmin");
	String tt = (String) row.get("batch_name")+", Trainer: "+(String) row.get("trainer_name");
	long t = ((Timestamp) row.get("eventdate")).getTime();
	long m = duration * 60 * 1000;
	Timestamp end_time = new Timestamp(t + m);
	String desc ="";
	desc = desc+"Batch Name: "+batch_name+"<br/>Org Name: "+(String) row.get("org_name")+"<br/>Classroom (ID): "
	+classroom_identifier+"("+class_id+").<br/>Duration: "+duration+" mins.<br/> Event Time: "+t+"<br/>Trainer: "+(String) row.get("trainer_name")+"<br/> Status: "+status;
	String col = "#A9CCE3";
	if (status.equalsIgnoreCase("SCHEDULED")) {
		col = "#A9CCE3";
	} else if (status.equalsIgnoreCase("TEACHING")) {
		col = "#58D68D";
	} else if (status.equalsIgnoreCase("ATTENDENCE")) {
		col = "#F7DC6F";
	} else if (status.equalsIgnoreCase("FEEDBACK")) {
		col = "#DC7633";
	} else if (status.equalsIgnoreCase("COMPLETED")) {
		col = "#626567";
	} else if (status.equalsIgnoreCase("STARTED")) {
		col = "#C0392B";
	} else if (status.equalsIgnoreCase("REACHED")) {
		col = "#FF00FF";
	}%>          					           
{		
start: '<%=(Timestamp) row.get("eventdate")%>',
end: '<%=end_time%>',
title:'<%=tt%>',
description: '<%=desc%>',
id: '<%=(String) row.get("id")%>',
batch_id:	<%=(Integer) row.get("batch_id")%>, 
color: '<%=col%>',
textColor: 'black',
class_id : '<%=class_id%>',
batch_name: '<%=batch_name%>',
classroom: '<%=classroom_identifier%>',
orgname:'<%=(String) row.get("org_name")%>',
status :'<%=status%>',
trainer_name:'<%=(String) row.get("trainer_name")%>',
duration :'<%=duration%>',
view_url:'<%=baseURL%>orgadmin/logs/trainer_logs.jsp?event_id=<%=(String) row.get("id")%>',
delete_url:'<%=baseURL%>delete_event?event_id=<%=(String) row.get("id")%>',
edit_url:'<%=baseURL%>orgadmin/events/create_events.jsp?event_id=<%=(String) row.get("id")%>&batch_id=<%=(Integer) row.get("batch_id")%>'
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