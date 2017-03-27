<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="com.istarindia.apps.dao.StudentDAO"%>
<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><%@page import="com.istarindia.apps.dao.*"%>
<!DOCTYPE html>
<html>
<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	
	RecruiterServices recruiterService = new RecruiterServices();
	HashMap<String, Object> interviewDetails = (HashMap<String, Object> ) request.getSession(false).getAttribute("interviewDetails");
	
	Panelist panelist = (Panelist) interviewDetails.get("panelist");
	Vacancy vacancy = (Vacancy) interviewDetails.get("vacancy");
	Student student = (Student) interviewDetails.get("student");
	String joinURL = (String) interviewDetails.get("joinURL");
	String uniqueURLCode = (String) interviewDetails.get("uniqueURLCode");
	List<PanelistFeedback> allPanelistFeedback = (List<PanelistFeedback>) interviewDetails.get("allPanelistFeedbackForVacancy");
	List<HashMap<String, Object>> skillrating = recruiterService.getStudentRatingPerskill(student.getId());
	
	int studentID = student.getId();
	int panelistID = panelist.getId();
	String location = student.getAddress().getPincode().getCity();
	String college =( student.getCollege()!=null)? student.getCollege().getName() : "N/A";
	String degree ="N/A";
	String intrested_job_domains = "N/A";
	String resume = null;
	String fname=student.getName();
	
	if(student.getStudentProfileData()!=null)
	{		
		 degree =(student.getStudentProfileData().getUnderGraduationSpecializationName()!=null)? student.getStudentProfileData().getUnderGraduationSpecializationName() : "N/A";
		 intrested_job_domains =( student.getStudentProfileData().getJobSector()!=null)? student.getStudentProfileData().getJobSector() : "N/A";
		 resume = (student.getStudentProfileData().getResume()!=null)?"/"+student.getStudentProfileData().getResume():null;
	}

	%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify Panelist</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
	<link href="<%=baseURL%>css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
</head>

