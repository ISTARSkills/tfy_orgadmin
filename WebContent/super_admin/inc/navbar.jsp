<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><div class="row border-bottom white-bg">
	<%@page import="in.talentify.core.utils.*"%>
	<%@page import="in.talentify.core.xmlbeans.*"%>
	<%@page import="com.viksitpro.core.dao.entities.*"%>

	<%
		String path = request.getContextPath();
		String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ path + "/";
		IstarUser user = new IstarUser();
		int count = 0;
		String activeUrl = request.getServletPath();
		String[] urlParts = activeUrl.split("/");
		activeUrl = urlParts[urlParts.length - 1];
		user = (IstarUser) request.getSession().getAttribute("user");
		String userRole = "SUPER_ADMIN";
	%>
	<nav class="navbar navbar-static-top" role="navigation">
		<div class="navbar-header">
			<button aria-controls="navbar" aria-expanded="false"
				data-target="#navbar" data-toggle="collapse"
				class="navbar-toggle collapsed" type="button">
				<i class="fa fa-reorder"></i>
			</button>
			<a href="/super_admin/dashboard.jsp" class="navbar-brand custom-theme-color">Talentify</a>
		</div>
		<div class="navbar-collapse collapse" id="navbar">
			<ul class="nav navbar-nav">
				<%
					for (ParentLink link : (new UIUtils()).getMenuLinks(userRole.toLowerCase())) {
						if (link.isIs_visible_in_menu()) {
							int nav_link_id =0;
							if (link.getDisplayName().equalsIgnoreCase("Placement") && userRole.equalsIgnoreCase("ORG_ADMIN")) {
								Organization admin =new Organization();
								if (admin.getIsCompany() != null && !admin.getIsCompany()) {
				%>
				<li><a id ="<%=link.getDisplayName().replace(" ","")%>" class="top_navbar_holder" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>
				<%
					}

							} else {
				%>
				<li><a id ="<%=link.getDisplayName().replace(" ","")%>" class="top_navbar_holder" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>
				<%
					}
				%>


				<%
					} else {
							System.out.println("48 activeUrl-=>" + activeUrl);
						}
					}
				%>
			</ul>
			<ul class="nav navbar-top-links navbar-right">
				<li><a href="/auth/logout"> <i class="fa fa-sign-out"></i>
						Log out
				</a></li>
			</ul>
		</div>
	</nav>
</div>