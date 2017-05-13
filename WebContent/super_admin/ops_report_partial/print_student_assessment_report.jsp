<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%
	OpsReportSevices opsReport = new OpsReportSevices();

	int assessmentId = 0;
	int batchId = 0;

	if (request.getParameter("assessmentId") != null) {
		assessmentId = Integer.parseInt(request.getParameter("assessmentId"));
	}
	if (request.getParameter("batchId") != null) {
		batchId = Integer.parseInt(request.getParameter("batchId"));
	}
%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_ops_report_print">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<div id="ops_report_holder">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins no-margins bg-muted">

							<div class="ibox-content">

								<div class="row">
									<div class="col-lg-6 p-xxs bg-muted">
										<div class="ibox float-e-margins">
											<div class="ibox-title">
												<h5>Student Attendance Table</h5>

											</div>
											<div class="ibox-content p-xxs bg-muted" id="">

												<%=opsReport.getStudentReportDetailsForTable(assessmentId, batchId)%>



											</div>
										</div>
									</div>
									<div style = "display:none" class="col-lg-3 p-xxs bg-muted">
										<div class="ibox float-e-margins">
											<div class="ibox-title">
												<h5>Student Score Table</h5>

											</div>
											<div class="ibox-content p-xxs bg-muted">


												<%=opsReport.getStudentScoreDetailsForTable(assessmentId, batchId)%>


											</div>
										</div>
									</div>
									<div class="col-lg-3 p-xxs bg-muted">
										<div class="ibox float-e-margins">
											<div class="ibox-title">
												<h5>Student Percentage Table</h5>

											</div>
											<div class="ibox-content p-xxs bg-muted">

												<%=opsReport.getStudentPercentageDetailsForTable(assessmentId, batchId)%>


											</div>
										</div>
									</div>
								</div>
							</div>


						</div>
					</div>
				</div>
				<page size="A4">
				<div class="row">
					<div class="col-lg-4">


						<div style = "display:none" class="ibox-content">
							<div class="row">
								<div style = "display:none" id="student_score_graph_container"></div>
							</div>
						</div>
					</div>
					<div  class="col-lg-4 no-padding bg-muted">
						<div class="ibox float-e-margins no-margins bg-muted"></div>
						<div class="ibox float-e-margins no-margins bg-muted">

							<div class="ibox-content">
								<div class="row">
									<div  id="student_precentage_graph_container"></div>
								</div>
							</div>
						</div>
					</div>

					<div class="col-lg-4"></div>
				</div>
			</div>

		</div>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			init_opsReport();
			 setTimeout(function() { 
				 window.print();	
		    }, 5000);			 
			 
		});

		function init_opsReport() {

			Highcharts.chart('student_score_graph_container', {
				data : {
					table : 'student_score_graph_table'
				},
				chart : {
					type : 'column'
				},
				title : {
					text : 'Student Score Graph'
				},
				yAxis : {
					allowDecimals : false,
					title : {
						text : 'Units'
					}
				},
				tooltip : {
					formatter : function() {
						return this.point.y + ' <b>' + this.series.name
								+ '</b><br/>' + ' '
								+ this.point.name.toLowerCase();
					}
				}
			});

			Highcharts.chart('student_precentage_graph_container', {
				data : {
					table : 'student_precentage_graph_datatable'
				},
				chart : {
					type : 'column'
				},
				title : {
					text : 'Student Percentage Graph'
				},
				yAxis : {
					allowDecimals : false,
					title : {
						text : 'Units'
					}
				},
				tooltip : {
					formatter : function() {
						return this.point.y + ' <b>' + this.series.name
								+ '</b><br/>' + ' are '
								+ this.point.name.toLowerCase();
					}
				}
			});

		}
	</script>
</body>
</html><%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%
	OpsReportSevices opsReport = new OpsReportSevices();

	int assessmentId = 0;
	int batchId = 0;

	if (request.getParameter("assessmentId") != null) {
		assessmentId = Integer.parseInt(request.getParameter("assessmentId"));
	}
	if (request.getParameter("batchId") != null) {
		batchId = Integer.parseInt(request.getParameter("batchId"));
	}
%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_ops_report_print">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<div id="ops_report_holder">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins no-margins bg-muted">

							<div class="ibox-content">

								<div class="row">
									<div class="col-lg-6 p-xxs bg-muted">
										<div class="ibox float-e-margins">
											<div class="ibox-title">
												<h5>Student Attendance Table</h5>

											</div>
											<div class="ibox-content p-xxs bg-muted" id="">

												<%=opsReport.getStudentReportDetailsForTable(assessmentId, batchId)%>



											</div>
										</div>
									</div>
									<div class="col-lg-3 p-xxs bg-muted">
										<div class="ibox float-e-margins">
											<div class="ibox-title">
												<h5>Student Score Table</h5>

											</div>
											<div class="ibox-content p-xxs bg-muted">


												<%=opsReport.getStudentScoreDetailsForTable(assessmentId, batchId)%>


											</div>
										</div>
									</div>
									<div class="col-lg-3 p-xxs bg-muted">
										<div class="ibox float-e-margins">
											<div class="ibox-title">
												<h5>Student Percentage Table</h5>

											</div>
											<div class="ibox-content p-xxs bg-muted">

												<%=opsReport.getStudentPercentageDetailsForTable(assessmentId, batchId)%>


											</div>
										</div>
									</div>
								</div>
							</div>


						</div>
					</div>
				</div>
				<page size="A4">
				<div class="row">
					<div class="col-lg-4">


						<div class="ibox-content">
							<div class="row">
								<div id="container1"></div>
							</div>
						</div>
					</div>
					<div class="col-lg-4 no-padding bg-muted">
						<div class="ibox float-e-margins no-margins bg-muted"></div>
						<div class="ibox float-e-margins no-margins bg-muted">

							<div class="ibox-content">
								<div class="row">
									<div id="container2"></div>
								</div>
							</div>
						</div>
					</div>

					<div class="col-lg-4"></div>
				</div>
			</div>

		</div>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			init_opsReport();
			 setTimeout(function() { 
				 window.print();	
		    }, 5000);			 
			 
		});

		function init_opsReport() {

			Highcharts.chart('container1', {
				data : {
					table : 'datatable1'
				},
				chart : {
					type : 'column'
				},
				title : {
					text : 'Student Score Graph'
				},
				yAxis : {
					allowDecimals : false,
					title : {
						text : 'Units'
					}
				},
				tooltip : {
					formatter : function() {
						return this.point.y + ' <b>' + this.series.name
								+ '</b><br/>' + ' '
								+ this.point.name.toLowerCase();
					}
				}
			});

			Highcharts.chart('container2', {
				data : {
					table : 'datatable2'
				},
				chart : {
					type : 'column'
				},
				title : {
					text : 'Student Percentage Graph'
				},
				yAxis : {
					allowDecimals : false,
					title : {
						text : 'Units'
					}
				},
				tooltip : {
					formatter : function() {
						return this.point.y + ' <b>' + this.series.name
								+ '</b><br/>' + ' are '
								+ this.point.name.toLowerCase();
					}
				}
			});

		}
	</script>
</body>
</html> --%>