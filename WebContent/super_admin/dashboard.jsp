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
	
	UIUtils uiUtil = new UIUtils();
	JSONArray calendardata = null;
%>
<body class="top-navigation" id="superadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->
			<jsp:include page="partials/events_stats.jsp"></jsp:include>
			<!-- End Table -->
			<div class="row" id="dashboard_holder">
				<!-------------------------------------------Today Events and Notifications  -------------------------------------------------------->
				<jsp:include page="ajax_partials/dashboard_left.jsp" />
				<!---------------------------------------Today Events and Notifications Ends ---------------------------------------------------->

				<jsp:include page="partials/charts_dashboard.jsp" />
			</div>
			
			<!-- edit modal -->

								<div class="modal inmodal" id="myModal2" tabindex="-1"
									role="dialog" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event-edit-modal">

										</div>
									</div>
								</div>


		<!--  -->
			<!-- event details modal -->

								<div class="modal inmodal" id="event_details" tabindex="-1"
									role="dialog" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event_details">

										</div>
									</div>
								</div>


		<!--  -->
			

		</div>
		
		<%-- <jsp:include page="../chat_element.jsp"></jsp:include> --%>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>
