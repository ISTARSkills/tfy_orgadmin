<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.Collections"%>
<%@page import="com.viksitpro.core.dao.entities.SkillObjective"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.Module"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<link rel="stylesheet" type="text/css"
	href="//fonts.googleapis.com/css?family=Lato" />
<style>
.champa {
	background-color: antiquewhite !important;
}
</style>
<body id="assesssment_edit_page">
	<%
		String basePath = AppProperies.getProperty("cdn_path");
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());
		if (cp == null) {
			flag = true;
			request.setAttribute("msg", "User Does Not Have Permission To Access");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
		request.setAttribute("cp", cp);
		Course course = new CourseDAO().findById(Integer.parseInt(request.getParameter("course_id")));
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<div id="assess_error" style="width: 523px;  margin-left: 33%; display:none; position: absolute; margin-top: 70px; z-index: 12;">
<div class="alert alert-danger alert-dismissible fade show" role="alert" >
  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
    <span aria-hidden="true">&times;</span>
  </button>
  <h3 class="alert-heading">Assessment update failed!</h3> 
  <hr>
  <div id="error_list"></div> 
</div>
</div>
	<input style='display: hidden' id='lessonId'
		value='<%=request.getParameter("lesson_id")%>'>
	<input style='display: hidden' id='courseId'
		value='<%=request.getParameter("course_id")%>'>
	<input style='display: hidden' id='assessmentID'>
	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row">
				<h1 id='assessmentPageHeading'></h1>
			</div>
		</div>
		<div class="form-container" id="assessment_edit">
			<div class="row">
				<div class="col-md-8">
					<form>
						<div class="form-group row">
							<label for="assessmentName" class="col-sm-2 col-form-label">
								Name</label>
							<div class="col-sm-10">
								<input type="text" id='assessmentName' class="form-control">
							</div>
						</div>
						<div class="form-group row">
							<label for="assessmentDesc" class="col-sm-2 col-form-label">Description</label>
							<div class="col-sm-10">
								<textarea class="form-control" rows="3" style="width: 100%"
									id='assessmentDesc'></textarea>
							</div>
						</div>
						<div class="form-group row">
							<label for="assessmentDurationInMinutes"
								class="col-sm-2 col-form-label">Duration (mins)</label>
							<div class="col-sm-10">
								<input type="number" id='assessmentDurationInMinutes'
									class="form-control">
							</div>
						</div>
						<div class="form-group row">
							<label for="assessmentRetryAble" class="col-sm-2 col-form-label">Retryable</label>
							<div class="col-sm-10 checkbox">
								<div class="checkbox">
									<label><input type="checkbox" 
										id="assessmentRetryAble"></label>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<div class="col-sm-2">
								<button class="btn btn-sm btn-primary " type="button"
									id='updateAssessmentDetails'>Update Detail</button>
							</div>
							<div class="col-sm-2">
								<button class="btn btn-sm btn-primary " type="button"
									id='add_new_question'>New Question</button>
							</div>
						</div>
					</form>

				</div>
				<div class="col-md-4">
					<div class="form-group row">
						<label for="session" class="col-sm-12 col-form-label"
							style="padding: 0px;"> Available questions can be
							filtered by sessions to add into assessment. </label>
					</div>
					<div class="form-group row">

						<select class="form-control col-sm-12 assessment_skill_selector"
							id="session_skill" multiple>
							<%
								if (course.getModules() != null) {
									for (Module module : course.getModules()) {
										boolean validModule = false;
										ArrayList<Cmsession> validCMS = new ArrayList();
										if (module.getCmsessions() != null) {

											for (Cmsession cms : module.getCmsessions()) {
												ArrayList<Integer> loInSession = new ArrayList();
												if (cms.getLessons() != null) {
													for (Lesson lesson : cms.getLessons()) {
														if (lesson.getType() != null && !lesson.getType().equalsIgnoreCase("ASSESSMENT")
																&& lesson.getSkillObjectives() != null
																&& lesson.getSkillObjectives().size() > 0) {
															for (SkillObjective lo : lesson.getSkillObjectives()) {
																if (!loInSession.contains(lo.getId())) {
																	loInSession.add(lo.getId());
																}
															}
														}
													}
												}

												if (loInSession.size() > 0) {
													validModule = true;
													validCMS.add(cms);

												}
											}

											if (validModule) {
							%>
							<optgroup label="<%=module.getModuleName()%>">
								<%
									for (Cmsession cms : validCMS) {
								%>
								<option value="<%=cms.getId()%>"><%=cms.getTitle()%></option>
								<%
									}
								%>
							</optgroup>
							<%
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
		<div class="container" style="margin-top: 20px;">
			<div class="row">
				<div class="col-md-6">
					<div class="panel panel-inverse" data-sortable-id="table-basic-6"
						style="margin-left: -15px;">
						<div class="panel-heading">
							<h4 class="panel-title">Questions in Assessment</h4>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-md-9">
									<div class="custom-search-input">
										<div class="input-group col-md-12">
											<input type="text" class="form-control input-lg"
												placeholder="Search... " id="search_assessment_question" />
											<span class="input-group-btn">
												<button class="btn btn-info btn-lg" type="button">
													<i class="glyphicon glyphicon-search"></i>
												</button>
											</span>
										</div>

									</div>
								</div>
								<div class="col-md-3">
									<div class="row"
										style="margin-top: 17px; margin-left: -43px; margin-right: 0px;">
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_1' id="rookie"
												style="border: 1px solid #000307;"> <b>R</b>
											</a>
										</div>
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_2' id="apprentice"
												style="border: 1px solid #000307;"> <b>A </b>
											</a>
										</div>
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_3' id="master"
												style="border: 1px solid #000307;"> <b>M</b>
											</a>
										</div>
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_4' id="wizard"
												style="border: 1px solid #000307;"> <b>W</b>
											</a>
										</div>
									</div>
								</div>
							</div>



							<div class="table-responsive">
								<table class="table" id="assessment_que_table">
									<thead>
										<tr>
											<th>Id</th>
											<th style="max-width: 30%">Question</th>
											<th style="max-width: 30%">Type</th>
											<th style="max-width: 30%">Session Skills</th>
											<th style="max-width: 30%"></th>
										</tr>
									</thead>
									<tbody id="assessment_que_table_body">
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="panel panel-inverse" style="margin-right: -15px;">
						<div class="panel-heading">
							<h4 class="panel-title">Questions Available</h4>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-md-9">

									<div class="custom-search-input">
										<div class="input-group col-md-12">
											<input type="text" class="form-control input-lg"
												placeholder="Search... " id="search_available_question" />
											<span class="input-group-btn">
												<button class="btn btn-info btn-lg" type="button">
													<i class="glyphicon glyphicon-search"></i>
												</button>
											</span>
										</div>
									</div>
								</div>
								<div class="col-md-3">
									<div class="row"
										style="margin-top: 17px; margin-left: -43px; margin-right: 0px;">
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_1' id="rookie"
												style="border: 1px solid #000307;"> <b>R</b>
											</a>
										</div>
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_2' id="apprentice"
												style="border: 1px solid #000307;"> <b>A </b>
											</a>
										</div>
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_3' id="master"
												style="border: 1px solid #000307;"> <b>M</b>
											</a>
										</div>
										<div class="col-md-3">
											<a class='btn btn-icon btn-sm level_4' id="wizard"
												style="border: 1px solid #000307;"> <b>W</b>
											</a>
										</div>
									</div>
								</div>
							</div>

							<div class="table-responsive">
								<table class="table" id="available_question_table">
									<thead>
										<tr>
											<th></th>
											<th>Id</th>
											<th>Question</th>
											<th>Type</th>
											<th style='width: 280px;'>Session Skills</th>
											<th style='display: none'></th>
										</tr>
									</thead>
									<tbody id="available_question_table_body">
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>

				<!-- end panel -->
			</div>
		</div>

	</div>
	<div id="editQuestionModal" class="modal fade" role="dialog"></div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script src="<%=basePath%>assets/js/plugins/ckeditor/ckeditor.js"></script>
	<script type="text/javascript"
		src="<%=basePath%>assets/js/edit_question.js"></script>
	<script>
		$(document).ready(function() {

			window.lessonID = $('#lessonId').val();
			window.courseID = $('#courseId').val();
			fillAssessmentEditFormFields();

		});

		function fillAvailableQuestionsTable() {
			$
					.get(
							'../tfy_content_rest/question/availableQuestion/'
									+ window.assessmentID + '/course/'
									+ window.courseID)
					.done(
							function(questionsObject) {
								if (questionsObject.success = true
										&& questionsObject.questions != null
										&& questionsObject.questions.length > 0) {
									var tableBody = '';
									var data = questionsObject.questions;
									for ( var i in data) {
										var questionId = data[i].id;
										var questionText = data[i].text;
										var type = data[i].type;
										var difficultyLevel = data[i].difficulty_level;
										var sesionNames = data[i].sesionNames;
										var sessionIds = data[i].sessionIds;
										var tableRow = "<tr class='"+difficultyLevel+" available_question' id='available_question_"+questionId+"'><td> \
							    <a class='btn btn-danger btn-icon btn-sm add_question_to_assessment'><i class='fa fa-arrow-circle-left' aria-hidden='true' style='color:white;'></i></a></td> \
							    <td>"
												+ questionId
												+ "</td> \
							    <td>"
												+ questionText
												+ "</td> \
							    <td>"
												+ type
												+ "</td> \
							    <td>"
												+ sesionNames
												+ "</td> \
							    <td style='display:none'>"
												+ sessionIds
												+ "</td> \
							    </tr>";
										tableBody += tableRow;
									}
									$('#available_question_table_body').empty();
									$('#available_question_table_body').append(
											tableBody);

									enableSearchInAvailableQuestionTable();
									initAddingQuestionToAssessment();
								}
							});
		}

		function initAddingQuestionToAssessment() {
			$('.add_question_to_assessment')
					.unbind()
					.on(
							'click',
							function(e) {
								//alert('remove_question clicked -');
								var newRow = $(this).parents(
										'.available_question');
								var questionRowId = $(this).parents(
										'.available_question').attr('id');
								var questionId = questionRowId.replace(
										'available_question_', '');
								$
										.get(
												'../tfy_content_rest/assessment/add_question/'
														+ questionId
														+ '/assessment/'
														+ window.assessmentID)
										.done(
												function(responseObject) {
													if (responseObject.success = true) {

														var difficultyLevel = newRow
																.removeClass(
																		'available_question')
																.attr('class');
														var questionText = newRow
																.find(
																		"td:eq(2)")
																.html();
														var type = newRow.find(
																"td:eq(3)")
																.html();
														var skills = newRow
																.find(
																		"td:eq(4)")
																.html();
														var tableRow = "<tr class='"+difficultyLevel+" question' id='question_"+questionId+"'> \
					     <td style='max-width:10px'>"
																+ questionId
																+ "</td> \
					     <td style='max-width:200px'>"
																+ questionText
																+ "</td> \
					     <td style='max-width:300px'>"
																+ type
																+ "</td> \
					     <td>"
																+ skills
																+ "</td> \
					     <td><a class='btn btn-danger btn-icon btn-sm remove_question'><i class='fa fa-trash' aria-hidden='true' style='color:white;'></i></a></td></tr>";
														$(
																'#assessment_que_table_body')
																.prepend(
																		tableRow);
														newRow.remove();
														initEditDeleteQuestion();
													} else {
														alert('Error in adding question to assessment');
													}
												});
								e.stopPropagation();
							});
		}
		function enableSearchInAvailableQuestionTable() {

			$("#search_available_question")
					.keyup(
							function() {
								var searchValue = this.value;

								var myOptions = [];
								$('#session_skill option:selected').each(
										function() {
											myOptions.push(',' + this.value
													+ ',');
										});

								if (myOptions.length != 0) {

									$("#available_question_table")
											.find("tr")
											.each(
													function(index) {
														var row = $(this);
														if (index === 0)
															return;
														var sessionIdInRow = $(
																this).find(
																"td:last")
																.text()
																.toLowerCase();
														var sessionIdMatched = false;
														$
																.each(
																		myOptions,
																		function(
																				index,
																				value) {

																			if (sessionIdInRow
																					.indexOf(value) !== -1) {
																				sessionIdMatched = true;
																				return;
																			}
																		});

														var rowText = $(this)
																.text()
																.toLowerCase();
														var textMatched = false;
														if (rowText
																.indexOf(searchValue
																		.toLowerCase()) !== -1) {
															textMatched = true;
														}
														if (sessionIdMatched
																&& textMatched) {
															row.toggle(true);
														} else {
															row.toggle(false);

														}

													});
								} else {

									$("#available_question_table")
											.find("tr")
											.each(
													function(index) {
														if (index === 0)
															return;
														var rowText = $(this)
																.text()
																.toLowerCase();
														$(this)
																.toggle(
																		rowText
																				.indexOf(searchValue
																						.toLowerCase()) !== -1);
													});
								}

							});

			$('#session_skill')
					.unbind()
					.on(
							'change',
							function() {

								var myOptions = [];
								$('#session_skill option:selected').each(
										function() {
											myOptions.push(',' + this.value
													+ ',');
										});

								if (myOptions.length != 0) {
									$("#available_question_table")
											.find("tr")
											.each(
													function(index) {
														var row = $(this);
														if (index === 0)
															return;
														var rowText = $(this)
																.find("td:last")
																.text()
																.toLowerCase();
														var showRow = false;
														$
																.each(
																		myOptions,
																		function(
																				index,
																				value) {

																			if (rowText
																					.indexOf(value) !== -1) {
																				showRow = true;
																				return;
																			}
																		});

														if (showRow) {
															row.toggle(true);
														} else {
															row.toggle(false);

														}

													});
								} else {
									$("#available_question_table").find("tr")
											.each(function(index) {
												if (index === 0)
													return;
												var row = $(this);
												row.toggle(true);
											});
								}

							});
		}
		function fillExistingQuestionsInAssessment() {
			$
					.get(
							'../tfy_content_rest/question/readAll/'
									+ window.assessmentID + '/course/'
									+ window.courseID)
					.done(
							function(questionsObject) {
								//console.log(questionsObject);
								if (questionsObject.success = true
										&& questionsObject.questionData.questions != null
										&& questionsObject.questionData.questions.length > 0) {
									var tableBody = '';
									var data = questionsObject.questionData.questions;
									for ( var i in data) {
										var questionId = data[i].id;
										var questionText = data[i].text;
										var type = data[i].type;
										var difficultyLevel = data[i].difficulty_level;
										var skills = data[i].skills;
										if(skills==null)
										{
											skills='';
										}
										var skillIds = data[i].skillIds;
										if(skillIds==null)
										{
											skillIds='';
										}
										var tableRow = "<tr class='"+difficultyLevel+" question' id='question_"+questionId+"'> \
							     <td style='max-width:40px'>"
												+ questionId
												+ "</td> \
							     <td  style='max-width:200px;word-wrap: break-word;'>"
												+ questionText
												+ "</td> \
							     <td  style='max-width:20px;    word-wrap: break-word;'>"
												+ type
												+ "</td> \
							     <td  style='max-width:200px;    word-wrap: break-word;'>"
												+ skills
												+ "</td> \
							     <td style='display:none'>"
												+ skillIds
												+ "</td> \
							     <td><a class='btn btn-danger btn-icon btn-sm remove_question'><i class='fa fa-trash' aria-hidden='true' style='color:white;'></i></a></td></tr>";
										tableBody += tableRow;
									}

									//console.log(tableBody);
									$('#assessment_que_table_body').empty();
									$('#assessment_que_table_body').append(
											tableBody);

									initEditDeleteQuestion();
									initSearchQuestionInAssessment();

								} else {
									//alert(false);
								}
							});
		}

		function initSearchQuestionInAssessment() {
			$("#search_assessment_question").keyup(
					function() {
						var searchValue = this.value;

						$("#assessment_que_table").find("tr").each(
								function(index) {
									if (index === 0)
										return;
									var rowText = $(this).text().toLowerCase();
									$(this).toggle(
											rowText.indexOf(searchValue
													.toLowerCase()) !== -1);
								});

					});
		}

		function initEditDeleteQuestion() {
			$('.question').unbind().on(
					'click',
					function(e) {
						//alert('question clicked');
						var questionId = $(this).attr('id').replace(
								'question_', '');
						$.get(
								'modals/edit_question.jsp?question_id='
										+ questionId + '&course_id='
										+ window.courseID).done(function(html) {
							$('#editQuestionModal').empty();
							$('#editQuestionModal').append(html);
							$('#editQuestionModal').modal();
							
							enablePassageViewer();
							enableExplanationViewer();
							enableQuestionViewer();
							enableEdit();
							addMoreOption();
							removeOption();
							enableMarkingOptionAsCorrect();
							submitQuestionData();
						});

						e.stopPropagation();
					});

			$('.remove_question')
					.unbind()
					.on(
							'click',
							function(e) {
								//alert('remove_question clicked -');
								var rowToRemove = $(this).parents('.question');
								var questionRowId = $(this)
										.parents('.question').attr('id');
								var questionId = questionRowId.replace(
										'question_', '');
								$
										.get(
												'../tfy_content_rest/question/delete/'
														+ questionId
														+ '/assessment/'
														+ window.assessmentID)
										.done(
												function(responseObject) {
													if (responseObject.success = true) {
														//fillExistingQuestionsInAssessment();
														var difficultyLevel = rowToRemove
																.removeClass(
																		'question')
																.attr('class');
														var questionText = rowToRemove
																.find(
																		"td:eq(1)")
																.html();
														var type = rowToRemove
																.find(
																		"td:eq(2)")
																.html();
														var skills = rowToRemove
																.find(
																		"td:eq(3)")
																.html();
														var sessionIds = rowToRemove
																.find(
																		"td:eq(4)")
																.html();
														var tableRow = "<tr class='"+difficultyLevel+" available_question' id='available_question_"+questionId+"'><td> \
						    <a class='btn btn-danger btn-icon btn-sm add_question_to_assessment'><i class='fa fa-arrow-circle-left' aria-hidden='true' style='color:white;'></i></a></td> \
						    <td>"
																+ questionId
																+ "</td> \
						    <td>"
																+ questionText
																+ "</td> \
						    <td>"
																+ type
																+ "</td> \
						    <td>"
																+ skills
																+ "</td> \
						    <td style='display:none'>"
																+ sessionIds
																+ "</td> \
						    </tr>";
														$(
																'#available_question_table')
																.prepend(
																		tableRow);
														rowToRemove.remove();
														enableSearchInAvailableQuestionTable();
														initAddingQuestionToAssessment();
													} else {
														alert('Error in removing question from assessment');
													}
												});
								e.stopPropagation();
							});

		}

		function initNewQuestionCreation()
		{
			$('#add_new_question').unbind().on(
					'click',
					function(e) {												
						$.get(
								'modals/edit_question.jsp?course_id='
										+ window.courseID).done(function(html) {
							$('#editQuestionModal').empty();
							$('#editQuestionModal').append(html);
							$('#editQuestionModal').modal();
							
							enablePassageViewer();
							enableExplanationViewer();
							enableQuestionViewer();
							enableEdit();
							enableMarkingOptionAsCorrect();
							submitQuestionData();
							addMoreOption();
							removeOption();
						});

						e.stopPropagation();
					});
		}
		
		function initUpdateAssessmentDetails()
		{
			$('#updateAssessmentDetails').unbind().on('click',function(){
				var assessmentName = $('#assessmentName').val().trim();
				var assessmentDesc = $('#assessmentDesc').val();
				var assessmentDurationInMinutes = $('#assessmentDurationInMinutes').val();
				var assessmentRetryAble = $('#assessmentRetryAble').prop('checked');
				
				var errorExist = false;
				var dataInErrorList='';
				if(assessmentName==='')
				{
					errorExist = true;
					dataInErrorList+='<p>Assesssment Name cannot be empty.</p>';
				}
				if(assessmentDurationInMinutes==0)
				{
					errorExist = true;
					dataInErrorList+='<p>Duration of assessment cannot be 0.</p>';
				}
				
				if(!errorExist)
				{
					var assessObject ={
							'id':window.assessmentID,
							'assessmentName':assessmentName,
							'assessmentDesc':assessmentDesc,
							'assessmentDurationInMinutes':assessmentDurationInMinutes,
							'assessmentRetryAble':assessmentRetryAble
					};		
					var assessJson = JSON.stringify(assessObject);
					$.ajax({
					    url: '../tfy_content_rest/assessment/update/'+ window.assessmentID,
					    type: "POST",
					    data: assessJson,
					    processData: false,
					    contentType: "application/json; charset=UTF-8",
					    success: function(data) {
					    	$('#assessmentPageHeading').html(assessmentName);
					    }
					});	
					
					
					$('#error_list').empty();
					var $alertMsg = $("#assess_error").find('.alert');
					if($alertMsg.hasClass('alert-danger'))
					{
						$alertMsg.removeClass('alert-danger');
						$alertMsg.addClass('alert-success');
						$alertMsg.find('.alert-heading').text('Assessment Updated Successfully !');
					}	
					$alertMsg.on("close.bs.alert", function () {
						$('#assess_error').hide();
					      return false;
					});
					$('#assess_error').show();
					$("#assess_error").fadeTo(2000, 500).slideUp(500, function(){
			               $("#assess_error").slideUp(500);
			                }); 
				}
				else
				{
					$('#error_list').empty();
					$('#error_list').append(dataInErrorList);
					var $alertMsg = $("#assess_error").find('.alert');
					if($alertMsg.hasClass('alert-success'))
					{
						$alertMsg.removeClass('alert-success');
						$alertMsg.addClass('alert-danger');
						$alertMsg.find('.alert-heading').text('Assessment Update Failed !');
						
					}
					$alertMsg.on("close.bs.alert", function () {
						$('#assess_error').hide();
					      return false;
					});
					$('#assess_error').show();
					$("#assess_error").fadeTo(2000, 500).slideUp(500, function(){
			               $("#assess_error").slideUp(500);
			                }); 
				}	
				
			});			
		}
		function fillAssessmentEditFormFields() {
			$.get(
					'../tfy_content_rest/assessment/read/' + window.lessonID
							+ '/course/' + window.courseID).done(
					function(assessmentObject) {
						$('#assessmentPageHeading').html(
								assessmentObject.assessment.title);
						$('#assessmentName').val(
								assessmentObject.assessment.title);
						$('#assessmentDesc').val(
								assessmentObject.assessment.description);
						$('#assessmentCategory').val(
								assessmentObject.assessment.category);
						if(assessmentObject.assessment.retry_able){
							$('#assessmentRetryAble').prop('checked',true);
						}else{
							$('#assessmentRetryAble').prop('checked',false);
						}
						$('#assessmentDurationInMinutes').val(
								assessmentObject.assessment.duration);
						$('#assessmentID').val(assessmentObject.assessment.id);
						window.assessmentID = $('#assessmentID').val();
						
						initUpdateAssessmentDetails();
						initNewQuestionCreation();
						
						fillExistingQuestionsInAssessment();

						fillAvailableQuestionsTable();
						
						
					});

		}
	</script>
</body>
</html>