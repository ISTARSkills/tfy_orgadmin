<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><%@page import="com.istarindia.apps.dao.*"%>
<!DOCTYPE html>
<html>
<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	PlacementOfficer recruiter = (PlacementOfficer) request.getSession().getAttribute("user");
%>

<%
	DatatableUtils dtUtils = new DatatableUtils();
	HashMap<String, String> conditions = new HashMap<>();
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify TPO | Dashboard <%=recruiter.getName()%></title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css"
	rel="stylesheet">
<style>
</style>
</head>

<body class="fixed-navigation">
	<div id="wrapper">
		<jsp:include page="includes/sidebar.jsp"></jsp:include>


		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<!-- header -->
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>

			<div class="wrapper" style="padding: 40px; padding-left: 40px; padding-right: 40px; padding-top: 30px;">

				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-content">
								<%
									conditions.clear();
									conditions.put("college_id", recruiter.getCollege().getId() + "");
								%>
								<%=dtUtils.getReport(302, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE")
							.toString()%>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-8">
						<div class="ibox float-e-margins">
							<div class="ibox-content">
								<%
									conditions.clear();
									conditions.put("college_id", recruiter.getCollege().getId() + "");
								%>
								<%=dtUtils.getReport(301, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE")
							.toString()%> 
							</div>
						</div>
					</div>
					
					<div class="col-lg-4">
						<div class="ibox float-e-margins">
							<div class="ibox-content">
								<%
									conditions.clear();
								    conditions.put("collegeId", recruiter.getCollege().getId() + "");								
								%>
								<%=dtUtils.getReport(226, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE")
							.toString()%>
							</div>
						</div>
					</div>
				</div>
		</div>
	</div>
</div>
	<!-- Mainly scripts -->
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<!-- Flot -->
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.tooltip.min.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.spline.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.resize.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.pie.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.symbol.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/curvedLines.js"></script>

	<!-- Peity -->
	<script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
	<script src="<%=baseURL%>js/demo/peity-demo.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI -->
	<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>

	<!-- Jvectormap -->
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

	<!-- Sparkline -->
	<script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>

	<!-- Sparkline demo data  -->
	<script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>
	<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>
		<!-- ChartJS-->

	<script src="https://code.highcharts.com/highcharts.js"></script>
	<script src="https://code.highcharts.com/modules/data.js"></script>
	<script src="https://code.highcharts.com/modules/no-data-to-display.js"></script>

	<script type="text/javascript">
	Highcharts.theme = {
			   colors: ['#1AB395', '#63D2BD', '#3AC0A6', '#009D7E', ' #007861', '#004638', '#00726E',
			      '#009590', '#39BAB6', '#62CECA', '#19ACA7'],			   
			   // General
			   background2: '#F0F0EA'
			};
	Highcharts.setOptions(Highcharts.theme);
	</script>
</body>
</html>