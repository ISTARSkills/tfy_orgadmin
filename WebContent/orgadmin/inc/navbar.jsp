<div class="row border-bottom white-bg">
<%@page import="in.talentify.core.utils.*"%>
<%@page import="in.talentify.core.xmlbeans.*"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

	<%
				IstarUser user = new IstarUser();
		int count = 0;
		String activeUrl = request.getServletPath();
		String[] urlParts = activeUrl.split("/");
		activeUrl = urlParts[urlParts.length - 1];
	
		int colegeID = (int)request.getSession().getAttribute("orgId");
 
 IstarUser istarUser =(IstarUser) request.getSession().getAttribute("user");
 Organization college = new OrganizationDAO().findById(colegeID);
		
		String userRole = "ORG_ADMIN";
	%>
	<nav class="navbar navbar-static-top" role="navigation">
		<div class="navbar-header">
			<button aria-controls="navbar" aria-expanded="false"
				data-target="#navbar" data-toggle="collapse"
				class="navbar-toggle collapsed" type="button">
				<i class="fa fa-reorder"></i>
			</button>
			<a href="/orgadmin/dashboard.jsp" class="navbar-brand">Talentify</a>
		</div>
		<div class="navbar-collapse collapse" id="navbar">
			<ul class="nav navbar-nav">
				<%
					for (ParentLink link : (new UIUtils()).getMenuLinks(userRole.toLowerCase())) {
						if (link.isIs_visible_in_menu()) {
							if (link.getDisplayName().equalsIgnoreCase("Placement") && userRole.equalsIgnoreCase("ORG_ADMIN")) {
								Organization admin =new Organization();
/* 								OrgAdmin admin = (OrgAdmin) user;

 */								if (admin.getIsCompany() != null && !admin.getIsCompany()) {
				%>
				<li><a id ="<%=link.getDisplayName().replace(" ","")%>" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>
				<%
					}

							} else {
				%>
				<li><a id ="<%=link.getDisplayName().replace(" ","")%>" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>
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
			<%if(request.getParameterMap().containsKey("not_auth") && request.getParameter("not_auth").equalsIgnoreCase("true")){%>
			<!-- <ul class="nav navbar-top-links navbar-right">
				<li><a href="/auth/logout"> <i class="fa fa-sign-out"></i>
						Log out
				</a></li>
			</ul> -->
			<%} else {%>
			
			<ul class="nav navbar-top-links navbar-right">
				<li><a href="/auth/logout"> <i class="fa fa-sign-out"></i>
						Log out
				</a></li>
			</ul>
			
			<%} %>
		</div>
	</nav>

</div>