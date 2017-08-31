<%@page import="com.istarindia.android.pojo.NotificationPOJO"%>
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

			<%
				String activeClass = "active";
				for (ParentLink link : (new UIUtils()).getMenuLinks(loggedInRole.toLowerCase())) {

					if (link.isIs_visible_in_menu()) {
						int nav_link_id = 0;
						if (link.getChildren().size() == 0) {
			%>




			<li class="nav-item <%=activeClass%>"><a
				id="<%=link.getDisplayName().replace(" ", "").toLowerCase()%>"
				class="nav-link" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>

			<%
				} else {
			%>

			<li class="nav-item dropdown <%=activeClass%>"><a
				class="nav-link dropdown-toggle" href="<%=link.getUrl()%>"
				id="<%=link.getDisplayName().replace(" ", "").toLowerCase()%>"
				data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><%=link.getDisplayName()%></a>

				<div class="dropdown-menu"
					aria-labelledby="<%=link.getDisplayName().replace(" ", "")%>">

					<%
						for (ChildLink child : link.getChildren()) {
					%>


					<a class="dropdown-item"
						id="<%=link.getDisplayName().replace(" ", "").toLowerCase()%>"
						href="<%=child.getUrl()%>"><%=child.getDisplayName()%></a>
					<%
						}
					%>
				</div></li>
			<%
				}

					}
					activeClass = "";
				}
			%>

		</ul>
		<ul class="navbar-nav">
			<li class="nav-item custom-leftmargin-type1"><a id=""
				class="nav-link custom-xp-number"><%=cp.getStudentProfile().getExperiencePoints()%>
					<small class='custom-xp'>XP</small></a></li>
			<li class="nav-item custom-leftmargin-type1"><a id=""
				class="nav-link custom-coins"><img class='custom-coin-icontag'
					src="/assets/images/coin-icon.png" 
					class="rounded" alt=""><small class='custom-xp'> <%=cp.getStudentProfile().getCoins()%></small></a></li>

			<li
				class="nav-item dropdown custom-leftmargin-type1 custom-rightmargin-type1 pt-0 pb-0"><a
				class="nav-link dropdown-toggle pt-0 pb-0"
				id="navbarDropdownNotificatinMenuLink" data-toggle="dropdown"
				aria-haspopup="true" aria-expanded="true"> <i
					class="fa fa-bell fa-4 mt-3 custom-bell-color"  aria-hidden="true"></i><span
					class="badge badge-info custom-notificatin-bell"><%=cp.getNotifications().size() %></span></a>
				<div class="dropdown-menu scrollbar text-center pt-0 pb-0"
					aria-labelledby="navbarDropdownNotificatinMenuLink">
					
					<% if(roleDir.equalsIgnoreCase("student")){ 
						
						if(cp.getNotifications().size() == 0){
							
							%>
							<img class='card-img-top mt-5' style="width:100px; height:100px;" src='/assets/images/note_graphic.png' alt=''>
						    <h1 class='text-center text-muted'>No Notifications</h1>
							
							
							<%
							
						}else{
					for(NotificationPOJO np : cp.getNotifications()){
					%>
				       <a class="dropdown-item custom-textSize <%=np.getStatus().equalsIgnoreCase("READ")?"text-muted":"" %>" href="#">
				       <div class='row p-0'>
				       <div class='col-2 p-0'> <img class='custom-notification-imgtag' src="<%=np.getImageURL()%>"  alt=""></div>
				       <div class='col-10 text-left'><%=np.getMessage() %></div>
				       </div></a>
				       <hr class='custom-no-margins'>
                       <%} }%>  
                    <%} %>
				</div></li>



		</ul>



		<ul class="navbar-nav custom-nav-left-border">
			<li class="nav-link" href="#"><img
				src="<%=cp.getStudentProfile().getProfileImage()%>"  class="img-circle custom-profile-imgtag" alt=""></li>
			<li class="nav-item dropdown m-0"><a
				class="nav-link dropdown-toggle custom-profil-name" href="#"
				id="navbarDropdownMenuLink" data-toggle="dropdown"
				aria-haspopup="true" aria-expanded="true">Welcome <%=cp.getStudentProfile().getFirstName()%>
			</a>
				<div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
					<a class="dropdown-item" href="#">Profile</a> <a
						class="dropdown-item" href="/auth/logout">Logout</a>
				</div></li>

		</ul>
		<a class="nav-link"> <span class="navbar-text"> </span></a>





	</div>
</nav>