<%@page import="com.viksitpro.core.dao.entities.BatchDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Batch"%>
<%@page import="in.superadmin.services.ReportDetailService"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.*"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.*"%>


<%
	int college_id = Integer.parseInt(request.getParameter("college_id"));
	System.out.println("---------college_id------->" + college_id);

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	request.setAttribute("base_url", baseURL);

	UIUtils uiUtil = new UIUtils();
	boolean flag = false;
	JsonUIUtils jsonUIUtils = new JsonUIUtils();
	JSONArray pieChartData = null;
	StringBuffer attendanceData = null;
	JSONArray calendardata = null;

	ArrayList<JSONArray> barChartData = null;
	int studentcount = 0;
	int courseOrBatchId = 0;
	List<HashMap<String, Object>> student_list = null;

	
	int sessionCount = 0;
	int assessmentCount=0;
	String courseName="";
	int course_id=0;
	if (request.getParameter("course_id") != null
			&& !request.getParameter("course_id").toString().equalsIgnoreCase("null")) {
		flag = true;
		Course course = new CourseDAO().findById(Integer.parseInt(request.getParameter("course_id").toString()));
		course_id = course.getId();
		courseName = course.getCourseName();
		System.out.println("course_id -------" + request.getParameter("course_id").toString());
		pieChartData = jsonUIUtils.getPieChartData(
				Integer.parseInt(request.getParameter("course_id").toString()), college_id, "Program");
		barChartData = jsonUIUtils.getBarChartData(
				Integer.parseInt(request.getParameter("course_id").toString()), college_id, "Program");
		studentcount = jsonUIUtils.getStudentCountfromCourse(
				Integer.parseInt(request.getParameter("course_id").toString()), college_id, "Program");
		student_list = jsonUIUtils.getStudentlistfromCourse(
				Integer.parseInt(request.getParameter("course_id").toString()), college_id, "Program");
		courseOrBatchId = Integer.parseInt(request.getParameter("course_id").toString());
		attendanceData = jsonUIUtils
				.getAttendanceReport(Integer.parseInt(request.getParameter("course_id").toString()), "Program");
		calendardata = uiUtil.getCourseReportEvent(college_id,
				Integer.parseInt(request.getParameter("course_id").toString()), "Program");
	} else if (request.getParameter("batch_id") != null
			&& !request.getParameter("batch_id").toString().equalsIgnoreCase("null")) {
		flag = false;
		System.out.println("batch_id--------" + request.getParameter("batch_id").toString());
		Batch batch = new BatchDAO().findById(Integer.parseInt(request.getParameter("batch_id").toString()));
		courseName = batch.getCourse().getCourseName();
		course_id = batch.getCourse().getId();
		pieChartData = jsonUIUtils.getPieChartData(
				Integer.parseInt(request.getParameter("batch_id").toString()), college_id, "Batch");
		barChartData = jsonUIUtils.getBarChartData(
				Integer.parseInt(request.getParameter("batch_id").toString()), college_id, "Batch");
		studentcount = jsonUIUtils.getStudentCountfromCourse(
				Integer.parseInt(request.getParameter("batch_id").toString()), college_id, "Batch");
		student_list = jsonUIUtils.getStudentlistfromCourse(
				Integer.parseInt(request.getParameter("batch_id").toString()), college_id, "Batch");
		courseOrBatchId = Integer.parseInt(request.getParameter("batch_id").toString());
		attendanceData = jsonUIUtils
				.getAttendanceReport(Integer.parseInt(request.getParameter("batch_id").toString()), "Batch");
		calendardata = uiUtil.getCourseReportEvent(college_id,
				Integer.parseInt(request.getParameter("batch_id").toString()), "Batch");

		List<HashMap<String, Object>> items = new ReportDetailService().getAllSessions(Integer.parseInt(request.getParameter("batch_id")), 0, true);
		sessionCount = items.size();
		items = new ReportDetailService().getAllAssessments(Integer.parseInt(request.getParameter("batch_id")), 0, true);
		assessmentCount=items.size();
	}
	int nosofpages = 0;
	if (studentcount % 6 == 0) {
		nosofpages = studentcount / 6;
	} else {
		nosofpages = (studentcount / 6) + 1;

	}
%>

<div id="data-holder" style='display: none;'>
	<div id='nosofpages' data-content='<%=nosofpages%>'></div>
</div>

<div collegeid="<%=college_id%>" id="myid"
	data-course="<%=courseOrBatchId%>" type="<%=flag%>"></div>
