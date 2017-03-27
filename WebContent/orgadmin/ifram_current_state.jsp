<%@page import="in.orgadmin.utils.BatchGroupUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
	
	DatatableUtils dtUtils = new DatatableUtils();
	HashMap<String, String> conditions = new HashMap<>();
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Portal | Current State</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">



<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">

</head>

<body class="fixed-navigation">
	<div id="wrapper" style="overflow-x: visible;">
		<jsp:include page="includes/sidebar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>
			<div class="wrapper wrapper-content ">
				<div class="row white-bg dashboard-header" style="padding: 0px">
					<div class="ibox">
	                        <div class="ibox-content">
	                      <iframe src="http://api.talentify.in:8080/new_current_state.jsp" style="width:100%;  height:100%;    border-width: inherit; border-style: hidden;">
	                      </iframe>
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
	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
    <script src="<%=baseURL%>js/highcharts-custom.js"></script>
 <script>
        $(document).ready(function(){
           
        });
    </script>


</body>
</html>