<%@page import="com.viksitpro.core.dao.entities.Batch"%>
<%@page import="com.viksitpro.core.dao.entities.BatchDAO"%>
<%@page import="in.superadmin.services.ReportDetailService"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.*"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.*"%>


<%
int college_id = (int)request.getSession().getAttribute("orgId");
	
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
	if (request.getParameter("course_id") != null && !request.getParameter("course_id").toString().equalsIgnoreCase("null")){
		flag = true;
		Course course = new CourseDAO().findById(Integer.parseInt(request.getParameter("course_id").toString()));
		courseName = course.getCourseName();
		System.out.println("course_id -------"+request.getParameter("course_id").toString());
		pieChartData = jsonUIUtils.getPieChartData(Integer.parseInt(request.getParameter("course_id").toString()), college_id,"Program");
		barChartData = jsonUIUtils.getBarChartData(Integer.parseInt(request.getParameter("course_id").toString()), college_id,"Program");
		studentcount = jsonUIUtils.getStudentCountfromCourse(Integer.parseInt(request.getParameter("course_id").toString()), college_id,"Program");
		student_list = jsonUIUtils.getStudentlistfromCourse(Integer.parseInt(request.getParameter("course_id").toString()), college_id,"Program");
		courseOrBatchId = Integer.parseInt(request.getParameter("course_id").toString());
		attendanceData = jsonUIUtils.getAttendanceReport(Integer.parseInt(request.getParameter("course_id").toString()),"Program");
		calendardata =uiUtil.getCourseReportEvent(college_id,Integer.parseInt(request.getParameter("course_id").toString()),"Program");
	} else if (request.getParameter("batch_id") != null && !request.getParameter("batch_id").toString().equalsIgnoreCase("null")){
		flag = false;
		Batch batch = new BatchDAO().findById(Integer.parseInt(request.getParameter("batch_id").toString()));
		courseName = batch.getCourse().getCourseName();
		System.out.println("batch_id--------"+request.getParameter("batch_id").toString());

		pieChartData = jsonUIUtils.getPieChartData(Integer.parseInt(request.getParameter("batch_id").toString()), college_id,"Batch");
		barChartData = jsonUIUtils.getBarChartData(Integer.parseInt(request.getParameter("batch_id").toString()), college_id,"Batch");
		studentcount = jsonUIUtils.getStudentCountfromCourse(Integer.parseInt(request.getParameter("batch_id").toString()), college_id,"Batch");
		student_list = jsonUIUtils.getStudentlistfromCourse(Integer.parseInt(request.getParameter("batch_id").toString()), college_id,"Batch");
		courseOrBatchId = Integer.parseInt(request.getParameter("batch_id").toString());
		attendanceData = jsonUIUtils.getAttendanceReport(Integer.parseInt(request.getParameter("batch_id").toString()),"Batch");
		calendardata =uiUtil.getCourseReportEvent(college_id,Integer.parseInt(request.getParameter("batch_id").toString()),"Batch");
		
		List<HashMap<String, Object>> items = new ReportDetailService().getAllSessions(Integer.parseInt(request.getParameter("batch_id")), 0, true);
		sessionCount = items.size();
		items = new ReportDetailService().getAllAssessments(Integer.parseInt(request.getParameter("batch_id")), 0, true);
		assessmentCount=items.size();
	}
	int nosofpages=0;
	if(studentcount % 6 ==0){
		nosofpages =studentcount/6;
	}else{
		nosofpages =(studentcount/6)+1;
	}
	
%>


<div id="data-holder" style='display: none;'>
	<div id='nosofpages' data-content='<%=nosofpages%>'></div>
	<div id='pieChartData' data-content='<%=pieChartData%>'></div>
	<div id='barchartTitle' data-content='<%=barChartData.get(0)%>'></div>
	<div id='barchartContent' data-content='<%=barChartData.get(1)%>'></div>
</div>

<div collegeid="<%=college_id%>" id="myid"
	data-course="<%=courseOrBatchId %>" type="<%=flag%>"></div>
