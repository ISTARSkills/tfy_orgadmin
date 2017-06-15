<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.superadmin.services.ReportDetailService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
SimpleDateFormat format = new SimpleDateFormat("dd MMM yyyy hh:mm a");

	int batch_id = 0;
	if (request.getParameter("batch_id") != null) {
		batch_id = Integer.parseInt(request.getParameter("batch_id"));
	}
	int offset = 0;
	if (request.getParameter("offset") != null) {
		offset = Integer.parseInt(request.getParameter("offset"));
	}
	ReportDetailService service = new ReportDetailService();
	List<HashMap<String, Object>> sessionItems = service.getAllSessions(batch_id, offset, false);
%>


<%
	for (HashMap<String, Object> item : sessionItems) {
%>
<div class="col-lg-4">
	<div
		class="product-box p-xl b-r-lg border-left-right border-top-bottom text-center batch-session-button"
		data-event-id="<%=item.get("event_id")%>" style="padding-left: 11px;
    padding-right: 11px;">
		<div>

			<p class="m-r-sm m-t-sm">
				<small><span class="label label-info" style="background-color: #eb384f;">DATE : <%=format.format(item.get("eventdate"))%></span></small>
			</p>
			<p class="m-r-sm m-t-sm">
				<b>Sessions Covered</b>:
				</p>
			<p class="m-r-sm m-t-sm"><%=item.get("cmsessions")!=null ? item.get("cmsessions") : "Not yet Covered"%></p>
		</div>
	</div>
</div>
<%
	}
	if (sessionItems.size() == 0) {
%>
<div class="ibox-content">
	<div class="alert alert-warning">No Session Found.</div>
</div>


<%
	}
%>
