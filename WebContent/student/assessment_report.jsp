<%@page import="com.istarindia.android.pojo.AssessmentResponsePOJO"%>
<%@page import="tfy.admin.trainer.TrainerReportService"%>
<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="com.istarindia.android.pojo.OptionPOJO"%>
<%@page import="org.apache.commons.collections.CollectionUtils"%>
<%@page import="com.istarindia.android.pojo.QuestionPOJO"%>
<%@page import="com.istarindia.android.pojo.AssessmentPOJO"%>
<%@page import="com.istarindia.android.pojo.SkillReportPOJO"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.dao.entities.QuestionDAO"%>
<%@page import="com.istarindia.android.pojo.QuestionResponsePOJO"%>
<%@page import="com.istarindia.android.pojo.AssessmentReportPOJO"%>
<%@page import="org.omg.CosNaming.IstringHelper"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<style>
.row {
	margin-right: 0px !important;
	margin-left: 0px !important;
}

.h-370 {
	min-height: 375px !important;
	max-height: 375px !important;
}

.button-top {
	margin-top: -12px !important;
}

.assessment-circle-img {
	width: 50%;
	height: 40%;
}

.session-square-img {
	width: 160px;
	height: 160px;
}

.btn-rounded {
	min-width: 200px;
	background: #eb384f;
	color: white;
}

.task-complete-header {
	background: #23b6f9 !important;
}

#vertical-timeline {
	overflow-x: hidden;
	overflow-y: auto;
	max-height: 250px;
}

.vertical-container {
	width: 99% !important;
}

.vertical-timeline-content p {
	margin-bottom: 2px !important;
	margin-top: 0 !important;
	line-height: 1.6 !important;
}

.content-border {
	border: none !important;
}

.btn.banner:hover {
	color: white !important
}

.nav-tabs>li.active>a:hover, a:focus, a:active {
	border-radius: 50px !important;
}

.btn.banner.focus, .btn.banner:focus, .btn.banner:hover {
	color: white !important;
}
</style>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	request.setAttribute("cp", cp);
	boolean flag = false;
	int assessmentID = Integer.parseInt(request.getParameter("assessment_id"));
	int trainerId  = Integer.parseInt(request.getParameter("user_id"));
	AssessmentPOJO assessment = rc.getAssessment(assessmentID, trainerId);
	ArrayList<QuestionPOJO> questions = (ArrayList<QuestionPOJO>)assessment.getQuestions();
	HashMap<Integer, QuestionPOJO> actualQuestions = new HashMap();
	for(QuestionPOJO que : questions)
	{
		actualQuestions.put(que.getId(), que);		
	}
	
	
	TrainerReportService reportService = new TrainerReportService();
	AssessmentResponsePOJO resp = reportService.getAssessmentResponseOfUser(assessmentID, trainerId);
	
	
	
%>
<body class="top-navigation" >
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<%
												if(resp!=null) {
													
													HashMap<Integer, QuestionResponsePOJO> answersByUser  = new HashMap();
													for(QuestionResponsePOJO qresp : resp.getResponse())
													{
														answersByUser.put(qresp.getQuestionId(), qresp);
													}
													%><div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2><small>Assessment Report for</small> <strong><%=assessment.getName() %></strong> </h2>

				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<div class="row">
			
				</div>
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-content">



								<div class="table-responsive">
									<table class="table table-hover issue-tracker">
									
										<thead>
										<tr>
										<th>Question</th>
										<th>Correct Answer</th>
										<th>Selected Answer</th>
										<th>Time Taken</th>
										<th>Marking</th>
										</tr>
										</thead>
										<tbody>
											<% 
											for(QuestionPOJO que : questions){
												
												String mark = "";
												String labelStyle= "";
												String correctAnswer ="";
												String userAnswer ="";
												String timeTookToAnswer ="0 sec";
												for(OptionPOJO option : que.getOptions())
												{
													correctAnswer = option.getText()+", ";
												}
												correctAnswer = correctAnswer.replaceAll(", $", "");
												if(answersByUser.get(que.getId())!=null && answersByUser.get(que.getId()).getOptions()!=null && answersByUser.get(que.getId()).getOptions().size()>0)
												{
													//atleast not skipped
													
													
													QuestionResponsePOJO queByUser = answersByUser.get(que.getId());
													ArrayList<Integer> realAnswers = (ArrayList<Integer>) que.getAnswers();
													ArrayList<Integer> selectByUser = (ArrayList<Integer>) queByUser.getOptions();
													Boolean isEqual = CollectionUtils.isEqualCollection(realAnswers,selectByUser);
													timeTookToAnswer = queByUser.getDuration()+" sec";
													
													if(isEqual)
													{
														mark = "Correct";
														labelStyle="style='background-color: #1ab394; color: white;';";
														
														userAnswer = correctAnswer;
													}
													else
													{
														mark ="Incorrect";
														labelStyle="style='background-color: #eb384f; color: #FFFFFF;';";
														
														for(OptionPOJO option : que.getOptions())
														{
															int optionId=option.getId();
															if(selectByUser.contains(optionId))
															{
																userAnswer = option.getText()+", ";
															}
															if(que.getAnswers().contains(optionId)){
																correctAnswer = option.getText()+", ";
															}
															
														}
														userAnswer = userAnswer.replaceAll(", $", "");
														correctAnswer = correctAnswer.replaceAll(", $", "");
													}		
												}
												else
												{
													mark ="Skipped";
													labelStyle="style='    background-color: #d1dade;color: #5e5e5e;';";
													userAnswer ="Skipped";
												}	
												%>
											
											<tr>
												
												<td class="issue-info"><small>
														<%=que.getText()%></small></td>
													<td><small><%=correctAnswer %></small></td>	
												<td><small><%=userAnswer %></small></td>
												
												<td><span class="label"><%=timeTookToAnswer%></span>																								
												<td><span class="label" <%=labelStyle%>><%=mark %></span></td>
											</tr>
											
											<% } }   %>
										</tbody>
									</table>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>