<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.viksitpro.core.dao.entities.ModuleDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.ContextDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Context"%>
<%@page import="com.viksitpro.core.dao.entities.Module"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	Boolean is_new = true;
	String image_url = "/course_images/37.png";
	String baseProdURL = (new URLServices()).getBaseUrl();
	DBUTILS dbutils = new DBUTILS();
	Course course = new Course();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
	if (request.getParameterMap().containsKey("course")) {
		course = (new CourseDAO()).findById(Integer.parseInt(request.getParameter("course")));
		is_new = false;
		image_url = cdnPath.substring(0,cdnPath.length())+course.getImage_url();
	}
%>
<body class="top-navigation" id="course_edit"
	data-helper='This page is used to edit an individual course.'>
	<div id="wrapper">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row wrapper border-bottom white-bg page-heading"
				style="padding-left: 30px; padding-bottom: 13px;">
				<div class="col-lg-6">
					<h2>
						<%
							if (is_new) {
						%>New Course
						<%
							} else {
						%>
						<%=course.getCourseName()%>
						<%
							}
						%>
					</h2>
					<ol class="breadcrumb"
						style="background-color: transparent !important;">
						<li><a href="/content/content_creator/dashboard.jsp">Home</a></li>
						<li><a href="/content/creator/courses.jsp">Course(s)</a></li>
						<li class="active"><strong> <%
 	if (is_new) {
 %>Create <%
 	} else {
 %>Edit <%
 	}
 %>Course
						</strong></li>
					</ol>
				</div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-title">
								<h5>Course Wizard</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="dropdown-toggle" data-toggle="dropdown" href="#">
										<i class="fa fa-wrench"></i>
									</a> <a class="close-link"> <i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<h2>
									<%
										if (is_new) {
									%>New Course<%
										} else {
									%>Course name:
									<%=course.getCourseName()%>
									<%
										}
									%>
								</h2>
								<p>Follow these steps to create/update a Course.</p>
								<input type='hidden' name='isNew' value='<%=is_new.toString()%>'/>
								<input type='hidden' name='cmsID' value='<%=course.getId()%>'/>
								<input type='hidden' name='baseProdURL' value='<%=baseProdURL%>'/>
								<form id="form" action="#" class="wizard-big">
									<h1>Basic</h1>
									<fieldset>
										<h2>Course Information</h2>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label>Name *</label> <input id="course_name_idd"
														name="course_name" type="text"
														class="form-control required" <%if (!is_new) {%>
														value="<%=course.getCourseName()%>" <%}%>>
												</div>
												<div class="form-group">
													<label>Description *</label>
													<textarea class="form-control required" name="course_desc" rows="3" id="course_desc_idd"><%if (!is_new) {%><%=course.getCourseDescription()%><%}%></textarea>
												</div>
												<div class="form-group">
													<label>Category *</label> <input id="course_category_idd"
														name="course_category" type="text"
														class="form-control required" <%if (!is_new) {%>
														value="<%=course.getCategory()%>" <%}%>>
												</div>
											</div>
											<div class="col-lg-4">
												<%-- <div class="form-group" id="filezz">
													<input id="fileupload" type="file" accept="image/png" name="files[]" data-url="/content/upload_media" multiple> <img src='<%=image_url%>' class="form-group" id='course_image' style="float: right; /* width: 100%; */ height: 200px;">
												</div> --%>

											</div>
										</div>
									</fieldset>
									<h1>Media Upload</h1>
									<fieldset>
										<h2>Image Upload</h2>
										<div class="row">
											<div class="col-lg-12">
												<h5>Course Image cropper</h5>
												<div class="row">
													<div class="col-md-6">
														<div class="image-crop">
															<img id='course_image' src="<%=image_url%>">
														</div>
													</div>
													<div class="col-md-6">
														<h4>Preview image</h4>
														<div class="img-preview img-preview-sm square"></div>
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

									<h1>Modules</h1>
									<fieldset>
										<div class="col-md-6">
											<input id="addChildren" placeholder="Put a Module id here and press enter key" style="margin-bottom: 5px; min-width: 449px;">
											<ul class="list-unstyled file-list" id="editable">
												<%
													if (!is_new) {
														String sql = "select * from module_course where course_id = "+course.getId();
														List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
														for (HashMap<String, Object> item : items) {
															Module module = (new ModuleDAO()).findById(Integer.parseInt(item.get("module_id").toString()));
															if (module.getId() >= 0 && !module.getIsDeleted()) {
												%>
												<li class="something" data-module_id="<%=module.getId()%>"><i
													class="js-remove fa fa-trash-o"> </i> | <%=module.getId()%>
													| <%=module.getModuleName()%></li>
												<%
													}
														}
													}
												%>
											</ul>
										</div>
										<div class="col-md-6">
											<input id="searchModules" placeholder="Search for modules by title, description.." style="margin-bottom: 5px; min-width: 449px;">
											<div class="ibox float-e-margins">
								                <div class="ibox-content text-center p-md" id="searchModulesResult" >								
								                    
								                    <!-- <h4 class="m-b-xxs">Top navigation, centered content layout</h4>
								                    <small>(optional layout)</small>
								                    <p>Available configure options</p>
								                    
								                    <span class="simple_tag">Scroll navbar</span>
								                    <span class="simple_tag">Top fixed navbar</span>
								                    <span class="simple_tag">Boxed layout</span>
								                    <span class="simple_tag">Scroll footer</span>
								                    <span class="simple_tag">Fixed footer</span>
								                    <div class="m-t-md">
								                        <p>Check the Dashboard v.4 with top navigation layout</p>
								                        <div class="p-lg ">
								                        	<a href="dashboard_4.html"><img class="img-responsive img-shadow" src="img/dashboard4_2.jpg" alt=""></a>
								                        </div>
								                    </div> -->
								                </div>
							                </div>
						                </div>
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