<%@page import="com.viksitpro.core.dao.entities.ContextDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Context"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.skill.pojo.LearningObjective"%>
<%@page import="com.viksitpro.core.skill.pojo.SessionLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.ModuleLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.CourseLevelSkill"%>
<%@page import="com.viksitpro.core.skill.services.CoreSkillService"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
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

int courseId = Integer.parseInt(request.getParameter("course_id"));
Course course = new CourseDAO().findById(courseId);
/* CourseDAO courseDao = new CourseDAO();
List<Course> courses = courseDao.findAll(); */
%>
<!-- <style>
.jstree-anchor {
    /*enable wrapping*/
    white-space : normal !important;
    /*ensure lower nodes move down*/
    height : auto !important;
    /*offset icon width*/
    padding-right : 24px;
}
</style> -->
<link rel="stylesheet"	href="//static.jstree.com/3.3.4/assets/dist/themes/default/style.min.css" />
<body class="top-navigation" id="course_skill_tree" data-helper='This page is used to show skill tree of Courses.'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			
			<% 
			   String[] brd = {"Dashboard","Courses"};
			%>
			<%=UIUtils.getPageHeader("Course Delivery Tree / "+course.getCourseName(), brd) %>
		<%-- <div class="row card-box scheduler_margin-box">

				<div class="ui-group">
					<h3 class="ui-group__title">Filter</h3>
					<div class="filters button-group js-radio-button-group btn-group">						
						<%
							DBUTILS util = new DBUTILS();	
							String getCourses = "select id, course_name from course order by course_name";
						List<HashMap<String	, Object>> courseData = util.executeQuery(getCourses);
						for(HashMap<String	, Object> row: courseData){
						%>

						<button class="button btn btn-white button_spaced btn-xs course_skill_course_selector"
							data-course_id="<%=row.get("id").toString()%>"><%=row.get("course_name").toString()%></button>
						<%
							
							}
						%>
					</div>
				</div>

			</div> --%>	
			
			<div id="modal-form" class="modal fade" aria-hidden="true" style="display: none;">
                                
                        </div>
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
			<div class="row">
			<!-- <div class="col-md-6">	
			<div class="ibox-title">
                                    <h5>Course Skill Tree</h5>
                                    
                                </div>
							<div class="ibox-content">
								<div id="skillTree">
									
								</div>
							</div>
			</div> -->
			<div class="col-md-12">	
			<div class="ibox-title">
                                    <h5>Course Delivery Tree</h5>
                                    
                                </div>
							<div class="ibox-content">
								<div id="course_delivery_tree">
									<jsp:include page="/skill_partails/course_delivery_tree_partial.jsp">
									<jsp:param value="<%=courseId%>" name="course_id"/> 
									</jsp:include>
								</div> 
							</div>
			</div>				
			</div>	
							
						
			</div>
			
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
	<script src="https://static.jstree.com/3.3.4/assets/dist/jstree.min.js"
		type="text/javascript"></script>
		
	<script type="text/javascript">
	</script>	
</body>


</html>