<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<body class="top-navigation" id='super_admin_account_managment'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="wrapper wrapper-content" style=" padding: 4px!important;">
				<div class="row">
							<div class="col-xs-12">
								<div class="page-title-box">
                                    <h4 class="page-title">Account Management</h4>
                                    <ol class="breadcrumb p-0 m-0">
                                        <li>
                                            <a href="#">Dashboard</a>
                                        </li>
                                        <li>
                                            <a href="#">Account Management</a>
                                        </li>
                                      
                                    </ol>
                                    <div class="clearfix"></div>
                                </div>
							</div>
						</div>
						
						<div class="row">
					<!-- Start Table -->
					<!-- End Table -->
					<div class="col-lg-12">
						<jsp:include page="partials/alphabet_pagination.jsp"></jsp:include>
					</div>

				</div>
				<div class="row" id="account_mgmt_org_holder" style="padding-left: 15px; padding-right: 15px;">
					<jsp:include page="ajax_partials/college_cards.jsp" />
				</div>

				<div class="modal inmodal fade" id="account_managment_model"
					tabindex="-1" role="dialog" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal">
									<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
								</button>
								<h4 class="modal-title" id="modal-title">Modal title</h4>
							</div>
							<div class="modal-body">
								<iframe src="" class="embed-responsive-item iframe-container"
									id="account_managment_iframe"></iframe>
							</div>

							<div class="modal-footer">
								<button type="button" class="btn btn-primary"
									data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>
