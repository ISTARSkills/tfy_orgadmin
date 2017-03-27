<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.istarindia.apps.dao.Course"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	int o_id = 0;
	
	String imageURL ="";
	
	if (request.getSession().getAttribute("user") != null) {
		imageURL = "img/user_images/recruiter.png";
	}

%>

<nav class="navbar-default navbar-static-side" role="navigation">
	<div style="width: 100%; height: 215px; background-color: white;">
	<a href="<%=baseURL%>orgadmin/dashboard.jsp">
	<center><img alt="NAME OF THE TIMEAGRE" src="<%=baseURL%>img/user_images/recruiter_portal_trans_logo.png" style="width: 65%; height:65%;padding-top: 37px;"/></center></a>
	</div>
	<div class="sidebar-collapse">
		<ul class="nav metismenu" id="side-menu">
			<%if(user.getUserType().equalsIgnoreCase("super_admin")){ %>
			<li><a href="<%=baseURL%>orgadmin/dashboard.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Dashboard</span></a></li>
			<li><a href="<%=baseURL%>orgadmin/ifram_current_state.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Current Programs</span></a></li>
			<li><a href="<%=baseURL%>orgadmin/dashboard_calendar.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Calendar</span></a></li>
			
			<%} else if (user.getUserType().equalsIgnoreCase("ORG_ADMIN")){
				
				OrgAdmin admin = (OrgAdmin)user;
				
				imageURL = admin.getImageUrl();
				if (imageURL == null) {
					imageURL = "/img/user_images/recruiter.png";
				}
				o_id = admin.getCollege().getId();
				
				%>
				
				<li><a href="<%=baseURL%>orgadmin/dashboard.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Dashboard</span></a></li>
				<li><a href="<%=baseURL%>orgadmin/dashboard_calendar.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Calendar</span></a></li>
			
			
<%-- 			<li><a href="<%=baseURL%>orgadmin/organization/dashboard.jsp?org_id=<%=o_id%>"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Dashboard</span></a></li>
 --%>			
			
			<%}else{ %>
			
			<li><a href="<%=baseURL%>orgadmin/student/dashboard.jsp?student_id=<%=user.getId()%>"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Dashboard</span></a></li>
			
			
			<%}
				OrgadminUtil util = new OrgadminUtil();
				out.println(util.getCourseLink(user, baseURL));
			%>

			<%
				try { if (request.getSession().getAttribute("org_id") != null) {
					int org_id = (int) request.getSession().getAttribute("org_id");
					College c = new CollegeDAO().findById(org_id);
			%>
			<li><a href=""><i class="fa fa-bar-chart-o"></i> <span class="nav-label"><%=c.getName()%></span><span class="fa arrow"></span></a>
				
				<ul class="nav nav-second-level collapse">
				<li><a href="<%=baseURL%>orgadmin/notification/create_notification.jsp?org_id=<%=c.getId()%>">Notification</a></li>
				<li><a href="<%=baseURL%>orgadmin/organization/dashboard.jsp?org_id=<%=c.getId()%>">Org Dashboard</a></li>
				
					<%
					Set<BatchGroup> bgs = c.getBatchGroups();
					if(bgs.size()>0)
					{
						for (BatchGroup bg : c.getBatchGroups()) {
							%>

							<li><a href="<%=baseURL%>orgadmin/batch_group/dashboard.jsp?batch_group_id=<%=bg.getId()%>"><%=bg.getName()%></a></li>
							<%
								}
					}
					else
					{
						%>
						<li><a href="<%=baseURL%>orgadmin/create_batch_group.jsps?org_id=<%=c.getId()%>">Create Batch Group</a></li>
					<%
					}	
					
					
					%>
				</ul></li>

			<%
				} } catch(Exception e) {}
			%>


			<%
				out.println(util.getTrinerLink(baseURL, user));
			%>
			
			
			<%
			if(user.getUserType().equalsIgnoreCase("super_admin")){
			%>
			
				<li><a href="<%=baseURL%>orgadmin/company/company_list.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Companies</span></a></li>
				<li><a href="<%=baseURL%>orgadmin/organization/organization_list.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Colleges</span></a></li>
				<li><a href="<%=baseURL%>orgadmin/company/vacancy_list.jsp"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Vacancies</span></a></li>
			<%
			}
			%>
			
		</ul>

	</div>
</nav>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-84077159-1', 'auto');
  ga('send', 'pageview');

</script>