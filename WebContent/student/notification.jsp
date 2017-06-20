<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.android.pojo.NotificationPOJO"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
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
.feed-activity-list {
	overflow-y: hidden !important;
	  height: auto !important;
	
}

</style>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(449);
	request.setAttribute("cp", cp);
	
%>


<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="ibox float-e-margins">

				<div class="ibox-content">

					<div>
						<div class="feed-activity-list">

							<% 
							List<NotificationPOJO> arr = new ArrayList<>();
							if(cp.getNotifications() != null && cp.getNotifications().size()>0)
							arr = cp.getNotifications();
							Collections.sort(arr,new Comparator<NotificationPOJO>() {
				                public int compare(NotificationPOJO o1, NotificationPOJO o2) {
				                    if (o1.getTime() == null) {
				                        return (o2.getTime() == null) ? 0 : -1;
				                    }
				                    if (o2.getTime() == null) {
				                        return 1;
				                    }
				                    return o2.getTime().compareTo(o1.getTime());
				                }
				            });
							if(arr != null && arr.size()>0){
							for( NotificationPOJO notification : arr) {
								String styles = "65px";
								if(notification.getImageURL() != null && notification.getImageURL().equalsIgnoreCase("http://cdn.talentify.in/course_images/assessment.png")){
									styles=" 65px;";
								}
							%>
							
							
							<div class="feed-element">
								<a href="profile.html" class="pull-left"> <img alt="image"
									class="img-circle"
									src="<%=notification.getImageURL() %>" style="width: <%=styles%> !important; height: 65px !important; ">
								</a>
								<div class="media-body ">
									<%
										PrettyTime p = new PrettyTime();
											Timestamp createdAt = (Timestamp) notification.getTime();
											String time = p.format(createdAt);
									%>
									<%=notification.getMessage()%>
									<br> <small class="text-muted"><%=time%></small>
								</div>
							</div>
							<%}}else{ %>
							<div><h3>No Notification Available</h3></div>
							<%} %>
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
