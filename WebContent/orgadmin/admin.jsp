<%@page import="in.talentify.core.utils.UIUtils"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body class="top-navigation" id="orgadmin_admin">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			
			<%
				String[] brd = { "Dashboard" };
			%>
			<%=UIUtils.getPageHeader("Admin", brd)%>

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

				<div class="ibox p-xs  b-r-lg border-left-right border-top-bottom border-size-sm customcss_adminmaintab">
					<div class="">
						<ul class="nav nav-tabs tabs-bordered nav-justified">
							<li class="<%=tab.equalsIgnoreCase("user")? "active":"" %> col-lg-3 text-center no-padding "><a
								data-toggle="tabajax" data-target="#admintab1" href="partials/admin_user_tab_content.jsp" id="admin_user_tab">Users</a></li>

							<li class="<%=tab.equalsIgnoreCase("group")? "active":"" %> col-lg-3 text-center no-padding "><a
								data-toggle="tabajax" data-target="#admintab2" href="partials/admin_group_tab_content.jsp" id="admin_section_tab">Section / Roles</a></li>

							

							<li class="<%=tab.equalsIgnoreCase("content")? "active":"" %> col-lg-3 text-center no-padding "><a
								data-toggle="tabajax" data-target="#admintab4" href="partials/admin_content_map_tab_content.jsp" id="admin_content_map">Content Mapping</a></li>
							
						</ul>

						<div class="tab-content">
							<div id="admintab1" class="<%=tab.equalsIgnoreCase("user")? "active":"" %> tab-pane div-min-height">								
							</div>

							<div id="admintab2" class="<%=tab.equalsIgnoreCase("group")? "active":"" %> tab-pane div-min-height">
							</div>							

							<div id="admintab4" class="<%=tab.equalsIgnoreCase("content")? "active":"" %> tab-pane div-min-height">
							</div>

							

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>	
	
</body>
</html>