<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<div class="row border-bottom white-bg">
<%@page import="in.talentify.core.utils.*"%>
<%@page import="in.talentify.core.xmlbeans.*"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

	<%
				
		int count = 0;
		String activeUrl = request.getServletPath();
		String[] urlParts = activeUrl.split("/");
		activeUrl = urlParts[urlParts.length - 1];
	
 DBUTILS util = new DBUTILS();
 IstarUser istarUser =(IstarUser) request.getSession().getAttribute("user");
 String findUserRole ="SELECT 	ROLE .role_name FROM 	user_role, 	ROLE WHERE 	user_role.role_id = ROLE . ID AND user_role.user_id = "+istarUser.getId()+" order by ROLE . ID  limit 1";
	List<HashMap<String, Object>> roles = util.executeQuery(findUserRole);
	String userRole = "";
	if(roles.size()>0 && roles.get(0).get("role_name")!=null )
	{
		userRole = roles.get(0).get("role_name").toString();
	}
	%>
	<nav class="navbar navbar-static-top" role="navigation">
		<div class="navbar-header">
			<button aria-controls="navbar" aria-expanded="false"
				data-target="#navbar" data-toggle="collapse"
				class="navbar-toggle collapsed" type="button">
				<i class="fa fa-reorder"></i>
			</button>
			<a href="/trainer/dashboard.jsp" class="navbar-brand">Talentify</a>
		</div>
		<div class="navbar-collapse collapse" id="navbar">
			<ul class="nav navbar-nav">
				<%
					for (ParentLink link : (new UIUtils()).getMenuLinks(userRole.toLowerCase())) {
					if (link.isIs_visible_in_menu()) 
					{
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
			<%
			} else {
			%>
			
			<ul class="nav navbar-top-links navbar-right">
				<li class="dropdown open">
                <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                    <i class="fa fa-cog"></i> Account Settings <!-- <span class="label label-primary">8</span> -->
                </a>
                <ul class="dropdown-menu dropdown-alerts" style="    width: 151px;">
                    <li>
                        <a href="/trainer/edit_profile.jsp" style="padding:0px">
                            <div>
                                <i class="fa fa-user fa-fw"></i> Profile
                                
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="/trainer/update_batch_code_wrapper.jsp" style="padding:0px">
                            <div>
                                <i class="fa fa-user fa-fw"></i> Update Batch Code
                                
                            </div>
                        </a>
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
<div style="display: none" id="admin_page_loader">
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