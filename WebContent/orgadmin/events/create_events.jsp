<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="in.orgadmin.utils.*"%>
<%@page import="java.net.URL"%>
<%@page import="java.text.*"%>
<%@page import="java.io.File"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="in.orgadmin.utils.report.ReportCollection"%>
<%@page import="javax.xml.bind.JAXBException"%>
<%@page import="java.net.URISyntaxException"%>
<%@page import="in.orgadmin.utils.report.IStarColumn"%>
<%@page import="in.orgadmin.utils.report.Report"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="in.orgadmin.utils.OrganizationUtils"%>
<%@page import="in.orgadmin.utils.*"%>
<%@page import="java.sql.Timestamp"%>

<%@page import="in.orgadmin.services.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>

<html>
<head>

<%
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>
<%
String event = "";
BatchScheduleEventDAO dao = new BatchScheduleEventDAO();
BatchScheduleEvent be = new BatchScheduleEvent();

if(request.getParameterMap().containsKey("event_id")) {
event = request.getParameter("event_id");
be = dao.findById(UUID.fromString(event));

 String sql = "delete from ops_event_session_log";
 DBUTILS util = new DBUTILS();
 util.executeUpdate(sql); 
 
}

%>


<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />

<title>Admin Portal | Create Assessment Events</title>

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

<link href="<%=baseURL%>css/mdb.min.css" rel="stylesheet">


<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/dropzone/dropzone.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.1/css/bootstrap-datepicker.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.1/css/bootstrap-datepicker.css.map">
<link
	href="<%=baseURL%>css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css"
	rel="stylesheet">

<style type="text/css">
</style>
</head>

<body class="fixed-navigation  pace-done">

	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg ">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>Create / Edit Events</h2>
				</div>
			</div>
			<br>
			<div class="wrapper wrapper-content">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Create Class Event</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-down"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">

								<div class="row">
									<div class="col-sm-12 b-r">
					
										<form class="form-horizontal" role="form"
											action="/create_event" id="event_submit_form"
											method="GET">
																<%
					if(request.getParameterMap().containsKey("event_id"))
					{
					%>
										<input type='hidden' name="event_id"
											value="<%=request.getParameter("event_id") %>">
										<%
					}
					%>
											
											
								<input type='hidden' id="hidden_batch_id" name="batch_id" value="<%=request.getParameter("batch_id") %>">
								<input type='hidden' name="event_date" value=""  id="id__event_date_holder">
								<input type='hidden' name="event_count" value="1">				
										<%
								if(request.getParameterMap().containsKey("event_id"))
								{
								%>
								<%
								EventServiceNew serv =  new EventServiceNew();
								int old_less = serv.getCurrentLesson(Integer.parseInt(request.getParameter("batch_id")));
								Batch bb = be.getBatch();
								List<HashMap<String, Object>> lessons = serv.getLessons(bb.getCourse().getId());
								%>
											<div class="form-group">
												<label class="col-sm-2 control-label">Next session
													of batch </label>
												<div class="col-sm-10">
													<div class="row">
														<div class="col-md-6">
															<select class="form-control m-b" name="lesson_id" id='id__lesson_id'>
																<% 
											for(HashMap<String, Object> row : lessons)
											{
												int l_id =(int)row.get("id");
												String status = (String) row.get("status");
												String lesson_name= (String) row.get("title");
												if((int)row.get("id")==old_less) 
												{	
											%>
											<option value="<%=l_id%>"  selected><%=lesson_name %> - <%=status %></option>
											<% 
											} 
												else 
											{ %>
											<option value="<%=l_id%>" ><%=lesson_name %> - <%=status %></option>
											
											<% }
											
											}%>
											
															</select>
														</div>
														<div class="col-md-2">
															<div class="i-checks">
																<label> <input type="checkbox" value="on"
																	 name="allow_pointer_update"> <i></i> Update Next Session Pointer
																</label>
															</div>

														</div>
														<div class="col-md-2">
															<button class="btn btn-primary" type="submit">Preview Session</button>
														</div>
													</div>
												</div>
											</div>
<%
								}
