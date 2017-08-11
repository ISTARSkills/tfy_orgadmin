<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.viksitpro.core.dao.entities.Batch"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";%>

<% UIUtils ui = new UIUtils();

/* OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user"); */

int colegeID = (int)request.getSession().getAttribute("orgId");
Organization college=new OrganizationDAO().findById(colegeID);

%>
<div class="panel-body">
		<button type="button" class="btn btn-w-m btn-danger" data-toggle="modal" data-target="#create_group_model" style="margin-bottom: 10px;">Add Section / Role</button>
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


		<div class="modal inmodal" id="create_group_model" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
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

							<form class="form-horizontal" action="<%=baseURL%>createOrUpdateBatchGroup" method="post">
								<input type="hidden" value="" name="user_id" /> <input type="hidden" value="<%=colegeID%>" name="college_id" />
								<div class="form-group">
									<h3 class="m-b-n-md">Name</h3>
									<hr class="m-b-xs">
									<div class="col-lg-12">
										<input type="text" placeholder="Section Name.." name="group_name" required class="form-control">
									</div>
								</div>

								<div class="form-group">
									<h3 class="m-b-n-md">Description</h3>
									<hr class="m-b-xs">
									<div class="col-lg-12">
										<label class="font-noraml">Short Text about Section</label> <input type="text" placeholder="Section Description.." name="group_desc" class="form-control">
									</div>
								</div>
								<div class="form-group">
									<div class="col-lg-3">
										<h3 class="m-b-n-md">Mode</h3>
										<hr class="m-b-xs">
										<div class="col-lg-12">
											<select class="form-control" name="mode_type">
												<option value="BLENDED">BLENDED</option>
												<option value="ELT">ELT</option>
											</select>
										</div>
									</div>
									<div class="col-lg-3">
										<h3 class="m-b-n-md">Type</h3>
										<hr class="m-b-xs">
										<div class="col-lg-12">
											<select class="form-control" name="group_type">
												<option value="SECTION">SECTION</option>
												<option value="ROLE">ROLE</option>
											</select>
										</div>
									</div>
									<div class="col-lg-3">
										<h3 class="m-b-n-md">Is Primary</h3>
										<hr class="m-b-xs">
										<div class="col-lg-12">
											<input type="checkbox" name="is_primary" class="js-switch" />
										</div>
									</div>
									
									<div class="col-lg-3">
										<h3 class="m-b-n-md">Is Historical</h3>
										<hr class="m-b-xs">
										<div class="col-lg-12">
											<input type="checkbox" name="is_historical" class="js-switch" />
										</div>
									</div>
									
									<div class="col-lg-3">
										<div class="form-group">
						<h3 class="m-b-n-md">Enrolled Students</h3>
						<hr class="m-b-xs">
						<div class="col-lg-12">
							<input type="number" min='0' placeholder="Number of Students" name="student_count"  
							id='student_count_idd'  
							
							value="0"
								class="form-control">
						</div>
					</div>
									</div>
									
								</div>
									<div class="form-group">	
									<div class="col-lg-4">
										<h3 class="m-b-n-md">Parent Role / Section</h3>
										<hr class="m-b-xs">
										<div class="col-lg-12">
											<select class="form-control" name="parent_group_id">
												<option value="-1">NONE</option>
												<%
									for(BatchGroup bg : college.getBatchGroups())
									{										
										%>
												<option value="<%=bg.getId()%>"><%=bg.getName() %> (<%=bg.getType()%>)
												</option>
												<% 	
									}
									%>
											</select>
										</div>
									</div>
									<div class="col-lg-4">
									<h3 class="m-b-n-md">Filter Students</h3>
										<hr class="m-b-xs">
										<div>
											<select data-placeholder="Filter By" class="select2-dropdown" tabindex="4" name="filter_by" id="member_filter_by" data-college_id="<%=colegeID%>">												
												
												<option value="ORG">By Org</option>
												<option value="ROLE">By Role</option>
												<option value="SECTION">By Section</option>
											</select>
										</div>
									</div>
									<div class="col-lg-4" id="role_section_holder" style="display: none">
									<h3 class="m-b-n-md">Select Section/Role</h3>
										<hr class="m-b-xs">
										<div>
											<select data-placeholder="Role/Section Name" class="select2-dropdown" multiple tabindex="8" name="role_section_id" id="role_section_options">


											</select>
										</div>
									</div>
								</div>
							<div class="form-group">	
								<h3 class="m-b-n-md">Filtered Students</h3>
									<hr class="m-b-xs">
									
									<div class="col-lg-12">
									<div id="entity_actual_holder">				
										<div>
											<select data-placeholder="Students..." class="select2-dropdown" multiple tabindex="4" name="student_list" id="student_list_holder">

											</select>
										</div>
										</div>
									</div>
								</div>

								<div class="form-group">
									<div class="col-lg-12">
										<input type="checkbox" name="select_all" class="js-switch" /> <label>Add all users to this group</label>
									</div>
								</div>

								<div class="form-group">
									<h3 class="m-b-n-md">Add Courses</h3>
									<hr class="m-b-xs">
									<div class="col-lg-2">
										
										<div class="form-group" id="data_2">
										<%SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy"); %>
											<div class="input-group date">
												<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input name="startDate" type="text" class="form-control date_holder" value="<%=df.format(new Date())%>">
											</div>
										</div>

									</div>
									<div class="col-lg-4" id="course_holder">
										<div>
											<select data-placeholder="Course Name" class="select2-dropdown" multiple tabindex="8" name="course_ids" id="course_options">
												<%									
									for(Course  c : (List<Course>)new CourseDAO().findAll())
										{
											%>
												<option value="<%=c.getId()%>"><%=c.getCourseName()%></option>
												<% 
										}%>

											</select>
										</div>
									</div>

								</div>


								<div class="modal-footer" style="padding-bottom: 0px;">
									<div class="form-group">
										<button type="submit" class="btn btn-danger">Save changes</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="modal inmodal" id="edit_group_modal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
			<div class="modal-dialog modal-lg">


				<div class="modal-content animated flipInY" id="edit_group_modal_content"></div>
			</div>
		</div>


	</div>
