
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
<jsp:include page="../inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_analytics">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>



			<div class="row">

				<!-- tab start -->

				<div
					class="ibox p-xs  b-r-lg border-left-right border-top-bottom border-size-sm gray-bg-admin">
					<div class="tabs-container">
						<ul class="nav nav-tabs">
							<li
								class="active col-lg-3 text-center no-padding bg-muted"><a
								data-toggle="tab" id="tab_1" href="#tab1">Account</a></li>

							<li
								class="col-lg-3 text-center no-padding bg-muted"><a
								data-toggle="tab" id="tab_2" href="#tab2">Program</a></li>

							<li
								class=" col-lg-3 text-center no-padding bg-muted"><a
								data-toggle="tab" id="tab_3" href="#tab3">Trainer</a></li>

							<li
								class=" col-lg-3 text-center no-padding bg-muted"><a
								data-toggle="tab" id="tab_4" href="#tab4">Student Feedback</a></li>
						</ul>

						<div class="tab-content">
							<div id="tab1"
								class="active tab-pane div-min-height">
								<div class="panel-body">
									<jsp:include page="report_section/static_report_main.jsp"/>
								</div>
							</div>

							<div id="tab2"
								class=" tab-pane div-min-height">
								<div class="panel-body">
							 <jsp:include page="program_partials/program_main.jsp"/>
								</div>
							</div>

							<div id="tab3"
								class=" tab-pane div-min-height">
								<div class="panel-body">
									 <jsp:include page="trainer_partials/analytic_trainer.jsp" />  
								</div>
							</div>

							<div id="tab4"
								class=" tab-pane div-min-height">
								<div class="panel-body">
									 <jsp:include page="feedback_partials/student_feedback.jsp" />  
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>



		</div>
	</div>
	<jsp:include page="../inc/foot.jsp"></jsp:include>
<!-- Mainly scripts -->
</body>
</html>