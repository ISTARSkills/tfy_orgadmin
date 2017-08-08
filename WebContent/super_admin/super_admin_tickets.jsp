
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int colegeID = 3;

	
%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_tickets">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="row">
							<div class="col-xs-12">
								<div class="page-title-box">
                                    <h4 class="page-title" style='padding-left: 15px;'>Ticket</h4>
                                    <ol class="breadcrumb p-0 m-0">
                                        <li>
                                            <a href="#">Dashboard</a>
                                        </li>
                                        <li>
                                            <a href="#">Ticket</a>
                                        </li>
                                      
                                    </ol>
                                    <div class="clearfix"></div>
                                </div>
							</div>
						</div>
			<jsp:include page="../ticket_element.jsp"></jsp:include>
		</div>
		<jsp:include page="../chat_element.jsp"></jsp:include>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<!-- Mainly scripts -->
</body>
</html>