<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<jsp:include page="/inc/head.jsp"></jsp:include>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<body class="top-navigation" id='super_admin_classroom'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content white-bg customcss_wrapcontent" >
			<% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Classroom(s)", brd) %>
				<div class="row white-bg customcss_classroom"
					style="">
					<button type="button" class="btn btn-w-m btn-danger" id="class-add"
						data-url='<%=baseURL%>super_admin/partials/modal/create_edit_classroom_modal.jsp?type=Create'
						style="margin-top: 16px;">Add Class Room</button>
					<br>
					<br>

				</div>

				<div class="row card-box custom_css_classroom" id='classromm_holder' style="">
					<%
						ReportUtils util = new ReportUtils();
						HashMap<String, String> conditions = new HashMap();
						conditions.put("limit", "12");
						conditions.put("offset", "0");
					%>
					<%=util.getTableOuterHTML(3055, conditions)%>
				</div>

			</div>
		</div>
		<%-- <jsp:include page="../chat_element.jsp"></jsp:include> --%>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>