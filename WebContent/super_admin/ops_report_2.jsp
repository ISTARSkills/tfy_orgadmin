<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	OpsReportSevices service = new OpsReportSevices();
%>
<body class="top-navigation" id="super_admin_ops_report">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<div class="row p-xl">
				<div class="col-lg-4">
					<div class="form-group">
						<label class="font-bold">Choose College</label>
						<div>
							<select data-placeholder="select College" tabindex="4" class="report_college"
								id='report_college'>
								<%=service.getOrganization()%>
							</select>
						</div>
					</div>
				</div>

				<div class="col-lg-4">
					<div class="form-group">
						<label class="font-bold">Choose Section</label>
						<div>
							<select data-placeholder="select Section" tabindex="4" class="report_batch report_batch_holder"
								id='report_batch'>

							</select>
						</div>
					</div>
				</div>

				<div class="col-lg-4">
					<div class="form-group">
						<label class="font-bold">Choose Assessment</label>
						<div>
							<select data-placeholder="select Assessment" tabindex="4" class="report_assessment"
								data-url='../ops_report_partial/batch_question_report.jsp'
								id='report_assessment'>
							</select>
						</div>
					</div>
				</div>



			</div>
			<div class="ops_report_holder" id="ops_report_holder_result2"></div>


		</div>
	</div>
	<!-- Mainly scripts -->
	

</body>
</html>










<%-- 
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	OpsReportSevices service = new OpsReportSevices();
%>
<body class="top-navigation" id="super_admin_ops_report">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">

			<div class="row p-xl">
				<div class="col-lg-4">
					<div class="form-group">
						<label class="font-bold">Choose College</label>
						<div>
							<select data-placeholder="select College" tabindex="4"
								id='report_college'>
								<%=service.getOrganization()%>
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
							<select data-placeholder="select Assessment" tabindex="4"
								data-url='ops_report_partial/batch_question_report.jsp'
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
	<script type="text/javascript">
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

		$('#report_assessment')
				.on(
						"change",
						function() {
							var batch = $('#report_batch').val();
							var assessment = $(this).val();
							var url = $(this).data('url');
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
							} else {
								$('#ops_report_holder')
										.html(
												"<div class='col-lg-4'></div><div class='alert alert-danger text-center col-lg-4'>Sorry No Data Found</div><div class='col-lg-4'></div>");
							}
						});

		function init_opsReport() {
			$('.ops_report_data_table').each(
					function(e) {

						var question_id = $(this).data('question');

						var table = 'ops_report_' + question_id;

						Highcharts.chart('container_' + question_id, {
							data : {
								table : table
							},
							chart : {
								type : 'column'
							},
							title : {
								text : 'NO of Students'
							},
							yAxis : {
								allowDecimals : false,
								title : {
									text : 'student'
								}
							},
							plotOptions : {
								series : {
									borderWidth : 0,
									dataLabels : {
										enabled : true,
										format : '{point.y}'
									}
								}
							},
							tooltip : {
								formatter : function() {
									return this.point.y + ' ' + this.point.name
											+ ' <b>' + this.series.name
											+ '</b> this question<br/>';
								}
							}, colors: ['#1ab394','#f8ac59', '#8f938f']
						});

					});
		}
	</script>

</body>
</html>
 --%>