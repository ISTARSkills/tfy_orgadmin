<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.talentify.admin.services.AdminUIServices"%>
<%@page import="com.viksitprodummy.SumanthDummyServices"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.talentify.admin.rest.pojo.AdminRoleThumb"%>
<%@page import="java.util.List"%>
<%@page import="com.talentify.admin.rest.pojo.AdminGroup"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
<%@page import="java.util.Random"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<%@page import="com.istarindia.android.pojo.*"%>

<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<style>

div.google-visualization-tooltip {
background-color: #616161;
 border-radius: 25px;
 height: 35px;
 width: 100px;
 text-align: center;
 margin:0px !important;
  padding:0px !important;
}

div.google-visualization-tooltip > ul > li > span {
color: #ffffff !important;
font-size:10px !important;
 margin:0px !important;
   padding:0px !important;
 
}

</style>
<body id='orgadmin_individual_groups_report'>

	<%
		boolean flag = false;
	    int batch_group_id =0;
 
		String url = request.getRequestURL().toString();

		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())

				+ request.getContextPath() + "/";

		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		if(request.getParameter("batch_group_id")!=null){
			batch_group_id = Integer.parseInt(request.getParameter("batch_group_id"));
		}
		
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());

		if (cp == null) {

			flag = true;

			request.setAttribute("msg", "User Does Not Have Permission To Access");

			request.getRequestDispatcher("/login.jsp").forward(request, response);

		}

		request.setAttribute("cp", cp);

		int orgId = (int) request.getSession().getAttribute("orgId");
		String	adminRestUrlForStudentRecord = (AppProperies.getProperty("admin_rest_url")+"report/"+orgId+"/group_student_record/"+batch_group_id);
		 String	admin_rest_url = (AppProperies.getProperty("admin_rest_url"));
		// String	adminRestUrlForAttendanceRecord = (AppProperies.getProperty("admin_rest_url")+"report/"+orgId+"/group_student_record/"+batch_group_id);
		//System.out.println(orgId);
		AdminUIServices uiservices=new AdminUIServices();
		BatchGroup batchgroup = new BatchGroup();
		BatchGroupDAO batchgroupDAO = new BatchGroupDAO();
		batchgroup = batchgroupDAO.findById(batch_group_id);
		String bgName = "N/A";
		if(batchgroup != null && batchgroup.getName() != null && !batchgroup.getName().equalsIgnoreCase("")  && !batchgroup.getName().equalsIgnoreCase("null")){
			bgName = batchgroup.getName();
		}
		
	%>

	<jsp:include page="/inc/navbar.jsp"></jsp:include>



	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row ml-0">
				<a class='col-1 my-auto custom-no-padding' href="<%=baseURL%>orgadmin/report/groups_report.jsp"> <img class="custom-beginskill-backarrow" src="/assets/images/1165040-200.png" alt="">
				</a>
				<div class='col-11 custom-no-padding'>
					<h1 class='custom-beginskill-course-heading'><%=bgName%></h1>
				</div>
			</div>
		</div>
		<div class="container">
			<div class="card custom-course-attendance-css">
				<div class="row m-5">
					<div class="col-md-10 pl-0">
						<h3 class="card-header-box text-center">ATTENDANCE RECORDS IN SECTIONS OVERTIME</h3>
					</div>

					 <div class="col-2 p-0">
						<select class="form-control select-dropdown-style graph_filter_selector"  name="course_id" id='filter_group_student_attendance' data-college_id="<%=orgId%>">										
										<%	
										ArrayList<Course> courses = uiservices.getCoursesInCollege(orgId);
										for(Course course : courses)
										{
										%>
										<option value="<%=course.getId()%>"><%=course.getCourseName().trim()%></option>
										<%
										} %>
									</select>
					</div> 
					<!-- <div class="col-1">
						<img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container">
					</div> -->

				</div>
				<div class="row m-0">
					<div class="col-12">
						<div id="columnchart_material"></div>

					</div>
				</div>
			</div>
		</div>


		<div class="container mt-5">
			<div class="card custom-course-masteryskill-css">
				<div class="row m-5">
					<div class="col-md-12 pl-0">
						<h3 class="card-header-box text-center">MASTERY LEVEL PER SKILL</h3>
						<div class="row m-0">
							<div class="col-3"></div>
							<div class="col-7">
								<div class="row m-0">
									<h4 class="mr-4">
										<span class="badge badge-default mr-4 b-Wizard custom-legends-masterylevel-css"> </span>Wizard
									</h4>
									<h4 class="mr-4">
										<span class="badge badge-default mr-4 b-Master custom-legends-masterylevel-css" > </span>Master
									</h4>
									<h4 class="mr-4">
										<span class="badge badge-default mr-4 b-Apprentice custom-legends-masterylevel-css" > </span>Apprentice
									</h4>
									<h4 class="mr-4">
										<span class="badge badge-default mr-4 b-Rookie custom-legends-masterylevel-css"> </span>Rookie
									</h4>
								</div>
							</div>
						
						<div class="col-2">
						<select class="form-control select-dropdown-style graph_filter_selector"  name="course_id" id='filter_master_level_perskill' data-college_id="<%=orgId%>">										
										<%	
										
										 courses = uiservices.getCoursesInCollege(orgId);
										for(Course course : courses)
										{
										%>
										<option value="<%=course.getId()%>"><%=course.getCourseName().trim()%></option>
										<%
										} %>
									</select>
						</div>
					</div>

					<!-- <div class="col-1">
						<img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container">
					</div>
 -->
				</div>
				</div>
				<div class="row m-0">
					<div class="col-12">
						<div class='custom-master_level_perskill-css custom-scroll-holder' id="master_level_perskill">

						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="container mt-5">
			<div class="card">
				<div class="card-block">
					<div class="card-body">
						<div class="row m-3">
							<div class="col-12">
								<h3 class='text-center card-header-box'>STUDENTS ENROLLED</h3>
							</div>
							<!-- <div class="col-1">
								<img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container">

							</div> -->
						</div>
						<div class="row m-0 custom-studentenroled-css">
							<div class="col-md-3 text-center m-auto">EMPLOYEE NAME</div>
							<div class="col-md-3 text-center m-auto">RANK</div>
							<div class="col-md-3 text-center m-auto">XP</div>
							<div class="col-md-3 text-center m-auto">LEVEL</div>
						</div>
						<div class="main-table custom-scroll-holder ">
							
						</div>
					</div>
				</div>
			</div>

		</div>
		<div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" id = 'studentInfo' aria-labelledby="studentInfo" aria-hidden="true">
  <div class="modal-dialog modal-lg" style="max-width: 73% !important;">
    <div class="modal-content" id='studentProfile_holder'>
    
    </div>
  </div>
