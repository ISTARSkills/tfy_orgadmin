<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="in.orgadmin.utils.BatchUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
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
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Portal | Add/Edit ClassRoomDetails</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
<!-- DataTable -->

<link
	href="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/buttons/1.2.2/css/buttons.dataTables.min.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>css/jquery.contextMenu.css" rel="stylesheet"
	type="text/css" />
	
    <link href="<%=baseURL%>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
	


</head>

<body class="fixed-sidebar no-skin-config full-height-layout">
	<%
	
	ClassroomDetails cd = new ClassroomDetails();
	cd.setClassroomIdentifier("");
	cd.setIpAddress("");
	cd.setMaxStudents(0);
	
	

		if (request.getParameterMap().containsKey("classroom_identifier")) {
			int classroom_identifier = Integer.parseInt(request.getParameter("classroom_identifier"));
			 cd = new ClassroomDetailsDAO().findById(classroom_identifier);

		}

		
		
	%>
	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			<div class="row wrapper border-bottom white-bg page-heading">
			
			<%
			String clsroom = "";
			String orgname ="";
			if (request.getParameterMap().containsKey("classroom_identifier")) {
				
				clsroom = cd.getClassroomIdentifier();
				orgname =cd.getCollege().getName();
			}else if(request.getParameterMap().containsKey("org_id")){
				int org_id = Integer.parseInt(request.getParameter("org_id"));
				Organization o = new OrganizationDAO().findById(org_id);
				orgname = o.getName();
				clsroom ="Create New ";
			}
			
			%>
			
				<div class="col-lg-10">

					<h2 > Class Room Details</h2>
					
					
					<p> <%= clsroom %> Class Room Detail</p>
					
					<p> <%= orgname %> Class Room Detail</p>


				

				</div>
			</div>
			<div class="row white-bg dashboard-header" style="padding: 0px">
				<div class="ibox float-e-margins">
					<div class="ibox-content">

						<form action="<%=baseURL%>update_classRoom_detail" method="get" id="myForm" class="form-horizontal">

						

							<div class="form-group">
								<label class="col-sm-2 control-label">Class Room Name</label>

								<div class="col-sm-10">



									<input type="text" id="class_name" name="class_name" class="form-control" 
										data-validation="required" value="<%=cd.getClassroomIdentifier()%>">


								</div>
							</div>

							<div class="form-group">
								<label class="col-sm-2 control-label">Max Number Of
									Student</label>

								<div class="col-sm-10">

									<input type="number" id="max_student" name="max_student" class="form-control"
										data-validation="required" value="<%=cd.getMaxStudents()%>" >


								</div>
							</div>


							<div class="form-group">
								<label class="col-sm-2 control-label">IP Address</label>

								<div class="col-sm-10">
                                  <input type="text" id="ip_address" data-validation="required" name="ip_address" class="form-control" data-mask="999.999.999.999" placeholder="" value="<%=cd.getIpAddress()%>">
                                        <span class="help-block">192.168.100.200</span>

								</div>
							</div>
							
							
							<%if(request.getParameterMap().containsKey("org_id")){ 
							int org_id = Integer.parseInt(request.getParameter("org_id"));
							Organization o = new OrganizationDAO().findById(org_id);%>
									
									<input type="hidden" name="org_id" value="<%=o.getId()%>">
									
									<%} else { %>
									<input type="hidden" name="classroom_identifier" value="<%=cd.getId()%>">
									<%} %>
									
							<button class="btn btn-primary" id="send_data" type="submit">Save changes</button>
					</div>
				</div>

				</form>
			</div>
		</div>

	</div>

	</div>
	</div>
	<!-- Mainly scripts -->


	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=baseURL%>js/jquery.contextMenu.js"
		type="text/javascript"></script>
	
	<script
		src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>

	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<script src="<%=baseURL%>js/plugins/jeditable/jquery.jeditable.js"></script>



	<script
		src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>


	<script
		src="https://cdn.datatables.net/buttons/1.2.2/js/dataTables.buttons.min.js"></script>
	<script
		src="//cdn.datatables.net/buttons/1.2.2/js/buttons.flash.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script>
	<script
		src="//cdn.rawgit.com/bpampuch/pdfmake/0.1.18/build/pdfmake.min.js"></script>
	<script
		src="//cdn.rawgit.com/bpampuch/pdfmake/0.1.18/build/vfs_fonts.js"></script>
	<script
		src="//cdn.datatables.net/buttons/1.2.2/js/buttons.html5.min.js"></script>
	<script
		src="//cdn.datatables.net/buttons/1.2.2/js/buttons.print.min.js"></script>

	<script src="<%=baseURL%>js/highcharts-custom.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>


	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>
	
	 <!-- Input Mask-->
    <script src="<%=baseURL%>js/plugins/jasny/jasny-bootstrap.min.js"></script>
    <script
		src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>

	
	
	<script>
	
	 
        
		 $(document).ready(function() {
	            
			 $.validate();
			 
						});
	</script>



</body>
</html>