<%@page import="com.istarindia.android.pojo.CourseContent"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
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
	int playlist_id = -1;
	int slide_id = 0;
	DBUTILS util = new DBUTILS();
	int task_id =0;
	if(request.getParameter("task_id")!=null){
		task_id = Integer.parseInt(request.getParameter("task_id"));
	}
	LessonServices lessonServices = new LessonServices();
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();

	ComplexObject cp = rc.getComplexObject(user.getId());
	String lessonTitle = "Talentify";
	
	CourseContent courseContent = rc.getCourseContentForStudent(task_id);
	int lessonId=0;
	long currentSlideId = 0;
	if(courseContent!=null)
	{
		lessonId = courseContent.getItems().get(courseContent.getCurrentItemOrderId()).getItemId();
		lessonTitle = courseContent.getItems().get(courseContent.getCurrentItemOrderId()).getItemName();
		currentSlideId = courseContent.getCurrentItemSlideId();
	}

	String email = user.getEmail();
%>
<head>
<meta charset="utf-8">
<link rel="shortcut icon" href="<%=basePath%>assets/img/user_images/new_talentify_logo.png" />
<title><%=lessonTitle %> - Istar Presentation</title>

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
			
			<%=lessonServices.lessonHTMLfromLessonXMLAddendum(lessonId) %>
			<%=lessonServices.lessonHTMLfromLessonXML(lessonId) %>
          
		</div>

	</div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath%>assets/slide_assets/lib/js/head.min.js"></script>
	<script src="<%=basePath%>assets/slide_assets/js/reveal.js"></script>
<script src="<%=basePath%>assets/js/reconnecting-websocket.min.js"></script>
<script>
var webSocket;
function connect() {
	try {
		// variables defined in foot.jsp
		var userEmail = '<%=email%>';
		var taskId = <%=task_id%>;
		if (userEmail != undefined && userEmail != null) {
			var host_name = location.hostname;
			console.log("ws://" + host_name + ":" + "4567" + "/core_socket/"+ userEmail+"/"+taskId+"");
			webSocket = new ReconnectingWebSocket("ws://" + host_name + ":" + "4567" + "/core_socket/"+ userEmail+"/"+taskId+"");
		}
	} catch (err) {
		console.log(err);
	}
	return webSocket;
}

if (webSocket == null) {
	connect();
}

try {
	webSocket.onmessage = function(msg) {
		console.log('in on message ' + msg);
		updateMessage(msg);

	};

	webSocket.onclose = function() {
		console.log("WebSocket connection closed");

	};

} catch (err) {
	console.log(err);
}

function checkLesson(content) {
	var lessonID =0;
	for(var i in content)
	{
	 var paramName = content[i].paramName;
     var paramValue = content[i].paramValue;
     if(paramName==='lesson_id')
    {
    	 lessonID = paramValue;
    }
	}
	if(lessonID == <%=lessonId%>){
		
	} else {
		var url ='/student/sync_class.jsp?task_id=<%=request.getParameter("task_id")%>';
		window.location.href= url;
	}
	console.log("134 --> "+lessonID);
}

