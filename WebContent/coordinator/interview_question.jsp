<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="tfy.admin.trainer.CoordinatorSchedularUtil"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	int courseId = 0;
	String stage = "";

	if (request.getParameter("course_id") != null) {
		courseId = Integer.parseInt(request.getParameter("course_id"));
	}

	if (request.getParameter("stage") != null) {
		stage = request.getParameter("stage");
	}

	CoordinatorSchedularUtil util = new CoordinatorSchedularUtil();
	Course course = new CourseDAO().findById(courseId);
%>
<body class="top-navigation">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10 m-l-md">
					<h2>
						<small>Interview Questions for</small> <strong><%=(course != null && course.getCourseName() != null ? course.getCourseName() : "")%></strong>
					</h2>

				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<%-- <div class="row">
					<div class="col-md-12">
						<div class="ibox float-e-margins">
							<div class="ibox-content" style="padding-bottom: 30px;">
								<div class="ibox-title">
									<h5>Add Interview Question</h5>
								</div>
								<form role="form" class="">
									<div class="row">
										<div class="form-group col-md-3">
											<label class="control-label">Course:</label> <select
												class="form-control" id="course_data" name="course"
												data-validation="required" required>
												<option value="">Select Course</option>

												<%
													for (HashMap<String, Object> item : util.getCoursees()) {
												%>
												<option value="<%=item.get("id")%>"><%=item.get("course_name")%>(<%=item.get("id")%>)
												</option>
												<%
													}
												%>

											</select>
										</div>
										<div class="form-group col-md-3">
											<label class="control-label">Question Text:</label>
											<div class='row p-sm'>
												<textarea rows='4' cols='38' style='margin-top: 10px;'
													id='question_text'>
													</textarea>
											</div>
										</div>

										<div class="form-group col-md-3">
											<label class="control-label">Option Text:</label> 
											<div class='row p-sm'>
												<textarea rows='4' cols='38' style='margin-top: 10px;'
													id='option_text'>
													</textarea>
											</div>
											
										</div>


										<div class="form-group col-md-3 text-center">
											<button class="btn btn-outline btn-primary m-t-md"
												type="button" id="add_requirement">
												<i class="fa fa-plus-square"></i> Add Requirement
											</button>
										</div>
									</div>
								</form>

							</div>
						</div>

					</div>

				</div> --%>
				<div class="col-lg-12">
					<div class="ibox">
						<div class="ibox-content">
							<div class="table-responsive">
								<table class="table table-hover issue-tracker">

									<thead>
										<tr>
											<th>#</th>
											<th>Question</th>
											<th>Answer</th>
										</tr>
									</thead>

									<%
										List<HashMap<String, Object>> data = util.getAllInterviewQuestions(stage, courseId);

										if (data != null && data.size() != 0) {
									%>

									<tbody>

										<%
											int i = 1;
												for (HashMap<String, Object> item : data) {
										%>

										<tr>
											<td><%=i++%></td>
											<td><p><%=item.get("question_text")%></p></td>
											<td><p><%=item.get("answer_text")%></p></td>
										</tr>

										<%
											}
										%>

									</tbody>
									<%
										}
									%>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>