<div id="wrapper">
	<div id="page-wrapper" class="gray-bg">
		<div class="row wrapper border-bottom white-bg page-heading">
			<div class="col-lg-9">
				<%
					if (request.getParameter("headname") != null
							&& !request.getParameter("headname").toString().equalsIgnoreCase("null")) {
				%>
				<h2>
					&nbsp;&nbsp;&nbsp;&nbsp; Report for
					<%=request.getParameter("headname").toString()%></h2>

			</div>
			<%
				}
			%>
		</div>
		<!-- row1 start -->
		<div class="row">

			<div class="col-lg-12">

				<div class="col-lg-3 no-paddings bg-muted">
					<div class="ibox-content">
						<div id="container1"
							class="p-xs b-r-lg border-left-right border-top-bottom border-size-sm"></div>
					</div>
				</div>



				<div class="col-lg-9 no-paddings bg-muted">
					<div class="ibox-content">
						<div id="container2"
							class="p-xs b-r-lg border-left-right border-top-bottom border-size-sm"></div>
					</div>
				</div>

			</div>


		</div>
		<!-- row1 end -->
		<br>


		<br>

		<!-- row3 start -->
		<div class="row">
			<div class="col-lg-12">
				<div class="col-lg-7">
					<div class="ibox-content" style="height: 672px !important;">
						<div id="container" style="height: 641px !important;"
							class="p-xs b-r-lg border-left-right border-top-bottom border-size-sm"></div>

						<table id="datatable" style="display: none;">
							<thead>
								<tr>

									<th>Time</th>
									<th><%=request.getParameter("headname")%></th>
								</tr>
							</thead>
							<tbody>
								<%=attendanceData%>
							</tbody>
						</table>
					</div>
				</div>
				<div class="col-lg-5">
				<div class="ibox white-bg" style="padding-top: 5px; height: 672px !important;"">
				<%=new ColourCodeUitls().getColourCodeForReports() %>
					<div class="ibox-content">
						<%
							CalenderUtils calUtil = new CalenderUtils();
							HashMap<String, String> input_params = new HashMap();
							input_params.put("org_id", college_id + "");
							if (request.getParameterMap().containsKey("course_id")
									&& !request.getParameter("course_id").toString().equalsIgnoreCase("null")) {
								input_params.put("course_id", request.getParameter("course_id"));
							} else if (request.getParameterMap().containsKey("batch_id")
									&& !request.getParameter("batch_id").toString().equalsIgnoreCase("null")) {
								input_params.put("batch_id", request.getParameter("batch_id"));
							}
						%>
						<%=calUtil.getCalender(input_params).toString()%>
					</div></div>
				</div>

			</div>
		</div>
		<!-- row3 end -->
		<br>

		<!-- row4 start -->
		<div class="row">

			<div class="<%=flag ? "col-lg-12" : "col-lg-6"%>">
				<div class="ibox-content profile-content">
					<h3 class="font-bold">Students Enrolled in <%=courseName %></h3>
					<div class="ibox-content student_content_holder" style="height: 228px !important;">
						<div id="student_list_container">
							<%
								if (student_list.size() > 0) {
									for (HashMap<String, Object> item : student_list) {
							%>
							<div class="col-lg-2">
								<div
									class="product-box p-xl b-r-lg border-left-right border-top-bottom text-center student_holder" data-course_id="<%=course_id%>" data-target="<%=item.get("student_id").toString()%>">
									<div data-target="#<%=item.get("student_id").toString()!= null ?item.get("student_id").toString():""%>"
										class='holder-data'>
										<img alt="image" class="img-circle m-t-sm student_image"
											src="<%=item.get("profile_image").toString()%>" />
										<p class="m-r-sm m-t-sm"><%=item.get("first_name").toString()!= null ?item.get("first_name").toString():""%></p>
									</div>
									<div class="modal inmodal"
									id="student_card_modal"	data-student_id="<%=item.get("student_id").toString()%>" tabindex="-1"
										role="dialog" aria-hidden="true">


</div>

								</div>

							</div>

							<%
								}
								} else {
							%>
							<%
								if (request.getParameter("headname") != null
											&& !request.getParameter("headname").toString().equalsIgnoreCase("null")) {
							%>

							<p class="text-danger">
								<strong>No students has enrolled for <%=request.getParameter("headname").toString()%></strong>
							</p>
							<%
								}
							%>
							<%
								}
							%>
						</div>
						<div class="col-lg-12 text-center">
							<div id="page-selection"></div>
						</div>
					</div>
				</div>
			</div>

			<div class="<%=flag ? "hidden-holder" : "col-lg-6"%>">
				<div
					class="ibox p-xs  b-r-lg border-left-right border-top-bottom border-size-sm"
					style="background: #eee;">
					<div class="tabs-container">
						<ul class="nav nav-tabs">
							<li class="active col-lg-6 text-center no-padding bg-muted"><a data-toggle="tab"
								href="#tab1">Sessions</a></li>
							<li class="col-lg-6 text-center no-padding bg-muted"><a data-toggle="tab"
								href="#tab2">Assessments</a></li>
						</ul>

						<div class="tab-content">
							<div id="tab1" class="tab-pane active">
								<div class="panel-body">
									<div id="batch_session_content" class="row">
										<%
											if (!flag) {
										%>
										<jsp:include page="./batch_session_model_data.jsp">
											<jsp:param value='<%=request.getParameter("batch_id")%>'
												name="batch_id" />
										</jsp:include>
									</div>
									<div class="m-t-sm text-center">
										<div id="session-page-selection"
											data-batch='<%=request.getParameter("batch_id")%>'
											data-size='<%=sessionCount%>'></div>
									</div>
									<%
										}
									%>
								</div>
							</div>

							<div id="tab2" class="tab-pane">
								<div class="panel-body">
									<%if (!flag) {%>
									<div id="batch_assessment_content" class="row">
										<jsp:include page="./batch_assessment_model_data.jsp">
											<jsp:param value='<%=request.getParameter("batch_id")%>' name="batch_id" />
										</jsp:include>
									</div>
									<div class="m-t-sm text-center">
										<div id="assessment-page-selection"
											data-batch='<%=request.getParameter("batch_id")%>' data-size='<%=assessmentCount%>'></div>
									</div>
									<%}%>
								</div>

							</div>

						</div>
					</div>
				</div>
			</div>

		</div>
		<!-- row4 end -->



	</div>
	<!-- page wrapper end -->

</div>
<!-- Mainly scripts -->


