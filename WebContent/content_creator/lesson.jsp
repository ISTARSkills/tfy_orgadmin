<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
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
	IstarUser istarUser = (IstarUser) request.getSession(false).getAttribute("user");
	Boolean is_new = true;
	Lesson lesson = new Lesson();
	String image_url = "/course_images/l_6540.png";
	String baseProdURL = (new URLServices()).getBaseUrl();
	DBUTILS dbutils = new DBUTILS();
	String jspFileName = "../content_creator/edit_video.jsp";
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
	if (request.getParameterMap().containsKey("lesson")) {
		is_new = false;
		LessonDAO dao = new LessonDAO();
		dao.getSession().clear();
		lesson = (dao).findById(Integer.parseInt(request.getParameter("lesson")));
		image_url = cdnPath.substring(0,cdnPath.length())+lesson.getImage_url();
		if (lesson.getType().equalsIgnoreCase(LessonTypeNames.VIDEO)) {
			jspFileName = "../content_creator/edit_video.jsp?lesson=" + lesson.getId();
		} else if (lesson.getType().equalsIgnoreCase(LessonTypeNames.INTERACTIVE)) {
			jspFileName = "../content_creator/edit_interactive.jsp";
		} else if (lesson.getType().toString().equalsIgnoreCase(LessonTypeNames.PRESENTATION)) {
			jspFileName = "../content_creator/view_presentation.jsp";
		} else if (lesson.getType().toString().equalsIgnoreCase(LessonTypeNames.ASSESSMENT)) {
			jspFileName = "../content_creator/view_assessment.jsp";
		}
		//checking if the lessonXML exists and create if doesn't
		Boolean lessonXMLexists = lessonServices.checkLessonXMLExists(lesson);
		if(!lessonXMLexists && lesson.getType().equalsIgnoreCase(LessonTypeNames.PRESENTATION)){
			lessonServices.createDummyLessonXML(lesson);
		}
	}
