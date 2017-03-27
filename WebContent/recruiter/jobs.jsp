<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><%@page import="com.istarindia.apps.dao.*"%>
<!DOCTYPE html>
<html>
<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	Recruiter recruiter = (Recruiter) request.getSession().getAttribute("user");
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify Recruiter | Dashboard <%=recruiter.getName()%></title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">

<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css"
	rel="stylesheet">
<link
	href="<%=baseURL%>css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.css"
	rel="stylesheet">
<link
	href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/datapicker/datepicker3.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/clockpicker/clockpicker.css"
	rel="stylesheet">
<link
	href="<%=baseURL%>css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css"
	rel="stylesheet">
    <!-- Toastr style -->
    <link href="<%=baseURL%>css/plugins/toastr/toastr.min.css" rel="stylesheet">
    <link href="<%=baseURL%>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">

</head>

<body class="fixed-navigation">
	<div id="wrapper">
		<jsp:include page="includes/sidebar.jsp"></jsp:include>


		<div id="page-wrapper" class="gray-bg">
			<div class="row">
				<!-- header -->
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>


			<div class="wrapper" style="overflow:hidden;">

				<div class="tabs-container vacancy_jobs_tab row">
					<div class="vacancy_tabs_pane">
						<ul class="nav nav-tabs ">
							<%
			int intialIndex = 0;
			for (Vacancy vacancy : recruiter.getVacancies()) {
				if(vacancy.getStatus().equalsIgnoreCase("PUBLISHED")){
		%>
							<li class=""><a data-toggle="tab"
								href="#tab-vacancy-<%=vacancy.getId()%>" aria-expanded="true"><%=vacancy.getProfileTitle().length() > 10? vacancy.getProfileTitle().substring(0,10):vacancy.getProfileTitle()%><%=vacancy.getId()%></a></li>
							<%
				}
			}
		%>

							<button type="button" class="btn btn-w-m btn-success create_job">+
								Add Job</button>
						</ul>

					</div>
					<div class="tab-content row" style="background-color:white; min-height: 1024px;">
						<%
						if(recruiter.getVacancies().size() > 0){
							for (Vacancy vacancy : recruiter.getVacancies()) {
								if(vacancy.getStatus().equalsIgnoreCase("PUBLISHED")){
						%>
										<div id="tab-vacancy-<%=vacancy.getId()%>" class="tab-pane">
											<div class="panel-body jobs_tab_content_panel_body">
												<div class="tabs-container">
													<jsp:include page="recruiter_vacancy.jsp">
														<jsp:param value="<%=vacancy.getId()%>" name="vacancy_id" />
													</jsp:include>
												</div>
											</div>
										</div>
										<%
								}
						}
						}else{	
							%>
							<div class="empty_message">No Vacancy Posted</div><%
						}
		%>
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
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

		<script src="<%=baseURL%>js/jquery.jscroll.min.js"></script>
		
	<!-- Flot -->
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.tooltip.min.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.spline.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.resize.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.pie.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.symbol.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/curvedLines.js"></script>

	<!-- Peity -->
	<script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
	<script src="<%=baseURL%>js/demo/peity-demo.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>



	<!-- Jvectormap -->
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

	<!-- Sparkline -->
	<script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>

	<!-- Sparkline demo data  -->
	<script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>
	<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>
	<!-- ChartJS-->
	<script src="<%=baseURL%>js/plugins/chartJs/Chart.min.js"></script>

	<!-- MENU -->
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
	<!-- Data picker -->
	<script src="<%=baseURL%>js/plugins/datapicker/bootstrap-datepicker.js"></script>

	<!-- Clock picker -->
	<script src="<%=baseURL%>js/plugins/clockpicker/clockpicker.js"></script>
	<!-- Tags Input -->
	<script
		src="<%=baseURL%>js/plugins/bootstrap-tagsinput/bootstrap-tagsinput.js"></script>
    <!-- Toastr script -->
    <script src="<%=baseURL%>js/plugins/toastr/toastr.min.js"></script>

    <!-- Jasny -->
    <script src="<%=baseURL%>js/plugins/jasny/jasny-bootstrap.min.js"></script>
    <script src="<%=baseURL%>js/highcharts-custom.js"></script>


	<script>
	//Count Number of Selected Students
		function validateSelectedCount(stage_id) {
	    	var count = 0;
	    	console.log("validateSelectedCount");
	    	$('input:checkbox:checked.' + stage_id).each(function() {
	            count++;
       		});
	    	$('.selection_count.'+ stage_id).html(count);
	    }
		
		function disablePromoteButton(){
			var stage_id = $(this).data('stage');
		}
		
 		//Count number of Student in each stage
		 function studentCountPerStage(){
			 console.log("Counting students in each stage");
			 
			$('input.student_count_stage').each(function(){
				 var stage = $(this).data('stage');
				 var vacancy = $(this).data('vacancy');
				 var college = $(this).data('college');
				 var count = 0;	
				 count = $(this).val();							
				 console.log('Stage Size: ' + count);
				 $('.stages_tab'+vacancy+college +' > li > a[data-stage="'+stage+'"] > i').html('('+(count)+')');
			})
		 }; 
		
