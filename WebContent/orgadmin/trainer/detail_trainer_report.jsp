<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="in.orgadmin.utils.OrgAdminRegistry"%>
<%@page import="java.net.URL"%>
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
<%@page import="java.text.SimpleDateFormat"%>
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
		String drange="";
		String start_date="";
		String end_date="";
		String trainer_id="";
		
		
		
		
			
			SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
			SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd");

			 
		
		
		if(request.getParameterMap().containsKey("daterange"))
		{
			System.out.println(request.getParameter("daterange"));
			drange = request.getParameter("daterange");
			start_date = drange.split("-")[0].trim();
			end_date = drange.split("-")[1].trim();
			 
			  start_date = formatter1.format(formatter.parse(start_date));
			  end_date = formatter1.format(formatter.parse(end_date));
			 
			 
			 System.out.println(start_date+"---------------------------------"+end_date);
		}
		
		if(request.getParameterMap().containsKey("trainer_id"))
		{
			trainer_id = request.getParameter("trainer_id");
			System.out.println(trainer_id);
		}
		

		DatatableUtils dtUtils = new DatatableUtils();
		HashMap<String, String> conditions = new HashMap<>();
%>
	
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css">
<link
	href="<%=baseURL%>css/plugins/dataTables/editor.dataTables.min.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link
	href="<%=baseURL%>css/plugins/daterangepicker/daterangepicker-bs3.css"
	rel="stylesheet">


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
					<h2>Detail Trainer Report</h2>
				</div>
			</div>
			<br>
			<div class="wrapper wrapper-content">
							
				
	            
				
						<div class="row">
						<div class="col-lg-12">
				        <div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Trainer Class Duration list</h5>
								<div class="ibox-tools">
						
									
									<a class="collapse-link">
										<i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" >
							<form action="<%=baseURL%>orgadmin/trainer/detail_trainer_report.jsp" method="get"
							class="form-horizontal">
							
							
							<h3>Date Range Picker</h3>


									<input class="form-control" type="text" name="daterange" id="daterange"
										value="07/01/2016 - 07/01/2016" />



									<h3>Selected Trainer</h3>
									
								
											<select class="form-control m-b" name="trainer_id" id='id__trainer_id'>
													
														
														<% 
														 
                                    DBUTILS util = new DBUTILS();
									String sql ="select id , email, name from student where user_type='TRAINER' order by email";
									List<HashMap<String, Object>> data = util.executeQuery(sql);
                                    if(data.size()>0)
                                    {	
                                    	for(HashMap<String, Object> row : data)
                                    	{
                                    		int id= (int)row.get("id");
                                    		String email= (String)row.get("email");
                                    		String name = (String)row.get("name");
                                    %>
														<option value="<%=id%>"><%=name %>, Email :<%=email %></option>
														<%
                                    	}
                                    }
														
                                    %>
													</select>

									<button class="btn btn-primary " type="submit" id="show_table"><i class="fa fa-check"></i>&nbsp;Generate Report</button>
									
									<%
									if(trainer_id.equalsIgnoreCase(""))
									{
									
											conditions.clear();
												
											%>

									<%
									}
									else
									{	
									//2016-10-01
									//2016-09-30
									
									System.out.println("--"+trainer_id);
										conditions.clear();
										conditions.put("start_date", start_date);
										conditions.put("end_date", end_date);
										conditions.put("trainer_id", trainer_id);
										%>
									<%=(new DatatableUtils()).getReport(219, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
										<% 		
									
									}
									%>
									
								 </from>	
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
	<!-- Date range use moment.js same as full calendar plugin -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>
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

	<!-- jQuery UI -->
	<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>

	<!-- Jvectormap -->
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

	<!-- Sparkline -->
	<script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>

	<!-- Sparkline demo data  -->
	<script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>

	<!-- Date range picker -->
	<script src="<%=baseURL%>js/plugins/daterangepicker/daterangepicker.js"></script>




	<!-- ChartJS-->
	<script src="<%=baseURL%>js/plugins/chartJs/Chart.min.js"></script>
	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<script src="<%=baseURL%>js/plugins/dataTables/datatables.min.js"></script>
	<script type="text/javascript" language="javascript"
		src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js"></script>
	
	
	<script>
	
		$(document).ready(function() {
			
             $('input[name="daterange"]').daterangepicker();
        	
      
        });
        
   
		
     	
     	
			
	</script>


</body>
</html>