<%@page import="java.io.InputStream"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="tfy.admin.trainer.TaskCardFactoryRecruitment"%>
<%@page import="java.io.IOException"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	int trainerId = Integer.parseInt(request.getParameter("trainer_id"));
	IstarUser trainer = new IstarUserDAO().findById(trainerId);
%>


<body class="top-navigation" id="coordinator_trainer_profile">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight"
				style="padding: 8px">
				<div class="row" id="main_block_rec">
					<div class='col-md-6 kamini widget '><%=(new TaskCardFactoryRecruitment()).showTrainerProfileCard(trainerId).toString()%></div>
					<div class="col-md-6 kamini widget  " style="margin-top: 10px;">
						<div class="row m-b-lg m-t-lg ">
							<div class="col-md-6">

								<div class="profile-image">
									<img
										src="<%=AppProperies.getProperty("media_url_path")%><%=(trainer.getUserProfile() != null ? trainer.getUserProfile().getImage() : "")%>"
										class="img-circle circle-border m-b-md" alt="profile">
								</div>
								<div class="profile-info">
									<div class="">
										<div>
											<h3 class="no-margins">
												<%=trainer.getUserProfile() != null && trainer.getUserProfile().getFatherName() != null
					? trainer.getUserProfile().getFirstName() : trainer.getEmail()%>
											</h3>
											<h4><%=(trainer.getProfessionalProfile() != null
					&& trainer.getProfessionalProfile().getUnderGraduateDegreeName() != null
							? trainer.getProfessionalProfile().getUnderGraduateDegreeName() : "")%>,
												<%=(trainer.getProfessionalProfile() != null
					&& trainer.getProfessionalProfile().getPgDegreeName() != null
							? trainer.getProfessionalProfile().getPgDegreeName() : "")%></h4>

										</div>
									</div>
								</div>
							</div>

							<div class="col-md-3">
								<small><%=trainer.getEmail()%></small>
								<h2 class="no-margins"><%=trainer.getMobile()%></h2>

							</div>


						</div>
						<%=(new TaskCardFactoryRecruitment()).showSummaryCard(trainerId).toString()%>
					</div>
				</div>
				<div class="row p-xs" id="equalheight2">

					<%
						DBUTILS util = new DBUTILS();
						String findInterestedCourse = "select course.id , course.course_name from  trainer_intrested_course, course where trainer_intrested_course.trainer_id = "
								+ trainerId + " and  course.id = trainer_intrested_course.course_id";
						List<HashMap<String, Object>> courseData = util.executeQuery(findInterestedCourse);
						if (courseData.size() > 0) {
							for (HashMap<String, Object> row : courseData) {
								int courseId = (int) row.get("id");
								try {
					%>

					<%=(new TaskCardFactoryRecruitment())
								.showCourseCard(trainerId, courseId, user.getId(), false).toString()%>

					<%
						} catch (Exception e) {
									e.printStackTrace();
								}
							}
						}
					%>
				</div>
			</div>
		</div>
	</div>

	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>

</html>
