<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.cms.services.AssessmentEngineService"%>
<%@page import="com.viksitpro.core.dao.entities.ContextDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Context"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.core.dao.entities.QuestionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	Boolean is_new = true;
	String baseProdURL = (new URLServices()).getBaseUrl();
	DBUTILS dbutils = new DBUTILS();
	Question question = new Question();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0, cdnPath.length() - 1);
	int question_id = -3;
	if (request.getParameterMap().containsKey("question")) {
		question_id = Integer.parseInt(request.getParameter("question"));
		question = (new QuestionDAO()).findById(Integer.parseInt(request.getParameter("question")));
		is_new = false;
	}
	String type = "Create";
	if (question_id != -3) {
		type = "Edit";
	}
	AssessmentEngineService service = new AssessmentEngineService();
	String question_text = "", explanation = "", comprehensive_passage_text = "";
	int question_type = 1, difficulty_level = 1;
	List<HashMap<String, Object>> optionData = new ArrayList();
	List<HashMap<String, Object>> learningObjs = new ArrayList();
	if (type.equalsIgnoreCase("Edit")) {
		List<HashMap<String, Object>> data = service.getQustionInfo(question_id);

		optionData = service.getAllOptionsInfo(question_id);
		learningObjs = service.getallLearningObjectives(question_id);

		for (HashMap<String, Object> item : data) {
			question_text = (String) item.get("question_text");
			question_type = Integer.parseInt((String) item.get("question_type"));
			difficulty_level = (int) item.get("difficulty_level");
			explanation = (String) item.get("explanation");
			comprehensive_passage_text = (String) item.get("comprehensive_passage_text");
		}
	}
