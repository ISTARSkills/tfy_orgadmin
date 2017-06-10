
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%

	int college_id = (int) request.getSession().getAttribute("orgId");
	DBUTILS util = new DBUTILS();
	
%>
<div class="row border-bottom white-bg ">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-title">
			<h2 class="text-center">PROGRAMS</h2>
		</div>
		<div class="ibox-content " style="overflow: auto;">

			<div class="row " style="display: flex;">

				<%
				
				String getCourseCards = "select course_id,course_name,course_description, cast(avg(attendance_perc) as integer) as attendance_perc, cast(avg(avg_feedback) as integer) as avg_feedback , cast (avg(completion_perc) as integer) as completion_perc, cast (sum(stu_enrolled) as integer) as stu_enrolled from (SELECT DISTINCT T1.course_name, COALESCE (T1.course_description, 'NA') AS course_description, COALESCE ( course_stats.attendance_perc, 0 ) AS attendance_perc, COALESCE ( course_stats.avg_feedback, 0 ) AS avg_feedback, COALESCE ( course_stats.completion_perc, 0 ) AS completion_perc, COALESCE ( course_stats.stu_enrolled, 0 ) AS stu_enrolled, T1.course_id, course_stats.batch_group_id FROM ( SELECT DISTINCT course. ID AS course_id, course_name, course_description, batch_group.college_id FROM batch_group, batch, course WHERE batch.course_id = course. ID AND batch_group. ID = batch.batch_group_id AND batch_group.is_historical_group = 'f' AND batch_group.college_id = "+college_id+" ) T1 LEFT JOIN course_stats ON ( T1.course_id = course_stats.course_id AND course_stats.college_id = T1.college_id ) )TFINAL group by course_id,course_name,course_description";
				List<HashMap<String, Object>> courseCardsData = util.executeQuery(getCourseCards); 	
				for (HashMap<String, Object> item: courseCardsData) {
						String courseId =item.get("course_id").toString();
						String courseName = item.get("course_name").toString();
						int collegeId = college_id;
						String courseDescription = item.get("course_description").toString();
						if(courseDescription.length()>=140)
						{
							courseDescription = courseDescription.substring(0, 140) + " ...";
						}
								
						String attendance = item.get("attendance_perc").toString();
						String avg_feedback = item.get("avg_feedback").toString();
						String studentEnrolled = item.get("stu_enrolled").toString();
						String completionPercentage = item.get("completion_perc").toString();
				%>
				<%-- <%= ui_Util.getCourseEventCard(college_id) %> --%>
				<a href='programs_report_details.jsp?course_id=<%=courseId%>&headname=<%=courseName%>&college_id=<%=collegeId%>' class='btn-link '>
					<div class='col-lg-3' id='program_info_1'>
						<div class='panel panel-default product-box course-card-height'>
							<div class='panel-heading custom-theme-panal-color font-bold' style="color: white;">
								<%=courseName%>
							</div>
							<div class='panel-body' style='width: 315px'>
								<p class='course-desc'><%=courseDescription%></p>
								<div class='row'>
									<div class='col-lg-6'>Attendance</div>
									<div class='col-lg-6 text-center'><%=attendance%></div>
								</div>
								<div class='row m-t-sm'>
									<div class='col-lg-6'>Feedback</div>
									<div class='col-lg-6 text-center' style='float: right;'>
										<div class='course_rating' data-report='<%=avg_feedback%>' style='float: right;'>
											<div class='rateYo<%=avg_feedback%>'></div>
										</div>
									</div>
								</div>
								<div class='row m-t-sm'>
									<div class='col-lg-6'>Student Enrolled</div>
									<div class='col-lg-6 text-center'><%=studentEnrolled%></div>
								</div>
								<div class='progress progress-striped active m-t-sm'>
									<div style='width: <%=completionPercentage%>%' aria-valuemax='100' aria-valuemin='0' aria-valuenow='<%=completionPercentage%>' role='progressbar' class='progress-bar progress-bar-danger'>
										<span class='text-center'><%=completionPercentage%>%</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</a>
				<%
					}
				%>
			</div>

		</div>
	</div>
</div>
<div class="row border-bottom white-bg ">

	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-title">
			<h2 class="text-center">BATCHES</h2>
		</div>
		<div class="ibox-content " style="overflow: auto;">
			<div class="row " style="display: flex;">

				<%
				
				String getBatchCards = "SELECT 	T1. NAME AS batch_name, 	COALESCE (batch_stats.stu_enrolled, 0) AS stu_enrolled, 	COALESCE ( 		batch_stats.completion_perc, 		0 	) AS completion_perc, 	COALESCE (batch_stats.avg_feedback, 0) AS avg_feedback, 	COALESCE ( 		batch_stats.attendance_perc, 		0 	) AS attendance_perc, 	T1. ID AS batch_id FROM 	( 		SELECT DISTINCT 			batch. ID, 			batch. NAME 		FROM 			batch_group, 			batch 		WHERE 			batch_group.college_id = "+college_id+" 		AND batch.batch_group_id = batch_group. ID 		AND batch_group.is_historical_group = 'f' 	) T1 LEFT JOIN batch_stats ON (T1. ID = batch_stats.batch_id) order by T1. NAME";
				List<HashMap<String, Object>> batchCardsData = util.executeQuery(getBatchCards); 	
				for (HashMap<String, Object> item: batchCardsData) {
						String batchId =item.get("batch_id").toString();
						String batchName = item.get("batch_name").toString();
						int collegeId = college_id;
						
						
								
						String attendance = item.get("attendance_perc").toString();
						String avg_feedback = item.get("avg_feedback").toString();
						String studentEnrolled = item.get("stu_enrolled").toString();
						String completionPercentage = item.get("completion_perc").toString();
				%>
				
				<a href='programs_report_details.jsp?batch_id=<%=batchId%>&headname=<%=batchName%>&college_id=<%=collegeId%>' class='btn-link '>
					<div class='col-lg-3' id='program_info_1'>
						<div class='panel panel-default product-box course-card-height'>
							<div class='panel-heading custom-theme-panal-color font-bold' style="color: white;">
								<%=batchName%>
							</div>
							<div class='panel-body' style='width: 315px'>
								
								<div class='row'>
									<div class='col-lg-6'>Attendance</div>
									<div class='col-lg-6 text-center'><%=attendance%></div>
								</div>
								<div class='row m-t-sm'>
									<div class='col-lg-6'>Feedback</div>
									<div class='col-lg-6 text-center' style='float: right;'>
										<div class='course_rating' data-report='<%=avg_feedback%>' style='float: right;'>
											<div class='rateYo<%=avg_feedback%>'></div>
										</div>
									</div>
								</div>
								<div class='row m-t-sm'>
									<div class='col-lg-6'>Student Enrolled</div>
									<div class='col-lg-6 text-center'><%=studentEnrolled%></div>
								</div>
								<div class='progress progress-striped active m-t-sm'>
									<div style='width: <%=completionPercentage%>%' aria-valuemax='100' aria-valuemin='0' aria-valuenow='<%=completionPercentage%>' role='progressbar' class='progress-bar progress-bar-danger'>
										<span class='text-center'><%=completionPercentage%>%</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</a>
				<%
					}
				%>
			</div>
		</div>
	</div>
</div>
<br>
<br>
<br>