<div id="wrapper">
	<div id="page-wrapper" class="gray-bg">
		<div class="row wrapper border-bottom white-bg page-heading">
			<div class="col-lg-9">
				<% if(request.getParameter("headname") != null && !request.getParameter("headname").toString().equalsIgnoreCase("null")){
				 %>
				<h2>
					&nbsp;&nbsp;&nbsp;&nbsp; Report for
					<%=request.getParameter("headname").toString()%></h2>

			</div>
			<% } %>
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

		<%-- <!-- row2 start -->
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox">
					<div class="ibox-content skill-overflow" id="ibox-content">
						<h2>Skill Level</h2>
						<div class="m-l-xl tooltip-demo custom-skill-level">
							<%
							List <HashMap<String, Object>> jobData = new ArrayList();
							if(request.getParameter("course_id") != null && !request.getParameter("course_id").toString().equalsIgnoreCase("null"))
							{
								int c_id = Integer.parseInt(request.getParameter("course_id")); 
								jobData = uiUtil.getJobMasterLevelForCourse(c_id);
							}
							else if(request.getParameter("batch_id") != null && !request.getParameter("batch_id").toString().equalsIgnoreCase("null"))
							{
								int b_id = Integer.parseInt(request.getParameter("batch_id")); 
								jobData = uiUtil.getJobMasterLevelForBatch(b_id);
							}	
							if(jobData != null){
							
									for (HashMap<String, Object> row: jobData) {
										
										String title =(String) row.get("title");
										String companyUrl = (String)row.get("company_image");
										int wizard_level = (int) row.get("wizard_level");
										int master_level = (int) row.get("master_level");
										int apprentice_level = (int) row.get("apprentice_level");
										int rookie_level = (int) row.get("rookie_level");
								%>
							<div class="tip-top inner-level" data-toggle="tooltip"
								data-placement="top"
								title="<h4><%=title %></h4>
							<p>Rookie: <%=rookie_level%>%<br> Apprentice: <%=apprentice_level%>%<br> Master: <%=master_level%>%<br>
							 wizard: <%=wizard_level%>%<br></p>"
								data-original-title="">
								<img class="img-circle skill-img" src="<%=companyUrl%>"></img>
							</div>

							<%
									//if (m != 9) {
								%>
							<div class="between-div">
								<hr class="between">
							</div>
							<%
									//}
								}}
								%>
						</div>

					</div>
				</div>
			</div>
		</div>
		<!-- row2 end --> --%>
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
									<th><%=request.getParameter("headname")  %></th>
								</tr>
							</thead>
							<tbody>
								<%=attendanceData %>
							</tbody>
						</table>
					</div>
				</div>
				<div class="col-lg-5">
				<div class="ibox white-bg" style="padding-top: 5px;    height: 672px !important;">
				<%=new ColourCodeUitls().getColourCodeForReports() %>
					<div class="ibox-content">
						<%
						CalenderUtils  calUtil = new CalenderUtils();
						HashMap<String, String> input_params = new HashMap();
						input_params.put("org_id",college_id+"");
						if(request.getParameterMap().containsKey("course_id") && !request.getParameter("course_id").toString().equalsIgnoreCase("null"))
						{
							input_params.put("course_id",request.getParameter("course_id"));
						}
						else if(request.getParameterMap().containsKey("batch_id") && !request.getParameter("batch_id").toString().equalsIgnoreCase("null"))
						{
							input_params.put("batch_id",request.getParameter("batch_id"));
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
					<h3 class="font-bold">Students Enrolled In <%=courseName %></h3>
					<div class="ibox-content student_content_holder">
						<div id="student_list_container">
							<%
								if (student_list.size() > 0) {
									FlashXMLReportService service = new FlashXMLReportService();
									for (HashMap<String, Object> item : student_list) {
										XMLStudentReport stuReport = service.getStudentReport(Integer.parseInt(item.get("student_id").toString()), skillId);
										XMLSkillReportLAData skillData= new XMLSkillReportLAData();
										if(stuReport!=null && stuReport.getOverAllData()!=null)
										{
											skillData = stuReport.getOverAllData();
										}
							%>
							<div class="col-lg-2">
								<div
									class="product-box p-xl b-r-lg border-left-right border-top-bottom text-center student_holder">
									<div data-target="#<%=item.get("student_id").toString()%>"
										class='holder-data'>
										<img alt="image" class="img-circle m-t-sm student_image"
											src="<%=item.get("profile_image").toString()%>" />
										<p class="m-r-sm m-t-sm"><%=item.get("name").toString()%></p>
									</div>
									<div class="modal inmodal"
										id="<%=item.get("student_id").toString()%>" tabindex="-1"
										role="dialog" aria-hidden="true">
										<div class="modal-dialog">
											<div class="modal-content animated flipInY">
												<div class="modal-header" style="padding: 13px 18px !important;">
												
													<button type="button" class="close" data-dismiss="modal">
														<span aria-hidden="true">&times;</span><span
															class="sr-only">Close</span>
													</button>
													  <div class="m-b-md">
                            <h2 class="font-bold no-margins">
                                <%=item.get("name").toString()%>
                            </h2>
                                
                                 <div>
                                <span class="fa fa-envelope m-r-xs"></span>
                               
                                <%=item.get("email").toString()%> |
                                 <span class="fa fa-phone m-r-xs"></span>
                               
                                <%=item.get("mobileno").toString()%>
                            </div>
                            </div>
												</div>
												<div class="modal-body" style="padding: 0px 30px 9px 30px !important">												
                        <div class="widget-head-color-box navy-bg p-lg text-center" style="padding:9px !important;">
                          
                             <div class="row">
                             <div class="col-md-4">
                           
                                <h2 class="font-bold">#<%=skillData.getRank()%></h2>
                                 <h3> <span> Batch Rank </span></h3>
                             </div>
                             <div class="col-md-4">
                              <img src=" <%=item.get("profile_image").toString()%>" class="img-circle circle-border m-b-md" alt="profile" style="width: 128px;    height: 128px;">
                             
                             </div>
                             <div class="col-md-4">
                              <h2 class="font-bold"><%=skillData.getPointsEarned() %></h2>
                                 <h3> <span> Points Earned </span></h3>
                             </div>
                            </div>
                            
                            
                        </div> 
                        
                        <%
                        if(skillData!=null && skillData.getSubSkills()!=null)
                        {
                        %>                      
                            <div class="col-lg-12" style="    padding-left: 0px;    padding-right: 0px;    margin-top: 32px;">
                    <!--  -->
                    <div class="ibox ">
                        <div class="ibox-title">
                            <h5>Skill Profile</h5>
                        </div>
                        <div class="ibox-content" >
                        <div class="full-height div-scroll-height-2"
				style="height: 232px !important;">
				<div class="full-height-scroll">
		  
		    <% for(XMLSkillReportLAData subSkill:  skillData.getSubSkills()){%>
		        <div class="col-md-12" style="padding-left: 0px !important;">
		            <ul class="tree1">
		                <li><%=subSkill.getSkillName()%>
		                    <ul> 
		                    <% int percentagesubSkill=1;
                                            	
                                            	if(subSkill.getTotalPoints()!=null && subSkill.getTotalPoints()!=0){
                                                      percentagesubSkill= subSkill.getPointsEarned()*100/subSkill.getTotalPoints();
                                                      if(percentagesubSkill==0)
                                                      {
                                                    	  percentagesubSkill=1;
                                                      }
                                            	}
                                                     %>
		                    <div class="progress " >
		                                <div style="width: <%=percentagesubSkill%>%; padding:20px;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="<%=percentagesubSkill%>" role="progressbar" class="progress-bar ">
		                                    
		                                </div>
		                            </div>
		                        <p><%=subSkill.getPointsEarned() %> / <%=subSkill.getTotalPoints()%> Points.</p>
		                     <%if(subSkill.getSubSkills().size()>0)
                                        	{%>
                                        	<%for(XMLSkillReportLAData child : subSkill.getSubSkills()){ %>
		                        <li><%=child.getSkillName() %>
		                        
		                         <%
                                                     int percentageChild=1;
                                                 	if(child.getTotalPoints()!=null && child.getTotalPoints()!=0){
                                                 		percentageChild= child.getPointsEarned()*100/child.getTotalPoints();
                                                 		if(percentageChild==0)
                                                 		{
                                                 			percentageChild=1;
                                                 		}
                                                 	}
                                                     %>
		                         <div class="progress"  >
		                                <div style="width: <%=percentageChild%>%; padding:20px;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="<%=percentageChild%>" role="progressbar" class="progress-bar">
		                                    
		                                </div>
		                            </div>
		                        
		                        </li>
		                        
		                       <%}
                                        	
		                       } %>
		                           <!--  <li>Company Maintenance
		                         <div class="progress"  >
		                                <div style="width: 10%; padding:20px;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="35" role="progressbar" class="progress-bar">
		                                    <span class="sr-only">35% Complete (success)</span>
		                                </div>
		                            </div>
		                        
		                        </li> -->
		                    </ul>
		                </li>
		                
		            </ul>
		        </div>
		        <%} %>            

</div></div>
                        </div>

                    </div>
                </div>
                            
                         <%
                        }
                         %>   
                            
                            
                            
                            
                            <!--  -->
                       
                
												
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-primary"
														data-dismiss="modal">Close</button>

												</div>
											</div>
										</div>
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
