<%@page import="com.istarindia.apps.dao.StageActionMapping"%>
<%@page import="java.util.UUID"%>
<%@page import="com.istarindia.apps.dao.IstarTaskWorkflowDAO"%>
<%@page import="com.istarindia.apps.dao.IstarTaskWorkflow"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.apps.dao.College"%>
<%@page import="com.istarindia.apps.dao.Skill"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";

	RecrutUtils utils = new RecrutUtils();
RecruiterServices recruiterServices = new RecruiterServices();
HashMap<Integer, Integer> studentPercentile = null;
String collegeID = "";
String companyID = "";
	HashMap<Integer, Student> student = null;
	int vacancyID = Integer.parseInt(request.getParameter("vacancy_id"));
	String stage_id = (request.getParameter("stage_id"));

	if (request.getParameterMap().containsKey("college_id")){
		collegeID = request.getParameter("college_id");
	}
	if (request.getParameterMap().containsKey("company_id")){
		companyID = request.getParameter("company_id");
	}
	
	student = utils.getUsersForVacancy(vacancyID, stage_id,Integer.parseInt(collegeID.toString()), Integer.parseInt(companyID.toString()));
	
	if(!student.isEmpty()){
	studentPercentile = recruiterServices.getCountryPercentile(student);
	}

	IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stage_id));
	String stageType="";
	String stageAction ="";
	if(stage.getStageActionMappings()!=null && !stage.getStageActionMappings().isEmpty())
	{
		StageActionMapping stage_action_map = stage.getStageActionMappings().iterator().next();
		stageType = stage_action_map.getType();
		stageAction = stage_action_map.getStageAction();
	}
	List<String> allCities = recruiterServices.getCitiesName();

	ArrayList<College> allColleges = recruiterServices.getAllColleges();
	ArrayList<String> ugDegrees = recruiterServices.getUGDegrees();
	ArrayList<String> pgDegrees = recruiterServices.getPGDegrees();
	List<Skill> skills = recruiterServices.getSkills();

	//String imageURL = "/img/user_images/student.png";
