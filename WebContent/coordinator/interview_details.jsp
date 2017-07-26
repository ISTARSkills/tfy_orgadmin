<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
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
<%@page import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
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
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	String trainerId = request.getParameter("user_id");
	String courseId =  request.getParameter("course_id");
	String stage = request.getParameter("stage");
	
	String findRatings ="select interview_skill.interview_skill_name, interview_rating.rating "+ 	
			 " from interview_rating , interview_skill			where			interview_skill.id = interview_rating.interview_skill_id"+	
			" and interview_rating.trainer_id = "+trainerId+" and interview_rating.stage_type = '"+stage+"' and interview_rating.course_id = "+courseId;
	DBUTILS utils = new DBUTILS();
	List<HashMap<String, Object>> items = 		utils.executeQuery(findRatings);
	String sql1= "select user_profile.first_name as interviewer_name,trainer_comments.comments , user_profile.user_id   from trainer_comments, "+
			" user_profile where user_profile.user_id = interviewer_id and trainer_id = "+trainerId+" and stage = '"+stage+"' and course_id = "+courseId;
	List<HashMap<String, Object>> items1 = 		utils.executeQuery(sql1);
//System.err.println(sql1);	
String baseURL1 = url.substring(0, url.length() - request.getRequestURI().length())
+ request.getContextPath() + "/";
try {
	Properties properties = new Properties();
	String propertyFileName = "app.properties";
	InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
	if (inputStream != null) {
		properties.load(inputStream);
		baseURL1 = properties.getProperty("cdn_path");
	}
} catch (IOException e) {
	e.printStackTrace();
}
%>
<body class="top-navigation" id="cordinator_interview">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp" />
			<%
													
													
													%><div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>
						<small>Feedback Report for <span style='text-decoration: underline;'> <%=(new IstarUserDAO()).findById(Integer.parseInt(trainerId)).getUserProfile().getFirstName() %></span> for Course <span style='text-shadow: aqua;'><%=(new CourseDAO()).findById(Integer.parseInt(courseId)).getCourseName() %></span>stage '<%=stage %>' </span></small>
					</h2>

				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight" style="padding: 10px;">
				<div class="row">
					<div class="col-lg-8">
						<div class="ibox">
							<div class="ibox-content">



								<div class="table-responsive">
									<table class="table table-hover issue-tracker">

										<thead>
											<tr>
												<th>Question</th>
												<th>Rating</th>

											</tr>
										</thead>
										<tbody>

											<% for(HashMap<String, Object> item: items) { %>
											<tr>

												<td class="issue-info"><small>
														<p><%=item.get("interview_skill_name") %></p>
												</small></td>

												<td>
													<div id="rateYo" class='rateYo_element' data-star_value='<%=item.get("rating") %>'><%=item.get("rating") %></div>
												</td>
											</tr>

											<% } %>

										</tbody>
									</table>
								</div>
							</div>

						</div>
					</div>
<%if(items1.size()!=0){ %>
					<div class="col-lg-4">
						<div class="ibox-content">

							<div>
								<div class="chat-activity-list">

									<div class="chat-element">
										<a href="#" class="pull-left"> <img alt="image" class="img-circle" src="<%=baseURL1 %><%=(new IstarUserDAO()).findById(Integer.parseInt(items1.get(0).get("user_id").toString())).getUserProfile().getImage() %>">
										</a>
										<div class="media-body ">
											<small class="pull-right text-navy">1m ago</small> <strong><%=items1.get(0).get("interviewer_name") %></strong>
											<p class="m-b-xs"><%=items1.get(0).get("comments") %></p>
										</div>
									</div>

									
							</div>
						</div>
					</div>
				</div>
				<%}%>
			</div>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>