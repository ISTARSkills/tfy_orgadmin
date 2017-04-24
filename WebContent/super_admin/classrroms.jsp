<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<body class="top-navigation" id='super_admin_classroom'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content">

				<div class="row white-bg">
					<button class="btn btn-default dim pull-right" id="class-add" type="button">
						<i class="fa fa-plus-circle"></i>
					</button>
				</div>

				<div class="row">
					<div class="col-lg-12 white-bg">
						<table class="table table-bordered datatable_istar"
							id='classroom_list' data-url='../get_list_of_classroom'>
							<thead>
								<tr>
									<th data-visisble='true'>#</th>
									<th data-visisble='true'>Class Room Name</th>
									<th data-visisble='true'>IP Adddress</th>
									<th data-visisble='true'>Organization</th>
									<th data-visisble='true'>Maximum Students</th>
									<th data-visisble='true'>Action</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
					</div>
				</div>

			</div>
		</div>
		<jsp:include page="../chat_element.jsp"></jsp:include>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>