<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%
String reportId = request.getParameter("report_id");
String reportName = request.getParameter("report_name");
ReportUtils util = new ReportUtils();
%>
<jsp:include page="inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_analytics">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="row">

			<div class="col-lg-12">
				
				<div class="no-paddings bg-muted">
					 <div class="ibox-title">
                        <h5><%=reportName %></h5>
                        
                    </div>
					<div class="ibox-content">
						<%HashMap<String, String> conditions = new HashMap();
						conditions.put("limit", "12");
						conditions.put("offset", "0");	
						%>
						<%= util.getTableOuterHTML(Integer.parseInt(reportId), conditions) %>
				<%%>
					</div>
				</div>
				</div>
				</div>
				
				
		</div>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
<!-- Mainly scripts -->
</body>
</html>