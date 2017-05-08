<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
ReportUtils util = new ReportUtils();
int collegeId = Integer.parseInt(request.getSession().getAttribute("orgId").toString());
%>
<div class="row">
	<div class="col-lg-12">
		<div class="col-lg-12">
			<div class="ibox">
				<div class="ibox-content">
					<div id="wizard">
						<h1>Select Entity</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="row">
								<div class="col-lg-3">
									<div class="form-group">
										<label>Select Entity Type*</label> <select class="select2_demo_1 form-control" 
										data-college_id="<%=collegeId%>" 
										data-user_report_id="3057" 
										data-section_report_id="3058" 
										data-role_report_id="3059" 
										data-course_report_id_for_user="3060"
										data-course_report_id_for_section="3061"
										data-course_report_id_for_role="3062"
										id="entity_type_selector">
											<option value="null">Select Entity Type</option>
											<option value="USER">User</option>
											<option value="SECTION">Section</option>
											<option value="ROLE">Role</option>
										</select>
									</div>
								</div>
								<div class="col-lg-12">										
									<div id="entity_list_holder" style="display:none">
																											
									</div>									
								</div>
							</div>
						</div>

						<h1>Select Course</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="text-center m-t-md">
								<div class="row">
									<div class="col-lg-12">										
									<div id="entity_course_holder" style="display:none">
																											
									</div>									
								</div>
								</div>

							</div>
						</div>
						<h1>Edit Course</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="row m-b-lg m-t-lg">
								<div class="col-lg-3">
									<div id="auto_scheduler_edit_course">
									
									</div>
								</div>
								
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>

	</div>
	</div>