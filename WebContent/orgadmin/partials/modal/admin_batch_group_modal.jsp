<%@page import="in.orgadmin.admin.services.OrgAdminBatchGroupService"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.dao.entities.BatchStudents"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.BatchStudentsDAO"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroupDAO"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
							<input type="text" placeholder="Section Name.." name="group_name"  required id='bg_name_idd'  value="<%=bg.getName() %>"
								class="form-control">
						</div>
					</div>

					<div class="form-group">
						<h3 class="m-b-n-md">Description</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<label class="font-noraml">Short Text about Batch Group</label> <input type="text"
								placeholder="Section Description.." name="group_desc"  required  id='bg_desc_idd' value="<%=bg.getBgDesc()!=null ? bg.getBgDesc(): "" %>"
								class="form-control">
						</div>
					</div>

					<div class="form-group">
						<h3 class="m-b-n-md">Members</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							
							<div>
								<select data-placeholder="Students..." class="select2-dropdown" multiple tabindex="4" name="student_list">
									<%=ui.getAllStudentsForBatch(bg.getOrganization().getId(),selectedStudents)%>
								</select>
							</div>
						</div>
					</div>
					<input type="hidden" >
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

	