<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.viksitpro.core.dao.entities.SkillObjective"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.Module"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentOption"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.dao.entities.QuestionDAO"%>
<%
	Integer questionId = null;
	if (request.getParameter("question_id") != null) {
		questionId = Integer.parseInt(request.getParameter("question_id"));
		;
	}

	int courseId = Integer.parseInt(request.getParameter("course_id"));
	Course course = new CourseDAO().findById(courseId);
	DBUTILS util = new DBUTILS();

	String questionText = "";
	Integer difficulty_level = null;
	Integer duration_in_sec = 60;
	String explanation = "";
	;
	String comprehensive_passage_text = "";
	String questionType = "";
	HashMap<Integer, HashMap<String, String>> optionDetails = new HashMap();
	ArrayList<Integer> questionInLO = new ArrayList();
	if (questionId != null) {
		List<HashMap<String, Object>> questionData = util
				.executeQuery("select * from question where id=" + questionId);
		if (questionData.size() > 0) {
			questionText = questionData.get(0).get("question_text").toString();
			questionType = questionData.get(0).get("question_type").toString();
			difficulty_level = (int) questionData.get(0).get("difficulty_level");
			duration_in_sec = (int) questionData.get(0).get("duration_in_sec");
			explanation = questionData.get(0).get("explanation").toString();
			;
			comprehensive_passage_text = questionData.get(0).get("comprehensive_passage_text").toString();
			;
		}

		String getOptions = "select * from assessment_option where question_id=" + questionId;

		List<HashMap<String, Object>> optionData = util.executeQuery(getOptions);
		if (optionData.size() > 0) {
			for (HashMap<String, Object> option : optionData) {
				int optionId = (int) option.get("id");
				String optionText = option.get("text").toString();
				int markingSheme = (int) option.get("marking_scheme");
				HashMap<String, String> op = new HashMap();
				op.put("optionText", optionText);
				op.put("markingSheme", markingSheme + "");
				optionDetails.put(optionId, op);
			}
		}

		String questionLOMapping = "select DISTINCT learning_objectiveid from question_skill_objective where questionid="
				+ questionId;
		List<HashMap<String, Object>> loData = util.executeQuery(questionLOMapping);
		if (loData.size() > 0) {
			for (HashMap<String, Object> lo : loData) {
				int loId = (int) lo.get("learning_objectiveid");
				questionInLO.add(loId);
			}
		}
	}
%>
<div
	style="width: 605px; margin-left: 33%; z-index: 54; position: absolute; margin-top: 31px; display: none;"
	id="que_error">
	<div class="alert alert-danger alert-dismissible fade show"
		role="alert">
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h3 class="alert-heading">Question creation failed!</h3>
		<hr>
		<div id="que_error_list"></div>
	</div>
</div>

