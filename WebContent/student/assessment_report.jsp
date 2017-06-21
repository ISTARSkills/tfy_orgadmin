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
%>
<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<%
for(AssessmentReportPOJO ass :  cp.getAssessmentReports()) { 
												if(ass.getId() == assessmentID) {
													%><div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2><small>Assessment Report for</small> <strong><%=ass.getName() %></strong> </h2>

				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<div class="row">
			<div class="col-lg-3">
                <div class="widget style1 navy-bg">
                    <div class="row">
                        <div class="col-xs-4">
                            <i class="fa fa-cloud fa-5x"></i>
                        </div>
                        <div class="col-xs-8 text-right">
                            <span> Points </span>
                            <h2 class="font-bold">26'C</h2>
                        </div>
                    </div>
                </div>
            </div>
				<div class="col-lg-3">
                <div class="widget style1 navy-bg">
                    <div class="row">
                        <div class="col-xs-4">
                            <i class="fa fa-cloud fa-5x"></i>
                        </div>
                        <div class="col-xs-8 text-right">
                            <span> Accuracy </span>
                            <h2 class="font-bold">26'C</h2>
                        </div>
                    </div>
                </div>
            </div>
				<div class="col-lg-3">
                <div class="widget style1 navy-bg">
                    <div class="row">
                        <div class="col-xs-4">
                            <i class="fa fa-cloud fa-5x"></i>
                        </div>
                        <div class="col-xs-8 text-right">
                            <span> Batch Average </span>
                            <h2 class="font-bold">26'C</h2>
                        </div>
                    </div>
                </div>	
            </div>
            
            <div class="col-lg-3" style="    margin-top: 11px;">
              <%for (SkillReportPOJO skill:  ass.getSkillsReport()) {
            	  for (SkillReportPOJO subSkill:  skill.getSkills()) {
              %>
                <button type="button" class="btn btn-danger m-r-sm"><%=subSkill.getName() %></button>
                <% } } %>
            </div>
				</div>
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-content">



								<div class="table-responsive">
									<table class="table table-hover issue-tracker">
										<tbody>
											<% 
												for(QuestionResponsePOJO pojo : ass.getAssessmentResponse().getResponse()) {
												QuestionDAO dao = new QuestionDAO();
												Question question = dao.findById(pojo.getQuestionId());
												
												%>
											
											<tr>
												<td><span class="label label-primary">Added</span></td>
												<td class="issue-info"><small>
														<%=question.getQuestionText() %></small></td>
												<td>Your Answer</td>
												<td>Right Answer</td>
												<td><span class="pie" style="display: none;">0.52,1.041</span>
												<svg class="peity" height="16" width="16">
														<path
															d="M 8 8 L 8 0 A 8 8 0 0 1 14.933563796318165 11.990700825968545 Z"
															fill="#1ab394"></path>
														<path
															d="M 8 8 L 14.933563796318165 11.990700825968545 A 8 8 0 1 1 7.999999999999998 0 Z"
															fill="#d7d7d7"></path></svg> 2d</td>
												<td class="text-right">
													<button class="btn btn-white btn-xs">Tag</button>
													<button class="btn btn-white btn-xs">Mag</button>
													<button class="btn btn-white btn-xs">Rag</button>
												</td>
											</tr>
											
											<% } }  } %>
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