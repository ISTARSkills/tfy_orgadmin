<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.core.dao.entities.Assessment"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentDAO"%>
<%@page import="com.viksitpro.core.dao.entities.SkillObjectiveDAO"%>
<%@page import="com.viksitpro.core.dao.entities.SkillObjective"%>
<%@page import="com.viksitpro.core.dao.entities.Task"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.utils.task.TaskServices"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	IstarUser istarUser = (IstarUser) request.getSession(false).getAttribute("user");
	String cdnPath = new LessonServices().getAnyPath("media_url_path");
	TaskServices taskServices = new TaskServices();
	List<Task> tasks = new ArrayList<Task>();
	AssessmentDAO assessmentDAO = new AssessmentDAO();
	List<Assessment> assessments = assessmentDAO.findAll();
%>
<body class="top-navigation" id="assessment_list"
	data-helper='This page is used to show list of assessments. '>
	<div id="wrapper" class='customcss_overflowy'>
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			<%
				String[] brd = {"Dashboard", "Assessments"};
			%>
			<%=UIUtils.getPageHeader("Assessment List", brd)%>

			<div class="row card-box scheduler_margin-box">


				<div class="col-lg-2">

					<button type="button" id="create_assessment"
						class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Assessment
					</button>
				</div>
				<div class="col-lg-2 form-group customcss_search-box">
					<input class="form-control quicksearch" autocomplete="off"
						type="text" id="quicksearch" placeholder="Search Assessment" />
				</div>
			</div>

			<div class="row card-box scheduler_margin-box">

				<div class="ui-group ">
					<h3 class="ui-group__title">Filter</h3>
					<div class="filters button-group js-radio-button-group btn-group">
						<button class="button btn button_spaced btn-xs btn-danger"
							data-filter="*">show all</button>
						<%
							ArrayList<String> arrayList = new ArrayList<>();
							ArrayList<String> displayList = new ArrayList<>();
							for (Assessment assessment : assessments) {
								String courseStringLong = "";
								

								try {
									int course_id = assessment.getCourse();
									Course course = new CourseDAO().findById(course_id);
									courseStringLong = course.getCourseName();
									String courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "")
											.toLowerCase();

									if (!arrayList.contains(courseString)) {
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
						for (Assessment assessment : assessments) {

							String courseStringLong = "";
							String courseString = "";
							String img_url = "/assets/img/no_course_module_lesson_image/c_1.png";
							try {

								int course_id = assessment.getCourse();
								Course course = new CourseDAO().findById(course_id);
								courseStringLong = course.getCourseName();
								if (course.getImage_url() != null && !course.getImage_url().equalsIgnoreCase("")
										&& course.getImage_url().endsWith(".png")) {
									img_url = cdnPath + course.getImage_url();
								}
								courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "")
										.toLowerCase();
							} catch (Exception e) {
							}
					%>

					<div
						class="col-md-2 pageitem transition element-item  <%=courseString%> ">
						<div class="ibox product-box customcss_height-prod-box">
							<div class="ibox-content  customcss_ibox_product_border">

								<div class="imgWrap">
									<img alt="image" class="customcss_img-size" src="<%=img_url%>">
								</div>
								<div class="product-desc">
									<span
										class="product-price customcss_product_price customcss_font-size"><span
										class="label label-primary"><%=courseStringLong%></span> </span> <small
										class="text-muted"> </small> <a
										href="/content_creator/assessment.jsp?assessment=<%=assessment.getId()%>"
										class="product-name"><%=assessment.getAssessmenttitle()%>
									</a>


								</div>
								<div class="col-lg-12 customcss_lesson-button1">
									<div class="col-md-3 text-center"></div>
									<div class="col-md-6 text-center">
									
									   <a href="#" target="_blank" class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Preview
											<i class="fa fa-desktop"></i>
										</a>
									
									
									
										
									</div>
									<div class="col-md-3 text-center"></div>
								</div>
								<div class="col-lg-12 customcss_dashboard_buttons">
										<div class="col-md-7 text-center">
										
										<a href="assessment_skill_tree.jsp?assessment_id=<%=assessment.getId()%>" target="_blank" class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Link-Skills
											<i class="fa fa-link"></i>
										</a>
										</div>
										<div class="col-md-5 text-center">
										
										<a href="/content_creator/assessment.jsp?assessment=<%=assessment.getId()%>"
											class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Edit <i
											class="fa fa-pencil"></i>
										</a>
										</div>
										</div>
							</div>

						</div>
					</div>
					<%
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