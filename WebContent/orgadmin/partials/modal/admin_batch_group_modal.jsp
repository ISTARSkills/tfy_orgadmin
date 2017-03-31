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

			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title pull-left">Edit a group</h4>
			</div>
			<div class="modal-body">

				<form class="form-horizontal"
					action="<%=baseURL%>createOrUpdateBatchGroup" method="post">

					<input type="hidden" value="<%=bg.getOrganization().getId()%>" name="college_id" />
					<input type="hidden" value="<%=groupId%>" name="bg_id" />

					<div class="form-group">
						<h3 class="m-b-n-md">Name of the group</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<input type="text" placeholder="Group Name.." name="group_name"  id='bg_name_idd'  value="<%=bg.getName() %>"
								class="form-control">
						</div>
					</div>

					<div class="form-group">
						<h3 class="m-b-n-md">Description</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<label>Short Text about Batch Group</label> <input type="text"
								placeholder="Group Description.." name="group_desc"   id='bg_desc_idd' value="<%=bg.getBgDesc()!=null ? bg.getBgDesc(): "" %>"
								class="form-control">
						</div>
					</div>

					<div class="form-group">
						<h3 class="m-b-n-md">Members</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							
							<div>
								<select data-placeholder="Students..." class="select2-dropdown" multiple tabindex="4">
									<%=ui.getAllStudentsForBatch(bg.getOrganization().getId(),selectedStudents)%>
								</select>
							</div>
						</div>
					</div>
					<input type="hidden" name="student_list">
					<div class="form-group" >
						<div class="col-lg-12">
							<input type="checkbox" name="select_all" class="js-switch" /> <label>Select
								all users within East Point College to this group</label>
						</div>
					</div>

					<div class="form-group">
						<button type="submit" class="btn btn-primary">Save
							changes</button>
					</div>
				</form>
			</div>

	