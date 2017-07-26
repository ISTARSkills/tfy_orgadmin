<%@page import="tfy.webapp.ui.OrgAdminPropData"%>
<%@page import="com.istarindia.android.pojo.LessonPOJO"%>
<%@page import="com.istarindia.android.pojo.ConcreteItemPOJO"%>
<%@page import="com.istarindia.android.pojo.ModulePOJO"%>
<%@page import="com.istarindia.android.pojo.CoursePOJO"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	request.setAttribute("cp", cp);
	String course_id = request.getParameter("course_id");
	//System.out.println("course id =========> " + course_id);
	String module_id = request.getParameter("module_id");
	//System.out.println("module_id =========> " + module_id);
%>


<body class="top-navigation student_pages" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row" id='equalheight'>

					<%
						int i = 0;
						if (cp != null && cp.getCourses() != null) {
							for (CoursePOJO course : cp.getCourses()) {
								if (course.getId() == Integer.parseInt(course_id) && course.getModules() != null) {
									for (ModulePOJO modulePOJO : course.getModules()) {
										if (modulePOJO.getId() == Integer.parseInt(module_id) && modulePOJO.getLessons() != null) {
											for (ConcreteItemPOJO lesson : modulePOJO.getLessons()) {
												LessonPOJO less = lesson.getLesson();
												
												if(less.getImageUrl() == null){
													less.setImageUrl("/course_images/l_"+less.getId()+".png");
												}
												
												String classname="";
												if(less.getStatus().equalsIgnoreCase("COMPLETED")){
													 classname="<div class='ribbon'><span>COMPLETED </span>									                            </div>";
												}
					%>
					
					<div class="col-md-3 "><%=classname %>
						<div class="ibox">
						<% String bg_status= ""; 
						if(less.isFuture(cp)) {
							bg_status = "background-color: #cbcbcd !important;";
						}%>
							<div class="ibox-content product-box h-370"
								style="min-height: 360px !important; <%=bg_status %>;">
								<div class="product-imitation" style="padding: 0px !important;">
									<img alt="<%=less.getTitle()%>"
										src="<%=OrgAdminPropData.get("media_url_path") %><%=less.getImageUrl() %>"
										style="width: 100%;max-height: 145px;">
								</div>
								<div class="progress progress-mini m-t-none">
											<div style="width: <%=lesson.getProgress() %>%" aria-valuemax="100" aria-valuemin="0"
												aria-valuenow="<%=lesson.getProgress() %>" role="progressbar" class="progress-bar">
											</div>
										</div>
								<div class="product-desc m-t-md" style="padding: 0px  !important;">
									<div class="medium m-t-xs">
										<div class="m-t-sm">
											<h3><%=less.getTitle()%></h3>
										</div>
										<div class="font-normal m-t-md"
											style="line-height: normal;">
											<p><%=less.getDescription()%></p>
										</div>
									</div>
									
								</div>
							</div>
							<div class="text-center button-top">
							
							<% if(!less.isFuture(cp)) { %>
								<a class="btn btn-rounded" target="_blank"
									href="/student/presentation.jsp?lesson_id=<%=less.getId()%>">BEGIN
									SKILL</a>
									<% } else { %>
									<a class="btn btn-rounded" 
									href="#">CONTENT LOCKED</a>
									
									<% } %>
							</div>
						</div>
					</div>
					<%
						}
										}
									}
								}
							}
						}
					%>


				</div>
			</div>
		</div>
	</div>



	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>

</html>
