<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.superadmin.services.ReportDetailService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
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
		data-event-id="<%=item.get("event_id")%>">
		<div>

			<p class="m-r-sm m-t-sm">
				<small><span class="label label-info">DATE : <%=format.format(item.get("eventdate"))%></span></small>
			</p>
			<p class="m-r-sm m-t-sm">
				Session:
				<%=item.get("cmsession_id")%></p>
			<p class="m-r-sm m-t-sm"><%=item.get("title")%></p>
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
