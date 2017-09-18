<%@page import="com.viksitpro.core.elt.interactive.EntityOption"%>
<%@page import="com.viksitpro.core.elt.interactive.CMSSlide"%>
<%@page
	import="com.viksitpro.core.elt.interactive.InteractiveLessonServices"%>
<%@page import="com.viksitpro.core.elt.interactive.CMSLesson"%>
<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>

<%
	boolean flag = false;
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	if (cp == null) {
		flag = true;
		request.setAttribute("msg", "User Does Not Have Permission To Access");
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}
	request.setAttribute("cp", cp);
	int lessonId = -1, slide_id = -1;
	CMSLesson cmsLesson = null;
	CMSSlide cmsSlide = null;
	InteractiveLessonServices services = new InteractiveLessonServices();

	if (request.getParameter("lesson_id") != null) {
		lessonId = Integer.parseInt(request.getParameter("lesson_id"));
		cmsLesson = services.getCmsInteractiveLesson(lessonId);
	}

	if (request.getParameter("slide_id") != null) {
		slide_id = Integer.parseInt(request.getParameter("slide_id"));
	}

	if (slide_id != -1 && cmsLesson != null) {
		for (CMSSlide cmsSlide1 : cmsLesson.getSlides()) {
			if (cmsSlide1.getId() == slide_id) {
				cmsSlide = cmsSlide1;
			}
		}
	}
%>

<link href="<%=baseURL%>assets/css/plugins/steps/jquery.steps.css"
	rel="stylesheet">
<jsp:include page="/inc/head.jsp"></jsp:include>

<link href="<%=baseURL%>assets/css/interactive_custom.css"
	rel="stylesheet">


