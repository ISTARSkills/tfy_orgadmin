<%@page import="com.viksitpro.core.dao.entities.AssessmentOption"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.dao.entities.QuestionDAO"%>
<%
int questionId = Integer.parseInt(request.getParameter("question_id"));
Question question = new QuestionDAO().findById(questionId);
%>
<div class="modal-dialog edit-question-modal-dialog" role="document">
	<div class="modal-content custom-edit-question-modal-content">
		<div class="modal-header custom-edit-question-modal-header">
			<h5 class="modal-title custom-edit-question-modal-title"
				id="editQuestionModalLabel">Edit Question</h5>
			<button type="button" class="close" data-dismiss="modal"
				aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
		</div>
		<div class="modal-body custom-no-padding">
			<div class="container-fluid bd-example-row">
				<div class='row' style="margin-top: 10px;">
					<div class='col-md-4 justify-content-md-center'>
						<img src='/assets/images/viewport.png' style="width: 360px;">
						<div class='que_mobile_prev'>

							<div class='row'>
								<div class='col-md-1 col-md-auto'>
									<i class="fa fa-remove" aria-hidden="true"></i>

								</div>
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
							</div>

							<div id='question_container'>
								<div class='row'>
									<div class='col-md-8 preview_heading'>QUESTION 7 OF 20</div>
								</div>
								<div class='row'>
									<div class='col-md-12' id='edit_question_text'>
										<%=question.getQuestionText() %>
									</div>
								</div>
								<%
								if(question.getAssessmentOptions()!=null)
								{int totalOption =1; 
									for(AssessmentOption op: question.getAssessmentOptions())
									{
										%>
										<div class='row edit_question_option' id='option_<%=op.getId()%>'>
									<div class='col-md-12 edit_option_text' id='edit_option_text_<%=op.getId()%>'
										data-is_correct=false>
										<p><%=op.getText()%></p>
									</div>
								</div>							
										<%
									}
								}	
								%>
							</div>

							<div id='question_passage_container'>
								<div class='row'>
									<div class='col-md-8 preview_heading'>COMPREHENSIVE
										PASSAGE</div>
								</div>
								<div class="row">
									<div class="col-md-12" id="edit_passage_text">
									
										<%if(question.getComprehensivePassageText()!=null)
											{
											%>
											<%=question.getComprehensivePassageText() %>
											<% 
											}%>
									</div>
								</div>
							</div>

							<div id='question_explanation_container'>
								<div class='row'>
									<div class='col-md-8 preview_heading'>EXPLANATION</div>
								</div>
								<div class="row">
									<div class='col-md-12' id="edit_explanation_text">
										<%if(question.getExplanation()!=null)
											{
											%>
											<%=question.getExplanation() %>
											<% 
											}%>
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
						<div class='que_passage_explanation_holder'>
							<div class='row' style="margin-bottom: 10px;">
								<div class='col-md-12 col-md-auto'>
									<button type="button" class="btn btn-primary"
										id="question_preview" title="Question and Option Preview">Q</button>
								</div>
							</div>
							<div class='row' style="margin-bottom: 10px;">
								<div class='col-md-12 col-md-auto'>
									<button type="button" class="btn btn-primary"
										id="passage_preview" title="Comprehensive Passage Preview">P</button>
								</div>
							</div>
							<div class='row' style="margin-bottom: 10px;">
								<div class='col-md-12 col-md-auto'>
									<button type="button" class="btn btn-primary"
										id="explanation_preview" title="Explanation Preview">E</button>
								</div>
							</div>

						</div>
					</div>
					<div class='col-md-8 question_form'>
						<div  id="question_details_form">
						<div class='row my-3'>
							<div class='col-md-2 col-md-auto'>
								<label>Difficulty Level</label> <select id='difficultyLevel'
									class="custom-select d-block " required>
									<option value="1">Beginner</option>
									<option value="2">Easy</option>
									<option value="3">Medium</option>
									<option value="4">Hard</option>
									<option value="5">Extreme</option>
								</select>
							</div>
							<div class='col-md-4 col-md-auto'>
								<label>Type</label> <select id='questionType'
									class="custom-select d-block" required>
									<option value="1">Single Correct Option</option>
									<option value="2">Multiple Correct Option</option>
									<option value="3">Comprehensive Single Correct Option</option>
									<option value="4">Comprehensive Multiple Correct Option</option>
								</select>
							</div>
							<div class='col-md-2 col-md-auto'>
								<label>Duration (in secs)</label> <input type="number"
									style="width: 100%" class="form-control  "
									id="questionDuration">
							</div>

						</div>

						<div class='row my-3'>

							<div class='col-md-10 col-md-auto'>
								<label><b>Question</b></label>
								<div id='questionText'>
								
								</div>
							</div>
						</div>
						
						<%
						if(question.getAssessmentOptions()!=null)
						{
							for(AssessmentOption op : question.getAssessmentOptions())
							{
								String markinScheme = "incorrect_option";
								if(op.getMarkingScheme()==1)
								{
									markinScheme = "correct_option";
								}
								%>
								<div class='row my-3'>	
							<div class='col-md-10 col-md-auto'>
								<label><b>Option</b></label>
								<div class="option_text" id='option_text_<%=op.getId()%>'>
								
								</div>
							</div>
							<div class='col-md-2 col-md-auto'>
								<div style="margin-top: 25px;">
								<button type="button" class="btn option_marking_scheme <%=markinScheme %>" id="option_marking_scheme_<%=op.getId()%>">Correct</button>
								</div>
							</div>
						</div>
								<%
							}
						}
						%>	
						</div>
						
						<div  id="question_passage_details_form">
						<div class='row my-3'>

							<div class='col-md-12 col-md-auto'>
								<label><b>Comprehensive Passage</b></label>
								<div id="passageText">
							
								</div>
							</div>
						</div>
						</div>
						<div  id="question_explanation_details_form">
						<div class='row my-3'>

							<div class='col-md-12 col-md-auto'>
								<label><b>Explanation</b></label>
								<div id="explanationText">
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