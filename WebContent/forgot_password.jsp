<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="com.istarindia.apps.dao.*"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="assets/images/talentify_logo_fav_48x48.png" />
    <title>Talentify | Login</title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/custom.css" rel="stylesheet">

</head>

<body class="gray-bg" style=" background-size: cover;    background-repeat: no-repeat;   background-image: url('assets/images/demo.png')">

    <div class="text-center loginscreen animated fadeInDown">
        
        
        <div class="login-screen-box">
            <div>
              <img alt="Talentify" src="assets/images/talentify_logo_300x187.png">
            </div>
           
            <br>

            <h2 style=" font-weight: 700;">Welcome</h2>
            <p style="font-size: 16px">Please enter your email address registered with us. The new password will be sent to the same email.</p>

            <br>
            
            <form class="m-t" role="form" action="<%=baseURL%>forgot_password" method="get">
                <div class="form-group">
                    <input type="email" name="email" value="surya@istarindia.com" class="form-control" placeholder="Username" required="">
                </div>
                
                <button type="submit" style="font-weight: 600; font-size:16px" class="btn btn-primary btn-xs block full-width m-b login-button">Submit</button>
            </form>
            
            <p class="m-t"> <small>ISTAR Skill Development Pvt. Ltd. &copy; 2016</small> </p>
        </div>
    </div>

    <!-- Mainly scripts -->
    <script src="js/jquery-2.1.1.js"></script>
    <script src="js/bootstrap.min.js"></script>

</body>

</html>
