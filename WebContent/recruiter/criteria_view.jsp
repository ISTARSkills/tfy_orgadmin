<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
	int vacancyID = Integer.parseInt(request.getParameter("vacancy_id"));
	String stage_id = request.getParameter("stage_id");
	Vacancy v = new VacancyDAO().findById(vacancyID);
	Recruiter rec = new RecruiterDAO().findById(v.getRecruiter().getId());
	RecruiterServices rc = new RecruiterServices();
	HashMap<Integer, Student> student = rc.getAllStudentsForRecruiter(rec);
	List<String> cities = rc.getCitiesName();
	List<College> colleges = rc.getCollegesForRecruiter(rec);
	List<String> ug_degrees = rc.getUGDegrees();
	List<String> pg_degrees = rc.getPGDegrees();
	List<Skill> skills = rc.getSkills();
	
%>
<input type="hidden" name="v_id" id ="id_vacc_idd" value="<%=vacancyID%>">
<input type="hidden" name="f_stage" id ="f_stage_id" value="<%=stage_id%>">
								<div class="row" >
								<label class="col-sm-2 control-label">Cities</label>
								<div class="col-sm-4">
								<select class="select2_demo_2 form-control" multiple="multiple" name="cities" id ="filtered_cities">
										<%
										for(String city : cities)
										{
										%>
										<option value="<%=city%>"><%=city%></option>
										<%
										}
										%>
									</select>
								
								</div>
								
								<label class="col-sm-2 control-label">Colleges</label>
								<div class="col-sm-4">
									<select class="select2_demo_2 form-control" multiple="multiple" name="colleges" id="filtered_colleges">
										<%
										for(College college : colleges)
										{
										%>
										<option value="<%=college.getId()%>"><%=college.getName()%></option>
										<%
										}
										%>
									</select>
								</div>
								</div>
								
								<div class="row" style="margin-top: 8px;">
								<label class="col-sm-2 control-label">UG Degree</label>
								<div class="col-sm-4">
									<select class="select2_demo_2 form-control" multiple="multiple" name="ug_degrees" id="filtered_ug_degrees">
										<%
										for(String ug : ug_degrees)
										{
										%>
										<option value="<%=ug%>"><%=ug%></option>
										<%
										}
										%>
									</select>
								</div>
								
								<label class="col-sm-2 control-label">PG Degree</label>
								<div class="col-sm-4">
									<select class="select2_demo_2 form-control" multiple="multiple" name="pg_degrees" id="filtered_pg_degrees">
										<%
										for(String pg : pg_degrees)
										{
										%>
										<option value="<%=pg%>"><%=pg%></option>
										<%
										}
										%>
									</select>
								</div>
								</div>
									
								<div class="row" style="margin-top: 8px;">						
								<label class="col-sm-2 control-label">Grade Cut-Off</label>
								<div class="col-sm-4">
        	    <select class="select2_demo_2 form-control"  id="grade_cutoff">										
        	    <option value="none">ALL</option>
        	    <option value=">35">More than 35 %</option>
        	    <option value=">60">More than 60 %</option>
        	    <option value=">80">More than 80 %</option>
        	    <option value=">90">More than 90 %</option>
        	    <option value=">95">More than 95 %</option>										
        	    </select>
        	    </div>
        	    
        	    <label class="col-sm-2 control-label">Skills</label>
								<div class="col-sm-4">
									<select class="select2_demo_2 form-control" multiple="multiple" name="skills" id="skill_selector">
										<%
										for(Skill pg : skills)
										{
										%>
										<option value="<%=pg.getId()%>"><%=pg.getSkillTitle()%></option>
										<%
										}
										%>
									</select>
								</div>
								</div>
								
								<div id="skill_percentile_dynamic_box">								
								</div>
								 <div class="col-sm-3">
								 <br>
								<br> 
								 <button id="filter_students" type="button" class="btn btn-w-m btn-primary">Filter</button>
								 </div> 
							 
						

