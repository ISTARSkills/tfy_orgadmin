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
	<div id="wrapper" class='customcss_overflowy'>
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<%
				String[] brd = {"Dashboard", "Questions"};
			%>
			<%=UIUtils.getPageHeader(type + " Question", brd)%>

			<div
				class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
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
										<label class="col-sm-2">Question Text</label>
										<div class="col-sm-10">
											<textarea name="question_text" id="question_text" rows="1"
												cols="80" placeholder="Question Text.."><%=question_text.replaceAll("<p>", "").replaceAll("</p>", "")%></textarea>
										</div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<label class="col-sm-2">Explanation</label>
										<div class="col-sm-10">
											<textarea name="question_explain" id="question_explain"
												rows="2" cols="80" placeholder="Question Explaination.."><%=explanation.replaceAll("<p>", "").replaceAll("</p>", "")%></textarea>
										</div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<label class="col-sm-2">Type</label>
										<div class="col-sm-10">
											<select class="form-control m-b" id='question_type'
												name="question_type" style="width: auto;">
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
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<label class="col-sm-2">Difficulty Level</label>
										<div class="col-sm-10">
											<select class="form-control m-b" name="question_diffculty"
												style="width: auto;">
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
									</div>
									<div class="hr-line-dashed"></div>
									<%
										String questionPassageStyle = "";
										if (question_type == 1 || question_type == 2) {
											questionPassageStyle = "style='display:none'";
										}
									%>
									<div class="form-group" id='question_passage_holder'
										<%=questionPassageStyle%>>
										<label class="col-sm-2">Passage</label>
										<div class="col-sm-10">
											<textarea name="question_passage" id="question_passage"
												rows="3" cols="80" placeholder="Question Passage.."><%=comprehensive_passage_text.replaceAll("<p>", "").replaceAll("</p>", "")%></textarea>
										</div>
									</div>
									<div class="hr-line-dashed" <%=questionPassageStyle%>></div>
									<div class="form-group">
										<label class="col-sm-2">Select learning objectives</label>
										<div class="col-sm-10">
											<select id="learn_obj_question" multiple="multiple"
												data-placeholder="Choose Learning Objectives..." class=""
												tabindex="-1" style="width: auto;">
												<option value="">Select</option>
											</select>
										</div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<label class="col-sm-2">Options</label>
										<div class="col-sm-10" id="question_options_holder">
											<%
												if (type.equalsIgnoreCase("Edit")) {
													int i = 0;
													for (HashMap<String, Object> item : optionData) {
											%>
											<div class="input-group m-b">
												<span class="input-group-addon">option <%=i + 1%></span> <input
													type="text" name="option_<%=i%>" id="option_<%=i%>"
													placeholder="Option <%=i + 1%>.." class="form-control"
													value="<%=item.get("text")%>"> <span
													class="input-group-addon"> <input type="checkbox"
													data-optnum='<%=i%>' class='option-correct-holder'
													name='option_correct_<%=i%>'
													<%=(int) item.get("marking_scheme") == 1 ? "checked" : ""%>>
												</span>
												<div class="input-group-btn">
													<button tabindex="-1" class="btn btn-white" type="button">Delete</button>
												</div>
											</div>
											<%
												i++;
													}
												}
											%>
											<button class="btn btn-default pull-left" id="add_options"
												type="button">
												<i class="fa fa-plus-circle"></i> Add Options
											</button>
										</div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<div class="col-sm-4 col-sm-offset-2">
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