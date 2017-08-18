<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.CmsessionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<%
	IstarUser istarUser = (IstarUser) request.getAttribute("user");
	LessonDAO lessonDAO = new LessonDAO();
	CmsessionDAO cmsessionDAO = new CmsessionDAO();
	List<Lesson> lessons = new ArrayList<Lesson>();
	lessons = (List<Lesson>) lessonDAO.findAll();
	List<Cmsession> cmsessions = (List<Cmsession>) cmsessionDAO.findAll();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
%>

<body class="top-navigation" id="lesson_list" data-helper='This page is used to show list of lessons. '>
	<div id="wrapper" class='customcss_overflowy'>
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			<% 
			   String[] brd = {"Dashboard","Lessons"};
			%>
			<%=UIUtils.getPageHeader("Lessons Grid", brd) %>
				<div class="row card-box scheduler_margin-box">
				<div class="col-lg-1" >
					<button type="button" id="create_lessonzz" class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Lesson
					</button>
				</div>
				<div class="modal inmodal fade" id="myModal6" tabindex="-1" role="dialog" aria-hidden="true">
					<div class="modal-dialog modal-sm">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal">
									<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
								</button>
								<h4 class="modal-title">Select Lesson Type</h4>
							</div>
							<div class="modal-body">
								<button type="button" class="btn btn-primary create_lesson" id="elt">Interactive Lesson</button>
								<button type="button" class="btn btn-primary create_lesson" id="vlt">Video Lesson</button>
								<button type="button" class="btn btn-primary create_lesson" id="ilt">ILT Lesson</button>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-white" data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>

				<div class="col-lg-2 form-group customcss_search-box">
					<input class="form-control quicksearch" autocomplete="off" type="text" id="quicksearch" placeholder="Search Lesson" />
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
							for (Lesson lesson : lessons) {
								String cmsessionString = "NONE";
								String cmsessionStringLong = "NONE";
								String courseStringLong = "";

								try {
									cmsessionStringLong = lesson.getCmsessions().iterator().next().getTitle();
									cmsessionString = cmsessionStringLong.replaceAll(" ", "").toLowerCase();
									courseStringLong = lesson.getCmsessions().iterator().next().getModules().iterator().next().getCourses().iterator().next().getCategory();
									String courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "").toLowerCase();
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
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box " id='only_lesson_items'>

				<div class="row grid">
					<%
						for (Lesson lesson : lessons) {
							if (!lesson.getIsDeleted()) {
								String lesson_edit_url = "/content_creator/lesson.jsp?lesson="+lesson.getId();
								String cmsessionString = "NONE";
								String cmsessionStringLong = "NONE";
								String course_category = "NONE";
								String courseString ="";
								try {
									cmsessionStringLong = lesson.getCmsessions().iterator().next().getTitle();
									cmsessionString = cmsessionStringLong.replaceAll(" ", "").toLowerCase();
									course_category = lesson.getCmsessions().iterator().next().getModules().iterator().next().getCourses().iterator().next().getCategory();
									 courseString = course_category.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "").toLowerCase();
								} catch (Exception e) {

								}
					%>

					<div class="col-md-2 box transition element-item pageitem <%=cmsessionString%> <%=courseString%>">
						<div class="ribbon">
							<span><%=lesson.getType()%></span>
						</div>
						<div class="ibox product-box customcss_height-prod-box">
							<div class="ibox-content customcss_ibox_product_border">

								<div class="imgWrap">
									<img alt="image" class="customcss_img-size" src="<%=cdnPath+lesson.getImage_url()%>">
								</div>
								<div class="product-desc">
									<span class="product-price customcss_product_price"><span class="label label-primary">Course Category - <%=course_category%></span> </span> <small class="text-muted"> <h5 class="badge badge-warning customcss_font-size">Session - <%=cmsessionStringLong%></h5></small> <a href="/content/creator/lesson.jsp?lesson_id=<%=lesson.getId()%>" class="product-name"><%=lesson.getTitle()%> </a>

									<div class="small m-t-xs">
										<%=(lesson.getDescription() != null && lesson.getDescription().length() > 100)? lesson.getDescription().substring(0, 100): lesson.getDescription()%>
									</div>
									
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
								<div class="col-lg-12 customcss_lesson-button1">
						<div class="col-md-6 text-center">
						<a href="<%=href_url %>" target="_blank"
							class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Preview <i
							class="fa fa-desktop"></i>
						</a></div><div class="col-md-6 text-center"> <a href="<%=lesson_edit_url%>"
							class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Edit <i
							class="fa fa-pencil"></i>
						</a></div></div><div class="col-lg-12 customcss_lesson-button"><div class="col-md-6 text-center customcss_lesson-margin" > <a  data-entity_id='<%=lesson.getId()%>'
							data-delete_type='lesson' class="btn btn-xs btn-outline btn-primary master_delete customcss_lesson-button_btn">Delete
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