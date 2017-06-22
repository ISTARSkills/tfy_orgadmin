<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	
%>
<body class="top-navigation" id="coordinator_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="inc/navbar.jsp"></jsp:include>

			
			<div class="row" id="_holder">
				<!-------------------------------------------Today Events and Notifications  -------------------------------------------------------->
				
				<!---------------------------------------Today Events and Notifications Ends ---------------------------------------------------->

				
			</div>
			
			

		</div>
		
		
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>
