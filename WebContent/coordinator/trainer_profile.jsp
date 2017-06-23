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
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	int trainerId = Integer.parseInt(request.getParameter("trainer_id"));
	
	IstarUser trainer = new IstarUserDAO().findById(trainerId);
%>


<body class="top-navigation" id="coordinator_trainer_profile">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg" style="min-height: 1212px !important">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight" style="padding: 8px">
				<div class="row" id="main_block_rec">
				<div class='col-md-6 kamini widget '><%=(new TaskCardFactoryRecruitment()).showTrainerProfileCard(trainerId).toString()%></div>
				<div class="col-md-6 kamini widget  " style="    margin-top: 10px;">
				<div class="row m-b-lg m-t-lg ">
                <div class="col-md-6">

                    <div class="profile-image">
                        <img src="http://cdn.talentify.in/video/android_images/D.png" class="img-circle circle-border m-b-md" alt="profile">
                    </div>
                    <div class="profile-info">
                        <div class="">
                            <div>
                                <h3 class="no-margins">
                                   <%=trainer.getUserProfile().getFirstName() %>
                                </h3>
                                <h4><%=trainer.getProfessionalProfile().getUnderGraduateDegreeName() %>, <%=trainer.getProfessionalProfile().getPgDegreeName() %></h4>
                                
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3">
                    <small><%=trainer.getEmail() %></small>
                    <h2 class="no-margins"><%=trainer.getMobile() %></h2>
                    
                </div>


            </div>
				<%=(new TaskCardFactoryRecruitment()).showSummaryCard(trainerId).toString()%>
				</div>
				</div>
								<div class="row" id="equalheight2">
				
				<% 
				DBUTILS util = new DBUTILS();
				String findInterestedCourse = "select course.id , course.course_name from  trainer_intrested_course, course where trainer_intrested_course.trainer_id = "+trainerId+" and  course.id = trainer_intrested_course.course_id";
				List<HashMap<String, Object>> courseData = util.executeQuery(findInterestedCourse);
				if (courseData.size()>0) {
					for(HashMap<String, Object> row: courseData) { 
					int courseId = (int)row.get("id");
					%>
					<%=(new TaskCardFactoryRecruitment()).showCourseCard(trainerId,courseId, user.getId()).toString()%>
				<% }
				}
				%>
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
