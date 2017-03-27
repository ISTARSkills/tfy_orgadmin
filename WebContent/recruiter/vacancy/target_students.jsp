<%@page import="java.util.HashMap"%>
<%@page import="com.istarindia.apps.dao.Skill"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="com.istarindia.apps.dao.CollegeDAO"%>
<%@page import="com.istarindia.apps.dao.College"%>
<%@page import="com.istarindia.apps.dao.CollegeRecruiter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="java.util.List"%>
<%@page import="in.orgadmin.utils.RecruiterTypes"%>
<%@page import="com.istarindia.apps.dao.RecruiterDAO"%>
<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	int recruiter_id = Integer.parseInt(request.getParameter("recruiter_id"));
	String vacancyID = request.getParameter("vacancy_id");
	Recruiter rec = new RecruiterDAO().findById(recruiter_id);
	RecruiterServices rc = new RecruiterServices();
	HashMap<Integer, Student> student = rc.getAllStudentsForRecruiter(rec);
	List<String> allCities = rc.getCitiesName();
	List<College> allColleges = rc.getCollegesForRecruiter(rec);
	List<String> ugDegrees = rc.getUGDegrees();
	List<String> pgDegrees = rc.getPGDegrees();
	List<Skill> skills = rc.getSkills();
	String stage_id = "FIRST_STAGE";
%>
<div class="panel-body" style="width: 100%;">
	<div class="row">
		<div class="col-lg-5 " id="filtered_students_list">
				<h2>Target</h2>
		<form id='publish_complete' action='<%=baseURL%>publish_vacancy'
			action='POST'>
			<input id='final_student_ids' type='hidden' name='final_student'>
			<input id='final_vacancy' type='hidden' name='final_vacancy_id'
				value='<%=vacancyID%>'>
		</form>
		
			<div class="feed-activity-list" style="height: 750px;">
			<span id="filter_error_result"></span>
				<%
				int countStudents = 0;
					for (Integer st : student.keySet()) {
						if(countStudents < 15){
				%>
				<div
					class="feed-element student_holder_actor row" id="<%=student.get(st).getId()%>">
					<div class="col-lg-2">
						<img alt="image"
							class="img-circle profile_image student_image-<%=student.get(st).getId()%>"
							src="<%=student.get(st).getImageUrl()%>"
							data-student="<%=student.get(st).getId()%>">
					</div>

					<div class="student_details_pane col-lg-10">
						<strong class="student_name"><%=student.get(st).getName()%></strong>
						<br> <small class="text-muted organization_name"><%=student.get(st).getCollege().getName()%></small>
						<%
							String ugDegreeName = student.get(st).getStudentProfileData().getUnder_graduate_degree_name();
								if (ugDegreeName != null) {
						%>
						<br> <small class="text-muted batch_name_name"><%=ugDegreeName%></small>
						<%
							String ugDegreeSpecialization = student.get(st).getStudentProfileData()
											.getUnderGraduationSpecializationName();
									if (ugDegreeSpecialization != null) {
						%>
						<small class="text-muted batch_name_name">(<%=ugDegreeSpecialization%>)
						</small>
						<%
							}
								}
							String pgDegreeName	= student.get(st).getStudentProfileData().getPg_degree_name();
							if (pgDegreeName != null) {	
						%>
						<br><small class="text-muted batch_name_name"><%=pgDegreeName%></small>
						<%
							String pgDegreeSpecialization = student.get(st).getStudentProfileData()
											.getPostGraduationSpecializationName();
								if (pgDegreeSpecialization != null) {
						%>
						<small class="text-muted batch_name_name">(<%=pgDegreeSpecialization%>)
						</small>
						<%} } %>
					</div>
				</div>
				<%
						}
						countStudents++;
					}
				%>
				<a href="<%=baseURL%>StudentPaginatorVacancy?startIndex=15&recruiterID=<%=recruiter_id%>"></a>	
			</div>
		</div>


		<div class="col-lg-7">
		<h2>Filter</h2>
			<div class="ibox-content" style="padding-left: 0px">
				<div id="filter_menu" class="tab-pane">
			<form>
											<p>Filter students to target for the current Vacancy. The students from your last selected 
									filter will be targeted for this job role.</p>
					<div class="filter border-size-sm"
						style="padding: 25px;">
						
						<h4>Filters</h4>

						<div class="talentify_rank">
							<label> <input type="radio" class="rank"
								style="position: absolute;" name="rank" value="100"> <label
								style="margin-left: 20px;">Talentify 100</label>
							</label> <label> <input type="radio" class="rank"
								style="position: absolute;" name="rank" value="200"> <label
								style="margin-left: 20px;">Talentify 200</label>
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

						<hr class="top_border" />

						<div class="form-group">
							<label>College</label> <select class="form-control colleges"
								name="college" multiple="multiple">
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

						<td>
						<td><input type="checkbox" class="ug_degrees i-checks"
							data-degree="<%=ugDegreeName%>" name="<%=ugDegreeName%>"></td>
						<td><%=ugDegreeName%></td>
						</td>
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
								class="degree_specializations form-control" multiple="multiple">
			</select>
		</div>

		<div class="form-group">
			<label> 10th Performance </label> <input type="text"
								class="highschool_performance" />
		</div>

		<div class="form-group">
			<label> 12th Performance </label> <input type="text"
								class="intermediate_performance" />
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
		
		
				<button type="button" data-loading-text="Filtering"
					class="btn btn-sm btn-primary pull-right m-t-n-xs filter_students"
					data-stage="<%=stage_id%>"
					data-stage_identifier=<%=stage_id%>
					data-vacancy_identifier=<%=vacancyID%>>Filter</button>

				<button type="reset"
					class="btn btn-sm btn-white pull-right m-t-n-xs reset_button"
					data-stage="<%=stage_id%>"
					data-stage_identifier=<%=stage_id%>
					data-vacancy_identifier=<%=vacancyID%>>Reset</button>
			</div>
</form>
				</div>
			</div>
			</div>
		</div>
</div>