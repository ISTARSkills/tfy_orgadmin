<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.services.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
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

<title>Admin Portal | Trainer Logs</title>

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

		
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
						<%
	LogService service = new LogService();
	String event_id = request.getParameter("event_id");
	List<HashMap<String, Object>>  basic = service.getBasicDeatails(event_id);
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy hh:mm:ss zzz");
	Timestamp eventdate = null;
	Timestamp end_time = null;
if(basic.size() >0)
{
	String trainer_name =  (String) (basic.get(0).get("name"));
	String email =  (String) (basic.get(0).get("email"));
	String batch_name =  (String) (basic.get(0).get("batch_name"));
	int event_hour = (int)(basic.get(0).get("eventhour"));
	int event_min = (int)(basic.get(0).get("eventminute"));
	int dur = (event_hour*60)+event_min;
	
	 eventdate = (Timestamp) basic.get(0).get("eventdate");
	  end_time = new Timestamp(eventdate.getTime()+dur*1000);
	

%>	
		<h2>Batch Name : <%=batch_name %></h2>
		<h3>Trainer Name : <%=trainer_name %> <span class="label label-primary" style="float:right; font-size:14px;">Event Date: <%=dateFormat.format(eventdate) %></span></h3>
		
<%
}
else
{	
%>
		<h2 class="doc-title"> No action by Trainer</h2>

<%
}
%>

				</div>
			</div>
			<div class="row white-bg dashboard-header" style="padding: 0px">
				<div class="col-lg-12">
                    <div class="ibox ">
                        <div class="ibox-title">
                            <h5>Trainer Activity Logs</h5>
                        </div>
                        <div class="ibox-content">

	<%


List<HashMap<String, Object>> diff_id = service.getIDAndStatusDashboard(event_id);
int total = diff_id.size();

	 

List<HashMap<String, Object>> slide_details = service.getSlideIDDashboard(event_id);

if(slide_details.size() >0 )
{
	

	   int slide_id = (int ) slide_details.get(0).get("slide_id");
		Slide s = new SlideDAO().findById(slide_id);
%>
	  
      <%-- <%=s.output("ddd", "desktop") %>  --%>
      
            
<%
}
%>

                        </div>

                    </div>
                </div>

			</div>

		
	<!-- Mainly scripts -->

	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
		<!-- Nestable List -->
    <script src="<%=baseURL%>js/plugins/nestable/jquery.nestable.js"></script>
		
	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
 <script>
         $(document).ready(function(){
        	 setTimeout(function(){
         		 $('li > button').hide();
         	},2000);        	 
             var updateOutput = function (e) {
                 var list = e.length ? e : $(e.target),
                         output = list.data('output');
                 if (window.JSON) {
                     output.val(window.JSON.stringify(list.nestable('serialize')));//, null, 2));
                 } else {
                     output.val('JSON browser support required for this demo.');
                 }
             };
        
          /*    // activate Nestable for list 2
             $('#nestable2').nestable({
                 group: 1
             }).on('change', null); */

             // output initial serialised data
             updateOutput($('#nestable2').data('output', $('#nestable2-output')));

             $('#nestable-menu').on('click', function (e) {
                 var target = $(e.target),
                         action = target.data('action');
                 if (action === 'expand-all') {
                     $('.dd').nestable('expandAll');
                 }
                 if (action === 'collapse-all') {
                     $('.dd').nestable('collapseAll');
                 }
             });
         });
    </script>



</body>
</html>