%>
											<div class="form-group">
												<label class="col-sm-2 control-label">Select Trainer</label>

												<div class="col-sm-4">
													<select class="form-control m-b" name="trainer_id" id='id__trainer_id'>
														<%
														if(request.getParameterMap().containsKey("event_id")) {
															IstarUser u = be.getActor();
														%>
														<option value="<%=u.getId() %>"  selected><%=u.getEmail() %></option>
														
														<% }
														 
                                    DBUTILS util = new DBUTILS();
									String sql ="select id , email from student where user_type='TRAINER' order by email";
									List<HashMap<String, Object>> data = util.executeQuery(sql);
                                    if(data.size()>0)
                                    {	
                                    	for(HashMap<String, Object> row : data)
                                    	{
                                    		int id= (int)row.get("id");
                                    		String email= (String)row.get("email");
                                    %>
														<option value="<%=id%>"><%=email %></option>
														<%
                                    	}
                                    }
														
                                    %>
													</select>


												</div>
											</div>

											<div class="form-group">
												<label class="col-sm-2 control-label">Select
													Classroom</label>

												<div class="col-sm-5">
													<select class="form-control m-b" name="class_id" id='id__class_id'>
														<% if(request.getParameterMap().containsKey("event_id")) {
												
												                 ClassroomDetails cd =  be.getClassroom();
											%>
														<option value="<%=cd.getId() %>" selected><%=cd.getClassroomIdentifier() %></option>
														<%
                                    }
                                   	
										HashMap<Integer, String> classes = new EventServiceNew().getClassrooms(Integer.parseInt(request.getParameter("batch_id")));
										for (Integer j : classes.keySet()) {
											
									%>
														<option value="<%=j%>"><%=classes.get(j)%></option>
														<%
										}
                                  	
									%>
													</select>


												</div>
											</div>


											<!-- row start  -->


											<!--  row ends -->
											<div class="row">
												<div class="col-sm-6 b-r">
													<div class="form-group">
														<label class="col-sm-2 control-label">Select Date</label>
														<div class="col-sm-5">
															<% if(request.getParameterMap().containsKey("event_id")) { 
										//2016-07-30 03:15:00
										SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
										SimpleDateFormat formatter1 = new SimpleDateFormat("MM/dd/YYYY");

											Date d = be.getEventdate(); //12/03/2012
										
										%>
															<div id="id__event_date"
																data-date="<%=formatter1.format(d) %>"></div>
															<% } 
                                   else { %>
															<div id="id__event_date"></div>
															<% }%>
														</div>
													</div>
												</div>
												<div class="col-sm-6 b-r">
													<div class="form-group">
														<label class="col-sm-2 control-label">Select Time</label>
														<div class="col-sm-5">
															<% if(request.getParameterMap().containsKey("event_id")) { 
										//2016-07-30 03:15:00
											SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");

											Date d = be.getEventdate();
										
										%>
															<input type="text" value="<%=formatter.format(d) %>"
																data-value="<%=formatter.format(d) %>"
																id="id__event_time" name="event_time" value=""
																class="form-control validate" required>
															<% } else { %>
															<input type="text" id="id__event_time" name="event_time"
																value="" class="form-control validate" required>
															<% }%>
														</div>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-sm-6 b-r">
													<div class="form-group">
														<label class="col-sm-3 control-label">Duration(in
															hours)</label>
														<div class="col-sm-3">
															<% if(request.getParameterMap().containsKey("event_id")) { 
										%>
															<input type="number" id="duration_hour"
																name="duration_hour" value="<%=be.getEventhour() %>">
															<%
										}
										else
										{
											%>
															<input type="number" id="duration_hour"
																name="duration_hour" value="" required>
															<% 
										}
											%>
														</div>
													</div>
												</div>
												<div class="col-sm-6 b-r">
													<div class="form-group">
														<label class="col-sm-3 control-label">Duration(in
															mins)</label>
														<div class="col-sm-3">
															<% 
									if(request.getParameterMap().containsKey("event_id")) { 
										%>
															<input type="number" id="duration_min"
																name="duration_min" value="<%=be.getEventminute() %>">

															<%
										}
										else
										{
											%>
															<input type="number" id="duration_min"
																name="duration_min" value="" required>
															<% 
										}
											%>
														</div>
													</div>
												</div>
											</div>







											<div>
												<button class="btn btn-sm btn-primary pull-left m-t-n-xs"
													type="submit" id="submit_button">
													<strong>Submit</strong>
												</button>
											</div>
										</form>
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
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.1/js/bootstrap-datepicker.js"></script>

	<script type="text/javascript"
		src="<%=baseURL%>js/plugins/dataTables/dataTables.editor.min.js"></script>
	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>
	<script src="<%=baseURL%>js/mdb.min.js"></script>

	<!-- DROPZONE -->
	<script src="<%=baseURL%>js/plugins/dropzone/dropzone.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>
	
	
	<script type="text/javascript">
		
		$(document).ready(
				
				function() {
					
					 $('.i-checks').iCheck({
		                    checkboxClass: 'icheckbox_square-green',
		                    radioClass: 'iradio_square-green',
		                });

					
				      $('#id__event_date_holder').val( $('#id__event_date').datepicker('getFormattedDate'));
					 

					  var datepicker11 = $('#id__event_date').datepicker({
							  multidate: true, 
							  format: 'yyyy-mm-dd', 
							  todayHighlight: true
					   }).on('changeDate', function(e) {
					       console.log( $('#id__event_date').datepicker('getFormattedDate'));
					       $('#id__event_date_holder').val( $('#id__event_date').datepicker('getFormattedDate'));
					    });
					    
					  console.log(datepicker11);
					  $('#id__event_time').pickatime({
						    twelvehour: false
						});
					  
					 
					
					

				});
		
		
		
		
	</script>

