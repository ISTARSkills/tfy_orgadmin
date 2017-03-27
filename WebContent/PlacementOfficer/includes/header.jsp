<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	PlacementOfficer user = (PlacementOfficer) request.getSession().getAttribute("user");
	if (request.getSession().getAttribute("user") != null) {
		String imageURL = user.getImageURL();
	}

	String imageURL = user.getImageURL();
	if (imageURL == null) {
		imageURL = "/img/user_images/tpo.png";
	}
%>
					
<nav class="navbar navbar-static-top" role="navigation"
	style="background: white; height: 45px; padding-top:10px; padding-bottom:10px;">
	<ul class="nav navbar-top-links navbar-right">
		<li class="m-r-sm text-muted"><span
			style="font-size: 22px; font-weight: bold; color: black;">Welcome
				to Talentify TPO</span></li>
		<li>
			<div class="dropdown profile-element">
				<a data-toggle="dropdown" class="dropdown-toggle" href="#"> <img
					style="width: 30px;padding-bottom:10px;" alt="<%=user.getName()%>" class="img-circle"
					src="<%=imageURL%>"/>
				</a>
				<ul class="dropdown-menu animated fadeInRight m-t-xs">
					<li><a href="<%=baseURL%>auth/logout">Logout</a></li>
				</ul>
			</div>
		</li>
	</ul>
</nav>