function updateMessage(msg)
{

	var str = JSON.stringify(msg, null, 2);
	var data = JSON.parse(msg.data);
	console.log(data);
	var type = data.messageType;
	var content = data.content
	if(type==='SLIDE_LEFT')
	{
		checkLesson(content);
		for(var i in content)
		{
		 var paramName = content[i].paramName;
	     var paramValue = content[i].paramValue;
	     if(paramName==='slide_id')
	    {	 
	     var slideId = paramValue;
			var indices = Reveal.getIndices( document.getElementById( slideId ) );
			Reveal.slide( indices.h, indices.v );
			break;
	    }
		}
	
		
	}else if(type==='SLIDE_RIGHT')
	{
		checkLesson(content);
		for(var i in content)
			{
			 var paramName = content[i].paramName;
		     var paramValue = content[i].paramValue;
		    // console.log('paramNAme'+paramName);
		     if(paramName==='slide_id')
		    {	 
		     var slideId = paramValue;
				var indices = Reveal.getIndices( document.getElementById( slideId ) );
				Reveal.slide( indices.h, indices.v );
				break;
		    }
			}
		
		
		
	}else if(type==='LESSON_CHANGE')
	{
		checkLesson(content);
		for(var i in content)
		{
		 var paramName = content[i].paramName;
	     var paramValue = content[i].paramValue;
	     if(paramName==='lesson_id')
	    {	 
	    	 var lessonId = paramValue;
	    	var url = 'student/sync_class.jsp?task_id=<%=task_id%>';
	 		location.href = '<%=basePath%>'+url;
	 		
	    }
		}
	
	
		
		
	}else if(type==='COURSE_COMPLETED')
	{
		location.href = '<%=basePath%>error/jsp?'+'error_code=COURSE_COMPLETED';
	}
	else if(type==='PREV_FRAGMENT')
	{
		Reveal.prevFragment();
	}
	else if(type==='NEXT_FRAGMENT')
	{
		Reveal.nextFragment();
	}
	else if(type==='PLAY_VIDEO')
	{
		var targetDiv = document.getElementsByClassName("present")[0];
		var video = targetDiv.getElementsByTagName("video")[0];
		video.play();
	}
	else if(type==='PAUSE_VIDEO')
	{
		var targetDiv = document.getElementsByClassName("present")[0];
		var video = targetDiv.getElementsByTagName("video")[0];
		video.pause();
	}	
	
}
</script>


<script>
 
/* $(document).bind("contextmenu",function(e) {
	 e.preventDefault();
	});

var ar = new Array(37, 38, 39, 40,123);
var disableArrowKeys = function(e) {
    if ($.inArray(e.keyCode, ar)>=0) {
        e.preventDefault();
    }
}

$(document).keydown(disableArrowKeys);

// then when you are ready to enable, unbind the function...
$(document).unbind('keydown', disableArrowKeys);
        */
    
    // More info https://github.com/hakimel/reveal.js#configuration
		Reveal.initialize({
			controls : false,
			progress : true,
			history : false,
			fragments: true,
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
					console.log('found my slide ->>>> <%=slide_id%>'+ <%=slide_id%>);

			var height = document.getElementsByClassName("slides")[0].style.height;
			var width =	document.getElementsByClassName("slides")[0].style.width;
			var slidetojump = 0;
			document.getElementsByClassName("present")[0].style.height = height;
			document.getElementsByClassName("present")[0].style.width = width;
			document.getElementsByClassName("slides")[0].style.display = 'table';
			var x = document.getElementsByTagName("section");
			var i;
			for (i = 0; i < x.length; i++) {
				   x[i].style.height = height;
					x[i].style.width = width;
					var slide_id=x[i].id;
					var HtmlElementSlideHolder =  document.getElementById('slide_'+slide_id);
					var size =HtmlElementSlideHolder.dataset.length;
					var templateName =HtmlElementSlideHolder.dataset.template;
					if(templateName ==='only_title'){
						x[i].style.fontSize = size+'%';
						 x[i].style.top = window.innerHeight/3+'px';;
						 x[i].style.verticalAlign='middle';
						 x[i].style.display='table-cell';
					}else if(templateName ==='only_video'){
						x[i].style.top = null;
					}
					else{
						x[i].style.top = '5%';
					}
					if(slide_id == <%=slide_id%>) {
						console.log('found my slide ->>>>'+ i);
						slidetojump = i;
					}
					

			}
			var indices = Reveal.getIndices( document.getElementById( '<%=slide_id%>' ) );
			Reveal.slide( indices.h, indices.v );
			
		});
		
	
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
			        url: '<%=basePath%>t2c/LessonProgressService?user_id=<%=user.getId()%>&lesson_id=<%=lessonId%>&slide_id='+slideID+'&title='+title+'&totoal_slides='+document.getElementsByTagName("section").length,
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

		});

	</script>
</body>
</html>
	