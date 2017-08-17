<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.CmsessionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.ModuleDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Module"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<body class="top-navigation" id="course_tree"
	data-helper='This page is used to show a course in tree form. '>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<% 
			   String[] brd = {"Dashboard","Courses"};
			%>
			<%=UIUtils.getPageHeader("Courses Grid", brd) %>
			<div class="page-title-box">
				<div class="row">
					<div class="col-md-4">
						<h4 class="page-title customcss_page-title">Nomenclature</h4>
					</div>
					<div class="col-md-6">
					<ul style="float: right; margin-top: 20px; padding: 0px; list-style: none;">
						<li><i class="glyphicon glyphicon-asterisk"> Course</i></li>
						<li><i class="glyphicon glyphicon-tree-deciduous"> Module</i>
						</li>

					</ul>
				</div>
				<div class="col-md-2">
					<ul style="margin-top: 20px; padding: 0px; list-style: none;">
						<li><i class="glyphicon glyphicon-leaf"> Session</i></li>
						<li><i class="glyphicon glyphicon-apple"> Lesson</i></li>
					</ul>
				</div>
				</div>
				<div class="clearfix"></div>
			</div>
			
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
							<div class="ibox-content">
								<div id="courseTree">
									<ul>
										<%
											DBUTILS dbutils = new DBUTILS();
											CourseDAO dao = new CourseDAO();
											String hql = "from Course order by id";
											List<Object> courzes = dbutils.executeHQL(hql);
											for (Object courze : courzes) {
												Course course = (Course) courze;
										%>
										<li data-jstree='{"icon":"glyphicon glyphicon-asterisk"}' class="COURSE"><a
											href="/content/creator/course.jsp?course=<%=course.getId()%>"><%=course.getId()%> - <%=course.getCourseName()%></a>
											<ul>
												<%
													String sql = "select * from module_course where course_id = " + course.getId();
														List<HashMap<String, Object>> modulz = dbutils.executeQuery(sql);
														for (HashMap<String, Object> modul : modulz) {
															Module module = (new ModuleDAO()).findById(Integer.parseInt(modul.get("module_id").toString()));
												%>
												<li
													data-jstree='{"icon":"glyphicon glyphicon-tree-deciduous"}' class="MODULE"><a
													href="/content/creator/module.jsp?module=<%=module.getId()%>"><%=module.getId()%> - <%=module.getModuleName()%></a>
													<ul>
														<%
															String sql1 = "select * from cmsession_module where module_id =" + module.getId();
																	List<HashMap<String, Object>> cmsessioz = dbutils.executeQuery(sql1);
																	for (HashMap<String, Object> cmsessio : cmsessioz) {
																		Cmsession cmsession = (new CmsessionDAO())
																				.findById(Integer.parseInt(cmsessio.get("cmsession_id").toString()));
														%>
														<li data-jstree='{"icon":"glyphicon glyphicon-leaf"}' class="CMSESSION"><a
															href="/content/creator/cmsession.jsp?session=<%=cmsession.getId()%>"><%=cmsession.getId()%> - <%=cmsession.getTitle()%></a>
															<ul>
																<%
																	String sql2 = "select * from lesson_cmsession where cmsession_id = " + cmsession.getId();
																				List<HashMap<String, Object>> lessoz = dbutils.executeQuery(sql2);
																				for (HashMap<String, Object> lesso : lessoz) {
																					Lesson lesson = (new LessonDAO())
																							.findById(Integer.parseInt(lesso.get("lesson_id").toString()));
																					Boolean isDelteted = false;
																					Boolean isPublished = false;
																					isDelteted = lesson.getIsDeleted();
																					isPublished = lesson.getIsPublished();
																					String previewLink="/content/creator/lesson.jsp?lesson="+lesson.getId();
																					if(lesson.getType().equalsIgnoreCase("PRESENTATION")){ 
																						previewLink="/content/content_creator/presentation.jsp?lesson_id="+lesson.getId();
																					} else if(lesson.getType().equalsIgnoreCase("INTERACTIVE")) {
																						previewLink = "/content/content_creator/interactive_template/ui_builder.jsp?ppt_id="+lesson.getId();
																					} else if(lesson.getType().equalsIgnoreCase("ASSESSMENT")) {
																						previewLink = "/content/creator/assessment.jsp?lesson="+lesson.getId();
																					}
																					String editLink="/content/creator/lesson.jsp?lesson="+lesson.getId();
																					if(lesson.getType().equalsIgnoreCase("PRESENTATION")){ 
																						editLink="/content/content_creator/template/create_slide.jsp?lesson_id="+lesson.getId();
																					} else if(lesson.getType().equalsIgnoreCase("INTERACTIVE")) {
																						editLink = "/content/content_creator/interactive_template/ui_builder.jsp?ppt_id="+lesson.getId();
																					} else if(lesson.getType().equalsIgnoreCase("ASSESSMENT")) {
																						editLink = "/content/creator/assessment.jsp?lesson="+lesson.getId();
																					}
																%>
																<%
																				if (!isDelteted) {
																			%>
																			<li data-jstree='{"icon":"glyphicon glyphicon-apple"}' class="LESSON" preview="<%=previewLink%>" edit="<%=editLink%>"><a
																	href="/content/creator/lesson.jsp?lesson=<%=lesson.getId()%>">
																		<%
																			if (isPublished) {
																		%><b>
																			<%
																				}
																			%>
																			<%=lesson.getId()%> - <%=lesson.getTitle()%>
																			<%
																				if (isPublished) {
																			%>
																	</b>
																		<%
																			}
																		%>
																</a></li>
																<%
																	}
																				}
																%>
															</ul></li>
														<%
															}
														%>
													</ul></li>
												<%
													}
												%>
											</ul></li>
										<%
											}
										%>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>

	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
	<script src="https://static.jstree.com/3.3.4/assets/dist/jstree.min.js"
		type="text/javascript"></script>
</body>
<script type="text/javascript">
	
</script>