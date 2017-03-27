<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	OpsReportSevices service = new OpsReportSevices();

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
				<div class="ibox-content">
					<%
						List<HashMap<String, Object>> questionList = service.getAllQuestions(assessmentId);
						int i = 1;
						for (HashMap<String, Object> item : questionList) {

							String questionText = "";

							if (item.get("comprehensive_passage_text") == null
									|| item.get("comprehensive_passage_text").toString().equalsIgnoreCase("")
									|| item.get("comprehensive_passage_text").toString().contains("<p>null</p>")) {
								questionText = item.get("question_text").toString();
							} else {
								questionText = item.get("comprehensive_passage_text").toString() + "<br/>"
										+ item.get("question_text").toString();
							}
					%>
					<div class="row p-lg product-box ibox-content">
						<div class="col-lg-6">
							<div class="m-t-sm m-l-sm">
								<span class="badge badge-info"><%=i++%></span>
								<h3>
									<strong class="m-l-sm" style='color: #000 !important'><%=questionText%></strong>
								</h3>
							</div>
							<%=service.getAllOptions((int) item.get("question_id"))%>
						</div>
						<div class="col-lg-6 ">
							<div id="container_<%=(int) item.get("question_id")%>"
								class="b-r-sm border-left-right border-top-bottom"
								style="width: 100%;"></div>

							<table id='ops_report_<%=(int) item.get("question_id")%>'
								class='ops_report_data_table' style="display: none"
								data-question='<%=(int) item.get("question_id")%>'>
								<thead>
									<tr>
										<th>student</th>
										<th>corrected</th>
										<th>incorrected</th>
										<th>skipped</th>
									</tr>
								</thead>
								<tbody>
									<%
										List<HashMap<String, Object>> graphList = service.getopsreport2(assessmentId, batchId,
													(int) item.get("question_id"));
											for (HashMap<String, Object> dataItem : graphList) {
									%>
									<tr>

										<td>students</td>
										<td><%=dataItem.get("correct")%></td>
										<td><%=dataItem.get("incorrect")%></td>
										<td><%=dataItem.get("skipped")%></td>
									</tr>
									<%
										}
									%>
								</tbody>

							</table>
						</div>

					</div>
					<br />
					<%
						}
					%>
				</div>

			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
		$(document).ready(function() {
			init_opsReport();
			setTimeout(function() {
				window.print();
			}, 5000);
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
							},
							colors : [ '#1ab394', '#f8ac59', '#8f938f' ]
						});

					});
		}
	</script>

</body>
</html>
