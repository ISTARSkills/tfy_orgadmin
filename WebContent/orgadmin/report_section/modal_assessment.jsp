<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.superadmin.services.ReportDetailService"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	int assessment_id = 0;
	if (request.getParameter("assessment_id") != null) {
		assessment_id = Integer.parseInt(request.getParameter("assessment_id"));
	}

	int batch_id = 0;
	if (request.getParameter("batch_id") != null) {
		batch_id = Integer.parseInt(request.getParameter("batch_id"));
	}

	ReportDetailService service = new ReportDetailService();
%>
<div class="modal inmodal" id="assessment_modal_<%=assessment_id%>"
	tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content animated flipInY">

			<!-- start -->

			<div class="row">
				<div class="col-lg-4">

					<div class="ibox full-height modal-height" >
						<div class="ibox-header">
							<h3 class="font-bold m-l-sm">Students</h3>
						</div>

						<div class="ibox-content full-height-scroll">
							<%
								List<HashMap<String, Object>> studentList = service.getAllStudents(batch_id);
								for (HashMap<String, Object> item : studentList) {
							%>
							<div class="row">
								<div
									class="product-box p-xl b-r-lg border-left-right border-top-bottom text-center modal-student"
									style="min-height: 100px; border-width: 1px;"
									data-user='<%=item.get("student_id")%>'
									data-assessment='<%=assessment_id%>' data-batch='<%=batch_id%>'>
									<div class="col-lg-4" style="margin-top: 3px;">
										<img alt="image" class="img-circle m-l-xxs student_image"
											src='<%=item.get("profile_image")%>'
											/>
									</div>
									<div class="col-lg-8" style="margin-top: 3px;">
										<p class="m-r-sm m-t-sm"><%=item.get("name")%>
											<small class="text-muted"><%=item.get("email")%></small>
										</p>
									</div>
								</div>
							</div>
							<br />
							<%
								}
							%>

						</div>
					</div>
				</div>


				<div class="col-lg-8">

					<div class="ibox">
						<div class="ibox-header">
							<h3 class="font-bold">Questions</h3>
						</div>
						<div id="modal_question_holder" class="full-height modal-height"></div>
					</div>
				</div>
			</div>
			<!-- end -->
		</div>
	</div>
</div>