<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
	System.out.println(request.getSession().getAttribute("user"));

	if(request.getSession().getAttribute("user")!=null) {
		IstarUser user = (IstarUser)request.getSession().getAttribute("user");
		String url1 = baseURL + "dashboard.jsp";
		if (user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN")) { 
			url1 = "/super_admin/dashboard.jsp";
		}else if (user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("ORG_ADMIN")) {
			System.out.println("------------------------------>"+user.getUserOrgMappings().iterator().next().getOrganization().getId());
			url1 = "/orgadmin/dashboard.jsp?org_id=" + user.getUserOrgMappings().iterator().next().getOrganization().getId();
		}
		
		response.sendRedirect(url1);
	} else {
		System.out.println("error-- redirecting to index.jsp") ;
		response.sendRedirect("/login.jsp");
	}

%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>  EMPTY PAGE </title>

    <link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="<%=baseURL%>css/animate.css" rel="stylesheet">
    <link href="<%=baseURL%>css/style.css" rel="stylesheet">

</head>

<body class="gray-bg">


    <div class="middle-box text-center animated fadeInDown">
        <h1>404</h1>
        <h3 class="font-bold">Page Not Found</h3>

        <div class="error-desc">
            Sorry, but the page you are looking for has note been found. Try checking the URL for error, then hit the refresh button on your browser or try found something else in our app.
            <form class="form-inline m-t" role="form">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="Search for page">
                </div>
                <button type="submit" class="btn btn-primary">Search</button>
            </form>
        </div>
    </div>

    

</body>

</html><script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-84077159-1', 'auto');
  ga('send', 'pageview');

</script>
