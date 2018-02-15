<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!doctype html>
<html lang="en">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
		+ path + "/";
	int lesson_id =6020;
	String slide_type = "";
	String template_type="ONLY_TITLE";
	int slide_id = (int)System.nanoTime();
	String upload_img_type = "forground_img";
	LessonServices lessonServices = new LessonServices();
	if(request.getParameter("lesson_id")!=null){
		 lesson_id = Integer.parseInt(request.getParameter("lesson_id"));
	}
	if(request.getParameter("template_type")!=null){
		template_type = request.getParameter("template_type");
	}
	if(request.getParameter("slide_id")!=null){
		slide_id = Integer.parseInt(request.getParameter("slide_id"));
	}
	if(request.getParameter("slide_type")!=null){
		slide_type = request.getParameter("slide_type");
	}
	
	System.out.print("slide_id>>>>>>>>>"+slide_id);
	
%>
<head>
<style type="text/css">
.custom_div {
    width: 250px;
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
    text-align: center;
    height: 15vh;
    margin: 40px
}

nav {
    opacity: 0.2;
    filter: alpha(opacity=50); /* For IE8 and earlier */
}

nav:hover {
    opacity: 1.0;
    filter: alpha(opacity=100); /* For IE8 and earlier */
}
.dropdown-colorselector{
text-align: center;
}
</style>
<style type="text/css">

#style-1::-webkit-scrollbar-track
{
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
	border-radius: 10px;
	background-color: #F5F5F5;
}

#style-1::-webkit-scrollbar
{
	width: 12px;
	background-color: #F5F5F5;
}

#style-1::-webkit-scrollbar-thumb
{
	border-radius: 10px;
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
	background-color: #555;
}

</style>
<style>
  #sortable { list-style-type: none; margin: 0; padding: 0; }
  #sortable li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; font-size: 1.4em; height: 18px; }
  #sortable li span { position: absolute; margin-left: -1.3em; }
  </style>
<meta charset="utf-8">

<title>reveal.js - The HTML Presentation Framework</title>

<meta name="description" content="A framework for easily creating beautiful presentations using HTML">
<meta name="author" content="Hakim El Hattab">

<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
 -->
 <link rel="stylesheet" href="<%=basePath%>assets/css/bootstrap.min.css">
<link rel="stylesheet" href="<%=basePath%>assets/slide_assets/css/reveal.css">
<link rel="stylesheet" href="<%=basePath%>assets/slide_assets/css/theme/black.css" id="theme">

<!-- Theme used for syntax highlighting of code -->
<link rel="stylesheet" href="<%=basePath%>assets/slide_assets/lib/css/zenburn.css">

 <!-- Sweet Alert -->
    <link href="<%=basePath%>assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
    
    
    <link href="<%=basePath%>assets/css/bootstrap-colorselector.css" rel="stylesheet">
    
<!-- Printing and PDF exports -->
<script>
	var link = document.createElement('link');
	link.rel = 'stylesheet';
	link.type = 'text/css';
	link.href = window.location.search.match(/print-pdf/gi) ? '<%=basePath%>assets/slide_assets/css/print/pdf.css'
			: '<%=basePath%>assets/slide_assets/css/print/paper.css';
	document.getElementsByTagName('head')[0].appendChild(link);
</script>
<% //fetch All slides froma given ppt %>
<!--[if lt IE 9]>
		<script src="lib/js/html5shiv.js"></script>
		<![endif]-->
</head>

<body>

<input type='hidden' id='slideID' value='<%=slide_id%>'>

<div class="row"> 
<div class="col-md-2 scrollbar" id="style-1" style="height: 100vh;background: white;overflow-y: scroll;">
<div class="force-overflow">

<%=lessonServices.lessonHTMLPreviewfromLessonXML(lesson_id) %>

</div>


