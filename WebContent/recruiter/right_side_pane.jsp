<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="com.istarindia.apps.dao.StudentDAO"%>
<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<% 
	
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	int studentID = Integer.parseInt(request.getParameter("student_id"));
	//String stage_ID = (request.getParameter("stage_id").toString().split("--")[1]);
	//int vacancy_ID = Integer.parseInt(request.getParameter("stage_id").toString().split("--")[0]);
	//int recID = (new VacancyDAO()).findById(vacancy_ID).getRecruiter().getId();
	Student student = new StudentDAO().findById(studentID);
	String location = student.getAddress().getPincode().getCity();//+", "+student.getAddress().getPincode().getState();
	String college =( student.getCollege()!=null)? student.getCollege().getName() : "N/A";
	String degree ="N/A";
	String intrested_job_domains = "N/A";
	String fname=student.getName();
	//String lastname="";
	if(student.getStudentProfileData()!=null)
	{		
		//fname= (student.getStudentProfileData().getFirstname()!=null)? student.getStudentProfileData().getFirstname() : student.getEmail(); 
		//lastname= (student.getStudentProfileData().getLastname()!=null)? student.getStudentProfileData().getLastname() : "";
		 degree =(student.getStudentProfileData().getUnderGraduationSpecializationName()!=null)? student.getStudentProfileData().getUnderGraduationSpecializationName() : "N/A";
		 intrested_job_domains =( student.getStudentProfileData().getJobSector()!=null)? student.getStudentProfileData().getJobSector() : "N/A";
	}
	 
	RecruiterServices serv = new RecruiterServices();
	List<HashMap<String, Object>> skillrating = serv.getStudentRatingPerskill(student.getId());
	
	String[] bar_colors = {"red","yellow","orange","green","blue","grey","purple","resort"};
	%>

