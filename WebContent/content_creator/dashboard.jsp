<%@page import="com.viksitpro.cms.taskStage.pojo.LessonTaskStageServices"%>
<%@page import="java.util.Set"%>
<%@page import="com.viksitpro.cms.taskStage.pojo.Stage"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.cms.utilities.LessonTaskNames"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.utilities.TaskItemCategory"%>
<%@page import="tfy.webapp.ui.LessonServices"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.Task"%>
<%@page import="com.viksitpro.core.dao.utils.task.TaskServices"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	IstarUser istarUser = (IstarUser) request.getSession(false).getAttribute("user");
	TaskServices taskServices = new TaskServices();
	List<Task> tasks = new ArrayList<Task>();

	if (istarUser != null) {
		tasks = taskServices.getAllTaskOfActor(istarUser);
	} else {
		System.out.println("IstarUser is null");
	}
	System.out.println("getting tasks for user");
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0, cdnPath.length() - 1);
	
	
%>
<body class="top-navigation" id='super_admin_classroom'>
	<div id="wrapper" class='customcss_overflowy'>
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			
<% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Dashboard", brd) %>
				
				<div class="row white-bg card-box scheduler_margin-box no_padding_box">
				
				
				<div class="row">
					<%
						for (Task task : tasks) {

							System.out.println(task.getId() + " -----  " + task.getItemId());

							if (task.getItemType().equals(TaskItemCategory.LESSON)
									&& task.getName().equalsIgnoreCase(LessonTaskNames.CREATE_LESSON) && task.getIsActive()) {
								LessonDAO dao = new LessonDAO();
								dao.getSession().clear();
								dao.getSession().flush();
								Lesson lesson = new Lesson();
								lesson = dao.findById(task.getItemId());
								if (lesson != null && !lesson.getIsDeleted()) {
									Stage currentStage = (new LessonTaskStageServices()).getCurrentStage(task.getState());
									Set<Stage> stages = (new LessonTaskStageServices()).getNextStages(currentStage);
									String desc = "empty description";
									String img_url = "/assets/img/no_course_module_lesson_image/l_1.png";
									if(lesson.getImage_url()!= null && !lesson.getImage_url().equalsIgnoreCase("") && lesson.getImage_url().endsWith(".png")){
										img_url = cdnPath+lesson.getImage_url();
									}
									if (lesson.getDescription() != null) {
										if (lesson.getDescription().length() > 55) {
											desc = lesson.getDescription().substring(0, 55);
										} else {
											desc = lesson.getDescription();
										}
									}
									String edit_url = "/creator/lesson.jsp?lesson=" + lesson.getId();
					%>
					<div class="col-md-2 pageitem null">
						<div class="ribbon">
							<span><%=lesson.getType()%></span>
						</div>
						<div class="ibox product-box customcss_height-prod-box">
							<div class="ibox-content customcss_ibox_product_border">

								<div class="imgWrap">
									<img alt="image" class="customcss_img-size" src="<%=img_url%>">
								</div>
								<div class="product-desc">
									<span class="product-price customcss_product_price"><span
										class="label label-primary">Status - <%=task.getState()%></span>
									</span> <small class="text-muted"> </small> <a href="<%=edit_url%>"
										class="product-name"><%=lesson.getTitle()%></a>

									<div class="small m-t-xs"><%=desc%></div>
									
								</div>
							</div>
							<div class="col-lg-12 customcss_lesson-button1">
							<!-- <div class="m-t text-righ customcss_dashboard_buttons"> -->
							<div class="col-md-3 text-center"></div>
							<div class="col-md-6 text-center">
										<%
											if (lesson.getType().equalsIgnoreCase("PRESENTATION")) {
										%>
										<a
											href="/content_creator/presentation.jsp?lesson_id=<%=lesson.getId()%>"
											target="_blank" class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Preview
											<i class="fa fa-desktop"></i>
										</a>
										<%
											} else {
										%>
										<%-- <a
											href="/content/content_creator/review_lesson.jsp?lesson_id=<%=lesson.getId()%>"
											target="_blank" class="btn btn-xs btn-outline btn-primary">Preview
											<i class="fa fa-desktop"></i>
										</a> --%>
										<%
											}
										%>
										</div>
										<div class="col-md-3 text-center"></div>
										</div>
										<div class="col-lg-12 customcss_dashboard_buttons">
										<div class="col-md-6 text-center">
										<a href="<%=edit_url%>"
											class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Edit <i
											class="fa fa-pencil"></i>
										</a></div><div class="col-md-6 text-center"> <a data-lesson_id='<%=lesson.getId()%>' href="#"
											class="btn btn-xs btn-outline btn-primary publish_lesson customcss_lesson-button_btn">Publish
											<i class="fa fa-print"></i>
										</a></div>
										<%-- <%for(Stage stage : stages){ %>
										<a title="<%=stage.getName() %>" href="#" class="btn btn-xs btn-outline btn-primary"><i class="fa <%=stage.getIcon()%>"></i>
										</a>
										<%} %> --%>
									</div>
							
						</div>
						
					</div>
					<%
						}
							}
						}
					%>
				</div>	
				</div>

				

			</div>
		</div>
		<%-- <jsp:include page="../chat_element.jsp"></jsp:include> --%>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>