/* 		//Count number of Student in each stage
		 function studentCountPerStage(){
			 $('.stages_tab > li').each(function() {
				 var stage = $(this).data('stage');
				 var vacancy = $(this).data('vacancy');
				 var count = 0;			 
				count = $('#list_students--'+stage+'-'+vacancy).find('.student_holder_actor').length;				
				$('.stages_tab > li > a[data-stage="'+stage+'"] > i').html('('+(count-1)+')');
			 })
		 }; */
		 
			function toggleFilterStudentList(){
				$('.list_filter_tab [data-toggle=tab]').click(function(){
					  if ($(this).parent().hasClass('active')){
						$($(this).attr("href")).toggleClass('active');
						$(this).closest('.list_filter_pane .tab-pane').toggleClass('active');
					  }
					})
				};
		 
				function initializeTabs() {
					$('.nav-tabs').each(function() {
						$(this).find('li > a:first').click();	
					});
					
					$('.feed-activity-list > .student_holder_actor:nth-child(2)').each(function() {
						showStudentInfo(this);
					});
				}
				
				function showStudentInfo(element) {
					 //To display the right side student pane for Student Card and Chat between recruiter and student
			        var ID = $(element).attr("id");
			        console.log("Student ID->" + ID);
			        var stage_id = $(element).data('stage_id');
			        var vacancyID = $(element).data('vacancy_id');
			        var collegeID = $(element).data('college');
			        var url = "/recruiter/right_side_pane.jsp?student_id="+ID;
			        console.log(url);
			        $.ajax(url, {
			            success: function(data) {
			                $("#student_pane--"+collegeID+ stage_id).html(data);
			            },
			            error: function() {
			            }
			        }); 
				}
				
				
		$(document).ready(function() {	
			
			initializeTabs();
			
			//Width of Promote Tab
			var widthOfPromote = $('.feed-activity-list').width();
			$('.promote_tab').width(widthOfPromote);
			
			studentCountPerStage();			
			toggleFilterStudentList();	
			
			$('#interview_scheduler').hide();
			$('#chat_form').hide();
			$('#offer_letter').hide();

		    $($(document)).on("click", ".student_holder_actor", function() {
		    	showStudentInfo(this);
		    });	 
		    
		    //Display Chat Window on click
		    var chatFormDisplay = false;
		    $($(document)).on("click", ".chat_box11111", function() {
		    
		    	if(chatFormDisplay == false){
		    		console.log("DISPLAYING CHAT FORM");
		    	//To display "Send Message aka Notification" for each student
   	 			$('#interview_scheduler').hide();
				$('#offer_letter').hide();
				
		    	 $("#chat_form textarea").each(function() {
				      this.value = "";
				});
		    	 
		    	 var sender_id='<%=recruiter.getId()%>';
		    	
		        var ID = $(this).attr("id").split("--")[2];
		        var receiver_id=ID;
		    	 $.ajax({
		             type: "POST",
		             url: '<%=baseURL%>get_chat_history',
		             data: {
		            	 sender_id: sender_id,
		            	 receiver_id: receiver_id
		            	            	 
		             },
				success : function(data) {
				        $("#chat_form .chat-message").html("");
				        $("#chat_form .chat-message").html(data);
				        
				}
			});
		    	 $(this).closest('.student_holder_actor').append($("#chat_form"));
			        $("#chat_form #idd_student_id").val(ID);
			        $('#chat_form').show();
			    	chatFormDisplay = true;	
		    	}else{
		    		console.log("CHAT FORM NOT DISPLAYED");
		    		chatFormDisplay = false;
		    		$('#chat_form').hide();
		    	}      		       
		    });
		    
		    $($(document)).on("click", ".student_notification", function() {
		        //An ajax call to send notification to a student individually
		        
		        var buttonContext = $(this);
		        $(buttonContext).button('loading');
		        
		        var ID = $("#chat_form #idd_student_id").val();
		        var url = "/send_notification_recruiter?student_id=" + ID + "&msg=" + $("textarea.message-input").val() + "&recruiter_id=" + $("#idd_recruiter_id").val();
		        var sender_id='<%=recruiter.getId()%>';
		        var receiver_id=ID;
		        $.ajax(url, {
		            success: function(data) {				             
			            	 if($("textarea.message-input").val()!=""){	
		            	var current_message="<div class='message' style=' margin-left: 0px; padding: 10px 7px;'><span class='message-date'> moments ago </span><span class='message-content'>"+$("textarea.message-input").val()+"</span></div>";		            	
				             $('#chat_form .chat-message').append(current_message);	
				             $("#chat_form textarea").each(function() {
							      this.value = "";
							  	});
			            	 }
			            	 $(buttonContext).button('reset');		
		            },
		            error: function() {
		            	$(buttonContext).button('reset');
		            }
		        });
		    });
		    
		    //Display Offer Letter on click
		    var offerLetterDisplay = false;			
			$($(document)).on("click", ".offer_letter_button", function() {
				$('#interview_scheduler').hide();
				$('#chat_form').hide();
				if(offerLetterDisplay==false){		
				$(this).closest('.student_holder_actor').append($('#offer_letter'));
				var stageID = $(this).data('stage');
				var vacancyID= $(this).data('vacancy');
				var studentID = $(this).data('student');
				$('#offer_letter #idd_vacancy_id').val(vacancyID);
				$('#offer_letter #idd_stage_idd').val(stageID);	
				$('#offer_letter #idd_student_id').val(studentID);
				offerLetterDisplay=true;
				$('#offer_letter').show();
				}else{
					offerLetterDisplay=false;
					$('#offer_letter').hide();
				}
			});
			
		    //Display Calendar Box on Click to Schedule Interview
		    var calendarBoxDisplay = false;
		    $($(document)).on("click", ".calendar_box", function() {
		    	$('#chat_form').hide();
		    	$('#offer_letter').hide();
		    	
		    	//To display "Interview Scheduler" for each student 
		    	if(calendarBoxDisplay==false){
		        var ID = $(this).attr("id");
		        console.log(ID);
		        var vacancy_id=ID.split("--")[0].replace("student_scheduler_box","");
		        var stage_id=ID.split("--")[1];
		        var student_id =ID.split("--")[2];
		     	console.log(vacancy_id);
		     	console.log(stage_id);
		     	console.log(student_id);
		     	var interview_details='';
		     	 $.ajax({
		             type: "POST",
		             url: '<%=baseURL%>get_interview_details',
		             data: {
		            	 vacancy_id: vacancy_id,
		            	 stage_id: stage_id,
		            	 student_id: student_id,
		            	            	 
		             },
				success : function(data) {
					/*  alert('id_session_id '+data); */
					var scheduled_data = data;
					console.log(scheduled_data);
					var panelist_email = scheduled_data.split('##')[0];
					var date = scheduled_data.split('##')[1];
					var time = scheduled_data.split('##')[2];
					$("#interview_scheduler select").each(function() {
					      this.value = "";
					  	});
					
					
					if(scheduled_data.endsWith("none"))
					{
							$("#interview_scheduler input").each(function() {
						      this.value = "";
						  	});
							
							
					}
					else
					{
						$('#interview_scheduler .interview_date').val(date);
						$('#interview_scheduler .interview_time').val(time);
						
						
					}
					
					var panelist_array = new Array();
					for (i = 0; i < panelist_email.split(",").length; i++) { 
					    var panel_email = panelist_email.split(",")[i];
					    var panel = new Object;
					    panel['id']=panel_email;
					    panel['text']= panel_email;
					    panelist_array.push(panel);
					}
					console.log(panelist_array.length);
					$('#interview_scheduler select').select2({
						  data: panelist_array,
						  width: 300,
						});
					
					
					$('#'+ID).closest('.student_holder_actor').append($("#interview_scheduler"));		
			    	console.log('++++++++++'+vacancy_id);
			     	console.log('++++++++++'+stage_id);
			     	console.log('++++++++++'+student_id);
			        $("#interview_scheduler #idd_student_id").val(student_id);
			        $("#interview_scheduler #idd_vacancy_id").val(vacancy_id);
			        $("#interview_scheduler #idd_stage_id").val(stage_id);
			     	$('#interview_scheduler').show();
			     	calendarBoxDisplay=true;
				}
			});
		    	}
		    	else{
		    		calendarBoxDisplay=false;
		    		$('#interview_scheduler').hide();
		    	}
		    });
		    
		    $($(document)).on("click", ".schedule_interview", function() {
		        //An ajax call to send notification to a student individually
		        
		        var buttonContext = $(this);
		        $(buttonContext).button('loading');
		        
		        var ID =  $("#interview_scheduler #idd_student_id").val();
		        var url = "/schedule_interview?recruiter_id="+<%=recruiter.getId()%>+"&student_id=" + ID + "&panelist=" + $('#interview_scheduler select').val() + "&date=" + $("input.interview_date").val()+" &time="+$("input.interview_time").val()+" &vacancy_id="+ $("#interview_scheduler #idd_vacancy_id").val()+" &stage_id="+$("#interview_scheduler #idd_stage_id").val();
		        
		        $.ajax(url, {
		            success: function(data) {
		            	$(buttonContext).button('reset');
			        	 $('#output_message').html(data);
			        	 $('#result_notification').modal('toggle');
		            },
		            error: function() {
		            	 $(buttonContext).button('reset');
				         $('#output_message').html("Invalid Request! Please try again.");
				         $('#result_notification').modal('toggle');
		            }
		        });
		    });
		    
		    //var selectAll = false;
		    $($(document)).on("change", ".allCheck", function() {
		        // find All students checkboxes with class .vacancy_id and select them		        
		        var stage_id = $(this).data('stage');
		        var vacancy_id = $(this).data('vacancy');
		        var college = $(this).data('college');
		        var allChecked = $(this).data('checked');
		        console.log("initially "+allChecked);

		        console.log("vacancy id for icheck->" + vacancy_id);
		        console.log("stage id for icheck->" + stage_id);
		        if(allChecked == false){		        	
		        	$('input:checkbox.student_checkbox-' + vacancy_id + '-'+stage_id).each(function() {
			            $(this).prop('checked', true);    
			        });
		        	$(this).data('checked', true);
		        }else{
		        	$('input:checkbox.student_checkbox-' + vacancy_id + '-'+stage_id).each(function() {
			            $(this).prop('checked', false);    
			        });
		        	$(this).data('checked', false);
		        }
		    });
		    
	        // Ajax call to promote all the selected students to next stage
		    $($(document)).on("click", ".promote_students", function() {
		    	
		    	var buttonContext = $(this);
		    	$(buttonContext).button('loading');
		    	
		        var vacancy_id = $(this).data('vacancy');
		        var stage_id=$(this).data('stage');
		        var college = $(this).data('college');
		        
		        var students = "";
		        $('input:checkbox.student_checkbox-' + vacancy_id + '-'+stage_id+college+':checked').each(function() {		        	
		            students = students + "," + $(this).data("student_id");
		            console.log(students);
		            console.log("CALLING FUNCTION");
		            //promoteStudentToNextStage(vacancy_id,stage_id,college, this)
		        });
		        var url = "/promote_students?vacancy_id=" + vacancy_id +"&stage_id="+stage_id+"&students=" + students;
		        console.log(url);
		        $.ajax(url, {
		            success: function(data) {
		            	console.log("Student Promoted");
		            	console.log("PROMOTED and calling Toastr");
		            	$(buttonContext).button('reset');
		            	toastrMessageForPromoteStudent(data,vacancy_id,stage_id,college);
		            },
		            error: function() {
		            	$(buttonContext).button('reset');

		            }
		        });
		    });
	        
	        function promoteStudentToNextStage(vacancy,stage,college, student){
	        	
		        var student_container = 	$(student).closest('.student_holder_actor');
		        var student_container_id = student_container.attr('id');
		        var stage_container = $(student_container).closest('.stage_tab_content');	        
		        var currentIndex = $(stage_container).data('current');
		        var maxIndex = $(stage_container).data('max');
		        
		        
		        var cloned = $(student_container).clone();
		        
		        if(currentIndex < maxIndex){
		        	var new_stage_container = $(stage_container).next();
		        	var new_student_list = $(new_stage_container).find('.feed-activity-list');
		        	var new_sibling = $(new_stage_container).find('#spy');
		        	
		        	var sibling_attributes = $(new_sibling).prop("attributes")	        	
		        	var input_checkbox = $(cloned).find('input:checkbox');
		        	var sibling_input_checkbox = $(new_sibling).find('#spy-input');	        	
		        	var sibling_checkBoxAttriubte = $(sibling_input_checkbox).prop("attributes");
		        	
		        	$.each(sibling_attributes, function() {
		        		if(this.name!='id' && this.name!='style'){
		        		$(cloned).attr(this.name, this.value);
		        		}
		        	});
		        	
		        	$.each(sibling_checkBoxAttriubte, function() {
		        		if(this.name!='id' && this.name!='data-student_id' && this.name!='type'){
		        		$(input_checkbox).attr(this.name, this.value);	        		
		        		}
		        		
		        		$(input_checkbox).removeClass(new_sibling.attr('id')).addClass(student_container_id);
		        		input_checkbox.prop('checked',false);
		        		$(student_container).find('input:checkbox').prop('checked',false);
		        	});
		        	
		        	$(new_student_list).append(cloned);
		        }else{
		        	console.log("STUDENT IS ALREADY OFFERED this POSITION");
		        }
		        
		        }
		    
		    function toastrMessageForPromoteStudent(data,vacancy_id,stage_id,college){		    	
		    	var studentData = data.split('##');
		    	console.log("STUDENT DATA:" + studentData );
		    	$.each(studentData, function(index, value){
		    		if(value!='' && value!=null){
		    		var studentArray = value.split(',');
		    		var studentName = studentArray[0];
		    		var studentID = studentArray[1];
		    		var statusCode = studentArray[2];
		    		var statusMessage = studentArray[3];
		    		var statusType = ["success","info","warning","error"];
		    		console.log("STATUS CODE is:" + statusCode);
		    		toastr[statusType[statusCode]](studentName +" " +statusMessage);
		    		
		    		if(statusCode == 0){
			        $('input:checkbox.student_checkbox-' + vacancy_id + '-'+stage_id+college+':checked').closest('#'+studentID).each(function() {		        	
			            console.log("CALLING FUNCTION");
			            promoteStudentToNextStage(vacancy_id,stage_id,college, this);
			            $(this).prop('checked', false);
			        });
		    		}
		    		console.log("STUDENT ID:" + studentArray[0] + " Message: " +studentArray[1].substring(1));
		    		toastr.options = {
		    				  "closeButton": true,
		    				  "debug": false,
		    				  "progressBar": true,
		    				  "preventDuplicates": false,
		    				  "positionClass": "toast-top-right",
		    				  "onclick": null,
		    				  "showDuration": "400",
		    				  "hideDuration": "1000",
		    				  "timeOut": "7000",
		    				  "extendedTimeOut": "1000",
		    				  "showEasing": "swing",
		    				  "hideEasing": "linear",
		    				  "showMethod": "fadeIn",
		    				  "hideMethod": "fadeOut"
		    				}
		    		}
		    	});
		    	
		    	studentCountPerStage();
		    	colorStudentBasedUponPercentile();
		    }
 

		    
		    //Open a new Tab to create new Jobs
		    $($(document)).on("click", ".create_job", function() {
		       var win = window.open('/recruiter/vacancy/create_new_vacancy.jsp');
				if (win) {
				    win.focus();
				} else {
				    alert('Please allow popups for this website');
				}
		    });
		});
		
	    function colorStudentBasedUponPercentile(){
		    //Color Student Profile Photo Border based upon percentile
		    $('.profile_image').each(function() {
				var studentID = $(this).data('student');
				
				var percentile = $(this).data('percentile');
				//console.log(studentID +"->"+ percentile);
				

				if(percentile <= 25){
				//	console.log("Less than 25");
				$('.student_image-'+studentID).css({
		             "border": "solid",
					"border-color": "#e21b1b",
					 "border-weight":"1px", 
		             "border-style":"solid"
				})
				}
				else if (percentile <=50){
					//console.log("Less than 50");
					$('.student_image-'+studentID).css({
			             "border": "solid",
						"border-color": "#de9d23", 
			             "border-weight":"1px", 
			             "border-style":"solid"
					})
				}
				
				else if (percentile <=75){
					//console.log("Less than 75");
					$('.student_image-'+studentID).css({
						"border": "solid",
						"border-color": "#619bc5", 
			             "border-weight":"1px", 
			             "border-style":"solid",
			             
					})
				}
				
				else if (percentile <=100){
					//console.log("Less than 100");
					$('.student_image-'+studentID).css({
			             "border": "solid",
						"border-color": "#23de4c", 
			             "border-weight":"1px", 
			             "border-style":"solid",
					})
				}
			});
		    }
		</script>

	<script>
		$(document).ready(function() {
			
			 $(".select2_demo_2").select2({
				 width: 'resolve'
			 });

			 $('.date_selector .input-group.date').datepicker({
	                todayBtn: "linked",
	                keyboardNavigation: false,
	                forceParse: false,
	                calendarWeeks: true,
	                autoclose: true
	            });
			 
			 $('.clockpicker').clockpicker({
					autoclose: true	 
			});

			
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
				"width":"300px",
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
			
			var filteredStudentIDs = "";
			
			$('.reset_button').click(function(){
				console.log("RESETTING");
				$('.cities').select2("val", "");
				$('.colleges').select2("val", "");
				$('.skills').select2("val", "");
				$('.degree_specializations').select2("val", "");
				$('.highschool_performance').val('0');
				$('.intermediate_performance').val('0');	
			})
			
			$('.filter_students').click(function (e){
				
				$('.student_holder_actor').each(function(){
					$(this).find('input:checkbox').prop('checked',false);
				});
				
				$('.student_holder_actor').each(function() {
					$(this).show();
				})
				
				var stage_identifier = $(this).data('stage_identifier');
				var vacancy_identifier = $(this).data('vacancy_identifier');
				
				var uniqId = $(this).closest('#filter_menu--'+stage_identifier+'-'+vacancy_identifier).attr('id');
				
				//var rank = $('#'+uniqId +'.rank:checked').val();
				var rank = $('#'+uniqId +' .rank:checked').val();
				var cities = $('#'+uniqId +' .cities').val();
				var colleges = $('#'+uniqId +' .colleges').val();
				var ugDegrees = "";
				
				$('input.ug_degrees:checkbox:checked').each(function() {
					ugDegrees = ugDegrees + "," + $(this).data('degree');
	       		});
			
				var pgDegrees = "";
				
				$('input.pg_degrees:checkbox:checked').each(function() {
					pgDegrees = pgDegrees + "," + $(this).data('degree');
	       		});
				
				var specializations = $('#'+uniqId +' .degree_specializations').val();
				
				var highschool_performance = $('.highschool_performance').val();
				var intermediate_performance = $('.intermediate_performance').val();				
				var skills = $('#'+uniqId +' .skills').val();
				
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
		            	 vacancyID: vacancy_identifier,
		            	 stageID: stage_identifier,
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
					
					var studentIDArray = filteredStudentIDs.split(',');					
					console.log(studentIDArray);
					var condition = '[data-stage="'+stage_identifier+'"]';
					//var acondtion = "'"+condition+"'";
					
					$('.student_holder_actor').filter(condition).each(function( index ) {
							  console.log( index + ": checking ids " + $( this ).attr('id') );

						  if($.inArray($( this ).attr('id'), studentIDArray) > -1){
							 console.log( index + ": " + $( this ).attr('id') );
							  $(this).show();
						  }else{
							  console.log("Hiding Unfiltered IDs");
							  $(this).hide();
						  }
						});
					$('.list_filter_tab--'+stage_identifier+'-'+vacancy_identifier + ' a:first').tab('show');
				}
			});
		       	 
		});
		});