</div>
	</div>




	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$.fn
				.extend({
					treed : function(o) {
						var openedClass = 'glyphicon-minus-sign';
						var closedClass = 'glyphicon-plus-sign';
						if (typeof o != 'undefined') {
							if (typeof o.openedClass != 'undefined') {
								openedClass = o.openedClass;
							}
							if (typeof o.closedClass != 'undefined') {
								closedClass = o.closedClass;
							}
						}
						;
						var tree = $(this);
						tree.addClass("tree");
						tree.find('li').has("ul").each(function() {
											var branch = $(this);
											branch.prepend("<i class='indicator glyphicon " + closedClass + "'></i>");
											branch.addClass('branch');
											branch.addClass('custom-branch-css');
											branch.on('click',function(e) {
																if (this == e.target) {
																	var icon = $(
																			this)
																			.children(
																					'i:first');
																	icon
																			.toggleClass(openedClass
																					+ " "
																					+ closedClass);
																	$(this)
																			.children()
																			.children()
																			.toggle();
																	$(
																			'.progress')
																			.show();
																	$(
																			'.progress-bar')
																			.show();
																}
															})
											branch.children().children()
													.toggle();
											$('.progress').show();
											$('.progress-bar').show();
											$('.row.ll').show();
											$('.col-md-2.ll').show();

										});
						tree.find('.branch .indicator').each(function() {
							$(this).on('click', function() {
								$(this).closest('li').click();
							});
						});
						tree.find('.branch>a').each(function() {
							$(this).on('click', function(e) {
								$(this).closest('li').click();
								e.preventDefault();
							});
						});
						tree.find('.branch>button').each(function() {
							$(this).on('click', function(e) {
								$(this).closest('li').click();
								e.preventDefault();
							});
						});
					}
				});
		
		
 function roleMasteryLevel(){
			 
			var course_id =  $('#filter_master_level_perskill').val();
			var college_id = $('#filter_master_level_perskill').attr('data-college_id');
			 
			 var htmlAdd = "";
				//{organization_id}/group_mastery_level/{group_id}/course/{course_id}
			  $.getJSON("<%=admin_rest_url%>report/"+college_id+"/group_mastery_level/"+<%=batch_group_id%>+"/course/"+course_id+"", function(result){
				 
				  
				  htmlAdd += "<ul id='tree1'>";
				  $.each(result.data, function(i, field){
					  
					  htmlAdd += "<li>";
					  htmlAdd += "<div style='display: initial;'>";
					  htmlAdd += "<div class='progress' style='display: inline; width: 30%; font-size: 17px; background-color: #fff; margin-right: 20px;'>"+field.title+"</div>";
					  htmlAdd += "<div class='progress' style='display: inline-flex; width: 70%; position: absolute; top: 16px; background-color: #fff; right: 10px;'>";
					  htmlAdd += "<div class='progress-bar ' role='progressbar' style='width: "+field.wizard+"%; font-size: 14px;    line-height: 3rem; height: 3rem !important; background-color: #fd6d81;' aria-valuenow='"+field.wizard+"' aria-valuemin='0' aria-valuemax='100'>"+field.wizard+"%</div>";
					  htmlAdd += "<div class='progress-bar   ' role='progressbar' style='width: "+field.master+"%; font-size: 14px; line-height: 3rem; height: 3rem !important; background-color: #7295fd;' aria-valuenow='"+field.master+"' aria-valuemin='0' aria-valuemax='100'>"+field.master+"%</div>";
					  htmlAdd += "<div class='progress-bar ' role='progressbar' style='width: "+field.rookie+"%; font-size: 14px; line-height: 3rem; height: 3rem !important; background-color: #bae88a;' aria-valuenow='"+field.rookie+"' aria-valuemin='0' aria-valuemax='100'>"+field.rookie+"%</div>";
					  htmlAdd += "<div class='progress-bar   ' role='progressbar' style='width: "+field.apprentice+"%; font-size: 14px; line-height: 3rem; height: 3rem !important; background-color: #30beef;' aria-valuenow='"+field.apprentice+"' aria-valuemin='0' aria-valuemax='100'>"+field.apprentice+"%</div>";
					  htmlAdd += "</div>";
					  htmlAdd += "</div>";
					  
					  htmlAdd += "<ul style='width:100%'>";
					  
					  
					  
					  $.each(field.session_skills, function(j, field){
						  
						  htmlAdd += "<li>";
						  htmlAdd += "<div style='display: initial;'>";
						  htmlAdd += "<div class='progress' style='display: inline; width: 30%; font-size: 17px; background-color: #fff; margin-right: 20px;'>"+field.title+"</div>";
						  htmlAdd += "<div class='progress' style='display: inline-flex; width: 72%; position: absolute; top: 16px; background-color: #fff; right: 10px;'>";
						  htmlAdd += "<div class='progress-bar ' role='progressbar' style='width: "+field.wizard+"%; font-size: 14px; line-height: 3rem; height: 3rem !important; background-color: #fd6d81;' aria-valuenow='"+field.wizard+"' aria-valuemin='0' aria-valuemax='100'>"+field.wizard+"%</div>";
						  htmlAdd += "<div class='progress-bar   ' role='progressbar' style='width: "+field.master+"%; font-size: 14px; line-height: 3rem; height: 3rem !important; background-color: #7295fd;' aria-valuenow='"+field.master+"' aria-valuemin='0' aria-valuemax='100'>"+field.master+"%</div>";
						  htmlAdd += "<div class='progress-bar ' role='progressbar' style='width: "+field.rookie+"%; font-size: 14px; line-height: 3rem; height: 3rem !important; background-color: #bae88a;' aria-valuenow='"+field.rookie+"' aria-valuemin='0' aria-valuemax='100'>"+field.rookie+"%</div>";
						  htmlAdd += "<div class='progress-bar   ' role='progressbar' style='width: "+field.apprentice+"%; font-size: 14px; line-height: 3rem; height: 3rem !important; background-color: #30beef;' aria-valuenow='"+field.apprentice+"' aria-valuemin='0' aria-valuemax='100'>"+field.apprentice+"%</div>";
						 
						  htmlAdd += "</div>";
						  htmlAdd += "</div>";
						  htmlAdd += "</li>";
						 
						  
					  });
					  htmlAdd += "</ul>";
					  htmlAdd += "</li>";
					
					 
					 
					    
		        });
				  htmlAdd += "<ul>";
				  $("#master_level_perskill").empty();
	            	$("#master_level_perskill").append(htmlAdd); 
	            	$('#tree1').treed();
					$('.progress').show();
					$('.progress-bar').show();
					$('.row.ll').show();
					$('.col-md-2.ll').show();
			  }); 
		 }
 
 function studentInfoFunction(){
	 
	 $( ".student_info-click" ).click(function() {
		 $("#studentProfile_holder").empty();
			var user_id = $(this).attr('data-userid');
			
				$("#studentProfile_holder").load("<%=baseURL%>/orgadmin/report/skill_profile.jsp?user_id="+user_id);
				$('#studentInfo').modal('toggle');

				
			
			
			});	 
 }
 
 function studentEnrolled(){
	 
	 var htmlAdd = "";
		
	  $.getJSON("<%=adminRestUrlForStudentRecord%>", function(result){
		 
           $.each(result.studentRecord, function(i, field){
           	var image ='';
           	var name ='';
           	var rank='';
           	var xp='';
           	var level='';
                 $.each(field, function(key,val){
           		
           		if(key == 'col-0'){
           			image ="<img  class='custom-mastery-levelimg-css' src='"+val+"'>";
           		}else if(key == 'col-1'){
           			name ="<h3>"+val+"</h3>";
           		}else if(key == 'col-2'){
           			rank ="<div class='col-md-3 text-center m-auto'>#"+val+"</div>";	
           		}else if(key == 'col-3'){
           			xp ="<div class='col-md-3 text-center m-auto'>"+val+"</div>";
           			
           		}else if(key == 'col-4'){
           			level ="<div class='col-md-3 text-center m-auto "+val+"'>"+val+"</div>";
           		}else if(key == 'col-5'){
        			user_id =val;
        		}
           		
                  
           	 });
              
           	
           	htmlAdd +="<div data-userID='"+user_id+"' class='row m-0 custom-mastery-levelbody-css student_info-click'>"
           	htmlAdd +="<div class='col-md-3 text-center m-auto'>";
           	htmlAdd +="<div class='row m-0'>";
           	htmlAdd +="<div class='col-md-4 text-center m-auto'>";
           	htmlAdd +=image;
           	htmlAdd +="</div>";
           	htmlAdd +="<div class='col-md-8 text-center m-auto'>";
           	htmlAdd += name;
           	htmlAdd +="</div>";
           	htmlAdd +="</div>";
           	htmlAdd +="</div>";
           	htmlAdd +=rank;
           	htmlAdd +=xp;
           	htmlAdd +=level;
           	htmlAdd +="</div>";
           	
           	$(".main-table").empty();
           	$(".main-table").append(htmlAdd);
           	studentInfoFunction();
           });
       });
	 
	 
 }
		 function drawChart() {
			 
			 $('#columnchart_material').empty();
				$("#columnchart_material").append('<div class="loader mx-auto my-auto"></div>');
				
			 var course_id =  $('#filter_group_student_attendance').val();
			 var college_id = $('#filter_group_student_attendance').attr('data-college_id');
			 
	    	   $.ajax({
				    url: "<%=admin_rest_url%>report/"+college_id+"/group_attendance_record/<%=batch_group_id%>/course/"+course_id+"",
				    type: 'GET',
				    async: true,
				    dataType: "json",
				    success: function (data) {	
				    	 $('#columnchart_material').empty();
				    	 
				    	  google.charts.load('current', {'packages':['corechart']});
				          google.charts.setOnLoadCallback(drawStuff);

				          function drawStuff() {
				            var tabledData = google.visualization.arrayToDataTable( data.data );				      
				           var classicOptions = {
				            		 tooltip: {isHtml: true},
				            		 legend: 'bottom',
						                colors: ['#30beef','#bae88a','#fd6d81','#7295fd'],
							       	    fontName: 'avenir-light',	
							       	 vAxis: {title: 'Attendance Percentage'},
							         hAxis: {title: 'Sessions'},
							         seriesType: 'bars',
				            		
				            };
				           
				            function drawClassicChart() {
				             
				            	 var chart = new google.visualization.ColumnChart(document.getElementById('columnchart_material'));
							        chart.draw(tabledData, classicOptions);
				            }

				            drawClassicChart();
				        };
				    	
				    	}
				  });
	    	  
	    	  
	        
	        }
		$(document).ready(function() {
			
			
			  google.charts.load('current', {'packages':['corechart']});
		      google.charts.setOnLoadCallback(drawChart);
		      studentEnrolled();
		      roleMasteryLevel();
					$('#tree1').treed();
					$('.progress').show();
					$('.progress-bar').show();
					$('.row.ll').show();
					$('.col-md-2.ll').show();
					
					
					$( "#filter_master_level_perskill" ).change(function() {
						 //alert( $(this).val() );
						 // masterLevelPerSkill($(this).val(),$(this).attr('data-college_id'));
						 roleMasteryLevel();
						});	
					
					$( "#filter_group_student_attendance" ).change(function() {
						 //alert( $(this).val() );
						 // masterLevelPerSkill($(this).val(),$(this).attr('data-college_id'));
						 drawChart();
						});	

				});
	</script>

</body>
</html>