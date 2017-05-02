<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	
%>
<script
	src='//cdnjs.cloudflare.com/ajax/libs/moment.js/2.9.0/moment.min.js'></script>

<script src="<%=basePath %>js/jquery-2.1.1.js"></script>


<script src="<%=basePath %>js/plugins/fullcalendar/moment.min.js"></script>

<script src="<%=basePath %>js/bootstrap.min.js"></script>
<script src="<%=basePath %>js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script
	src="<%=basePath %>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<!-- Custom and plugin javascript -->
<script src="<%=basePath %>js/inspinia.js"></script>
<script src="<%=basePath %>js/plugins/pace/pace.min.js"></script>

<!-- Flot -->
<script src="<%=basePath %>js/plugins/flot/jquery.flot.js"></script>
<script src="<%=basePath %>js/plugins/flot/jquery.flot.tooltip.min.js"></script>
<script src="<%=basePath %>js/plugins/flot/jquery.flot.resize.js"></script>
<!-- dataTables -->
<script src="<%=basePath %>js/plugins/dataTables/datatables.min.js"></script>
<script type="text/javascript" src="<%=basePath %>js/jquery.bootpag.js"></script>


<!-- Data picker -->
<script
	src="<%=basePath %>js/plugins/datapicker/bootstrap-datepicker.js"></script>

<!-- Clock picker -->
<script src="<%=basePath %>js/plugins/clockpicker/clockpicker.js"></script>

<!-- Full Calendar -->
<script src="<%=basePath %>js/plugins/fullcalendar/fullcalendar.min.js"></script>
<!-- Toastr script -->
<script src="<%=basePath %>js/plugins/toastr/toastr.min.js"></script>


<!-- Jquery Validate -->
<script src="<%=basePath %>js/plugins/validate/jquery.validate.min.js"></script>
<script
	src="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.js"
	type="text/javascript"></script>


<!-- highcharts -->
<%-- <script src="<%=basePath %>js/highcharts-custom.js"></script>
 --%>

<script src="<%=basePath %>js/plugins/chosen/chosen.jquery.js"></script>
<script src="<%=basePath %>js/plugins/select2/select2.full.min.js"></script>

<script src="<%=basePath%>js/jquery.rateyo.min.js"></script>

<!-- 	<script src="https://code.highcharts.com/modules/data.js"></script>
 -->
<script src="<%=basePath %>js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="<%=basePath %>js/plugins/highchart/highcharts.js"></script>
<script src="<%=basePath %>js/plugins/highchart/no-data-to-display.js"></script>
<script src="<%=basePath %>js/plugins/highchart/data.js"></script>
<script src="<%=basePath %>js/plugins/highchart/exporting.js"></script>
<script src="<%=basePath %>js/reconnecting-websocket.min.js"></script>
<script src="<%=basePath %>js/websocket.js"></script>
<script src="<%=basePath %>js/app.js"></script>