</script>

<script>
			$(document).ready(function(){
				
				colorStudentBasedUponPercentile();
				
				$('.feed-activity-list').jscroll({
					loadingHtml: '<img src="/img/loader.gif" alt="Loading" style="margin: 0 auto; display:block;"/>',
					padding: 20,
					callback:  colorStudentBasedUponPercentile
				});
			});
</script>

	<div id="chat_form" class="b-r-lg row student_list_dropbox p-sm b-r-lg">
		<div class="">
		<h4>Send Message to Student</h4>
			<div class="b-r-md row" style="background-color: white; height: 220px;">
				<input type="hidden" name="student_id" id="idd_student_id" />
				<div class="chat-discussion" style="padding: 8px;">
					<div class="chat-message left" style="padding: 0px"></div>
				</div>
			</div>
			<div class="row" style="margin-top: 15px;">
				<textarea
					class="form-control message-input b-r-md pull-left col-md-3"
					style="height: 40px !important;margin-left: 16px;width:65%;"></textarea>
				<button class="btn btn-sm btn-primary student_notification col-md-3" data-loading-text="Sending"
					style="margin-left: 10px; margin-top: 5px; padding-top: 8px;"> Send </button>
			</div>
		</div>
	</div>
	
		<div id="interview_scheduler" class="student_list_dropbox p-sm b-r-lg">
	<div class="p-sm b-r-lg" style="padding:8px;">
		<h4 class="col-md-12">Select Interview Schedule</h4> 
		<div class="row">
			<div class="form-group col-md-6 date_selector" style="padding-left:0px;padding-right:0px;">
			<label>Date</label> 
				<input type="hidden" name="student_id" id="idd_student_id" /> 
				<input type="hidden" name="vacancy_id" id="idd_vacancy_id" /> 
				<input type="hidden" name="stage_id" id="idd_stage_id" />
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" class="form-control interview_date">
				</div>
			</div>
			<div class="form-group clockpicker col-md-6">
			<label>Time</label>
				<div class="input-group time">
					<span class="input-group-addon"><i class="fa fa-clock-o"></i></span><input 
						type="text" class="form-control interview_time"> 
				</div>
			</div>
		</div>
		<div class="form-group row" style="padding-left: 20px;">
			<label class="col-md-11" style="padding-left:0px;">Add Panelist(s)</label>
			<div class="row">
			<select
				class="select2_demo_2 form-control panelist col-md-9"
				multiple="multiple">
			</select>
			<button class="btn btn-sm btn-primary schedule_interview pull-right col-md-2" data-loading-text="Inviting"
				style="margin-right: 15px;padding-left: 0px;padding-right: 0px;"><center>Invite</center></button> 
			</div>

		</div>
		</div>
	</div>

	<div id="offer_letter" class="student_list_dropbox p-sm b-r-lg">
		<form action="<%=baseURL%>sendOfferLetterToStudent" method="POST"
			enctype="multipart/form-data" class="form-group" style="padding-left:20px;padding-bottom:10px;">
			<input type="hidden" name="vacancy_id" id="idd_vacancy_id" /> <input
				type="hidden" name="stage_id" id="idd_stage_idd" /> <input
				type="hidden" name="student_id" id="idd_student_id" />

			<div class="row">
			<label>Select Offer Letter</label> 
				<div class="fileinput fileinput-new input-group col-lg-11"
					data-provides="fileinput">
					<div class="form-control" data-trigger="fileinput">
						<i class="glyphicon glyphicon-file fileinput-exists"></i> <span
							class="fileinput-filename"></span>
					</div>
					<span class="input-group-addon btn btn-default btn-file"> <span
						class="fileinput-new">Select file</span> <span
						class="fileinput-exists">Change</span> <input type="file"
						name="student_offer_letter" id="student_offer_letter" accept=".pdf,.PDF"/>
					</span> <a href="#"
						class="input-group-addon btn btn-default fileinput-exists"
						data-dismiss="fileinput">Remove</a>
				</div>
			</div>
			<div class="col-lg-12" style="padding-bottom:10px;">
				<button type="submit"
					class="btn btn-sm btn btn-success send_offer_letter pull-right">
					<i class="fa fa-upload"></i>&nbsp;&nbsp;<span class="bold">Upload</span></button>
			</div>
		</form>
	</div>
	
	<div id="modal-form" class="modal fade" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-12 b-r">
							<h3 class="m-t-none m-b">Send Message</h3>


							<div class="form-group">
								<label class="form-control" style="border: 0px;">Message</label>
								<input type="hidden" name="student_id" id="idd_student_id" /> <input
									type="hidden" name="recruiter_id" id="idd_recruiter_id"
									value="<%=recruiter.getId()%>" />
								<div class="col-lg-12">

									<div class="col-lg-12">
										<textarea placeholder="Write text to send notification"
											id="fetch_text" class="form-control message-input"
											style="min-width: 350px;"></textarea>
									</div>
									<button
										class="btn btn-sm btn-primary pull-right m-t-n-xs student_notification_all"
										style="margin-right: 25px; margin-top: 8px;">Send</button>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="result_notification" class="modal fade" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-12 b-r" id="output_message">
						
						</div>
					</div>
				</div>
			</div>
		</div>
