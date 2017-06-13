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
%>


<%
	UIUtils uiUtil = new UIUtils();
	JSONArray calendardata = null;
	 	IstarUser u = (IstarUser) request.getSession().getAttribute("user"); 
	int colegeID = (int) request.getSession().getAttribute("orgId");

	if (request.getParameter("course_id") != null
			&& !request.getParameter("course_id").toString().equalsIgnoreCase("null")) {
		calendardata = uiUtil.getCourseReportEvent(colegeID,
				Integer.parseInt(request.getParameter("course_id").toString()), "Program");
	}
	if (request.getParameter("batch_id") != null
			&& !request.getParameter("batch_id").toString().equalsIgnoreCase("null")) {
		calendardata = uiUtil.getCourseReportEvent(colegeID,
				Integer.parseInt(request.getParameter("batch_id").toString()), "Batch");
	}
	DBUTILS dbutils = new DBUTILS();
	
	//NotificationAndTicketServices serv = new NotificationAndTicketServices();
	//List<HashMap<String, Object>> data = serv.getNotificationAndTicket(u.getId());
	
%>
<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->
			<jsp:include page="partials/events_stats.jsp"></jsp:include>
			<!-- End Table -->
			<div class="row">
				<!-------------------------------------------Today Events and Notifications  -------------------------------------------------------->
				<div class="col-lg-6" id="dashboard_left_box">
					<div class="tabs-container">
						<ul class="nav nav-tabs">
							<li class="active"><a data-toggle="tab" href="#tab-1">Todays
									Events</a></li>
							<li class=""><a data-toggle="tab" href="#tab-2">Notifications&nbsp;&nbsp;<span
									class="label label-info pull-right" id="dashboard_notice_count" style="background-color: #eb384f !important;"></span></a></li>
						</ul>
						<div class="tab-content dash_main_tab">
							<div id="tab-1" class="tab-pane active">

								<div class="panel-body">

									<%
										OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();

										List<HashMap<String, Object>> items = dashboardServices.getTodaysEventData(colegeID);
										if (items.size() > 0) {
											//int i = 0;
											for (HashMap<String, Object> item : items) {

												//i++;
												String eventId = (String) item.get("event_id");
												int batch_group_id = (int) item.get("batch_group_id");
												int course_id = (int)item.get("course_id");
												int trainerId = (int) item.get("actor_id");
												List<HashMap<String, Object>> slideCount = dashboardServices.getSlideCount(eventId);
												List<HashMap<String, Object>> currentCMsession = dashboardServices.getCurrentCMSession(batch_group_id, course_id);
									%>
<jsp:include page="/session_cards/session_event_detail_card.jsp">
				<jsp:param value='<%=item.get("status") %>' name="status"/>
				<jsp:param value='<%=item.get("title") %>' name="title"/>
				<jsp:param value='<%=item.get("eventdate") %>' name="eventdate"/>
				<jsp:param value='<%=item.get("eventhour") %>' name="eventhour"/>
				<jsp:param value='<%=item.get("batchname") %>' name="batchname"/>
				<jsp:param value='<%=item.get("classroom_identifier") %>' name="classroom_identifier"/>
				<jsp:param value='<%=item.get("trainername") %>' name="trainername"/>
				<jsp:param value='<%=eventId %>' name="event_id"/>
				<jsp:param value='<%=item.get("trainer_image") %>' name="trainer_image"/>
				<jsp:param value='<%=item.get("actor_id") %>' name="trainer_id"/>
				<jsp:param value='<%=item.get("batch_group_id") %>' name="batch_group_id"/>
				<jsp:param value='<%=item.get("course_id") %>' name="course_id"/>
				</jsp:include>
		
									<hr>
									<%
										}
										} else {
									%>
									No Events to display Today

									<%
										}
									%>

								</div>
							</div>
							<div id="tab-2" class="tab-pane">
							<div class="panel-body" id="admin_notifications" style="height: 525px !important;    overflow-y: scroll;">
								<jsp:include page="../dashboard_notification.jsp">
								<jsp:param value="<%=u.getId()%>" name="user_id"/>
								</jsp:include>
							<button type="button" class="btn btn-block btn-outline btn-primary read_more_notification">Read More</button>
							<div id="no_notice_available"><h2>No Notification To Show
                           
                        </h2></div>
							</div>	
							</div>
						</div>
					</div>
				</div>
				<!---------------------------------------Today Events and Notifications Ends ---------------------------------------------------->

				<jsp:include page="partials/charts_dashboard.jsp">
					<jsp:param value='<%=colegeID%>' name="colegeID" />
				</jsp:include>
			</div>
			<!-- edit modal -->

			<div class="modal inmodal" id="myModal2" tabindex="-1" role="dialog"
				aria-hidden="true">
				<input type="hidden" value="<%=colegeID%>" id="org_id">
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
	</div>



	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>

</html>
