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
</style>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	request.setAttribute("cp", cp);
	boolean flag = false;
	
	
	
%>


<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"/>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight">
				
				<% 
				List<TaskSummaryPOJO> filterTaskList = new ArrayList<>();
				if(cp!=null && cp.getTasks()!=null){
					for(TaskSummaryPOJO task : cp.getTasks()){
					if(task!= null && task.getStatus()!= null && task.getDate() != null && !task.getStatus().equalsIgnoreCase("COMPLETED")){
						
						if(sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0){
							filterTaskList.add(task);
						}
						
					}else{
						if(task!= null && task.getStatus()!= null  && task.getDate() != null){
							if(sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0)
						flag =true;
						}
					}
				}
					
					System.out.println("filterTaskList------------"+filterTaskList.size());
				}
				
				int i=0;
				if(flag){
				(new TaskCardFactory()).showSummaryCard(filterTaskList).toString() ;

				}
				for(TaskSummaryPOJO task :filterTaskList) { 
				
				%>

				<%=(new TaskCardFactory()).showcard(task).toString() %>
				
				<%  } %>


			</div>
		</div>
	</div>



	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>

</html>