</div>	
</body>
</html>
<Script>
/* 		    $('.i-checks').iCheck({
                checkboxClass:	 'icheckbox_square-green',
                radioClass: 'iradio_square-green',
           }); */
           
           
           
           /* 		    $(document).on('ifChanged', '.allCheck', function(event) {
	    	
	    	var stage_id = $(this).data('stage');
	        var checkAll = $('input.select_all_students-' + stage_id);		        
	        var checkboxes = $('input:checkbox.' + stage_id);
	        
	        checkAll.on('ifChecked ifUnchecked', function(event) {
	        	console.log(event);
	            if (event.type == 'ifChecked') {
	                checkboxes.iCheck('check');
	            } else {
	                checkboxes.iCheck('uncheck');
		        	console.log("else");
	            }
	        });

	        checkboxes.on('ifChanged', function(event){
	        	console.log(event);
	            if(checkboxes.filter(':checked').length == checkboxes.length) {
	                checkAll.prop('checked', 'checked');
	            } else {
	            	checkAll.prop('checked', false);
	            }
	            checkAll.iCheck('update');
	        });
       }); */
	    

	 /*    $($(document)).on("click", ".select_none_students", function() {
	    	console.log("meh");
	        // find All students checkboxes with class .vacancy_id and select them 
	        var stage_id = $(this).data('stage');
	        $('input:checkbox.' + stage_id).each(function() {
	            $(this).prop('checked', false);
	        });
	        validateSelectedCount(stage_id);
	    });
	     */
	    /* $('.i-checks').change(function() {
	    	var stage_id = $(this).data('stage_id');
	        validateSelectedCount(stage_id);
	    }); */
	    

	    /* 			$($(document)).on("click", ".send_offer_letter", function() {

	    				var vacancyID = $('#offer_letter #idd_vacancy_id').val();
	    				var stageID = $('#offer_letter #idd_stage_id').val();
	    				var studentID = $('#offer_letter #idd_student_id').val();
	    				console.log("INPUT FILE VALUE:" + $('#student_offer_letter').val());
	    				var formData = new FormData($('#student_offer_letter')[0].files[0]);
	    				//formData.append('file',);
	    				console.log(formData);
	    				var url = '/sendOfferLetterToStudent?vacancy_id='+vacancyID+'&stage_id='+stageID+'&student_id='+studentID;
	    			    $.ajax({
	    			    	url: url,
	    			    	type: 'POST',
	    			        data: formData,
	    			        async: false,
	    			        cache: false,
	    			        contentType: false,
	    			        processData: false,   
	    			        success: function(data) {
	    			        	console.log("FORM SUBMITTED");
	    			        },
	    			        error: function() {
	    			            console.log("FAILED");
	    			        }
	    			    });
	    				
	    			});
	    			 */
	    
	    			 
	    			    
	    			    
	    			    
	    			  /*   $($(document)).on("click", ".student_notification_all", function() {
	    			    	 //An ajax call to send notification to the selected students of any stage
	    			        var vacancy_id =1; //$('.notify_all').data('vacancy');
	    			        console.log("vacancy_id", vacancy_id);
	    			        var message = $('#fetch_text').val();
	    			        console.log("message: ", message);
	    			        var students = "";
	    			        $('input:checkbox.' + vacancy_id + ':checked').each(function() {
	    			            students = students + "," + $(this).data("student_id");
	    			        });

	    			        var url = "/send_notification_recruiter?student_id=" + students + "&msg=" + message + "&recruiter_id=" + $("#idd_recruiter_id").val();
	    			        $('#modal-form').modal('toggle'); 
	    			        $.ajax(url, {
	    			            success: function(data) {
	    			            	//What and how a message should be displayed if successful?
	    			            },
	    			            error: function() {
	    			            	//What and how a message should be displayed if failed?
	    			            }
	    			        });
	    			    }); */
	    
           </Script>           
           
           	<%-- 		<div id="chat_form"
			style="width: 350px; margin-top: 10px; margin-left: 10px; display: none">
			<div class="col-lg-12">
				<div class="ibox float-e-margins" style="margin-bottom: 10px;">
					<div class="ibox-content" style="padding: 0px; border: 0px;">
						<div role="form" class="form-inline">
							<div class="form-group">
								<label class="form-control" style="border: 0px;">Message</label>
								<input type="hidden" name="student_id" id="idd_student_id" /> <input
									type="hidden" name="recruiter_id" id="idd_recruiter_id"
									value="<%=recruiter.getId()%>" />
								<div class="col-lg-12" style="width: 350px;">
									<textarea placeholder="Write text to send notification"
										class="form-control message-input" style="width: 320px;"></textarea>
								</div>
								<button
									class="btn btn-sm btn-primary pull-right m-t-n-xs student_notification"
									style="margin-right: 25px; margin-top: 8px;">Send</button>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div> --%>