%>
<body class="top-navigation" id="question_edit"
	data-helper='This page is used to edit an individual question.'>
	<div id="wrapper">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
		<%
				String[] brd = { "Dashboard", "Questions" };
			%>
			<%=UIUtils.getPageHeader(type+" Question", brd)%>
			<%-- <div class="row wrapper border-bottom white-bg page-heading"
				style="padding-left: 30px; padding-bottom: 13px;">
				<div class="col-lg-6">
					<h2>
						<%
							if (is_new) {
						%>New Question
						<%
							} else {
						%>
						Edit Question
						<%
							}
						%>
					</h2>
					<ol class="breadcrumb"
						style="background-color: transparent !important;">
						<li><a href="/content/content_creator/dashboard.jsp">Home</a></li>
						<li><a href="/content/creator/questions.jsp">Question(s)</a></li>
						<li class="active"><strong> <%
 	if (is_new) {
 %>Create <%
 	} else {
 %>Edit <%
 	}
 %>Session
						</strong></li>
					</ol>
				</div>
			</div> --%>
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox no-margins">
							<div class="ibox-title">
								<h5><%=type%>
									a Question
								</h5>
							</div>
							<div class="ibox-content">
								<form class="form-horizontal" action="../question_engine"
									method="post" id='create-question-form'
									name='create-question-form'>

									<input type='hidden' name='question_id'
										value='<%=question_id%>' id="hidden_question_id" /> <input
										type='hidden' name='operation_mode' value='<%=type%>' />

									<div class="form-group">
                                <div class="col-lg-12">
										<div class="col-lg-6">
											<label>Question Text</label>
											<textarea name="question_text" id="question_text" rows="5"
												cols="80" placeholder="Question Text.."><%=question_text.replaceAll("<p>", "").replaceAll("</p>", "")%></textarea>

										</div>
									
										<div class="col-lg-6">
											<label>Explanation</label>
											<textarea name="question_explain" id="question_explain"
												rows="3" cols="80" placeholder="Question Explaination.."><%=explanation.replaceAll("<p>", "").replaceAll("</p>", "")%></textarea>
										</div>
										</div>
										<div class="col-lg-6">
											<label class="control-label">Type</label> <select
												class="form-control m-b" id='question_type'
												name="question_type">
												<option value="1" <%=question_type == 1 ? "selected" : ""%>>Single
													Choice</option>
												<option value="2" <%=question_type == 2 ? "selected" : ""%>>Multiple
													Choice</option>
												<option value="3" <%=question_type == 3 ? "selected" : ""%>>Single
													Choice with Passage</option>
												<option value="4" <%=question_type == 4 ? "selected" : ""%>>Multiple
													Choice with Passage</option>
											</select>
										</div>


										<div class="col-lg-6">
											<label class="control-label">Difficulty Level</label> <select
												class="form-control m-b" name="question_diffculty">
												<option value="1"
													<%=difficulty_level == 1 ? "selected" : ""%>>1</option>
												<option value="2"
													<%=difficulty_level == 2 ? "selected" : ""%>>2</option>
												<option value="3"
													<%=difficulty_level == 3 ? "selected" : ""%>>3</option>
												<option value="4"
													<%=difficulty_level == 4 ? "selected" : ""%>>4</option>
												<option value="5"
													<%=difficulty_level == 5 ? "selected" : ""%>>5</option>
											</select>
										</div>
										<br>
										<%
											if (question_type == 1 || question_type == 2) {
										%>
										<div class="hidden-holder col-lg-12 "
											id='question_passage_holder'>
											<%
												} else {
											%>
											<div class="hidden-holder col-lg-12 "
												id='question_passage_holder'>
												<%
													}
												%>
												<label>Passage</label>
												<textarea name="question_passage" id="question_passage"
													rows="3" cols="80" placeholder="Question Passage.."><%=comprehensive_passage_text.replaceAll("<p>", "").replaceAll("</p>", "")%></textarea>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-12">
												<div class="ibox">
													<div class="ibox-title">
														<h5>Skill Filter</h5>
														<div class="ibox-tools">
															<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
															</a>
														</div>
													</div>
													<div class="ibox-content">
														<div class="form-group">
															<label class="font-normal">Select context skill</label> <select
																id="context_skill_question"
																data-placeholder="Choose a Context Skill..." class=""
																tabindex="-1">
																<option value="">Select</option>
															</select>
														</div>
														<div class="form-group">
															<label class="font-normal">Select module level
																skill</label> <select id="module_skill_question"
																data-placeholder="Choose a module level Skill..."
																class="" tabindex="-1">
																<option value="">Select</option>
															</select>
														</div>
														<div class="form-group">
															<label class="font-normal">Select session level
																skill</label> <select id="session_skill_question"
																data-placeholder="Choose a session level Skill..."
																class="" tabindex="-1">
																<option value="">Select</option>
															</select>
														</div>
														<div class="form-group">
															<label class="font-normal">Select learning
																objectives</label> <select id="learn_obj_question"
																multiple="multiple"
																data-placeholder="Choose Learning Objectives..."
																class="" tabindex="-1">
																<option value="">Select</option>
															</select>
														</div>
													</div>
												</div>

												<div class="col-lg-12 m-t-sm">
													<button class="btn btn-default pull-left" id="add_options"
														type="button">
														<i class="fa fa-plus-circle"></i> Add Options
													</button>
												</div>

												<div id="question_options_holder" class="col-lg-12 m-t-sm">

													<%
														if (type.equalsIgnoreCase("Create")) {
													%>
													<div class="col-lg-6">
														<label>option 1</label>
														<div class="input-group m-b">
															<textarea name="option_0" id="option_0" rows="3"
																cols="80" placeholder="option 1.."></textarea>
															<span class="input-group-addon"> <input
																type="checkbox" data-optnum='0'
																class='option-correct-holder' name='option_correct_0'>
															</span>
														</div>
													</div>

													<div class="col-lg-6">
														<label>option 2</label>
														<div class="input-group m-b">
															<textarea name="option_1" id="option_1" rows="3"
																cols="80" placeholder="option 2.."></textarea>
															<span class="input-group-addon"> <input
																type="checkbox" data-optnum='1'
																class='option-correct-holder' name='option_correct_1'>
															</span>
														</div>
													</div>
													<%
														} else if (type.equalsIgnoreCase("Edit")) {
															int i = 0;
															for (HashMap<String, Object> item : optionData) {
													%>

													<div class="col-lg-6">
														<label>option <%=i + 1%></label>
														<div class="input-group m-b">
															<textarea name="option_<%=i%>" id="option_<%=i%>"
																rows="3" cols="80" placeholder="option 2.."><%=item.get("text")%>
												</textarea>
															<span class="input-group-addon"> <input
																type="checkbox" data-optnum='<%=i%>'
																class='option-correct-holder'
																name='option_correct_<%=i%>'
																<%=(int) item.get("marking_scheme") == 1 ? "checked" : ""%>>
															</span>
														</div>
													</div>


													<%
														i++;
															}
														}
													%>
												</div>
											</div>
										</div>
										<hr>
										<div class="form-group">
											<button type="button" class="btn btn-primary pull-right"
												id='question-create-submit'>Save changes</button>
										</div>
									</div>
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