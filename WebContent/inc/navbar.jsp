<%@page import="in.talentify.core.xmlbeans.ChildLink"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.google.cloud.Role"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.talentify.core.xmlbeans.ParentLink"%>

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
	String mainRole = (String) request.getSession().getAttribute("main_role");
	ArrayList<Role> userRoles = (ArrayList<Role>) request.getSession().getAttribute("user_roles");
	String loggedInRole = (String) request.getSession().getAttribute("logged_in_role");
	String roleDir = loggedInRole.toLowerCase();
	if (loggedInRole.toLowerCase().equalsIgnoreCase("trainer")) {
		roleDir = "student";
	}
	if (loggedInRole.toLowerCase().equalsIgnoreCase("org_admin")) {
		roleDir = "orgadmin";
	}
	String b_url = request.getRequestURL().toString();
	String baseURL = b_url.substring(0, b_url.length() - request.getRequestURI().length()) + "/";
	ComplexObject cp = (ComplexObject) request.getAttribute("cp");
	request.setAttribute("cp", cp);
%>





<nav class="navbar navbar-expand-md fixed-top">
	<a class="navbar-brand" href="#">Talentify</a>
	<button class="navbar-toggler" type="button" data-toggle="collapse"
		data-target="#navbarsExampleDefault"
		aria-controls="navbarsExampleDefault" aria-expanded="false"
		aria-label="Toggle navigation">
		<span class="navbar-toggler-icon"></span>
	</button>

	<div class="collapse navbar-collapse" id="navbarsExampleDefault">
		<ul class="navbar-nav mr-auto">

			<%   String activeClass = "active";
				for (ParentLink link : (new UIUtils()).getMenuLinks(loggedInRole.toLowerCase())) {
					
					if (link.isIs_visible_in_menu()) {
						int nav_link_id = 0;
						if (link.getChildren().size() == 0) {
							
							
							%>


			
				
				<li class="nav-item <%=activeClass%>"><a id="<%=link.getDisplayName().replace(" ", "")%>" class="nav-link" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>

			<%

						}else{
						
							%>

			<li class="nav-item dropdown <%=activeClass%>"><a
				class="nav-link dropdown-toggle" href="<%=link.getUrl()%>"
				id="<%=link.getDisplayName().replace(" ", "")%>"
				data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><%=link.getDisplayName()%></a>

				<div class="dropdown-menu"
					aria-labelledby="<%=link.getDisplayName().replace(" ", "")%>">

					   <%
							
	
							for (ChildLink child : link.getChildren()) {
								
					    %>


					<a class="dropdown-item" id="<%=link.getDisplayName().replace(" ", "")%>" href="<%=child.getUrl()%>"><%=child.getDisplayName()%></a>
					<%	
							}
						
					   %>
						</div></li>
					      <%	
						}
						
					
					}
					activeClass="";
				}
			       %>
			       
			     </ul>
			     <ul class="navbar-nav">
			     <li class="nav-item"><a id="" class="nav-link custom-xp-number" href="#"><%=cp.getStudentProfile().getExperiencePoints() %> <small class='custom-xp'>XP</small></a></li>
			     <li class="nav-item"><a id="" class="nav-link custom-coins" href="#"><img src="/assets/images/coin-icon.png" width="24px" height="24px" class="rounded" alt=""><small class='custom-xp'> <%=cp.getStudentProfile().getCoins() %></small></a></li>
			    
			     </ul>
			     
			     
			     
			 <ul class="navbar-nav">     
			  <li class="nav-link" href="#"> <img src="<%=cp.getStudentProfile().getProfileImage() %>" width="24px" height="24px" class="rounded" alt=""></li>
			      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">Welcome
         <%=cp.getStudentProfile().getFirstName() %>
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          <a class="dropdown-item" href="#">Profile</a>
          <a class="dropdown-item" href="#">Another action</a>
        </div>
      </li>
                       
         </ul>           <a class="nav-link" href="#">   <span class="navbar-text">  </span></a>

               

		

	</div>
</nav>