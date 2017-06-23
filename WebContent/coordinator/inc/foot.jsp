<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
String basePath = "http://cdn.talentify.in/";

try{
	Properties properties = new Properties();
	String propertyFileName = "app.properties";
	InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
		if (inputStream != null) {
			properties.load(inputStream);
			basePath =  properties.getProperty("cdn_path");
			System.out.println("basePath"+basePath);
		}
	} catch (IOException e) {
		e.printStackTrace();
	}
	
%>
<script src="<%=basePath %>assets/js/plugins/fullcalendar/moment.min.js"></script>

<script src="<%=basePath %>assets/js/jquery-2.1.1.js"></script>



<script src="<%=basePath %>assets/js/bootstrap.min.js"></script>
<script src="<%=basePath %>assets/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script
	src="<%=basePath %>assets/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<!-- Custom and plugin javascript -->
<script src="<%=basePath %>assets/js/inspinia.js"></script>
<script src="<%=basePath %>assets/js/plugins/pace/pace.min.js"></script>
<script src="<%=basePath %>assets/js/plugins/dataTables/datatables.min.js"></script>
<script type="text/javascript" src="<%=basePath %>assets/js/jquery.bootpag.js"></script>
<script src="<%=basePath %>assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<!-- Clock picker -->
<script src="<%=basePath %>assets/js/plugins/clockpicker/clockpicker.js"></script>
<script src="<%=basePath %>assets/js/plugins/select2/select2.full.min.js"></script>
<%-- 
<!-- Flot -->
<script src="<%=basePath %>assets/js/plugins/flot/jquery.flot.js"></script>
<script src="<%=basePath %>assets/js/plugins/flot/jquery.flot.tooltip.min.js"></script>
<script src="<%=basePath %>assets/js/plugins/flot/jquery.flot.resize.js"></script>
<!-- dataTables -->
<!-- Data picker -->
<script	src="<%=basePath %>assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<!-- Clock picker -->
<script src="<%=basePath %>assets/js/plugins/clockpicker/clockpicker.js"></script>
<!-- Full Calendar -->
<script src="<%=basePath %>assets/js/plugins/fullcalendar/fullcalendar.min.js"></script>
<!-- Toastr script -->
<script src="<%=basePath %>assets/js/plugins/toastr/toastr.min.js"></script>
<script type="text/javascript" src="<%=basePath %>assets/js/wickedpicker.js"></script>
<!-- Jquery Validate -->
<script src="<%=basePath %>assets/js/plugins/validate/jquery.validate.min.js"></script>
<script	src="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.js" type="text/javascript"></script>
 <script type="text/javascript" src="<%=basePath %>assets/js/timepicki.js"></script>
 
   <!-- Tags Input -->
    <script src="<%=basePath %>assets/js/plugins/bootstrap-tagsinput/bootstrap-tagsinput.js"></script>

<!-- highcharts -->
<script src="<%=basePath %>assets/js/highcharts-custom.js"></script>


<script src="<%=basePath %>assets/js/plugins/chosen/chosen.jquery.js"></script>
<script src="<%=basePath %>assets/js/plugins/select2/select2.full.min.js"></script>


<!-- 	<script src="https://code.highcharts.com/modules/data.js"></script>
 -->
<script src="<%=basePath %>assets/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="<%=basePath %>assets/js/plugins/highchart/highcharts.js"></script>
<script src="<%=basePath %>assets/js/plugins/highchart/no-data-to-display.js"></script>
<script src="<%=basePath %>assets/js/plugins/highchart/data.js"></script>
<script src="<%=basePath %>assets/js/plugins/highchart/exporting.js"></script>
<script src="<%=basePath %>assets/js/plugins/highchart/drilldown.js"></script>
<script src="<%=basePath %>assets/js/reconnecting-websocket.min.js"></script>
<script src="<%=basePath %>assets/js/websocket.js"></script>
<script src="<%=basePath %>assets/js/plugins/steps/jquery.steps.min.js"></script>
 --%>
 <script src="<%=basePath%>assets/js/jquery.rateyo.min.js"></script>
 
 			<script src="https://unpkg.com/isotope-layout@3/dist/isotope.pkgd.js"></script>
 <script src="https://cdn.rawgit.com/nnattawat/flip/master/dist/jquery.flip.min.js"></script>
 
<script src="<%=basePath %>assets/js/app.js"></script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-101170072-1', 'auto');
  ga('send', 'pageview');

</script>