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
	<%
		if (request.getParameterMap().containsKey("course")) {
	%>
	<input style='display: hidden' id='courseID'
		value='<%=request.getParameter("course")%>'>
	<%
		}
	%>
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
								<input type="text" placeholder="course_name"
									class="form-control">
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
								<button class="btn btn-sm btn-primary " type="submit">Update
									Detail</button>
							</div>
						</div>

					</div>
					<div class="col-md-3">
						<div class="fileinput fileinput-new input-group"
							data-provides="fileinput">

							<span class="input-group-addon btn btn-default btn-file">
								<span class="fileinput-new">Select file</span> <span
								class="fileinput-exists">Change</span> <input type="file"
								name="..." />
							</span>
						</div>
					</div>
				</div>
			</form>
		</div>
		<div class="container" style="margin-top: 20px;">
			<div class="card">

				<div class="row">
					<div id="skillTree"></div>
				</div>
			</div>
		</div>
	</div>
	<div id='modals'></div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document)
				.ready(
						function() {
							var courseID = $('#courseID').val();
							var url = '../tfy_content_rest/course/getTree/'
									+ courseID;
							var jsonData;
							$
									.get(url, function(data) {
										window.jsonData = data;
									})
									.done(
											function() {
												$('#skillTree')
														.jstree(
																{
																	'core' : {
																		'check_callback' : true,
																		'data' : window.jsonData.courseTree
																	}
																});
												$('#skillTree')
														.on(
																"click",
																".addChildren",
																function() {
																	$
																			.get('./modals/module.jsp').done(function(data){
																				$('#modals').html(data);
																				$('#moduleModal').modal('toggle');
																			});
																	var parentitemID = this.parentElement.parentElement.parentElement.parentElement.id;
																	/* $(
																			'#skillTree')
																			.jstree(
																					true)
																			.create_node(
																					parentitemID,
																					{
																						"id" : "ajson5",
																						"text" : "newly added"
																					},
																					"last",
																					function() {
																						alert("done");
																					}); */

																});

												$('#skillTree')
														.on(
																'open_node.jstree',
																function(e,
																		data) {

																	var nodesToKeepOpen = [];

																	// get all parent nodes to keep open
																	$(
																			'#'
																					+ data.node.id)
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
																	$(
																			'.jstree-node')
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
						})
	</script>
</body>
</html>