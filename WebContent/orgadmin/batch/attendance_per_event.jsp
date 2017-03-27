<%@page import="com.istarindia.apps.dao.BatchDAO"%>
<%@page import="com.istarindia.apps.dao.AssessmentDAO"%>
<%@page import="com.istarindia.apps.dao.Assessment"%>
<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="in.orgadmin.utils.OrgAdminRegistry"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.File"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="in.orgadmin.utils.report.ReportCollection"%>
<%@page import="javax.xml.bind.JAXBException"%>
<%@page import="java.net.URISyntaxException"%>
<%@page import="in.orgadmin.utils.report.IStarColumn"%>
<%@page import="in.orgadmin.utils.report.Report"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="in.orgadmin.utils.OrganizationUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="in.orgadmin.utils.BatchUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>

<html>
<head>

<%
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>

<%
BatchScheduleEvent bse = new BatchScheduleEvent();

if(request.getParameterMap().containsKey("bse_id"))
{
	
	String bse_id = request.getParameter("bse_id");
	bse = new BatchScheduleEventDAO().findById(UUID.fromString(request.getParameter("bse_id")));
		    
	
}
		
%>
	
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />

<title>Admin Portal |  Update Attendance</title>

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

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/dropzone/dropzone.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/toastr/toastr.min.css" rel="stylesheet">

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
				
				
					<h2></h2> <br>
					
				</div>
			</div>
			<br>
			
			
			<div class="row">
			<div class="col-lg-12 text-center" style="display:none; position: absolute;z-index: 1;margin-top: 20%;" id="progressBarr">
                    
                        
                        <div class="">
                            <div class="spiner-example">
                                <div class="sk-spinner sk-spinner-wave">
                                    <div class="sk-rect1"></div>
                                    <div class="sk-rect2"></div>
                                    <div class="sk-rect3"></div>
                                    <div class="sk-rect4"></div>
                                    <div class="sk-rect5"></div>
                                </div>
                            </div>
                        </div>
                   
                </div>
			</div>
			<div class="wrapper wrapper-content">
				
				<!--  Student list table -->
				<div class="row">
					<div class="col-lg-12">
				        <div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Update Attendance</h5>
								<div class="ibox-tools">
									<a class="collapse-link">
										<i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							
							<div class="ibox-content" style="display:none">
										<input type="hidden" name="event_id" value="">
										<button class="btn btn-primary" id="send_data" name="send_data" type="button">Save changes</button>
												<div class="project-list">
													<table class="table table-hover">
														<tbody>
															<%
														
														
																//BatchScheduleEvent batchSE = new BatchScheduleEventDAO().findById(UUID.fromString(request.getParameter("bse_id")));
																BatchUtils util = new BatchUtils();
																out.println(util.PrintEventStudentAttendanceList(bse, baseURL).toString());
																
															
															  
															%>
														</tbody>
													</table>
													
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
		<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- DROPZONE -->
	<script src="<%=baseURL%>js/plugins/dropzone/dropzone.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>
	 <script src="<%=baseURL%>js/plugins/toastr/toastr.min.js"></script>
	
	<script>

		$(document).ready(function() {
			toastr.options = {
					  "closeButton": true,
					  "debug": false,
					  "progressBar": true,
					  "preventDuplicates": false,
					  "positionClass": "toast-top-center",
					  
					  "showDuration": "400",
					  "hideDuration": "1000",
					  "timeOut": "7000",
					  "extendedTimeOut": "1000",
					  "showEasing": "swing",
					  "hideEasing": "linear",
					  "showMethod": "fadeIn",
					  "hideMethod": "fadeOut"
					}
       	 $('.fa-chevron-up').click()

			    
			    $("#send_data").click(function(event){
			    	var checkboxValues = [];
					$('input[name="student_ids"]:checked').map(function() {
					            checkboxValues.push($(this).val());
					});
					    console.log(checkboxValues);
			    	var event_id = '<%=bse.getId()%>';
			    	
			    	 var dataString = 'event_id='+ event_id +'&student_ids=' + checkboxValues.join(',') ;
			    	$('#progressBarr').show();
			    	 $.ajax({
	                     url: '<%=baseURL%>update_attendance_orgadmin',
	                     data: dataString,
	                     
	                     success : function(data) {
	                    	 
	                    	 $('#progressBarr').hide();
	                    	 toastr.success('updated successfully!','Attendance has been')

	                    	 $('.fa-chevron-up').click();
	         			}
	                     });
			    	
			    });
			    
			
		});
	</script>

</body>
</html>