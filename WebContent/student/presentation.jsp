<%@page import="com.istarindia.android.pojo.ConcreteItemPOJO"%>
<%@page import="com.istarindia.android.pojo.ModulePOJO"%>
<%@page import="com.istarindia.android.pojo.CoursePOJO"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="tfy.webapp.ui.LessonServices"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!doctype html>
<html lang="en">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
		+ path + "/";
	int lesson_id =6020;
	int playlist_id = -1;
	LessonServices lessonServices = new LessonServices();
	if(request.getParameter("lesson_id")!=null){
		 lesson_id = Integer.parseInt(request.getParameter("lesson_id"));
	}
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();

	ComplexObject cp = rc.getComplexObject(user.getId());
	for(CoursePOJO coursePOJO:cp.getCourses()){
		for(ModulePOJO modulePOJO:coursePOJO.getModules()){
			for(ConcreteItemPOJO concreteItemPOJO:modulePOJO.getLessons()){
				if(concreteItemPOJO.getLesson().getId().intValue() == lesson_id){
					 playlist_id = concreteItemPOJO.getLesson().getPlaylistId();			
				}
			}
		}
	}
%>
<head>
<meta charset="utf-8">

<title>reveal.js - The HTML Presentation Framework</title>

<meta name="description" content="A framework for easily creating beautiful presentations using HTML">
<meta name="author" content="Hakim El Hattab">

<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<link rel="stylesheet" href="<%=basePath%>assets/slide_assets/css/reveal.css">
<link rel="stylesheet" href="<%=basePath%>assets/slide_assets/css/theme/black.css" id="theme">

<!-- Theme used for syntax highlighting of code -->
<link rel="stylesheet" href="<%=basePath%>assets/slide_assets/lib/css/zenburn.css">

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

	<div class="reveal">

		<div class="slides">
			
			<%=lessonServices.lessonHTMLfromLessonXML(lesson_id) %>
          
		</div>

	</div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath%>assets/slide_assets/lib/js/head.min.js"></script>
	<script src="<%=basePath%>assets/slide_assets/js/reveal.js"></script>

	<script>
     
   
       
    
    // More info https://github.com/hakimel/reveal.js#configuration
		Reveal.initialize({
			controls : true,
			progress : true,
			history : false,
			center : true,
			autoPlayMedia : false,
			showNotes:false,
			margin: 0,
			width: "90%",
			height: "100%",
			transition : 'slide', // none/fade/slide/convex/concave/zoom
			transitionSpeed: 'slow',
			showSlideNumber: 'all',
			slideNumber: 'c/t',
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
		//	console.log('ready slide chnagd');
			var height = document.getElementsByClassName("slides")[0].style.height;
			var width =	document.getElementsByClassName("slides")[0].style.width;
			
			document.getElementsByClassName("present")[0].style.height = height;
			document.getElementsByClassName("present")[0].style.width = width;
			document.getElementsByClassName("slides")[0].style.display = 'table';
			var x = document.getElementsByClassName("section");
			var i;
			for (i = 0; i < x.length; i++) {
				    x[i].style.height = height;
					x[i].style.width = width;
					var slide_id=x[i].id;
					var HtmlElementSlideHolder =  document.getElementById('slide_'+slide_id);
					var size =HtmlElementSlideHolder.dataset.length;
					var templateName =HtmlElementSlideHolder.dataset.template;
					//console.log(templateName);
					//console.log(size);
					
					
					if(templateName ==='only_title'){
						x[i].style.fontSize = size+'%';
						 x[i].style.top = window.innerHeight/3+'px';;
						 x[i].style.verticalAlign='middle';
						 x[i].style.display='table-cell';
					}else if(templateName ==='only_video'){
						x[i].style.top = null;
					}
					else{
						//x[i].style.top = null;
						x[i].style.top = '5%';
					}
					

			}
			
		} );
		
	
		Reveal.addEventListener( 'slidechanged', function( event ) {
		//	console.log('slide chnagd');
		
			var height = document.getElementsByClassName("slides")[0].style.height;
			var width =	document.getElementsByClassName("slides")[0].style.width;
			

			document.getElementsByClassName("present")[0].style.height = height;
			document.getElementsByClassName("present")[0].style.width = width;
			var slideID = document.getElementsByClassName("present")[0].id;
			//lessons/user/{userId}/add_log/lesson/{lesson_id}/{slide_id}/{slide_title} 
								var HtmlElementSlideHolder =  document.getElementById('slide_'+slideID);
								var title =HtmlElementSlideHolder.dataset.title;

								$.ajax({
			        type: "GET",
			        url: '<%=basePath%>t2c/LessonProgressService?user_id<%=user.getId()%>&lesson_id=<%=lesson_id%>&slide_id='+slideID+'&itle='+title+'&totoal_slides='+document.getElementsByTagName("section").length,
			        success: function(result) {
			           
			        }
			    });
			var x = document.getElementsByTagName("section");
			var i;
			for (i = 0; i < x.length; i++) {			    
				x[i].style.height = height;
				x[i].style.width = width;
				
				
				var slide_id=x[i].id;
				var HtmlElementSlideHolder =  document.getElementById('slide_'+slide_id);
				var size =HtmlElementSlideHolder.dataset.length;
				var templateName =HtmlElementSlideHolder.dataset.template;
				//console.log(templateName);
				//console.log(size);
				
				
				if(templateName ==='only_title'){
					 x[i].style.fontSize = size+'%';
					 x[i].style.top = window.innerHeight/3+'px';;
					 x[i].style.verticalAlign='middle';
					 x[i].style.display='table-cell';
				}else if(templateName ==='only_video'){
					x[i].style.top = null;
				}
				else{
				//	x[i].style.top = null;
					x[i].style.top = '5%';
				}
				
				
			}
			
			// check for end of ppt 
			if(Reveal.getProgress() == 1){
				console.log('PPT ENDED '+Reveal.getProgress());
				
				$.ajax({
			        type: "GET",
			        url: '<%=basePath%>t2c/lessons/user/<%=user.getId()%>/<%=lesson_id%>/update_lesson_status',
			        success: function(result) {
			           
			        }
			    });
				
			}

		});

		
		 
	
	</script>


</body>
</html>
