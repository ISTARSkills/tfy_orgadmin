<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
IstarUser trainer = (IstarUser)request.getSession().getAttribute("user");	
%>
<body class="top-navigation" id="trainer_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="inc/navbar.jsp"></jsp:include>
		<div class="row">
				<div class="row wrapper border-bottom white-bg page-heading">
					<div class="col-lg-10">
						<h2 style="margin-left: 31px;">Section/Roles Details</h2>
					</div>
				</div>
				<jsp:include page="/trainer_common_jsps/update_batch_code.jsp">
				<jsp:param value="<%=trainer.getId()%>" name="user_id"/>
				</jsp:include>
			</div>
		</div>
		
		
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>