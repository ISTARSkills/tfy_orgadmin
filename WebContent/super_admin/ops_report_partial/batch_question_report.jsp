<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	List<HashMap<String, Object>> questionList = service.getAllQuestions(assessmentId);
%>

<%
	if (questionList.size() > 0) {
%>
<div class='title-action'>
	<a
		href="../ops_report_partial/print_batch_question_report.jsp?assessmentId=<%=assessmentId%>&batchId=<%=batchId%>"
		target="_blank" class="btn btn-danger"><i class="fa fa-print"></i>
		Print Report </a>
</div>
<%
	}
%>


<div class="ibox-content">
	<%
		int i = 1;
		for (HashMap<String, Object> item : questionList) {

			String questionText = "";

			if (item.get("comprehensive_passage_text") == null
					|| item.get("comprehensive_passage_text").toString().equalsIgnoreCase("")
					|| item.get("comprehensive_passage_text").toString().trim().contains("<p>null</p>")) {
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
			<div class="m-t-sm m-l-sm">
				<%=service.getAllOptions((int) item.get("question_id"))%>
			</div>
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
						<th>students</th>
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

						<td>Attended</td>
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