<%@page import="com.istarindia.android.pojo.ModulePOJO"%>
<%@page import="com.istarindia.android.pojo.CoursePOJO"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<style>
.row {
	margin-right: 0px !important;
	margin-left: 0px !important;
}

.h-370 {
	min-height: 400px !important;
	max-height: 400px !important;
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

.product-desc {
padding: 15px !important;
}
</style>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(449);
	request.setAttribute("cp", cp);
	String course_id = request.getParameter("course_id");
	System.out.println("course id =========> " + course_id);
%>


<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">

					<%
						int i = 0;
					if(cp != null && cp.getCourses() != null){
						for (CoursePOJO course : cp.getCourses()) {
							if (course.getId() == Integer.parseInt(course_id) && course.getModules() != null) {
								for (ModulePOJO modulePOJO : course.getModules()) {
					%>
					<a href="/student/roles/roles_lesson.jsp?course_id=<%=course.getId() %>&module_id=<%=modulePOJO.getId() %>" style="color: black;"><div class="col-md-3 ">
							<div class="ibox">
								<div class="ibox-content product-box h-370">
									<h3 class="p-xxs m-l-xs"><%=modulePOJO.getName()%></h3>
									<div class="product-imitation" style="padding: 0px !important;">
										<img alt="" src="<%=modulePOJO.getImageURL()%>"
											style="width: 100%; height: 190px;">
									</div>
									<div class="product-desc">


										<div class="medium m-t-xs">
										<% for(String skillLabel : modulePOJO.getSkillObjectives()){ %>
										<span class="badge m-b-xs font-normal" style="background: #eb384f;color: white;"><%=skillLabel %></span>
										<%} %>
										</div>

									</div>
								</div>

							</div>
						</div></a>
					<%
						}
							}
						}}
					%>

					
				</div>
			</div>
		</div>
	</div>



	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
</body>

</html>
