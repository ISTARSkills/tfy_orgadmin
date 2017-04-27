<%@page import="tfy.admin.services.GraphCustomServices"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="tfy.admin.services.AdminServices"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.ArrayList"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="in.talentify.core.utils.ColourCodeUitls"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	int colegeID = 0;
	UIUtils uiUtil = new UIUtils();
	DBUTILS dbutils1 = new DBUTILS();
	AdminServices serv = new AdminServices();
	ReportUtils utils = new ReportUtils();
	HashMap<String, String> conditions = new HashMap<>();
	GraphCustomServices custServ= new GraphCustomServices();
	if (request.getParameterMap().containsKey("colegeID")) {

		colegeID = Integer.parseInt(request.getParameter("colegeID"));

	}
%>
<div class="col-lg-6">
	<div class="row">
		<div class="col-lg-12 no-padding bg-muted">
			<div class="tabs-container">
				<ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-11">Progress
							View</a></li>
					<li class=""><a data-toggle="tab" href="#tab-12">Competition
							View</a></li>
					<li class=""><a data-toggle="tab" href="#tab-13">Program
							View</a></li>
					<li class=""><a data-toggle="tab" href="#tab-14">Section
							View</a></li>

				</ul>
				<div class="tab-content">
					<div id="tab-11" class="tab-pane active">
						<div class="panel-body">
							
					 <% conditions = new HashMap();
					 conditions.put("college_id", colegeID+"");
					 %> 
					<%=custServ.getProgressGraph(1,conditions) %>			
						</div>
					</div>
					<div id="tab-12" class="tab-pane">
						<div class="panel-body">
						
						  <% conditions = new HashMap();
					 conditions.put("college_id", colegeID+"");
					 %> 
					<%=custServ.getCompetitionGraph(conditions)%>   
							
							<%-- <table id="competition_view_datatable"
								data-college='<%=colegeID%>' style="display: none">

							</table>
							<div id="competition_view"></div> --%>
						</div>
					</div>
					<div id="tab-13" class="tab-pane">
						<div class="panel-body">
							<div class="form-group">
								<label class="col-sm-3 control-label">Select Program</label>
								<div class="col-sm-4">
									<select class="form-control m-b graph_filter_selector"  data-report_id="3040" name="course_id" data-college_id="<%=colegeID%>">										
										<%
										
										ArrayList<Course> courses = serv.getCoursesInCollege(colegeID);
										for(Course course : courses)
										{
										%>
										<option value="<%=course.getId()%>"><%=course.getCourseName().trim()%></option>
										<%
										} %>
									</select>

								</div>
							</div>
							
							<%
							conditions = new HashMap();
								conditions.put("college_id", colegeID+"");
							if(courses.size()>0){
								conditions.put("course_id", courses.get(0).getId()+"");
							}
							System.err.println();;							
							%>
							<%=utils.getHTML(3040, conditions) %>
						</div>
					</div>
					<div id="tab-14" class="tab-pane">
						<div class="panel-body">

							<div class="form-group">
								<label class="col-sm-3 control-label">Select Section</label>

								<div class="col-sm-4">
								<select class="form-control m-b graph_filter_selector"  data-report_id="3041" name="batch_group_id" data-college_id="<%=colegeID%>">										
										<%
										ArrayList<BatchGroup> batchGroups = serv.getBatchGroupInCollege(colegeID);
										for(BatchGroup batchGroup : batchGroups)
										{
										%>
										<option value="<%=batchGroup.getId()%>"><%=batchGroup.getName().trim()%></option>
										<%
										} %>
									</select>
									
								</div>
							</div>
							<%
							conditions = new HashMap();
								conditions.put("college_id", colegeID+"");
							if(batchGroups.size()>0){
								conditions.put("batch_group_id", batchGroups.get(0).getId()+"");
							}
													
							%>
							<%=utils.getHTML(3041, conditions) %>
							
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<hr>
	<div class="row">
		<div class="col-md-12">
		<div class="ibox white-bg" style="padding-top: 5px;"">
			<%=new ColourCodeUitls().getColourCode() %>
			<div class="ibox">
				<div class="ibox-content">
					<%
						CalenderUtils calUtil = new CalenderUtils();
						HashMap<String, String> input_params = new HashMap();
						/* 						OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user");
						 */
						int college_id = (int) request.getSession().getAttribute("orgId");
						input_params.put("org_id", college_id + "");
					%>
					<%=calUtil.getCalender(input_params).toString()%>
				</div>
			</div></div>
		</div>
	</div>
</div>

