<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.viksitpro.core.dao.entities.CmsessionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	Boolean is_new = true;
	String image_url = baseURL + "img/user_images/recruiter_portal_trans_logo_old.png";
	String baseProdURL = (new URLServices()).getBaseUrl();
	DBUTILS dbutils = new DBUTILS();
	Cmsession cmsession = new Cmsession();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
	String sessionName = "Create Session";
	if (request.getParameterMap().containsKey("session")) {
		cmsession = (new CmsessionDAO()).findById(Integer.parseInt(request.getParameter("session")));
		is_new = false;
		image_url = cdnPath.substring(0,cdnPath.length())+cmsession.getImage_url();
		sessionName = cmsession.getTitle();
	}
%>
<body class="top-navigation" id="session_edit"
	data-helper='This page is used to edit an individual session.'>
	<div id="wrapper">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
				<%-- <div class="col-lg-6">
					<h2>
						<%
							if (is_new) {
						%>New Session
						<%
							} else {
						%>
						<%=cmsession.getTitle()%>
						<%
							}
						%>
					</h2>
					<ol class="breadcrumb"
						style="background-color: transparent !important;">
						<li><a href="/content/content_creator/dashboard.jsp">Home</a></li>
						<li><a href="/content/creator/cmsessions.jsp">Session(s)</a></li>
						<li class="active"><strong> <%
 	if (is_new) {
 %>Create <%
 	} else {
 %>Edit <%
 	}
 %>Session
						</strong></li>
					</ol>
				</div> --%>
				<%
				String[] brd = {"Dashboard", "Courses"};
			%>
			<%=UIUtils.getPageHeader(sessionName, brd)%>
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box">
				<div class="row">
							<div class="ibox-content">
								<h2>
									<%
										if (is_new) {
									%>New Session<%
										} else {
									%>Session name:
									<%=cmsession.getTitle().trim()%>
									<%
										}
									%>
								</h2>
								<p>Follow these steps to create/update a session.</p>
								<input type='hidden' name='isNew' value='<%=is_new.toString()%>'/>
								<input type='hidden' name='cmsID' value='<%=cmsession.getId()%>'/>
								<input type='hidden' name='baseProdURL' value='<%=baseProdURL%>'/>
								<form id="form" action="#" class="wizard-big">
									<h1>Basic</h1>
									<fieldset class="fieldset-border-margin">
										<h2>Session Information</h2>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label>Name *</label> <input id="cmsession_name_idd"
														name="cmsession_name" type="text"
														class="form-control required" <%if (!is_new) {%>
														value="<%=cmsession.getTitle().trim()%>" <%}%>>
												</div>
												<div class="form-group">
													<label>Description *</label>
													<textarea class="form-control required"
														name="cmsession_desc" rows="3" id="cmsession_desc_idd"><%if (!is_new) {%><%=cmsession.getDescription().trim()%><%}%></textarea>
												</div>
											</div>
											<div class="col-lg-4">
												<div class="form-group" id="filezz">
													<input id="fileupload" type="file" accept="image/png"
														name="files[]" multiple>
													<!-- <input type="button" value="Upload" id='uploadImage'/> -->
													<button type="button" id='uploadImage'
														class="btn btn-danger btn-xs m-t-xs">Upload Image</button>
												</div>
												<br/>
												<img src='<%=image_url%>' class="form-group"
													id='session_image'>
											</div>
										</div>
									</fieldset>
									<h1>Lessons</h1>
							<fieldset class="fieldset-border-margin">
								<div class="col-md-6">
									<div class="ibox-content custom-scroll">
										<ul class="list-group custom-li-padding" id="editable">
											<%
												if (!is_new) {
													String sql = "select * from lesson_cmsession where cmsession_id = " + cmsession.getId();
													List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
													for (HashMap<String, Object> item : items) {
														Lesson lesson = (new LessonDAO()).findById(Integer.parseInt(item.get("lesson_id").toString()));
														if (lesson.getId() >= 0 && !lesson.getIsDeleted()) {
											%>
											<li class="list-group-item something"
												data-lesson_id="<%=lesson.getId()%>"><span
												class="badge badge-primary"><i
													class="js-remove fa fa-trash-o"> </i></span> <%=lesson.getId()%> |
												<%=lesson.getTitle()%></li>
											<%
														}
													}
												}
											%>
										</ul>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<div class="col-sm-12">
											<input id="searchLessons" type="text" class="form-control"
												placeholder="Search for lesson by title, description..">
										</div>
									</div>
										<div class="ibox-content no-padding custom-scroll">
											<ul class="list-group custom-li-padding" id="searchLessonsResult">
											</ul>
										</div>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<!-- Mainly scripts -->
<jsp:include page="../inc/foot.jsp"></jsp:include>
<script type="text/javascript">
</script>