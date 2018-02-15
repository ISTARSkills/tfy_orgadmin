<%@page import="com.viksitpro.core.logger.ViksitLogger"%>
<%@page import="com.viksitpro.core.utilities.TaskItemCategory"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
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
	boolean flag = false;
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	if (cp == null) {
		flag = true;
		request.setAttribute("msg", "User Does Not Have Permission To Access");
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}
	request.setAttribute("cp", cp);
%>
<body class="top-navigation">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp" />
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<%
					if (!flag) {
				%>
				<%=(new TaskCardFactory()).showSummaryEvents(cp).toString()%>
				<%=(new TaskCardFactory()).showSummaryCard(cp).toString()%>
				<%
					//int k = 0;

						List<TaskSummaryPOJO> taskSummaryPOJOList = cp.getTasks();
						try {
							Collections.sort(taskSummaryPOJOList, new Comparator<TaskSummaryPOJO>() {
								public int compare(TaskSummaryPOJO o1, TaskSummaryPOJO o2) {
									if (o1.getDate() == null) {
										return (o2.getId() == null) ? 0 : 1;
									}
									if (o2.getDate() == null) {
										return -1;
									}
									return o2.getDate().compareTo(o1.getDate());
								}
							});
						} catch (Exception e) {
							e.printStackTrace();
						}

						for (TaskSummaryPOJO task : taskSummaryPOJOList) {
							//ViksitLogger.logMSG(this.getClass().getName(),">>>>>>>>>"+task.getItemType());
							//ViksitLogger.logMSG(this.getClass().getName(),"task.getStatus() "+task.getStatus());
							if ((sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0)
									&& !task.getStatus().equalsIgnoreCase("COMPLETED")) {
							//	ViksitLogger.logMSG(this.getClass().getName(),"today date" + task.getDate());
							//	ViksitLogger.logMSG(this.getClass().getName(),"today itemType " + task.getItemType());
								if ((task.getItemType().equalsIgnoreCase(TaskItemCategory.CLASSROOM_SESSION_STUDENT)
										|| task.getItemType().equalsIgnoreCase(TaskItemCategory.REMOTE_CLASS_STUDENT)
										|| task.getItemType().equalsIgnoreCase(TaskItemCategory.WEBINAR_STUDENT)
										|| task.getItemType().equalsIgnoreCase(TaskItemCategory.WEBINAR_TRAINER)
										|| task.getItemType().equalsIgnoreCase(TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWEE)
										|| task.getItemType().equalsIgnoreCase(TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWER))) {
									
									
				%>

				<%=(new TaskCardFactory()).showcard(task).toString()%>

				<%
					}

							}

						}

						for (TaskSummaryPOJO task : taskSummaryPOJOList) {

							if (!(sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) > 0)
									&& !task.getStatus().equalsIgnoreCase("COMPLETED")) {

								//ViksitLogger.logMSG(this.getClass().getName(),"previous date " + task.getDate());
								//ViksitLogger.logMSG(this.getClass().getName(),"previous itemType " + task.getItemType());

								if (task.getItemType().equalsIgnoreCase(TaskItemCategory.LESSON_PRESENTATION)
										|| task.getItemType().equalsIgnoreCase(TaskItemCategory.ASSESSMENT)
										|| task.getItemType().equalsIgnoreCase(TaskItemCategory.CUSTOM_TASK)) {
				%>

				<%=(new TaskCardFactory()).showcard(task).toString()%>

				<%
					}

							}

						}
					}
				%>
			</div>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>