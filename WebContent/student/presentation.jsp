<%@page import="com.viksitpro.user.service.UserNextTaskService"%>
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
	int lesson_id =-1;
	int playlist_id = -1;
	int slide_id = 0;
	DBUTILS util = new DBUTILS();
	int task_id =0;
	int course_id =0;
	int module_id =0;
	int cmsession_id =0;
	boolean redirect_page =true;
	if(request.getParameter("task_id")!=null){
		task_id = Integer.parseInt(request.getParameter("task_id"));
		redirect_page = false;
	}
	if(request.getParameter("course_id")!=null){
		course_id = Integer.parseInt(request.getParameter("course_id"));
		redirect_page = true;
	}
	if(request.getParameter("module_id")!=null){
		module_id = Integer.parseInt(request.getParameter("module_id"));
		redirect_page = true;
	}
	if(request.getParameter("cmsession_id")!=null){
		cmsession_id = Integer.parseInt(request.getParameter("cmsession_id"));
		redirect_page = true;
	}
	LessonServices lessonServices = new LessonServices();
	if(request.getParameter("lesson_id")!=null){
		 lesson_id = Integer.parseInt(request.getParameter("lesson_id"));
	}
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	UserNextTaskService userNextTask = new UserNextTaskService();
	
	ComplexObject cp = rc.getComplexObject(user.getId());
	
	String partialUrl = "";
	if(redirect_page){
		partialUrl = userNextTask.getnextLesson(user.getId(), lesson_id,cmsession_id,module_id,course_id).toString();
	}else{
		partialUrl = userNextTask.getnextTask(user.getId(), task_id).toString();
	}
	
	String lessonTitle = "Talentify";
	for(CoursePOJO coursePOJO:cp.getCourses()){
		for(ModulePOJO modulePOJO:coursePOJO.getModules()){
			for(ConcreteItemPOJO concreteItemPOJO:modulePOJO.getSessions().get(0).getLessons()){
				if(concreteItemPOJO.getLesson().getId().intValue() == lesson_id){
					lessonTitle = concreteItemPOJO.getLesson().getTitle();
					 playlist_id = concreteItemPOJO.getLesson().getPlaylistId();			
				}
			}
		}
	}

String sql = "select slide_id from user_session_log where user_id="+user.getId()+" and lesson_id="+lesson_id+" order by created_at desc limit 1";

List<HashMap<String, Object>> data = util.executeQuery(sql);
if(data.size()!=0){
	slide_id = (int)data.get(0).get("slide_id");
	//System.out.println(">>>>>>>redirecting"+slide_id);
}
	

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
<a id='go_back' href='' class="btn btn-default" style="z-index: 9999;  position: absolute; top: 7px; right: 8px;">Go Back</a>
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
			<% if(cp.getStudentProfile().getUserType().equalsIgnoreCase("TRAINER")) {%>
			showNotes:true,
			<% }  else {%>
			showNotes:false,

			<% } %>
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
		Reveal.slide(0);
	
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
			
			
    	
    	<%if(redirect_page){ %>
    	
    	
    	
    	$('#go_back').attr('href','<%=basePath%>student/partials/begin_skill.jsp?course_id=<%=course_id%>');
    		
    		<%}else{%>
    		
    		
    		
    		$('#go_back').attr('href','<%=basePath%>student/dashboard.jsp');
    		
    		<%}%>
			
			
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
			        url: '<%=basePath%>t2c/LessonProgressService?user_id=<%=user.getId()%>&lesson_id=<%=lesson_id%>&slide_id='+slideID+'&title='+title+'&total_slides='+document.getElementsByTagName("section").length,
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
			        url: '<%=basePath%>t2c/lessons/user/<%=user.getId()%>/<%=lesson_id%>/<%=task_id%>/update_lesson_status22',
			        success: function(result) {
			        	<%if(!partialUrl.isEmpty()){%>
			        		window.location.href = "<%=basePath%><%=partialUrl%>";
			        		
			        		$('#go_back').attr('href','<%=basePath%><%=partialUrl%>');
			        		
			        	<%}else{%>
			        	
			        	<%if(redirect_page){ %>
			        	
			        	window.location.href = "<%=basePath%>student/partials/begin_skill.jsp?course_id=<%=course_id%>";
			        	
			        	$('#go_back').attr('href','<%=basePath%>student/partials/begin_skill.jsp?course_id=<%=course_id%>');
			        		
			        		<%}else{%>
			        		
			        		window.location.href = "<%=basePath%>student/dashboard.jsp";
			        		
			        		$('#go_back').attr('href','<%=basePath%>student/dashboard.jsp');
			        		
			        		<%}}%>
			           
			        }
			    });
				
			}

		});

		
		 
	
	</script>
<% String userID = "NOT_LOGGED_IN_USER";

if(request.getSession().getAttribute("user") != null) {
	userID =  ((IstarUser)request.getSession().getAttribute("user")).getUserRoles().iterator().next().getRole().getId()+"_"+ ((IstarUser)request.getSession().getAttribute("user")).getId();
}
%>
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-103015121-1', 'auto', {
	  userId: '<%=userID%>'
	});
ga('send', 'pageview');


</script>

</body>
</html>
	