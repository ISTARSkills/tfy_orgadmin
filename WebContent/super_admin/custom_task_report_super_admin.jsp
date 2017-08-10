<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%
				String url = request.getRequestURL().toString();
				String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
						+ request.getContextPath() + "/";
			%>

<%
String reportId = request.getParameter("report_id");
String reportName = request.getParameter("report_name");
//String orgId = request.getParameter("organziation_id");
ReportUtils util = new ReportUtils();
%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body class="top-navigation" id="custom_task_report_superadmin">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="row wrapper border-bottom white-bg page-heading"
				style="padding-bottom: 10px; padding-left: 20px;">

				<% 
			String[] brd = {"Dashboard","Utility Reports"};
			%>
				<%=UIUtils.getPageHeader(reportName, brd) %>

				<div class="col-lg-2"></div>
			</div>
			<div class="row">

				<div class="col-lg-12">

					<div class="no-paddings bg-muted">
						<div class="ibox-content card-box margin-box "
							data-report_id='<%=reportId%>'>
							<%HashMap<String, String> conditions = new HashMap();
						conditions.put("limit", "10");
						conditions.put("offset", "0");
						/* conditions.put("org_id", orgId); */
						conditions.put("static_table", "true");	
						
						%>

							<%= util.getTableFilters(Integer.parseInt(reportId), conditions) %>




							<%= util.getTableOuterHTML(Integer.parseInt(reportId), conditions) %>
							<%%>
						</div>
					</div>
				</div>
			</div>


		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<!-- Mainly scripts -->
</body>

<script>
$(document).ready(function(){
	
	
       
});


</script>

</html>