<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="org.omg.CosNaming.IstringHelper"%>
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

				<div class="row white-bg">
					<div class="col-lg-10">
						<h2 style="margin-left: 30px">
							<strong>Dashboard</strong> <small>These are the list of
								interviews you need to schedule today.</small>
						</h2>
					</div>
					<div class="col-lg-2"></div>
				</div>

				<div class="row white-bg" id="filters" style="margin-top: 20px;">
					<div class="big-demo go-wide" data-js="filtering-demo">
						<div
							class="filter-button-group button-group js-radio-button-group m-l-sm">
							<span class="badge badge-info">Filter by Stage</span>
							<div class="row m-t-xs">
								<div class="col-md-10">
									<button class="btn btn-outline btn-warning btn-xs is-checked"
										style="margin-bottom: 5px; margin-right: 5px" data-filter="*">show
										all</button>
									<%
										for (int i = 4; i <= 6; i++) {
									%>
									<button class="btn btn-outline btn-warning btn-xs"
										style="margin-bottom: 5px; margin-right: 5px"
										data-filter=".stage_L<%=i%>"><%=schedularUtil.getStage(("L" + i))%></button>
									<%
										}
									%>
								</div>
							</div>
						</div>
					</div>
				</div>

			</div>


			<div class="wrapper wrapper-content animated fadeInRight grey-bg"
				style="padding: 20px; margin-left: 5px">
				<div class='row-fluid grid' id="dashboard_cads">
					<%
						List<HashMap<String, Object>> dataL4 = schedularUtil.getDashboardCardListsL4();
						List<HashMap<String, Object>> dataL5 = schedularUtil.getDashboardCardListsL5();
						List<HashMap<String, Object>> dataL6 = schedularUtil.getDashboardCardListsL6();

						List<HashMap<String, Object>> finalList = new ArrayList();
						finalList.addAll(dataL4);
						finalList.addAll(dataL5);
						finalList.addAll(dataL6);
						for (HashMap<String, Object> item : finalList) {
							String stage = item.get("stage").toString();
							String temp = "L";
							int stageCount = Integer.parseInt(stage.charAt(stage.length() - 1) + "") + 1;
							stage = temp + stageCount;

							int trainerId = (int) item.get("trainer_id");
							int courseId = (int) item.get("course_id");
							String uniq_id = courseId + "_" + trainerId;
							IstarUser trainer = new IstarUserDAO().findById(trainerId);
							Course course = new CourseDAO().findById(courseId);
							List<HashMap<String, Object>> interViewData = schedularUtil.isAlreadyScheduled(trainerId + "", stage);
						///	if (interViewData != null && interViewData.size() == 0) {
					%>
					<div
						class="col-md-3 element-item <%=CoordinatorSchedularUtil.createClassNameStage(stage)%>"
						id="interview_holder_<%=uniq_id%>">
						<div class="ibox">


							<div class="ibox-content  product-box" style="padding: 20px;">
								<div class="row" style="border-bottom: 1px solid #e7eaec;">
									<div class="col-md-10">
										<%
											String firstName = "FIRST NAME";
													if (trainer != null) {
														try {
															firstName = trainer.getUserProfile().getFirstName();
														} catch (Exception npe) {
														}
										%>
										<h3><%=firstName%></h3>
										<h5 class="no-padding">
											<i class="fa fa-envelope-o fa-1x"></i> <small><%=trainer.getEmail()%></small>
										</h5>
									</div>
									<div class="col-md-2 pull-right">
										<a
											href="<%=baseURL%>coordinator/trainer_profile.jsp?trainer_id=<%=trainerId%>"
											target="_blank" data-toggle="tooltip"
											title="Click here to see trainer performance details"> <img
											style="width: 42px;"
											src='<%=AppProperies.getProperty("media_url_path")%><%=(trainer != null && trainer.getUserProfile() != null
								&& trainer.getUserProfile().getImage() != null) ? trainer.getUserProfile().getImage()
										: ""%>'></a>
									</div>
								</div>
								<div class="product-desc" style="padding-bottom: 0px;">
									<div class="row text-center font-bold bg-muted small p-xxs">
										<div class="col-xs-6 col-md-6" style="display: none">Stage</div>
										<div class="col-xs-6 col-md-6" style="display: none">Course</div>
									</div>
									<div class="row text-center p-xxs"
										style="font-size: 28px; color: #eb384f;">
										<div class="col-xs-6 col-md-6">
											<i class="fa fa-trophy fa-3x"></i>
										</div>

										<div class="col-xs-6 col-md-6">
											<img style="width: 85px;"
												src='<%=AppProperies.getProperty("media_url_path")%><%=course.getImage_url()%>'></a>
										</div>
									</div>
									<div class="row text-center font-bold medium p-xxs m-b-xs"
										style="font-size: 14px;">
										<div class="col-xs-4 col-md-6"><%=schedularUtil.getStage(stage)%></div>
										<div class="col-xs-4 col-md-6"><%=course.getCourseName()%></div>
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
								<button type="button"
									class="banner btn btn-rounded submit_form "
									data-unique='<%=uniq_id%>'>Schedule</button>
							</div>
						</div>
					</div>

					<%
						//}
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