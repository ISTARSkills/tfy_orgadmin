<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<!DOCTYPE html>
<html>

<head>
<% 
	IstarUser user =  new IstarUser();
	String userEmail = new String();
	
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
	
	if(request.getSession().getAttribute("user")!=null) {
		user = (IstarUser)request.getSession().getAttribute("user");
		userEmail = user.getEmail();
	} else {
		userEmail = ""; 
	}

%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="img/user_images/new_talentify_logo.png" />
    <title>Talentify | Login</title>

    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

    <link href="assets/css/animate.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
    <link href="assets/css/custom.css" rel="stylesheet">

</head>

<body class="gray-bg" style=" background-size: cover;    background-repeat: no-repeat;   background-image: url('assets/images/demo.png')">

    <div class="text-center loginscreen animated fadeInDown">
        
        
        <div class="login-screen-box">
            <div>
              <img alt="Talentify" src="assets/images/talentify_logo_300x187.png">
            </div>
           
            <br>

            <h2 style=" font-weight: 700;">1</h2>
            <p style="font-size: 16px">2</p>

            <br>
            
            <form class="m-t" role="form" action="<%=baseURL%>reset_password" method="get">
                <div class="form-group">
                    <input type="email" name="email" value="<%=userEmail%>" class="form-control" required="">
                </div>
                <div class="form-group">
                    <input type="password" name="old_password" id="old_password"  value="test123"  class="form-control" placeholder="Password" required="">
                </div>
                <div class="form-group">
                    <input type="password" name="new_password"  id="new_password" class="form-control" placeholder="New Password" required="">
                </div>
                <div class="form-group">
                    <input type="password" name="confirm_password" id="confirm_password" class="form-control" placeholder="Confirm Password" required="">
                </div>
                
                <button type="submit" style="font-weight: 600; font-size:16px" class="btn btn-primary block full-width m-b login-button">Confirm</button>
            </form>
            
            <p class="m-t"> <small>ISTAR Skill Development Pvt. Ltd. &copy; 2016</small> </p>
        </div>
    </div>

    <!-- Mainly scripts -->
    <script src="assets/js/jquery-2.1.1.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
	<script type="text/javascript">
		$(function () {
	        $("#new_password").bind("keyup", function () {
	        	$("#confirm_password").val("");
	           
	        	//TextBox left blank.
	            if ($(this).val().length == 0) {
	                $("#password_strength").html("");
	                return;
	            }
	 
	            //Regular Expressions.
	            var regex = new Array();
	            regex.push("[A-Z]"); //Uppercase Alphabet.
	            regex.push("[a-z]"); //Lowercase Alphabet.
	            regex.push("[0-9]"); //Digit.
	            regex.push("[$@$!%*#?&]"); //Special Character.
	 
	            var passed = 0;
	 
	            //Validate for each Regular Expression.
	            for (var i = 0; i < regex.length; i++) {
	                if (new RegExp(regex[i]).test($(this).val())) {
	                    passed++;
	                }
	            }
	
	            //Validate for length of Password.
	            if (passed > 2 && $(this).val().length > 8) {
	                passed++;
	            }
	 
	            //Display status.
	            var color = "";
	            var strength = "";
	            switch (passed) {
	                case 0:
	                case 1:
	                    strength = "Weak";
	                    color = "red";
	                    break;
	                case 2:
	                    strength = "Good";
	                    color = "darkorange";
	                    break;
	                case 3:
	                case 4:
	                    strength = "Strong";
	                    color = "green";
	                    break;
	                case 5:
	                    strength = "Awesome!";
	                    color = "darkgreen";
	                    break;
	            }
	            
	            $("#password_strength").html(strength);
	            $("#password_strength").css("color", color);
	        });
	    });
		
		$(function () {
	        $("#confirm_password").bind("keyup", function () {
	            
	        	//TextBox left blank.
	            if ($(this).val().length == 0) {
	                $("#password_match").html("");
	                return;
	            }
	            
	            var color = "";
	            var match = "";
				
	            var confirm_password = $(this).val();
	            var new_password = $("#new_password").val();
	            
	            if(confirm_password == new_password) {
                    match = "Awesome!";
                    color = "darkgreen";
	            } else {
                    match = "";
                    color = "red";
	            }
				
	            $("#password_match").html(strength);
	            $("#password_match").css("color", color);
	        });
	    });
	</script>
</body><script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

	  ga('create', 'UA-103015121-1', 'auto');
	  ga('send', 'pageview');
	  ga('set', 'userId', 'NOT_LOGGED_IN_USER'); // Set the user ID using signed-in user_id.

</script>

</html>
