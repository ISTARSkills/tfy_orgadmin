<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="in.orgadmin.utils.*"%>
<%@page import="java.net.URL"%>
<%@page import="java.text.*"%>
<%@page import="java.io.File"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="in.orgadmin.utils.report.ReportCollection"%>
<%@page import="javax.xml.bind.JAXBException"%>
<%@page import="java.net.URISyntaxException"%>
<%@page import="in.orgadmin.utils.report.IStarColumn"%>
<%@page import="in.orgadmin.utils.report.Report"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="in.orgadmin.utils.OrganizationUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>

<html>
<head>

<%
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>
<%
	String event = "";
	int batch_id=0;
	String assess_event_id = "";
	DBUTILS util = new DBUTILS();
	if(request.getParameterMap().containsKey("batch_id"))
	{
		batch_id = Integer.parseInt( request.getParameter("batch_id"));
	}
	IstarEventDAO dao = new IstarEventDAO();
	
	IstarEvent ae = new IstarEvent();
	if(request.getParameterMap().containsKey("parent_event_id")) {
		String parent_event_id=request.getParameter("parent_event_id");  
		String sql = " select batch_id, cast(id as varchar(50)) from istar_assessment_event where parent_id='"+parent_event_id+"' limit 1";
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		if(res.size()>0)
		{
			batch_id = (int)res.get(0).get("batch_id");
			assess_event_id = (String)res.get(0).get("id");
		}
	
		ae = dao.findById(UUID.fromString(assess_event_id));
	}
	
	
	
	Batch b = new BatchDAO().findById(batch_id);	
	OrgadminUtil orgutil = new OrgadminUtil();
	ArrayList<HashMap<String, String>>  assess_details = orgutil.getAllTrainerAssessmentListForBatch();

%>

	
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />

<title>Admin Portal | Create Assessment Events</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">


<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>
<!-- DataTable -->
<link href="<%=baseURL%>css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css">
<link
	href="<%=baseURL%>css/plugins/dataTables/editor.dataTables.min.css"
	rel="stylesheet">
 <link href="<%=baseURL%>css/plugins/datapicker/datepicker3.css" rel="stylesheet">
   <link href="<%=baseURL%>css/plugins/clockpicker/clockpicker.css" rel="stylesheet">


<link href="<%=baseURL%>css/mdb.min.css" rel="stylesheet">


<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/dropzone/dropzone.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.1/css/bootstrap-datepicker.css">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.1/css/bootstrap-datepicker.css.map">
  <link href="<%=baseURL%>css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">

<style type="text/css">

</style>
</head>

<body class="fixed-navigation  pace-done">
	
	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg ">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>Create / Edit Events</h2>				
				</div>
			</div>
			<br>
			<div class="wrapper wrapper-content">
			<div class="row">
					<div class="col-lg-12">
				        <div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Create Assessment Event</h5>
								<div class="ibox-tools">
									<a class="collapse-link">
										<i class="fa fa-chevron-down"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" >		
							<form class="form-horizontal" role="form" action="/create_edit_assessment_event" id="event_submit_form" method="GET">
							<input type="hidden" name="batch_id" value="<%=request.getParameter("batch_id")%>">		
							<%
							 if(assess_details.size()>0)
							 {
								 for(HashMap<String, String> row : assess_details)
                             	{
                             		String id= row.get("assess_id");
                             		String title= row.get("title");
								 %>
								  <div class="row">
								  <div class="col-sm-6 ">
                                    <div>
                                        <label> <input type="checkbox" class="i-checks" value="<%=id%>" name="assessment_id"> <%=title %> </label>
                                    </div>
                           		 </div>
                            <div class=" col-sm-3 form-group" id="data_1">
                                <div class="input-group date">
                                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input id ="id_date_<%=id %>" name="date_<%=id %>" type="text" class="form-control" >
                                </div>
                            </div>
                            <div class="col-sm-3 input-group clockpicker" data-autoclose="true">
                                <input type="text" class="form-control" id ="id_time_<%=id %>" name="time_<%=id %>" >
                                <span class="input-group-addon">
                                    <span class="fa fa-clock-o"></span>
                                </span>
                            </div>
                            

                             </div>
								 <% 
                             	}
							 }
							 else
							 {
								 
							 }	 
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

	<!-- Mainly scripts -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=baseURL%>js/jquery.contextMenu.js"
		type="text/javascript"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="<%=baseURL%>js/plugins/dataTables/datatables.min.js"></script>
	<script type="text/javascript" language="javascript"
		src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js">
	</script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.1/js/bootstrap-datepicker.js"></script>
	
	<script type="text/javascript"
		src="<%=baseURL%>js/plugins/dataTables/dataTables.editor.min.js"></script>
		<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>
	<script src="<%=baseURL%>js/mdb.min.js"></script>

	<!-- DROPZONE -->
	<script src="<%=baseURL%>js/plugins/dropzone/dropzone.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>
 <!-- Data picker -->
   <script src="<%=baseURL%>js/plugins/datapicker/bootstrap-datepicker.js"></script>


   <!-- Clock picker -->
    <script src="<%=baseURL%>js/plugins/clockpicker/clockpicker.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>
				<script type="text/javascript">
		
		$(document).ready(
				
				function() {
					
					 $('#data_1 .input-group.date').datepicker({
			                todayBtn: "linked",
			                keyboardNavigation: false,
			                forceParse: false,
			                calendarWeeks: true,
			                autoclose: true
			            });

					 $('.clockpicker').clockpicker();

					
					 $('.i-checks').iCheck({
		                    checkboxClass: 'icheckbox_square-green',
		                    radioClass: 'iradio_square-green',
		                });

					
				      //$('#id__event_date_holder').val( $('#id__event_date').datepicker('getFormattedDate'));
					 

					 /*  var datepicker11 = $('#id__event_date').datepicker({
							  multidate: true, 
							  format: 'yyyy-mm-dd', 
							  todayHighlight: true
					   }).on('changeDate', function(e) {
					       console.log( $('#id__event_date').datepicker('getFormattedDate'));
					       $('#id__event_date_holder').val( $('#id__event_date').datepicker('getFormattedDate'));
					    });
					    
					  console.log(datepicker11);
					  $('#id__event_time').pickatime({
						    twelvehour: false
						}); */
					  
					 
					
					

				});
		
		
		
		
	</script>
	


</body>
</html>