<body id="interactive_lesson">

	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container mx-0 mt-5 mb-2">
			<div class="row">
				<a class="back-button" id='back-button' href='./edit_lesson_inter.jsp?lesson_id=<%=lessonId%>'>
					<i class="fa fa-arrow-circle-left"></i> Back to Lesson
				</a>
			</div>
		</div>

		<!-- slide preview starts -->
		<form id='slide_form' method='GET' action=''>
			<input type='hidden' name='lesson_id' value='<%=lessonId%>' /> <input
				type='hidden' name=slide_id value='<%=slide_id%>' />
			<div class='mobile-specific w-100 m-0 p-0 white-bg'>
				<div class='row w-100 p-0 m-0'>

					<div class='col-8 pl-5 pr-5'>
						<jsp:include page="./interactive/interactive_options_partial.jsp">
							<jsp:param value='<%=lessonId + ""%>' name='lesson_id' />
							<jsp:param value='<%=slide_id + ""%>' name='slide_id' />
						</jsp:include>
					</div>
					<div class='col-4 mobile-specific'>
						<div class="row">
							<div class='mobile-preview'>
								<div class=' mobile-inside' id='mobile-holder'>

									<!-- drag-drop/tap based template starts -->
									<jsp:include page="./interactive/dt_template_based.jsp">
										<jsp:param value='<%=lessonId + ""%>' name='lesson_id' />
										<jsp:param value='<%=slide_id + ""%>' name='slide_id' />
										<jsp:param value='TOP' name='type' />
									</jsp:include>
									<jsp:include page="./interactive/dt_template_based.jsp">
										<jsp:param value='<%=lessonId + ""%>' name='lesson_id' />
										<jsp:param value='<%=slide_id + ""%>' name='slide_id' />
										<jsp:param value='BOTTOM' name='type' />
									</jsp:include>
									<!-- drag-drop/tap based template starts -->

									<!-- MATCH based template starts -->
									<div
										class='w-100 h-100 m-0 p-0 mobile_preview match-based-holder'
										id='mobile_preview_match'>

										<div class='w-100 h-100'
											style="background-color: transparent;">
											<div class='row w-100 m-0 p-0 h-100'>
												<div
													class='col-6 m-0 p-0 w-100 h-100 custom-scroll match-holder-questions'
													style='overflow: auto;'>

													<%
														if (cmsSlide != null && cmsSlide.getTemplate() != null && cmsSlide.getTemplate().equalsIgnoreCase("MATCH")
																&& cmsSlide.getEntityOptions() != null
																&& cmsSlide.getEntityOptions().getEntityOptions().size() != 0) {

															for (EntityOption entityOption : cmsSlide.getEntityOptions().getEntityOptions()) {
																if (entityOption.getType() != null && entityOption.getType().equalsIgnoreCase("draggable")) {
													%>
													<jsp:include page="./interactive/match_template_based.jsp">
														<jsp:param name="position"
															value="<%=entityOption.getId()%>" />
														<jsp:param name="bg_image"
															value="<%=entityOption.getImage_BG()%>" />
														<jsp:param name="opt_text"
															value="<%=entityOption.getOption_text()%>" />
														<jsp:param name="type" value="ques" />
													</jsp:include>

													<%
														}
															}
														}
													%>

												</div>
												<div
													class='col-6 m-0 p-0 w-100 h-100 custom-scroll match-holder-options'
													style='overflow: auto;'>

													<%
														if (cmsSlide != null && cmsSlide.getTemplate() != null && cmsSlide.getTemplate().equalsIgnoreCase("MATCH")
																&& cmsSlide.getEntityOptions() != null
																&& cmsSlide.getEntityOptions().getEntityOptions().size() != 0) {

															for (EntityOption entityOption : cmsSlide.getEntityOptions().getEntityOptions()) {
																if (entityOption.getType() != null && entityOption.getType().equalsIgnoreCase("droppable")) {
													%>
													<jsp:include page="./interactive/match_template_based.jsp">
														<jsp:param name="position"
															value="<%=entityOption.getId()%>" />
														<jsp:param name="bg_image"
															value="<%=entityOption.getImage_BG()%>" />
														<jsp:param name="opt_text"
															value="<%=entityOption.getOption_text()%>" />
														<jsp:param name="correct_option"
															value="<%=entityOption.getCorrect_option()%>" />
														<jsp:param name="type" value="option" />
													</jsp:include>
													<%
														}
															}
														}
													%>
												</div>
											</div>
										</div>
									</div>
									<!-- MATCH based template ends -->

									<!-- ORDERING based template starts -->
									<div
										class='w-100 h-100 m-0 p-0 mobile_preview order-based-holder'
										id='mobile_preview_order'>

										<div class='w-100 h-100'
											style="background-color: transparent;">
											<div
												class='row w-100 m-0 p-0 match-holder-orders custom-scroll'>
												<%
													if (cmsSlide != null && cmsSlide.getTemplate() != null
															&& cmsSlide.getTemplate().equalsIgnoreCase("ORDERING") && cmsSlide.getEntityOptions() != null
															&& cmsSlide.getEntityOptions().getEntityOptions().size() != 0) {

														for (EntityOption entityOption : cmsSlide.getEntityOptions().getEntityOptions()) {
															int order = entityOption.getCorrect_order_id();
												%>
												<jsp:include page="./interactive/order_template_based.jsp">
													<jsp:param name="position"
														value="<%=entityOption.getId()%>" />

													<jsp:param name="bg_image"
														value="<%=entityOption.getImage_BG()%>" />
													<jsp:param name="opt_text"
														value="<%=entityOption.getOption_text()%>" />
													<jsp:param name="correct_order" value="<%=order%>" />
												</jsp:include>
												<%
													}
													}
												%>

											</div>
										</div>
									</div>
									<!-- ORDERING based template ends -->

								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
		<!-- slide preview ends -->

	</div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script src="<%=baseURL%>assets/js/plugins/steps/jquery.steps.min.js"></script>
	<script src="<%=baseURL%>assets/js/plugins/steps/jquery.steps.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script src="<%=baseURL%>assets/js/interactive_custom.js"></script>

</body>
</html>