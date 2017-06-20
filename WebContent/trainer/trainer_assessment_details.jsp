<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	
%>
<body class="top-navigation" id="trainer_assessment_details">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="inc/navbar.jsp"></jsp:include>		
		
		<div class="wrapper wrapper-content white-bg">
		
				<div class="row">
				
					<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");				
				%>				
				<%=util.getTableOuterHTML(3065, conditions)%>
				</div>
</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>
