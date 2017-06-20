<%@page import="com.viksitpro.core.utilities.TaskItemCategory"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<link href="inc/student_custom.css" rel="stylesheet">
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	request.setAttribute("cp", cp);
	boolean flag = false;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<body class="top-navigation" id="trainer_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content animated fadeInRight">
				<%
					List<TaskSummaryPOJO> todaysCompletedTask = new ArrayList<>();
					List<TaskSummaryPOJO> todaysInCompletedTask = new ArrayList<>();
					if (cp != null && cp.getTasks() != null) {
						for (TaskSummaryPOJO task : cp.getTasks()) {
							if (task != null && task.getStatus() != null && task.getDate() != null && !task.getStatus().equalsIgnoreCase("COMPLETED")) {

								if (sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0) {
									todaysCompletedTask.add(task);
								}
							} else {
								if (task != null && task.getStatus() != null && task.getDate() != null) {
									if (sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0)
										todaysInCompletedTask.add(task);
								}
							}
						}

					}

					if (todaysCompletedTask.size() > 0) {
				%>
				<div class='col-md-3 '>
					<div class='ibox'>
						<div class='ibox-content product-box h-370'>
							<div class='task-complete-header bg-primary'>
								<h6 class='p-xxs font-normal bg-muted m-l-xs m-t-none'>TODAY'S ACTIVITY</h6>
								<h3 class='p-xxs m-l-xs'><%=todaysCompletedTask.size()%>
									Tasks Completed
								</h3>
							</div>
							<div class='product-desc no-padding'>


								<div class='ibox-content no-padding content-border' id='ibox-content'>
									<div id='vertical-timeline' class='vertical-container dark-timeline left-orientation'>
										<%
											for (TaskSummaryPOJO task : todaysInCompletedTask) {

												%>

												<%=(new TaskCardFactory()).showcard(task).toString() %>
												
												<%
												}
										%>
									</div>



									<div class='m-l-lg'>
										<i class='fa fa-circle-thin m-r-md'></i><%=todaysInCompletedTask%>
										tasks remaining for the day
									</div>
								</div>

							</div>
						</div>

					</div>
				</div>
				<%
					}
				%>

			</div>
		</div>

		<%-- <jsp:include page="../chat_element.jsp"></jsp:include> --%>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>
