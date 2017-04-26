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
					<li class=""><a data-toggle="tab" href="#tab-14">Course
							View</a></li>

				</ul>
				<div class="tab-content">
					<div id="tab-11" class="tab-pane active">
						<div class="panel-body">
							<div id="progress_view"></div>

							<table id="progress_view_datatable" data-college='<%=colegeID%>'
								style="display: none">

								</tbody>
							</table>
						</div>
					</div>
					<div id="tab-12" class="tab-pane">
						<div class="panel-body">
							<table id="competition_view_datatable"
								data-college='<%=colegeID%>' style="display: none">

							</table>
							<div id="competition_view"></div>
						</div>
					</div>
					<div id="tab-13" class="tab-pane">
						<div class="panel-body">
							<div class="form-group">
								<label class="col-sm-3 control-label">Select Course</label>
								<div class="col-sm-4">
									<select class="form-control m-b graph_filter_selector"  data-report_id="3040" name="course_id" data-college_id="<%=colegeID%>">										
										<%
										AdminServices serv = new AdminServices();
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
							<!-- <table id="program_view_datatable" style="display: none">

							</table>
							<div id="program_view"></div> -->
							<%ReportUtils utils = new ReportUtils();
							HashMap<String, String> conditions = new HashMap<>();
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
								<label class="col-sm-3 control-label">Select Batch Group</label>

								<div class="col-sm-4">
									<select class="form-control m-b"
										id="select_batchgroup_course_view" name="account"
										data-college='<%=colegeID%>'>
										<%=uiUtil.getBatchGroups(colegeID, null)%>
									</select>
								</div>
							</div>
							<table id="course_view_datatable" style="display: none">

							</table>
							<div id="course_view"></div>
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
					<!-- <div style="background-color: white !important" id="calendar"></div> -->
				</div>
			</div></div>
		</div>
	</div>
</div>

