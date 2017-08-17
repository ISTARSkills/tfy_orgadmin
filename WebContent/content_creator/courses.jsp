<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.ModuleDAO"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<%
	IstarUser istarUser = (IstarUser) request.getAttribute("user");
	CourseDAO courseDAO = new CourseDAO();
	ModuleDAO moduleDAO = new ModuleDAO();
	List<Course> courses = new ArrayList<Course>();
	courses.removeAll(courses);
	courses = (List<Course>) courseDAO.findAll();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0, cdnPath.length() - 1);
%>

<body class="top-navigation" id="course_list"
	data-helper='This page is used to show list of courses. '>
	<div id="wrapper" class='customcss_overflowy'>
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>

			<%
				String[] brd = {"Dashboard", "Courses"};
			%>
			<%=UIUtils.getPageHeader("Courses Grid", brd)%>
			<div class="row card-box scheduler_margin-box">
				<div class="col-lg-2">
					<button type="button" id="create_course"
						class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Course
					</button>
				</div>
				<div class="col-lg-2 form-group customcss_search-box">
					<input class="form-control quicksearch" autocomplete="off"
						type="text" id="quicksearch" placeholder="Search Course" />
				</div>
			</div>
			<div class="row card-box scheduler_margin-box">

				<div class="ui-group">
					<h3 class="ui-group__title">Filter</h3>
					<div class="filters button-group js-radio-button-group btn-group">
						<button class="button btn btn-danger button_spaced btn-xs"
							data-filter="*">show all</button>
						<%
							ArrayList<String> arrayList = new ArrayList<>();
							ArrayList<String> displayList = new ArrayList<>();
							for (Course course : courses) {
								String course_category = "";

								if (course.getCategory() != null && !course.getCategory().contentEquals("")) {
									course_category = course.getCategory().trim().replace(" ", "_").replace("/", "_");
									if (!arrayList.contains(course_category)) {
										arrayList.add(course_category);
										displayList.add(course.getCategory());
									}
								}
							}

							int i = 0;
							for (String c_category : arrayList) {
						%>

						<button class="button btn btn-white button_spaced btn-xs"
							data-filter=".<%=c_category%>"><%=displayList.get(i)%></button>
						<%
							i++;
							}
						%>
					</div>
				</div>

			</div>
			<div
				class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box ">
				<div class="row grid">
					<%
						for (Course course : courses) {
							if (true) { //is_deleted stub
								String course_category = "NONE";
								String course_category1 = "";
								String img_url = "/assets/img/no_course_module_lesson_image/c_1.png";
								if (course.getImage_url() != null && !course.getImage_url().equalsIgnoreCase("")
										&& course.getImage_url().endsWith(".png")) {
									img_url = cdnPath + course.getImage_url();
								}

								try {
									if (course.getCategory() != null && !course.getCategory().contentEquals("")) {
										course_category1 = course.getCategory().trim().replace(" ", "_").replace("/", "_");
									}
									course_category = course.getCategory();
								} catch (Exception e) {
								}
					%>

					<div
						class="col-md-2 pageitem transition element-item <%=course_category1%> <%=course_category%> ">
						<div class="ibox product-box customcss_height-prod-box">
							<div class="ibox-content  customcss_ibox_product_border">

								<div class="imgWrap">
									<img alt="image" class="customcss_img-size" src="<%=img_url%>">
								</div>
								<div class="product-desc">
									<span class="product-price customcss_product_price"><span
										class="label label-primary">Context - <%=course_category%></span>
									</span> <small class="text-muted"> <%--  <span class="badge badge-warning">Module - <%=moduleStringLong%></span> --%>
									</small> <a
										href="/content_creator/course.jsp?course=<%=course.getId()%>"
										class="product-name"><%=course.getCourseName()%> </a>

									<div class="small m-t-xs">
										<%
											if (course.getCourseDescription().length() > 100) {
										%>
										<%=course.getCourseDescription().substring(0, 100)%>
										<%
											} else {
										%>
										<%=course.getCourseDescription()%>
										<%
											}
										%>
									</div>

								</div>
							</div>
							<div class="m-t text-righ customcss_float-right-edit ">

								<a href="/content_creator/course.jsp?course=<%=course.getId()%>"
									class="btn btn-xs btn-outline btn-primary">Edit <i
									class="fa fa-pencil"></i>
								</a>
								<%-- <a data-course_id='<%=course.getId()%>' href="#" class="btn btn-xs btn-outline btn-primary delete_course">Delete <i class="fa fa-trash-o"></i>
										</a> --%>
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