</div> 
<%if(request.getParameter("slide_type")==null){ %>
<div class="col-md-10">
<nav class="navbar navbar-default" style='z-index: 999; position: absolute;width: 100%; height: 6vh;'> <div class="container-fluid"> <div class="navbar-header"> 
	
	<ul class="nav navbar-nav"> 
	<li><a onclick='delFunction()' class='slide_del' style='padding-top: 4px;' >Delete </a></li> 
	<li><a class='edit_img' style='padding-top: 4px;' >Background-Image</a></li> 
	<li><a id='slide_reorder' style='padding-top: 4px;' >Slide Re-Order</a></li> 
    <li class="dropdown" ><a style='padding-bottom: 0px;padding-top: 4px;' class='edit_background_color' >Background-Color</a> 
    <select id="colorselector"> 
   <%=lessonServices.chooseBgColorForLesson() %>   
</select></li>
	<li class="dropdown" style='width: 254px;'> 
	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" style='padding-top: 4px;'>Choose Template<span class="caret"></span></a> 
	 <%=lessonServices.chooseTemplatForLesson(lesson_id) %>
	 
	 </li> 
	
	</ul>
	  </div> </div> </nav>
	
</div>

<%
}
if(request.getParameter("template_type")!=null){ %>
<div class="col-md-10" style=" padding-left: 1px;    height: 100vh;">
	<div class="reveal">
	
		<div class="slides">
		
		<%=lessonServices.addslideHTMLtoLessonXML(template_type,slide_id,lesson_id) %>
	    </div>
		
		
  <!--  <button onclick='delFunction()' class='slide_del ' style='float: right;margin: 10px; z-index: 999; position: absolute;top: 1%;right: 1%;'><img src='/content/img/minus_image.png' width='48' height='48' ></button>
  <button class='edit_img ' style='float: right;margin: 10px; z-index: 999; position: absolute;top: 10%;right: 1%;'><img src='/content/img/bakground_img.png' width='48' height='48' ></button>
 --><!-- <div class='add_style' style='display:none' >
<button class='slide_style ' style='float: right;margin: 10px; z-index: 999; position: absolute;top: 50%;right: 1%;'><img src='/content/img/painting_icon.png' width='48' height='48' ></button>
</div> -->
	</div></div>
	<%} %>
	<div class="col-md-10" style=" padding-left: 1px;    height: 100vh;background: white;overflow: scroll;">
	<div class="col-md-12" style='margin-top: 20px;'>
	 <%if(request.getParameter("slide_type")!=null){ %>
      <%if(request.getParameter("slide_type").equalsIgnoreCase("type1")){ %>
    <button type="button" style=' float: right;margin: 10px;'class="btn btn-default btn-sm save_btn"><span class="glyphicon glyphicon-floppy-save" aria-hidden="true"></span>Save</button>
	<button type="button" style='    float: right;margin: 10px;'class="btn btn-default btn-sm add-row"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span> Add Row</button>
     <%} if(request.getParameter("slide_type").equalsIgnoreCase("type2")){%>
     	    <button type="button" style=' float: right;margin: 10px;'class="btn btn-default btn-sm save_question"><span class="glyphicon glyphicon-floppy-save" aria-hidden="true"></span>Save</button>
<!--      	<button type="button" style='    float: right;margin: 10px;'class="btn btn-default btn-sm add-question"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span> Add Question</button>
 -->	  <%} %>
		
		<%=lessonServices.addslideTypeHTMLtoLessonXML(slide_type,slide_id,lesson_id) %>
		
		<%} %>
	</div></div></div>
<!--     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" type="text/javascript" charset="utf-8"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
 -->	
 
 
   <script src="<%=basePath%>assets/js/jquery-2.1.1.js"></script>
    <script src="<%=basePath%>assets/js/slides_bootstrap_js/bootstrap.min.js"></script>
 <script src="<%=basePath%>assets/slide_assets/lib/js/head.min.js"></script>
	  <script src="<%=basePath%>assets/slide_assets/js/jquery.jeditable.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath%>assets/slide_assets/js/reveal.js"></script>
	
	 <script src="<%=basePath%>assets/js/jquery-ui.js"></script>

