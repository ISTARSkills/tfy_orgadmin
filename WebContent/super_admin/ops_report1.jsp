<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%
	OpsReportSevices opsReport = new OpsReportSevices();
%>
<jsp:include page="inc/head.jsp"></jsp:include>

<body class="top-navigation" id="super_admin_ops_report">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="row p-xl">
				<div class="col-lg-4">
					<div class="form-group">
						<label class="font-bold">Choose College</label>
						<div>
							<select data-placeholder="select College" tabindex="4"
								id='report_college'>
								<%=opsReport.getOrganization()%>
							</select>
						</div>
					</div>
				</div>

				<div class="col-lg-4">
					<div class="form-group">
						<label class="font-bold">Choose Batch</label>
						<div>
							<select data-placeholder="select Batch" tabindex="4"
								id='report_batch'>

							</select>
						</div>
					</div>
				</div>

				<div class="col-lg-4">
					<div class="form-group">
						<label class="font-bold">Choose Assessment</label>
						<div>
							<select data-placeholder="select Assessment" tabindex="4" data-url='ops_report_partial/student_assessment_report.jsp'
								id='report_assessment'>
							</select>
						</div>
					</div>
				</div>



			</div>
			
				<div id="ops_report_holder"></div>

		</div>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
	<script>
		$(document)
				.ready(
						function() {

							$('#report_college').on("change", function() {
								var orgId = $(this).val();
								var type = 'org';
								$.ajax({
									type : "POST",
									url : '../get_ops_report',
									data : {
										orgId : orgId,
										type : type
									},
									success : function(data) {
										$('#report_batch').html(data);
									}
								});
							});

							$('#report_batch').on("change", function() {
								var batch = $(this).val();
								var type = 'batch';

								if (batch != 'null') {
									$.ajax({
										type : "POST",
										url : '../get_ops_report',
										data : {
											type : type,
											batch : batch
										},
										success : function(data) {
											$('#report_assessment').html(data);

										}
									});
								}
							});

							$('#report_assessment').on("change", function() {
								var batch = $('#report_batch').val();
								var assessment = $(this).val();
								var url=$(this).data('url');
								if (assessment != 'null') {
									$.ajax({
										type : "POST",
										url : url,
										data : {
											assessmentId : assessment,
											batchId : batch
										},
										success : function(data) {
											$('#ops_report_holder').html(data);
											init_opsReport();
										}
									});
								}else{
									$('#ops_report_holder').html("<div class='col-lg-4'></div><div class='alert alert-danger text-center col-lg-4'>Sorry No Data Found</div><div class='col-lg-4'></div>");
								}
							});
						});
		
		function init_opsReport(){
			
			Highcharts.chart('container1',
					{
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
								return this.point.y
										+ ' <b>'
										+ this.series.name
										+ '</b><br/>'
										+ ' '
										+ this.point.name
												.toLowerCase();
							}
						}
					});

			Highcharts.chart('container2',
					{
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
								return this.point.y
										+ ' <b>'
										+ this.series.name
										+ '</b><br/>'
										+ ' are '
										+ this.point.name
												.toLowerCase();
							}
						}
					});
			
			
		}
		
	</script>
</body>

</html>
