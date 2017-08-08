
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int colegeID = 3;

	if (request.getParameterMap().containsKey("orgID")) {
		colegeID = Integer.parseInt(request.getParameter("orgID"));

	}
%>
<%
	String tab = "tab_1";
	if (request.getParameterMap().containsKey("tab")) {
		tab = request.getParameter("tab");
	}
%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_report">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="row">
				<div class="col-xs-12">
					<div class="page-title-box">
						<h4 class="page-title">Student Report</h4>
						<ol class="breadcrumb p-0 m-0">
							<li><a href="#">Dashboard</a></li>
							<li><a href="#">Student Report</a></li>

						</ol>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
<div class="row" style='    margin-left: 0px; margin-right: 0px;'>

	<!-- tab start -->

	<div
		class="ibox p-xs  b-r-lg border-left-right border-top-bottom border-size-sm gray-bg-admin">
		<div class="tabs-container">
			<ul class="nav nav-tabs gray-bg">
				<li class="active col-lg-2 text-center no-padding bg-muted"><a
					data-toggle="tab" id="tab_6" href="#tab6">Section Report</a></li>

				<li class="col-lg-2 text-center no-padding bg-muted"><a
					data-toggle="tab" id="tab_7" href="#tab7">Assessment Report</a></li>


			</ul>

			<div class="tab-content">
				<div id="tab6" class="active tab-pane ops-tab div-min-height">
					<div class="panel-body">
						 <jsp:include page="../ops_report1.jsp" /> 
					</div>
				</div>

				<div id="tab7" class=" tab-pane ops-tab div-min-height">
					<div class="panel-body">
						 <jsp:include page="../ops_report_2.jsp" /> 
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<!-- Mainly scripts -->
</body>
</html>
