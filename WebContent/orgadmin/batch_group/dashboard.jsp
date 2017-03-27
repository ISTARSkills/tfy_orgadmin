<%@page import="in.orgadmin.utils.BatchGroupUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	DatatableUtils dtUtils = new DatatableUtils();
	HashMap<String, String> conditions = new HashMap<>();
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Portal | Batch Dashboard</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">



<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">

</head>

<body class="fixed-sidebar no-skin-config full-height-layout">
	<%
		int batch_group_id = Integer.parseInt(request.getParameter("batch_group_id"));
		BatchGroup b = new BatchGroupDAO().findById(batch_group_id);
		BatchGroupUtils util = new BatchGroupUtils();
	%>
	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2><%=b.getName().toUpperCase()%></h2>
					<p><%=b.getCollege().getName().toUpperCase()%></p>

				</div>
			</div>
			<div class="row white-bg dashboard-header" style="padding: 0px">

				<div class="col-sm-12">
					<div class="white-bg border-left">

						<div class="element-detail-box">

							<div class="tab-content">


								<div id="tab-1" class="tab-pane active">

									<div class="wrapper wrapper-content animated fadeInUp">

										<div class="ibox">
											<div class="ibox-title">
												<h5>Batches associated with this Program</h5>
												<div class="ibox-tools">
													<a
														href="<%=baseURL%>orgadmin/batch/edit_batch.jsp?batch_group_id=<%=batch_group_id%>"
														class="btn btn-primary btn-xs right">Create New Batch</a>
													&nbsp; &nbsp; <a class="collapse-link "> <i
														class="fa fa-chevron-up"></i>
													</a> <a class="close-link"> <i class="fa fa-times"></i>
													</a>
												</div>

											</div>
											<div class="ibox-content" style="display: none">

												<div class="project-list">
													<table class="table table-hover">
														<tbody>
															<%
																out.println(util.PrintBatchList(b, baseURL).toString());
															%>
														</tbody>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div id="tab-2" class="tab-pane active">

									<div class="wrapper wrapper-content animated fadeInUp">

										<div class="ibox">
											<div class="ibox-title">
												<h5>Assessment Report associated with this Batches</h5>
												<div class="ibox-tools">
													<a class="collapse-link "> <i class="fa fa-chevron-up"></i>
													</a> <a class="close-link"> <i class="fa fa-times"></i>
													</a>
												</div>

											</div>
											<div class="ibox-content" style="display: none">

												<div class="project-list">
													<table class="table table-hover">
														<tbody>
															<%
																conditions.clear();
																conditions.put("batch_group_id", batch_group_id + "");
															%>
															<%=dtUtils.getReport(207, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
														</tbody>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div id="tab-3" class="tab-pane active">

									<div
										class="wrapper wrapper-content animated fadeInUp ecommerce">
										<div class="ibox">
											<div class="ibox-title">
												<h5>Students associated in the program</h5>
												<div class="ibox-tools">
													<a class="collapse-link"> <i class="fa fa-chevron-down"></i>
													</a> <a class="close-link"> <i class="fa fa-times"></i>
													</a>
												</div>
											</div>
											<div class="ibox-content" style="display: none">
												<form action="/update_bg_student" method="get"
													class="form-horizontal">
													<input type="hidden" name="batch_group_id"
														value="<%=batch_group_id%>">
													<button class="btn btn-primary" type="submit">Save changes</button>
													<label style=" float: right;"> <input type="checkbox" class="i-checks" id="checkAll"> Select/Unselect All</label>
													
													<%
														out.println(util.getStudentsInBatchGroup(b));
													%>

													<button class="btn btn-primary" type="submit">Save changes</button>
												</form>
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
	</div>
	<!-- Mainly scripts -->

	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

	<script>
	
	
		$(document).ready(function() {

			//$('.fa-chevron-up').click();
			//$('.i-checks').iCheck({
			//	checkboxClass : 'icheckbox_square-green',
			//radioClass: 'iradio_square-green',
			//});
			//$('#checkAll').on('ifChecked', function() {
			//	$('input').iCheck('check');
			//});
			//$('#checkAll').on('ifUnchecked', function() {
				//$('input').iCheck('uncheck');
			//});
			
			 $('#checkAll').change(function() {
			        if($(this).is(":checked")) {
			            //var returnVal = confirm("Are you sure?");
			            //$('.i-checks1').attr("checked", $(this).val());
			            $('.i-checks1').prop('checked', true);

			        } else {
			        	 $('.i-checks1').prop('checked', false);
			        }
			        
			    });
			
			
			
		});
	</script>


</body>
</html>