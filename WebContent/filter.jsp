<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.apps.dao.College"%>
<%@page import="com.istarindia.apps.dao.Skill"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	RecruiterServices recruiterServices = new RecruiterServices();
	List<String> allCities = recruiterServices.getCitiesName();

	ArrayList<College> allColleges = recruiterServices.getAllColleges();
	ArrayList<String> ugDegrees = recruiterServices.getUGDegrees();
	ArrayList<String> pgDegrees = recruiterServices.getPGDegrees();
	List<Skill> skills = recruiterServices.getSkills();
%>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.css"	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">


<link href="<%=baseURL%>css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/nouslider/jquery.nouislider.css" rel="stylesheet">

<!-- Mainly scripts -->
<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
<script src="<%=baseURL%>js/bootstrap.min.js"></script>

<!-- NouSlider -->
<script src="<%=baseURL%>js/plugins/nouslider/jquery.nouislider.min.js"></script>

<!-- MENU -->
<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>
<script
	src="<%=baseURL%>js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>
<!-- Chosen -->
<script src="<%=baseURL%>js/plugins/chosen/chosen.jquery.js"></script>

</head>
<body style="background: white">

	<div class="filter all_border" style="width: 440px; padding: 10px;">

		<button id="filter_students" type="button"
			class="btn btn-sm btn-primary pull-right m-t-n-xs">Filter</button>

		<h4>Filters</h4>

		<div class="">
			<label> <input type="radio" class="rank"
				style="position: absolute;" name="rank" value="100"> <label
				style="margin-left: 20px;">Talentify 100</label>
			</label> <label> <input type="radio" class="rank"
				style="position: absolute;" name="rank" value="200"> <label
				style="margin-left: 20px;" >Talentify 200</label>
			</label> <label> <input type="radio" class="rank" 
				style="position: absolute;" name="rank" value="500"> <label
				style="margin-left: 20px;">Talentify 500</label>
			</label>
		</div>

		<hr class="top_border" />

		<div class="form-group">
			<label> Cities </label> <select class="form-control cities"
				name="cities" multiple="multiple" data-role="tagsinput">
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
			<label>College</label> <select 
				class="form-control colleges" name="college" multiple="multiple"
				data-role="tagsinput">
				<%
					for (College college : allColleges) {
				%>
				<option value="<%=college.getName()%>">
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
							for (String ugDegreeName : ugDegrees) {
						%>

						<td>
						<td><input type="checkbox" class="ug_degrees i-checks"
							data-degree="<%=ugDegreeName%>" name="<%=ugDegreeName%>"></td>
						<td><%=ugDegreeName%></td>
						</td>
						<%
							}
						%>
					</tr>
					</table>

					<table class="degrees">
					<tr>
						<%
							for (String pgDegreeName : pgDegrees) {
						%>

						<td>
						<td><input type="checkbox" class="pg_degrees i-checks"
							data-degree="<%=pgDegreeName%>" name="<%=pgDegreeName%>"></td>
						<td><%=pgDegreeName%></td>
						</td>
						<%
							}
						%>
					</tr>
				</table>
			</div>
		</div>

		<hr class="top_border" />

		<div class="form-group">
			<label> Specialization </label> <select
				class="degree_specializations form-control" multiple="multiple"
				data-role="tagsinput">
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
				multiple="multiple" data-role="tagsinput" name="skills">
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
	</div>
	

	
	<script>
		$(document).ready(function() {

			$('.cities').select2({
				placeholder : "Select Cities"
			});

			$('.colleges').select2({
				placeholder : "Select Colleges"
			});

			$('.degree_specializations').select2({
				placeholder : "Select Degree Specializations"
			});

			$('.skills').select2({
				placeholder : "Select Skills"
			}).on('select2:open', function() {
				$('.select2-dropdown--above').attr('id', 'fix');
				$('#fix').removeClass('select2-dropdown--above');
				$('#fix').addClass('select2-dropdown--below');

			});

			$(".highschool_performance").ionRangeSlider({
				min : 0,
				max : 100,
				from : 50
			});

			$(".intermediate_performance").ionRangeSlider({
				min : 0,
				max : 100,
				from : 50
			});

			$('.degrees .i-checks').change(function() {
				var degreeName = "";
				$('input:checkbox:checked').each(function() {
					degreeName = degreeName + "," + $(this).data('degree');
				});

				var url = "/getDegreesSpecializations?degrees=" + degreeName;
				$.ajax(url, {
					success : function(data) {
						$('.degree_specializations').empty();
						$('.degree_specializations').html(data);
					},
					error : function() {

					}
				});
			});
			
			var filteredStudentIDs = "";
			
			$('#filter_students').click(function (e){
				
				var rank = $('.rank:checked').val();
				var cities = $('.cities').val();
				var colleges = $('.colleges').val();
				var ugDegrees = "";
				
				$('input.ug_degrees:checkbox:checked').each(function() {
					ugDegrees = ugDegrees + "," + $(this).data('degree');
	       		});
			
				var pgDegrees = "";
				
				$('input.pg_degrees:checkbox:checked').each(function() {
					pgDegrees = pgDegrees + "," + $(this).data('degree');
	       		});
				
				var specializations = $('.degree_specializations').val();
				
				var highschool_performance = $('.highschool_performance').val();
				var intermediate_performance = $('.intermediate_performance').val();				
				var skills = $('.skills').val();
				
				console.log(rank);
				console.log(cities);
				console.log(colleges);
				console.log(ugDegrees);
				console.log(specializations);
				console.log(highschool_performance);
				console.log(intermediate_performance);
				console.log(skills);
				
				var filtered_rank = rank!=null?rank:"";
				var filtered_cities = cities!=null?cities.join(','):"";
				var filtered_colleges = colleges!=null?colleges.join(','):"";
				var filtered_ugDegrees = ugDegrees!=null?ugDegrees:"";
				var filtered_pgDegrees = pgDegrees!=null?pgDegrees:"";
				var filtered_specializations = specializations!=null?specializations.join(','):"";
				var filtered_highschool_performance = highschool_performance!=null?highschool_performance:"";
				var filtered_intermediate_performance = intermediate_performance!=null?intermediate_performance:"";
				var filtered_skills = skills!=null?skills:"";
				
		       	 $.ajax({
		             type: "POST",
		             url: '<%=baseURL%>getFilteredStudents',
		             data: {
		            	 rank: filtered_rank,
		            	 cities: filtered_cities,
		            	 colleges: filtered_colleges,
		            	 ugDegrees: filtered_ugDegrees,
		            	 pgDegrees: filtered_pgDegrees,
		            	 specializations: filtered_specializations,
		            	 highschool_performance: filtered_highschool_performance,
		            	 intermediate_performance: filtered_intermediate_performance,
		            	 skills: filtered_skills         	 
		             },
				success : function(data) {
					filteredStudentIDs = data;
					console.log("Student IDs: " + filteredStudentIDs);
				}
			});
		})
	});
</script>
</body>
</html>