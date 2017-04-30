<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
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
								data-target="#create_group_model" style="margin-bottom: 10px;">Add Section / Role</button>
	<div class="col-lg-12">
	<div class="row">
		<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");
				conditions.put("college_id", colegeID+"");				
				%>				
				<%=util.getTableOuterHTML(3045, conditions)%>
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
					<h4 class="modal-title text-center">Create Section / Role</h4>
				</div>
				<div class="modal-body" style="padding-bottom: 0px;">

					<form class="form-horizontal"
						action="<%=baseURL%>createOrUpdateBatchGroup" method="post">
						<input type="hidden" value="" name="user_id" /> <input
							type="hidden" value="<%=colegeID%>" name="college_id" />
						<div class="form-group">
							<h3 class="m-b-n-md">Name</h3>
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
							<h3 class="m-b-n-md">Type</h3>
							<hr class="m-b-xs">
							<div class="col-lg-3">
								<select
									class="form-control" name="group_type">
									<option value="ROLE">ROLE</option>
									<option value="SECTION">SECTION</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<h3 class="m-b-n-md">Parent Role / Section</h3>
							<hr class="m-b-xs">
							<div class="col-lg-10">
								<select
									class="form-control" name="parent_group_id">
									<option value="-1">NONE</option>
									<%
									for(BatchGroup bg : college.getBatchGroups())
									{										
										%>
										<option value="<%=bg.getId()%>"><%=bg.getName() %> (<%=bg.getType()%>)</option>				
										<% 	
									}
									%>
									
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<h3 class="m-b-n-md">Members</h3>
							<hr class="m-b-xs">
							<div class="col-lg-2">								
								<div>
									<select data-placeholder="Filter By" class="select2-dropdown" tabindex="4" name="filter_by" id="member_filter_by" data-college_id="<%=colegeID%>">
										<option value=""></option>
										<option value="ORG">ORG</option>
										<option value="ROLE"> ROLE</option>	
										<option value="SECTION"> SECTION</option>	
									</select>
								</div>
							</div>
							<div class="col-lg-4" id="role_section_holder" style="display:none">								
								<div>
									<select data-placeholder="Role/Section Name" class="select2-dropdown" multiple tabindex="8" name="role_section_id" id="role_section_options">
									
											
									</select>
								</div>
							</div>
							<div class="col-lg-6">								
								<div>
									<select data-placeholder="Students..." class="select2-dropdown" multiple tabindex="4" name="student_list" id="student_list_holder">
										
									</select>
								</div>
							</div>
						</div>

						<div class="form-group">
							<div class="col-lg-12">
								<input type="checkbox" name="select_all" class="js-switch" /> <label>Add
									all users to this group</label>
							</div>
						</div>
						
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
	
	<div class="modal inmodal" id="edit_group_modal" tabindex="-1"
		role="dialog" aria-hidden="true" style="display: none;">
		<div class="modal-dialog modal-lg">


			<div class="modal-content animated flipInY" id="edit_group_modal_content">
					
	</div>
	</div>
	</div>
	
	
</div>