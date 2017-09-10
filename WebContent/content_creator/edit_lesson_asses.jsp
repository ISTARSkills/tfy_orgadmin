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
<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Lato" />
<style>
.champa {
	background-color: antiquewhite !important;
}
</style>
<body id="assesssment_edit_page">
	<%String basePath =  AppProperies.getProperty("cdn_path");
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
	<input style='display: hidden' id='lessonId' value='<%=request.getParameter("lesson_id")%>'>
	<input style='display: hidden' id='courseId' value='<%=request.getParameter("course_id")%>'>
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
							<label for="assessmentName" class="col-sm-3 col-form-label"> Name</label>
							<div class="col-sm-9">
								<input type="text" id='assessmentName' class="form-control">
							</div>
						</div>
						<div class="form-group row">
							<label for="assessmentDesc" class="col-sm-3 col-form-label">Description</label>
							<div class="col-sm-9">
								<textarea class="form-control" rows="3" style="width: 100%" id='assessmentDesc'></textarea>
							</div>
						</div>
						<div class="form-group row">
							<label for="assessmentDurationInMinutes" class="col-sm-3 col-form-label">Duration (mins)</label>
							<div class="col-sm-2">
								<input type="number" id='assessmentDurationInMinutes' class="form-control">
							</div>
						</div>
						<div class="form-group row">
							<label for="assessmentRetryAble" class="col-sm-3 col-form-label">Retryable</label>
							<div class="col-sm-9 checkbox">
								<div class="checkbox">
									<label><input type="checkbox" checked id="assessmentRetryAble"></label>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<div class="col-sm-10">
								<button class="btn btn-sm btn-primary " type="button" id='updateAssessmentDetails'>Update Detail</button>
							</div>
						</div>
					</form>

				</div>
				<div class="col-md-4">
					<div class="form-group row">
					<label for="session" class="col-sm-2 col-form-label">Skills</label>
						<select class="form-control col-sm-10 assessment_skill_selector" id="session_skill" multiple>
						<%
						if(course.getModules()!=null){
							for(Module module : course.getModules())
							{
								if(module.getCmsessions()!=null)
								{
									%>
									<optgroup label="<%=module.getModuleName()%>">
   									<%
									for(Cmsession cms : module.getCmsessions())
									{
										ArrayList<Integer> loInSession = new ArrayList();
										if(cms.getLessons()!=null)
										{
											for(Lesson lesson : cms.getLessons())
											{
												if(lesson.getType()!=null && !lesson.getType().equalsIgnoreCase("ASSESSMENT") && lesson.getSkillObjectives()!=null && lesson.getSkillObjectives().size()>0)
												{
													for(SkillObjective lo : lesson.getSkillObjectives())
													{
														if(!loInSession.contains(lo.getId()))
														{
															loInSession.add(lo.getId());
														}
													}
												}	
											}	
										}
										
										if(loInSession.size()>0)
										{
											%>
											 <option value="<%=StringUtils.join(loInSession, ",")%>"><%=cms.getTitle() %></option>
											<%
										}
									}
									
									%>
									 </optgroup>
									<%
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
			<div class="panel panel-inverse" data-sortable-id="table-basic-6">
                        <div class="panel-heading">
                         <h4 class="panel-title">Questions in Assessment</h4>
                        </div>
                        <div class="panel-body">
                        	<div class="table-responsive">
								<table class="table" id="assessment_que_table">
									<thead>
										<tr>
											<th>Id</th>
											<th>Question</th>
											<th>Type</th>
											<th>Session Skill</th>						
											<th></th>
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
			<div class="panel panel-inverse">
                        <div class="panel-heading">                            
                            <h4 class="panel-title">Questions Available</h4>
                        </div>
                        <div class="panel-body">
                        	<div class="table-responsive">
								<table class="table">
									<thead>
										<tr>
											<th>Id</th>
											<th>Question</th>
											<th>Type</th>
										</tr>
									</thead>
									<tbody>
										<tr class="active">
											<td>1</td>
											<td>Nicky Almera</td>
											<td>nicky@hotmail.com</td>
										</tr>
										<tr class="info">
											<td>2</td>
											<td>Terry Khoo</td>
											<td>terry@gmail.com</td>
										</tr>
										<tr class="success">
											<td>3</td>
											<td>Edmund Wong</td>
											<td>edmund@yahoo.com</td>
										</tr>
										<tr class="warning">
											<td>4</td>
											<td>Harvinder Singh</td>
											<td>harvinder@gmail.com</td>
										</tr>
										<tr class="danger">
											<td>5</td>
											<td>Terry Khoo</td>
											<td>terry@gmail.com</td>
										</tr>
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
<div id="editQuestionModal" class="modal fade" role="dialog">
</div>
		
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script src="<%=basePath %>assets/js/plugins/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="<%=basePath%>assets/js/edit_question.js"></script>
	<script>
		$(document).ready(function() {
			
			
			
			window.lessonID = $('#lessonId').val();
			window.courseID = $('#courseId').val();
			fillAssessmentEditFormFields();
			
		});
		function  fillExistingQuestionsInAssessment()
		{
			$.get('../tfy_content_rest/question/readAll/' + window.assessmentID+'/course/'+window.courseID)
			.done(
					function(questionsObject) {	
						//console.log(questionsObject);
						if(questionsObject.success=true && questionsObject.questionData.questions!=null && questionsObject.questionData.questions.length>0)
						{
							var tableBody='';
							var data = questionsObject.questionData.questions;
							for(var i in data)
							{
							     var questionId = data[i].id;
							     var questionText = data[i].text;
							     var type =data[i].type ;
							     var difficultyLevel = data[i].difficulty_level;
							     var skills= data[i].skills;
							     var tableRow = "<tr class='"+difficultyLevel+" question' id='question_"+questionId+"'> \
							     <td>"+questionId+"</td> \
							     <td>"+questionText+"</td> \
							     <td>"+type+"</td> \
							     <td>"+skills+"</td> \
							     <td><a class='btn btn-danger btn-icon btn-sm remove_question'><i class='fa fa-trash' aria-hidden='true' style='color:white;'></i></span></i></a></td></tr>";							  
							     tableBody+=tableRow;							    
							}
							
							//console.log(tableBody);
							$('#assessment_que_table_body').empty();
							$('#assessment_que_table_body').append(tableBody);
							
							
							initEditDeleteQuestion();
							
							
						}else
						{
							//alert(false);
						}	
					});
		}
		
		function initEditDeleteQuestion()
		{
			$('.question').unbind().on('click',function(e){
				//alert('question clicked');
				var questionId = $(this).attr('id').replace('question_','');
				$.get('modals/edit_question.jsp?question_id='+questionId)
				.done(function(html) {
					$('#editQuestionModal').empty();
					$('#editQuestionModal').append(html);
					$('#editQuestionModal').modal();
					enableCorrectQuestionSelector();
					enablePassageViewer();
					enableExplanationViewer();
					enableQuestionViewer();
					enableEdit();
					enableMarkingOptionAsCorrect();
				});	
				
			    e.stopPropagation();
			});
			
			$('.remove_question').unbind().on('click',function(e){
				//alert('remove_question clicked -');
				var questionRowId = $(this).parents('.question').attr('id');
				var questionId = questionRowId.replace('question_','');
				$.get('../tfy_content_rest/question/delete/' + questionId+'/assessment/'+window.assessmentID)
				.done(function(responseObject) {
					if(responseObject.success=true){
						fillExistingQuestionsInAssessment();
					}else
					{
						alert('Error in removing question from assessment');
					}	
				});				
			    e.stopPropagation();
			});
			
		}
		
		function fillAssessmentEditFormFields()
		{			
				$.get('../tfy_content_rest/assessment/read/' + window.lessonID+'/course/'+window.courseID)
						.done(
								function(assessmentObject) {									
									$('#assessmentPageHeading').html(
											assessmentObject.assessment.title);
									$('#assessmentName').val(
											assessmentObject.assessment.title);
									$('#assessmentDesc').val(
											assessmentObject.assessment.description);
									$('#assessmentCategory').val(
											assessmentObject.assessment.category);
									$('#assessmentRetryAble').val(
											assessmentObject.assessment.retry_able);
									$('#assessmentDurationInMinutes').val(
											assessmentObject.assessment.duration);
									$('#assessmentID').val(
											assessmentObject.assessment.id);
									window.assessmentID = $('#assessmentID').val();
									
									fillExistingQuestionsInAssessment();
									fillAvailableQuestions();
								});
			
		}
		
		function fillAvailableQuestions()
		{
			
		}
		</script>
</body>
</html>