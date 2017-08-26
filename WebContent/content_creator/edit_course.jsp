<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="student_role">
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
		StudentRolesService studentrolesservice = new StudentRolesService();
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row">
				<h1>Direct Skill Theory</h1>
			</div>
		</div>
		<div class="container">
			<div class="row">
				<div class="col-md-8">
					<form class="form-horizontal">
						<div class='row'>
							<div class='col-md-4'>
								<label>Course Name</label>
							</div>
							<div class='col-md-8'>
								<input type="email" placeholder="Email" class="form-control">
							</div>
						</div>
						<div class='row'>
							<div class='col-md-4'>
								<label>Course Category</label>
							</div>
							<div class='col-md-8'>
								<select class="form-control m-b" name="account">
									<option>option 1</option>
									<option>option 2</option>
									<option>option 3</option>
									<option>option 4</option>
								</select>
							</div>
						</div>
						<div class='row'>
							<div class='col-md-4'>
								<label>Description</label>
							</div>
							<div class='col-md-8'>
								<textarea></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="col-md-3">
					<h4>Not a member?</h4>
				</div>
			</div>
		</div>
		<%
			String[] modules = {"Fundamentals of Risk", "Debt - Fundamentals", "Equities - Fundamentals",
					"Mutual Funds", "Risk Managment", "Time Value of Money"};
			String[] sessions = {"Application of Risk Assessment", "Risk Assessment & Quantification",
					"Understanding Risk", "Identifying Risk Factors"};
			String[] lessons = {"The risk game - 1", "The risk game - 2", "The risk game - 3", "The risk game - 4",
					"The risk game - 5"};
		%>
		<div class="container">
			<div class="row">
				<div id="skillTree">
					<ul>
						<%
							for (int i = 0; i < modules.length; i++) {
						%>
						<li class="MODULE">[MODULE-<%=i%>] - <%=modules[i]%><div style="float: right"><div class='dropdown'> <button class='btn btn-secondary dropdown-toggle' type='button' id='dropdownMenuButton' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'> Dropdown button </button> <div class='dropdown-menu' aria-labelledby='dropdownMenuButton'> <a class='dropdown-item' href='#'>Action</a> <a class='dropdown-item' href='#'>Another action</a> <a class='dropdown-item' href='#'>Something else here</a> </div> </div></div>
							<ul>
								<%
									for (int j = 0; j < sessions.length; j++) {
								%>
								<li class="SESSION">[SESSION-<%=j%>] - <%=sessions[j]%>
									<ul>
										<%
											for (int k = 0; k < lessons.length; k++) {
										%>
										<li class="LESSON">[LESSON-<%=k%>] - <%=lessons[k]%>
										</li>
										<%
											}
										%>
									</ul>
								</li>
								<%
									}
								%>
							</ul> <%
 	}
 %>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			$('#skillTree').jstree();
		});
	</script>
</body>
</html>