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
	Lesson lesson = new LessonDAO().findById(Integer.parseInt(request.getParameter("lesson_id")));
	int lessonID = 0;
	if (lesson != null) {
		lessonID = lesson.getId();
	}
%>
<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">

<title>reveal.js The HTML Presentation Framework</title>

<meta name="description" content="A framework for easily creating beautiful presentations using HTML">
<meta name="author" content="Hakim El Hattab">

<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, minimal-ui">

<link rel="stylesheet" href="<%=baseURL%>assets/slide_assets/css/reveal.css">
<link rel="stylesheet" href="<%=baseURL%>assets/slide_assets/css/theme/black.css" id="theme">

<!-- Printing and PDF exports -->


<!--[if lt IE 9]>
		<script src="lib/js/html5shiv.js"></script>
		<![endif]-->
</head>
<body id="edit_lesson">




	<div id='slide_holder' class="reveal" data-lessonid=<%=lessonID%>>

		<!-- Any section element inside of this container is displayed as a slide -->


	</div>
	<script src="/assets/js/jquery.min.js"></script>
	<script src="/assets/slide_assets/lib/js/head.min.js"></script>
	<script src="/assets/slide_assets/js/reveal.js"></script>

	<script>
		$(document).ready(function() {
			window.slideID = $('.reveal').data('lessonid');
			intializeReveal();
		});
		function intializeReveal() {

			$.ajax({
				url : '../tfy_content_rest/slide/read/' + window.slideID,
				type : "GET",
				dataType : "html",
			}).done(function(data) {
				$('#slide_holder').html(data);
				Reveal.initialize({
					controls : true,
					progress : true,
					history : false,
					center : true,

					transition : 'slide', // none/fade/slide/convex/concave/zoom

				});x
			});

			/* 	$.get('../tfy_content_rest/slide/read/' + window.slideID).done(
						function(data) {
							console.log('data'+data);
							
							$('#slide_holder').html(data);
							Reveal.initialize({
								controls : true,
								progress : true,
								history : false,
								center : true,

								transition : 'slide', // none/fade/slide/convex/concave/zoom

							});
						}); */

		}
	</script>
</body>
</html>