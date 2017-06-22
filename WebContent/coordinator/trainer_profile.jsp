<%@page import="tfy.admin.trainer.TaskCardFactoryRecruitment"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.istarindia.android.pojo.CoursePOJO"%>
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
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	int trainerId = Integer.parseInt(request.getParameter("trainer_id"));
	trainerId = 6077;
%>


<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
				<div class='col-md-4'><%=(new TaskCardFactoryRecruitment()).showTrainerProfileCard(trainerId).toString()%></div>
				<div class="col-md-8">
				<div class="row">
				<%=(new TaskCardFactoryRecruitment()).showSummaryCard(trainerId).toString()%>
				</div>
				</div>
				
				
				</div>
			</div>
		</div>
	</div>



	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>

</html>
