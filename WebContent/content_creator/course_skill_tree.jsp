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
CourseDAO courseDao = new CourseDAO();
List<Course> courses = courseDao.findAll();
%>
<link rel="stylesheet"	href="//static.jstree.com/3.3.4/assets/dist/themes/default/style.min.css" />
<body class="top-navigation" id="course_skill_tree" data-helper='This page is used to show skill tree of Courses.'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			
			<% 
			   String[] brd = {"Dashboard","Skill Administration"};
			%>
			<%=UIUtils.getPageHeader("Course Skill Tree", brd) %>
				
				
<div class="row card-box scheduler_margin-box">
			
			<div class="col-md-4">
                                    <p>
                                       Select Course
                                    </p>
                                    <select class="select2_demo_1 form-control" id="course_skill_course_selector">
                                        <%
                                        for(Course course : courses)
                                        {
                                        	%>
                                        	<option value="<%=course.getId()%>"><%=course.getCourseName()%></option>
                                        	<%
                                        }	
                                        %>
                                    </select>
                                </div>
			
			</div>
			
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
				
							<div class="ibox-content">
								<div id="skillTree">
									
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


</html>