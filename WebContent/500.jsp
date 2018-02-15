<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%><%@page import="com.viksitpro.core.dao.entities.*"%><%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<!DOCTYPE html><html><head><title>Error Page | iStar CMS</title><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<% String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
String user_type = ((IstarUser)request.getSession().getAttribute("user")).getUserRoles().iterator().next().getRole().getRoleName().toLowerCase() ;
String userUrl= baseURL + user_type ; 
Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
String servletName = (String) request.getAttribute("javax.servlet.error.servlet_name");
String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");

if (requestUri == null) {
	requestUri = "Unknown";
}

StringBuffer message = new StringBuffer();
message.append("URL: " + requestUri);
message.append("\nServlet Name : " + servletName);
//message.append("\nException Type : " + throwable.getClass().getName());
//message.append("\nException message: " + throwable.getMessage());
//ViksitLogger.logMSG(this.getClass().getName(),message.toString());


%>
<link rel="shortcut icon" href="<%=baseURL%>img/user_images/new_talentify_logo.png" />

<!-- Web Fonts -->
<link rel='stylesheet' type='text/css' href='//fonts.googleapis.com/css?family=Open+Sans:400,300,600&amp;subset=cyrillic,latin'/>

<!-- CSS Global Compulsory -->
<link rel="stylesheet" href="<%=baseURL %>assets/plugins/bootstrap/assets/css/bootstrap.min.css"/>

<link rel="stylesheet" href="<%=baseURL %>assets/assets/css/500.css"/>
</head>

<body>

	<div class="wrapper">
		
		<div class="container-fluid height-1000" style="padding: 0px !important">
			<div class="page-error">
				<h1 class="number text-center">500</h1>
				<h2 class="description text-center">Something's not just!</h2>
				<h3 class="text-center"> <strong>NOTE</strong>: Please go back and reload the page. If the issue persists, report below</h3>
			</div>		
			<div class="text-center copy"> <a target='_blank' href="https://docs.google.com/a/istarindia.com/spreadsheets/d/15RF7M5ysBV7fu77uOeAzd4QgLufJsdN9m6e_fgSRS00/edit?usp=sharing">Report here!</a></div>	
		</div>
	</div>


	<!-- JS Global Compulsory -->
	<script type="text/javascript" src="<%=baseURL %>assets/plugins/jquery/jquery.min.js?a=1"></script>
	<script type="text/javascript" src="<%=baseURL %>assets/plugins/jquery/jquery-migrate.min.js?a=1"></script>
	<script type="text/javascript" src="<%=baseURL %>assets/plugins/bootstrap/assets/js/bootstrap.min.js?a=1"></script>
	<!-- JS Implementing Plugins -->
	<script type="text/javascript" src="<%=baseURL %>assets/plugins/back-to-top.js?a=1"></script>
	<script type="text/javascript" src="<%=baseURL %>assets/plugins/smoothScroll.js?a=1"></script>
	<!-- JS Customization -->
	<script type="text/javascript" src="<%=baseURL %>assets/assets/js/custom.js?a=1"></script>
	<!-- JS Page Level -->
	<script type="text/javascript" src="<%=baseURL %>assets/assets/js/app.js?a=1"></script>
	<script type="text/javascript" src="<%=baseURL %>assets/assets/js/plugins/style-switcher.js?a=1"></script>
	<script type="text/javascript">
		jQuery(document).ready(function() {
			App.init();
		});
	</script>
	

</body>
</html>
