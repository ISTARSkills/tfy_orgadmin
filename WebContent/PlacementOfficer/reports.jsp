<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	PlacementOfficer recruiter = (PlacementOfficer) request.getSession().getAttribute("user");
	
	RecruiterServices recServices = new RecruiterServices();
%>
<meta charset="utf-8">
<meta name="vi  ewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify TPO | Dashboard <%=recruiter.getName()%></title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.css"	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/toastr/toastr.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
</head>

<body class="fixed-navigation">
	<div id="wrapper">
		<jsp:include page="includes/sidebar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row">
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>
				
			<div class="wrapper" style="overflow:hidden;">
				
				<div class="row">
					<div class="col-lg-12">
	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<h5>Reports</h5>
		</div>
		<div class="ibox-content">
			<div class="tabs-container" style="background: #23c6c8" id="dashboard2">
				<ul class="nav nav-tabs" id="r_data">
					<li value="program" class="active"><a data-toggle="tab" href="#tab-2" onclick="getBatchGroups()">Report of Programs</a></li>
					<li value="student" class=""><a data-toggle="tab" href="#tab-1" onclick="getStudent()">Student Report</a></li>
				</ul>
				<div class="tab-content">
					
				
			<div id="tab-2" class="tab-pane active">
				<select class="form-control m-b  pull-right" onchange='getBatchGroups()' id="batch_filter1" name="select_drop" value="" Selected="selected" style="    width: 140px;">
					<option value="NONE" selected="selected">Select Programs</option>
				</select>
				<div id="Bgraph">
					<div class="well">
						<h1 class="text-center">NO DATA</h1>
					</div>
				</div>
			</div>
			<div id="tab-1" class="tab-pane ">
						<select class="form-control m-b pull-right" onchange='getStudent()' id="stud_filter1" name="select_drop" value="" Selected="selected" style="    width: 140px;">
							<option value="NONE" selected="selected">Select Student</option>
						</select>
						<div id="Sgraph" >
							<div class="well">
								<h1 class="text-center">NO DATA</h1>
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
		</div>

		<!-- Mainly scripts -->
		<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
		
				<!-- jQuery UI -->
		<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>
		
		<script src="<%=baseURL%>js/bootstrap.min.js"></script>
		<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
		<script	src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

		<!-- Flot -->
		<script src="<%=baseURL%>js/plugins/flot/jquery.flot.js"></script>
		<script src="<%=baseURL%>js/plugins/flot/jquery.flot.tooltip.min.js"></script>
		<script src="<%=baseURL%>js/plugins/flot/jquery.flot.spline.js"></script>
		<script src="<%=baseURL%>js/plugins/flot/jquery.flot.resize.js"></script>
		<script src="<%=baseURL%>js/plugins/flot/jquery.flot.pie.js"></script>
		<script src="<%=baseURL%>js/plugins/flot/jquery.flot.symbol.js"></script>
		<script src="<%=baseURL%>js/plugins/flot/curvedLines.js"></script>

		<!-- Peity -->
		<script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
		<script src="<%=baseURL%>js/demo/peity-demo.js"></script>

		<!-- Custom and plugin javascript -->
		<script src="<%=baseURL%>js/inspinia.js"></script>
		<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>



		<!-- Jvectormap -->
		<script
			src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
		<script
			src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

		<!-- Sparkline -->
		<script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>

		<!-- Sparkline demo data  -->
		<script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>
		<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>
		<!-- ChartJS-->
		<script src="<%=baseURL%>js/plugins/chartJs/Chart.min.js"></script>

		<!-- MENU -->
		<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
		<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>
		<script	src="<%=baseURL%>js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>
				

		<!-- Data picker -->
	<script src="<%=baseURL%>js/plugins/datapicker/bootstrap-datepicker.js"></script>

	<!-- Clock picker -->
	<script src="<%=baseURL%>js/plugins/clockpicker/clockpicker.js"></script>
	
		<!-- Tags Input -->
	<script
		src="<%=baseURL%>js/plugins/bootstrap-tagsinput/bootstrap-tagsinput.js"></script>
    <!-- Toastr script -->
    <script src="<%=baseURL%>js/plugins/toastr/toastr.min.js"></script>

    <!-- Jasny -->
    <script src="<%=baseURL%>js/plugins/jasny/jasny-bootstrap.min.js"></script>
    <script src="<%=baseURL%>js/highcharts-custom.js"></script>

	<script>
	
	$(document).ready(function() {
		
		getReportsData(<%=recruiter.getCollege().getId().toString()%>);
		
    	try {
    		$('#stud_filter1').select2();
    	} catch (err) {
		}
    	
    	try {
    		$('#batch_filter1').select2();
    	} catch (err) {
		}
		
    	
		
	});
	
	//data sending to student report list controler
	function getStudent(){
	       
		 
		  var selectedstud =  $('#stud_filter1').val();
		  
		var dataString = 'selectedstud='+ selectedstud ;
		//alert(dataString);
 	 $.ajax({
             url: '<%=baseURL%>student_report_list',
             data: dataString,
             
             success : function(data) {
          	   
           
            		$('#Sgraph').html(data);

            		handleGraphs();
 			}
             });
 	 
		   }
	
	function getBatchGroups() {
	      
		var selectedbatch =  $('#batch_filter1').val();
	  
		var dataString = 'selectedbatch='+ selectedbatch ;
		//alert(dataString);
	 $.ajax({
           url: '<%=baseURL%>batch_report_list',
           data: dataString,
           
           success : function(data) {
        	   
         
          		$('#Bgraph').html(data);

          		handleGraphs();
			}
           });
	 
		   }
	
	
	function getReportsData(ids) {
		//data sending to batch report list controler
		var datastring = 'ids='+ ids;
      	 $.ajax({
                  url: '<%=baseURL%>batch_report_list',
                  data: datastring,
                  
                  success : function(data) {
                 	
                
                 		$('#batch_filter1').html(data);
                 		
                 		getBatchGroups();
      			}
                  });
  		//data sending to student report list controler
      	var datastring = 'ids='+ ids;
      	 $.ajax({
                  url: '<%=baseURL%>student_report_list',
                  data: datastring,
                  
                  success : function(data) {
                 	
                
                 		$('#stud_filter1').html(data);
                 		
                		 getStudent();

      			}
                  });	
	}
	</script>
	
</body>
</html>

