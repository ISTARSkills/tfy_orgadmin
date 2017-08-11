
<%@page import="in.talentify.core.utils.UIUtils"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int colegeID = 3;

	
%>


<body class="top-navigation" id="org_admin_tickets">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>

<% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Ticket", brd) %>

			<jsp:include page="../ticket_element.jsp"></jsp:include>
		</div>

	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<!-- Mainly scripts -->
</body>
</html>