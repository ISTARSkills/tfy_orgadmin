<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.services.*"%>
<%@page import="java.util.*"%>
<%@page import="	java.text.SimpleDateFormat"%>
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

	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
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
                        <div class="dd " id="nestable2" >
<ol class="dd-list">
	<%


List<HashMap<String, Object>> diff_id = service.getIDAndStatus(event_id);
int total = diff_id.size();

for(int i =0; i< total; i++)
{
	String status = (String) (diff_id.get(i).get("event_status"));
	Timestamp created_at = (Timestamp)(diff_id.get(i).get("created_at")) ;
	String color="palegoldenrod";
	if(created_at.after(eventdate) )
	{
		color="palegreen";
	}
	int next_id =1;
	long diff_between_state_change =0;
	int start_id = (int) (diff_id.get(i).get("id"));
	Calendar cal = Calendar.getInstance();
	if(i+1<total && i!=0)
	{
		next_id =  (int) (diff_id.get(i+1).get("id"));
		Timestamp prev_time = (Timestamp)(diff_id.get(i-1).get("created_at"));
		diff_between_state_change = created_at.getTime()-prev_time.getTime();
		System.out.println("mins"+diff_between_state_change);
		cal.setTimeInMillis(diff_between_state_change);
	}
	long diffSeconds = diff_between_state_change / 1000 % 60;
	long diffMinutes = diff_between_state_change / (60 * 1000) % 60;
	long diffHours = diff_between_state_change / (60 * 60 * 1000);
	int diffInDays = (int) diff_between_state_change / (1000 * 60 * 60 * 24);
%>    
<li class="dd-item " data-id="<%=i %>">
        <div class="dd-handle" style="background-color:<%=color%>">
        <span class="label label-info" ></span> <%=status %> 
        <span class="label label-primary" style="float:right; font-size:12px;">Time Taken: <%=diffHours %> hrs,<%=diffMinutes %> mins</span>
        <span class="label label-warning" style="float:right; font-size:12px;">Action Time: <%=dateFormat.format(created_at) %></span>
        </div>
		 <ol class="dd-list">
<%
List<HashMap<String, Object>> slide_details = service.getDetails(start_id, next_id,  event_id);
int slide_total = 0;
if(slide_details!= null )
{
	slide_total = slide_details.size();
for(int j=0; j < slide_total ;j++)
{
	String slide_title = (String) slide_details.get(j).get("slide_title");
	String course_name = (String ) slide_details.get(j).get("course_name");
	String session_title = (String ) slide_details.get(j).get("session_title");
	String lesson_title = (String ) slide_details.get(j).get("lesson_title");
	int ppt_id = (int ) slide_details.get(j).get("ppt_id");
	int slide_id = (int ) slide_details.get(j).get("slide_id");
	String module_name = (String ) slide_details.get(j).get("module_name");
	String 	url1 = (String ) slide_details.get(j).get("url");
	Timestamp created_at1 = (Timestamp) slide_details.get(j).get("created_at");
	
	
	int next_slide_id=1;
	long diff_between_slide_change =0;
	
	Calendar cal1 = Calendar.getInstance();
	
	if(j+1<slide_total && j!=0)
	{
		Timestamp prev_slide_time = (Timestamp)(slide_details.get(j-1).get("created_at"));
		diff_between_slide_change = created_at1.getTime() - prev_slide_time.getTime();
		
		cal1.setTimeInMillis(diff_between_slide_change);
	}
	long diffSeconds1 = diff_between_slide_change / 1000 % 60;
	long diffMinutes1 = diff_between_slide_change / (60 * 1000) % 60;
	long diffHours1 = diff_between_slide_change / (60 * 60 * 1000);
	int diffInDays1 = (int) diff_between_slide_change / (1000 * 60 * 60 * 24);
	
%>
	 <li class="dd-item" data-id="<%=i+j+1%>">
                <div class="dd-handle">
                    <span class="pull-right"> Time Taken: <%=diffMinutes1 %>min <%=diffSeconds1 %>secs </span>
                    <span class="label label-info"></i></span> <h4 class="">Slide Title : <%=slide_title %></h4>
   			 <p class="">Course : <%=course_name %>, Module Name: <%=module_name %>, Session Name: <%=session_title %>, Slide Id : <%=slide_id %>, PPT Id :<%=ppt_id %> </p>
 	
                </div>
            </li>
<%
}//for loop ends here
	}
%>
 </ol>
    </li>  
    <%
}
 %>  
                     
</ol>
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