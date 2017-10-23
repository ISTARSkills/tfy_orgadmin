<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="in.talentify.core.xmlbeans.ChildLink"%>
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
	String t2cPath = AppProperies.getProperty("t2c_path");
	String cdnPath = AppProperies.getProperty("cdn_path");
%>
<nav class="navbar navbar-expand-md fixed-top">
	<a class="navbar-brand" id='talentify_logo_holder'
		data-cdn='<%=cdnPath%>' data-t2c='<%=t2cPath%>'
		data-user='<%=user.getId()%>' href="#">Talentify</a>
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
		<%
			if (roleDir.equalsIgnoreCase("student")) {
		%>
		<ul class="navbar-nav">
			<li class="nav-item custom-leftmargin-type1"><a id=""
				class="nav-link custom-xp-number">{{studentProfile.experiencePoints}}
					<small class='custom-xp'>XP</small>
			</a></li>
			<li class="nav-item custom-leftmargin-type1"><a id=""
				class="nav-link custom-coins"><img class='custom-coin-icontag'
					ng-src="/assets/images/coin-icon.png" class="rounded" alt=""><small
					class='custom-xp'> {{studentProfile.coins}}</small></a></li>

			<li
				class="nav-item dropdown custom-leftmargin-type1 custom-rightmargin-type1 pt-0 pb-0"><a
				class="nav-link dropdown-toggle pt-0 pb-0"
				id="navbarDropdownNotificatinMenuLink" data-toggle="dropdown"
				aria-haspopup="true" aria-expanded="true"> <i
					class="fa fa-bell fa-4 mt-3 custom-bell-color" aria-hidden="true"></i><span
					class="badge badge-info custom-notificatin-bell">{{notifications.length}}</span></a>
				<div class="dropdown-menu scrollbar text-center pt-0 pb-0"
					aria-labelledby="navbarDropdownNotificatinMenuLink">


					<div ng-if="notifications.length==0">
						<img class='card-img-top mt-5'
							style="width: 100px; height: 100px;"
							ng-src='/assets/images/note_graphic.png' alt=''>
						<h1 class='text-center text-muted'>No Notifications</h1>
					</div>

					<div ng-if="notifications.length!=0"
						ng-repeat='notification in notifications'>

						<a class="dropdown-item custom-textSize "
							ng-class="(notification.status==READ ? 'text-muted' : '') "
							href="#">
							<div class='row p-0'>
								<div class='col-2 p-0'>
									<img class='custom-notification-imgtag'
										ng-src="{{notification.imageURL}}" alt="no-image">
								</div>
								<p class='col-10 text-left' ng-bind-html="notification.message"></p>
							</div>
						</a>
						<hr class='custom-no-margins'>
					</div>
				</div></li>



		</ul>
		<%
			}
		%>


		<ul class="navbar-nav custom-nav-left-border">
			<li class="nav-link"><img ng-src="{{studentProfile.profileImage}}"
				class="img-circle custom-profile-imgtag" alt=""></li>
			<li class="nav-item dropdown m-0"><a
				class="nav-link dropdown-toggle custom-profil-name" href="#"
				id="navbarDropdownMenuLink" data-toggle="dropdown"
				aria-haspopup="true" aria-expanded="true">Welcome
					{{studentProfile.firstName}} </a>
				<div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
					<a class="dropdown-item" href="#">Profile</a> <a
						class="dropdown-item" href="/auth/logout">Logout</a>
				</div></li>

		</ul>
		<a class="nav-link"> <span class="navbar-text"> </span></a>





	</div>
</nav>