<%@page import="in.talentify.core.utils.UIUtils"%>
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
	cdnPath = cdnPath.substring(0, cdnPath.length() - 1);
	String courseName = "Create Course";
	String context_name ="";
	if (request.getParameterMap().containsKey("course")) {
		CourseDAO courseDAO = new CourseDAO();
		courseDAO.getSession().clear();
		course = courseDAO.findById(Integer.parseInt(request.getParameter("course")));
		is_new = false;
		image_url = cdnPath.substring(0, cdnPath.length()) + course.getImage_url();
		courseName = course.getCourseName();
		context_name = course.getCategory()!=null?course.getCategory():"";
		System.out.print(">>>> "+ context_name);
	}
%>
<body class="top-navigation" id="course_edit"
	data-helper='This page is used to edit an individual course.'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
			<%
				String[] brd = {"Dashboard", "Courses"};
			%>
			<%=UIUtils.getPageHeader(courseName, brd)%>

			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box wizard-padding">
				<div class="row">
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
						<input type='hidden' name='isNew' value='<%=is_new.toString()%>' />
						<input type='hidden' name='cmsID' value='<%=course.getId()%>' />
						<input type='hidden' name='baseProdURL' value='<%=baseProdURL%>' />
						<form id="form" action="#" class="wizard-big">
							<h1>Basic Details</h1>
							<fieldset class="fieldset-border-margin">
								<h2>Course Information</h2>
								<div class="row">
									<div class="col-lg-8">
										<div class="form-group">
											<label>Name *</label> <input id="course_name_idd"
												name="course_name" type="text" class="form-control required"
												<%if (!is_new) {%> value="<%=course.getCourseName().trim()%>" <%}%>>
										</div>
										<div class="form-group">
											<label>Description *</label>
											<%
												String desc = "";
													if (!is_new) {
														desc = course.getCourseDescription().trim();
													}
												%>
											<textarea class="form-control required" name="course_desc"
												rows="3" id="course_desc_idd"><%=desc %></textarea>
										</div>
										<div class="form-group">
										<label>Category *</label> 
											<select name="course_category" 	class="form-control" id="course_category_idd">
										<% 
										List<Context> contexts = new ContextDAO().findAll();
										for(Context context:contexts){
										%>
											
											<option <%=context_name.equalsIgnoreCase(context.getTitle())?"selected":"" %> value="<%=context.getId()%>"><%=context.getTitle() %></option>
											
											<%}%>
											</select>
										</div>
									</div>
									<div class="col-lg-4">
									<h2>Image Upload</h2>
									<div class="form-group" id="filezz">
													<input id="fileupload" type="file" accept="image/png"
														name="files[]" multiple>
														<!-- <input type="button" value="Upload" id='uploadImage'/> -->
													<button type="button" id='uploadImage' class="btn btn-danger btn-xs m-t-xs">Upload Image</button>
												</div>
												<br/>
												<img src='<%=image_url%>'
														id='course_image' alt="Course Image">
									</div>
								</div>
							</fieldset>
							<h1>Map Modules</h1>
							<fieldset class="fieldset-border-margin">
								<div class="col-md-6">
									<div class="ibox-content custom-scroll">
										<ul class="list-group custom-li-padding" id="editable">
											<%
												if (!is_new) {
													String sql = "select * from module_course where course_id = " + course.getId();
													List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
													for (HashMap<String, Object> item : items) {
														Module module = (new ModuleDAO()).findById(Integer.parseInt(item.get("module_id").toString()));
														if (module.getId() >= 0 && !module.getIsDeleted()) {
											%>
											<li class="list-group-item something"
												data-module_id="<%=module.getId()%>"><span class="badge badge-primary"><i
													class="js-remove fa fa-trash-o"> </i></span> <%=module.getId()%> |
												<%=module.getModuleName()%></li>
											<%
														}
													}
												}
											%>
										</ul>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<div class="col-sm-12">
											<input id="searchModules" type="text" class="form-control"
												placeholder="Search for modules by title, description..">
										</div>
									</div>
									<div class="ibox-content no-padding custom-scroll">
										<ul class="list-group custom-li-padding"
											id="searchModulesResult">
										</ul>
									</div>
								</div>
							</fieldset>
						</form>
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