<!-- Sweet alert -->
    <script src="<%=basePath%>assets/js/plugins/sweetalert/sweetalert.min.js"></script>
        
   <script src="<%=basePath%>assets/js/bootstrap-colorselector.js"></script>
    
    
    	<%if(request.getParameter("template_type")!=null){ %>
	<script>
	var selectedSlide;
	var slideID = $('#slideID').val();
	$(document).ready(function(){
		var myElements = document.getElementsByClassName('custom_div');
		var myElement = myElements[0];
		$.each( myElements , function( key, value ) {
			  if($(value).data('slideid').toString()===window.slideID){
				  myElement = value;
			  }
		});
		var topPos = myElement.offsetTop;
		document.getElementById('style-1').scrollTop = topPos;
	});
	
 // More info https://github.com/hakimel/reveal.js#configuration
		Reveal.initialize({
			controls : true,
			progress : true,
			history : false,
			center : false,
			autoPlayMedia : false,
			showNotes:true,
			margin: 0,
			keyboard: false,
			fragments: false,
			width: "90%",
			height: "100%",
			transition : 'slide', // none/fade/slide/convex/concave/zoom
			transitionSpeed: 'slow',
			showSlideNumber: 'all',
			//slideNumber: 'c/t',
			// More info https://github.com/hakimel/reveal.js#dependencies
			dependencies : [ {
				src : '<%=basePath%>assets/slide_assets/lib/js/classList.js',
				condition : function() {
					return !document.body.classList;
				}
			}, {
				src : '<%=basePath%>assets/slide_assets/plugin/markdown/marked.js',
				condition : function() {
					return !!document.querySelector('[data-markdown]');
				}
			}, {
				src : '<%=basePath%>assets/slide_assets/plugin/markdown/markdown.js',
				condition : function() {
					return !!document.querySelector('[data-markdown]');
				}
			}, {
				src : '<%=basePath%>assets/slide_assets/plugin/highlight/highlight.js',
				async : true,
				callback : function() {
					hljs.initHighlightingOnLoad();
				}
			}, {
				src : '<%=basePath%>assets/slide_assets/plugin/zoom-js/zoom.js',
				async : true
			}, {
				src : '<%=basePath%>assets/slide_assets/plugin/notes/notes.js',
				async : true
			} ]
		});
	
	
		Reveal.addEventListener( 'ready', function( event ) {
				
			var x = document.getElementsByTagName("section");
				x[0].style.top = '75%';
				
				if($(x[0]).hasClass('ONLY_VIDEO')){
					$(".custom_video_style ").css("height", "90vh");
				}
			   
			    $('.edit').each(function(){
			      
			        if( $(this).attr('data-element_type') == 'LIST'){
			        	
			        	$("li.edit").css("fontSize", "30px");
			        }
			     });
				
		
		} );
		var colorCode = '';
		
		 $('.edit').focusin(function() {
			 
			 console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>> '+$(this).css('color'));
			 if( $(this).css('color') == 'rgb(255, 255, 255)' ){
				 $(this).css('color', 'black');
			 }
		           
		});
      $('.edit').focusout(function() {
			 
			 console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>> '+$(this).css('color'));
			 if( $(this).css('color') == 'rgb(255, 255, 255)'){
				 $(this).css('color', 'black');
			 }if($(this).css('color') == 'rgb(0, 0, 0)'){
				 $(this).css('color', 'white');
			 }
		           
		});
      
      $(document).on("click", ".edit", function(){ 
    	  
    	  var type = $(this).prop("tagName");
    	  console.log(type.toLowerCase());
    	  $('.custom-btn-div').remove();
    	  var fontSize = '';
    	  if(type.toLowerCase() == 'div'){
            	$($('ul').find('div.edit')[0]).parent().after('<div class="custom-btn-div"><button type="button" class="btn btn-default btn-xs custom-glyphicon-remove-circle"><span class="custom-glyphicon-remove-circle" aria-hidden="true">×</span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon-plus"><span style="float: left;" class="glyphicon glyphicon-plus" aria-hidden="true"></span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon-minus"><span style="float: left;"class="glyphicon glyphicon-minus"></span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon glyphicon-check glyphicon glyphicon-check"></button></div>');
 
            	  fontSize = $($('ul').find('div.edit')[0]).css('fontSize');
	    		 fontSize = fontSize.substr(0,fontSize.length-2);
	    		 
    	  }else if(type.toLowerCase() == 'li'){
    		  
         	 $($('ul').find('li.edit')[0]).parent().after('<div class="custom-btn-div"><button type="button" class="btn btn-default btn-xs custom-glyphicon-remove-circle"><span class="custom-glyphicon-remove-circle" aria-hidden="true">×</span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon-plus"><span style="float: left;" class="glyphicon glyphicon-plus" aria-hidden="true"></span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon-minus"><span style="float: left;"class="glyphicon glyphicon-minus"></span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon glyphicon-check glyphicon glyphicon-check"></button></div>');
 
         	fontSize = $($('ul').find('li.edit')[0]).css('fontSize');
  		    fontSize=  fontSize.substr(0,fontSize.length-2);
         	 
    	  }else if(type.toLowerCase() == 'h1' ){
    		 
    	  	    $('h1.edit').after('<div class="custom-btn-div"><button type="button" class="btn btn-default btn-xs custom-glyphicon-remove-circle"><span class="custom-glyphicon-remove-circle" aria-hidden="true">×</span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon-plus"><span style="float: left;" class="glyphicon glyphicon-plus" aria-hidden="true"></span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon-minus"><span style="float: left;"class="glyphicon glyphicon-minus"></span></button><button type="button" class="btn btn-default btn-xs custom-glyphicon glyphicon-check glyphicon glyphicon-check"></button></div>');
    	  	  fontSize = $('h1.edit').css('fontSize');
    		  fontSize =   fontSize.substr(0,fontSize.length-2);
    	  }
    	  
  
    	    $('.custom-glyphicon-plus').click(function() {
    	    	 console.log(type.toLowerCase());
    	    	 fontSize = +fontSize + +5;
    	     	 $(''+type.toLowerCase()+'.edit').css({ 'font-size': ''+fontSize+'px' });
    	     	 
    	     	 
    	     });
    	     $('.custom-glyphicon-minus').click(function() {
    	    	 console.log(type.toLowerCase());
    	    	
    	    	 fontSize = +fontSize - +5;
    	    	 
    	    	 $(''+type.toLowerCase()+'.edit').css({ 'font-size': ''+fontSize+'px' });
    	    });
    	     $('.custom-glyphicon-remove-circle').click(function() {
    	    	 console.log(type.toLowerCase());
    	    	 $('.custom-btn-div').remove();
    	    });
    	  
        });
      
	
	 $('.edit').editable('/edit_ppt', {
		    	indicator : 'Saving...', 
		        tooltip:'Click to edit...',
		        submitdata : function(value, settings) {
		            return {
		            	slide_id: <%=slide_id%>,
		            	element_type: $(this).attr("data-element_type"),
		            	template_type:'<%=template_type%>',
		            	lesson_id:<%=lesson_id%>,
		            	fragment_index:$(this).attr("data-fragment-index"),
		            	child_fragment_index:$(this).attr("data-child-fragment-index"),
		            	color_code:colorCode
		            	};
		        },callback:function(value, settings) {
		        	 console.log(value);
		             return(value);
		             
		        }
		       
		    });
		 
		 $('.speaker-notes').click(function() {
			 var slideID =<%=slide_id%>;
			 $('#edit_teacher_notes').modal('show');
			 $('#teacher_notes_comment').val($('.present aside').text().trim());
			 $('#slide_id').val(slideID);
			 
			 $('#save_teacher_notes').click(function() {
					
					var teacher_notes_comment = $('#teacher_notes_comment').val();
					 var slide_id = $('#slide_id').val();
					 
					 $.ajax({
					        type: "POST",
					        url: '/edit_teachernotes',
					        data: {teacher_notes_comment:teacher_notes_comment, lesson_id:<%=lesson_id%>,slide_id:slide_id},
					        success: function(result) {
					            window.console.log('Successful '+teacher_notes_comment);
					            $('.speaker-notes').text(teacher_notes_comment);
					            location.reload();
					           
					        }
					    });
				 });
			 
		 });
		 
		
		 
		
		 
		 
		 
		 $('.edit_img').click(function() {
			 
			 $('#upload_file').change(function() {
				 var str = $('#upload_file').val();
				 var n = str.endsWith(".mp4");
				 if(n){
					 $("#element_type").val("VIDEO"); 
				 }else{
					 $("#element_type").val("IMAGE"); 
				 }
				});
			 
		var type = 	 $(this).prop("tagName");
	  if(type == 'A' ){
		$("#upload_img_type").val("background_img");
		$("#btnRemove").css("display", "block");
	  }
	  else{
			$("#upload_img_type").val("forground_img");
			}
				
			 $('#edit_image_holder').modal('show');
			 
			 $("#btnSubmit").click(function (event) {
			        //stop submit the form, we will post it manually.
			        event.preventDefault();
			        // Get form
			        var form = $('#fileUploadForm')[0];
			        var servlet="/edit_ppt";
					// Create an FormData object
			        var data = new FormData(form);
					// If you want to add an extra field for the FormData
			        data.append("CustomField", "This is some extra data, testing");
					// disabled the submit button
			        $("#btnSubmit").prop("disabled", true);
			        var upload_file =$('#upload_file').val();
			        var file_ext = $('#upload_file').val().split('.')[1];
			       
			       
			        
			        console.log(file_ext);
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
			                $("#result").text(data);
			                console.log("SUCCESS : ", data);
			                $("#btnSubmit").prop("disabled", false);
			                location.reload();
			                alert('Upload');
			            },
			            error: function (e) {
			                $("#result").text(e.responseText);
			                console.log("ERROR : ", e);
			                $("#btnSubmit").prop("disabled", false);
			            }
			        });
				}else{
					 alert('Please upload a png');
					 $("#btnSubmit").prop("disabled", false);
				}
			    });
			 
			 $("#btnRemove").click(function (event) {
				 
				 var slideID = <%=slide_id%>;
				 
				 $.ajax({
				        type: "POST",
				        url: '/slide_add_delete',
				        data: {key:"background_img_delete",lesson_id:<%=lesson_id%>,slide_id:slideID},
				        success: function(result) {
				        	 location.reload();
				           
				        }
				    });
				 
			 });

			 
		 });
		 
		 	 
		 function delFunction() {
			    
			 var slideID = <%=slide_id%>;
							 
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
			        			        
			        $.ajax({
				        type: "POST",
				        url: '/slide_add_delete',
				        data: {key:'delete',lesson_id:<%=lesson_id%>,slide_id:slideID},
				        success: function(result) {
				          
				        	location.reload();
				        }
				    });
			        
			        
			    });
			}
		
		 
		 
		 
		
	</script>
	<%} %>
	<script type="text/javascript">
	 $('.custom_div').click(function() {
			
		 var template =  $(this).attr("data-template");
		 var slideID =  $(this).attr("data-slideID")
		 
		
		 if(template == 'ONLY_EVALUATOR_EXCEL'){
			 window.location.href = './create_slide.jsp?slide_id='+slideID+'&slide_type=type1&lesson_id='+<%=lesson_id%>;
		 }else{
			 window.location.href = './create_slide.jsp?slide_id='+slideID+'&template_type='+template+'&lesson_id='+<%=lesson_id%>; 
		 }
		  
	});
	 
	 $('#slide_reorder').click(function() {
			var slide_id = '';
		 $('.custom_div').each(function(){
		        
		        slide_id = slide_id + $(this).attr("data-slideid")+',';
		   });
		 
		slide_id = slide_id.substr( 0 , slide_id.length-1);
		 
		  $.ajax({
		        type: "POST",
		        url: '/slide_add_delete',
		        data: {key:"re_order",lesson_id:<%=lesson_id%>,slide_id:slide_id},
		        success: function(result) {
		          
		           alert('successfully re-ordered');
		        }
		    });

		 
	 });
	
	</script>
	
