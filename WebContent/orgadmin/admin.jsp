<jsp:include page="inc/head.jsp"></jsp:include>
<body class="top-navigation" id="orgadmin_admin">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<%
				String tab = "";
				if (request.getAttribute("tab") != null) {
					tab = (String) request.getAttribute("tab");
				} else {
					tab = "user";
				}
			%>
			<div class="row">

				<!-- tab start -->

				<div
					class="ibox p-xs  b-r-lg border-left-right border-top-bottom border-size-sm gray-bg-admin"
					>
					<div class="tabs-container">
						<ul class="nav nav-tabs">
							<li class="<%=tab.equalsIgnoreCase("user")? "active":"" %> col-lg-3 text-center no-padding bg-muted"><a
								data-toggle="tab" href="#admintab1" id="admin_user_tab">Users</a></li>

							<li class="<%=tab.equalsIgnoreCase("group")? "active":"" %> col-lg-3 text-center no-padding bg-muted"><a
								data-toggle="tab" href="#admintab2" id="admin_section_tab">Section / Roles</a></li>

							

							<li class="<%=tab.equalsIgnoreCase("content")? "active":"" %> col-lg-3 text-center no-padding bg-muted"><a
								data-toggle="tab" href="#admintab4" id="admin_content_map">Content Mapping</a></li>
							
						</ul>

						<div class="tab-content">
							<div id="admintab1" class="<%=tab.equalsIgnoreCase("user")? "active":"" %> tab-pane div-min-height">
								<div class="panel-body">
									<jsp:include page="partials/admin_user_tab_content.jsp" />
								</div>
							</div>

							<div id="admintab2" class="<%=tab.equalsIgnoreCase("group")? "active":"" %> tab-pane div-min-height">
								<div class="panel-body">
									<jsp:include page="partials/admin_group_tab_content.jsp" />
								</div>
							</div>							

							<div id="admintab4" class="<%=tab.equalsIgnoreCase("content")? "active":"" %> tab-pane div-min-height">
								<div class="panel-body">
									<jsp:include page="partials/admin_content_map_tab_content.jsp" />									
								</div>
							</div>

							

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>	
</body>
</html>
