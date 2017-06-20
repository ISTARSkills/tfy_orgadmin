<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	
%>
<body class="top-navigation" id="trainer_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="inc/navbar.jsp"></jsp:include>
		<div class="row" id="_holder">
				tasks, roles and calender related to trainer will come here
				
		</div>
			
			

		</div>
		
		 <%-- <jsp:include page="../chat_element.jsp"></jsp:include> --%>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>
