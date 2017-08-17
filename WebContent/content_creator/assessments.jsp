<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.core.dao.entities.Assessment"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentDAO"%>
<%@page import="com.viksitpro.core.dao.entities.SkillObjectiveDAO"%>
<%@page import="com.viksitpro.core.dao.entities.SkillObjective"%>
<%@page import="com.viksitpro.core.dao.entities.Task"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.utils.task.TaskServices"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	IstarUser istarUser = (IstarUser) request.getSession(false).getAttribute("user");
	TaskServices taskServices = new TaskServices();
	List<Task> tasks = new ArrayList<Task>();
	AssessmentDAO assessmentDAO = new AssessmentDAO();
	List<Assessment> assessments = assessmentDAO.findAll();
%>
<body class="top-navigation" id="assessment_list"
	data-helper='This page is used to show list of assessments. '>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			<%
				String[] brd = { "Dashboard", "Assessments" };
			%>
			<%=UIUtils.getPageHeader("Assessment List", brd)%>
			
			<div class="row card-box scheduler_margin-box">
				
				
				<div class="col-lg-2" >
					
					<button type="button" id="create_assessment"
						class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Assessment
					</button>
				</div>
                 <div class="col-lg-2 form-group customcss_search-box">
					<input class="form-control quicksearch" autocomplete="off" type="text"
						id="quicksearch" placeholder="Search Assessment" />
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
							for (Assessment assessment : assessments) {
								String courseStringLong = "";
								int course_id = assessment.getCourse();
								Course course = new CourseDAO().findById(course_id);
								

								try {
									courseStringLong = course.getCourseName();
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

			<div class="wrapper wrapper-content animated fadeInUp">

				<div class="ibox">
					<div class="ibox-title">
						<h5>All Assessments</h5>
					</div>
					<div class="ibox-content">
						<div class="project-list">
							<table class="table table-hover">
								<tbody>
									<%
										for (Assessment assessment : assessments) {
											
									%>
									<tr id="<%=assessment.getId()%>" class="pageitem">
										<td class="project-status"><span
											class="label label-primary"><%=assessment.getAssessmentType()%></span></td>
										<td class="project-title"><a href="<%=baseURL%>content_creator/assessment.jsp?assessment=<%=assessment.getId()%>"><%=assessment.getAssessmenttitle()%></a></td>
										<td class="project-actions"><a
											href="<%=baseURL%>content_creator/assessment.jsp?assessment=<%=assessment.getId()%>"
											class="btn btn-white btn-sm"><i class="fa fa-folder"></i>
												Edit </a> <%-- <a href="<%=baseURL%>creator/preview_assessment.jsp?assessment=<%=assessment.getId()%>" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Preview </a>--%></td> 
									</tr>
									<%
										}
									%>
								</tbody>
							</table>
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

</script>
</html>