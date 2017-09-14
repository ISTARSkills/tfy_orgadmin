<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>
<%
	boolean flag = false;
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	if (cp == null) {
		flag = true;
		request.setAttribute("msg", "User Does Not Have Permission To Access");
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}
	request.setAttribute("cp", cp);
	int lessonID = 0;
	Lesson lesson = new LessonDAO().findById(Integer.parseInt(request.getParameter("lesson_id")));
	String slide_id = "0";
	String template_type = "0";
	
	/*  if(request.getParameter("slide_id")!=null){
		 slide_id = request.getParameter("slide_id");
	   template_type = request.getParameter("template_type");
	} */ 
	
	
	if (lesson != null) {
		lessonID = lesson.getId();
	}
%>
<!doctype html>
<html lang="en">

<head>
<style type="text/css">

.custom_style_template{
    position: absolute;
    bottom: 10px;
    left: 23px;
    font-size: 11px;
}
</style>
<meta charset="utf-8">

<title>reveal.js The HTML Presentation Framework</title>

<meta name="description" content="A framework for easily creating beautiful presentations using HTML">
<meta name="author" content="Hakim El Hattab">

<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, minimal-ui">

<link href="<%=baseURL%>assets/css/bootstrap.css" rel="stylesheet">
<link href="<%=baseURL%>assets/css/bootstrap-glyphicons.css" rel="stylesheet">
<link rel="stylesheet" href="<%=baseURL%>assets/slide_assets/css/reveal.css">
<link rel="stylesheet" href="<%=baseURL%>assets/slide_assets/css/theme/black.css" id="theme">

<!-- Theme used for syntax highlighting of code -->
<link rel="stylesheet" href="<%=baseURL%>assets/slide_assets/lib/css/zenburn.css">

 <!-- Sweet Alert -->
    <link href="<%=baseURL%>assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
<!-- Printing and PDF exports -->



<!--[if lt IE 9]>
		<script src="lib/js/html5shiv.js"></script>
		<![endif]-->
</head>
<body id="edit_lesson">

<div class="btn-toolbar" style="position: absolute; z-index: 9999; right: 11px; top: 10px;">
  <div class="btn-group">
      <button id='delete' onclick='deleteSlideFunction()' style='border: 1px solid gray;' class="btn"><i class="glyphicon glyphicon-trash"></i></button>
      <button id='bg_image' style='border: 1px solid gray;' class="btn" ><i class="glyphicon glyphicon-picture"></i></button>
      <button id='bg_color' style='border: 1px solid gray;' class="btn" ><input type="color" id="colorpicker" name="favcolor" value="#ff0000"></button>
      <button id='add_slide' onclick='createSlideFunction()' style='border: 1px solid gray;' class="btn"><i class="glyphicon glyphicon-plus"></i></button>
  </div>
