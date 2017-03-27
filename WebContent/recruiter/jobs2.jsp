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


<title>Talentify Recruiter | Jobs <%=recruiter.getName()%></title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css"
	rel="stylesheet">
</head>

<body class="fixed-navigation">
	<div id="wrapper">
		<jsp:include page="includes/sidebar.jsp"></jsp:include>


		<div id="page-wrapper" class="gray-bg" style="padding:0px;">
			<div class="row border-bottom">
				<!-- header -->
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>
			
			<div class="row wrapper border-bottom white-bg page-heading" style="padding: 0 10px 11px 10px">
				<div class="col-lg-10">
					<ol class="breadcrumb">
						<li><h3></h3><a href="#">Jobs</a></h3></li>
					</ol>
				</div>
			</div>
			
			<div class="wrapper" style="padding:0px;">
				<div class="tabs-container">

					<div class="tab-content">
								<div class="panel-body" style="padding:0px;";>
									<jsp:include page="recruiter_college.jsp">
										<jsp:param value="<%=recruiter.getId()%>"
											name="recruiter_id" />
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
		<script src="<%=baseURL%>js/bootstrap.min.js"></script>
		<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
		<script	src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

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

		<!-- jQuery UI -->
		<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>

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
		<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

		<script>

	    function validateSelectedCount(stage_id) {
	    	var count = 0;//$('.selection_count.'+stage_id).html();
	    	console.log("validateSelectedCount");
	    	$('input:checkbox:checked.' + stage_id).each(function() {
	            count++;
       		});
	    	$('.selection_count.'+ stage_id).html(count);
	    }
	    
		$(document).ready(function() {
			
					
		    $(".student_holder_actor").click(function() {
		    	//To display the right side student pane for Student Card and Chat between recruiter and student		    	
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
		    });
		    
		    $($(document)).on("click", ".chat_box11111", function() {
		    	//To display "Send Message aka Notification" for each student 
		        var ID = $(this).attr("id").split("--")[2];
		        $(this).parent().parent().append($("#chat_form"));
		        $("#chat_form #idd_student_id").val(ID);
		        $('#chat_form').show();
		    });
		    
		    $($(document)).on("click", ".student_notification", function() {
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
		    });
		    
		    $($(document)).on("click", ".student_notification_all", function() {
		    	 //An ajax call to send notification to the selected students of any stage
		        var vacancy_id = $('.notify_all').data('vacancy');
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
		    });
		    
		    $($(document)).on("click", ".select_all_students", function() {
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
		       var win = window.open('/recruiter/jobs/create_job.jsp');
				if (win) {
				    win.focus();
				} else {
				    alert('Please allow popups for this website');
				}
		    });
		    
		});
		</script>
		 <script>
		 $($(document)).on("click", '#filter_students', function() {
       
        	var filtered_cities =$('#filtered_cities').val()!=null ? $('#filtered_cities').val().join("!#"): "none";
        	
        	var filtered_colleges=$('#filtered_colleges').val()!=null ? $('#filtered_colleges').val().join("!#"): "none";
        	
        	var filtered_ug_degrees=$('#filtered_ug_degrees').val()!=null ? $('#filtered_ug_degrees').val().join("!#"): "none";
        	
        	var filtered_pg_degrees=$('#filtered_pg_degrees').val()!=null ? $('#filtered_pg_degrees').val().join("!#"): "none";
        	
        	var skill_selector=$('#skill_selector').val()!=null ? $('#skill_selector').val().join("!#"): "none";
        	
        	var vacancy_idd=$('#id_vacc_idd').val()!=null ? $('#id_vacc_idd').val(): "none";
        	
        	var grade_cutoff = $('#grade_cutoff').val()!=null ? $('#grade_cutoff').val(): "none";
        	var filter_stage_id =$('#f_stage_id').val()!=null ? $('#f_stage_id').val(): "TARGETED";
        	var skill_ids='none';
        	var skill_percentile='none';
        	
        	 $('.skill_percentile').each(function (index, value) {
        		 skill_ids="";
        		 skill_percentile="";
        		 var id = $(this).attr('id');
        		 var skill_id = id.replace("skill_percentile_id_","");
        		 var percentile_value = $("#"+id).val();
        		 skill_ids+=skill_id+'!#';
        		 skill_percentile+=percentile_value+'!#';
        		 
        		 //alert('idddd'+id+' and value='+percentile_value);        		 
        	 });
        	//alert(filtered_cities);
       	 $.ajax({
             type: "POST",
             url: '<%=baseURL%>get_filtered_students',
             data: {
            	 filtered_cities: filtered_cities,
            	 filtered_colleges: filtered_colleges,
            	 filtered_ug_degrees: filtered_ug_degrees,
            	 filtered_pg_degrees: filtered_pg_degrees,
            	 skill_selector: skill_selector,
            	 vacancy_idd: vacancy_idd,
            	 skill_ids:skill_ids,
            	 skill_percentile:skill_percentile,
            	 grade_cutoff:grade_cutoff,
            	 filter_stage_id:filter_stage_id
             },
		success : function(data) {
			  alert('id_session_id '+data); 
			
			$('#filtered_students_list').html(data);
			
		}
	});
        });
         </script> 

		<div id="chat_form"
			style="width: 350px; margin-top: 10px; display: none">
			<div class="col-lg-12">
				<div class="ibox float-e-margins" style="margin-bottom: 10px;">
					<div class="ibox-content" style="padding: 0px">
						<div role="form" class="form-inline">
							<div class="form-group">
								<label class="form-control" style="border: 0px;">Message</label>
								<input type="hidden" name="student_id" id="idd_student_id" /> <input
									type="hidden" name="recruiter_id" id="idd_recruiter_id"
									value="<%=recruiter.getId()%>" />
								<div class="col-lg-12">
									<textarea placeholder="Write text to send notification"
										class="form-control message-input" style="width: 300px;"></textarea>
								</div>
								<button
									class="btn btn-sm btn-primary pull-right m-t-n-xs student_notification"
									style="margin-right: 25px; margin-top: 8px;">Send</button>
							</div>

						</div>
					</div>
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
									<input type="hidden" name="student_id" id="idd_student_id" />
									<input type="hidden" name="recruiter_id" id="idd_recruiter_id"
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
</body>
</html>