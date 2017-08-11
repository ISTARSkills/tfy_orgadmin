<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Assessment"%>
<%@page import="tfy.admin.services.AdminServices"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
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
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
 String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
IstarUser user = (IstarUser)request.getSession().getAttribute("user");
int collegeID = (int)request.getSession().getAttribute("orgId");
Organization organization = new OrganizationDAO().findById(collegeID);
%>
<body class="top-navigation" id="istar_notification">
<input type="hidden" name="college_id" value="<%=collegeID%>" id ="hidden_college_id">
<input type="hidden" name="admin_id" value="<%=user.getId()%>" id ="hidden_admin_id">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="/inc/navbar.jsp"></jsp:include>
		
		<% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Notification", brd) %>
				
			<div class="row customcss_istarnotification">
			<div class="col-lg-12 card-box m-r-none bg-muted">
				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Choose Section/ Role</label>
						<div>
							<select data-placeholder="Select Section" tabindex="4"
								id='notification_batchgroup_holder'>
								<option value="null">Select Section / Role</option>
								<option value="ALL_GROUP_OF_ORG_<%=collegeID%>">Select All</option>
								<%
								
								for(BatchGroup bg : organization.getBatchGroups())
								{
									//System.err.println(organization.getId()+"---"+bg.getName());
									if(bg.getBatchStudentses().size()>0){
										//System.out.println(bg.getName());
									%>
									<option value="<%=bg.getId()%>"><%=bg.getName() %> (<%=bg.getType() %>)</option>
									<% 
									}
								}
								%>
								</select>
						</div>
					</div>
				</div>

				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Notification Type</label>
						<div>
							<select data-placeholder="Select Notification" tabindex="4"
								id='notification_type_holder'>
								<option value="null">Select Notification Type</option>
								<option value="LESSON">LESSON</option>
								<option value="ASSESSMENT">ASSESSMENT</option>
								<option value="COMPLEX_UPDATE">UPDATE STUDENT CONTENT</option>
								<option value="MESSAGE">MESSAGE</option>
							</select>
						</div>
					</div>
				</div>
				<div id="play_presentation_holder" style="display: none;">
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Course</label>
							<div>
								<select data-placeholder="Select Course" tabindex="4"
									data-url='' id='course_holder'>									
									</select>
							</div>
						</div>
					</div>
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Session</label>
							<div>
								<select data-placeholder="Select Session" tabindex="4"
									data-url='' id='notification_cmsession_holder'>
								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Lesson</label>
							<div>
								<select data-placeholder="Select Lesson" tabindex="4"
									data-url='' id='notification_ppt_holder'>
								</select>
							</div>
						</div>
					</div>
				</div>
				
				
				<div id="play_assessment_holder" style="display: none;">
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Course</label>
							<div>
								<select data-placeholder="Select Course" tabindex="4"
									data-url='' id='notification_assessment_course_holder'>
									<%
									List<Assessment> assessments = (List<Assessment>)new AssessmentDAO().findAll();
									ArrayList<Integer>courseIds = new ArrayList();
									for(Assessment assess : assessments) 
									{
										if(!courseIds.contains(assess.getCourse()))
										{
											courseIds.add(assess.getCourse());
											Course cc = new CourseDAO().findById(assess.getCourse());
											if(cc!=null && cc.getId()!=null){
											%>
											<option value="<%=cc.getId()%>"><%=cc.getCourseName() %></option>
											<%
										}}
									}
									%>
									
									
								</select>
							</div>
						</div>
					</div>
					
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Assessment</label>
							<div>
								<select data-placeholder="Select Assessment" tabindex="4"
									data-url='' id='notification_assessment_holder'>
									
								</select>
							</div>
						</div>
					</div>
				</div>

	<div class="col-lg-2">					
				</div></div>
			</div>
			<div style="display: none" id="spinner_holder">
				<div style="width: 100%; z-index: 6; position: fixed;"
					class="spiner-example">
					<div style="width: 100%;"
						class="sk-spinner sk-spinner-three-bounce">
						<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
					</div>
				</div>
			</div>
			<div id="">
				<form role="form">

					<div class="row">

						<div class="col-lg-6 white-bg">
							<div class="ibox">
								<div class="ibox-content  customcss_iboxcontent">
									<div class="form-group">
										<label>Title</label> <input type="text" id="title"
											placeholder="Write Title..." class="form-control">
									</div>
									<div class="form-group">
										<label>Description</label>
										<textarea class="form-control" id="comment"
											placeholder="Write Comment..."></textarea>
									</div>
									<div class="form-group">
										<button class="btn btn-sm btn-danger pull-right m-t-n-xs"
											id="send_notification" type="button">
											<strong>Send Notification</strong>
										</button>

									</div>

								</div>

							</div>
						</div>
						<div class="col-lg-6">
							<div class="ibox">
								<div class="ibox-content">

									<h3 class="m-b-xxs">
										Student List <label class="checkbox-inline pull-right">
											<input type="checkbox" id="checkAll"> Check All
										</label>
									</h3>
									<div >
									<ul data-student='student_list' class='todo-list m-t small-list ui-sortable' id="student_holder">
									</ul>
									</div>

								</div>

							</div>
						</div>
					</div>

				</form>


			</div>

		</div>
		
	</div>
	
<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>