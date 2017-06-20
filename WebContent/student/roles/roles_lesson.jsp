<%@page import="com.istarindia.android.pojo.LessonPOJO"%>
<%@page import="com.istarindia.android.pojo.ConcreteItemPOJO"%>
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
	min-height: 220px !important;
	max-height: 220px !important;
}

.btn-rounded {
	min-width: 200px;
    margin-top: -16px;
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

.product-desc {
	padding: 15px !important;
}
h2 small {
	font-size: 61% !important;
	line-height: normal;
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
	String module_id = request.getParameter("module_id");
	System.out.println("module_id =========> " + module_id);
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
									if(modulePOJO.getId() == Integer.parseInt(module_id) && modulePOJO.getLessons() != null){
									for(ConcreteItemPOJO lesson : modulePOJO.getLessons()){
										LessonPOJO less = lesson.getLesson();
					%>
					<div class="col-md-3 ">
						<div class="ibox">
							<div class="ibox-content product-box h-370">
								<div class="product-desc m-t-md">
									<div class="medium m-t-xs">
										<div class="text-center font-bold m-t-sm"><h2><%=less.getTitle()%></h2></div>
										<div class="text-center font-normal m-t-md" style="line-height: normal;"><h2><small><%=less.getDescription()%></small></h2></div>
									</div>

								</div>
							</div>
							<div class="text-center button-top">
								<a class="btn btn-rounded" href="#">BEGIN SKILL</a>
							</div>
						</div>
					</div>
					<%
									}}}
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