%>
<input type="hidden" value=<%=student.size() %> class="student_count_stage" data-stage="<%=stage.getId()%>" data-vacancy="<%=vacancyID%>" data-college="<%=collegeID%>" data-company="<%=companyID%>"/>
<div class="tabs-container row">
		<ul class="nav nav-tabs row list_filter_tab list_filter_tab--<%=stage_id%>-<%=vacancyID%><%=companyID%>" >
			<li class="active col-lg-12"><a data-toggle="tab" aria-expanded="true"
				href="#list_students--<%=stage_id%>-<%=vacancyID%><%=companyID%>" style="border:none;">Students List</a></li>
		</ul>
		<div class="row select_all_pane border-top">
				<div class="pull-right" style="    margin-top: 10px;"><label>Select All</label>
				<input type="checkbox" class="i-checks allCheck select_all_students-<%=stage_id%>" data-stage="<%=stage_id%>" data-vacancy=<%=vacancyID%> data-college="<%=companyID%>" data-checked="false"/>			
				</div>
		</div>
	<div class="tab-content list_filter_pane" style="height:920px; background-color:white">

	<div id="list_students--<%=stage_id%>-<%=vacancyID%><%=companyID%>" class="tab-pane active" >
				<div class="feed-activity-list" data-vacancy=<%=vacancyID%>>
					<%
					int countStudents = 0;
						for (Integer st : student.keySet()) {
							if(countStudents < 15){
					%>
										<div data-vacancy_id="<%=vacancyID%>"
						class="feed-element student_holder_actor row"
						data-stage_id="<%=vacancyID%>--<%=stage_id%>"
						data-stage="<%=stage_id%>" id="<%=student.get(st).getId()%>" data-college="<%=companyID%>">

							<a class="col-lg-2 profile_image_link"> <img alt="image" class="img-circle profile_image student_image-<%=student.get(st).getId()%>"
								data-percentile="<%=studentPercentile.get(student.get(st).getId())%>" src="<%=student.get(st).getImageUrl()%>" data-student="<%=student.get(st).getId()%>">
							</a>
							
					<div class="student_details_pane col-lg-7">
						<strong class="student_name"><%=student.get(st).getName()%></strong>
						<br> <small class="text-muted organization_name"><%=student.get(st).getCollege().getName()%></small>
						<%
							String ugDegreeName = student.get(st).getStudentProfileData().getUnder_graduate_degree_name();
								if (ugDegreeName != null && !ugDegreeName.trim().isEmpty()) {
						%>
						<br> <small class="text-muted batch_name_name"><%=ugDegreeName%></small>
						<%
							String ugDegreeSpecialization = student.get(st).getStudentProfileData()
											.getUnderGraduationSpecializationName();
									if (ugDegreeSpecialization != null && !ugDegreeSpecialization.trim().isEmpty()) {
						%>
						<small class="text-muted batch_name_name">(<%=ugDegreeSpecialization%>)
						</small>
						<%
							}
								}
							String pgDegreeName	= student.get(st).getStudentProfileData().getPg_degree_name();
							if (pgDegreeName != null && !pgDegreeName.trim().isEmpty()) {	
						%>
						<br><small class="text-muted batch_name_name"><%=pgDegreeName%></small>
						<%
							String pgDegreeSpecialization = student.get(st).getStudentProfileData()
											.getPostGraduationSpecializationName();
								if (pgDegreeSpecialization != null && !pgDegreeSpecialization.trim().isEmpty()) {
						%>
						<small class="text-muted batch_name_name">(<%=pgDegreeSpecialization%>)
						</small>
						<%} } %>
					</div>
							
							<div class="col-lg-3 student_checkbox">
							<div class="pull-right">
								<input type="checkbox"
									data-stage_id="<%=stage_id%>"
									class="i-checks <%=vacancyID%> <%=stage_id%> student_checkbox-<%=vacancyID%>-<%=stage_id%><%=companyID%> <%=student.get(st).getId()%>"
									data-college="<%=companyID%>"
									data-student_id="<%=student.get(st).getId()%>" name="send_msg"
									id="">
							</div>
							
							<%
							String style= "    margin-left: 71px;";
							%>
							<div class="cal-notification" style="<%=style%>">
									<div class="notification_box pull-left">
										<img src="/img/send_notif.png" class="chat_box chat_box11111"
										data-college="<%=companyID%>"
										data-student_id="<%=student.get(st).getId()%>"
											id="student_chat_box<%=vacancyID%>--<%=stage_id%><%=companyID%>--<%=student.get(st).getId()%>"/>
									</div>
							</div>
							</div>
					</div>

					<%
							}
							countStudents++;
						}
					%>
					<a href="<%=baseURL%>StudentPaginatorPlacementOfficer?startIndex=15&stageID=<%=stage_id%>&vacancyID=<%=vacancyID%>&collegeID=<%=collegeID%>&companyID=<%=companyID%>"></a>	
				</div>
		<div class="send_notification_to_all" style="background-color: #e2e4e6; height:46px; bottom:0; margin-right:15px; padding-top: 7px;position:fixed;z-index: 3000;">
		<div style="padding-right: 15px;"><button type="button" 
			class="btn btn-outline btn-primary pull-right" id="student_notification_all_btn"
			data-vacancy="<%=vacancyID%>" data-stage="<%=stage_id%>" data-college="<%=companyID%>">Send Notification</button></div>
		</div>
	</div>
	
	<div id="filter_menu--<%=stage_id%>-<%=vacancyID%><%=companyID%>" class="tab-pane list_filter_pane" >
	
	<div class="filter border-size-sm" style="padding: 25px;">

	
		<h4>Filters</h4>
		<form>
		<div class="form-group">
			<label> <input type="radio" class="rank"
				style="position: absolute;" name="rank" value="100"> <label
				style="margin-left: 20px;">Talentify 100</label>
			</label> <label> <input type="radio" class="rank"
				style="position: absolute;" name="rank" value="200"> <label
				style="margin-left: 20px;" >Talentify 200</label>
			</label> <label> <input type="radio" class="rank" 
				style="position: absolute;" name="rank" value="500"> <label
				style="margin-left: 20px;">Talentify 500</label>
			</label> <label> <input type="radio" class="rank" 
				style="position: absolute;" name="rank" value="0"> <label
				style="margin-left: 20px;" checked="checked">None</label>
			</label>
		</div>

		<hr class="top_border" />

		<div class="form-group">
			<label> Cities </label> <select class="form-control cities"
				name="cities" multiple="multiple">
				<%
					for (String cityName : allCities) {
				%>
				<option value="<%=cityName%>">
					<%=cityName%>
				</option>
				<%
					}
				%>

			</select>
		</div>

		<hr class="top_border"/>

		<div class="form-group">
			<label>College</label> <select 
				class="form-control colleges" name="college" multiple="multiple">
				<%
					for (College college : allColleges) {
				%>
				<option value="<%=college.getId()%>">
					<%=college.getName()%></option>
				<%
					}
				%>
			</select>
		</div>

		<hr class="top_border" />

		<div>
			<div class="form-group">
				<label> Degrees </label>
				<table class="degrees">
					<tr>
						<%
						int countUGDegree = 0;
							for (String ugDegreeName : ugDegrees) {
								if(countUGDegree <= 5){
						%>
						<td><input type="checkbox" class="ug_degrees i-checks"
							data-degree="<%=ugDegreeName%>" name="<%=ugDegreeName%>"></td>
						<td><%=ugDegreeName%></td>
						<%
								}
						countUGDegree++;
							}
						%>
					</tr>
					</table>

					<table class="degrees">
					<tr>
						<%
						int countPGDegree= 0;
							for (String pgDegreeName : pgDegrees) {
								if(countPGDegree <= 5) {
						%>
						<td><input type="checkbox" class="pg_degrees i-checks"
							data-degree="<%=pgDegreeName%>" name="<%=pgDegreeName%>"></td>
						<td><%=pgDegreeName%></td>
						<%
								}
								countPGDegree++;
							}
						%>
					</tr>
				</table>
			</div>
		</div>

		<hr class="top_border" />

		<div class="form-group">
			<label> Specialization </label> <select
				class="degree_specializations form-control" multiple="multiple" style="width:300px;">
			</select>
		</div>

		<div class="form-group">
			<label> 10th Performance </label> <input type="text" class="highschool_performance"/>
		</div>

		<div class="form-group">
			<label> 12th Performance </label> <input type="text" class="intermediate_performance"/>
		</div>

		<div class="form-group">
			<label>Skills</label> <select class="form-control skills"
				multiple="multiple" name="skills">
				<%
					for (Skill skill : skills) {
				%>
				<option value="<%=skill.getSkillTitle()%>">
					<%=skill.getSkillTitle()%></option>
				<%
					}
				%>
			</select>
		</div>
		
		<div class="form-group row">
		<button type="button"
			class="btn btn-sm btn-primary pull-right m-t-n-xs filter_students" data-stage="<%=stage_id%>" data-stage_identifier="<%=stage_id%>" data-vacancy_identifier="<%=vacancyID%>" data-college_identifier="<%=companyID%>">Filter</button>
		
		<button type="reset"
			class="btn btn-sm btn-white pull-right m-t-n-xs" data-stage="<%=stage_id%>" data-stage_identifier="<%=stage_id%>" data-vacancy_identifier="<%=vacancyID%>" data-college_identifier="<%=companyID%>">Reset</button>
		</div>
		</form>
	</div>
	
	</div>

</div>
</div>