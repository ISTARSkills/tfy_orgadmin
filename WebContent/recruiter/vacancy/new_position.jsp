<%@page import="com.istarindia.apps.dao.VacancyProfile"%>
<%@page import="javax.crypto.spec.PSource"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.apps.dao.IstarTaskType"%>
<%@page import="java.util.List"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="com.istarindia.apps.dao.PlacementOfficer"%>
<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@page import="com.istarindia.apps.dao.PincodeDAO"%>
<%@page import="com.istarindia.apps.dao.Pincode"%>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	Recruiter recruiter = (Recruiter)user;
	boolean newVacancy = true;
	RecruiterServices service = new RecruiterServices();
	ArrayList<String> position_types= service.getPosTypes();
	ArrayList<String> experience_levels= service.getExpLevel();
	ArrayList<String> position_categories= service.getCategories();

	RecruiterServices recruiterServices = new RecruiterServices();
	List<String> allCities = recruiterServices.getCitiesName();
	
	String recruiterID = request.getParameter("recruiter_id");
	
	String vacancy_title ="placeholder ='Enter Title'";
	String total_positions=null;
	String vacancy_description="Enter the Description";
	String vacancy_location="Enter the Location";
 	String vacancy_position_type="none";
 	String vacancy_category="none";
 	String vacancy_experience_level="none";
 	String vacancy_salary_range="3;7";
 	
	VacancyDAO vaccancyDAO = new VacancyDAO();
	if(request.getParameter("vacancy_id") !=null ) {
		System.out.println("inside old Position");
		newVacancy = false;
		Vacancy v = vaccancyDAO.findById(Integer.parseInt(request.getParameter("vacancy_id")));
		System.out.println("inside old Position");
		vacancy_title= "value ='"+v.getProfileTitle()+"'";				
		total_positions = v.getTotalPositions()!=null ? v.getTotalPositions().toString() : "";
		vacancy_description= !v.getDescription().trim().isEmpty()?v.getDescription():"Enter the Description again";
		vacancy_location = v.getLocation()!=null ? v.getLocation() : "Enter the Location";
		
		VacancyProfile vp = v.getVacancyProfile();
		if(vp!=null)
		{
			vacancy_position_type=  vp.getVacancy_position_type()!=null ? vp.getVacancy_position_type() : "none";
			vacancy_experience_level =  vp.getVacancy_experience_level()!=null ? vp.getVacancy_experience_level() : "none";
			vacancy_category = vp.getVacancy_category()!=null ? vp.getVacancy_category() : "none";
			vacancy_salary_range = (vp.getVacancy_min_salary()!=null && vp.getVacancy_max_salary()!=null) ? vp.getVacancy_min_salary()+";"+vp.getVacancy_max_salary() : "3;7";
		}		
	}	
%>
<div class="panel-body" style="width: 100%;">
	<fieldset>
	<form action="<%=baseURL%>create_update_vacancy" method="POST">
		<h2>Position Details</h2>
		<p>A standout job description is an essential step toward
			attracting the right candidates. Use the editor below to format your
			lists and section headers.</p>
		<div class="row" id="new_position">
			<div class="col-lg-12">
				<div class="row">
					<div class="form-group col-md-8">
						<label>Title *</label> <label id="title-error" class="error"
							for="title" style="display: none;"></label> <input
							id="vacancy_title" name="title" type="text"
							class="form-control" aria-required="true"
							aria-invalid="false" <%=vacancy_title%> data-validation="required"/>
					</div>
					<div class="col-md-4">
						<label>No of positions *</label> <label id="position-error"
							class="error" for="position" style="display: none;"></label> <input
							id="vacancy_position" name="position" type="number"
							class="form-control" aria-required="true" required
							aria-invalid="false" <%if(!newVacancy){%>value="<%=total_positions%>"<%} %> min="1" data-validation="required"/>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-md-4">
						<select class="form-control m-b" name="position_type"
							id="vacancy_position_type" data-validation="required">
							<option hidden selected disabled>Position Type</option>
							<%
																		for(String str : position_types)
																		{
																			if(vacancy_position_type.equalsIgnoreCase(str))
																			{
																		%>
							<option value="<%=str%>" selected><%=str %></option>
							<%
																			}
																			else
																			{
																				%>
							<option value="<%=str%>"><%=str %></option>

							<% 
																			}	
																		}
																		%>
						</select>
					</div>
					<div class="form-group col-md-4">
						<select class="form-control m-b" name="experience_level"
							id="vacancy_experience_level" data-validation="required">
							<option hidden selected disabled>Experience Level</option>
							<%
																		for(String str : experience_levels)
																		{
																		if(vacancy_experience_level.equalsIgnoreCase(str))
																			{
																		%>
							<option value="<%=str%>" selected><%=str %></option>
							<%
																			}
																			else
																			{
																				%>
							<option value="<%=str%>"><%=str %></option>
							<% 
																			}
																		}
																		%>
						</select>
					</div>
					<div class="form-group col-md-4">
						<select class="form-control m-b" name="position_category"
							id="vacancy_position_category" data-validation="required">
							<option hidden selected disabled>Category</option>
							<%
																		for(String str : position_categories)
																		{
																		if(vacancy_category.equalsIgnoreCase(str))
																			{
																		%>
							<option value="<%=str%>" selected><%=str %></option>
							<%
																			}
																			else
																			{
																				%>
							<option value="<%=str%>"><%=str %></option>
							<% 
																			}
																		}
																		%>
						</select>
					</div>
				</div>			
									
				<div class="form-group">
					<label>Job description *</label>
						<div id="summernote">
						<%=vacancy_description %>
						</div>
						<input type="hidden" name="description" id="description"/>
				</div>

				<div class="form-group">
					<label>Location *</label> <label class="error" for="location"
						style="display: none;"></label> <select id="vacancy_location"
						data-placeholder="Select Location"
						class="form-control m-b required valid" name="location"
						tabindex="2" aria-required="true" aria-invalid="false" data-validation="required">
						<%
						if(newVacancy){
						%><option hidden selected disabled>Select Location</option><%} else{%>					
						<option value="<%=vacancy_location%>" selected><%=vacancy_location%></option>
						<%} %>
						<% for(String cityName: allCities) {%>
						<option value="<%=cityName %>">
							<%=cityName %>
						</option>
						<%} %>

					</select>

				</div>

				<div class="form-group m-b-sm">
					<label>Salary range *</label> <input type="text"
						id="vacancy_salary_range" name="salary_range" data-validation="required" value="<%=vacancy_salary_range%>"/>
				</div>
				<%if(!newVacancy) {%>
				<input type="hidden" name="vacancy_id" value="<%=request.getParameter("vacancy_id")%>"/>
				<%} %>
				<input type="hidden" name="recruiter_id" value="<%=recruiterID%>"/>
				<div class="form-group">
					<button type="submit" id="create_update_vacancy"
						class="btn btn-w-m btn-primary pull-right">Save</button>
				</div>
			</div>
		</div>
		</form>
	</fieldset>
</div>