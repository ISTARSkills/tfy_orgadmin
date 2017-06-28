<%@page import="com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes"%>
<%@page import="com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes"%>
<%@page import="in.orgadmin.utils.report.CustomReportUtils"%>
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

<jsp:include page="inc/head.jsp"></jsp:include>
<style>
th {
	text-align: center
}

.label {
	line-height: 22px;
}
</style>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	DBUTILS util = new DBUTILS();
%>
<body class="top-navigation" id="coordinator_trainer_details">
	<div id="wrapper">
		<div id="page-wrapper" class="white-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2 style="margin-left: 30px">
						<strong>Trainer Recruitment</strong>
					</h2>
				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight white-bg" style="padding: 20px;margin-left: 5px">
				<div class="row" id="filters">

					<div class=" col-lg-2 input-group pull-right">
						<input type="text" id="user_keyword" name="user_keyword" class="form-control"> <span class="input-group-btn">
							<button type="button" id="user_search_button" class="btn btn-outline btn-info">Search</button>
						</span>
					</div>	
					<%
						DBUTILS utils = new DBUTILS();
						String sql = "SELECT DISTINCT 	course_name FROM 	cluster_requirement, 	course, 	trainer_intrested_course WHERE 	course. ID = cluster_requirement.course_id and trainer_intrested_course.course_id=course.id";
						List<HashMap<String, Object>> items = utils.executeQuery(sql);
					%>
					<div class="big-demo go-wide" data-js="filtering-demo">
						<div class="filter-button-group button-group js-radio-button-group">
							<span class="badge badge-info">Course</span>
							<button class="btn btn-outline btn-info is-checked btn-xs" data-filter="*">show all</button>
							<%
								for (HashMap<String, Object> item : items) {
							%>
							<button class="btn btn-outline btn-info btn-xs" style="margin-bottom: 5px; margin-right: 5px" data-filter=".course_<%=item.get("course_name").toString().replaceAll("-", "_").replaceAll(" ", "_").replaceAll("/", "___").trim()%>"><%=item.get("course_name").toString()%></button>
							<%
								}
							%>
						</div>

					</div>
					<%
						String sql1 = "select distinct cluster.id, cluster_name from cluster, trainer_prefred_location, pincode , cluster_pincode_mapping where trainer_prefred_location.pincode = pincode.pin and pincode.id = cluster_pincode_mapping.pincode_id and cluster_pincode_mapping.cluster_id = cluster.id ";
						List<HashMap<String, Object>> items1 = utils.executeQuery(sql1);
					%>
					<div class="row" style="margin-top: 20px;margin-left: 15px;">
						<div class="big-demo go-wide" data-js="filtering-demo">
							<div class="filter-button-group button-group js-radio-button-group">
								<span class="badge badge-info">Filter by Cluster</span>
								<button class="btn btn-outline btn-warning btn-xs is-checked" data-filter="*">show all</button>
								<%
									for (HashMap<String, Object> item : items1) {
								%>
								<button class="btn btn-outline btn-warning btn-xs" style="margin-bottom: 5px; margin-right: 5px"  data-filter=".cluster_<%=item.get("cluster_name").toString().replaceAll("-", "_").replaceAll(" ", "_").replaceAll("/", "___").trim()%>"><%=item.get("cluster_name").toString()%></button>
								<%
									}
								%>
							</div>

						</div>
					</div>
					<div class="row grid" id="searchable_grid" style="margin: 10px">


						<%
							CustomReportUtils reportUtil = new CustomReportUtils();
							String sql2 = reportUtil.getReport(43).getSql();
							System.err.println("sql2--------------------"+sql2);
							List<HashMap<String, Object>> data = util.executeQuery(sql2);

							for (int i = 0; i < data.size(); i++) {
								try{
						%>						
						<div style="margin-bottom : 10px" data-name='<%=data.get(i).get("first_name").toString().replaceAll(" ", "_").toLowerCase()%>' 
						 data-url='<%=baseURL%>coordinator/trainer_profile.jsp?trainer_id=<%=data.get(i).get("id")%>'
						 
						 <%
						 String clustersData="";
						 if(data.get(i)!=null && data.get(i).get("clusters")!=null && !data.get(i).get("clusters").toString().equalsIgnoreCase("")){
							 clustersData=UIUtils.createClassNameCLuster(data.get(i).get("clusters").toString());
						 }
						 
						 %>
						 
						 class="trainerprofile_holder product-box col-lg-4 element-item <%=clustersData%> 
						  <%=UIUtils.createClassNameCourse(data.get(i).get("courses").toString())%>" >
							<div class="contact-box no-borders" style="height:80% !important;" >
								<div class="col-sm-4">
									<div class="text-center">
										<img style="width: 80px !important; height: 80px !important;" alt="image"
										 class="img-circle m-t-xs img-responsive" 
										 src="<%=user.getUserProfile().getProfileImage() %>">
									</div>
								</div>
								<div class="col-sm-8">
									<h3>
										<strong><%=data.get(i).get("first_name")%></strong>
									</h3>
									<p>
										<i class="fa fa-envelope"></i>&nbsp;
										<%=data.get(i).get("email")%></p>
									<address>
										<p>
											<i class="fa fa-phone"></i>&nbsp;
											<%=data.get(i).get("mobile")%></p>
									</address>
								</div>
								<table class="table table-bordered">
									<thead>
										<tr>
											<th>Course</th>
											<th>Level 1</th>
											<th>Level 2</th>
											<th>Level 3</th>
											<th>Level 4</th>
											<th>Level 5</th>
											<th>Level 6</th>
										</tr>
									</thead>
									<tbody>

										<%
										
										String findInterestedCourse = "select course.id , course.course_name from  trainer_intrested_course, course where trainer_intrested_course.trainer_id = "+data.get(i).get("id")+" and  course.id = trainer_intrested_course.course_id";
										List<HashMap<String, Object>> courseData = util.executeQuery(findInterestedCourse);
										if (courseData.size()>0) {
													
										for (HashMap<String, Object> courseRow : courseData) {
										
										String L1="<i class='fa fa-check text-navy'>";
										String L2="<i class='fa fa-check text-navy'>";
										String L3="NA"+"&nbsp;<i class='fa fa-hourglass-end'>";
										String L4="NA"+"&nbsp;<i class='fa fa-hourglass-end'>";
										String L5="NA"+"&nbsp;<i class='fa fa-hourglass-end'>";
										String L6="NA"+"&nbsp;<i class='fa fa-hourglass-end'>";
										Boolean courseCleared =false;
										String getL3Result ="select cast (sum(score) as integer) as user_score, (select cast (count(assessment_question.id) as integer) as total from assessment_question where assessmentid in (select DISTINCT assessment_id from course_assessment_mapping where course_id ="+courseRow.get("id")+"))   from report where user_id = "+data.get(i).get("id")+" and assessment_id in (select DISTINCT assessment_id from course_assessment_mapping where course_id ="+courseRow.get("id")+")";
										List<HashMap<String, Object>> scoreL3 = util.executeQuery(getL3Result);
										if(scoreL3.size()>0)
										{
											if(scoreL3.get(0).get("user_score")!=null)
											{
												L3 = scoreL3.get(0).get("user_score").toString()+"/"+scoreL3.get(0).get("total").toString();
											}
										}
										else
										{
											L3="NA"+"&nbsp;<i class='fa fa-hourglass-end'>";
										}	
										
										String result ="select  stage_type, cast (avg(rating) as integer) as rating from interview_rating where trainer_id = "+data.get(i).get("id")+" and course_id = "+courseRow.get("id")+" group by  stage_type";
										List<HashMap<String, Object>> scoreData = util.executeQuery(result);
										for(HashMap<String, Object> levelScore : scoreData)
										{
											if(levelScore.get("stage_type").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.SME_INTERVIEW))
											{
												L4 = levelScore.get("rating").toString()+"/5";
											}else if(levelScore.get("stage_type").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.DEMO))
											{
												L5 = levelScore.get("rating").toString()+"/5";
											}
											else if(levelScore.get("stage_type").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.FITMENT_INTERVIEW))
											{
												L6 = levelScore.get("rating").toString()+"/5";
											}																							
										}
										String getStatus = "SELECT trainer_id, ( CASE WHEN ( COUNT (*) FILTER (WHERE stage = 'L2') ) > 0 THEN ( CASE WHEN ( COUNT (*) FILTER (  WHERE stage = 'L2' AND empanelment_status = 'SELECTED' ) ) > 0 THEN 'SELECTED' ELSE 'REJECTED' END ) ELSE 'NOT_REACHED' END ) AS l2, ( CASE WHEN ( COUNT (*) FILTER (WHERE stage = 'L3') ) > 0 THEN ( CASE WHEN ( COUNT (*) FILTER (  WHERE stage = 'L3' AND empanelment_status = 'SELECTED' ) ) > 0 THEN 'SELECTED' ELSE 'REJECTED' END ) ELSE 'NOT_REACHED' END ) AS l3, ( CASE WHEN ( COUNT (*) FILTER (WHERE stage = 'L4') ) > 0 THEN ( CASE WHEN ( COUNT (*) FILTER (  WHERE stage = 'L4' AND empanelment_status = 'SELECTED' ) ) > 0 THEN 'SELECTED' ELSE 'REJECTED' END ) ELSE 'NOT_REACHED' END ) AS l4, ( CASE WHEN ( COUNT (*) FILTER (WHERE stage = 'L5') ) > 0 THEN ( CASE WHEN ( COUNT (*) FILTER (  WHERE stage = 'L5' AND empanelment_status = 'SELECTED' ) ) > 0 THEN 'SELECTED' ELSE 'REJECTED' END ) ELSE 'NOT_REACHED' END ) AS l5, ( CASE WHEN ( COUNT (*) FILTER (WHERE stage = 'L6') ) > 0 THEN ( CASE WHEN ( COUNT (*) FILTER (  WHERE stage = 'L6' AND empanelment_status = 'SELECTED' ) ) > 0 THEN 'SELECTED' ELSE 'REJECTED' END ) ELSE 'NOT_REACHED' END ) AS l6 FROM trainer_empanelment_status  where trainer_id = "+data.get(i).get("id")+" and course_id = "+courseRow.get("id")+" group by trainer_id";				
										List<HashMap<String, Object>> statusData = util.executeQuery(getStatus);
										HashMap<String,String> statusIconMap = new HashMap();
										statusIconMap.put(TrainerEmpanelmentStatusTypes.SELECTED, "<i class='fa fa-check text-navy' />");
										statusIconMap.put(TrainerEmpanelmentStatusTypes.REJECTED, "<i class='fa fa-times' />");
										statusIconMap.put(TrainerEmpanelmentStatusTypes.NOT_REACHED, "<i class='fa fa-hourglass-end' />");
										for(HashMap<String, Object>statusRow : statusData)
										{
											
											L3 +="&nbsp;"+ (L3.contains("fa-hourglass-end")?"":statusIconMap.get(statusRow.get("l3").toString()));
											L4 +="&nbsp;"+ (L4.contains("fa-hourglass-end")?"":statusIconMap.get(statusRow.get("l4").toString()));
											L5 +="&nbsp;"+ (L5.contains("fa-hourglass-end")?"":statusIconMap.get(statusRow.get("l5").toString()));
											L6 +="&nbsp;"+ (L6.contains("fa-hourglass-end")?"":statusIconMap.get(statusRow.get("l6").toString()));
											if(statusRow.get("l6").toString().equalsIgnoreCase(TrainerEmpanelmentStatusTypes.SELECTED))
											{
												courseCleared = true;
											}
										}
										%>
										<tr>
											<td><%=courseRow.get("course_name")%>&nbsp; 
											<%
											if(courseCleared)
											{
											%>
											<i class="fa fa-check text-navy"></i>
											<% 
											}
											%>
											
											
											</td>
											<td><%=L1 %></td>
											<td><%=L2 %></td>
											<td><%=L3 %></td>
											<td><%=L4 %></td>
											<td><%=L5 %></td>
											<td><%=L6 %></td>
										</tr>
										<%
											}
												}
										%>
									</tbody>
								</table>
								
								<div class="show_more" style="display:none;">
								<%
									if (data.get(i).get("slots") != null && !data.get(i).get("slots").toString().equalsIgnoreCase("")) {
								%>
								<div class="row">
									<div class="col-lg-12">
										<h5>Slots:</h5>

										<%
											String[] slots = data.get(i).get("slots").toString().split("<br>");
													for (String slot : slots) {
										%>
										<button class="btn btn-white btn-xs" type="button"><%=slot.replaceAll("- 9am, 9am -","-").replaceAll("- 10am, 10am -","-").replaceAll("- 11am, 11am -","-").replaceAll("- 12pm, 12pm -","-").replaceAll("- 1pm, 1pm -","-").replaceAll("- 2pm, 2pm -","-").replaceAll("- 3pm, 3pm -","-").replaceAll("- 4pm, 4pm -","-").replaceAll("- 5pm, 5pm -","-")%></button>
										<br />
										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>

								<%
									if (data.get(i).get("cities") != null && !data.get(i).get("cities").toString().equalsIgnoreCase("")) {
								%>
								<div class="row">
									<div class="col-lg-12">
										<h5>Cities:</h5>
										<%
											String[] cities = data.get(i).get("cities").toString().split(",");
													for (String city : cities) {
										%>
										<button class="btn btn-white btn-xs" type="button"><%=city%></button>
										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>

								<%
									if (data.get(i).get("clusters") != null
												&& !data.get(i).get("clusters").toString().equalsIgnoreCase("")) {
								%>
								<div class="row">
									<div class="col-lg-12">
										<h5>Cluster:</h5>
										<%
											String[] clusters = data.get(i).get("clusters").toString().split(",");
													for (String cluster : clusters) {
										%>
										<button class="btn btn-white btn-xs m-b-xs m-r-xs" type="button"><%=cluster%></button>
										<%
											}
										%>
									</div>
								</div>
								<%
									}
								%>
								</div>
							
								
							</div>
							<div class="row text-center"> 
							<a class="btn btn-outline btn-primary btn-xs show_more_button" style=''>more info</a>
							</div>
						</div>
						<%
							}catch(Exception e)
							{
								e.printStackTrace();
							}
							}
						%>
					
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>