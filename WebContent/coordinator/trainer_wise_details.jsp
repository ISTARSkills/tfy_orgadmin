<%@page import="com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes"%>
<%@page import="com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes"%>
<%@page import="in.orgadmin.utils.report.CustomReportUtils"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>

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
%>
<body class="top-navigation" id="coordinator_trainer_details">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>
						<strong>Trainer Dashboard</strong>
					</h2>
				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight" style="padding: 20px;">
				<div class="row" id="filters">

					<div class=" col-lg-2 input-group pull-right">
						<input type="text" id="user_keyword" name="user_keyword" class="form-control"> <span class="input-group-btn">
							<button type="button" id="user_search_button" class="btn btn-primary">search</button>
						</span>
					</div>	
					<%
						DBUTILS utils = new DBUTILS();
						String sql = "select course_name from cluster_requirement, course where course.id= cluster_requirement.course_id";
						List<HashMap<String, Object>> items = utils.executeQuery(sql);
					%>
					<div class="big-demo go-wide" data-js="filtering-demo">
						<div class="filter-button-group button-group js-radio-button-group">
							<span class="badge badge-info">Course</span>
							<button class="button is-checked" data-filter="*">show all</button>
							<%
								for (HashMap<String, Object> item : items) {
							%>
							<button class="button" data-filter=".course_<%=item.get("course_name").toString().replaceAll("-", "_").replaceAll(" ", "_").replaceAll("/", "___").trim()%>"><%=item.get("course_name").toString()%></button>
							<%
								}
							%>
						</div>

					</div>
					<%
						String sql1 = "select * from cluster";
						List<HashMap<String, Object>> items1 = utils.executeQuery(sql1);
					%>
					<div class="row" style="margin-top: 20px">
						<div class="big-demo go-wide" data-js="filtering-demo">
							<div class="filter-button-group button-group js-radio-button-group">
								<span class="badge badge-info">Filter by Cluster</span>
								<button class="button is-checked" data-filter="*">show all</button>
								<%
									for (HashMap<String, Object> item : items1) {
								%>
								<button class="button" data-filter=".cluster_<%=item.get("cluster_name").toString().replaceAll("-", "_").replaceAll(" ", "_").replaceAll("/", "___").trim()%>"><%=item.get("cluster_name").toString()%></button>
								<%
									}
								%>
							</div>

						</div>
					</div>
					<div class="row grid" id="searchable_grid" style="margin-top: 30px">


						<%
							CustomReportUtils reportUtil = new CustomReportUtils();
							String sql2 = reportUtil.getReport(43).getSql();
							List<HashMap<String, Object>> data = util.executeQuery(sql2);

							for (int i = 0; i < data.size(); i++) {
						%>
						<a href='trainer_profile.jsp?trainer_id=<%=data.get(i).get("id")%>' >
						
						<div data-name='<%=data.get(i).get("first_name").toString().replaceAll(" ", "_")%>' 
						 class="col-lg-5 element-item <%=UIUtils.createClassNameCLuster(data.get(i).get("clusters").toString())%> 
						  <%=UIUtils.createClassNameCourse(data.get(i).get("courses").toString())%>">
							<div class="contact-box">
								<div class="col-sm-4">
									<div class="text-center">
										<img style="width: 80px !important; height: 80px !important;" alt="image"
										 class="img-circle m-t-xs img-responsive" 
										 src="<%=user.getUserProfile().getProfileImage() %>">
									</div>
								</div>
								<div class="col-sm-8">
									<h3>
										<strong><%=data.get(i).get("first_name")%></strong>
									</h3>
									<p>
										<i class="fa fa-envelope"></i>&nbsp;
										<%=data.get(i).get("email")%></p>
									<address>
										<p>
											<i class="fa fa-phone"></i>&nbsp;
											<%=data.get(i).get("mobile")%></p>
									</address>
								</div>
								<table class="table table-bordered">
									<thead>
										<tr>
											<th>Course</th>
											<th>Level 1</th>
											<th>Level 2</th>
											<th>Level 3</th>
											<th>Level 4</th>
										</tr>
									</thead>
									<tbody>

										<%
											if (data.get(i).get("courses") != null && !data.get(i).get("courses").toString().equalsIgnoreCase("")) {
													String[] courses = data.get(i).get("courses").toString().split(",<br>");
													for (String course : courses) {
										%>
										<tr>
											<td><%=course%>&nbsp; <i class="fa fa-check text-navy"></i></td>
											<td>12/36 &nbsp; <i class="fa fa-times"></i></td>
											<td>12/33 &nbsp; <i class="fa fa-check text-navy"></i></td>
											<td>38 &nbsp; <i class="fa fa-times"></i></td>
											<td>40 &nbsp; <i class="fa fa-check text-navy"></i></td>
										</tr>
										<%
											}
												}
										%>
									</tbody>
								</table>
								<%
									if (data.get(i).get("slots") != null && !data.get(i).get("slots").toString().equalsIgnoreCase("")) {
								%>
								<div class="row">
									<div class="col-lg-12">
										<h5>Slots:</h5>

										<%
											String[] slots = data.get(i).get("slots").toString().split("<br>");
													for (String slot : slots) {
										%>
										<button class="btn btn-white btn-xs" type="button"><%=slot.replaceAll("- 9am, 9am -","-").replaceAll("- 10am, 10am -","-").replaceAll("- 11am, 11am -","-").replaceAll("- 12pm, 12pm -","-").replaceAll("- 1pm, 1pm -","-").replaceAll("- 2pm, 2pm -","-").replaceAll("- 3pm, 3pm -","-").replaceAll("- 4pm, 4pm -","-").replaceAll("- 5pm, 5pm -","-")%></button>
										<br />
										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>

								<%
									if (data.get(i).get("cities") != null && !data.get(i).get("cities").toString().equalsIgnoreCase("")) {
								%>
								<div class="row">
									<div class="col-lg-12">
										<h5>Cities:</h5>
										<%
											String[] cities = data.get(i).get("cities").toString().split(",");
													for (String city : cities) {
										%>
										<button class="btn btn-white btn-xs" type="button"><%=city%></button>
										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>

								<%
									if (data.get(i).get("clusters") != null
												&& !data.get(i).get("clusters").toString().equalsIgnoreCase("")) {
								%>
								<div class="row">
									<div class="col-lg-12">
										<h5>Cluster:</h5>
										<%
											String[] clusters = data.get(i).get("clusters").toString().split(",");
													for (String cluster : clusters) {
										%>
										<button class="btn btn-white btn-xs" type="button"><%=cluster%></button>
										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>
							</div>
						</div></a>
						<%
							}
						%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>