<body class="fixed-navigation">

	<div id="wrapper">

		<nav class="navbar navbar-static-top" role="navigation"
			style="margin-bottom: 0; background: white; height: 45px; padding-top: 15px;">
			<ul class="nav navbar-top-links navbar-right">
				<li class="m-r-sm text-muted"><span
					style="font-size: 22px; font-weight: bold; color: black;">Welcome
						to Talenitfy</span></li>
			</ul>
		</nav>

		<div class="wrapper wrapper-content"
			style="overflow-x: hidden;">
			<div class="row" style="position: relative; min-height: 850px;">
				<div class="pull-right col-lg-8 row" id="panelist"
					style="border: solid white 1px; min-height: 750px;background-color: white; position: absolute; top: 0; bottom: 0; right: 0; margin-top: 45px; padding-top: 20px;">
						<center><iframe src="<%=joinURL%>" class="col-lg-11 row" style="min-height: 750px;"></iframe></center>
				</div>

				<div class="col-lg-4 row" id="student_card"
					style="position: absolute; min-height: 850px;">
					<input type="hidden" value="<%=studentID %>" class="student_id" />

					<div class="student_card_panelist border-right">
						<div class="row" style="margin-bottom: 20px;">
							<div class="col-md-4">
								<img alt="image" class="img-responsive all_border"
									src="<%=student.getImageUrl()%>">
							</div>

							<div class=" col-md-8">
								<h4 style="font-size: 16px;">
									<strong><%=StringUtils.capitalize(fname) %> </strong>
								</h4>
								<p style="font-size: 14px;">
									<%=location %></p>
								<hr class="top_border" />
								<p style="font-size: 16px;">
									<Strong><%=college %> </Strong><br />

								</p>
								<p style="font-size: 14px;"><%=degree %></p>
							</div>
						</div>

						<div class="row" style="padding: 20px;">

							<div class="tabs-container">
								<ul class="nav nav-tabs">
									<li class="active"><a data-toggle="tab"
										href="#feedback_interview"><i class="fa fa-laptop"></i></a></li>
									<%if(allPanelistFeedback.size()>0){%>
									<li class=""><a data-toggle="tab"
										href="#feedback_panelist"><i class="fa fa-desktop"></i></a></li>
									<%} %>
									<li class=""><a data-toggle="tab" href="#profile"><i
											class="fa fa-database"></i></a></li>
								</ul>
								<div class="tab-content border-top">
									<div id="feedback_interview" class="tab-pane active">
										<div class="panel-body">
									<form>
											<ul class="stat-list" id="skill_rating_list" style="overflow-y=scroll;">
												<%
						for (HashMap<String, Object> row : skillrating) {%>
												<li style="padding-bottom: 12px;" data-skill="<%=String.valueOf((Integer) row.get("id")) %>">
													<h2 class="no-margins"
														style="font-size: 14px; padding-bottom: 4px;"><%=(String) row.get("skill_title") %></h2>
													<div class="row" id="rate_student">
														<div class="col-md-3 oneBar"
															style="padding-left: 5px; padding-right: 0px;"
															data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
															data-bar="1">
															<div class="progress progress-mini <%=String.valueOf((Integer) row.get("id")) %>"
																data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
																data-bar="1">
																<div style="width: 0%;" class="progress-bar"
																	id="bar1<%=String.valueOf((Integer) row.get("id")) %>"
																	data-bar="1"></div>
																<input type="radio"
																	class="<%=String.valueOf((Integer) row.get("id")) %>"
																	value="1" style="display: none;" data-validation="required"/>
															</div>
															<i style="font-size: 8px; padding-bottom: 4px;">Novice</i>
														</div>
														<div class="col-md-3 oneBar"
															style="padding-left: 5px; padding-right: 0px;"
															data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
															data-bar="2">
															<div class="progress progress-mini oneBar <%=String.valueOf((Integer) row.get("id"))%>"
																data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
																data-bar="2">
																<div style="width: 0%;" class="progress-bar"
																	id="bar2<%=String.valueOf((Integer) row.get("id")) %>"
																	data-bar="2"></div>
																<input type="radio"
																	class="<%=String.valueOf((Integer) row.get("id")) %>"
																	value="2" style="display: none;" data-validation="required"/>
															</div>
															<i style="font-size: 8px; padding-bottom: 4px;">Apprentice</i>
														</div>
														<div class="col-md-3 oneBar"
															style="padding-left: 5px; padding-right: 0px;"
															data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
															data-bar="3">
															<div class="progress progress-mini oneBar <%=String.valueOf((Integer) row.get("id")) %>"
																data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
																data-bar="3">
																<div style="width: 0%;" class="progress-bar"
																	id="bar3<%=String.valueOf((Integer) row.get("id")) %>"
																	data-bar="3"></div>
																<input type="radio"
																	id="star_rating_1_<%=String.valueOf((Integer) row.get("id")) %>"
																	class="<%=String.valueOf((Integer) row.get("id")) %>"
																	value="3" style="display: none;" data-validation="required"/>
															</div>
															<i style="font-size: 8px; padding-bottom: 4px;">Master</i>
														</div>
														<div class="col-md-3 oneBar"
															style="padding-left: 5px; padding-right: 0px;"
															data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
															data-bar="4">
															<div class="progress progress-mini oneBar <%=String.valueOf((Integer) row.get("id")) %>"
																data-skill="<%=String.valueOf((Integer) row.get("id")) %>"
																data-bar="4">
																<div style="width: 0%;" class="progress-bar"
																	id="bar4<%=String.valueOf((Integer) row.get("id")) %>"
																	data-bar="4"></div>
																<input type="radio"
																	id="star_rating_1_<%=String.valueOf((Integer) row.get("id")) %>"
																	class="<%=String.valueOf((Integer) row.get("id")) %>"
																	value="4" style="display: none;" data-validation="required"/>
															</div>
															<i style="font-size: 8px; padding-bottom: 4px;">Wizard</i>
														</div>
													</div>
												</li>
												<%
														}
													%>
											</ul>

												<input type="hidden" name="panelist_id"
													value="<%=panelistID%>" class="panelist_id"/> 
												<input type="hidden" name="student_id" value="<%=studentID%>"
													class="student_id"/> <span
													class="panelist_video_details"></span>
												<div class="col-lg-10 form-group"
													style="height: 100px !important;">
														<textarea placeholder="Enter feedback"
													class="form-control message-input b-r-md pull-left" id="interview_feedback" data-validation="required"
													></textarea>
												</div>
				<div class="col-lg-10">
				<button type="button" class="btn btn-w-m btn-primary pull-left submit_interview_result" data-result="select" style="margin-right:10px; ">Select</button>
				<button type="button" class="btn btn-w-m btn-danger pull-left submit_interview_result" data-result="reject">Reject</button>		
				</div>
				</form>
												</div>

										</div>
									<%if(allPanelistFeedback.size()>0){%>
									<div id="feedback_panelist" class="tab-pane">
										<div class="panel-body">
											<h3>Panelist Feedback</h3>
											<% for(PanelistFeedback panelistFeedback:allPanelistFeedback){
											if(!panelistFeedback.getResult().trim().isEmpty()){%>
											<strong><%=panelistFeedback.getPanelist().getName()%></strong>
											<% String feedback = panelistFeedback.getFeedback();
											if(!feedback.trim().isEmpty()){%>
											<p>
												<%=panelistFeedback.getFeedback()%>
											</p>
											<%} else{ %>
											<p>
											No Feedback provided
											</p>
										<%	}
											}
											}%>
										</div>
									</div>
									<%}%>
									<div id="profile" class="tab-pane">
										<div class="panel-body">
											<h3>Student Profile</h3>

											<div class="user-button">
												<%
						if (skillrating.size() == 0) {
						%>
												<h4>Skill Rating Not Available</h4>
												<%	
						}
						else
						{	
						%>
												<ul class="stat-list" style="overflow-y=scroll;">
													<%
						for (HashMap<String, Object> row : skillrating) {
							int country_percentile = (int) row.get("percentile_country");
							int bar1=0;
							int bar2=0;
							int bar3=0;
							int bar4=0;
							int quotient = country_percentile/25;
							 int remiander = country_percentile%25;
							if(quotient==0)
							{
								 bar1=0;
								 bar2=0;
								 bar3=0;
								 bar4=0;
							}	
							else if (quotient==1)
							{
								 bar1=100;
								
								 bar2=remiander;
								 bar3=0;
								 bar4=0;
							}
							else if (quotient==2)
							{
								 bar1=100;
								 bar2=100;
								 bar3=remiander;
								 bar4=0;
							}
							else if (quotient==3)
							{
								 bar1=100;
								 bar2=100;
								 bar3=100;
								 bar4=remiander;
							}
							else if (quotient==4)
							{
								 bar1=100;
								 bar2=100;
								 bar3=100;
								 bar4=100;
							}
						
						%>

													<li style="padding-bottom: 12px;">
														<h2 class="no-margins"
															style="font-size: 14px; padding-bottom: 4px;"><%=(String) row.get("skill_title") %></h2>
														<div class="row">
															<div class="col-md-3"
																style="padding-left: 5px; padding-right: 0px;">
																<div class="progress progress-mini">
																	<div style="width: <%=bar1%>%;" class="progress-bar"></div>
																</div>
																<i style="font-size: 8px; padding-bottom: 4px;">Novice</i>
															</div>
															<div class="col-md-3"
																style="padding-left: 5px; padding-right: 0px;">
																<div class="progress progress-mini">
																	<div style="width: <%=bar2%>%;" class="progress-bar"></div>
																</div>
																<i style="font-size: 8px; padding-bottom: 4px;">Apprentice</i>
															</div>
															<div class="col-md-3"
																style="padding-left: 5px; padding-right: 0px;">
																<div class="progress progress-mini">
																	<div style="width: <%=bar3%>%;" class="progress-bar"></div>
																</div>
																<i style="font-size: 8px; padding-bottom: 4px;">Master</i>
															</div>
															<div class="col-md-3"
																style="padding-left: 5px; padding-right: 0px;">
																<div class="progress progress-mini">
																	<div style="width: <%=bar4%>%;" class="progress-bar"></div>
																</div>
																<i style="font-size: 8px; padding-bottom: 4px;">Wizard</i>
															</div>
														</div>
													</li>

													<%
						}
                                        %>
												</ul>
												<%
						}
						%>



											</div>
											<%if(resume!=null) {%>
											<a title="Download Resume" id="download"
												class="btn btn-outline btn-primary pull-right" href="<%=resume%>" target="_blank">Download
												Resume</a>
											<%} else{ %>
											
											<p class="pull-right" style="margin-top: 30px;">No resume available</p>
											<%} %>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
