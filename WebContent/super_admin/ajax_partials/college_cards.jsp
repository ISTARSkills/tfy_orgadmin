<%@page import="in.superadmin.services.AccountManagementServices"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>

<%
	AccountManagementServices services = new AccountManagementServices();

	String firstLetter = "0";
	if (request.getParameterMap().containsKey("firstLetter")) {
		firstLetter = request.getParameter("firstLetter");
	}
	List<HashMap<String, Object>> collegeList = services.getAllCollegeList(firstLetter);
	for (HashMap<String, Object> item : collegeList) {
%>
<div class="col-lg-4">
	<div class="ibox">
		<div class="ibox-content clickablecards"
			data-url="/orgadmin_login?not_auth=true&org_id=<%=(int) item.get("id")%>">
			<h3>
				<strong><%=item.get("name")%></strong>
			</h3>

			<p class="small">
				<span class="label label-info"><%=item.get("count")%>
					Students</span>
			</p>
			<p class="small">
				<span class="label label-info"><%=services.getAllTotalCourses((int) item.get("id"))%>
					Programs</span>
			</p>

			<div class="full-height min-scroll-height">
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
										<div class="dd-handle"><%=batchGP.get("name")%></div>
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