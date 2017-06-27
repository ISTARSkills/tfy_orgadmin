<%@page import="tfy.admin.trainer.CoordinatorSchedularUtil"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="tfy.admin.trainer.TaskCardFactoryRecruitment"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.istarindia.android.pojo.CoursePOJO"%>
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

<jsp:include page="inc/head.jsp"></jsp:include>
<%
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	CoordinatorSchedularUtil schedularUtil = new CoordinatorSchedularUtil();
%>


<body class="top-navigation" id="coordinator_interview_schedular">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<div class="wrapper wrapper-content animated fadeInRight" style="padding: 8px">
				<div class="row">
					<div class="col-md-5">

						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Scheduler</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" style='padding: 15px 20px 64px 20px !important;'>
								<form id="schedular_form" class="form">
									<div class="form-group">
										<label>Choose Course</label> <select class="form-control m-b scheduler_select" id="course_id" name="course_id">
											<option value="">Select Course...</option>
											<%
												for (HashMap<String, Object> item : schedularUtil.getCoursees()) {
											%>
											<option value="<%=item.get("id")%>"><%=item.get("course_name")%>(<%=item.get("id")%>)
											</option>
											<%
												}
											%>
										</select>
									</div>

									<div class="form-group">
										<label>Choose Stage</label> <select class="form-control m-b scheduler_select" id="stage_id" name="stage_id">
											<option value="">Select Stage...</option>
											<option value="L4">SME Interview(L4)</option>
											<option value="L5">Demo(L5)</option>
											<option value="L6">Fitment Interview(L6)</option>
										</select>
									</div>

									<div class="form-group">
										<label>Choose Interviewer</label> <select class="form-control m-b scheduler_select" id='inter_viewer_id' name="interviewer_id">
											<option value="">Select Interviewer...</option>
											<%
												for (HashMap<String, Object> item : schedularUtil.getInterViewersList()) {
											%>
											<option value="<%=item.get("id")%>"><%=item.get("email")%> (<%=item.get("role_name").toString().replaceAll("_", " ").toLowerCase()%>)
											</option>
											<%
												}
											%>
										</select>
									</div>

									<div class="form-group">
										<label>Choose Trainer</label> <select class="form-control m-b scheduler_select" id='trainer_id' name="trainerID">
											<option value="">Select Trainer...</option>
										</select>
									</div>



									<div class="form-group" id="data_2">
										<label class="font-bold">Interview Date</label>
										<div class="input-group date">
											<span class="input-group-addon"><i class="fa fa-calendar"></i></span> <input name="date" id="eventDate" type="text" class="form-control date_holder" value="">
										</div>
									</div>

									<div class="form-group">
										<label class="font-bold">Interview Time</label>
										<div class="input-group" data-autoclose="true">
											<span class="input-group-addon"> <span class="fa fa-clock-o"></span>
											</span> <input type="text" style="width: 100%; height: 28px;" id="eventTime" name="time" class="time_element" />
										</div>
									</div>

									<div class="form-group">
										<label class="font-bold">Interview Duration(in Mins)</label>
										<div class="input-group" data-autoclose="true">
											<span class="input-group-addon"> <span class="fa fa-clock-o"></span>
											</span> <input type="text" style="width: 100%; height: 28px;" id="event_duration" value='30' name="duration" />
										</div>
									</div>

									<div class="form-group">
										<button type="button" class="btn btn-outline btn-primary pull-right" id="submit_form">Submit</button>
									</div>
									<input type='hidden' name='coordinator_id' value='<%=user.getId()%>' /> <input type='hidden' name='type' value='submit' />
								</form>

							</div>
						</div>

					</div>
				</div>

			</div>
		</div>
	</div>

	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>

</html>
