<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";

	if(request.getSession().getAttribute("user")!=null) {
		String url1 = baseURL + "dashboard2.jsp";
	}
	
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="img/user_images/recruiter_portal_trans_logo.png" />
<title>Talentify | Login</title>

<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="font-awesome/css/font-awesome.css" rel="stylesheet">

<link href="css/animate.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/custom.css" rel="stylesheet">

</head>

<body class="gray-bg"
	style="background-size: cover; background-repeat: no-repeat; background-image: url('assets/images/demo.png')">
	<%if(request.getAttribute("msg")!=null && request.getAttribute("msg").toString().equalsIgnoreCase("")){%>
	<p id="error_holder"><%=request.getAttribute("msg") %></p>
	<%}%>
	<div class="text-center loginscreen animated fadeInDown">


		<div class="login-screen-box">
			<div>
				<img alt="Talentify"
					src="img/user_images/new_talentify_logo.png" width="60%"
					height="60%">
			</div>

			<br>

			<h2 style="font-weight: 700;">Welcome</h2>
			<p style="font-size: 16px">Revolutionizing education through
				engaging, creative content and immersive gamified experiences.</p>

			<br>

			<form class="m-t" role="form" action="<%=baseURL%>login" method="get">
				<div class="form-group">
					<input type="email" name="email" value="vaibhav@istarindia.com"
						class="form-control" placeholder="Username" required="">
				</div>
				<div class="form-group">
					<input type="password" name="password" value="test123"
						class="form-control" placeholder="Password" required="">
				</div>

				<button type="submit" style="font-weight: 600; font-size: 16px"
					class="btn btn-danger custom-theme-btn-primary block full-width m-b login-button">Login</button>

				<%--  <a href="<%=baseURL%>forgot_password.jsp">Forgot password?</a> --%>
			</form>

			<p class="m-t">
				<small>ISTAR Skill Development Pvt. Ltd. &copy; 2016</small>
			</p>
		</div>
	</div>

	<!-- Mainly scripts -->
	<script src="js/jquery-2.1.1.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-84077159-1', 'auto');
  ga('send', 'pageview');
  
   $(document).ready(function(){
	  if($('#error_holder').text().length!=0){
			alert($('#error_holder').html());
		}
	});

</script>
</body>

</html>