<!-- style="overflow-y: scroll; height: 41vh; overflow-x: hidden;" -->
<div class="student_card">
	<div class="ibox float-e-margins">
		<div>
			<div class="row" style="margin-bottom: 20px;">
				<div class="col-md-4">
					<img alt="image" class="img-responsive all_border"
						src="<%=student.getImageUrl()%>">
				</div>

				<div class=" col-md-8">
					<h4 style="font-size: 16px;">
						<strong><%=StringUtils.capitalize(fname) %> </strong>
					</h4>
					<p style="font-size: 14px;">
						<%=location %></p>
					<hr class="top_border" />
					<p style="font-size: 16px;">
						<Strong><%=college %> </Strong><br />
						
					</p>
					<p style="font-size: 14px;">
										<%
							String ugDegreeName = student.getStudentProfileData().getUnder_graduate_degree_name();
								if (ugDegreeName != null && !ugDegreeName.trim().isEmpty()) {
						%>
						<br> <small class="text-muted batch_name_name"><%=ugDegreeName%></small>
						<%
							String ugDegreeSpecialization = student.getStudentProfileData()
											.getUnderGraduationSpecializationName();
									if (ugDegreeSpecialization != null && !ugDegreeSpecialization.trim().isEmpty()) {
						%>
						<small class="text-muted batch_name_name">(<%=ugDegreeSpecialization%>)
						</small>
						<%
							}
								}
							String pgDegreeName	= student.getStudentProfileData().getPg_degree_name();
							if (pgDegreeName != null && !pgDegreeName.trim().isEmpty()) {	
						%>
						<br><small class="text-muted batch_name_name"><%=pgDegreeName%></small>
						<%
							String pgDegreeSpecialization = student.getStudentProfileData()
											.getPostGraduationSpecializationName();
								if (pgDegreeSpecialization != null && !pgDegreeSpecialization.trim().isEmpty()) {
						%>
						<small class="text-muted batch_name_name">(<%=pgDegreeSpecialization%>)
						</small>
						<%} } %>
					</p>
				</div>
			</div>

			<div class="row" style="padding:20px;">

						<p style="font-size: 16px;">
							<Strong>Skills </Strong>
						</p>
				<div>

					<div class="ibox-content skills">
						<div class="user-button">
						<%
						if (skillrating.size() == 0) {
						%>
						<h4>Skill Rating Not Available</h4>
						<%	
						}
						else
						{	
						%>
						<ul class="stat-list">
						<%
						for (HashMap<String, Object> row : skillrating) {
							int country_percentile = (int) row.get("percentile_country");
							int bar1=0;
							int bar2=0;
							int bar3=0;
							int bar4=0;
							int quotient = country_percentile/25;
							 int remiander = country_percentile%25;
							if(quotient==0)
							{
								 bar1=0;
								 bar2=0;
								 bar3=0;
								 bar4=0;
							}	
							else if (quotient==1)
							{
								 bar1=100;
								
								 bar2=remiander;
								 bar3=0;
								 bar4=0;
							}
							else if (quotient==2)
							{
								 bar1=100;
								 bar2=100;
								 bar3=remiander;
								 bar4=0;
							}
							else if (quotient==3)
							{
								 bar1=100;
								 bar2=100;
								 bar3=100;
								 bar4=remiander;
							}
							else if (quotient==4)
							{
								 bar1=100;
								 bar2=100;
								 bar3=100;
								 bar4=100;
							}
						
						%>			
						
                                        <li style="padding-bottom: 12px;">
                                            <h2 class="no-margins" style="    font-size: 14px;padding-bottom: 4px;"><%=(String) row.get("skill_title") %></h2>
                                           <div class="row">
                                           	<div class="col-md-3">
                                           	 <div class="progress progress-mini">
                                                <div style="width: <%=bar1%>%;" class="progress-bar"></div>
                                            </div>
                                            <center><i style="font-size: 11px;padding-bottom: 4px;">Novice</i></center>
                                           	</div>
                                           		<div class="col-md-3">
                                           		 <div class="progress progress-mini">
                                                <div style="width: <%=bar2%>%;" class="progress-bar"></div>
                                            </div>
                                             <center><i style="font-size: 11px;padding-bottom: 4px;">Apprentice</i></center>
                                           	</div>
                                           		<div class="col-md-3">
                                           		 <div class="progress progress-mini">
                                                <div style="width: <%=bar3%>%;" class="progress-bar"></div>
                                            </div>
                                            <center><i style="font-size: 11px;padding-bottom: 4px;">Master</i></center>
                                           	</div>
                                           		<div class="col-md-3">
                                           		 <div class="progress progress-mini">
                                                <div style="width: <%=bar4%>%;" class="progress-bar"></div>
                                            </div>
                                             <center><i style="font-size: 11px;padding-bottom: 4px;">Wizard</i></center>
                                           	</div>
                                           </div> 
                                        </li>
                                        
                                        <%
						}
                                        %>
                                        </ul>
						<%
						}
						%>
						
						
						
						</div>
					</div>

				</div>
			</div>

		</div>
	</div>


	<%-- 	<div class="tabs-container" style="min-height: 515px;">
	<ul class="nav nav-tabs">
		<li class="active"><a data-toggle="tab" href="#tab-filter-<%=request.getParameter("stage_id") %>"
			aria-expanded="true">Filter Criteria</a></li>
		<li class=""><a data-toggle="tab" href="#tab-notif-<%=request.getParameter("stage_id") %>"
			aria-expanded="false">Student Notifications</a></li>
	</ul>
	<div class="tab-content">
		<div id="tab-filter-<%=request.getParameter("stage_id") %>" class="tab-pane active" >
			<div class="panel-body" style="width:100% !important; min-height: 450px !important; height:450px; max-height: 450px !important; ">
				<jsp:include page="criteria_view.jsp">
				<jsp:param value="<%=vacancy_ID%>" name="vacancy_id" />
				<jsp:param value="<%=stage_ID %>" name="stage_id" />
				</jsp:include>
			</div>
		</div>
		<div id="tab-notif-<%=request.getParameter("stage_id") %>" class="tab-pane">
			<div class="panel-body" style="width:100% !important;">
				<jsp:include page="chat_view.jsp"></jsp:include>
			</div>
		</div>
	</div>


</div> --%>
</div>
