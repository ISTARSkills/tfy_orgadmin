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

<div class='title-action'>
	<a
		href="../ops_report_partial/print_student_assessment_report.jsp?assessmentId=<%=assessmentId%>&batchId=<%=batchId%>"
		target="_blank" class="btn btn-danger"><i class="fa fa-print"></i>
		Print Report </a>
</div>

<div class="row">
	<div class="col-lg-8">
		<div class="ibox float-e-margins no-margins bg-muted">

			<div class="ibox-content">

				<div class="row">
					<div class="col-lg-6 no-padding bg-muted">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Student Attendance Table</h5>

							</div>
							<div class="ibox-content no-padding bg-muted" id="">

								<%=opsReport.getStudentReportDetailsForTable(assessmentId,batchId)%>



							</div>
						</div>
					</div>
					  <div class="col-lg-1 no-padding bg-muted" style="display:none">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Student Score Table</h5>

							</div>
							<div class="ibox-content no-padding bg-muted">


								<%=opsReport.getStudentScoreDetailsForTable(assessmentId,batchId)%>


							</div>
						</div>
					</div>   
					<div class="col-lg-3 no-padding bg-muted">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Student Percentage Table</h5>

							</div>
							<div class="ibox-content no-padding bg-muted">

								<%=opsReport.getStudentPercentageDetailsForTable(assessmentId,batchId)%>


							</div>
						</div>
					</div>
					<div class="col-lg-3 no-padding bg-muted">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
							<% int totalQuestion = opsReport.getTotalNoOfQuestions(assessmentId); %>
								<h5>Total No Of Questions: <%=totalQuestion %></h5>

							</div>
							<div class="ibox-content no-padding bg-muted">


								<%--  <%=opsReport.getStudentScoreDetailsForTable(assessmentId,batchId)%>  --%>


							</div>
						</div>
					</div> 
				</div>
			</div>


		</div>
	</div>
	<div class="col-lg-4 no-padding bg-muted">
		<div class="ibox float-e-margins no-margins bg-muted" >

			<div class="ibox-content">
				<div class="row">
					<div id="student_score_graph_container" style="display:none"></div>
				</div>
			</div>
		</div>
		<div class="ibox float-e-margins no-margins bg-muted">

			<div class="ibox-content">
				<div class="row">
					<div id="student_precentage_graph_container"></div>
				</div>
			</div>
		</div>
	</div>
</div>