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
				IstarUser user = new IstarUser();
		int count = 0;
		String activeUrl = request.getServletPath();
		String[] urlParts = activeUrl.split("/");
		activeUrl = urlParts[urlParts.length - 1];

 IstarUser istarUser =(IstarUser) request.getSession().getAttribute("user");		
String userRole = istarUser.getUserRoles().iterator().next().getRole().getRoleName();
System.out.println("user role  "+userRole);

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
			<a href="/student/dashboard.jsp" class="navbar-brand">Talentify</a>
		</div>
		<div class="navbar-collapse collapse" id="navbar">
			<ul class="nav navbar-nav">
				<%
					for (ParentLink link : (new UIUtils()).getMenuLinks(userRole.toLowerCase())) {
						if (link.isIs_visible_in_menu()) {
							
				%>

<li><a id ="<%=link.getDisplayName().replace(" ","")%>" href="<%=link.getUrl()%>"><%=link.getDisplayName()%></a></li>
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
			<li class="dropdown">
			<%
			ArrayList<NotificationPOJO> unreadArraylist = new ArrayList<NotificationPOJO>();
            if(cp != null && cp.getNotifications() != null){
            	
           
            Collections.sort(cp.getNotifications(),new Comparator<NotificationPOJO>() {
                public int compare(NotificationPOJO o1, NotificationPOJO o2) {
                    if (o1.getTime() == null) {
                        return (o2.getTime() == null) ? 0 : -1;
                    }
                    if (o2.getTime() == null) {
                        return 1;
                    }
                    return o2.getTime().compareTo(o1.getTime());
                }
            });
            for(NotificationPOJO notificationPojo:cp.getNotifications()){ 
            if(notificationPojo.getStatus() == "UNREAD"){
        		unreadArraylist.add(notificationPojo);
        	}}
            if(unreadArraylist.size() ==0){
            	int i=0;
                for(NotificationPOJO notificationPojo:cp.getNotifications()){ 
                	if(i<3){
                		unreadArraylist.add(notificationPojo);
                	}
                	i++;
                }
            }
            }
			%>
                    <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                        <i class="fa fa-bell"></i>  <span class="label label-primary"><%=unreadArraylist.size() %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-alerts">
                        
                        <%  
                        if(cp !=null && cp.getNotifications() != null && unreadArraylist.size() > 0){
                        for(NotificationPOJO notificationPojo:unreadArraylist){ 
                        	
                        %>
                        <li>
                            <div class="feed-element no-padding"  >
                                                    <a href="profile.html" class="pull-left">
                                                        <img alt="image" class="img-circle" src="<%=notificationPojo.getImageURL()%>">
                                                    </a>
                                                    <div class="media-body ">
                                                    	<%
										PrettyTime p = new PrettyTime();
											Timestamp createdAt = (Timestamp) notificationPojo.getTime();
											String time = p.format(createdAt);
									%>
                                                     <strong>  <%=notificationPojo.getMessage() %></strong><br>
                                                        <small class="text-muted"><%=time %></small>

                                                    </div>
                                                </div>
                        </li>
                        <li class="divider"></li>
                        <%} }%>
                        <li>
                            <div class="text-center link-block">
                                <a href="/student/notification.jsp">
                                    <strong>See All Alerts</strong>
                                    <i class="fa fa-angle-right"></i>
                                </a>
                            </div>
                        </li>
                    </ul>
                </li>

		
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
					<div style="width: 100%;"
						class="sk-spinner sk-spinner-three-bounce">
						<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
					</div>
				</div>
			</div>
</div>