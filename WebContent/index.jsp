<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = "http://cdn.talentify.in/";


try {
	Properties properties = new Properties();
	String propertyFileName = "app.properties";
	InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
	if (inputStream != null) {
		properties.load(inputStream);
		baseURL = properties.getProperty("cdn_path");
	}
} catch (IOException e) {
	e.printStackTrace();
}


	System.out.println(request.getSession().getAttribute("user"));
	if(request.getSession().getAttribute("user")!=null) {
		IstarUser user = (IstarUser)request.getSession().getAttribute("user");
		System.out.println("user email"+user.getEmail());
		String url1 = baseURL + "dashboard.jsp";
		
		DBUTILS util = new DBUTILS();
		
		String findUserRole ="SELECT 	ROLE .role_name FROM 	user_role, 	ROLE WHERE 	user_role.role_id = ROLE . ID AND user_role.user_id = "+user.getId()+" order by ROLE . ID  limit 1";
		List<HashMap<String, Object>> roles = util.executeQuery(findUserRole);
		String userRole = "";
		if(roles.size()>0 && roles.get(0).get("role_name")!=null )
		{
			userRole = roles.get(0).get("role_name").toString();
		}
		
		System.out.println("user role in index"+userRole);
		if (userRole.equalsIgnoreCase("SUPER_ADMIN")) { 
			url1 = "/super_admin/dashboard.jsp";
			System.out.println("super amdin");
		}else if (userRole.equalsIgnoreCase("ORG_ADMIN")) {
			
			url1 = "/orgadmin/dashboard.jsp?org_id=" + user.getUserOrgMappings().iterator().next().getOrganization().getId();
		}
		else if (userRole.equalsIgnoreCase("COORDINATOR"))
		{
			url1 = "/coordinator/dashboard.jsp";
		}else if(userRole.equalsIgnoreCase("TRAINER"))
		{
			url1 = "/student/dashboard.jsp";
		}
		else if (userRole.equalsIgnoreCase("STUDENT"))
		{
			url1 = "/student/dashboard.jsp";
		}
		else{			
			String errorResponse="";
			if(request.getAttribute("msg")!=null){				
				errorResponse=request.getAttribute("msg").toString();
				System.out.println("error-- redirecting to index.jsp 55555555"+ request.getAttribute("msg").toString()) ;
			}			
			request.setAttribute("msg", errorResponse);
			request.getRequestDispatcher("/login.jsp").forward(request, response);			
		}		
		response.sendRedirect(url1);		
	} else {
		String errorResponse="";
		if(request.getAttribute("msg")!=null){			
			errorResponse=request.getAttribute("msg").toString();
			System.out.println("error-- redirecting to index.jsp"+ request.getAttribute("msg").toString()) ;
		}		
		/* request.setAttribute("msg", errorResponse);
		request.getRequestDispatcher("/login.jsp").forward(request, response); */
		request.setAttribute("msg", errorResponse);
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}
%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>  EMPTY PAGE </title>

    <link href="<%=baseURL%>assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=baseURL%>assets/font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="<%=baseURL%>assets/css/animate.css" rel="stylesheet">
    <link href="<%=baseURL%>assets/css/style.css" rel="stylesheet">

</head>

<body class="gray-bg" id="admin_index_holder">



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
</html>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-84077159-1', 'auto');
  ga('send', 'pageview');

</script>
