<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<% String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";%>

<% UIUtils ui = new UIUtils();

/* OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user"); */

int colegeID = (int)request.getSession().getAttribute("orgId");
Organization college=new OrganizationDAO().findById(colegeID);

%>

<div class="ibox">
<button type="button" class="btn btn-w-m btn-danger" data-toggle="modal"
								data-target="#create_group_model" style="margin-bottom: 10px;">Add Section</button>
	<div class="col-lg-12">

		<!-- <button class="btn btn-default pull-right" data-toggle="modal"
			data-target="#create_group_model" type="button">
			<i class="fa fa-plus-circle"></i>
		</button> -->
		
		

		<div class="row">
			<table class="table table-bordered dataTables-example" id='batch_group_list'>
				<thead>
					<tr>
						<th>Batch Code</th>
						<th>Group Name</th>
						<th>Number of Students</th>
						<th>Number of batches</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%=ui.getAllGroups(colegeID) %>
				</tbody>
			</table>
		</div>
	</div>


	<div class="modal inmodal" id="create_group_model" tabindex="-1"
		role="dialog" aria-hidden="true" style="display: none;">
		<div class="modal-dialog modal-lg">


			<div class="modal-content animated flipInY">

					<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title text-center">Create Section</h4>
				</div>
				<div class="modal-body" style="padding-bottom: 0px;">

					<form class="form-horizontal"
						action="<%=baseURL%>createOrUpdateBatchGroup" method="post">
						<input type="hidden" value="" name="user_id" /> <input
							type="hidden" value="<%=colegeID%>" name="college_id" />
						<div class="form-group">
							<h3 class="m-b-n-md">Name of the Section</h3>
							<hr class="m-b-xs">
							<div class="col-lg-12">
								<input type="text" placeholder="Section Name.." name="group_name"
									class="form-control">
							</div>
						</div>

						<div class="form-group">
							<h3 class="m-b-n-md">Description</h3>
							<hr class="m-b-xs">
							<div class="col-lg-12">
								<label class="font-noraml">Short Text about Section</label> <input type="text"
									placeholder="Section Description.." name="group_desc"
									class="form-control">
							</div>
						</div>

						<div class="form-group">
							<h3 class="m-b-n-md">Members</h3>
							<hr class="m-b-xs">
							<div class="col-lg-12">
								
								<div>
									<select data-placeholder="Students..." class="select2-dropdown" multiple tabindex="4">
										<%=ui.getAllStudentsForBatch(colegeID,null)%>
									</select>
								</div>
							</div>
						</div>

						<div class="form-group">
							<div class="col-lg-12">
								<input type="checkbox" name="select_all" class="js-switch" /> <label>Select
									all users within <%=college.getName() %> to this group</label>
							</div>
						</div>
						<input type="hidden" name="student_list">
						 <div class="modal-footer" style="padding-bottom: 0px;">
						<div class="form-group">
							<button type="submit" class="btn btn-danger">Save
								changes</button>
						</div></div>
					</form>
				</div>
			</div></div>
		</div>
	</div>
</div>