<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
	OpsReportSevices opsReport = new OpsReportSevices();
	UIUtils ui = new UIUtils();
	int colegeID = (int)request.getSession().getAttribute("orgId");
	
	 int user_id=(new IstarUserDAO().findByEmail("principal_ep@istarindia.com").get(0)).getId();
	 
	/*  Organization college=new OrganizationDAO().findById(colegeID); */
	 user_id = ui.getOrgPrincipal(colegeID);
	/*  user_id = college.getUserOrgMappings().iterator().next().getIstarUser().getId(); */
	
	
%>
<jsp:include page="inc/head.jsp"></jsp:include>

<body class="top-navigation" id="istar_notification">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="row p-xl">
			
				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Choose Section</label>
						<div>
							<select data-placeholder="Select Section" tabindex="4"
								id='notification_batchgroup_holder'></select>
						</div>
					</div>
				</div>

				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Notification Type</label>
						<div>
							<select data-placeholder="Select Notification" tabindex="4"
								id='notification_type_holder'>
								<option value="null">Select Notification</option>
								<option value="playPresentation">PLAY PRESENTATION</option>
								<option value="playAssessment">PLAY ASSESSMENT</option>
								<option value="complexObjectUpdate">UPDATE STUDENT CONTENT</option>
								<option value="coUpdateWithMessage">SIMPLE MESSAGE</option>
							</select>
						</div>
					</div>
				</div>
				<div id="play_presentation_holder" style="display: none;">
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Course</label>
							<div id="notification_course_holder">
								<select data-placeholder="Select Course" tabindex="4"
									data-url='' id='course_holder'></select>
							</div>
						</div>
					</div>
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Session</label>
							<div>
								<select data-placeholder="Select Session" tabindex="4"
									data-url='' id='notification_cmsession_holder'>
								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Presentation</label>
							<div>
								<select data-placeholder="Select Presentation" tabindex="4"
									data-url='' id='notification_ppt_holder'>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div id="play_assessment_holder" style="display: none;">
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Assessment</label>
							<div>
								<select data-placeholder="Select Assessment" tabindex="4"
									data-url='' id='notification_assessment_holder'>
									<%=ui.getAllAssessments()%>
								</select>
							</div>
						</div>
					</div>
				</div>

<div class="col-lg-2">
				<input type="hidden" id="notification_college_holder" value="<%=colegeID%>">
				<input type="hidden" id="adminID" value="<%=user_id%>">
					<%-- <div class="form-group">
						<label class="font-bold">Choose College</label>
						<div>
							<select data-placeholder="select College" tabindex="4"
								id='notification_college_holder'>
								<%=opsReport.getOrganization()%>
							</select>
						</div>
					</div> --%>
				</div>

			</div>
			<div style="display: none" id="spinner_holder">
				<div style="width: 100%; z-index: 6; position: fixed;"
					class="spiner-example">
					<div style="width: 100%;"
						class="sk-spinner sk-spinner-three-bounce">
						<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
					</div>
				</div>
			</div>
			<div id="">
				<form role="form">

					<div class="row">

						<div class="col-lg-6 white-bg">
							<div class="ibox">
								<div class="ibox-content">
									<div class="form-group">
										<label>Title</label> <input type="text" id="title"
											placeholder="Write Title..." class="form-control">
									</div>
									<div class="form-group">
										<label>Comments</label>
										<textarea class="form-control" id="comment"
											placeholder="Write Comment..."></textarea>
									</div>
									<div class="form-group">
										<button class="btn btn-sm btn-danger pull-right m-t-n-xs"
											id="send_notification" type="button">
											<strong>Send Notification</strong>
										</button>

									</div>

								</div>

							</div>
						</div>
						<div class="col-lg-6">
							<div class="ibox">
								<div class="ibox-content">

									<h3 class="m-b-xxs">
										Student List <label class="checkbox-inline pull-right">
											<input type="checkbox" id="checkAll"> Check All
										</label>
									</h3>
									<div id="student_holder"></div>

								</div>

							</div>
						</div>
					</div>

				</form>


			</div>

		</div><jsp:include page="../chat_element.jsp"></jsp:include>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			
			var orgId = $('#notification_college_holder').val();
			var type = 'org';
			$.ajax({
				type : "POST",
				url : '../get_notification',
				data : {
					orgId : orgId,
					type : type
				},
				success : function(data) {
					$('#notification_batchgroup_holder').html(data);
				}
			});
			
			
		});
	</script>
</body>

</html>
