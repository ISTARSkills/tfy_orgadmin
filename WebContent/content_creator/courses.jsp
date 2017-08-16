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
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
%>

<body class="top-navigation" id="course_list" data-helper='This page is used to show list of courses. '>
	<div id="wrapper" class='customcss_overflowy'>
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>

			<% 
			   String[] brd = {"Dashboard","Courses"};
			%>
			<%=UIUtils.getPageHeader("Courses Grid", brd) %>
			<div class="row card-box scheduler_margin-box">
				<div class="col-lg-2">
					<button type="button" id="create_course" class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Course
					</button>
				</div>
				<div class="col-lg-2 form-group customcss_search-box">
					<input class="form-control" autocomplete="off" type="text" id="quicksearch" placeholder="Search Course" />
				</div>
			</div>
			<div class="row card-box scheduler_margin-box">
			 This is where we will put course context for filters
			
			</div>
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
				<div class="row" id="course_list_holder">
					<%
						for (Course course : courses) {
							if (true) { //is_deleted stub
								String course_category = "NONE";
							String img_url = "/assets/img/no_course_module_lesson_image/c_1.png";
							if(course.getImage_url()!= null && !course.getImage_url().equalsIgnoreCase("") && course.getImage_url().endsWith(".png")){
								img_url = cdnPath+course.getImage_url();
							}
							
								try {
									course_category = course.getCategory();
								} catch (Exception e) {
								}
					%>

					<div class="col-md-2 pageitem <%=course_category%>">
						<div class="ibox product-box customcss_height-prod-box">
							<div class="ibox-content  customcss_ibox_product_border">

								<div class="imgWrap">
									<img alt="image" class="customcss_img-size" src="<%=img_url%>">
								</div>
								<div class="product-desc">
									<span class="product-price"><span class="label label-primary">Context - <%=course_category%></span> </span> <small class="text-muted"> <%--  <span class="badge badge-warning">Module - <%=moduleStringLong%></span> --%>
									</small> <a href="/creator/course.jsp?course=<%=course.getId()%>" class="product-name"><%=course.getCourseName()%> </a>

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

								<a href="/content_creator/course.jsp?course=<%=course.getId()%>" class="btn btn-xs btn-outline btn-primary">Edit <i class="fa fa-pencil"></i>
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