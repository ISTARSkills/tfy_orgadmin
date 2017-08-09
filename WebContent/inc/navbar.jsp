<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="tfy.webapp.ui.NotificationLinkFactory"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="java.util.Collections"%>
<%@page import="com.istarindia.android.pojo.NotificationPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="org.apache.commons.lang3.text.WordUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><div class="row border-bottom white-bg">
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
		String mainRole =  (String)request.getSession().getAttribute("main_role");
		ArrayList<Role> userRoles = (ArrayList<Role>) request.getSession().getAttribute("user_roles");
		String loggedInRole = (String)request.getSession().getAttribute("logged_in_role");
		String roleDir = loggedInRole.toLowerCase();
		if(loggedInRole.toLowerCase().equalsIgnoreCase("trainer")) {
			roleDir = "student";
		}if(loggedInRole.toLowerCase().equalsIgnoreCase("org_admin")) {
			roleDir = "orgadmin";
		}

String b_url = request.getRequestURL().toString();
String baseURL = b_url.substring(0, b_url.length() - request.getRequestURI().length())+ "/";
	
		ComplexObject cp  = (ComplexObject)request.getAttribute("cp");

		request.setAttribute("cp", cp);
	%>
	<style>
.navbar .nav li.dropdown>.dropdown-toggle:hover, .navbar .nav li.dropdown.open>.dropdown-toggle:hover
	{
	background-color: transparent !important;
	.
	dropdown-submenu
	{
	position
	:
	relative;
}

.dropdown-submenu .dropdown-menu {
	top: 0;
	left: 100%;
	margin-top: -1px;
}
</style>
	<nav class="navbar navbar-static-top" role="navigation">
		<div class="navbar-header">
			<button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
				<i class="fa fa-reorder"></i>
			</button>
			<a href="/<%=roleDir %>/dashboard.jsp" class="navbar-brand custom-theme-color">Talentify</a>
		</div>
		<div class="navbar-collapse collapse" id="navbar">


			<ul class="nav navbar-nav">

				<%
					for (ParentLink link : (new UIUtils()).getMenuLinks(loggedInRole.toLowerCase())) {
						if (link.isIs_visible_in_menu()) {
							int nav_link_id = 0;
							if (link.getChildren().size() == 0) {
				%>
				<li><a id="<%=link.getDisplayName().replace(" ", "")%>" class="top_navbar_holder" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>
				<%
					} else {
				%>
				'
				<li class="dropdown"><a aria-expanded="false" role="button" href="<%=link.getUrl()%>" class="dropdown-toggle" data-toggle="dropdown"><%=link.getDisplayName()%><span class="caret"></span> </a>
					<ul role="menu" class="dropdown-menu">
						<%
							for (ChildLink child : link.getChildren()) {
						%>
						<li><a id="<%=link.getDisplayName().replace(" ", "")%>" href="<%=child.getUrl()%>"><%=child.getDisplayName()%></a></li>

						<%
							}
										DBUTILS utils = new DBUTILS();
										String sql = "select * from super_admin_reports where type='UTILITY_REPORT' ";
										List<HashMap<String, Object>> data = utils.executeQuery(sql);
										if (data.size() > 0) {

											for (HashMap<String, Object> row : data) {
												String reportId = row.get("report_id").toString();
												/* String organizationId = "2"; */
												String reportName = row.get("report_name").toString();
						%>
						<li><a href="/super_admin/custom_task_report_super_admin.jsp?report_name=<%=reportName%><%-- &organziation_id=<%=organizationId%> --%>&report_id=<%=reportId%>"> <%=reportName%>
						</a></li>
						<%
							}
						%>



						<%
							}
						%>
					</ul></li>
				<%
					}

						}
					}

					if (loggedInRole.equalsIgnoreCase("SUPER_ADMIN")) {

						DBUTILS utils = new DBUTILS();
						String sql = "select * from super_admin_reports where type='CUSTOM_REPORT'";
						List<HashMap<String, Object>> data = utils.executeQuery(sql);
						if (data.size() > 0) {
				%>
				<li class="dropdown"><a aria-expanded="true" role="button" href="" class="dropdown-toggle" data-toggle="dropdown">Custom Reports </a>
					<ul role="menu" class="dropdown-menu">
						<%
							for (HashMap<String, Object> row : data) {
										String reportId = row.get("report_id").toString();
										String organizationId = "2";
										String reportName = row.get("report_name").toString();
						%>
						<li><a href="/super_admin/custom_report_super_admin.jsp?report_name=<%=reportName%>&organziation_id=<%=organizationId%>&report_id=<%=reportId%>"> <%=reportName%>
						</a></li>
						<%
							}
						%>
					</ul></li>


				<%
					}
				%>
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown">Switch Organization<b class="caret"></b></a> 
				<%
				 	DBUTILS db = new DBUTILS();
				 		String sql2 = "SELECT pincode.state, organization.name, organization.id, count(user_org_mapping.user_id) as cnt FROM organization, pincode, address, user_org_mapping WHERE organization.address_id = address. ID AND address.pincode_id = pincode. ID and organization.id=user_org_mapping.organization_id GROUP BY organization.id, organization.name, pincode.state";
				 		List<HashMap<String, Object>> orgdata = db.executeQuery(sql2);
				
				 		HashMap<String, ArrayList<Organization>> orgs = new HashMap();
				 		for (Organization o : (List<Organization>) new OrganizationDAO().findAll()) {
				 			if (o.getUserOrgMappings().size() > 0) {
				 				if (o.getAddress() != null && o.getAddress().getPincode() != null
				 						&& o.getAddress().getPincode().getState() != null) {
				 					if (orgs.containsKey(o.getAddress().getPincode().getState().trim().toUpperCase())) {
				 						ArrayList<Organization> temp = orgs
				 								.get(o.getAddress().getPincode().getState().trim().toUpperCase());
				 						temp.add(o);
				 						orgs.put(o.getAddress().getPincode().getState().trim().toUpperCase(), temp);
				 					} else {
				 						ArrayList<Organization> temp = new ArrayList();
				 						temp.add(o);
				 						orgs.put(o.getAddress().getPincode().getState().trim().toUpperCase(), temp);
				 					}
				
				 				}
				 			}
				
				 		}
 				%>
					<ul class="dropdown-menu mega-menu" style="background-color: white;left: -100px;">
						<%
							for (String state : orgs.keySet()) {
									System.out.println("statte-" + state + "----- ");
									for (Organization org : orgs.get(state))

									{
										System.out.println("org-" + org.getName() + "6666");

									}
								}

								for (String state : orgs.keySet()) {
						%>
						<li class="mega-menu-column">
							<ul>


								<li class="nav-header" style="font-size: 15px;"><%=state.toUpperCase()%></li>
								<%
									for (Organization org : orgs.get(state))

											{
								%>
								<li style="font-size: 13px; display: block !important; cursor: help; border-bottom: 1px dotted #777;"><a href="/role_switch_controller?user_id=<%=user.getId()%>&main_role=<%=mainRole%>&org_id=<%=org.getId()%>"><%=org.getName()%></a></li>
								<%
									}
								%>


							</ul>
						</li>
						<%
							}
						%>





					</ul></li>

				<%
					} else if (loggedInRole.equalsIgnoreCase("ORG_ADMIN")) {
						DBUTILS utils = new DBUTILS();
						if (request.getSession().getAttribute("orgId") != null) {
							int orgId = (int) request.getSession().getAttribute("orgId");
							String sql = "select * from org_custom_report where organization_id=" + orgId;
							List<HashMap<String, Object>> data = utils.executeQuery(sql);
							if (data.size() > 0) {
				%>
				<li class="dropdown"><a aria-expanded="true" role="button" href="" class="dropdown-toggle" data-toggle="dropdown">Custom Reports </a>
					<ul role="menu" class="dropdown-menu">
						<%
							for (HashMap<String, Object> row : data) {
											String reportId = row.get("report_id").toString();
											String organizationId = row.get("organization_id").toString();
											String reportName = row.get("report_name").toString();
						%>
						<li><a href="/orgadmin/custom_report.jsp?report_name=<%=reportName%>&organziation_id=<%=organizationId%>&report_id=<%=reportId%>"> <%=reportName%>
						</a></li>
						<%
							}
						%>
					</ul></li>
				<%
					}
						}
					}
				%>



			</ul>
			<ul class="nav navbar-top-links navbar-right" style="display:flex">
			<%if(loggedInRole.equalsIgnoreCase("TRAINER") || loggedInRole.equalsIgnoreCase("STUDENT") || loggedInRole.equalsIgnoreCase("MASTER_TRAINER")){ %>
			
				<span class="label" style="color: #eb384f; font-size: 15px; background: white;"><img alt="" src="/assets/img/user_images/coins_icon.png" style="width: 14px;"> <%=cp != null && cp.getStudentProfile() != null && cp.getStudentProfile().getCoins() != null
					? cp.getStudentProfile().getCoins()
					: "0"%></span>
				<span class="label" style="color: #eb384f; font-size: 15px; background: white;"><%=cp != null && cp.getStudentProfile() != null && cp.getStudentProfile().getExperiencePoints() != null
							? cp.getStudentProfile().getExperiencePoints()
							: "0"%>&nbsp;&nbsp; XP </span>

				<li class="dropdown"><a class="dropdown-toggle count-info" data-toggle="dropdown" href="#" aria-expanded="false"> <i class="fa fa-bell"></i> <span class="label label-primary"><%=cp != null ? cp.getNotificationsValid() : ""%></span>
				</a>
				<ul class="dropdown-menu dropdown-alerts" style="overflow: auto; max-height: 571px;">
						<%
							List<NotificationPOJO> items = new ArrayList();

							if (cp != null && cp.getNotifications() != null) {
								items = cp.getNotifications();
							}

							Collections.reverse(items);
							for (NotificationPOJO notification : items) {

								PrettyTime p = new PrettyTime();
								Timestamp createdAt = (Timestamp) notification.getTime();
								String time = p.format(createdAt);

								if (notification.getStatus().equalsIgnoreCase("UNREAD")) {
									if (notification.getItemType().equalsIgnoreCase("ASSESSMENT")
											|| notification.getItemType().equalsIgnoreCase("CLASSROOM_SESSION")
											|| notification.getItemType().equalsIgnoreCase("LESSON")
											|| notification.getItemType().equalsIgnoreCase("MESSAGE")
											|| notification.getItemType().equalsIgnoreCase("LESSON_PRESENTATION")
											|| notification.getItemType().equalsIgnoreCase("CLASSROOM_SESSION_STUDENT")
											|| notification.getItemType().equalsIgnoreCase("WEBINAR_STUDENT")
											||  notification.getItemType().equalsIgnoreCase("WEBINAR_TRAINER")
											||  notification.getItemType().equalsIgnoreCase("REMOTE_CLASS_TRAINER")
											||  notification.getItemType().equalsIgnoreCase("REMOTE_CLASS_STUDENT")) {

										String url = NotificationLinkFactory.getURL(notification, user.getId());
										if (notification.getItemType().equalsIgnoreCase("ASSESSMENT")) {
											int assessmentTaskId = ((Double) notification.getItem().get("taskId")).intValue();
											for (TaskSummaryPOJO task : cp.getTaskForTodayCompleted()) {
												if (task.getId() == assessmentTaskId) {
													url = "/student/assessment_report.jsp?assessment_id="
															+ notification.getItemId().intValue() + "&user_id=" + cp.getId();
													break;
												}
											}
										}
						%><li>
							<div class='row  dropdown-messages-box notification_holder_status' data-notifiction="<%=notification.getId()%>" data-url="<%=baseURL + "t2c/notifications/user/" + cp.getId()%>">
								<div class='col-md-2'>
									<img src="<%=notification.getImageURL()%>" class="img-rounded" style="width: 100%">
								</div>
								<div class='col-md-9'>
									<%=notification.getMessage().trim()%>
									<br />
									<br /> <span class="pull-right text-muted small"><%=time%></span>
								</div>
							</div>
						</li>
						<li class="divider"></li>
						<%
							}
								}
							}
						%>

					</ul></li>
				<li><div style="border-left: 1px solid #e7eaec; height: 32px; margin-bottom: -11px; margin-left: 7px;margin-right: 7px;"></div></li>
				<%} %>
				<% 
				String imageurl = "";
				if (user != null && user.getUserProfile() != null) {
					imageurl = "http://cdn.talentify.in:9999/"+user.getUserProfile().getProfileImage();
				} %>
				<img style="height: 34px !important; margin-top: 8px;" src="<%=imageurl%> " class="img-circle img-md">
				<li class="dropdown">
				<a aria-expanded="true" role="button" href="" class="dropdown-toggle" data-toggle="dropdown">  Welcome &nbsp;&nbsp;&nbsp;<%=user.getUserProfile().getFirstName()%><span class="caret"></span>
				</a>
					<ul role="menu" class="dropdown-menu">
						<li><a href="/edit_profile.jsp"> Profile </a></li>

						<%
							if (userRoles != null && userRoles.size() > 1) {
						%>
						<li class="dropdown-submenu"><a class="test" tabindex="-1" href="#">Switch Role <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<%
									for (Role role : userRoles) {
											if (!role.getRoleName().equalsIgnoreCase(loggedInRole)) {
								%>
								<li><a tabindex="-1" href="/role_switch_controller?user_id=<%=user.getId()%>&main_role=<%=mainRole%>&new_role=<%=role.getRoleName()%>"> <%=WordUtils.capitalize(role.getRoleName().replace("_", " ").toLowerCase())%>
								</a></li>
								<%
									}
										}
								%>

							</ul></li>
						<%
							}
						%>

						<li><a href="/auth/logout"> Logout </a></li>

					</ul></li>
			</ul>
		</div>
	</nav>
	<%-- <jsp:include page="/chat_element.jsp"></jsp:include> --%>
	<%-- <jsp:include page="/alert_notifications.jsp"></jsp:include> --%>

	<div style="display: none" id="admin_page_loader">
		<div style="width: 100%; z-index: 6; position: fixed;" class="spiner-example">
			<div style="width: 100%;" class="sk-spinner sk-spinner-three-bounce">
				<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
				<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
				<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
			</div>
		</div>
	</div>
</div>