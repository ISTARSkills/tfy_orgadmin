<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="java.util.ArrayList"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.*"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	int colegeID = (int)request.getSession().getAttribute("orgId");

%>
<body class="top-navigation" id='super_admin_classroom'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content white-bg">

				<div class="row white-bg">
								<br><br>
					<!-- <button class="btn btn-default dim pull-right" id="class-add" type="button">
						<i class="fa fa-plus-circle"></i>
					</button> -->
				</div>

				<div class="row">
					<div class="panel-body">
							<div class="form-group">
								<label class="col-sm-3 control-label">Select Organization</label>
								<div class="col-sm-4">
									<select class="form-control m-b graph_filter_selector"  data-report_id="3069" name="org_id">										
										<%					
									List<Organization>orgs =	 new OrganizationDAO().findAll();
										;
										for(Organization org :orgs)
										{
										%>
										<option value="<%=org.getId()%>"><%=org.getName().trim()%></option>
										<%
										} %>
									</select>

								</div>
							</div>							
							<%
							
							ReportUtils utils = new ReportUtils();
								HashMap <String, String>conditions2 = new HashMap();
								
								conditions2.put("org_id", orgs.get(0).getId()+"");
								%>
								<%=utils.getHTML(3069, conditions2) %>
								<% 
							
											
							%>
							
						</div>
				</div>

			</div>
		</div>
		
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>