<script>

$('#colorselector').colorselector();

  $( function() {
    $( "#sortable" ).sortable();
    $( "#sortable" ).disableSelection();
  } );
  </script>
  
  <script type="text/javascript">
  var thID = 2;
  thID = $('tbody >tr').length+1;
  removeFunction();
  select_questionFunction();
  $(".add-row").click(function(){
    
      var markup = "<tr><td><input name='key_"+thID+"' class='form-control' aria-label='Text input with dropdown button'></td> <td><select name='value_"+thID+"' class='form-control'>   <option value='CELL_TYPE_BLANK'>CELL_TYPE_BLANK</option>   <option value='CELL_TYPE_BOOLEAN'>CELL_TYPE_BOOLEAN</option>   <option value='CELL_TYPE_ERROR'>CELL_TYPE_ERROR</option>   <option value='CELL_TYPE_FORMULA'>CELL_TYPE_FORMULA</option>    <option value='CELL_TYPE_NUMERIC'>CELL_TYPE_NUMERIC</option>     <option value='CELL_TYPE_STRING'>CELL_TYPE_STRING</option> </select></td> <td><input name='formula_"+thID+"' class='form-control' aria-label='Text input with dropdown button'></td> <td><input name='result_"+thID+"' class='form-control' aria-label='Text input with dropdown button'></td> <td><button id='remove_"+thID+"' type='button'class='btn btn-default btn-sm remove-row'><span class='glyphicon glyphicon-minus' aria-hidden='true'></span></button></td></tr>";
      $("table tbody").append(markup);
      thID = thID + 1;
      
      removeFunction();
  });
  
  
  function removeFunction() {
	   
	  $(".remove-row").unbind().click(function(){
		  	 
		  	 var slideID = <%=slide_id%>;  
		  	var idsplit = $(this).attr('id');
		   var part2 = idsplit.split('_')[1];
		  
		 var cellID = $('input[name="key_'+part2+'"]').val();
		 
		 $(this).parent().parent().remove();
		  
		  $.ajax({
		        type: "POST",
		        url: '/slide_evaluator',
		        data: {key:'delete',lesson_id:<%=lesson_id%>,slide_id:slideID,cellID:cellID},
		        success: function(result) {
		          
		        	
		        }
		    });
		  
		  	
		  	  
		    });
	  
	}
  
  $('.add-question').click(function() {
		 var slideID =<%=slide_id%>;
		
		 
		 $.ajax({
		        type: "POST",
		        url: 'add_question_modal.jsp',
		        data: {question_id:'0'},
		        success: function(result) {
		        	
		        	$('#modal_body_holder').empty();
		        	$('#modal_body_holder').append(result);
		        	
		        	 $('#add_question').modal('show');
		        	 
		        	 
		        }
		    });
		 
		
		 
	 });
  
  function select_questionFunction() {
  $('.select_question').unbind().click(function() {
		
	 //var array{}
	  if($(this).hasClass("active") === true){
		  $(this).removeClass("active");   
	  }else{
		  $(this).addClass("active");
	  }
	 
	 
		 
	 });
  }
  
  $('#lo_select').on('change', function() {
	  
	  $('#lo_select').val();
	  var lo_id = $(this).val();
	  $.ajax({
	        type: "POST",
	        url: '/slide_evaluator',
	        data: {key:'getQuestionbylo',lo_id:lo_id},
	        success: function(result) {
	        	
	        	$('.add_lo_question_holder').empty();
	        	$('.add_lo_question_holder').append(result);
	        	 select_questionFunction();
	        	
	  }
	    });
	  
	  $("#checkAll").unbind().change(function(){

		  if ($('.new_select_holder').hasClass('active') === false) {
		      $('.new_select_holder').addClass('active');
		  } else {
			  $('.new_select_holder').removeClass('active');
		  }       
		});
	  
	  
	})
	
	
	
	$('#colorselector').unbind().change(function(){
		var slide_id =<%=slide_id%>;
		colorCode = $(this).val();
		$('.color-btn').removeClass('selected');
		$('.btn-colorselector').css('background-color', ''+colorCode+'');
		$('.slide-background').css('background-color', ''+colorCode+'');
		
		 $.ajax({
  	        type: "POST",
  	        url: '/slide_add_delete',
  	        data: {key:'addBGColor',colorCode:colorCode,slide_id:slide_id,lesson_id:<%=lesson_id%>},
  	        success: function(result) {
  	        	
  	          }
  	    });
		
		
	})
	
	         $('.save_question').click(function() {
				var questionID = "";
				 var slide_id =<%=slide_id%>;
	        	 $(".select_question").each(function() {
	        		   if($(this).hasClass('active') === true) {
	        			 //  console.log($(this).find('.question_text').text());
	        			   questionID += $(this).attr('id')+'&##&'+$(this).find('.question_text').text()+',&,';
	        			   }
	        		});
	        	
	        	 questionID =  questionID.substr(0,questionID.length-3);
	        	 console.log(questionID);
	        	 
	        	 $.ajax({
	     	        type: "POST",
	     	        url: '/slide_evaluator',
	     	        data: {key:'addQuestionsToXmL',questionID:questionID,slide_id:slide_id,lesson_id:<%=lesson_id%>},
	     	        success: function(result) {
	     	        	
	     	          }
	     	    });
	        	 
	        	 
	        	 
				 
			 });
	