%>
<body class="top-navigation" id="lesson_edit"
	data-helper='This page is used to edit/create an individual lesson.'>
	<div id="wrapper">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row wrapper border-bottom white-bg page-heading"
				style="padding-left: 30px; padding-bottom: 13px;">
				<div class="col-lg-6">
					<h2>
						<%
							if (is_new) {
						%>New Lesson
						<%
							} else {
						%>
						<%=lesson.getTitle()%>
						<%
							}
						%>
					</h2>
					<ol class="breadcrumb"
						style="background-color: transparent !important;">
						<li><a href="/content/content_creator/dashboard.jsp">Home</a></li>
						<li><a href="/content/creator/lessons.jsp">Lesson(s)</a></li>
						<li class="active"><strong> <%
 	if (is_new) {
 %>Create <%
 	} else {
 %>Edit <%
 	}
 %>Lesson
						</strong></li>
					</ol>
				</div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Lesson Wizard</h5>
							</div>
							<div class="ibox-content">
								<h2>
									<%
										if (is_new) {
									%>New Lesson<%
										} else {
									%>Lesson name:
									<%=lesson.getTitle()%>
									<%
										}
									%>
								</h2>
								<p>Please follow the following steps</p>
								<input type='hidden' name='isNew' value='<%=is_new.toString()%>'/>
								<input type='hidden' name='cmsID' value='<%=lesson.getId()%>'/>
								<input type='hidden' name='baseProdURL' value='<%=baseProdURL%>'/>
								<form id="wizard" action="#" class="wizard-big">
									<h1>Basic details</h1>
									<fieldset>
										<h2>Lesson Information</h2>
										<div class="form-group">
											<h4>Select Lesson Type</h4>

											<select class="form-control" name="lesson_type"
												id='lesson_type_idd' <%if(!is_new){ %>disabled<%} %>>
												<option value="VIDEO"
													<%if (!is_new) {
				if (lesson.getType().equalsIgnoreCase("VIDEO")) {%>
													selected <%}
			}%>>Video Lesson</option>
												<option value="INTERACTIVE"
													<%if (!is_new) {
				if (lesson.getType().equalsIgnoreCase("INTERACTIVE")) {%>
													selected <%}
			}%>>ELT Lesson</option>
												<%if (!is_new) {  %>
												<option value="ASSESSMENT" <%if (lesson.getType().equalsIgnoreCase("ASSESSMENT")) {%>
													selected <%}%>>ASSESSMENT Lesson</option>
													<%} %>
												<option value="PRESENTATION"
													<%if (!is_new) {
				if (lesson.getType().equalsIgnoreCase("PRESENTATION")) {%>
													selected <%}
			}%>>PRESENTATION Lesson</option>
										</select>
										</div>
										<div class="form-group">
											<h4>Lesson Name</h4>
											<input class="form-control required" id="lesson_name_idd"
												type="text" name="lesson_name" <%if (!is_new) {%>
												value="<%=lesson.getTitle()%>" <%}%>>
										</div>
										<div class="form-group">
											<h4>Lesson Description</h4>
											<textarea class="form-control required" name="lesson_desc"
												rows="3" id="lesson_desc_idd"><%if (!is_new) {%><%=lesson.getDescription()%><%}%></textarea>
										</div>
										<div class="form-group">
											<label>Lesson Duration (minutes)</label> <input
												class="form-control" id="lesson_duration_idd"
												type="number" name="lesson_duration" step="5"
												style="max-width: 70px;" <%if (!is_new) {%>
												value="<%=lesson.getDuration()%>" <%}%>>
										</div>
									</fieldset>

									<h1>Learning Objectives</h1>
									<fieldset>
										<h2>Learning Objectives for this lesson</h2>
										<div class="form-group">
											<label class="font-normal">Select learning objectives</label>
											<select id="learn_obj" multiple="multiple"
												data-placeholder="Choose Learning Objectives..." class=""
												tabindex="-1">
												<option value="">Select</option>
											</select>
										</div>
										<input id="searchLOs" placeholder="Search for learning objective" style="margin-bottom: 5px; min-width: 449px;">
										<div class="ibox float-e-margins">
							                <div class="ibox-content text-center p-md" id="searchLOsResult" >								
							                    
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
									</fieldset>

									<h1>Media Upload</h1>
									<fieldset>
										<h2>Image Upload</h2>
										<div class="row">
											<div class="col-lg-12">
												<h5>
													Lesson Image cropper <!-- <small>http://fengyuanchen.github.io/cropper/</small> -->
												</h5>
												<div class="row">
													<div class="col-md-6">
														<div class="image-crop">
															<img id='lesson_image' src="<%=image_url%>">
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

									<h1>Content</h1>
									<fieldset>
										<h2>Add Content</h2>
										<%
											if (is_new) {
										%>
										<button type="button" class="btn btn-w-m btn-primary"
											id="edit_lesson_content">Add Content</button>
										<%
											} else {
										%>
										<div class="row">
											<jsp:include page="<%=jspFileName%>" flush="true" />
										</div>
										<%
											}
										%>
									</fieldset>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id='modalContainer'>
		<div class="modal inmodal fade" id="chooseLOModal" tabindex="-1"
		role="dialog" aria-hidden="true">
			<div class="modal-dialog modal-sm">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">Choose LOs</h4>
					</div>
					<div class="modal-body">
						<label class="font-normal">Select context skill</label><select
							id="context_skill" data-placeholder="Choose a Context Skill..."
							class="" tabindex="-1">
							<option value="">Select</option>
						</select> <label class="font-normal">Select module level skill</label> <select
							id="module_skill" data-placeholder="Choose a module level Skill..."
							class="" tabindex="-1">
							<option value="">Select</option>
						</select> <label class="font-normal">Select session level skill</label> <select
							id="session_skill"
							data-placeholder="Choose a session level Skill..." class=""
							tabindex="-1">
							<option value="">Select</option>
						</select> <label class="font-normal">Select learning objectives</label> <select
							id="learn_obj_modal" multiple="multiple"
							data-placeholder="Choose Learning Objectives..." class=""
							tabindex="-1">
							<option value="">Select</option>
						</select>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-white" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary" id='addLOs'>Add
							LOs</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../inc/foot.jsp"></jsp:include>
</body>
<!-- Mainly scripts -->
<script type="text/javascript">
	
</script>