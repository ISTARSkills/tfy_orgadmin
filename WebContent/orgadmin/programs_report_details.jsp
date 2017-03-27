<jsp:include page="inc/head.jsp" />

<body class="top-navigation" id="orgadmin_report_detail">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			
			<jsp:include page="report_section/programs_report_details.jsp">
				<jsp:param name="course_id"
					value='<%=request.getParameter("course_id")%>' />
				<jsp:param name="batch_id"
					value='<%=request.getParameter("batch_id")%>' />
				<jsp:param name="headname"
					value='<%=request.getParameter("headname")%>' />
			</jsp:include></div>

	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>

</html>
