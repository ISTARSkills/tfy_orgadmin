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

<jsp:include page="inc/head.jsp"></jsp:include>
<style>

th{
text-align:center
}
.label
{
    line-height: 22px;
}
</style>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	DBUTILS util = new DBUTILS();
%>
<body class="top-navigation">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2><strong>Trainer Wise Details</strong> </h2>
				</div>
				<div class="col-lg-2"></div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 10px;">
				<div class="row">
			<div class="col-lg-2">
                <div class="widget style1 navy-bg">
                    <div class="row">
                        <div class="col-xs-4">
                            <i class="fa fa-cloud fa-5x"></i>
                        </div>
                        <div class="col-xs-8 text-right">
                            <span> Signed Up(L2) </span>
                            <h2 class="font-bold">50</h2>
                        </div>
                    </div>
                </div>
            </div>
				<div class="col-lg-2">
                <div class="widget style1 navy-bg">
                    <div class="row">
                        <div class="col-xs-4">
                            <i class="fa fa-cloud fa-5x"></i>
                        </div>
                        <div class="col-xs-8 text-right">
                            <span>  Assessment(L3) </span>
                            <h2 class="font-bold">10</h2>
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
                            <span> SME Interview (L4) </span>
                            <h2 class="font-bold">15</h2>
                        </div>
                    </div>
                </div>	
            </div>
            <div class="col-lg-2">
                <div class="widget style1 navy-bg">
                    <div class="row">
                        <div class="col-xs-4">
                            <i class="fa fa-cloud fa-5x"></i>
                        </div>
                        <div class="col-xs-8 text-right">
                            <span> Demo (L5) </span>
                            <h2 class="font-bold">15</h2>
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
                            <span> Fitement Interview (L6) </span>
                            <h2 class="font-bold">15</h2>
                        </div>
                    </div>
                </div>	
            </div>
            </div>
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-content">
							<% 
							CustomReportUtils reportUtil = new CustomReportUtils();
							String sql = reportUtil.getReport(43).getSql();
							List<HashMap<String, Object>> data = util.executeQuery(sql);
							%>
							<div class="table-responsive">
                <table class="table table-striped table table-bordered">
                    <thead>
                   <tr align=center>
										<th>Id</th>
										<th>First Name</th>
										<th>Clusters</th>
										<th>Courses</th>
										<th>Cities</th>
										<!-- <th>Pincodes</th> -->
										<!-- <th>Days</th> -->
										<th>Time Slots</th>
										<th style="white-space: nowrap;">L2<br>
										<span class="label label-primary" style="background-color: #1ab394;    color: #FFFFFF;">Selected</span>&nbsp;
										<span class="label label-warning">Pending</span>&nbsp;
										<span class="label label-danger">Rejected</span></th>
										<th style="white-space: nowrap;">L3<br>
										<span class="label label-primary" style="background-color: #1ab394;    color: #FFFFFF;">Selected</span>&nbsp;
										<span class="label label-warning">Pending</span>&nbsp;
										<span class="label label-danger">Rejected</span></th>
										<th style="white-space: nowrap;">L4<br>
										<span class="label label-primary" style="background-color: #1ab394;    color: #FFFFFF;">Selected</span>&nbsp;
										<span class="label label-warning">Pending</span>&nbsp;
										<span class="label label-danger">Rejected</span></th>
										<th style="white-space: nowrap;">L5<br>
										<span class="label label-primary" style="background-color: #1ab394;    color: #FFFFFF;">Selected</span>&nbsp;
										<span class="label label-warning">Pending</span>&nbsp;
										<span class="label label-danger">Rejected</span></th>
										<th style="white-space: nowrap;">L6<br>
										<span class="label label-primary" style="background-color: #1ab394;    color: #FFFFFF;">Selected</span>&nbsp;
										<span class="label label-warning">Pending</span>&nbsp;
										<span class="label label-danger">Rejected</span></th>
										<th>L3 Score</th>
										<th>L4 Avg Score</th>
										<th>L5 Avg Score</th>
										<th>L6 Avg Score</th>
										</tr>
                    </thead>
                    <tbody>
                    <%
										for(HashMap<String, Object> row: data){
											int trainerId = (int)row.get("id");
											String findCourses = "select distinct course.id , course_name from trainer_intrested_course, course where trainer_intrested_course.course_id = course.id and trainer_intrested_course.trainer_id = "+trainerId+"  order by course_name ";
											List<HashMap<String, Object>> courseData = util.executeQuery(findCourses);
										%>
										<tr>
										<td><%=row.get("id")%></td>
										<td><a href='trainer_profile.jsp?trainer_id=<%=row.get("id")%>'><%=row.get("first_name")%><br/>[<%=row.get("email")%>]</a></td>
										
										<td style="white-space: nowrap;"><%=row.get("clusters")%></td>
										<td style="white-space: nowrap;"><%=row.get("courses")%></td>
										<td><%=row.get("cities")%></td>
										
										<td style="white-space: nowrap;" ><%=row.get("slots").toString().replaceAll("- 9am, 9am -","-").replaceAll("- 10am, 10am -","-").replaceAll("- 11am, 11am -","-").replaceAll("- 12pm, 12pm -","-").replaceAll("- 1pm, 1pm -","-").replaceAll("- 2pm, 2pm -","-").replaceAll("- 3pm, 3pm -","-").replaceAll("- 4pm, 4pm -","-").replaceAll("- 5pm, 5pm -","-")%></td>
										<td>
										<%
										for(int i=0 ;i< courseData.size(); i++)
										{
											HashMap<String, Object> perCourse= courseData.get(i);
											String getStatusForCourse = "select empanelment_status from trainer_empanelment_status where course_id= "+perCourse.get("id")+" and trainer_id = "+trainerId+" and stage='"+TrainerEmpanelmentStageTypes.SIGNED_UP+"'";
											List<HashMap<String, Object>> dataForL2 = util.executeQuery(getStatusForCourse);
											if(dataForL2.size()>0)
											{
												if(dataForL2.get(0).get("empanelment_status").toString().equalsIgnoreCase(TrainerEmpanelmentStatusTypes.SELECTED))
												{
													%>
													<span class="label label-primary" style="background-color: #1ab394;    color: #FFFFFF;"><%=perCourse.get("course_name") %></span><br>
													<% 
												}
												else
												{
													%>
													<span class="label label-danger"><%=perCourse.get("course_name") %></span><br>
													<% 
												}	
											}
											else
											{
												%>
												<span class="label label-warning"><%=perCourse.get("course_name") %></span>
												<% 
											}	
										}
										%>
										</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td style="white-space: nowrap;"></td>
										<td></td>
										<td></td>
										<td></td>
										</tr>
										<%
										}%>
                    </tbody>
                </table>
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