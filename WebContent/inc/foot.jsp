<%@page import="com.viksitpro.core.dao.entities.Role"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = AppProperies.getProperty("cdn_path");

	String loggedInRole = (String) request.getSession().getAttribute("logged_in_role");
	String roleDir = loggedInRole.toLowerCase();
	if (loggedInRole.toLowerCase().equalsIgnoreCase("trainer")) {
		roleDir = "student";
	}
	if (loggedInRole.toLowerCase().equalsIgnoreCase("org_admin")) {
		roleDir = "orgadmin";
	}
%>

<script src="<%=basePath%>assets/js/jquery.min.js"></script>
<script src="<%=basePath%>assets/js/popper.min.js"></script>
<script src="<%=basePath%>assets/js/bootstrap.min.js"></script>
<script
	src="<%=basePath%>assets/js/plugins/angular-1.5.6/anguangular.min.js"></script>
<script
	src="<%=basePath%>assets/js/plugins/angular-1.5.6/angular-sanitize.js"></script>
<script
	src="<%=basePath%>assets/js/plugins/angular-1.5.6/angular-route.js"></script>
<script src="<%=basePath%>assets/js/plugins/angular-1.5.6/elif.js"></script>


<script src="<%=basePath%>assets/js/plugins/fullcalendar/moment.min.js"></script>
<script
	src="<%=basePath%>assets/js/plugins/fullcalendar/fullcalendar.min.js"></script>
<script type="text/javascript"
	src="https://www.gstatic.com/charts/loader.js"></script>
<script src="<%=basePath%>assets/js/jquery.dropdown.js"></script>

<script type="text/javascript"
	src="<%=basePath%>assets/js/moment.min.js"></script>
<script type="text/javascript"
	src="<%=basePath%>assets/js/daterangepicker.js"></script>
<script src="<%=basePath%>assets/js/plugins/jsTree/jstree.min.js"></script>
<script src="<%=basePath %>assets/js/plugins/sweetalert/sweetalert.min.js"></script>


<%
	if (roleDir.equalsIgnoreCase("student")) {
%>
<script src="<%=basePath%>assets/js/student-main.js"></script>

<%
	} else {
%>
<script src="<%=basePath%>assets/js/orgadmin-main.js"></script>
<%
	}
%>


<script src="<%=basePath%>assets/js/app.js"></script>

<%
	String userID = "NOT_LOGGED_IN_USER";

	if (request.getSession().getAttribute("user") != null) {
		userID = ((IstarUser) request.getSession().getAttribute("user")).getUserRoles().iterator().next()
				.getRole().getId() + "_" + ((IstarUser) request.getSession().getAttribute("user")).getId();
	}
%>
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-101152637-1', 'auto', {
	  userId: '<%=userID%>'
	});
	
ga('set', 'userId', '<%=userID%>');
	ga('send', 'pageview');
</script>
