<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.*"%>

<% 
UIUtils ui_Util = new UIUtils();
 %>
<div class="row border-bottom white-bg ">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-content">
			<div class="row">
				<div class="col-lg-12">
					<div class="no-paddings bg-muted">
						<div class="ibox-title">
							<h5>SuperAdmin List</h5>
						</div>
						<div class="ibox-content">
							<%
								HashMap<String, String> conditions = new HashMap();
								conditions.put("limit", "12");
								conditions.put("offset", "0");
								conditions.put("static_table", "true");
								ReportUtils util = new ReportUtils();
							%>
							<%=util.getTableFilters(Integer.parseInt("3080"), conditions)%>
							<%=util.getTableOuterHTML(Integer.parseInt("3080"), conditions)%>
							<%%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<br>
<br>
<br>
