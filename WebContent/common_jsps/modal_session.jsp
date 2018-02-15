<%@page import="com.viksitpro.core.dao.entities.BatchDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Batch"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.sql.Date"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String eventId = request.getParameter("event_id");
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	DBUTILS dbutils = new DBUTILS();
	OrgAdminDashboardServices dashboardServices = new OrgAdminDashboardServices();
%>

<div class="modal inmodal session_modal_holder"
	id="session_modal_<%=eventId%>" tabindex="-1" role="dialog"
	aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content animated flipInY">
			<!-- start -->
			<div class="panel-body">

				<%
					List<HashMap<String, Object>> items = dashboardServices.getEvenetDetailsFromEvent(eventId);
					for (HashMap<String, Object> item : items) {
						//int batch_id = (int) item.get("batch_id");
						int trainerId = (int) item.get("actor_id");
						//Batch bb = new BatchDAO().fin	dById(batch_id);
						//ViksitLogger.LOGGER.info (">>>>.>"+item.get("status"));
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
					if (items.size() == 0) {
				%>
				Event Information is Not Available
				<%
					}
				%>
			</div>
			<!-- end -->
		</div>
	</div>
</div>