<%@page import="com.viksitpro.core.skill.pojo.DeliveryAssessmentTree"%>
<%@page import="com.viksitpro.core.dao.entities.Assessment"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentDAO"%>
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
//CourseDAO courseDao = new CourseDAO();
//List<Course> courses = courseDao.findAll();
int assessment_id = Integer.parseInt(request.getParameter("assessment_id"));
Assessment assessment = new AssessmentDAO().findById(assessment_id);
%>
<style>
.jstree-anchor {
    /*enable wrapping*/
    white-space : normal !important;
    /*ensure lower nodes move down*/
    height : auto !important;
    /*offset icon width*/
    padding-right : 24px;
}
</style>
<link rel="stylesheet"	href="//static.jstree.com/3.3.4/assets/dist/themes/default/style.min.css" />
<body class="top-navigation" id="assessment_skill_tree" data-helper='This page is used to show skill tree of Context'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			
			<% 
			   String[] brd = {"Dashboard","Assessments"};
			%>
			<%=UIUtils.getPageHeader("Assessment Delivery Tree / "+assessment.getAssessmenttitle(), brd) %>

		<%-- <div class="row card-box scheduler_margin-box">

				<div class="ui-group">
					<h3 class="ui-group__title">Filter</h3>
					<div class="row card-box scheduler_margin-box">
			
			<div class="col-md-4">
                                    <p>
                                       Select Course
                                    </p>
                                    <select class="select2_demo_1 form-control" id="assessment_skill_course_selector" title ="Select Course to get assessments under that course">
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
					<div class="filters button-group js-radio-button-group btn-group">						
						<%
						DBUTILS util = new DBUTILS();
						CoreSkillService serv = new CoreSkillService();
						
						String getCourses = "select id, course_id, assessmenttitle from assessment order by assessmenttitle";
						List<HashMap<String	, Object>> courseData = util.executeQuery(getCourses);
						for(HashMap<String	, Object> row: courseData){
							int assessmentId = (int)row.get("id");
							DeliveryAssessmentTree assessmentTree = serv.getDeliveryTreeForAssessment(assessmentId);
							String buttonClass = "btn-warning";
							boolean isValid = false;
							String error="";
							if(assessmentTree!=null && assessmentTree.isValid())
							{
								buttonClass ="btn-white";
								isValid = true;
							}
							if(!isValid)
							{
								error="One or more question is not mapped to Learning Objective.";
							}	
						%>

						<button title="<%=error%>" class="button btn <%=buttonClass%> button_spaced btn-xs assessment_skill_assessment_selector"
						data-course_id="<%=row.get("course_id").toString() %>" data-is_valid="<%=isValid%>"	data-assessment_id="<%=row.get("id").toString()%>" style="display:none"><%=row.get("assessmenttitle").toString()%></button>
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
                                    <h5>Assessment Skill Tree</h5>
                                    
                                </div>
							<div class="ibox-content">
								<div id="assessment_tree">
									
								</div> 
							</div>
			</div> -->
			<div class="col-md-12">	
			<div class="ibox-title">
                                    <h5>Assessment Delivery Tree</h5>                                    
                                </div>
							<div class="ibox-content">
								<div id="assessment_delivery_tree">
								<jsp:include page="/skill_partails/assessment_delivery_tree_partial.jsp">
								<jsp:param value="<%=assessment_id%>" name="assessment_id"/>
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
</body>


</html>