<input id="questionID" value="<%=questionId%>" type="hidden">
<div class="modal-dialog edit-question-modal-dialog" role="document">
	<div class="modal-content custom-edit-question-modal-content">
		<div class="modal-header custom-edit-question-modal-header">
			<h5 class="modal-title custom-edit-question-modal-title"
				id="editAddQuestionModalLabel">Edit Question</h5>
			<button type="button" class="close" data-dismiss="modal"
				aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
		</div>
		<div class="modal-body custom-no-padding">
			<div class="container-fluid bd-example-row pl-0">
				<div class='row' style="margin-top: 10px;">
					<div class='col-md-3 justify-content-md-center'>
						<img src='/assets/images/viewport.png' style="width: 360px;">
						<div class='que_mobile_prev'>

							<div class='row'>

								<div class='col-md-7 col-md-auto que_simulator_heading'>
									<i class="fa fa-check-square-o" aria-hidden="true"
										style="color: #2db9f8; font-size: 20px;"></i>
									<p class="answered_question">14 OF 20 ANSWERED</p>
								</div>
								<div class='col-md-4 col-md-auto'
									style="padding-right: 0px !important; padding-left: 21px !important; flex: 0px;">
									<p>
										<i class="fa fa-clock-o" aria-hidden="true"></i> 10:06
									</p>
								</div>

								<div class='col-md-1 col-md-auto' id="explanation_preview"
									title="Explanation Preview">
									<i class="fa fa-info-circle" aria-hidden="true"
										style="margin-left: -22px; font-size: 20px;" id="e_prev"></i>
									<i class="fa fa-question-circle" aria-hidden="true"
										style="margin-left: -22px; font-size: 20px; display: none"
										id="q_prev"></i>
								</div>

							</div>

							<div id='question_container'>
								<div class='row'>
									<div class='col-md-8 preview_heading'>QUESTION 7 OF 20</div>
								</div>
								<div class='row'>
									<div class='col-md-12' id='edit_question_text'>
										<%=questionText%>
									</div>
								</div>

								<div class="row">
									<div class="col-md-12" id="edit_passage_text">

										<%
											if (!comprehensive_passage_text.equalsIgnoreCase("null")) {
										%>
										<%=comprehensive_passage_text%>
										<%
											}
										%>
									</div>
								</div>
								<div id="option_prev_container">
									<%
										if (optionDetails != null && optionDetails.size() > 0) {
											int optionCount = optionDetails.size();
											for (int optionId : optionDetails.keySet()) {
												HashMap<String, String> details = optionDetails.get(optionId);
												boolean scheme = false;
												if (details.get("markingSheme").equalsIgnoreCase("1")) {
													scheme = true;
												}
									%>
									<div class='row edit_question_option'
										id='prev_option_<%=optionCount%>'
										data-option_id='<%=optionId%>'>
										<div class='col-md-12 edit_option_text'
											<%-- id='edit_option_text_<%=optionCount%>' --%>
										data-is_correct=<%=scheme%>>
											<%=details.get("optionText")%>
										</div>
									</div>
									<%
										optionCount--;
											}
										}
									%>
								</div>

							</div>

							<div id='question_explanation_container'>
								<div class='row'>
									<div class='col-md-8 preview_heading'>EXPLANATION</div>
								</div>
								<div class="row">
									<div class='col-md-12' id="edit_explanation_text">
										<%
											if (explanation != null) {
										%>
										<%=explanation%>
										<%
											}
										%>
									</div>
								</div>
							</div>

							<div class='row que_prev_next_row'>
								<div class='col-md-3 col-md-auto' style="padding-right: 0px;">
									<p>
										<i class="fa fa-chevron-left" aria-hidden="true"></i> PREV
									</p>
								</div>
								<div class='col-md-6 col-md-auto' style="text-align: center;">
									<p>
										<i class="fa fa-th-list" aria-hidden="true"></i> VIEW ALL
									</p>
								</div>
								<div class='col-md-3 col-md-auto'
									style="padding-right: 15px; padding-left: 0px;">
									<p style="float: right;">
										NEXT <i class="fa fa-chevron-right" aria-hidden="true"></i>
									</p>
								</div>

							</div>
						</div>

					</div>
					<div class='col-md-9 question_form'>
						<div class="row m-0">
							<div class="col-md-12">
								<div class="card">
									<ul class="nav nav-tabs" role="tablist">
										<li role="presentation" class="active"><a href="#home"
											aria-controls="home" role="tab" data-toggle="tab"
											style='padding: 15px;'>Question</a></li>
										<li role="presentation"><a href="#profile"
											aria-controls="profile" role="tab" data-toggle="tab"
											style='padding: 15px;'>Learning Objective</a></li>
									</ul>
									
									<!-- Tab panes -->
									<div class="tab-content">
										<button type="button" class="btn-grey btn-sm submit_question"
											id='submit_question'>Save Changes</button>
										<div role="tabpanel" class="tab-pane active custom-scroll-holder" id="home">
											<div id="question_details_form">
												<div class='row my-3'>
													<div class='col-md-2 col-md-auto'>
														<label>Difficulty Level</label> <select
															id='difficultyLevel' class="custom-select d-block "
															required>
															<option value="1"
																<%if (difficulty_level != null && difficulty_level == 1) {%>
																selected <%}%>>Rookie</option>
															<option value="2"
																<%if (difficulty_level != null && difficulty_level == 2) {%>
																selected <%}%>>Apprentice</option>
															<option value="3"
																<%if (difficulty_level != null && difficulty_level == 3) {%>
																selected <%}%>>Master</option>
															<option value="4"
																<%if (difficulty_level != null && difficulty_level == 4) {%>
																selected <%}%>>Wizard</option>
														</select>
													</div>
													<div class='col-md-4 col-md-auto'>
														<label>Type</label> <select id='questionType'
															class="custom-select d-block" required>
															<option value="1"
																<%if (questionType.equalsIgnoreCase("1")) {%> selected
																<%}%>>Single Correct Option</option>
															<option value="2"
																<%if (questionType.equalsIgnoreCase("2")) {%> selected
																<%}%>>Multiple Correct Option</option>
														</select>
													</div>
													<div class='col-md-2 col-md-auto'>
														<label>Duration (in secs)</label> <input type="number"
															style="width: 100%" class="form-control  "
															id="questionDuration" min="0" max="600"
															value="<%if (duration_in_sec != null) {%><%=duration_in_sec%><%}%>">
													</div>
													<div class="col-md-2 col-md-auto">
														<button type="button" class="btn-grey btn-sm"
															id="add_option" style="margin-top: 19px;">Add
															Option</button>
													</div>
												</div>

												<div class='row my-3'>

													<div class='col-md-10 col-md-auto'>
														<label><b>Question</b></label>
														<div id='questionText'></div>
													</div>
												</div>
												<div class='row my-3'>

													<div class='col-md-10 col-md-auto'>
														<label><b>Comprehensive Passage</b></label>
														<div id="passageText"></div>
													</div>
												</div>
												<div id="option_container_form">
													<%
														if (optionDetails != null && optionDetails.size() > 0) {
															int optionCount = optionDetails.size();
															for (int optionId : optionDetails.keySet()) {
																HashMap<String, String> details = optionDetails.get(optionId);
																String scheme = "incorrect_option";
																if (details.get("markingSheme").equalsIgnoreCase("1")) {
																	scheme = "correct_option";
																}
													%>

													<div class='row my-3 option_in_form'
														id="option_form_<%=optionCount%>"
														data-option_id="<%=optionId%>">
														<div class='col-md-10 col-md-auto'>
															<label><b>Option</b></label>
															<div class="option_text"
																id="option_ckeditor_<%=optionCount%>"></div>
														</div>
														<div class='col-md-1 col-md-auto m-auto'>
																<button type="button"
																	class="btn option_marking_scheme <%=scheme%>">Correct</button>
														</div>
														<div class='col-md-1 col-md-auto m-auto'>
															<a class="btn btn-icon btn-sm remove_option"> <i
																class="fa fa-trash custom-btn-icon" aria-hidden="true"></i></a>
														</div>

													</div>

													<%
														optionCount--;
															}
														}
													%>
												</div>


											</div>
											<div id="question_explanation_details_form">
												<div class='row my-3'>

													<div class='col-md-12 col-md-auto'>
														<label><b>Explanation</b></label>
														<div id="explanationText"></div>
													</div>
												</div>
											</div>
										</div>
										<div role="tabpanel" class="tab-pane" id="profile">
											<div id="question_lo_details_form">
												<div class='row my-3'>

													<div class="col-md-12 col-md-auto">

														<label> <b>Learning Objectives</b></label> <select
															class="form-control col-sm-12" multiple
															style="height: 500px" id="question_lo_selector">
															<%
																if (course.getModules() != null) {
																	for (Module module : course.getModules()) {
																		if (module.getCmsessions() != null) {

																			for (Cmsession cms : module.getCmsessions()) {

																				boolean validCMS = false;
																				ArrayList<SkillObjective> loInCMS = new ArrayList();
																				ArrayList<Integer> uniquechecker = new ArrayList();
																				if (cms.getLessons() != null) {

																					for (Lesson lesson : cms.getLessons()) {
																						if (lesson.getType() != null && !lesson.getType().equalsIgnoreCase("ASSESSMENT")
																								&& lesson.getSkillObjectives() != null
																								&& lesson.getSkillObjectives().size() > 0) {
																							validCMS = true;
																							for (SkillObjective lo : lesson.getSkillObjectives()) {
																								if (!uniquechecker.contains(lo.getId())) {
																									loInCMS.add(lo);
																									uniquechecker.add(lo.getId());
																								}

																							}
																						}
																					}
																				}

																				if (validCMS) {
															%>
															<optgroup label="<%=cms.getTitle()%>">
																<%
																	for (SkillObjective lo : loInCMS) {
																%>
																<option value="<%=lo.getId()%>"
																	<%if (questionInLO.contains(lo.getId())) {%> selected
																	<%}%>><%=lo.getName()%></option>
																<%
																	}
																%>
															</optgroup>
															<%
																}
																			}

																		}
																	}
																}
															%>
														</select>


													</div>
												</div>
											</div>

										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>