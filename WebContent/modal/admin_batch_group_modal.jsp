<%@page import="in.orgadmin.admin.services.OrgAdminBatchGroupService"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.dao.entities.BatchStudents"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.BatchStudentsDAO"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroupDAO"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<% String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
				
	int groupId = 2;
	if(request.getParameter("bg_id")!=null)
	{
		groupId= Integer.parseInt(request.getParameter("bg_id"));
	}	
	BatchGroup bg = new BatchGroupDAO().findById(groupId);

	ArrayList<Integer> selectedStudents=new OrgAdminBatchGroupService().getSelectedStudents(groupId);
	
	UIUtils ui = new UIUtils();
	
%>

			<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title text-center">Edit Section</h4>
			</div>
			<div class="modal-body" style="padding-bottom: 0px;">

				<form class="form-horizontal"
					action="<%=baseURL%>createOrUpdateBatchGroup" method="post">

					<input type="hidden" value="<%=bg.getOrganization().getId()%>" name="college_id" />
					<input type="hidden" value="<%=groupId%>" name="bg_id" />

					<div class="form-group">
						<h3 class="m-b-n-md">Name of the Section</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<input type="text" placeholder="Section Name.." name="group_name"  id='bg_name_idd'  value="<%=bg.getName() %>"
								class="form-control">
						</div>
					</div>
					<div class="form-group">
						<h3 class="m-b-n-md">Description</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<label class="font-noraml">Short Text about Section</label> <input type="text"
								placeholder="Section Description.." name="group_desc"   id='bg_desc_idd' value="<%=bg.getBgDesc()!=null ? bg.getBgDesc(): "" %>"
								class="form-control">
						</div>
					</div>
					<div class="form-group">
					<div class="col-lg-3">
							<h3 class="m-b-n-md">Type</h3>
							<hr class="m-b-xs">
							<div class="col-lg-12">
							
								<select
									class="form-control" name="group_type">
									<option value="ROLE" <%if(bg.getType().equalsIgnoreCase("ROLE")) {	%>selected	<% } %>>ROLE</option>
									<option value="SECTION" <%if(bg.getType().equalsIgnoreCase("SECTION")) {	%>selected	<% } %>>SECTION</option>
								</select>
							</div>
						</div>
						<div class="col-lg-9">
							<h3 class="m-b-n-md">Parent Role / Section</h3>
							<hr class="m-b-xs">
							<div class="col-lg-12">
								<select
									class="form-control" name="parent_group_id" id="parent_group_selector">
									<option value="-1">NONE</option>
									<%
									for(BatchGroup bgs: bg.getOrganization().getBatchGroups())
									{
										if(bgs.getId()!=bg.getId())
										{
											%>
											<option value="<%=bgs.getId() %>"  <%if(bgs.getId()==bg.getParentGroupId()) {%>selected<%} %>   ><%=bgs.getName() %> (<%=bgs.getType() %>)</option>
											<%
										}
									}
									%>
									
								</select>
							</div></div>
						</div>
					
					<div class="form-group">
							<h3 class="m-b-n-md">Members</h3>
							<hr class="m-b-xs">
							<div class="col-lg-2">								
								<div>
									<select data-placeholder="Filter By" class="select2-dropdown" tabindex="4" name="filter_by" id="edit_member_filter_by" data-batch_group_id="<%=bg.getId()%>" data-college_id="<%=bg.getOrganization().getId()%>">
										<option value=""></option>
										<option value="ORG">ORG</option>
										<option value="ROLE">ROLE</option>	
										<option value="SECTION">SECTION</option>	
									</select>
								</div>
							</div>
							<!-- <div class="col-lg-4" id="edit_role_section_holder" style="display:none">								
								<div>
									<select data-placeholder="Role/Section Name" class="select2-dropdown" multiple tabindex="8" name="role_section_id" id="edit_role_section_options">
									
											
									</select>
								</div>
							</div> -->
							<div class="col-lg-10">								
								<div>
									<select data-placeholder="Students..." class="select2-dropdown" multiple tabindex="4" name="student_list" id="edit_student_list_holder">
										
									</select>
								</div>
							</div>
						</div>
					<!-- <input type="hidden" name="student_list"> -->
					<div class="form-group" >
						<div class="col-lg-12">
							<input type="checkbox" name="select_all" class="js-switch" /> <label>Select
								all users within East Point College to this group</label>
						</div>
					</div>
<div class="modal-footer" style="padding-bottom: 0px;">
					<div class="form-group">
						<button type="submit" class="btn btn-danger">Save
							changes</button>
					</div></div>
				</form>
			</div></div>

	