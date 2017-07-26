<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
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
IstarUser user = (IstarUser) request.getSession().getAttribute("user");
//System.err.println("--------------"+user.getEmail());
String roleName = user.getUserRoles().iterator().next().getRole().getRoleName();
if(roleName.equalsIgnoreCase("ORG_ADMIN"))
{
	%>
	<jsp:include page="/inc/head.jsp"></jsp:include>
	<% 
}
else if(roleName.equalsIgnoreCase("SUPER_ADMIN")) 
{
	%>
	<jsp:include page="/inc/head.jsp"></jsp:include>
	<%
	
	}	
%>
<body class="top-navigation" id="orgadmin_report_detail">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<!--  -->
	<%	
		if(roleName.equalsIgnoreCase("ORG_ADMIN"))
{
	%>

	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<% 
}
else if(roleName.equalsIgnoreCase("SUPER_ADMIN")) 
{
	%>
	
	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<%
	
	}	
%>

<%
int college_id = Integer.parseInt(request.getParameter("college_id"));
	
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	request.setAttribute("base_url", baseURL);
	ReportUtils util = new ReportUtils();
	
	UIUtils uiUtil = new UIUtils();
	boolean flag = false;
	JsonUIUtils jsonUIUtils = new JsonUIUtils();
	JSONArray pieChartData = null;
	StringBuffer attendanceData = null;
	JSONArray calendardata = null;
	String batch_id=null;
	String course_id=null;
	ArrayList<JSONArray> barChartData = null;
	int studentcount = 0;
	int courseOrBatchId = 0;
	List<HashMap<String, Object>> student_list = null;
		int sessionCount = 0;
		int assessmentCount=0;
		String courseName="";
	if (request.getParameter("course_id") != null && !request.getParameter("course_id").toString().equalsIgnoreCase("null")){
		flag = true;
		//System.out.println("course_id -------"+request.getParameter("course_id").toString());
		Course course = new CourseDAO().findById(Integer.parseInt(request.getParameter("course_id").toString()));
		courseName = course.getCourseName();		
		course_id =request.getParameter("course_id");		
		studentcount = jsonUIUtils.getStudentCountfromCourse(Integer.parseInt(request.getParameter("course_id").toString()), college_id,"Program");
		student_list = jsonUIUtils.getStudentlistfromCourse(Integer.parseInt(request.getParameter("course_id").toString()), college_id,"Program");
		courseOrBatchId = Integer.parseInt(request.getParameter("course_id").toString());		
		calendardata =uiUtil.getCourseReportEvent(college_id,Integer.parseInt(request.getParameter("course_id").toString()),"Program");
	} else if (request.getParameter("batch_id") != null && !request.getParameter("batch_id").toString().equalsIgnoreCase("null")){
		flag = false;
		Batch batch = new BatchDAO().findById(Integer.parseInt(request.getParameter("batch_id").toString()));
		course_id = batch.getCourse().getId()+"";
		courseName = batch.getCourse().getCourseName();
		//System.out.println("batch_id--------"+request.getParameter("batch_id").toString());
		batch_id =request.getParameter("batch_id");		
		studentcount = jsonUIUtils.getStudentCountfromCourse(Integer.parseInt(request.getParameter("batch_id").toString()), college_id,"Batch");
		student_list = jsonUIUtils.getStudentlistfromCourse(Integer.parseInt(request.getParameter("batch_id").toString()), college_id,"Batch");
		courseOrBatchId = Integer.parseInt(request.getParameter("batch_id").toString());
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
</div>

<div collegeid="<%=college_id%>" id="myid"
	data-course="<%=courseOrBatchId %>" type="<%=flag%>"></div>

		<div class="row wrapper border-bottom white-bg page-heading">
			<div class="col-lg-9">
				<% if(request.getParameter("headname") != null && !request.getParameter("headname").toString().equalsIgnoreCase("null")){
				 %>
				

<h2>					
<ol class="breadcrumb" style="margin-left: 14px;     color: rgb(235, 56, 79);">
               <% 
               String reportPageUrl="super_admin/analytics.jsp";
               
               if(roleName.equalsIgnoreCase("ORG_ADMIN"))
{
            	   reportPageUrl=baseURL+"/orgadmin/report.jsp";
	%>
	<jsp:include page="/inc/head.jsp"></jsp:include>
	<% 
}
else if(roleName.equalsIgnoreCase("SUPER_ADMIN")) 
{
	reportPageUrl=baseURL+"/super_admin/analytics.jsp";
	%>
	<jsp:include page="/inc/head.jsp"></jsp:include>
	<%
	
	}
               
    %> 


            <li>
                <%if(request.getParameter("batch_id") != null && !request.getParameter("batch_id").toString().equalsIgnoreCase("null")){ %>
              
              
          
                
                <a href="<%=reportPageUrl %>">Batches</a>
                <%}
                else
                {
                	%>
                   <a href="<%=reportPageUrl %>">Program</a>
                    <%
                	
                }%>
            </li>
            <li class="active">
                <%=request.getParameter("headname").toString()%>

          </li>

        </ol>
        </h2>	
       
			</div>
			<% } %>
		</div>
		<!-- row1 start -->
		<div class="row">

			<div class="col-lg-12">

				<div class="col-lg-3 no-paddings bg-muted">
					<div class="ibox-content">
						<%HashMap<String, String> conditions = new HashMap();
								  
							      conditions.put("college_id", college_id+"");
							      if(request.getParameter("batch_id") != null && !request.getParameter("batch_id").toString().equalsIgnoreCase("null")){
							    	  conditions.put("batch_id", batch_id);  
							    	 %>
							    	 <%= util.getHTML(3048, conditions) %>
							    	 <% 
							      }
							      
							      if(request.getParameter("course_id") != null && !request.getParameter("course_id").toString().equalsIgnoreCase("null")){
							    	  conditions.put("course_id", course_id); 
							    	  %>
								    	 <%= util.getHTML(3050, conditions) %>
								    	 <%
							      }
				%>
					</div>
				</div>



				<div class="col-lg-9 no-paddings bg-muted">
					<div class="ibox-content">
						 <%-- <%
						 HashMap<String, String> conditions1 = new HashMap();
			      
			      conditions1.put("college_id", college_id+"");
			      if(request.getParameter("batch_id") != null && !request.getParameter("batch_id").toString().equalsIgnoreCase("null")){
			    	  conditions1.put("batch_id", batch_id);  
			    	  %>
				    	 <%= util.getHTML(3049, conditions1) %>
				    	 <%
			      }
			      
			      if(request.getParameter("course_id") != null && !request.getParameter("course_id").toString().equalsIgnoreCase("null")){
			    	  conditions1.put("course_id", course_id); 
			    	  %>
				    	 <%= util.getHTML(3051, conditions1) %>
				    	 <%
			      }			      			      
				%>				 --%>
				
				<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>				
					</div>
				</div>

			</div>


		</div>
		<!-- row1 end -->
		


		<!-- row3 start -->
		<div class="row" style="margin-top: 15px;">
			<div class="col-lg-12">
				<div class="col-lg-7">
					<div class="ibox-content" style="height: 582px !important;">
						<%ReportUtils repUtils = new ReportUtils();
						if(request.getParameterMap().containsKey("course_id") && !request.getParameter("course_id").toString().equalsIgnoreCase("null"))
						{
							HashMap<String, String> conditions3 = new HashMap();
							conditions3.put("course_id", request.getParameter("course_id").toString());
							conditions3.put("college_id", college_id+"");
							%>
							<%=repUtils.getHTML(3053, conditions3) %>	
							<% 
						}
						else
						{
							HashMap<String, String> conditions3 = new HashMap();
							conditions3.put("batch_id", request.getParameter("batch_id").toString());
						%>
						<%=repUtils.getHTML(3054, conditions3) %>	
						<% 
						}	
							%>				
					</div>
				</div>
				<div class="col-lg-5">
				<div class="ibox white-bg" style="padding-top: 5px;    height: 582px !important;">
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
					<!-- event details modal -->

								<div class="modal inmodal" id="event_details" tabindex="-1"
									role="dialog" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event_details">

										</div>
									</div>
								</div>


		<!--  -->
		<!-- modal -->

								<div class="modal inmodal" id="myModal2" tabindex="-1"
									role="dialog" aria-hidden="true">
									<%-- <input id="orgID" type="hidden" value="<%=colegeID %>" /> --%>
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event-edit-modal">

										</div>
									</div>
								</div>
								<!--  -->
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
									

								</div>
								<div class="modal inmodal"
									id="student_card_modal"	data-student_id="<%=item.get("student_id").toString()%>" tabindex="-1"
										role="dialog" aria-hidden="true">


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





<!-- Mainly scripts -->




		<!--  -->
		</div>
</div>
		<%	
		if(roleName.equalsIgnoreCase("ORG_ADMIN"))
{
	%>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<% 
}
else if(roleName.equalsIgnoreCase("SUPER_ADMIN")) 
{
	%>
	
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<%
	
	}	
%>
<script>
$(document).ready(function(){
	$(function () {

		var flag = <%=flag%>;
		var queryString ='';
		if(flag)
		{
			var course_id = <%=course_id%>;
			var college_id = <%=college_id%>;
			queryString ='course_id='+course_id+'&college_id='+college_id;
		}
		else
		{
			var batch_id = <%=batch_id%>;
			var college_id = <%=college_id%>;
			queryString ='batch_id='+batch_id+'&college_id='+college_id;
		}	
		var moduleLevelData = [];  
		var sessionLevelData ={} ;  
		 $.ajax({
	          url: "<%=baseURL%>/get_admin_skill_graph",
	          cache: false,
	          type:  "POST",
	          data:  "type=MODULE_LEVEL&"+queryString,
	          success: function(data){
	        	  var data = JSON.parse(data);
	        	  moduleLevelData = data;
	        	  
	        	  $.ajax({
	    	          url: "<%=baseURL%>/get_admin_skill_graph",
	    	          cache: false,
	    	          type:  "POST",
	    	          data:  "type=SESSION_LEVEL&"+queryString,
	    	          success: function(data2){
	    	        	  var data = JSON.parse(data2);
	    	        	  sessionLevelData = data2;
	    	        	  loadSkillChart(moduleLevelData,sessionLevelData);
	    	          }
	    	        });
	        	  
	        	  
	          }
	        });
		 
		
		
		 

	});
	
});

function loadSkillChart(moduleLevelData,sessionLevelData)
{
	
	
	  $('#container').highcharts({
	        chart: {
	            type: 'column',
	            events: {
	                drilldown: function (e) {
	                    if (!e.seriesOptions) {
	                        var chart = this,	                            
	                            
	                            drilldowns = JSON.parse(sessionLevelData),
	                            series = drilldowns[e.point.name];	                	        
	                	      	for(var i=0; i< series.length; i++){ 	
	                        chart.addSingleSeriesAsDrilldown(e.point, series[i]);	                       
	                	      	}
	                        chart.applyDrilldown();
	                    }

	                }
	            }
	        },
	        credits: {
	            enabled: false
	          },
	        title: {
	            text: 'Mastery Level Per Skill'
	        },
	        xAxis: {
	            type: 'category'
	        },

	        legend: {
	            enabled: true
	        },

	        plotOptions: {
	            series: {
	                stacking: 'percent	',
	                borderWidth: 0,
	                dataLabels: {
	                    enabled: false
	                }
	            }, 
	            dataLabels: {
	                enabled: false,
	                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
	            }
	        },

	        series: moduleLevelData,

	        drilldown: {
	            series: []
	        }, 
	        
	        yAxis: {
	            min: 0,
	            title: {
	                text: 'Percentage'
	            },
	            stackLabels: {
	                enabled: false,
	                style: {
	                    fontWeight: 'bold',
	                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
	                }
	            }
	        },
	    });
	
	}

</script>

</body>

