<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
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
	IstarUser istarUser = (IstarUser) request.getAttribute("user");
	LessonDAO lessonDAO = new LessonDAO();
	CmsessionDAO cmsessionDAO = new CmsessionDAO();
	List<Lesson> lessons = (List<Lesson>) lessonDAO.findAll();
	List<Cmsession> cmsessions = (List<Cmsession>) cmsessionDAO.findAll();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
%>

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
									<span class="product-price customcss_product_price"><span class="label label-primary">Course Category - <%=course_category%></span> </span> <small class="text-muted"> <h5 class="badge badge-warning" style="font-size: 9px">Session - <%=cmsessionStringLong%></h5></small> <a href="/content/creator/lesson.jsp?lesson_id=<%=lesson.getId()%>" class="product-name"><%=lesson.getTitle()%> </a>

									<div class="small m-t-xs">
										<%=(lesson.getDescription() != null && lesson.getDescription().length() > 100)? lesson.getDescription().substring(0, 100): lesson.getDescription()%>
									</div>
									<%-- <div class="m-t text-righ">
									<%if(lesson.getType().equalsIgnoreCase(LessonTypeNames.PRESENTATION)){ %>
										<a href="/content_creator/presentation.jsp?lesson_id=<%=lesson.getId()%>" target="_blank" class="btn btn-xs btn-outline btn-primary">Preview <i class="fa fa-desktop"></i></a>
										<%}else if(lesson.getType().equalsIgnoreCase(LessonTypeNames.ASSESSMENT)){ %>
										<a href="/content_creator/assessment.jsp?lesson=<%=lesson.getId()%>" target="_blank" class="btn btn-xs btn-outline btn-primary">Preview <i class="fa fa-desktop"></i></a>
										<%} else if(lesson.getType().equalsIgnoreCase(LessonTypeNames.INTERACTIVE)){ %>
										<a href="/content_content_creator/interactive_template/ui_builder.jsp?ppt_id=<%=lesson.getId()%>" target="_blank" class="btn btn-xs btn-outline btn-primary">Preview <i class="fa fa-desktop"></i></a>
										<%} %>
										<a href="<%=lesson_edit_url %>" class="btn btn-xs btn-outline btn-primary">Edit <i class="fa fa-pencil"></i>
										</a> <a data-lesson_id='<%=lesson.getId()%>' href="#" class="btn btn-xs btn-outline btn-primary delete_lesson">Delete <i class="fa fa-trash-o"></i>
										</a> <a data-lesson_id='<%=lesson.getId()%>' href="#" class="btn btn-xs btn-outline btn-primary publish_lesson">Publish <i class="fa fa-print"></i></a>
									</div> --%>
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
						}
					%>

				</div>