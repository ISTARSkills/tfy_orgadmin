
<%@page import="tfy.admin.trainer.ClusterRequirmentUtil"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<style>
.row {
	margin-right: 0px !important;
	margin-left: 0px !important;
}

.h-370 {
	min-height: 375px !important;
	max-height: 375px !important;
}

.button-top {
	margin-top: -12px !important;
}

.assessment-circle-img {
	width: 50%;
	height: 40%;
}

.session-square-img {
	width: 160px;
	height: 160px;
}

.btn-rounded {
	min-width: 200px;
	background: #eb384f;
	color: white;
}

.task-complete-header {
	background: #23b6f9 !important;
}

#vertical-timeline {
	overflow-x: hidden;
	overflow-y: auto;
	max-height: 250px;
}

.vertical-container {
	width: 99% !important;
}

.vertical-timeline-content p {
	margin-bottom: 2px !important;
	margin-top: 0 !important;
	line-height: 1.6 !important;
}

.content-border {
	border: none !important;
}

.btn.banner:hover {
	color: white !important
}

.nav-tabs>li.active>a:hover, a:focus, a:active {
	border-radius: 50px !important;
}

.btn.banner.focus, .btn.banner:focus, .btn.banner:hover {
	color: white !important;
}
</style>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
%>
<body class="top-navigation" id="coordinator_overall_cluster">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>
						<small>Over All Hiring Report</small>
					</h2>
				</div>
				<div class="col-lg-2 m-t-sm">
				</div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<div class="row">
					<%
						ClusterRequirmentUtil clusterRequirmentUtil = new ClusterRequirmentUtil();
					%>
					<div class="col-md-12">
						<div class="ibox float-e-margins">
							<div class="ibox-content" style="padding-bottom: 30px;">
								<div class="ibox-title">
									<h5>Add Requirements</h5>
								</div>
								<form role="form" class="">
									<div class="row">

										<div class="form-group col-md-3">
											<label class="control-label">PinCode:</label> <select
												class="js-data-example-ajax  form-control" id="pincode_data"
												data-pin_uri="<%=baseURL%>" name="pincode"
												data-validation="required" required>
												<option value="">Select Pincode</option>
											</select>
										</div>

										<div class="form-group col-md-3">
											<label class="control-label">Course:</label> <select
												class="form-control" id="course_data" name="course"
												data-validation="required" required>
												<option value="">Select Course</option>

												<%
													for (HashMap<String, Object> item : clusterRequirmentUtil.getCoursees()) {
												%>
												<option value="<%=item.get("id")%>"><%=item.get("course_name")%>(<%=item.get("id")%>)
												</option>
												<%
													}
												%>

											</select>
										</div>
										<div class="form-group col-md-3">
											<label class="control-label">Requirement:</label> <input
												type="number" placeholder="Number of requirements"
												id="requirement_number" min="0" class="form-control">
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

				</div>
				<div class="col-lg-12">
					<div class="ibox">
						<div class="ibox-content">

							<div class="row">
								<%
									ReportUtils util = new ReportUtils();
									HashMap<String, String> conditions = new HashMap();
									conditions.put("limit", "100");
									conditions.put("offset", "0");
									conditions.put("static_table", "true");
								%>
								<%=util.getTableOuterHTML(3066, conditions)%>
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