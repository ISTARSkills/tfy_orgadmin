<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>WebSocket Client</title>
 <script type="text/javascript">
 var webSocket='';
/*  try{     
 var wsocket;      
      function connect() {         
 wsocket = new WebSocket("ws://localhost:4567/chat/vaibhav@istarindia.com");       
          wsocket.onmessage = onMessage;          
      }
      function onMessage(evt) {             
         alert(evt.data);        
      }
 }
 catch (err)
 {
	 console.log(err);
 } */
 function connect() {
		try {
			
			//variables defined in foot.jsp
			var userEmail = 'vaibhav@istarindia.com';
			//console.log('>>>>>>>' + userEmail);
			if (userEmail != undefined && userEmail != null) {
				var host_name = location.hostname;
				console.log("ws://" + host_name + ":" + "4567" + "/chat/" + userEmail);
				webSocket = new ReconnectingWebSocket("ws://localhost:4567/chat/vaibhav@istarindia.com");
			}

		} catch (err) {
			console.log(err);
		}
		return webSocket;
	}
	
	if (webSocket == null) {
		connect();
	}
	
	try{
	webSocket.onmessage = function(msg) {
			console.log('in on message ' + msg);
			updateChat(msg);

		};

	webSocket.onclose = function() {
			console.log("WebSocket connection closed");

		};	
		
	}catch(err)
	{
		console.log(err);
	}
	
 
 
 window.addEventListener("load", connect, false);
  </script>
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

<script src="<%=basePath %>js/plugins/highchart/highcharts.js"></script>
<script src="<%=basePath %>js/plugins/highchart/no-data-to-display.js"></script>
<script src="<%=basePath %>js/plugins/highchart/data.js"></script>
<script src="<%=basePath %>js/plugins/highchart/exporting.js"></script>
<script src="<%=basePath %>js/reconnecting-websocket.min.js"></script>
<script src="<%=basePath %>js/websocket.js"></script>

</head>
<body>
<table>
<tr>
<td> <label id="rateLbl">Current Rate:</label></td>
<td> <label id="rate">0</label></td>
</tr>
</table>
</body>
</html>