<!-- Mainly scripts -->
<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>

		<!-- jQuery UI -->
	<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>
	
<script src="<%=baseURL%>js/bootstrap.min.js"></script>
<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<!-- Flot -->
<script src="<%=baseURL%>js/plugins/flot/jquery.flot.js"></script>
<script src="<%=baseURL%>js/plugins/flot/jquery.flot.tooltip.min.js"></script>
<script src="<%=baseURL%>js/plugins/flot/jquery.flot.spline.js"></script>
<script src="<%=baseURL%>js/plugins/flot/jquery.flot.resize.js"></script>
<script src="<%=baseURL%>js/plugins/flot/jquery.flot.pie.js"></script>
<script src="<%=baseURL%>js/plugins/flot/jquery.flot.symbol.js"></script>
<script src="<%=baseURL%>js/plugins/flot/curvedLines.js"></script>

<!-- Peity -->
<script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
<script src="<%=baseURL%>js/demo/peity-demo.js"></script>

<!-- Custom and plugin javascript -->
<script src="<%=baseURL%>js/inspinia.js"></script>
<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
	<!-- Sweet alert -->
	<script src="<%=baseURL%>js/plugins/sweetalert/sweetalert.min.js"></script>
	    <script src="<%=baseURL%>js/highcharts-custom.js"></script>

