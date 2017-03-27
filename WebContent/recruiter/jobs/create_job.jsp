<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>INSPINIA | Wizards</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/steps/jquery.steps.css" rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>css/custom.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/summernote/summernote.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/summernote/summernote-bs3.css" rel="stylesheet">


<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/chosen/chosen.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/colorpicker/bootstrap-colorpicker.min.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/cropper/cropper.min.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/switchery/switchery.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/nouslider/jquery.nouislider.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/datapicker/datepicker3.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">

<style>
ul.projects li:not (.ui-sortable-helper ) {
	float: left;
	margin: 0px 6.5px 12px;
	cursor: pointer;
	-webkit-transition: all 0.2s linear;
	-moz-transition: all 0.2s linear;
	-ms-transition: all 0.2s linear;
	-o-transition: all 0.2s linear;
	transition: all 0.2s linear;
}

.wizard
>
.content
>
.body
  
position
:
 
relative
;
 
 .myred{background-color:red;}
 
}

</style>

</head>

<body>

	<div id="wrapper">
		<jsp:include page="../includes/sidebar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>Create new job offering</h2>
					<ol class="breadcrumb">
						<li><a href="index.html">Home</a></li>
						<li><a>Jobs</a></li>
						<li class="active"><strong>Create</strong></li>
					</ol>
				</div>
				<div class="col-lg-2"></div>
			</div>

			<jsp:include page="new_job_wizard.jsp"></jsp:include>

		</div>
	</div>



	<!-- Mainly scripts -->
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/custom.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>
	<script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>

	<!-- Chosen -->
	<script src="<%=baseURL%>js/plugins/chosen/chosen.jquery.js"></script>

	<!-- JSKnob -->
	<script src="<%=baseURL%>js/plugins/jsKnob/jquery.knob.js"></script>

	<!-- Input Mask-->
	<script src="<%=baseURL%>js/plugins/jasny/jasny-bootstrap.min.js"></script>

	<!-- Data picker -->
	<script src="<%=baseURL%>js/plugins/datapicker/bootstrap-datepicker.js"></script>

	<!-- NouSlider -->
	<script src="<%=baseURL%>js/plugins/nouslider/jquery.nouislider.min.js"></script>

	<!-- Switchery -->
	<script src="<%=baseURL%>js/plugins/switchery/switchery.js"></script>

	<!-- IonRangeSlider -->
	<script src="<%=baseURL%>js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

	<!-- MENU -->
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>

	<!-- Color picker -->
	<script src="<%=baseURL%>js/plugins/colorpicker/bootstrap-colorpicker.min.js"></script>

	<!-- Clock picker -->
	<script src="<%=baseURL%>js/plugins/clockpicker/clockpicker.js"></script>

	<!-- Image cropper -->
	<script src="<%=baseURL%>js/plugins/cropper/cropper.min.js"></script>

	<!-- Date range use moment.js same as full calendar plugin -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>

	<!-- Date range picker -->
	<script src="<%=baseURL%>js/plugins/daterangepicker/daterangepicker.js"></script>

	<!-- Select2 -->
	<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>

	<!-- TouchSpin -->
	<script src="<%=baseURL%>js/plugins/touchspin/jquery.bootstrap-touchspin.min.js"></script>
	<script src="<%=baseURL%>js/plugins/summernote/summernote.min.js"></script>
	<script src="<%=baseURL%>js/plugins/staps/jquery.steps.min.js"></script>
	<!-- Jquery Validate -->
	<script src="<%=baseURL%>js/plugins/validate/jquery.validate.min.js"></script>

	<script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
	<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

	<!-- Peity d data  -->
	<script src="<%=baseURL%>js/demo/peity-demo.js"></script>
	<script>
    var step_count =1;
        $(document).ready(function(){
        	$('.summernote').summernote();

            var edit = function() {
                $('.click2edit').summernote({focus: true});
            };

            $("#wizard").steps();

            $("#form").steps({
                bodyTag: "fieldset",
                onStepChanging: function (event, currentIndex, newIndex)
                {
                    // Always allow going backward even if the current step contains invalid fields!
                    if (currentIndex > newIndex)
                    {
                        return true;
                    }

                    // Forbid suppressing "Warning" step if the user is to young
                    if (newIndex === 3 && Number($("#age").val()) < 18)
                    {
                        return false;
                    }

                    var form = $(this);

                    // Clean up if user went backward before
                    if (currentIndex < newIndex)
                    {
                        // To remove error styles
                        $(".body:eq(" + newIndex + ") label.error", form).remove();
                        $(".body:eq(" + newIndex + ") .error", form).removeClass("error");
                    }

                    // Disable validation on fields that are disabled or hidden.
                    form.validate().settings.ignore = ":disabled,:hidden";

                    // Start validation; Prevent going forward if false
                    return form.valid();
                },
                onStepChanged: function (event, currentIndex, priorIndex)
                {
                    // Suppress (skip) "Warning" step if the user is old enough.
                    if (currentIndex === 2 && Number($("#age").val()) >= 18)
                    {
                        $(this).steps("next");
                    }

                    // Suppress (skip) "Warning" step if the user is old enough and wants to the previous step.
                    if (currentIndex === 2 && priorIndex === 3)
                    {
                        $(this).steps("previous");
                    }
                },
                onFinishing: function (event, currentIndex)
                {
                    var form = $(this);

                    // Disable validation on fields that are disabled.
                    // At this point it's recommended to do an overall check (mean ignoring only disabled fields)
                    form.validate().settings.ignore = ":disabled";

                    // Start validation; Prevent form submission if false
                    return form.valid();
                },
                onFinished: function (event, currentIndex)
                {
                    var form = $(this);

                    // Submit form input
                    form.submit();
                }
            }).validate({
                        errorPlacement: function (error, element)
                        {
                            element.before(error);
                        },
                        rules: {
                            confirm: {
                                equalTo: "#password"
                            }
                        }
                    });

            $("#ionrange_1").ionRangeSlider({
                min: 100,
                max: 1000,
                type: 'double',
                prefix: "&#8377; ",
                postfix: 'K',
                maxPostfix: "+ ",
                prettify: false,
                hasGrid: true
            });
            
            //ionrange_2
              $("#ionrange_2").ionRangeSlider({
                min: 0,
                max: 60,
                type: 'double',
                prefix: "",
                postfix: ' yrs',
                step: 0.1,
                maxPostfix: "+ ",
                prettify: false,
                hasGrid: true
            });
            
              $( "#sortable" ).sortable();
              $( "#sortable" ).disableSelection();
       });
        
        
        function createStep(){
        	var stage_type = $(".modalSelectBox option:selected").val();
			var stage_description = $("#stage_description").val();
			var box ="<div class='col-lg-2 ui-state-default new_world'  id = 'draggable1' style='margin-bottom: 2%;padding-left: 0px !important;padding-right: 0px !important;margin-right:1%;'><div class='ibox-content text-center ' ><h3 class='title-stage' > Stage "+
			step_count+"</h3><p class='font-bold'>"+stage_type+"</p><p class='font-bold' style='word-break: break-all;'>"+stage_description+"</p></div></div>";
			
                 	if(typeof stage_description != 'undefined' && stage_description.trim()){
                 	//	alert('treu');
                    	$('#box-content').append(box);
                    	step_count++;
                    	$( "#box-content" ).sortable({
                 		   start: function(evt, ui) {
                 			  console.log(this); 
                 			 $(ui.item).find('.ibox-content').addClass('yellow-bg');
                 			  //$(ui.draggable).children('ibox-content').addClass('yellow-bg');
                 		   },
                 		   stop: function(evt, ui) {
                   			 $(ui.item).find('.ibox-content').removeClass('yellow-bg');

                 			   
                 	            setTimeout(
                 	                function(){
                 	                	$( ".title-stage" ).each(function( index ) {
                         	        		var temp =index+1;
                 						$(this).text('Stage '+temp);
                         	        	});0
                 	                },
                 	                    200
                 	            )
                 	        }
                 		   
                 	   });
                 	    $( "#box-content" ).disableSelection(); 
                 	    $( "#droppable" ).droppable({
                 	        drop: function( event, ui ) {
                 	        	step_count--;
                 	        	 $(ui.draggable).remove(); 
                 	        	 $( ".title-stage" ).each(function( index ) {
                    	        		var temp =index+1;
            						$(this).text('Stage '+temp);
                    	        	});                 	       
                 	        }
                 	      });
  
                 	   $('#modal-form').modal('hide');
                 	    
                 	}else{
                 		var error_span ="<span class='help-block form-error' id='help-block'>This is a required field</span>";
                 		if(!$('#stage_description').parent().hasClass('has-error')){
                 		$('#stage_description').parent().addClass('has-error');
                 		$('#stage_description').addClass('error');
                 		$('#stage_description').parent().append(error_span);
                        $('#stage_description').keyup(function (e) { 

							 if($(this).val().trim()){                          
                        	$('#help-block').remove(); 
                        	$('#stage_description').removeClass('error');
                        	$('#stage_description').parent().removeClass('has-error');
							 }
                        	});
                 	}

                 		
                 	}
/*         	
         		var content ="<div id = 'draggable1'  class='ui-state-default new_world' style='width: 150px; height: 60px;    text-align: center; padding: 0.5em;     margin: 10px 20px 0px; background-color:#ffffff;'><div class='jj'>Step "+step_count+"</div><div class='titlestage' style='margin-top:5%;'>"+steps_enter_text+"</div></div>";
        		
        		
        	$('#sortable').append(content);
        	step_count++;
        	   $('#modal-form').modal('toggle');
        	   
        	   $( "#sortable" ).sortable({
        		   
        		   start: function() {
       				
       			},
        		   stop: function(evt, ui) {
        	            setTimeout(
        	                function(){
        	                	$( ".jj" ).each(function( index ) {
                	        		var temp =index+1;
        						$(this).text('Steps '+temp);
                	        	});0
        	                },
        	                    200
        	            )
        	        }
        		   
        	   });
        	    $( "#sortable" ).disableSelection(); 
        	    
        	    
        	    
        	    $( "#droppable" ).droppable({
        	        drop: function( event, ui ) {
        	        	step_count--;
        	        	
        	        	 $(ui.draggable).remove(); 
        	        	 $( ".jj" ).each(function( index ) {
           	        		var temp =index+1;
   						$(this).text('Steps '+temp);
           	        	});
        	        	
        	        	
        	       
        	        }
        	      }); */
 
        	         }
        
        

        
    </script>

</body>

</html>
