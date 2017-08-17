<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
<%@page import="com.viksitpro.core.utilities.TaskItemCategory"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.Task"%>
<%@page import="com.viksitpro.core.dao.utils.task.TaskServices"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.CmsessionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<%
	IstarUser istarUser = (IstarUser) request.getSession(false).getAttribute("user");
	LessonDAO lessonDAO = new LessonDAO();
	CmsessionDAO cmsessionDAO = new CmsessionDAO();
	TaskServices taskServices = new TaskServices();
	List<Task> tasks = new ArrayList<Task>();
	List<Lesson> lessons = new ArrayList<Lesson>();
	if (istarUser != null) {
		tasks = taskServices.getAllTaskOfActor(istarUser);
	} else {
		System.out.println("IstarUser is null");
	}
	System.out.println("getting tasks for user");
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
%>

<div class="row ">
	<%
		
		for (Task task : tasks) {
			Lesson lesson = new Lesson();
			System.out.println(task.getId() + " -----  " + task.getItemId());

			if (task.getItemType().equalsIgnoreCase("LESSON")) {
				try {
					lesson = (new LessonDAO()).findById(task.getItemId());
					String lesson_edit_url = "/content_creator/lesson.jsp?lesson=" + lesson.getId();
					String img_url = "/assets/img/no_course_module_lesson_image/l_1.png";
					if(lesson.getImage_url()!= null && !lesson.getImage_url().equalsIgnoreCase("") && lesson.getImage_url().endsWith(".png")){
						img_url = cdnPath+lesson.getImage_url();
					}
					if (!lesson.getIsDeleted()) {
						String cmsessionString = "NONE";
						String cmsessionStringLong = "NONE";
						String course_category = "NONE";
						try {
							cmsessionStringLong = lesson.getCmsessions().iterator().next().getTitle();
							cmsessionString = cmsessionStringLong.replaceAll(" ", "").toLowerCase();
							course_category = lesson.getCmsessions().iterator().next().getModules().iterator().next().getCourses().iterator().next().getCategory();
						} catch (Exception e) {

						}
	%>

	<div class="col-md-2 box  pageitem <%=cmsessionString%>">
		<div class="ribbon">
			<span><%=lesson.getType()%></span>
		</div>
		<div class="ibox product-box customcss_height-prod-box">
			<div class="ibox-content customcss_ibox_product_border">

				<div class="imgWrap">
					<img alt="image" class="customcss_img-size" src="<%=img_url%>">
				</div>
				<div class="product-desc">
					<span class="product-price"><span
						class="label label-primary">Course Category - <%=course_category%></span>
					</span> <a
						href="/content_creator/lesson.jsp?lesson_id=<%=lesson.getId()%>"
						class="product-name"><%=lesson.getTitle()%> </a>

					<div class="small m-t-xs">
						<%=(lesson.getDescription() != null && lesson.getDescription().length() > 100)
									? lesson.getDescription().substring(0, 100) : lesson.getDescription()%>
					</div>
					
						<%
						String href_url = "";
							if (lesson.getType().equalsIgnoreCase("PRESENTATION")) {
								 href_url = "/content_creator/presentation.jsp?lesson_id="+lesson.getId();
								 
							} else if (lesson.getType().equalsIgnoreCase(LessonTypeNames.ASSESSMENT)) {
								 href_url = "/creator/assessment.jsp?lesson="+lesson.getId();
						
							} else if (lesson.getType().equalsIgnoreCase(LessonTypeNames.INTERACTIVE)) {
								 href_url = "/content_creator/interactive_template/ui_builder.jsp?ppt_id="+lesson.getId();
						
							}
						%>
						
				</div>
				<div class="col-md-12 customcss_lesson-button">
						<div class="col-md-6 text-center">
						<a href="<%=href_url %>" target="_blank"
							class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Preview <i
							class="fa fa-desktop"></i>
						</a></div><div class="col-md-6 text-center"> <a href="<%=lesson_edit_url%>"
							class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Edit <i
							class="fa fa-pencil"></i>
						</a></div><div class="col-md-6 text-center customcss_lesson-margin" > <a  data-lesson_id='<%=lesson.getId()%>' href="#"
							class="btn btn-xs btn-outline btn-primary delete_lesson customcss_lesson-button_btn">Delete
							<i class="fa fa-trash-o"></i>
						</a></div><div class="col-md-6 text-center customcss_lesson-margin"> <a data-lesson_id='<%=lesson.getId()%>' href="#"
							class="btn btn-xs btn-outline btn-primary publish_lesson customcss_lesson-button_btn">Publish
							<i class="fa fa-print"></i>
						</a></div>
						
					</div>
			</div>
		</div>
	</div>
	<%
		}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

	for (Lesson lesson : lessons) {

			String lesson_edit_url = "/content_creator/lesson.jsp?lesson=" + lesson.getId();
			String img_url = "/assets/img/no_course_module_lesson_image/l_1.png";
			if (lesson.getImage_url() != null && !lesson.getImage_url().equalsIgnoreCase("")
					&& lesson.getImage_url().endsWith(".png")) {
				img_url = cdnPath + lesson.getImage_url();
			}
			System.out.println(">>>>>>>>>>>>>> "+lesson.getId());
			if (!lesson.getIsDeleted()) {
				String cmsessionString = "NONE";
				String cmsessionStringLong = "NONE";
				String course_category = "NONE";

				cmsessionStringLong = lesson.getCmsessions().iterator().next().getTitle();
				cmsessionString = cmsessionStringLong.replaceAll(" ", "").toLowerCase();
				course_category = lesson.getCmsessions().iterator().next().getModules().iterator().next()
						.getCourses().iterator().next().getCategory();
	%>

	<div class="col-md-2 box  pageitem <%=cmsessionString%>">
		<div class="ribbon">
			<span><%=lesson.getType()%></span>
		</div>
		<div class="ibox product-box customcss_height-prod-box">
			<div class="ibox-content customcss_ibox_product_border">

				<div class="imgWrap">
					<img alt="image" class="customcss_img-size" src="<%=img_url%>">
				</div>
				<div class="product-desc">
					<span class="product-price"><span
						class="label label-primary">Course Category - <%=course_category%></span>
					</span> <a
						href="/content_creator/lesson.jsp?lesson_id=<%=lesson.getId()%>"
						class="product-name"><%=lesson.getTitle()%> </a>

					<div class="small m-t-xs">
						<%=(lesson.getDescription() != null && lesson.getDescription().length() > 100)
							? lesson.getDescription().substring(0, 100)
							: lesson.getDescription()%>
					</div>

					<%
						String href_url = "";
								if (lesson.getType().equalsIgnoreCase("PRESENTATION")) {
									href_url = "/content_creator/presentation.jsp?lesson_id=" + lesson.getId();

								} else if (lesson.getType().equalsIgnoreCase(LessonTypeNames.ASSESSMENT)) {
									href_url = "/creator/assessment.jsp?lesson=" + lesson.getId();

								} else if (lesson.getType().equalsIgnoreCase(LessonTypeNames.INTERACTIVE)) {
									href_url = "/content_creator/interactive_template/ui_builder.jsp?ppt_id=" + lesson.getId();

								}
					%>

				</div>
				<div class="col-md-12 customcss_lesson-button">
					<div class="col-md-6 text-center">
						<a href="<%=href_url%>" target="_blank"
							class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Preview
							<i class="fa fa-desktop"></i>
						</a>
					</div>
					<div class="col-md-6 text-center">
						<a href="<%=lesson_edit_url%>"
							class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Edit
							<i class="fa fa-pencil"></i>
						</a>
					</div>
					<div class="col-md-6 text-center customcss_lesson-margin">
						<a data-lesson_id='<%=lesson.getId()%>' href="#"
							class="btn btn-xs btn-outline btn-primary delete_lesson customcss_lesson-button_btn">Delete
							<i class="fa fa-trash-o"></i>
						</a>
					</div>
					<div class="col-md-6 text-center customcss_lesson-margin">
						<a data-lesson_id='<%=lesson.getId()%>' href="#"
							class="btn btn-xs btn-outline btn-primary publish_lesson customcss_lesson-button_btn">Publish
							<i class="fa fa-print"></i>
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