<%--   $('.question_holder').click(function() {
		
				 var question_id = $(this).text();
				 
				
				 
				  $.ajax({
				        type: "POST",
				        url: '<%=basePath%>/content_creator/template/add_question_modal.jsp',
				        data: {question_id:question_id},
				        success: function(result) {
				        	
				        	$('#modal_body_holder').empty();
				        	$('#modal_body_holder').append(result);
				        	
				        	 $('#add_question').modal('show');
				        	 
				        	 
				        }
				    }); 
			 });  --%>
  
 
 
  $( ".save_btn" ).click(function() {
	 var data= $('#form_data').serialize();
	  console.log( $('#form_data').serialize());
	  var trCount = $('tbody tr').length;
	  
	  $('<input>').attr({
		    type: 'hidden',
		    id: 'trcount',
		    name: 'trcount',
		    value: trCount
		}).appendTo('#form_data');
	  
	  $('<input>').attr({
		    type: 'hidden',
		    id: 'slide_id',
		    name: 'slide_id',
		    value: '<%=slide_id%>'
		}).appendTo('#form_data');
	  
	  $('<input>').attr({
		    type: 'hidden',
		    id: 'lesson_id',
		    name: 'lesson_id',
		    value: '<%=lesson_id%>'
		}).appendTo('#form_data');
	  
	  $('<input>').attr({
		    type: 'hidden',
		    id: 'slide_type',
		    name: 'slide_type',
		    value: '<%=slide_type%>'
		}).appendTo('#form_data');
	  
	  $('#form_data').submit();
	  	  	  
	});
 
  </script>
