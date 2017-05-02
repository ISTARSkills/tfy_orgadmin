
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int colegeID = 3;

	
%>

<jsp:include page="inc/head.jsp"></jsp:include>
<body class="top-navigation" id="org_admin_tickets">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>



			<jsp:include page="../ticket_element.jsp"></jsp:include>
		</div>
		<jsp:include page="../chat_element.jsp"></jsp:include>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
	<!-- Mainly scripts -->
</body>
</html>