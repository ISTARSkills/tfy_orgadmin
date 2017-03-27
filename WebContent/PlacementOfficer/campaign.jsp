<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	PlacementOfficer recruiter = (PlacementOfficer) request.getSession().getAttribute("user");
	System.out.println("-----------"+recruiter.getId());
	RecruiterServices recServices = new RecruiterServices();
%>
<meta charset="utf-8">
<meta name="vi  ewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify TPO | Dashboard <%=recruiter.getName()%></title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.css"	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/toastr/toastr.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
</head>

<body class="fixed-navigation">
	<div id="wrapper">
		<jsp:include page="includes/sidebar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row">
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>
				
			<div class="wrapper" style="overflow:hidden;">
				<div class="tabs-container college_tabs">
				
				<button type="button" data-toggle="modal" class="btn btn-w-m btn-success invite_recruiter" href="#add_recruiter">+
							Invite Recruiter</button>
				
					<ul class="nav nav-tabs college_tabs">
						<%
						if(recruiter.getCollege().getCollegeRecruiters().size() > 0){
							for (CollegeRecruiter cr : recruiter.getCollege().getCollegeRecruiters()) {
								if(recServices.hasLaunchedCampaign(cr.getRecruiter().getId(), recruiter.getCollege().getId())){
								String crNAME = cr.getRecruiter().getCompany().getName();
								if(crNAME.length() >10 ) {
									crNAME = cr.getRecruiter().getCompany().getName().substring(0,10);
								} %>
						<li class=""><a data-toggle="tab" href="#tab-<%=cr.getId()%>"><%=crNAME%></a></li>

							<%
								}
							}
						}
						%>

					</ul>

					<div class="tab-content college_tab_panel">
						<%
						if(recruiter.getCollege().getCollegeRecruiters().size() > 0){
						for (CollegeRecruiter cr : recruiter.getCollege().getCollegeRecruiters()) {
							if(recServices.hasLaunchedCampaign(cr.getRecruiter().getId(), recruiter.getCollege().getId())){
							%>
							<div id="tab-<%=cr.getId()%>" class="tab-pane college_tab" data-college="<%=cr.getRecruiter().getCompany().getId()%>">
								<div class="panel-body" style="padding-top: 2px; padding-left: 10px; padding-right:10px; padding-bottom: 3px; background-color:#666666;">
									<jsp:include page="recruiter_college.jsp">
										<jsp:param value="<%=cr.getRecruiter().getCompany().getId()%>" name="company_id" />
										<jsp:param value="<%=cr.getRecruiter().getId()%>" name="recruiter_id" />
										<jsp:param value="<%=recruiter.getCollege().getId()%>" name="college_id"/>	
									</jsp:include>
								</div>
							</div>
							<%
									}
								}
						}else{
							%><div class="empty_message"><p>No Campaigns for your college are available. Invite a recruiter to your college.</p></div><%
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
		<script	src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>


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
		<script	src="<%=baseURL%>js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>
				

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
/* 	//Count number of Student in each stage
	 function studentCountPerStage(){
				 $('.stages_tab > li').each(function() {
					 var stage = $(this).data('stage');
					 var vacancy = $(this).data('vacancy');
					 var college = $(this).data('college');
					 var count = 0;			 
					count = $('#list_students--'+stage+'-'+vacancy+college).find('.student_holder_actor').length;				
					$('.stages_tab'+vacancy+college +' > li > a[data-stage="'+stage+'"]').append('('+count+')');
				 })
	 }; */
	 
	 function studentCountPerStage(){
		 console.log("Counting students in each stage");
		 
			$('input.student_count_stage').each(function(){
			 var stage = $(this).data('stage');
			 var vacancy = $(this).data('vacancy');
			 var college = $(this).data('company');
			 var count = 0;	
			 count = $(this).val();							
			 console.log('Stage Size: ' + count);
			 $('.stages_tab'+vacancy+college +' > li > a[data-stage="'+stage+'"] > i').html('('+(count)+')');
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
			
			//Width of Send Notification to all Tab
			var widthOfPromote = $('.feed-activity-list').width();
			console.log("WIDTH->" + widthOfPromote);
			$('.send_notification_to_all').width(widthOfPromote);
			
			studentCountPerStage();
			
			
			$('#chat_form').hide();
			
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
		        console.log("ID_--------->" + ID);
		        var receiver_id=$(this).data('student_id');
		        console.log('REC--->' + receiver_id);
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
		        var url = "/send_notification_recruiter?student_id=" + ID + "&msg=" + $("textarea.message-input").val() + "&recruiter_id=" + $("#sender_id").val();
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
		        	$('input:checkbox.student_checkbox-' + vacancy_id + '-'+stage_id+college).each(function() {
			            $(this).prop('checked', true);    
			        });
		            $(this).data('checked', true);
		        }else{
		        	$('input:checkbox.student_checkbox-' + vacancy_id + '-'+stage_id+college).each(function() {
			            $(this).prop('checked', false);    
			        });
		        	$(this).data('checked', false);
		        }
		    });

		    colorStudentBasedUponPercentile();
		});
		
	    //Color Student Profile Photo Border based upon percentile
	    function  colorStudentBasedUponPercentile(){
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
	
		
		  $($(document)).on("click", ".inviteRecruiterButtn", function(){
			 	var recruiter_name = $('.recruiter_name').val();
			 	var recruiter_email = $('.recruiter_email').val();
			 	var recruiter_companyId = $('.recruiter_company').val();
			 	var tpo_college_id = $('.tpo_college_id').val();
			 		    	
			 	var url = "/invite_recruiter?name="+recruiter_name+"&email="+recruiter_email+"&company_id="+recruiter_companyId+"&tpo_college_id="+tpo_college_id;
			 	$('#add_recruiter').modal('toggle');
			 	console.log(url);
			 	
			     $.ajax(url, {
			         success: function(data) {
			        	 $('#output_message').html(data);
			        	 $('#result_notification').modal('toggle');
			 			$('#add_recruiter').find('input.recruiter_name').val('');
						$('#add_recruiter').find('input.recruiter_email').val('');
						$('#add_recruiter').find('select.recruiter_company').val('');
			         },
			         error: function() {
			        	 $('#output_message').html("Invalid Request! Please try again.");
			        	 $('#result_notification').modal('toggle');
			         }
			     });
			  });
		  
		  $($(document)).on("click", '#closeNotificationResult', function(){
			  $('#result_notification').modal('toggle');
		  });

		  $($(document)).on("click", "#student_notification_all_btn", function() {
			  
		        var vacancyID =$(this).data('vacancy');
		    	var stageID = $(this).data('stage');
		    	var companyID = $(this).data('college');
		    	
		    	console.log("vac->" + vacancyID);
		    	console.log("stage->" + stageID);
		    	console.log("company->" + companyID);
		    	
		    	var students = "";
		    	
		        $('.student_checkbox-'+vacancyID+'-'+stageID+companyID+':checked').each(function() {
		            students = $(this).data("student_id") + "," + students;
		        });
		    	
		        console.log("Students->" + students);
		        
		    	$('#student_ids').val(students);
		    	$('#modal-form').modal('toggle'); 
		    });
		  
		    $($(document)).on("click", ".student_notification_all", function() {
		    	 //An ajax call to send notification to the selected students of any stage
		        var message = $('#fetch_text').val();
		        console.log("message: ", message);
		        var students = $('#student_ids').val();
		      
		        var url = "/send_notification_recruiter?student_id=" + students + "&msg=" + message + "&recruiter_id=" + $("#all_recruiter_id").val();
		        $('#modal-form').modal('toggle'); 
		        $.ajax(url, {
		            success: function(data) {
		            },
		            error: function() {
		            }
		        });
		    });
		</script>
		<script>
			$(document).ready(function(){
				
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
				<input type="hidden" name="sender_id" id="sender_id" value="<%=recruiter.getId()%>" />
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
	
	<div id="modal-form" class="modal fade" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-12 b-r">
							<h3 class="m-t-none m-b">Send Message</h3>


							<div class="form-group">
								<label class="form-control" style="border: 0px;">Message</label>
								<input type="hidden" name="student_id" id="student_ids" /> <input
									type="hidden" name="recruiter_id" id="all_recruiter_id"
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

			<div id="add_recruiter" class="modal fade" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-body">
							<div class="row">
									<div class="col-sm-12 b-r"><h3 class="m-t-none m-b">Invite a Recruiter</h3>
		                                <p>Invite a recruiter to your college.</p>
		                                    <div class="form-group"><label>Name</label> <input type="text" data-validation="required" placeholder="Enter name of Recruiter" class="form-control recruiter_name"></div>
		                                    <div class="form-group"><label>Email</label> <input type="email" data-validation="required" placeholder="Enter email of Recruiter" class="form-control recruiter_email"></div>
		                                    <div class="form-group">
		                                    	<label>Organization</label>	         
											<select data-placeholder="Choose Company" class="form-control chosen-select recruiter_company" tabindex="2" data-validation="required">
											<option value="" selected>Select Industry Type</option>
												<% RecruiterServices recruiterServices = new RecruiterServices ();
		                                    List<Company> allCompanies = recruiterServices.getAllCompanies();
		                                    for(Company company: allCompanies){%>
		                                    	<option value="<%=company.getId()%>"><%=company.getName() %></option>
												<%} %>
											</select>
											</div>
											<input type="hidden" value=<%=recruiter.getCollege().getId() %> class="tpo_college_id"/>
                       						<div>
		                                        <button
												class="btn btn-sm btn-primary pull-right inviteRecruiterButtn"
												style="margin-right: 25px; margin-top: 8px;">Invite</button>
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

<script>

/* function triggerFirstStudentData(){			

	var vacancy_id = $('.student_holder_actor').data("vacancy_id");
	var stage_id = $('.student_holder_actor').data("stage");
	
	console.log("vacancy",vacancy_id );
	console.log("stage", stage_id);
	console.log('#tab-vacancy-'+vacancy_id+' #tab-vacancy-workflow-'+stage_id+'-'+vacancy_id);
	
	
	$('#tab-vacancy-'+vacancy_id).each(function(){
		$('#tab-vacancy-workflow-'+stage_id+'-'+vacancy_id).each(function(){
				$('.student_holder_actor').each(function(){
					
					$(this).first().trigger("click");
					return false;
					})
				return false;
			})
			return false;
		});		
	}
	
	
 */
 
/* 	$(".chosen-select").chosen({disable_search_threshold: 10}); 
	$(".chosen-container.chosen-container-single").css({"width": "537px"});
/* $(".nav-tabs").click(function () {
	    console.log("li of nav tab");
		$(this).children().removeClass("active");
	}); */
	
	//triggerFirstStudentData();
/* 	
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		//triggerFirstStudentData();
		//console.log(e.relatedTarget);
		}); 
 */
	
/* 	//Invite recruiter 
  $($(document)).on("click", ".inviteRecruiterButtn", function(){
 	var recruiter_name = $('.recruiter_name').val();
 	var recruiter_email = $('.recruiter_email').val();
 	var recruiter_companyId = $('.recruiter_company').val();
 	var tpo_college_id = $('.tpo_college_id').val();
 		    	
 	var url = "/invite_recruiter?name="+recruiter_name+"&email="+recruiter_email+"&company_id="+recruiter_companyId+"&tpo_college_id="+tpo_college_id;
 	$('#add_recruiter').modal('toggle');
 	console.log(url);
 	
     $.ajax(url, {
         success: function(data) {
         },
         error: function() {
         }
     });
  }); */
	
	
	
	
/*  $(".student_holder_actor").click(function() {
 	//To display the right side student pane for Student Card and Chat between recruiter and student
 	
 	//triggerFirstStudentData();
 	
     var ID = $(this).attr("id");
     console.log("Student ID->" + ID);
     var stage_id = $(this).data('stage_id');
     var url = "/recruiter/right_side_pane.jsp?student_id=" + ID + "&stage_id=" + stage_id + "&recruiter_id=" + $("#idd_recruiter_id").val();
     $.ajax(url, {
         success: function(data) {
             $("#student_pane--" + stage_id).html(data);
             
             
             
             $(".select2_demo_2").select2();
     		$(".select2_demo_2").select2({ width: '100%' });
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
         	    //alert($('#s2skill_selector').find('li').eq(li_count-2).find('div').text());
         	}); 
         },
         error: function() {
         }
     });
 }); */
 
/*  $($(document)).on("click", ".chat_box11111", function() {
 	//To display "Send Message aka Notification" for each student 
     var ID = $(this).attr("id").split("--")[2];
     $(this).parent().parent().append($("#chat_form"));
     $("#chat_form #idd_student_id").val(ID);
     $('#chat_form').show();
 }); */
 
/*  $($(document)).on("click", ".student_notification", function() {
     //An ajax call to send notification to a student individually
     var ID = $("#chat_form #idd_student_id").val();
     var url = "/send_notification_recruiter?student_id=" + ID + "&msg=" + $("textarea.message-input").val() + "&recruiter_id=" + $("#idd_recruiter_id").val();
     
     $.ajax(url, {
         success: function(data) {
         	//What and how a message should be displayed if successful?
         },
         error: function() {
             //What and how a message should be displayed if failed?
         }
     });
 }); */
 
/*  $($(document)).on("click", ".select_all_students", function() {
     // find All students checkboxes with class .vacancy_id and select them 
     var stage_id = $(this).data('stage');
     $('input:checkbox.' + stage_id).each(function() {
         $(this).prop('checked', true);            
     });
     validateSelectedCount(stage_id);
 });
 
 $($(document)).on("click", ".select_none_students", function() {
     // find All students checkboxes with class .vacancy_id and select them 
     var stage_id = $(this).data('stage');
     $('input:checkbox.' + stage_id).each(function() {
         $(this).prop('checked', false);
     });
     validateSelectedCount(stage_id);
 });
 
 $('.i-checks').change(function() {
 	var stage_id = $(this).data('stage_id');
     validateSelectedCount(stage_id);
 });
 
 $($(document)).on("click", ".promote_students", function() {
     // Ajax call to promote all the selected students to next stage
     var vacancy_id = $(this).data('vacancy');
     var students = "";
     $('input:checkbox.' + vacancy_id + ':checked').each(function() {
         students = students + "," + $(this).data("student_id");
     });
     var url = "/promote_students?vacancy_id=" + vacancy_id + "&students=" + students;
     console.log(url);
     $.ajax(url, {
         success: function(data) {

         },
         error: function() {

         }
     });
 });
 
 $($(document)).on("click", ".create_job", function() {
    var win = window.open('/recruiter/vacancy/create_new_vacancy.jsp');
		if (win) {
		    win.focus();
		} else {
		    alert('Please allow popups for this website');
		}
 });
 */
</script>