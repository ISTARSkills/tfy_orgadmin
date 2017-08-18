<%@page import="java.util.ArrayList"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
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
	cdnPath = cdnPath.substring(0, cdnPath.length() - 1);
%>

<body class="top-navigation" id="module_list"
	data-helper='This page is used to show list of modules. '>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			<%
				String[] brd = { "Dashboard", "Modules" };
			%>
			<%=UIUtils.getPageHeader("Modules Grid", brd)%>
			<div class="row card-box scheduler_margin-box">
				<div class="col-lg-2">
					<button type="button" id="create_module"
						class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Module
					</button>
				</div>
				<div class="col-lg-2 form-group customcss_search-box quicksearch">
					<input class="form-control quicksearch" autocomplete="off" type="text"
						id="quicksearch" placeholder="Search Modules" />
				</div>
			</div>
			<div class="row card-box scheduler_margin-box">
				<div class="ui-group ">
					<h3 class="ui-group__title">Filter</h3>
					<div class="filters button-group js-radio-button-group btn-group">
						<button class="button btn button_spaced btn-xs btn-danger" data-filter="*">show all</button>
						<%
							ArrayList<String> arrayList = new ArrayList<>();
						ArrayList<String> displayList = new ArrayList<>();
							for (Module module : modules) {
								String course_category = "";
								try {
									String courseStringLong = module.getCourses().iterator().next().getCourseName();
									String courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "").toLowerCase();
									 course_category = module.getCourses().iterator().next().getCategory();
									 if(!arrayList.contains(courseString)){
										 arrayList.add(courseString);
										 displayList.add(courseStringLong);
									 }
								} catch (Exception e) {

								}
							}
							int i = 0;
							for (String c_category : arrayList) {
						%>

						<button class="button btn button_spaced btn-xs btn-white"
							data-filter=".<%=c_category%>"><%=displayList.get(i)%></button>
						<%
						i++;}
						%>
					</div>
				</div>
				
				</div>
			<div
				class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
				<div class="row grid">
					<%
						for (Module module : modules) {
							if (!module.getIsDeleted()) {
								String courseString = "NONE";
								String courseStringLong = "NONE";
								String course_category = "NONE";
								String img_url = "/assets/img/no_course_module_lesson_image/m_1.png";
								if (module.getImage_url() != null && !module.getImage_url().equalsIgnoreCase("")
										&& module.getImage_url().endsWith(".png")) {
									img_url = cdnPath + module.getImage_url();
								}
								String moduleDescription = module.getModule_description();
								if (module.getModule_description().length() > 100) {
									moduleDescription = module.getModule_description().substring(0, 100);
								}
								try {
									courseStringLong = module.getCourses().iterator().next().getCourseName();
									courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "")
											.toLowerCase();
									course_category = module.getCourses().iterator().next().getCategory();
								} catch (Exception e) {

								}
					%>
					<div class="col-md-2  element-item pageitem <%=courseString%>">
						<div class="ibox product-box customcss_height-prod-box">
							<div class="ibox-content customcss_ibox_product_border">
								<div class="imgWrap">
									<img alt="image" class="customcss_img-size" src="<%=img_url%>">
								</div>
								<div class="product-desc">
									<span class="product-price customcss_product_price"><span
										class="label label-primary">Course - <%=courseStringLong%></span>
									</span> <a
										href="/content_creator/edit_module.jsp?module=<%=module.getId()%>"
										class="product-name"><%=module.getModuleName()%> </a>
									<div class="small m-t-xs">
										<%=moduleDescription%>
									</div>
								</div>
								<div class="col-md-12 customcss_lesson-button">
									<div class="col-md-6 text-center">
										<a
											href="/content_creator/module.jsp?module=<%=module.getId()%>"
											class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Edit
											<i class="fa fa-pencil"></i>
										</a>
									</div>
									<div class="col-md-6 text-center">
										<a data-entity_id='<%=module.getId()%>' data-delete_type='module'
											class="btn btn-xs btn-outline btn-primary master_delete customcss_lesson-button_btn">Delete
											<i class="fa fa-trash-o"></i>
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