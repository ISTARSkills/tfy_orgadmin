<%@page import="tfy.webapp.ui.NotificationLinkFactory"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<div class="row border-bottom white-bg">
	<%@page import="in.talentify.core.utils.*"%>
	<%@page import="in.talentify.core.xmlbeans.*"%>
	<%@page import="com.viksitpro.core.dao.entities.*"%>
	<%@page import="com.istarindia.android.pojo.ComplexObject"%>
	<%@page import="com.istarindia.android.pojo.*"%>

	<%
		int count = 0;
		String activeUrl = request.getServletPath();
		String[] urlParts = activeUrl.split("/");
		activeUrl = urlParts[urlParts.length - 1];

 IstarUser istarUser =(IstarUser) request.getSession().getAttribute("user");		
//String userRole = istarUser.getUserRoles().iterator().next().getRole().getRoleName();
DBUTILS util = new DBUTILS();
String findUserRole ="SELECT 	ROLE .role_name FROM 	user_role, 	ROLE WHERE 	user_role.role_id = ROLE . ID AND user_role.user_id = "+istarUser.getId()+" order by ROLE . ID  limit 1";
List<HashMap<String, Object>> roles = util.executeQuery(findUserRole);
String userRole = "";
if(roles.size()>0 && roles.get(0).get("role_name")!=null )
{
	userRole = roles.get(0).get("role_name").toString();
}


System.out.println("user role  "+userRole);

String b_url = request.getRequestURL().toString();
String baseURL = b_url.substring(0, b_url.length() - request.getRequestURI().length())+ "/";

ComplexObject cp  = (ComplexObject)request.getAttribute("cp");

request.setAttribute("cp", cp);

	%>
	<nav class="navbar navbar-static-top" role="navigation">
		<div class="navbar-header">
			<button aria-controls="navbar" aria-expanded="false"
				data-target="#navbar" data-toggle="collapse"
				class="navbar-toggle collapsed" type="button">
				<i class="fa fa-reorder"></i>
			</button>
			<a href="/student/dashboard.jsp" class="navbar-brand">
			<div class='row'>
			<div class='col-md-3'>			<img style="    width: 40px;
    margin-left: -33px;
    margin-top: -10px;" src='/assets/img/user_images/new_talentify_logo_inverse.png'>
			</div>
			<div  class='col-md-9'>	Talentify
			</div>
			</div></a>
			
		</div>
		<div class="navbar-collapse collapse" id="navbar">
			<ul class="nav navbar-nav">
				<%
					for (ParentLink link : (new UIUtils()).getMenuLinks(userRole.toLowerCase())) {
						if (link.isIs_visible_in_menu()) {
							
				%>

				<li><a id="<%=link.getDisplayName().replace(" ","")%>"
					href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>
				<%
					} else {
							System.out.println("48 activeUrl-=>" + activeUrl);
						}
					}
				
					
				
				%>
			</ul>
			
			<%if(request.getSession().getAttribute("not_auth")!=null){
			
			System.out.println("--vhvhvhv-->"+request.getParameter("not_auth"));
			
			%>

			<%} else {%>

			<ul class="nav navbar-top-links navbar-right">
			<span class="label" style="color: #eb384f;font-size: 15px; background: white;"><img alt="" src="/assets/img/user_images/coins_icon.png" style=" width: 14px;"> <%=cp.getStudentProfile().getCoins() %></span>
			<span class="label" style="color: #eb384f;font-size: 15px; background: white;"><%=cp.getStudentProfile().getExperiencePoints() %>&nbsp;&nbsp; XP </span>
				<li class="dropdown"><a class="dropdown-toggle count-info"
					data-toggle="dropdown" href="#" aria-expanded="true"> <i style="color:#eb384f" " 
						class="fa fa-bell"></i> <span class="label label-warning"><%=cp.getNotificationsValid() %></span>
				</a>
					<ul class="dropdown-menu dropdown-messages">
						<% 
						
						List<NotificationPOJO> items = cp.getNotifications();
				        Collections.reverse(items);
						for(NotificationPOJO notification: items) { 
							
							PrettyTime p = new PrettyTime();
							Timestamp createdAt = (Timestamp) notification.getTime();
							String time = p.format(createdAt);
							
							if(notification.getStatus().equalsIgnoreCase("UNREAD")) {
							if(notification.getItemType().equalsIgnoreCase("ASSESSMENT") 
									||  notification.getItemType().equalsIgnoreCase("CLASSROOM_SESSION")
									|| notification.getItemType().equalsIgnoreCase("LESSON")
									|| notification.getItemType().equalsIgnoreCase("MESSAGE")
									|| notification.getItemType().equalsIgnoreCase("LESSON_PRESENTATION") 
									|| notification.getItemType().equalsIgnoreCase("CLASSROOM_SESSION_STUDENT")){
								
								String url = NotificationLinkFactory.getURL(notification, istarUser.getId());
								if(notification.getItemType().equalsIgnoreCase("ASSESSMENT"))
								{
									int assessmentTaskId = ((Double)notification.getItem().get("taskId")).intValue();
									for(TaskSummaryPOJO task : cp.getTaskForTodayCompleted())
									{
										if(task.getId()== assessmentTaskId)
										{
											url="/student/assessment_report.jsp?assessment_id="+notification.getItemId().intValue()+"&user_id="+cp.getId();
												break;	
										}	
									}	
								}	
							%>
						<li style="    margin-left: -31px;min-height: 38px;	">
							<div class="dropdown-messages-box notification_holder_status" data-url="<%=baseURL+"t2c/notifications/user/"+cp.getId() %>" data-notifiction="<%=notification.getId()%>" >
								<a href="<%=url %>" class="pull-left"> <img alt="image" class='' style="width: 45px;" src="<%=notification.getImageURL() %>">
								</a>
								<div class="media-body">
									<small class="pull-right"><%=time %></small>
									<%if(!url.equalsIgnoreCase("#")){ %>	
																	<a href="<%=url%>" target="_blank" class="pull-left"> <%=notification.getMessage().trim() %></a><br>
																	<%}else{ %>
												<a class="pull-left"><%=notification.getMessage().trim() %></a><br>					
								<%} %>
								</div>
							</div>
						</li>						<li class="divider"></li>
						<% } }} %>
					</ul></li>


				<li><a href="/auth/logout"> <i class="fa fa-sign-out"></i>
						Log out
				</a></li>
			</ul>

			<%}
			
			%>
		</div>

	</nav>
	<%-- <jsp:include page="/chat_element.jsp"></jsp:include>
<jsp:include page="/alert_notifications.jsp"></jsp:include> --%>
	<div style="display: none" id="student_page_loader">
		<div style="width: 100%; z-index: 6; position: fixed;"
			class="spiner-example">
			<div style="width: 100%;" class="sk-spinner sk-spinner-three-bounce">
				<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
				<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
				<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
			</div>
		</div>
	</div>
</div>