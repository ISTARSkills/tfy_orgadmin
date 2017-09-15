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
			<form class="form-horizontal">
				<div class="row">
					<div class="col-md-8">

						<p>Sign in today for more expirience.</p>
						<div class="form-group">
							<label class="col-lg-2 control-label">Course Name</label>

							<div class="col-lg-10">
								<input type="text" placeholder="course_name" class="form-control">
							</div>
						</div>
						<div class="form-group">
							<label class="col-lg-2 control-label">Description</label>

							<div class="col-lg-10">
								<textarea rows="3" cols="80"></textarea>
							</div>
						</div>

						<div class="form-group">
							<div class="col-lg-offset-2 col-lg-10">
								<button class="btn btn-sm btn-primary " type="submit">Update Detail</button>
							</div>
						</div>

					</div>
					<div class="col-md-3">
						<div class="fileinput fileinput-new input-group" data-provides="fileinput">

							<span class="input-group-addon btn btn-default btn-file"> <span class="fileinput-new">Select file</span> <span class="fileinput-exists">Change</span> <input type="file" name="..." />
							</span>
						</div>
					</div>
				</div>
			</form>
		</div>
		<%
			String[] modules = {"Fundamentals of Risk", "Debt - Fundamentals", "Equities - Fundamentals",
					"Mutual Funds", "Risk Managment", "Time Value of Money"};
			String[] sessions = {"Application of Risk Assessment", "Risk Assessment & Quantification",
					"Understanding Risk", "Identifying Risk Factors"};
			String[] lessons = {"The risk game - 1", "The risk game - 2", "The risk game - 3", "The risk game - 4",
					"The risk game - 5"};
		%>
		<div class="container" style="margin-top: 20px;">
			<div class="card">

				<div class="row">
					<div id="skillTree">
						<ul>
							<%
								for (int i = 0; i < modules.length; i++) {
							%>
							<li class="MODULE">[MODULE-<%=i%>] - <%=modules[i]%><div style="float: right">
									<div class='dropdown'>
										<button class='btn btn-default dropdown-toggle' type='button' id='dropdownMenuButton' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false' style="padding: 0px; !important">
											<i class="fa fa-ellipsis-h fa-2x"></i>
										</button>
										<div class='dropdown-menu' aria-labelledby='dropdownMenuButton'>
											<a class='dropdown-item' href='#'>Action</a> <a class='dropdown-item' href='#'>Another action</a> <a class='dropdown-item' href='#'>Something else here</a>
										</div>
									</div>
								</div>
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
			$(document)
					.ready(
							function() {
								$('#skillTree').jstree();
								$('#skillTree')
										.on(
												'open_node.jstree',
												function(e, data) {

													var nodesToKeepOpen = [];

													// get all parent nodes to keep open
													$('#' + data.node.id)
															.parents(
																	'.jstree-node')
															.each(
																	function() {
																		nodesToKeepOpen
																				.push(this.id);
																	});

													// add current node to keep open
													nodesToKeepOpen
															.push(data.node.id);

													// close all other nodes
													$('.jstree-node')
															.each(
																	function() {
																		if (nodesToKeepOpen
																				.indexOf(this.id) === -1) {
																			$(
																					"#skillTree")
																					.jstree()
																					.close_node(
																							this.id);
																		}
																	})
												})
							});
		</script>
</body>
</html>