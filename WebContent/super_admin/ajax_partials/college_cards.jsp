<%@page import="in.superadmin.services.AccountManagementServices"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>

<%
	AccountManagementServices services = new AccountManagementServices();

	String firstLetter = "a";
	if (request.getParameterMap().containsKey("firstLetter")) {
		firstLetter = request.getParameter("firstLetter");
	}
	List<HashMap<String, Object>> collegeList = services.getAllCollegeList(firstLetter);
	for (HashMap<String, Object> item : collegeList) {
%>
<div class="col-lg-3 card-box no-padding bg-muted customcss_col-lg-3-widthsize">
	<div class="panel panel-primary custom-theme-panel-primary customcss_m-b-none bg-muted">
		<div class="panel-heading custom-theme-panal-color customcss_m-b-none bg-muted">
			<%=item.get("name")%>
			<a class="edit_organization customcss_college-cards" data-char="edit" data-org="<%=(int) item.get("id")%>"> <i class="fa fa-wrench"></i>
			</a>
		</div>
		<div class="panel-body clickablecards" data-url="/orgadmin_login?not_auth=true&org_id=<%=(int) item.get("id")%>">
			<p style="float: right">
				<span class="label label-primary custom-theme-label-primary customcss_college_card_lable"><%=item.get("count")%> Students</span> <span class="label label-primary custom-theme-label-primary customcss_college_card_lable"><%=services.getAllTotalCourses((int) item.get("id"))%> Programs</span>
			</p>

			<div class="full-height min-scroll-height customcss_minscroll_college_card">
				<div class="full-height-scroll">
					<div class="dd">
						<ol class="dd-list">
							<%
								List<HashMap<String, Object>> programList = services.getAllPrograms((int) item.get("id"));
									for (HashMap<String, Object> program : programList) {
							%>
							<li class="" data-id="2">
								<div class="dd-handle"><%=program.get("course_name")%></div>
								<ol class="dd-list">
									<%
										List<HashMap<String, Object>> batchList = services.getAllBG((int) program.get("course_id"),
														(int) item.get("id"));
												for (HashMap<String, Object> batchGP : batchList) {
									%>
									<li>
										<div class="dd-handle row">
											<div class="col-md-8 customcss_col-md-8">
												<%=batchGP.get("name")%></div>
											<div class="col-md-1"></div>
											<div class="col-md-3">
												<span class="label label-primary custom-theme-label-primary"><%=batchGP.get("stu_count")%> students</span>
											</div>
										</div>
									</li>
									<%	
										}
									%>
								</ol>
							</li>
							<%
								}
							%>
						</ol>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<%
	}
	if (collegeList.size() == 0) {
%>

<div class="gray-bg col-lg-12">
	<h4>
		<strong>No Record Found</strong>
	</h4>
</div>
<%}%>