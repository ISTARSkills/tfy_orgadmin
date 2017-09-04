<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	boolean flag = false;
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	if (cp == null) {
		flag = true;
		request.setAttribute("msg", "User Does Not Have Permission To Access");
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}
	request.setAttribute("cp", cp);
%>
<link href="<%=baseURL%>assets/css/dataTables/datatables.min.css"
	rel="stylesheet">
<body id="student_role">

	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row">
				<h1>Question List</h1>
			</div>
		</div>
		<div class="container">
			<table id='questionList'>
				<thead>
					<tr>
						<th data-visisble='true'>#</th>
						<th data-visisble='true'>Question Text</th>
						<th data-visisble='true'>Question Type</th>
						<th data-visisble='true'>Difficulty Level</th>
						<th data-visisble='true'>action</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th data-visisble='true'>#</th>
						<th data-visisble='true'>Question Text</th>
						<th data-visisble='true'>Question Type</th>
						<th data-visisble='true'>Difficulty Level</th>
						<th data-visisble='true'>action</th>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script
		src="<%=baseURL%>assets/js/plugins/dataTables/datatables.min.js"></script>
	<script>
		$(document).ready(function() {
			$('#questionList').DataTable({
				"processing" : true,
				"serverSide" : true,
				"ajax" : "../tfy_content_rest/question/getAll"
			});
		});
	</script>
</body>
</html>