<script type="text/javascript">
    $('#id__event_date_holder').val( $('#id__event_date').datepicker('getFormattedDate'));

	//var form = $('#event_submit_form');
	
	 $('#submit_button').click(function() {
		var id__trainer_id = document.getElementById("id__trainer_id").value;
		var id__event_date_holder = document.getElementById("id__event_date_holder").value;
		var id__event_time = document.getElementById("id__event_time").value;
		var duration_hour = document.getElementById("duration_hour").value;
		var duration_min = document.getElementById("duration_min").value;
		var id__class_id =  document.getElementById("id__class_id").value;
		var hidden_batch_id =document.getElementById("hidden_batch_id").value; 
		var event_id = '<%=request.getParameter("event_id")%>';
		
		 $.ajax({
	            url: '/validate_event',
	            data: {
	            	'id__class_id' : id__class_id,
	            	'id__trainer_id': id__trainer_id,
	            	'id__event_date_holder': id__event_date_holder,
	            	'id__event_time': id__event_time,
	            	'duration_hour': duration_hour,
	            	'duration_min': duration_min,
	            	'hidden_batch_id': hidden_batch_id, 
	            	'event_id': event_id
	            
	            },
	            method: 'GET',
	            success: function(data, textStatus) {
	            	var res = data;
	            	console.log(res);
	            	if(data==='every_thing_fine')
	            		{
	            		var form = $('#event_submit_form');
	            		form.submit();
	            		}
	            	else if(data==='class_time_not_available')
	            		{
	            		alert("Already event exist around this Time in this Class Room");
	            		}
	            	else if(data==='trainer_not_available')
	            		{
	            		alert("Trainer not available around this Time.");
	            		}
	            	else if(data==='batch_not_available')
	            		{
	            		alert("Already event exist for this batch around this Time.");
	            		}
	            	return true;
	            	///console.log("success");
	            },
	            error: function(ts) {  }
	        });

	    return false; 
		}); 
	
	
	
	
	function validateEvent() {
		
	    // return true or false, depending on whether you want to allow the `href` property to follow through or not
	}
	
	</script>

</body>
</html>