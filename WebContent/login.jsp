<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String cdnUrl = "http://cdn.talentify.in/";
	
	try {
		Properties properties = new Properties();
		String propertyFileName = "app.properties";
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
		if (inputStream != null) {
			properties.load(inputStream);
			cdnUrl = properties.getProperty("cdn_path");
		}
	} catch (IOException e) {
		e.printStackTrace();
	}
	
	
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";

	if(request.getSession().getAttribute("user")!=null) {
		String url1 = baseURL + "dashboard2.jsp";
	}
	
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=cdnUrl%>assets/img/user_images/new_talentify_logo.png" />
<title>Talentify | Login</title>

<link href="<%=cdnUrl%>assets/css/bootstrap.min.css" rel="stylesheet">

<link href="<%=cdnUrl%>assets/font-awesome/css/font-awesome.css" rel="stylesheet">
  <!-- Sweet Alert -->
<link href="<%=cdnUrl%>assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/animate.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/style.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/custom.css" rel="stylesheet">

</head>

<body class="gray-bg"
	style="background-size: cover; background-repeat: no-repeat; background-image: url('<%=baseURL%>assets/images/demo.png')">
	
	<% String errormsg=""; 
	Boolean flag = false;%>
	<%if(request.getAttribute("msg")!=null && !request.getAttribute("msg").toString().equalsIgnoreCase("")){
		
		 errormsg = request.getAttribute("msg").toString();
		 flag = true;
		 request.removeAttribute("msg");

	}%>
	
	<% System.out.println("---------------->"+errormsg); %>
	<div class="text-center loginscreen animated fadeInDown">

		<div class="login-screen-box">
			<div>
				<img alt="Talentify"
					src="<%=cdnUrl%>assets/img/user_images/new_talentify_logo.png" width="60%"
					height="60%">
			</div>

			<br>

			<h2 style="font-weight: 700;">Welcome</h2>
			

			<form class="m-t" role="form" action="<%=baseURL%>login" method="post">
				<div class="form-group">
					<input type="email" name="email" 
						class="form-control" placeholder="Username" required="">
				</div>
				<div class="form-group">
					<input type="password" name="password" 
						class="form-control" placeholder="Password" required="">
				</div>

				<button type="submit" style="font-weight: 600; font-size: 16px"
					class="btn btn-danger custom-theme-btn-primary block full-width m-b login-button">Login</button>
				<p class="text-muted text-center">
                            <small>Do not have an account?</small>
                        </p>
                 <div class="row">       
				<div class="col-md-6"><a class="btn btn-sm btn-danger btn-block" href="trainer_signup.jsp">Sign up as Trainer</a></div>
				<div class="col-md-6"><a class="btn btn-sm btn-danger btn-block" href="student_signup.jsp">Sign up as Student</a></div>
				</div>
				
			</form>
          
			<p class="m-t">
				<small>ISTAR Skill Development Pvt. Ltd. &copy; 2017</small>
			</p>
		</div>
	</div>

	<!-- Mainly scripts -->
	<script src="<%=cdnUrl%>assets/js/jquery-2.1.1.js"></script>
	<script src="<%=cdnUrl%>assets/js/bootstrap.min.js"></script>
	 <!-- Sweet alert -->
    <script src="<%=cdnUrl%>assets/js/plugins/sweetalert/sweetalert.min.js"></script>
	
	<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-84077159-1', 'auto');
  ga('send', 'pageview');
  
   $(document).ready(function(){
	 
	   var flag = <%=flag%>;
	   
	 if(flag === true){
		 callMyFunction(); 
	 }else{
		 
	 }
	  
	  


	   
	});
   
   function callMyFunction(){
	  
	  
           swal({
               title: "<%=errormsg%>"
           });
          
      
	   
	   
   }

</script>
</body>

</html>
