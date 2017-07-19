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

<jsp:include page="../inc/head.jsp"></jsp:include>
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
%>

 
<body class="top-navigation student_pages" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">

					<%
						int i = 0;
					
					if(cp != null && cp.getCourses() != null){
						for (CoursePOJO course : cp.getCourses()) {
							if (course.getId() == Integer.parseInt(course_id) && course.getModules() != null) {
								for (ModulePOJO modulePOJO : course.getModules()) {
									String className="";
									if(!modulePOJO.getStatus().equalsIgnoreCase("COMPLETED")){
										className=" background-color: #cbcbcd !important";
									}
					%>
					<a href="/student/roles/roles_lesson.jsp?course_id=<%=course.getId() %>&module_id=<%=modulePOJO.getId() %>" style="color: black;"><div class="col-md-3 ">
							<div class="ibox" >
								<div class="ibox-content product-box h-370 "  style= " <%=className %> ; min-height: 267px !important">
									<div style="    min-height: 60px;"><h3 class="p-xxs m-l-xs"><%=modulePOJO.getName()%></h3></div>
									
									<div class="product-imitation" style="padding: 0px !important;">
										<img alt="" src="<%=modulePOJO.getImageURL()%>"
											style="width: 100%;">
									</div>
									
								</div>

							</div>
						</div></a>
					<%
						}
							}
						}}
					%>

					
				</div>
			</div>
		</div>
	</div>



	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
</body>

</html>
