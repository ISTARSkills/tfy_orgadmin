<%@page import="com.istarindia.apps.dao.AssessmentDAO"%>
<%@page import="com.istarindia.apps.dao.Assessment"%>
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

		DatatableUtils dtUtils = new DatatableUtils();
		HashMap<String, String> conditions = new HashMap<>();
		int assessment_id = Integer.parseInt(request.getParameter("assessment_id"));
		
		
		String date_time_key = request.getParameter("date_time_key");
		Assessment assessment = (new AssessmentDAO()).findById(assessment_id);
		

		SimpleDateFormat  oldDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		SimpleDateFormat  newDateFormat = new SimpleDateFormat("dd MMM yyyy hh:mm a");
		Date date = oldDateFormat.parse(date_time_key.replace("T", ""));
		//date = newDateFormat.format(date);
		
		String user_id  = "";
		if(request.getParameterMap().containsKey("trainer_id")){
			
			 user_id = request.getParameter("trainer_id");
		}
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

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/dropzone/dropzone.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<style type="text/css">
.dataTables_wrapper  table  td:nth-child(2) , .dataTables_wrapper  table  th:nth-child(2) , .dataTables_wrapper  table  tfoot:nth-child(2) {
	max-width: 400px;
	word-break: break-all;
}
.dataTables_wrapper  table  td:nth-child(3) , .dataTables_wrapper  table  th:nth-child(3) , .dataTables_wrapper  table  tfoot:nth-child(3) {
	max-width: 350px;
	
}

.dataTables_wrapper table tfoot{ display: none; }



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
					<h2><%=assessment.getAssessmenttitle()%> [#<%=assessment_id %>]</h2> <br>
					<p><label>Schedule : </label>&nbsp;<%=newDateFormat.format(date)%> <br>
					<label>Duration : </label>&nbsp;<%=assessment.getLesson().getDuration()%> Minutes<br>
					<%-- <label>Session : </label>&nbsp;<%=assessment.getLesson().getCmsession().getTitle() %><br>
					<label>Description : </label>&nbsp;<%=assessment.getLesson().getCmsession().getSession_description() %></p> --%>
				</div>
			</div>
			<br>
			<div class="wrapper wrapper-content">
				
				<!--  Student list table -->
				<div class="row">
				<%if(request.getParameterMap().containsKey("trainer_id")){%>
					<div class="col-lg-8">
					<%}else{ %>
					<div class="col-lg-12">
					<%} %>
				        <div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Assessment report</h5>
								<div class="ibox-tools">
								
								<%if(request.getParameterMap().containsKey("trainer_id")){
									
									 user_id = request.getParameter("trainer_id");
								 %>
								<a href="<%=baseURL%>orgadmin/batch/rootcause_analysis.jsp?user_id=<%=user_id %>" class="btn btn-primary btn-xs right">View Reports</a>		 &nbsp; &nbsp;
									<%} %>
									<a class="collapse-link">
									
										<i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" >
									<%
									if(request.getParameterMap().containsKey("batch_id") ) {
										int batch_id = Integer.parseInt(request.getParameter("batch_id"));
										
										conditions.clear();
										conditions.put("date_time_key", date_time_key);
										conditions.put("batchID", batch_id + "");
										conditions.put("assessmentID", assessment_id + "");
										
										if(assessment.getCategory()!= null && assessment.getCategory().equalsIgnoreCase("TRAINER_ASSESSMENT")){
										%>
										
											<%=dtUtils.getReport(228, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
											
									<% 	}else{
										
									%>
						
											<%=dtUtils.getReport(191, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
									
									<%}}else{
										
										int trainer_id = Integer.parseInt(request.getParameter("trainer_id"));
										
										conditions.clear();
										conditions.put("date_time_key", date_time_key);
										conditions.put("trainer_id", trainer_id + "");
										conditions.put("assessment_id", assessment_id + "");
								
										%>
								
							 	<%=dtUtils.getReport(211, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
										
										
									
							</div>
				        </div>
				    </div>
				    <div class="col-lg-4">
				    <div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Skill Report</h5>
								
							</div>
							<div class="ibox-content" >
								<iframe src="http://api.talentify.in:8080/cpreports/report.jsp?user_id=<%=user_id %>" style="width: 100%;    height: 98vh; border:none"></iframe>	
							</div>
				        </div>
				    
				   <% } %>
				    
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