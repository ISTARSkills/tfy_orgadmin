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
tr.row_selected {
	background: silver;
}

tr.selected, tr:hover.selected, .table-striped>tbody>tr:nth-of-type(odd).selected
	{
	background-color: rgba(26, 179, 148, 0.45) !important;
	background-color: rgba(18, 220, 179, 1) !important;
	color: #000 !important;
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
	String baseProdURL = (new URLServices()).getBaseUrl();
	if (request.getParameterMap().containsKey("assessment")) {
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
<body class="top-navigation" id="assessment_edit"
	data-helper='This page is used to edit an individual assessment'>
	<div id="wrapper">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row wrapper border-bottom white-bg page-heading"
				style="padding-left: 30px; padding-bottom: 13px;">
				<div class="col-lg-6">
					<h2>
						<%
							if (is_new) {
						%>New Assessment
						<%
							} else {
						%>
						<%=assessment.getAssessmenttitle()%>
						<%
							}
						%>
					</h2>
					<ol class="breadcrumb"
						style="background-color: transparent !important;">
						<li><a href="/content/content_creator/dashboard.jsp">Course
								Administration</a></li>
						<li><a href="/content/creator/assessments.jsp">Assessment(s)</a></li>
						<li class="active"><strong> <%
 	if (is_new) {
 %>Create <%
 	} else {
 %>Edit <%
 	}
 %>Assessment
						</strong></li>
					</ol>
				</div>
			</div>

			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Assessment Wizard</h5>
							</div>
							<div class="ibox-content">
								<p>Please follow the following steps</p>
								<input type='hidden' name='isNew' value='<%=is_new.toString()%>'/>
								<input type='hidden' name='cmsID' value='<%=assessment.getId()%>'/>
								<input type='hidden' name='baseProdURL' value='<%=baseProdURL%>'/>
								<form id="form" class="wizard-big">
									<%
										if (!is_new) {
									%><input type="hidden" name="assessment_id"
										value="<%=assessment.getId()%>" id='assessment_id_idd' />
									<%
										}
									%>
									<!-- class="form-horizontal" -->
									<h1>Basic details</h1>
									<fieldset>
										<div class="row">
											<div class="col-lg-6">
												<div class="form-group">
													<label>Assessment Title</label> <input class="form-control"
														id="assessment_name_idd" type="text"
														name="assessment_name" style="width: 30vw !important"
														<%if (!is_new) {%>
														value='<%=assessment.getAssessmenttitle()%>' <%}%>>
												</div>
												<div class="form-group">
													<label>Assessment Description</label>
													<textarea class="form-control required" name="assessment_desc" rows="3" id="assessment_desc_idd"> <% if (!is_new) { %><%=assessment.getDescription()%> <% } %> </textarea>
												</div>
												<div class="form-group">
													<label>Assessment Retriable </label> <input
														id="assessment_retry_idd" type="checkbox"
														<%if (!is_new) {
				if (assessment.getRetryAble()) {%>
														checked <%}
			}%>>
												</div>
												<div class="form-group">
													<label>Assessment Duration (minutes)</label> <input
														class="form-control" id="assessment_duration_idd"
														type="number" name="assessment_duration" step="5"
														style="max-width: 70px;" <%if (!is_new) {%>
														value="<%=assessment.getAssessmentdurationminutes()%>"
														<%}%>>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label>Select Assessment Type</label> <select
														class="form-control" name="assessment_type"
														id='assessment_type_idd' style="max-width: 200px;">
														<option value="STATIC"
															<%if (!is_new) {
				if (assessment.getAssessmentType().equalsIgnoreCase("STATIC")) {%>
															selected <%}
			}%>>Static Assessment</option>
														<option value="ADAPTIVE"
															<%if (!is_new) {
				if (assessment.getAssessmentType().equalsIgnoreCase("ADAPTIVE")) {%>
															selected <%}
			}%>>Adaptive Assessment</option>
													</select>
												</div>
												<div class="form-group">
													<label>Assessment Category</label> <select
														class="form-control" name="assessment_category"
														id='assessment_category_idd' style="max-width: 200px;">
														<option value="JOBS"
															<%if (!is_new) {
				if (assessment.getCategory().equalsIgnoreCase("JOBS")) {%>
															selected <%}
			}%>>JOBS Assessment</option>
														<option value="TRAINER_ASSESSMENT"
															<%if (!is_new) {
				if (assessment.getCategory().equalsIgnoreCase("TRAINER_ASSESSMENT")) {%>
															selected <%}
			}%>>TRAINER Assessment</option>
													</select>
												</div>
												<div class="form-group">
													<label>Choose course</label> <select id="course"
														class="form-control" data-placeholder="Choose a Course..."
														style="width: 240px !important;">
														<%
															for (Course course : courses) {
														%>
														<option value="<%=course.getId()%>"
															<%if (!is_new) {
					if (assessment.getCourse() == course.getId()) {%>
															selected <%}
				}%>><%=course.getCourseName()%></option>
														<%
															}
														%>
													</select>
												</div>
											</div>
										</div>
									</fieldset>
									<h1>Questions</h1>
									<fieldset>
										<h3>Select Questions for this assessment</h3>
										<p>First Select the parent skill to filter learning
											objectives.</p>
										<div class="form-group">
											<label class="font-normal">Select context skill</label> <select
												id="context_skill"
												data-placeholder="Choose a Context Skill..." class=""
												tabindex="-1">
												<option value="">Select</option>
											</select>
										</div>
										<!-- <div class="form-group">
											<label class="font-normal">Select module level skill</label>
											<select id="module_skill"
												data-placeholder="Choose a module level Skill..." class=""
												tabindex="-1">
												<option value="">Select</option>
											</select>
										</div>
										<div class="form-group">
											<label class="font-normal">Select session level skill</label>
											<select id="session_skill"
												data-placeholder="Choose a session level Skill..." class=""
												tabindex="-1">
												<option value="">Select</option>
											</select>
										</div>
										<div class="form-group">
											<label class="font-normal">Select learning objectives</label>
											<select id="learn_obj" multiple="multiple"
												data-placeholder="Choose Learning Objectives..."
												class="question_filter_skills" tabindex="-1">
												<option value="">Select</option>
											</select>
										</div> -->
										<!-- <label class="font-normal">Select parent skill</label> <select
											id="parent_skill" data-placeholder="Choose a Parent Skill..."
											class="question_filter_skills" tabindex="-1"
											style="display: none;">
											<option value="">Select</option>
										</select> <label class="font-normal">Select Skill Objectives</label> <select
											id="skill_obj" class="question_filter_skills"
											data-placeholder="Choose a Skill Objective..." tabindex="-1">
											<option value="">Select</option>
										</select> <label class="font-normal">Select Learning Objectives</label>
										<select id="learn_obj" class="question_filter_skills"
											multiple="multiple">
											<option value="">Select</option>
										</select> -->

										<!-- table start -->

										<table class="table table-bordered datatable_istar"
											id='question_list'
											data-url='../AssessmentEngineMasterController'>
											<thead>
												<tr>
													<th data-visisble='true'>#</th>
													<th data-visisble='true'>Question Text</th>
													<th data-visisble='true'>Question Type</th>
													<th data-visisble='true'>Difficulty Level</th>
													<th data-visisble='true'>action</th>
												</tr>
											</thead>
											<tbody>

											</tbody>
										</table>
										<!-- table end -->
									</fieldset>
									<h1>Review Questions</h1>
									<fieldset>
										<div class="form-group">
											<h3>Questions in this assessment</h3>
											<ul class="list-unstyled file-list" id="editable">
												<%
													Set<AssessmentQuestion> aqs = new HashSet<AssessmentQuestion>();
													aqs = assessment.getAssessmentQuestions();
													for (AssessmentQuestion aq : aqs) {
														String questionText = aq.getQuestion().getQuestionText().replaceAll("<p>", "").replaceAll("</p>", "").replaceAll("<strong>", "").replaceAll("</strong>", "");
												%>
												<li class="something"
													data-question_id="<%=aq.getQuestion().getId()%>"><i
													class="js-remove fa fa-trash-o"> </i> | <%=aq.getQuestion().getId()%>
													| <%=questionText%></li>
												<%
													}
												%>
											</ul>
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
</body>
<!-- Mainly scripts -->
<jsp:include page="../inc/foot.jsp"></jsp:include>
<script type="text/javascript">
</script>