<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="tfy.admin.trainer.CoordinatorSchedularUtil"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<style>
th {
	text-align: center
}

.label {
	line-height: 22px;
}
</style>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	DBUTILS util = new DBUTILS();
	CoordinatorSchedularUtil schedularUtil = new CoordinatorSchedularUtil();
%>
<body class="top-navigation student_pages" id="coordinator_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="row wrapper border-bottom  page-heading white-bg">
				<div class="col-lg-10">
					<h2 style="margin-left: 30px">
						<strong>Coordinator Dashboard</strong>
					</h2>
				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight grey-bg" style="padding: 20px; margin-left: 5px">
				<div class='row' id="dashboard_cads">
					<%
						List<HashMap<String, Object>> data = schedularUtil.getDashboardCardLists();
						for (HashMap<String, Object> item : data) {

							String stage = item.get("stage").toString();
							String temp = "L";
							int stageCount = Integer.parseInt(stage.charAt(stage.length() - 1) + "") + 1;
							stage = temp + stageCount;

							int trainerId = (int) item.get("trainer_id");
							int courseId = (int) item.get("course_id");
							String uniq_id = courseId + "_" + trainerId;

							List<HashMap<String, Object>> interViewData = schedularUtil.isAlreadyScheduled(trainerId + "", stage);
							if (interViewData != null && interViewData.size() == 0) {
					%>
					<div class="col-md-3" id="interview_holder_<%=uniq_id%>">
						<div class="ibox">

							<div class="ibox-title">
								<div class="row">
									<div class="col-md-10">
										<h3><%=item.get("first_name")%></h3>
										<h5 class="no-padding">
											<i class="fa fa-envelope-o fa-1x"></i> <small><%=item.get("email")%></small>
										</h5>
									</div>
									<div class="col-md-2 pull-right">
										<a href="<%=baseURL%>coordinator/trainer_profile.jsp?trainer_id=<%=trainerId%>" class="btn btn-primary	 btn-xs text-center" target="_blank"><i class="fa fa-user-circle btn-primary" aria-hidden="true"></i></a>
									</div>
								</div>
							</div>

							<div class="ibox-content  product-box" style="padding: 20px;">
								<div class="product-desc" style="padding-bottom: 0px;">
									<div class="row text-center font-bold bg-muted small p-xxs">
										<div class="col-xs-6 col-md-6">Stage</div>
										<div class="col-xs-6 col-md-6">Course</div>
									</div>
									<div class="row text-center p-xxs" style="font-size: 28px; color: #eb384f;">
										<div class="col-xs-6 col-md-6">
											<i class="fa fa-trophy"></i>
										</div>

										<div class="col-xs-6 col-md-6">
											<i class="fa fa-shield"></i>
										</div>
									</div>
									<div class="row text-center font-bold medium p-xxs m-b-xs" style="font-size: 14px;">
										<div class="col-xs-4 col-md-6"><%=schedularUtil.getStage(stage)%></div>
										<div class="col-xs-4 col-md-6"><%=item.get("course_name")%></div>
									</div>

									<jsp:include page="./coordinator_interview.jsp">
										<jsp:param value='<%=courseId%>' name="course_id" />
										<jsp:param value='<%=stage%>' name="stage_id" />
										<jsp:param value='<%=trainerId%>' name="trainerID" />
										<jsp:param value='<%=uniq_id%>' name="uniq_id" />
									</jsp:include>
								</div>
							</div>
							<div class="form-group text-center button-top">
								<button type="button" class="banner btn btn-rounded submit_form " data-unique='<%=uniq_id%>'>Schedule</button>
							</div>
						</div>
					</div>

					<%
						}
						}
					%>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>