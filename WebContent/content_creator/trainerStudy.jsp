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
<body class="top-navigation" id="trainer_study_list"
	data-helper='This page is used to show list of sessions. '>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			
			<%
				String[] brd = {"Dashboard"};
			%>
			<%=UIUtils.getPageHeader("Trainer Study Progress", brd)%>
			
			
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box ">
				<div class="row">
					<div class="col-md-12">
						<div class="ibox no-margins">
							<div class="ibox-content">
								<div class="row">
									<div class="col-sm-5 m-b-xs">
										<select class="input-sm form-control input-s-sm inline"
											id="course">
											<%
												DBUTILS dbutils = new DBUTILS();
												CourseDAO dao = new CourseDAO();
												List<Course> listOfCourses = dao.findAll();
												for (Course course : listOfCourses) {
											%>
											<option value="<%=course.getId()%>"><%=course.getCourseName()%></option>
											<%
												}
											%>
										</select>
									</div>
								</div>
								<div class="table-responsive">
									<table class="table table-bordered">
										<thead id="tableHead">
										</thead>
										<tbody id="tableBody">
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		
	});
	
</script>