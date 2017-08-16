<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="java.util.Set"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Module"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.ModuleDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<%
	IstarUser istarUser = (IstarUser) request.getAttribute("user");
	ModuleDAO moduleDAO = new ModuleDAO();
	CourseDAO courseDAO = new CourseDAO();
	moduleDAO.getSession().clear();
	courseDAO.getSession().clear();
	List<Module> modules = (List<Module>) moduleDAO.findAll();
	List<Course> courses = (List<Course>) courseDAO.findAll();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
%>

<body class="top-navigation" id="module_list" data-helper='This page is used to show list of modules. '>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			<div class="row wrapper border-bottom white-bg page-heading" style="padding-left: 30px; padding-bottom: 13px;">
				<div class="col-lg-5">
					<h2>Modules grid</h2>
					<ol class="breadcrumb">
						<li><a href="/content/content_creator/dashboard.jsp">Home</a></li>
						<li><a>Modules</a></li>
						<li class="active"><strong>Modules grid</strong></li>
					</ol>
				</div>
				<div class="col-lg-4 form-group" style="margin-top: 26px; padding: 7px">
					<select class="js-example-basic-single" id="filters">
						<option></option>
						<%
							for (Course course : courses) {
								String courseSearchString = course.getCourseName().replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "").toLowerCase();
						%>
						<option value="<%=courseSearchString%>"><%=course.getCourseName()%></option>
						<%
							}
						%>
					</select>
				</div>
				<div class="col-lg-1" style="margin-top: 26px; padding: 0px">
					<button class="btn btn-primary dim" type="button" id="create_module" style="float: right;">
						<i class="fa fa-plus-circle" title="Create a Module"></i>&nbsp;Create
					</button>
				</div>
				<div class="col-lg-2 form-group">
					<input style="margin-top: 26px; padding: 7px;" type="text" id="quicksearch" placeholder="Search" />
				</div>
			</div>

			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<%
						for (Module module : modules) {
							if (!module.getIsDeleted()) {
								String courseString = "NONE";
								String courseStringLong = "NONE";
								String course_category = "NONE";
								String moduleDescription = module.getModule_description();
								if(module.getModule_description().length() > 100) {
									moduleDescription = module.getModule_description().substring(0, 100);
								}
										
								try {
									courseStringLong = module.getCourses().iterator().next().getCourseName();
									courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "").toLowerCase();
									course_category = module.getCourses().iterator().next().getCategory();
								} catch (Exception e) {

								}
					%>

					<div class="col-md-3  pageitem <%=courseString%>" style="padding-left: 7px; padding-right: 7px">
						<div class="ibox">
							<div class="ibox-content product-box">

								<div class="imgWrap">
									<img alt="image" style="width: 100%" class=" " src="<%=cdnPath+module.getImage_url()%>">
								</div>
								<div class="product-desc">
									<span class="product-price"><span class="label label-primary">Course Category - <%=course_category%></span> </span> <small class="text-muted"> <span class="badge badge-warning">Course - <%=courseStringLong%></span></small> <a href="/content/content_creator/edit_module.jsp?module=<%=module.getId()%>" class="product-name"><%=module.getModuleName()%> </a>

									<div class="small m-t-xs">
										<%=moduleDescription%>
									</div>
									<div class="m-t text-righ">

										<a href="/content/creator/module.jsp?module=<%=module.getId()%>" class="btn btn-xs btn-outline btn-primary">Edit <i class="fa fa-pencil"></i>
										</a> <a data-module='<%=module.getId()%>' href="#" class="btn btn-xs btn-outline btn-primary delete_module">Delete <i class="fa fa-trash-o"></i>
										</a>
									</div>
								</div>
							</div>
						</div>
					</div>
					<%
						}
						}
					%>

				</div>




			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
</body>

<script type="text/javascript">
	
</script>
</html>