<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.viksitpro.core.dao.entities.CmsessionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	Boolean is_new = true;
	String image_url = baseURL + "img/user_images/recruiter_portal_trans_logo_old.png";
	String baseProdURL = (new URLServices()).getBaseUrl();
	DBUTILS dbutils = new DBUTILS();
	Cmsession cmsession = new Cmsession();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
	if (request.getParameterMap().containsKey("session")) {
		cmsession = (new CmsessionDAO()).findById(Integer.parseInt(request.getParameter("session")));
		is_new = false;
		image_url = cdnPath.substring(0,cdnPath.length())+cmsession.getImage_url();
	}
%>
<body class="top-navigation" id="session_edit"
	data-helper='This page is used to edit an individual session.'>
	<div id="wrapper">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row wrapper border-bottom white-bg page-heading"
				style="padding-left: 30px; padding-bottom: 13px;">
				<div class="col-lg-6">
					<h2>
						<%
							if (is_new) {
						%>New Session
						<%
							} else {
						%>
						<%=cmsession.getTitle()%>
						<%
							}
						%>
					</h2>
					<ol class="breadcrumb"
						style="background-color: transparent !important;">
						<li><a href="/content/content_creator/dashboard.jsp">Home</a></li>
						<li><a href="/content/creator/cmsessions.jsp">Session(s)</a></li>
						<li class="active"><strong> <%
 	if (is_new) {
 %>Create <%
 	} else {
 %>Edit <%
 	}
 %>Session
						</strong></li>
					</ol>
				</div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-title">
								<h5>Session Wizard</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<h2>
									<%
										if (is_new) {
									%>New Session<%
										} else {
									%>Session name:
									<%=cmsession.getTitle()%>
									<%
										}
									%>
								</h2>
								<p>Follow these steps to create/update a session.</p>
								<input type='hidden' name='isNew' value='<%=is_new.toString()%>'/>
								<input type='hidden' name='cmsID' value='<%=cmsession.getId()%>'/>
								<input type='hidden' name='baseProdURL' value='<%=baseProdURL%>'/>
								<form id="form" action="#" class="wizard-big">
									<h1>Basic</h1>
									<fieldset>
										<h2>Session Information</h2>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label>Name *</label> <input id="cmsession_name_idd"
														name="cmsession_name" type="text"
														class="form-control required" <%if (!is_new) {%>
														value="<%=cmsession.getTitle()%>" <%}%>>
												</div>
												<div class="form-group">
													<label>Description *</label>
													<textarea class="form-control required"
														name="cmsession_desc" rows="3" id="cmsession_desc_idd"><%if (!is_new) {%><%=cmsession.getDescription()%><%}%></textarea>
												</div>
											</div>
											<div class="col-lg-4">
												<%-- <div class="form-group" id="filezz">
													<input id="fileupload" type="file" accept="image/png"
														name="files[]" data-url="/content/upload_media" multiple>
													<img src='<%=image_url%>' class="form-group"
														id='cmsession_image'
														style="float: right; /* width: 100%; */ height: 200px;">
												</div> --%>
											</div>
										</div>
									</fieldset>

									<h1>Media Upload</h1>
									<fieldset>
										<h2>Image Upload</h2>
										<div class="row">
											<div class="col-lg-12">
												<h5>Session Image cropper</h5>
												<div class="row">
													<div class="col-md-6">
														<div class="image-crop">
															<img id='session_image' src="<%=image_url%>">
														</div>
													</div>
													<div class="col-md-6">
														<h4>Preview image</h4>
														<div class="img-preview img-preview-sm"></div>
														<h4>Common method</h4>
														<p>You can upload new image to crop container and easy
															upload/download new cropped image.</p>
														<div class="btn-group">
															<label title="Upload image file" for="inputImage"
																class="btn btn-primary"> <input type="file"
																accept="image/png" name="file" id="inputImage"
																class="hide"> Upload new image
															</label> <label title="Donload image" id="download"
																class="btn btn-primary">Download</label><label
																title="Upload image" id="upload" class="btn btn-primary">Upload</label>
														</div>
														<h4>Other method</h4>
														<p>You may set cropped area with these options.</p>
														<div class="btn-group">
															<button class="btn btn-white" id="zoomIn" type="button">Zoom
																In</button>
															<button class="btn btn-white" id="zoomOut" type="button">Zoom
																Out</button>
															<button class="btn btn-white" id="rotateLeft"
																type="button">Rotate Left</button>
															<button class="btn btn-white" id="rotateRight"
																type="button">Rotate Right</button>
															<button class="btn btn-warning" id="setDrag"
																type="button">New crop</button>
														</div>
													</div>
												</div>
											</div>
										</div>
									</fieldset>

									<h1>Lessons</h1>
									<fieldset>
										<input id="addChildren" placeholder="Put a lesson id here and press enter key" style="margin-bottom: 5px; min-width: 449px;">
										<ul class="list-unstyled file-list" id="editable">
											<%
												if (!is_new) {
													String sql = "select * from lesson_cmsession where cmsession_id = "+cmsession.getId();
													List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
													for (HashMap<String, Object> item : items) {
														Lesson lesson = (new LessonDAO()).findById(Integer.parseInt(item.get("lesson_id").toString()));
														if (lesson.getId() >= 0 && !lesson.getIsDeleted()) {
											%>
											<li class="something" data-lesson_id="<%=lesson.getId()%>"><i
												class="js-remove fa fa-trash-o"> </i> | <%=lesson.getId()%>
												| <%=lesson.getTitle()%></li>
											<%
												}
													}
												}
											%>
										</ul>
									</fieldset>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<!-- Mainly scripts -->
<jsp:include page="../inc/foot.jsp"></jsp:include>
<script type="text/javascript">
</script>