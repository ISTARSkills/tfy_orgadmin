<%@page import="java.util.HashMap"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentQuestion"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentDAO"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.Assessment"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.List"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<style>
.pagination .bootpag>li {
	display: inline !important;
}
</style>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	List<Course> courses = (new CourseDAO()).findAll();
	Boolean is_new = true;
	Assessment assessment = new Assessment();
	Lesson lesson = new Lesson();
	String image_url = baseURL + "img/user_images/recruiter_portal_trans_logo_old.png";
	DBUTILS dbutils = new DBUTILS();
	String assessment_type = "New Assessment";
	String baseProdURL = (new URLServices()).getBaseUrl();
	if (request.getParameterMap().containsKey("assessment")) {
		assessment_type = "Edit Assessment";

		is_new = false;
		assessment = (new AssessmentDAO())
				.findById(Integer.parseInt(request.getParameter("assessment").toString()));
		lesson = (new LessonServices()).getLessonforAssessment(assessment);
	}
	if (request.getParameterMap().containsKey("lesson")) {
		lesson = (new LessonDAO()).findById(Integer.parseInt(request.getParameter("lesson").toString()));
		if (lesson != null && lesson.getType().equalsIgnoreCase(LessonTypeNames.ASSESSMENT)) {
			assessment = (new LessonServices()).getAssessmentforLesson(lesson);
			if (assessment != null) {
				is_new = false;
			}
		}
	}
%>
<body class="top-navigation" id="assessment_edit" data-helper='This page is used to edit an individual assessment'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<div id="page-wrapper" class="gray-bg">
				<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<%
					String[] brd = {"Dashboard", "Assessments"};
				%>
				<%=UIUtils.getPageHeader(assessment_type, brd)%>


				<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
					<div class="row">
						<div class="col-lg-12">
							<div class="ibox float-e-margins no-margins">
								<div class="ibox-title">
									<h5>Assessment Wizard</h5>
								</div>
								<div class="ibox-content">
									<p>Please follow the following steps</p>
									<input type='hidden' name='isNew' value='<%=is_new.toString()%>' /> <input type='hidden' name='isNew' value='<%=is_new.toString()%>' /> <input type='hidden' name='cmsID' value='<%=assessment.getId()%>' /> <input type='hidden' name='baseProdURL' value='<%=baseProdURL%>' />
									<form id="form" class="wizard-big">
										<%
											if (!is_new) {
										%><input type="hidden" name="assessment_id" value="<%=assessment.getId()%>" id='assessment_id_idd' />
										<%
											}
										%>
										<!-- class="form-horizontal" -->
										<h1>Basic details</h1>
										<fieldset class='fieldset-border-margin'>
											<div class="row">
												<div class="col-lg-6">
													<div class="form-group">
														<label>Assessment Title</label> <input class="form-control required" id="assessment_name_idd" type="text" name="assessment_name" <%if (!is_new) {%> value='<%=assessment.getAssessmenttitle()%>' <%}%>>
													</div>
													<div class="form-group">
														<label>Assessment Description</label>
														<textarea class="form-control required" name="assessment_desc" rows="3" id="assessment_desc_idd"> <%
 	if (!is_new) {
 %><%=assessment.getDescription()%> <%
 	}
 %> </textarea>
													</div>
													<div class="form-group">
														<label>Assessment Duration (minutes)</label> <input class="form-control required" id="assessment_duration_idd" type="number" name="assessment_duration" step="5" <%if (!is_new) {%> value="<%=assessment.getAssessmentdurationminutes()%>" <%}%>>
													</div>
												</div>
												<div class="col-lg-6">
													<div class="form-group ">
														<label>Select Assessment Type</label> <select class="form-control" name="assessment_type" id='assessment_type_idd'>
															<option value="STATIC" <%if (!is_new) {
				if (assessment.getAssessmentType().equalsIgnoreCase("STATIC")) {%> selected <%}
			}%>>Static Assessment</option>

														</select>
													</div>
													<div class="form-group">
														<label>Assessment Category</label> <select class="form-control" name="assessment_category" id='assessment_category_idd'>
															<option value="JOBS" <%if (!is_new) {
				if (assessment.getCategory().equalsIgnoreCase("JOBS")) {%> selected <%}
			}%>>JOBS Assessment</option>
															<option value="TRAINER_ASSESSMENT" <%if (!is_new) {
				if (assessment.getCategory().equalsIgnoreCase("TRAINER_ASSESSMENT")) {%> selected <%}
			}%>>TRAINER Assessment</option>
															<option value="COURSE_ASSESSMENT" <%if (!is_new) {
				if (assessment.getCategory().equalsIgnoreCase("COURSE_ASSESSMENT")) {%> selected <%}
			}%>>Course Assessment</option>
														</select>
													</div>

													<div class="form-group">
														<label>Select Course</label> <select class="form-control">
															<%
																String sql = "select id,course_name from course";
																List<HashMap<String, Object>> coursess = dbutils.executeQuery(sql);
																for (HashMap<String, Object> course : coursess) {
															%>
															<option <%if (assessment.getCourse() == course.get("id")) {%> selected <%}%> value="<%=course.get("id")%>"><%=course.get("course_name")%></option>
															<%
																}
															%>
														</select>
													</div>
													<div>
														<label> <input id="assessment_retry_idd" type="checkbox" class="i-checks" <%if (!is_new) {
				if (assessment.getRetryAble()) {%> checked <%}
			}%>> Is Retriable 
														</label>
													</div>
												</div>
											</div>
										</fieldset>

										<h1>Add/Review Questions</h1>
										<fieldset class='fieldset-border-margin'>
											<div class="col-md-6">
												<div class="form-group">
													<h3>Questions in this assessment</h3>
													<ul class="list-group custom-li-padding" id="editable" style="max-height: 54vh; overflow-y: scroll;">
														<%
															Set<AssessmentQuestion> aqs = new HashSet<AssessmentQuestion>();
															aqs = assessment.getAssessmentQuestions();
															for (AssessmentQuestion aq : aqs) {
																String questionText = aq.getQuestion().getQuestionText().replaceAll("<p>", "").replaceAll("</p>", "")
																		.replaceAll("<strong>", "").replaceAll("</strong>", "");
														%>
														<li class="question list-group-item" data-assessmentQuestionID="<%=aq.getQuestion().getId()%>"><span class="badge badge-primary"><i class="fa fa-trash-o"> </i></span> | <%=aq.getQuestion().getId()%> | <%=questionText%></li>
														<%
															}
														%>
													</ul>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-group">
													<div class="col-sm-12">
														<input id="searchQuestions" type="text" class="form-control" placeholder="Search for questions by text, skill..">
													</div>
												</div>
												<div class="ibox-content no-padding custom-scroll">
													<ul class="list-group custom-li-padding" id="searchQuestionsResult">
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
			</div>
		</div>
	</div>
</body>
<!-- Mainly scripts -->
<jsp:include page="../inc/foot.jsp"></jsp:include>
<script type="text/javascript">
	
</script>