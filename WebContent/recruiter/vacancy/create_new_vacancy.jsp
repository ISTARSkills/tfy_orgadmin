<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="com.istarindia.apps.dao.RecruiterPanelistMapping"%>
<%@page import="javax.crypto.spec.PSource"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.apps.dao.IstarTaskType"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="com.istarindia.apps.dao.PlacementOfficer"%>
<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	Recruiter recruiter = (Recruiter) user;
	int rec_id = recruiter.getId();
	String panelist = "";
	boolean editVacancy = false;
	
	Set<RecruiterPanelistMapping> panelistMapping = recruiter.getRecruiterPanelistMappings();
	System.out.println("SIZE is" + panelistMapping.size());
	
	if(!panelistMapping.isEmpty()){
	for (RecruiterPanelistMapping map : panelistMapping) {
		panelist += map.getPanelist().getEmail() + ",";
	}
	}
	
	RecruiterServices service = new RecruiterServices();
	
	String vacancyID = "none";
	if(request.getParameterMap().containsKey("vacancy_id"))
	{
		vacancyID= request.getParameter("vacancy_id");
	}
	
	if(request.getParameterMap().containsKey("status")){
	if(request.getParameter("status").equalsIgnoreCase("edit")){
		editVacancy = true;
	}
	}
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />
<title>Talentify Recruitor | New Vacancy</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/summernote/summernote.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/sweetalert/sweetalert.css" rel="stylesheet">

