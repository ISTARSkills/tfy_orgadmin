<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
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
<%@page import="java.sql.Timestamp"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>

<html>
<head>

<%
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>

<%
		DatatableUtils dtUtils = new DatatableUtils();
		HashMap<String, String> conditions = new HashMap<>();
%>
	
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />

<title>Admin Portal | Organization Dashboard</title>

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
<link href="<%=baseURL%>css/plugins/dropzone/dropzone.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/style.css" rel="stylesheet">

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
					<h2>Trainer list</h2>
				</div>
			</div>
			<br>
			<div class="wrapper wrapper-content">
							
				<!--  Student bulk upload form -->
				<!-- <div class="row">
		             <div class="col-lg-12">
		                <div class="ibox float-e-margins">
		                    <div class="ibox-title">
		                        <h5>Upload Trainers in Organization</h5>
		                        <div class="ibox-tools">
									<a class="collapse-link">
										<i class="fa fa-chevron-down"></i>
									</a>
								</div>
		                    </div>
		                    <div class="ibox-content" style="display: none;">
		                        <form id="my-awesome-dropzone" class="dropzone dz-clickable" action="#">
		                            <div class="dropzone-previews"></div>
		                            <button type="submit" class="btn btn-primary pull-right">Upload</button>
		                        <div class="dz-default dz-message"><span>Drop files here to upload</span></div></form>
		                    </div>
		                </div>
		            </div>
	            </div> -->
	            
				<!--  Student list table -->
				<div class="row">
					<div class="col-lg-12">
				        <div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Trainer list</h5>
								<div class="ibox-tools">
									<a href="<%=baseURL%>orgadmin/trainer/edit_trainerlist.jsp?org_id=2" class="btn btn-primary btn-xs right">Create new trainer</a>		 &nbsp; &nbsp;
									<a class="collapse-link">
										<i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" >
									<%
										conditions.clear();
									%>
									<%=dtUtils.getReport(196, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
				        </div>
				    </div>
				</div>
				
						<div class="row">
					<div class="col-lg-12">
				        <div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Trainer Class Duration list</h5>
								<div class="ibox-tools">
								<a href="<%=baseURL%>orgadmin/trainer/detail_trainer_report.jsp" class="btn btn-primary btn-xs right">Detail trainer Report</a>		 &nbsp; &nbsp;
									<a href="<%=baseURL%>orgadmin/trainer/invoice_generation.jsp" class="btn btn-primary btn-xs right">Generate Invoice</a>		 &nbsp; &nbsp;
								
									<a class="collapse-link">
										<i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" >
									<%
										conditions.clear();
									%>
									<%=dtUtils.getReport(217, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
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
	
	
	<script>
	
		$(document).ready(function() {
			
			
			
			
		}); 
	</script>


</body>
</html>