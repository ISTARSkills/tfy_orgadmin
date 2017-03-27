<%@page import="com.istarindia.apps.dao.OrgAdmin"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.DBUTILS"%>
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
									<select class="form-control m-b" name="account"
										id="select_course_program_view" data-college='<%=colegeID%>'>
										<%=uiUtil.getCourses(colegeID)%>
									</select>

								</div>
							</div>
							<table id="program_view_datatable" style="display: none">

							</table>
							<div id="program_view"></div>
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
			</div>
		</div>
	</div>
</div>