<script>
	
	$(document).ready(function() {
		
		$($(document)).on("click", ".close_window", function(){
			window.close();
		})
		
		var interviewFinished = false; 
		 $($(document)).on("click", ".oneBar", function() {	
			 
			 $(this).siblings().each(function(){
				 $(this).find('.progress-bar').css("width","0%");
			 });
			 console.log("touched");
			 var barNumber = $(this).data('bar');
			 console.log(barNumber);
			 var skill = $(this).data('skill');
			 console.log(skill);
			 $(this).siblings().each(function(){
				 var tempBarNumber = $(this).find('.progress-bar').data('bar');
				 console.log("child " + tempBarNumber)
				 if(tempBarNumber < barNumber){
					 $(this).find('.progress-bar').css("width","100%");
				 }
			 })
			 
			 $(this).find('.progress-bar').css("width","100%");
			 console.log($('input.'+skill));
			 $(this).find('input.'+skill).prop('checked', true);
			 console.log($('input.'+skill));
			 console.log("TRUE");
		 });
		 
			$($(document)).on("click", ".submit_interview_result", function() {
			
				var result = $(this).data('result');
				
		 swal({
		        title: "Confirm result submission?",
		        text: "Once you submit the results, you wont be allowed to make any further changes.",
		        type: "warning",
		        showCancelButton: true,
		        confirmButtonColor: "#1ab394",
		        confirmButtonText: "Submit",
		        closeOnConfirm: true
		    },function(){
		    	interviewFinished = true;
				//var result = $(this).data('result');
				var studentID = $('.student_id').val();
				var panelistID = $('.panelist_id').val();
				var feedback = $('textarea#interview_feedback').val();
				var interviewResult="";
				
				$('#skill_rating_list > li').each(function(){
					var skillID = $(this).data('skill');
					var skillRating = $('input.'+skillID+':checked').val();
					console.log("Skill ID->" + skillID +" -----Skill Rating->"+skillRating);
					interviewResult = skillID+":"+skillRating + "," + interviewResult;
					console.log("INTERVIEW RESULT-->" + interviewResult);
				})
				
				console.log(result);
				console.log(studentID);
				console.log(panelistID);
				console.log(interviewResult);
				console.log(feedback);
				console.log("DONE");
				
				var URL = "/sendInterviewFeedback";
				console.log("INTERVIEW RESULT" + result);
			       	 $.ajax({
			             type: "POST",
			             url: URL,
		            	 data:{
		            		 interviewResult : result,
		            		 interviewFeedback : feedback,
		            		 interviewResultMap : JSON.stringify(interviewResult),
		            		 uniqueURLCode : '<%=uniqueURLCode%>'
		            	 },
					success : function(data) {
						console.log("Feedback Sent");
						console.log(data);
						$('#output_message').html(data);
						$('#result_notification').modal('toggle');
					}
				});
			       	
		});
		 $('.sa-icon').hide();
		    })
	});

	</script>
	
	<div id="result_notification" class="modal fade" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-12 b-r" id="output_message">

						</div>
					</div>
				</div>
			</div>
		</div>
</div>	

	
	</body>
</html>