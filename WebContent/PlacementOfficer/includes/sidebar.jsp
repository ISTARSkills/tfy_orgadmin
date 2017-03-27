<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.istarindia.apps.dao.Course"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	String url1 = request.getRequestURL().toString();
	String baseURL = url1.substring(0, url1.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	String url = "/PlacementOfficer/dashboard.jsp";
	String imageURL = "";
	/* if(imageURL == null) {
		imageURL = user.getUserType().toLowerCase() + ".png" ; 
	} */
	
	
	if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")) { 
		url = "/PlacementOfficer/dashboard.jsp";
	} 
	
	else if (user.getUserType().equalsIgnoreCase("TRAINER")) {
		
		url = "/orgadmin/student/dashboard.jsp?trainer_id=" + user.getId();
	}else if (user.getUserType().equalsIgnoreCase("STUDENT")) {
		
		url = "/orgadmin/student/dashboard.jsp?student_id=" + user.getId();
	}
	
	
	
	else if (user.getUserType().equalsIgnoreCase("ORG_ADMIN")) {
		OrgAdmin admin = (OrgAdmin) user;
		url = "/orgadmin/organization/dashboard.jsp?org_id=" + admin.getCollege().getId();
	} else if (user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR")) {
		IstarCoordinator admin = (IstarCoordinator) user;
		url = "/orgadmin/organization/dashboard.jsp?org_id=" + admin.getCollege().getId();
	} else if (user.getUserType().equalsIgnoreCase("RECRUITER")) {
		Recruiter admin = (Recruiter) user;
		url = "/recruiter/dashboard.jsp";
	} else if (user.getUserType().equalsIgnoreCase("PlacementOfficer")) {
		PlacementOfficer admin = (PlacementOfficer) user;
		url = "/PlacementOfficer/dashboard.jsp";
		imageURL = admin.getImageURL();
	}
%>

<nav class="navbar-default navbar-static-side" role="navigation">
	<div style="width: 100%; height: 215px; background-color:white;">
	<a href="<%=url%>"><center><img alt="NAME OF THE TIMEAGRE" src="<%=baseURL%>img/user_images/recruiter_portal_trans_logo.png" style="width: 65%; height:65%;padding-top: 37px;"/></center></a>
	</div>
		<div class="sidebar-collapse">	
			<ul class="nav metismenu" id="side-menu">
				<li><a href="<%=url%>"><i class="" aria-hidden="true"></i><span class="nav-label">DASHBOARD</span></a></li>
				<li><a href="<%=baseURL%>PlacementOfficer/campaign.jsp"><i class="" aria-hidden="true"></i><span class="nav-label">CAMPAIGNS</span></a></li>
				<li><a href="<%=baseURL%>PlacementOfficer/reports.jsp"><i class="" aria-hidden="true"></i><span class="nav-label">REPORTS</span></a></li>
			</ul>
			</ul>
		</div>
</nav>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-84077159-1', 'auto');
  ga('send', 'pageview');

</script>