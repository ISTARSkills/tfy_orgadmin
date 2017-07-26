<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	int colegeID = (int)request.getSession().getAttribute("orgId");

%>
<body class="top-navigation" id='super_admin_classroom'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content white-bg">

				<div class="row white-bg">
				<button type="button" class="btn btn-w-m btn-danger" id="class-add"  data-url='<%=baseURL%>orgadmin/partials/modal/create_edit_classroom_modal.jsp?type=Create' style="margin-top: 16px;">Add Class Room</button>
								<br><br>
					<!-- <button class="btn btn-default dim pull-right" id="class-add" type="button">
						<i class="fa fa-plus-circle"></i>
					</button> -->
				</div>

				<div class="row">
					<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");	
				conditions.put("organization_id", colegeID+"");	
				%>				
				<%=util.getTableOuterHTML(3068, conditions)%>
				</div>

			</div>
		</div>
		<jsp:include page="../chat_element.jsp"></jsp:include>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>