<div id="edit_image_holder" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit Image</h4>
      </div>
      <div class="modal-body">
     <form method="POST" enctype="multipart/form-data" id="fileUploadForm">
							<input type="hidden" name="lesson" value='<%=lesson_id%>'>	
								<input type="hidden" name="slide_id" value='<%=slide_id%>'>
								<input type="hidden" id ='element_type' name="element_type" value='IMAGE'>
								<input type="hidden" name="template_type" value='<%=template_type%>'>
								<input type="hidden" id='upload_img_type' name="upload_img_type" value='<%=upload_img_type%>'>
								<div class="row"> 
<div class="col-md-6">

<div class="form-group">
												<label class="col-sm-4 control-label">Upload Media:</label>
												<div class="col-sm-5">
												 <input id="upload_file" type="file" name="files"/>
													<%
													if(template_type.equalsIgnoreCase("NO_CONTENT")){
													%>
													Desktop Image<input id="upload_file1" type="file" name="files"/>
                                                   <%} %>
                                                  
												</div>
											</div>
											
</div>
<div class="col-md-6" >
 <input type="submit"  style="float: right;" value="Upload" id="btnSubmit"/><br/><br/><br/>
  <input type="submit"  style="float: right; display: none;" value="Remove Background Image" id="btnRemove"/>
</div>
</div>
								
								
                            
								</form>
        
      </div>
      <div class="modal-footer">
        <button type="button" id="save_image" class="btn btn-default" data-dismiss="modal">Save</button>
      </div>
    </div>

  </div></div>
   <div id="edit_teacher_notes" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit Teacher Notes</h4>
      </div>
      <div class="modal-body">
      <input type="hidden" value="" id ="slide_id" >
         <textarea class="form-control" rows="5" id="teacher_notes_comment"></textarea>
      </div>
      <div class="modal-footer">
        <button type="button" id="save_teacher_notes" class="btn btn-default" data-dismiss="modal">Save</button>
      </div>
    </div>

  </div></div>
  
  
  <div id="add_style_modal" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title title_holder"></h4>
      </div>
  <div id='modal_body_holder'>
  <div class="modal-body">
      <input type="hidden" value="" id ="slide_id" >
      </div>
  </div>   
      <div class="modal-footer">
        <button type="button" id="save_new_question" class="btn btn-default" data-dismiss="modal">Save</button>
      </div>
    </div>

  </div></div>
  
</body>
</html>