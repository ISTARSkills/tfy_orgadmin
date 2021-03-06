<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%
String reportId = request.getParameter("report_id");
String reportName = request.getParameter("report_name");
String orgId = request.getParameter("organziation_id");
ReportUtils util = new ReportUtils();
%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body class="top-navigation" id="custom_report">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="row wrapper border-bottom white-bg page-heading customcss_heading">
				<% 
			String[] brd = {"Dashboard","Custom Reports"};
			%>
				<%=UIUtils.getPageHeader(reportName, brd) %>

				<div class="col-lg-2"></div>
			</div>
			<div class="row customcss_superadmin_report ">

				<div class="col-lg-12 card-box margin-box">

					<div class="no-paddings bg-muted">
						
						<div class="ibox-content custom_card-box" data-report_id='<%=reportId%>' data-org_id='<%=orgId%>'>
							<%HashMap<String, String> conditions = new HashMap();
						conditions.put("limit", "12");
						conditions.put("offset", "0");
						conditions.put("org_id", orgId);
						conditions.put("static_table", "true");	
						
						%>

							<%= util.getTableFilters(Integer.parseInt(reportId), conditions) %>




							<%= util.getTableOuterHTML(Integer.parseInt(reportId), conditions) %>
							<%%>
						</div>
					</div>
				</div>
			</div>


		</div>
		<div class="modal inmodal fade" id="myModal6" tabindex="-1" role="dialog"  aria-hidden="true">
                                <div class="modal-dialog modal-sm" style="width: 400px;">
                                    <div class="modal-content" >
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                            <h4 class="modal-title">Attendance List</h4>
                                        </div>
                                        <div id='addendance_data_holder'class="modal-body no-padding bg-muted " style='max-height: 400px;overflow-y: scroll;'>
                                          
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-white" data-dismiss="modal">Close</button>
                                            
                                        </div>
                                    </div>
                                </div>
                            </div>
		<div class="modal inmodal" id="myModal2" tabindex="-1"
							role="dialog" aria-hidden="true">
							<%-- <input id="orgID" type="hidden" value="<%=colegeID %>" /> --%>
							<div class="modal-dialog">
								<div class="modal-content animated flipInY event-edit-modal">

								</div>
							</div>
						</div>
		
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<!-- Mainly scripts -->
</body>

<script>
$(document).ready(function(){
	
    
       
});


</script>

</html>