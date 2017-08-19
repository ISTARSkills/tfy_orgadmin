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
.pagination .bootpag > li{
display:inline !important;
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
<body class="top-navigation" id="assessment_edit"
	data-helper='This page is used to edit an individual assessment'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<div id="page-wrapper" class="gray-bg">
				<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<%
					String[] brd = { "Dashboard", "Assessments" };
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
									<input type='hidden' name='isNew'
										value='<%=is_new.toString()%>' /> 
										<input type='hidden' name='isNew'
										value='<%=is_new.toString()%>' /> 
										<input type='hidden'
										name='cmsID' value='<%=assessment.getId()%>' /> <input
										type='hidden' name='baseProdURL' value='<%=baseProdURL%>' />
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
										<fieldset class='fieldset-border-margin'>
											<div class="row">
												<div class="col-lg-8">
													<div class="form-group">
														<label>Assessment Title</label> <input
															class="form-control" id="assessment_name_idd" type="text"
															name="assessment_name" style="width: 30vw !important"
															<%if (!is_new) {%>
															value='<%=assessment.getAssessmenttitle()%>' <%}%>>
													</div>
													<div class="form-group">
														<label>Assessment Description</label>
														<textarea class="form-control required"
															name="assessment_desc" rows="3" id="assessment_desc_idd"> <%if (!is_new) {%><%=assessment.getDescription()%> <%}%> </textarea>
													</div>
													<div class="form-group">
														<label>Assessment Retryable </label> <input
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
												<div class="col-lg-3">
													<div class="form-group">
														<label>Select Assessment Type</label> <select
															class="form-control" name="assessment_type"
															id='assessment_type_idd' style="max-width: 200px;">
															<option value="STATIC"
																<%if (!is_new) {
				if (assessment.getAssessmentType().equalsIgnoreCase("STATIC")) {%>
																selected <%}
			}%>>Static Assessment</option>
															<%-- <option value="ADAPTIVE"
																<%if (!is_new) {
				if (assessment.getAssessmentType().equalsIgnoreCase("ADAPTIVE")) {%>
																selected <%}
			}%>>Adaptive Assessment</option> --%>
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
													<%-- <div class="form-group">
														<label>Choose course</label> <select id="course"
															class="form-control"
															data-placeholder="Choose a Course..."
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
													</div> --%>
												</div>
											</div>
										</fieldset>
										<h1>Questions</h1>
										<fieldset class='fieldset-border-margin'>
											<h3>Select Questions for this assessment</h3>
											<p>First Select the parent skill to filter learning
												objectives.</p>
												<div class="row">
												<div class="col-lg-6" >
											<div class="form-group">
												<label class="font-normal">Select context skill</label> <select
													id="context_skill"
													data-placeholder="Choose a Context Skill..." class=""
													tabindex="-1">
													<option value="">Select</option>
												</select>
											</div>
											</div>
											<div class="col-lg-6" >
											<div class="form-group">
												<label class="font-normal">Select Skill</label> <select
													multiple id="skills_data"
													data-placeholder="Choose a Skill..." class=""
													tabindex="-1">
													<option value="">Select</option>
												</select>
											</div>
											</div></div>
											<div class="row " id="table_holder_div" style=' max-height: 42vh; overflow-y: auto;'>
											<!-- table start -->
											

											<table class="table table-bordered" id='assessment_list_table' data-url='../assessment_list'>
												<thead>
													<tr>
														<th data-visisble='true'>#</th>
														<th data-visisble='true'>Question Text</th>
														<th data-visisble='true'>Question Type</th>
														<th data-visisble='true'>Difficulty Level</th>
														<th data-visisble='true'>action</th>
													</tr>
												</thead>
												<tbody id="assessment_data">

												</tbody>
											</table>
											 <div id="page-selection" style="text-align: center"></div>
											 </div>
											 
											<!-- table end -->
										</fieldset>
										<h1>Review Questions</h1>
										<fieldset class='fieldset-border-margin'>
											<div class="form-group">
												<h3>Questions in this assessment</h3>
												<ul class="list-unstyled file-list" id="editable" style="    max-height: 54vh; overflow-y: scroll;">
													<%
														Set<AssessmentQuestion> aqs = new HashSet<AssessmentQuestion>();
														aqs = assessment.getAssessmentQuestions();
														for (AssessmentQuestion aq : aqs) {
															String questionText = aq.getQuestion().getQuestionText().replaceAll("<p>", "").replaceAll("</p>", "")
																	.replaceAll("<strong>", "").replaceAll("</strong>", "");
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
		</div></div>
</body>
<!-- Mainly scripts -->
<jsp:include page="../inc/foot.jsp"></jsp:include>
<script type="text/javascript">
</script>