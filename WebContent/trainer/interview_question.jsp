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
	Course course=new CourseDAO().findById(courseId);
	
%>
<body class="top-navigation">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10 m-l-md">
					<h2>
						<small>Interview Questions for</small> <strong><%=(course!=null && course.getCourseName()!=null?course.getCourseName():"") %></strong>
					</h2>

				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<div class="row"></div>
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