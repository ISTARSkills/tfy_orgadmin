<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.istarindia.android.pojo.AssessmentResponsePOJO"%>
<%@page import="tfy.admin.trainer.TrainerReportService"%>
<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="com.istarindia.android.pojo.OptionPOJO"%>
<%@page import="org.apache.commons.collections.CollectionUtils"%>
<%@page import="com.istarindia.android.pojo.QuestionPOJO"%>
<%@page import="com.istarindia.android.pojo.AssessmentPOJO"%>
<%@page import="com.istarindia.android.pojo.SkillReportPOJO"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.dao.entities.QuestionDAO"%>
<%@page import="com.istarindia.android.pojo.QuestionResponsePOJO"%>
<%@page import="com.istarindia.android.pojo.AssessmentReportPOJO"%>
<%@page import="org.omg.CosNaming.IstringHelper"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
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
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	
%>
<body class="top-navigation" >
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2><small>Over All Hiring Report</small></strong> </h2>

				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<div class="row">
			
				</div>
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-content">

<div class="row">
					<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "10");
				conditions.put("offset", "0");		conditions.put("static_table", "true");		
				%>				
				<%=util.getTableOuterHTML(3067, conditions)%>
				</div>

							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>