<style>
.irs-slider.from.last{
border: solid 0.5px;
border-radius: 3px;
background: white;
}
.irs-slider.to{
border: solid 0.5px;
border-radius: 3px;
background: white;
}
</style>
</head>
<body class="fixed-navigation">
	<div id="wrapper" style="overflow-y:hidden">
		<jsp:include page="../includes/sidebar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg ">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>


			<div class="wrapper">
				<div class="vacancy_tabs_pane white-bg page-heading">
					<h2 style="padding-top: 15px;">New Position</h2>
				</div>

				<div class="panel-body">
					<div class="tabs-container">
						<input type="hidden" name="vacancy_iddd" id="vacancy_iddd"
							value="<%=vacancyID%>" />
						<div class="tabs-left row">
							<ul class="nav nav-tabs vacancy_stages_tab"
								id="tab_navigation_pane" style="width: 10% !important">
								<li class="active"><a aria-expanded="true"
									data-toggle="tab" href="#tab-1">Position Details</a></li>
								<li class="<%=editVacancy?"disabled":""%>"><a
									aria-expanded="false" data-toggle="tab" href="#tab-3">Pipeline
										Stages</a></li>
								<li class="<%=editVacancy?"disabled":""%>"><a
									aria-expanded="false" data-toggle="tab" href="#tab-4">Target</a></li>
								<li class="<%=editVacancy?"disabled":""%>"><a
									aria-expanded="false" data-toggle="tab" href="#tab-5">Hiring
										Team</a></li>
								<li class="<%=editVacancy?"disabled":""%>"><a
									aria-expanded="false" data-toggle="tab" href="#tab-6">Publish</a></li>
							</ul>
							<div class="tab-content col-lg-10"
								style="background-color: #f3f3f4;">
								
								
								<div id="tab-1" class="tab-pane row active vacancy_stage_pane">
									<jsp:include page="new_position.jsp">
										<jsp:param name="recruiter_id" value="<%=user.getId()%>" />
									</jsp:include>
								</div>
								<div id="tab-3" class="tab-pane row vacancy_stage_pane">
									<jsp:include page="workflow_stages.jsp">
										<jsp:param name="recruiter_id" value="<%=user.getId()%>" />
									</jsp:include>
								</div>
								<div id="tab-4" class="tab-pane row vacancy_stage_pane">
									<jsp:include page="target_students.jsp">
										<jsp:param name="recruiter_id" value="<%=user.getId()%>" />
										<jsp:param name="vacancy_id" value="<%=vacancyID%>" />
									</jsp:include>
								</div>
								<div id="tab-5" class="tab-pane row vacancy_stage_pane">
									<jsp:include page="hiring_team.jsp">
										<jsp:param name="recruiter_id" value="<%=user.getId()%>" />
									</jsp:include>
								</div>
								<div id="tab-6" class="tab-pane row vacancy_stage_pane">
									<jsp:include page="publish_vacancy.jsp">
										<jsp:param name="recruiter_id" value="<%=user.getId()%>" />
									</jsp:include>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Mainly scripts -->
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	
	<!-- jQuery UI -->
	<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>
	
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	
	<script src="<%=baseURL%>js/jquery.jscroll.min.js"></script>
	
		<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>

	<!-- Chosen -->
	<script src="<%=baseURL%>js/plugins/chosen/chosen.jquery.js"></script>

	<!-- Sparkline -->
	<script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>
	<script src="<%=baseURL%>js/plugins/summernote/summernote.min.js"></script>
	
		<!-- Sparkline demo data  -->
	<script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>
	<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>
	
		<!-- IonRangeSlider -->
	<script src="<%=baseURL%>js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>

	<!-- TouchSpin -->
	<script src="<%=baseURL%>js/plugins/touchspin/jquery.bootstrap-touchspin.min.js"></script>
	<script src="<%=baseURL%>js/plugins/staps/jquery.steps.min.js"></script>

	<script
		src="<%=baseURL%>js/plugins/bootstrap-tagsinput/bootstrap-tagsinput.js"></script>

	<!-- Sweet alert -->
	<script src="<%=baseURL%>js/plugins/sweetalert/sweetalert.min.js"></script>
	
	    <script src="<%=baseURL%>js/highcharts-custom.js"></script>

	<script>
	$(document).ready(function() {
		
    	//Variable to retrieve profile data on page load

    	
    	$('#summernote').summernote({
    		height: 300,
    		resize: false,
    		placeholder: 'Enter Job Description',
    	    onChange: function() {
    	    profileData = $('.note-editable').html(); 
    		$('#description').val(profileData); }   //Storing profile data in input tag 
    	});

    	var profileData = $('.note-editable').html(); 
    	$('#description').val(profileData);
    	
		EnableDisableDelBtn();
		
		$('.cities').select2({
			placeholder : "Select Cities",
			width: '100%'
		});
		
		$('.colleges').select2({
			placeholder : "Select Colleges",
			width: '100%'
		});
		
		$('.degree_specializations').select2({
			placeholder : "Select Specializations",
			width: '100%'
		});
		
		$('.select2-search__field').css({
			"width":"200px",
			"min-width":"100px"
		});

		$('.skills').select2({
			placeholder : "Select Skills",
			width: '100%'
		}).on('select2:open', function() {
			$('.select2-dropdown--above').attr('id', 'fix');
			$('#fix').removeClass('select2-dropdown--above');
			$('#fix').addClass('select2-dropdown--below');

		});

		$(".highschool_performance").ionRangeSlider({
			min : 0,
			max : 100,
		});

		$(".intermediate_performance").ionRangeSlider({
			min : 0,
			max : 100,
		});
		
        $('.irs-slider.to').css({
        	"border":"solid 2px #1ab394",
        	"background":"white",
        	"border-radius" : "3px"
        });
        
        $('.irs-slider.from').css({
        	"border":"solid 2px #1ab394",
        	"background":"white",
        	"border-radius" : "3px"
        });
        
        $('.irs-slider.from.last').css({
        	"border":"solid 2px #1ab394",
        	"background":"white",
        	"border-radius" : "3px"
        });
        
        $('.irs-slider.single').css({
        	"border":"solid 2px #1ab394",
        	"background":"white",
        	"border-radius" : "3px"
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
		
		$('.reset_button').click(function(){
			console.log("RESETTING");
			$('.cities').select2("val", "");
			$('.colleges').select2("val", "");
			$('.skills').select2("val", "");
			$('.degree_specializations').select2("val", "");
			$('.highschool_performance').val('0');
			$('.intermediate_performance').val('0');	
		})
		
		
		var filteredStudentIDs = "";
		
		$('.filter_students').click(function (e){
			
			var buttonContext = $(this);
			
			$(buttonContext).button('loading');
			
			filteredStudentIDs = "";

			var rank = $('input[name=rank]:checked').val();
			var cities = $('.cities').val();
			var colleges = $('.colleges').val();
			var ugDegrees = "";
			
			$('input.ug_degrees:checkbox:checked').each(function() {
				ugDegrees = ugDegrees + "," + $(this).data('degree');
				console.log("UG Checked" + ugDegrees);
       		});
		
			var pgDegrees = "";
			
			$('input.pg_degrees:checkbox:checked').each(function() {
				pgDegrees = pgDegrees + "," + $(this).data('degree');
				console.log("PG Checked" + pgDegrees);
       		});
			
			var specializations = $('.degree_specializations').val();
			
			var highschool_performance = $('.highschool_performance').val();
			var intermediate_performance = $('.intermediate_performance').val();				
			var skills = $('.skills').val();
			
			console.log(rank);
			console.log(cities);
			console.log(colleges);
			console.log(ugDegrees);
			console.log(pgDegrees);
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
	            	 skills: filtered_skills,
	            	 vacancyID : <%=vacancyID%>,
	             },
			success : function(data) {
				allFilteredStudents = data
				console.log("DATA->" + allFilteredStudents);
				if(allFilteredStudents!=""){
					$('#filter_error_result').html("");
				var studentIDArray = allFilteredStudents.split(',');					
				
				$('.student_holder_actor').each(function(index) {
					  if($.inArray($( this ).attr('id'), studentIDArray) > -1){
						  $(this).show();
						  filteredStudentIDs = filteredStudentIDs + ',' + $( this ).attr('id');
						  console.log(filteredStudentIDs);
					  }else{
						  $(this).hide();
					  	}
					});
				
			}else{
				console.log("NO student found");
				$('#filter_error_result').html("No student found for this filter criteria");
				$('.student_holder_actor').each(function(index) {
					$(this).hide();
				});
			}
				$(buttonContext).button('reset');
				}
			});   	 
		});
		
		//Dont touch this method...keep it just below the above method
		$('#publish_position').click(function (e) {
			  $('#final_student_ids').val(filteredStudentIDs);
			  $('#publish_complete').submit();
		});
	});
		</script>
		<script>
		$(document).ready(function() {
        	//$("#loading").hide();
        	$('.test_action_form').hide();
        	$('.interview_action_form').hide();
        	$('.other_action_form').hide();
        	$('.url_action_form').hide();
        	
        	$(".select2_demo_2").select2();
        	$(".select2_demo_2").select2({ width: '100%' });  
            $.validate();
            $('.tagsinput').tagsinput({
                tagClass: 'label label-primary'
            });

            
            function disableDelBtn(){
        	var stage_tab_count = $('.concrete_stage_content .tab-pane').length;
        	 if(stage_tab_count == 1){
        		 $('#btnDel').attr('disabled',true);
        	 }
            }

            $("#vacancy_salary_range").ionRangeSlider({
                min: 3,
                max: 50,
                type: 'double',
                prefix: "&#8377; ",
                postfix: ' Lacs',
                maxPostfix: "+ ",
                prettify: false,
                hasGrid: true,
                step: 0.10
            });
            
            $('.irs-slider.to').css({
            	"border":"solid 2px #1ab394",
            	"background":"white",
            	"border-radius" : "3px"
            });
            
            $('.irs-slider.from.last').css({
            	"border":"solid 2px #1ab394",
            	"background":"white",
            	"border-radius" : "3px"
            });
            
            
            
            $('.tagsinput').tagsinput({
        		confirmKeys: [13, 32, 188],
                tagClass: 'label label-primary'
            });                     
        });


		$('#create_update_stages').click(function (e) {
			var buttonContext = $('#create_update_stages');
		 swal({
		        title: "Confirm stages submission?",
		        text: "You wont be able to change the number of stages. However, you can always update the stage names and type",
		        type: "warning",
		        showCancelButton: true,
		        confirmButtonColor: "#1ab394",
		        confirmButtonText: "Submit",
		        closeOnConfirm: true
		    }, function () {
		    	
		    	
		    	$(buttonContext).button('Submitted');
		    	//$(buttonContext).attr('disabled',true);
		 var stage_names=[];
		 var stage_types=[];
		 var assessment_ids=[];
		 var panelists =[];
		 var other_infos=[];
		 var test_urls=[];
		 
		 var vacancy_iddd=$('#vacancy_iddd').val()!=null ? $('#vacancy_iddd').val() : "none";
		 
		 $('.concrete_stages').each(function (index, value) {
		  var id = $(this).attr('id');
		  var stage_count=id.replace("stage_name_","");
		  var stage_name=$("#stage_name_"+stage_count).val()!= null ? $("#stage_name_"+stage_count).val():"none";
		  var stage_type=$("#id_stage_selector_"+stage_count).val()!= null ? $("#id_stage_selector_"+stage_count).val() : "none";
		  var assesment_id="none";
		  var panel="none";
		  var varURL = "none";
		  var other_info="none";
		  if(stage_type==='assessment')
			{
			  assesment_id = $("#id_stage_action_"+stage_count).val() !=null ?$("#id_stage_action_"+stage_count).val() : "none";
			}
		  else if(stage_type==='interview')
			  {
			  panel=$("#stage_interviewer_id_"+stage_count).val()!= null ? $("#stage_interviewer_id_"+stage_count).val(): "none";
			  }
		  else if(stage_type=='external_assessment')
		  {
			  varURL = $("#stage_external_assesment_id_"+stage_count).val()!=null ? $("#stage_external_assesment_id_"+stage_count).val() : "none";
			  console.log(varURL);
		  }
		  else 
			  {
			  other_info=$("#stage_other__id_"+stage_count).val()!=null ? $("#stage_other__id_"+stage_count).val() : "none" ;
			  } 
		  stage_names.push(stage_name);
		  stage_types.push(stage_type);
		  assessment_ids.push(assesment_id);
		  panelists.push(panel);
		  test_urls.push(varURL);
		  other_infos.push(other_info);
		}); 
		 $.ajax({
		        type: "POST",
		        url: '<%=baseURL%>create_update_workflow',
		          data: {
		        	  stage_names: stage_names,
		        	  stage_types: stage_types,
		        	  assessment_ids: assessment_ids,
		        	  panelists: panelists,
		        	  test_urls : test_urls,
		        	  other_infos: other_infos,
		        	  vacancy_iddd: vacancy_iddd
		          },
					success : function(data) {
						console.log("Created");
						$('#btnAdd').attr('disabled',true);
						$('#btnDel').attr('disabled',true);
						$(buttonContext).attr('disabled',true);
				},error : function(){
					
					$(buttonContext).button('Failed').delay(1000).queue(function(){
			            $(this).button('reset');
			            $(this).dequeue();
					})
				}
		});
			     });
		 
				$('.sa-icon').hide();
		  });
       
   $("#skill_selector").select2().on('select2:select', function (e) {     	
   	    var last_selected_skill_id=$(this).find(':selected:last').val();
   	    var selected_skill_name= $(this).find(':selected:last').text();
   	    var html_perskill='<div class="row" style="margin-top: 8px;">';
   	    html_perskill+='<label class="col-sm-3 control-label">'+selected_skill_name+'</label>';
   	    html_perskill+='<div class="col-sm-9">';
   	    html_perskill+='<select class="select2_demo_2 form-control skill_percentile" name="skill_percentiles" id="skill_percentile_id_'+last_selected_skill_id+'">	';									
   	    html_perskill+='<option value=">0">ALL</option>';
   	    html_perskill+='<option value=">35">More than 35 percentile</option>';
   	    html_perskill+='<option value=">60">More than 60 percentile</option>';
   	    html_perskill+='<option value=">80">More than 80 percentile</option>';
   	    html_perskill+='<option value=">90">More than 90 percentile</option>';
   	    html_perskill+='<option value=">95">More than 95 percentile</option>';										
   	    html_perskill+='</select>';
   	    html_perskill+='</div>';
   	    html_perskill+='</div>';
 		$(html_perskill).appendTo('#skill_percentile_dynamic_box');
   	});
   
   
   

	$('#btnAdd').click(function (e) {
		var panelistt= '';
	  	var nextTab = $('#stage_tab li').size()+1;
	  	
	  	// create the tab
	  	
	  	$('<li class="tab_number_'+nextTab+'" id="tab_number" data-tab_number="'+nextTab+'"><a data-toggle="tab" href="#stage_'+nextTab+'" >Stage '+nextTab+'</a></li>').appendTo('#stage_tab');
	  	
		// create the tab content
	 var content='<div id="stage_'+nextTab+'" class="tab-pane active">';
	 content=content+'<div class="panel-body tab_number_'+nextTab+'" data-tab_number="'+nextTab+' style="margin-left: 0%; min-height: 150px !important;">';
	 content=content+'<div class="form-group">';
	content=content+'<label>Stage Name *</label> <label class="error" for="stageName"';
	content=content+'style="display: none;"></label> <input id="stage_name_'+nextTab+'"';
	content=content+'name="stage_title_'+nextTab+'" type="text"';
	content=content+'class="form-control required valid concrete_stages" aria-required="true"';
	content=content+'aria-invalid="false" value="Stage Name">';
	content=content+'</div>';
	content=content+'<div class="row">';
	content=content+'<div class="form-group col-md-6">';
	content=content+'<select class="form-control m-b stage_selector" id="id_stage_selector_'+nextTab+'"  name="stage_type_'+nextTab+'">';
	content=content+'<option value="null">Select Stage Type</option>';
	content=content+'<option value="assessment">Test</option>';
	content=content+'<option value="external_assessment">External Assessment Test</option>';
	content=content+'<option value="interview">Interview</option>';
	content=content+'<option value="other">Other</option>';
	content=content+'</select>';
	content=content+'</div>';
	content=content+'<div class="form-group col-md-6 test_action_form'+nextTab+'"  id="test_action_form_'+nextTab+'">';
	content=content+'<select class="form-control m-b id_stage_action_'+nextTab+'" name="stage_action_'+nextTab+'" id="id_stage_action_'+nextTab+'" >';
	content=content+'</select>';
	content=content+'</div>';
	content=content+'</div>';
	content=content+'<div class="form-group interview_action_form'+nextTab+'" id="interview_action_form_'+nextTab+'" >';
	content=content+'<label>Select Interviewer *</label> <input ';
	content=content+'class="tagsinput form-control tag_inputs_elements" type="text"';
	content=content+'name="stage_interviewer_'+nextTab+'" id="stage_interviewer_id_'+nextTab+'" value="'+panelistt+'"/>';
	content=content+'</div>';
	content=content+'<div class="form-group url_action_form" id="url_action_form_'+nextTab+'">';
	content=content+'<label> URL </label>';
	content=content+'<input type="text" name="stage_external_assesment_'+nextTab+'" placeholder="https://www.topcoder.com/" class="form-control" id="stage_external_assesment_id_'+nextTab+'" value=""/>';						
	content=content+'</div>';
	content=content+'<div class="form-group other_action_form'+nextTab+'" id="other_action_form_'+nextTab+'" >';
	content=content+'<label>Enter Details about stage*</label>';
	content=content+'<textarea rows="4" cols="50" class="form-control stage_other_id_'+nextTab+'"';
	content=content+'name="stage_other_'+nextTab+'" id="stage_other__id_'+nextTab+'" >';
	content=content+'Details about stage.';
	content=content+'</textarea>';
	content=content+'</div>';
	content=content+'</div>';
	content=content+'</div>';
	
	  	$(content).appendTo('.concrete_stage_content');
	
	   	$('#test_action_form_'+nextTab).hide();
	   	$('#interview_action_form_'+nextTab).hide();
	   	$('#other_action_form_'+nextTab).hide(); 
	   	$('#url_action_form_'+nextTab).hide();
	   	$('.tagsinput').tagsinput({
	   		confirmKeys: [13, 32, 188],
	           tagClass: 'label label-primary'
	       });
	
	  	// make the new tab active
	  	$('#stage_tab a:last').tab('show');	
	  	EnableDisableDelBtn();
	});
	
	
	
	$('#btnDel').click(function() {
		var tab_number = $("ul#stage_tab li.active").data('tab_number');
		if(tab_number >0){
			$('li.tab_number_'+tab_number).remove();
			$('.tab_number_'+tab_number).remove();
			$('#stage_'+tab_number).remove();
			
			$('#stage_tab a:last').tab('show');
			numberPages();
		}
		else{
			alert("The Vacancy must have atleast one stage");
		}
		EnableDisableDelBtn();
	});
	
	function numberPages() {		
		var tabNumber =0;
		var tabCount = $('#stage_tab li').length;
		$('#stage_tab li').each(function(){
			tabNumber++;
			$(this).children('a').html('Stage ' + tabNumber);
			var currentClassName = $(this).attr('class');
			$(this).children('a').switchClass(currentClassName, 'tab_number_'+tabNumber);
			//attr('class','tab_number_'+tabNumber);
			//$(this).children('a').attr('class') = 'tab_number_'+tabNumber;
		})
	}
	
	function EnableDisableDelBtn(){
		var stage_tab_count = 0;
    	stage_tab_count = $('.concrete_stage_content .tab-pane').length;
    	 if(stage_tab_count == 1){
    		 $('#btnDel').attr('disabled',true);
    	 }else{
    		 $('#btnDel').attr('disabled',false);
    	 }
        }


	$($(document)).on("change", ".stage_selector", function(){
		  	 var id = $(this).attr('id');
			 var stage_id = id.replace("id_stage_selector_", "");
			 var stage_type=  this.value;	
				if(stage_type==='assessment')
					{					
					$('#interview_action_form_' + stage_id).hide();
		        	$('#other_action_form_' + stage_id).hide();
		        	$('#url_action_form_'+ stage_id).hide();		        	
					 $.ajax({
		                    type: "POST",
		                    url: '<%=baseURL%>get_all_job_assessment',
					success : function(data) {
						$('#id_stage_action_' + stage_id).html(data);
						$('#test_action_form_' + stage_id).show();
					}
				});
			} else if (stage_type === 'interview') {
				$('#test_action_form_' + stage_id).hide();
				$('#other_action_form_' + stage_id).hide();
				$('#interview_action_form_' + stage_id).show();
				$('#url_action_form_'+ stage_id).hide();
			} else if (stage_type === 'external_assessment'){
				$('#test_action_form_' + stage_id).hide();
				$('#interview_action_form_' + stage_id).hide();
				$('#other_action_form_' + stage_id).hide();
				$('#url_action_form_'+ stage_id).show();
			} else {
				$('#test_action_form_' + stage_id).hide();
				$('#interview_action_form_' + stage_id).hide();
				$('#other_action_form_' + stage_id).show();
				$('#url_action_form_'+ stage_id).hide();
			}
		});
	
		$('#invite_hiring_team').click(function (e) {	
			
			var buttonContext = $(this);
			$(buttonContext).button('loading');

			 var hiring_team_email=$("#id_hiring_team_email").val()!= null ? $("#id_hiring_team_email").val(): "none";
			 var vac_id =  $('#vacancy_iddd').val()!=null ? $('#vacancy_iddd').val() : "none";
			 
			 $.ajax({
		          type: "POST",
		          url: '<%=baseURL%>invite_hiring_team',
					data : {
						hiring_team_email : hiring_team_email,
						vac_id : vac_id
					},
					success : function(data) {
						$('#invite_hiring_team').html("Inviting...");
						$(buttonContext).button('reset');
					},error : function(){
						$(buttonContext).button('reset');
					}	});	
					});
		</script>
		
		<script>
			$(document).ready(function(){
				
				$('.feed-activity-list').jscroll({
					loadingHtml: '<img src="/img/loader.gif" alt="Loading" style="margin: 0 auto; display:block;"/>',
					padding: 20
				});
			});
</script>

</body>
</html>