</div>


	<div id='slide_holder' class="reveal" data-lessonid="<%=lessonID%>" data-slide_id="<%=slide_id%>" data-template_type="<%=template_type%>">

	</div>
	 <script src="<%=baseURL %>assets/js/jquery.min.js"></script>
    <script src="<%=baseURL %>assets/js/popper.min.js "></script>

    <script src="<%=baseURL %>assets/js/bootstrap.min.js"></script>
    <script src="<%=baseURL%>assets/slide_assets/js/jquery.jeditable.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=baseURL%>assets/slide_assets/lib/js/head.min.js"></script>
	<script src="<%=baseURL%>assets/slide_assets/js/reveal.js"></script>
 <!-- Sweet alert -->
    <script src="<%=baseURL%>assets/js/plugins/sweetalert/sweetalert.min.js"></script>
   <script src="<%=baseURL%>assets/js/jquery-ui.js"></script>
   

	<script>
	function rgb2hex(rgb){
		 rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
		 return (rgb && rgb.length === 4) ? "#" +
		  ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
		  ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
		  ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
		}
	
		$(document).ready(function() {
			window.lessonID = $('.reveal').data('lessonid');
			//window.templateType = $('.reveal').data('template_type');
			//window.slide_id = $('.reveal').data('slide_id');
			intializeReveal();
			});
		function intializeReveal() {
			
			var url = '../tfy_content_rest/slide/read/' + window.lessonID ;
			

			$.ajax({
				url : url,
				type : "GET",
				dataType : "html",
			}).done(function(data) {
									
				$('#slide_holder').html(data);
				Reveal.initialize({
					controls : true,
					progress : true,
					history : false,
					center : true,
					showSlideNumber: 'all',
					slideNumber: 'c/t',
					fragments: true,
					transition : 'slide', // none/fade/slide/convex/concave/zoom

				});
				
				Reveal.addEventListener( 'ready', function( event ) {
					// event.currentSlide, event.indexh, event.indexv
					var x = document.getElementsByClassName("present");
					var slide_id=x[0].id;
					editableFunction(slide_id);
				} );
				
					
				Reveal.addEventListener( 'slidechanged', function( event ) {
					// event.previousSlide, event.currentSlide, event.indexh, event.indexv
					
					var x = document.getElementsByClassName("present");
					var slide_id=x[0].id;
					$('.slide_controls').hide();
					//console.log('#slide_controls_idd_'+slide_id);
					$('#slide_controls_idd_'+slide_id).show();
				
					
					editableFunction(slide_id);	

				});
				
				
			});
			

}
		
		function editableFunction(slide_id){
			
			//image upload	
			$('.edit_img').unbind().click(function() { 
				 
				var slide_id = $('.present').attr('id');
				
				$("#load_element").load('<%=baseURL %>content_creator/slide_creation/image_upload.jsp?image_type=foreground');
				$('#slide_elements').modal('show');
				
				$('#slide_elements').on('shown.bs.modal', function(){
				    uploadImageFunction(slide_id); 
				    $('#slide_id').val(slide_id);
				    $('#element_type').val("IMAGE");
				    $('#lesson').val(<%=lessonID %>);
				    $('#isnew_slide').val($('.present >.slide_controls').attr('data-isnew_slide'));
				    $('#template_type').val( $('#slide_'+$('.present').attr('id')).attr('data-template'));
				    if($('.present').hasClass('ONLY_VIDEO')){
				    	 $('#element_type').val("VIDEO");
				    	 $('.custom_img').remove();
				    	 
				    }else{
				    	$('.custom_video').remove();
				    }
				    
				})
				
			 });
			
			 $('.edit').editable('<%=baseURL%>tfy_content_rest/edit_ppt', {
		    	indicator : 'Saving...', 
		        tooltip:'Click to edit...',
		        event:'dblclick',
		       

		        submitdata : function(value, settings) {
		        	var isnewdata = $('.present >.slide_controls').attr('data-isnew_slide');
	            	 $('.present >.slide_controls').attr('data-isnew_slide','false');
		            return {
		            	slide_id: $('.present').attr('id'),
		            	element_type: $(this).attr("data-element_type"),
		            	template_type:$('#slide_'+$('.present').attr('id')).attr('data-template'),
		            	lesson_id:<%=lessonID%>,
		            	fragment_index:$(this).attr("data-fragment-index"),
		            	child_fragment_index:$(this).attr("data-child-fragment-index"),
		            	color_code:rgb2hex($('.slide-background.present').css('background-color')),
		            	isnew_slide:isnewdata,
		            	};
		        },callback:function(value, settings) {
		        	 console.log(value);
		             return(value);
		             
		        }
		       
		    });
			 
			
		}
		
		
		          //bg_image
                   $('#bg_image').unbind().click(function() { 
						 
                		var slide_id = $('.present').attr('id');
                		
						$("#load_element").load('<%=baseURL %>content_creator/slide_creation/image_upload.jsp?image_type=background');
						$('#slide_elements').modal('show');
						
						$('#slide_elements').on('shown.bs.modal', function(){
						    uploadImageFunction(slide_id); 
						    $('#slide_id').val(slide_id);
						    $('#lesson').val(<%=lessonID %>);
						    $('#isnew_slide').val($('.present >.slide_controls').attr('data-isnew_slide'));
						    $('#template_type').val( $('#slide_'+$('.present').attr('id')).attr('data-template'));
						    removeBGImageFunction(slide_id);
						    
						})
						
						
						
						
						
					 });
		
		
                   function  removeBGImageFunction(slide_id){
                	   
                	   
                	   $("#btnRemove").click(function (event) {
							 
						   $.ajax({
							        type: "POST",
							        url: '<%=baseURL%>tfy_content_rest/slide_add_delete',
							        data: {key:"background_img_delete",lesson_id:<%=lessonID%>,slide_id:slide_id},
							        success: function(result) {
							        	
							           
							        }
							    });
							 
						 });
                	   
                	   
                   }
		
		function  deleteSlideFunction(){
			
			 var slidenumber =  parseInt($('.slide-number-a').text());
			 var slideID = $('.present').attr('id');
			 
			 swal({
			        title: "Are you sure?",
			        text: "You will not be able to recover this slide!",
			        type: "warning",
			        showCancelButton: true,
			        confirmButtonColor: "#DD6B55",
			        confirmButtonText: "Yes, delete it!",
			        closeOnConfirm: false
			    }, function () {
			    	
			    	
			        swal("Deleted!", "Your slide has been deleted.", "success");
			        Reveal.slide(slidenumber);		        
			        $.ajax({
				        type: "POST",
				        url: '<%=baseURL%>tfy_content_rest/slide_add_delete',
				        data: {key:'delete',lesson_id:<%=lessonID%>,slide_id:slideID},
				        success: function(result) {
				        $('#'+slideID).remove();
				        }
				    });
			        
			        
			    });
			
			
			
			
			 
		}
		
		$("#colorpicker").on("change",function(){
			
			var slide_id = $('.present').attr('id');
			var colorCode = $("#colorpicker").val();
			
			 $.ajax({
		  	        type: "POST",
		  	        url: '<%=baseURL%>tfy_content_rest/slide_add_delete',
		  	        data: {key:'addBGColor',colorCode:colorCode,slide_id:slide_id,lesson_id:<%=lessonID%>},
		  	        success: function(result) {
		  	        	
		  	        	 $(".slide-background.present").css("background-color",$("#colorpicker").val());
		  	          }
		  	    });
			
		   
		});
		
		function createSlideFunction(){
			
			$("#load_element").load('<%=baseURL %>content_creator/slide_creation/template_type.jsp');
			$('#slide_elements').modal('show');
			
			$('#slide_elements').on('shown.bs.modal', function(){
			   
				addNewSlide();
			    
			});
			
		}
		
		
		function addNewSlide(){
			
			  $('.custom_template_type').unbind().click(function() { 
				  
				 var templateType =  $(this).attr('data-template_type');
				 var slide_id = $('.present').attr('id');
				 var slidenumber =  parseInt($('.slide-number-a').text());
				 alert(templateType);
					$.ajax({
						url : '../tfy_content_rest/slide/createTemplate/' + templateType +'/'+ slide_id +'/'+ window.lessonID,
						type : "GET",
						dataType : "html",
					}).done(function(data) { 
						
						$('section').each(function() {
							  if($(this).attr('id') == slide_id){ 
								  $(this).after(data);  
								  Reveal.sync();
								  Reveal.slide(slidenumber);
								  editableFunction(slide_id);
								  $('#slide_elements').modal('hide');
								  }
							});
						
					});
				
			  });
			
		}
		
		  function  uploadImageFunction(slide_id){
			
			  $('#save_slide_elements').unbind().click(function() { 
					
				  event.preventDefault();
				  
				  
				  
			        // Get form
			        var form = $('#fileUploadForm')[0];
			        var servlet="<%=baseURL%>tfy_content_rest/edit_ppt";
					// Create an FormData object
			        var data = new FormData(form);			        
					// disabled the submit button
			        $("#save_slide_elements").prop("disabled", true);
			        var upload_file =$('#upload_file1').val();
			        var file_ext = $('#upload_file1').val().split('.')[1];
			        if(upload_file != '' & file_ext == 'png' || file_ext == 'PNG' || file_ext == 'mp4' || file_ext == 'MP4' || file_ext == 'gif' || file_ext == 'GIF'){
			        	
			        	 $.ajax({
					            type: "POST",
					            enctype: 'multipart/form-data',
					            url: servlet,
					            data: data,
					            processData: false,
					            contentType: false,
					            cache: false,
					            timeout: 600000,
					            success: function (data) {
					             
					                console.log("SUCCESS : ", data);
					                $("#save_slide_elements").prop("disabled", false);
					                if($('#image_type').val() === 'background'){
					                	$('.slide-background.present').css('background-image', 'url(' + data + ')');
					               // $('.present').attr('data-background-image',data);
					                	
					                }if($('#image_type').val() === 'foreground'){
					                	if($('#element_type').val() === 'VIDEO'){
					                		$($('.present')[0]).find('video').children().attr('src',data);
					             
					                	}else{
					                		 $('#'+slide_id+' .edit_img').attr('src',data);
					                	}
					               
					                
					                }
					                alert('Upload');
					                $('#slide_elements').modal('hide');
					            },
					            error: function (e) {
					                $("#result").text(e.responseText);
					                console.log("ERROR : ", e);
					                $("#save_slide_elements").prop("disabled", false);
					            }
					        });
			        }else{
						 alert('Please upload a png File');
						 $("#save_slide_elements").prop("disabled", false);
					}
			        
			        
				});
			
		}
			
		
	</script>
	
	 <div id="slide_elements" class="modal fade bd-example-modal-lg" role="dialog"> 
  <div class="modal-dialog modal-lg">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
     
      
      <div id="load_element">
      
      
      </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="save_slide_elements" class="btn btn-default" data-dismiss="modal">Save</button>
      </div>
    </div>

  </div>
  
  </div>
</body>
</html>