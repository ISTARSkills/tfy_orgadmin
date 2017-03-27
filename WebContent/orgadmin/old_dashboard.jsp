<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="in.orgadmin.utils.OrgAdminRegistry"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.File"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="in.orgadmin.utils.report.ReportCollection"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="javax.xml.bind.JAXBException"%>
<%@page import="java.net.URISyntaxException"%>
<%@page import="in.orgadmin.utils.report.IStarColumn"%>
<%@page import="in.orgadmin.utils.report.Report"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="in.orgadmin.utils.OrganizationUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="in.orgadmin.utils.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user= (IstarUser)request.getSession().getAttribute("user");
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify Recruitor | Dashboard</title>

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
<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link
	href="<%=baseURL%>css/plugins/daterangepicker/daterangepicker-bs3.css"
	rel="stylesheet">


</head>

<body class="fixed-navigation">

	<%
		OrganizationUtils orgUtils = new OrganizationUtils();
		
		DatatableUtils dtUtils = new DatatableUtils();
		HashMap<String, String> conditions = new HashMap<>();
		String batchId = null;
		
        OrgadminUtil util = new OrgadminUtil();
        ArrayList<College> colleges= util.getOrgInFilter( user,  baseURL);
		
		
	%>
	<div id="wrapper">
		<jsp:include page="includes/sidebar.jsp"></jsp:include>


		<div id="page-wrapper" class="gray-bg 	">
			<div class="row border-bottom">
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>
			<div class="wrapper wrapper-content ">

				<div class="row">
					<div class="col-lg-6">
						<div class="ibox float-e-margins">
							<div class="ibox-title">

								<h5>Track Session</h5>
							</div>

						</div>
						<jsp:include page="dashboard_parts/trainer_eventlogs.jsp"></jsp:include>
					</div>


					<div class="col-lg-6">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<div class="col-md-6">
									<h5>Batch Report List</h5>
								</div>
								<div class="col-md-6" style="margin-top: -7px;">
									<select class="form-control m-b" id="org_filter3"
										name="select_drop" value="" Selected="selected">

										<option value="NONE" selected="selected">Select
											College</option>
										<%
										for(College c : colleges){
									
										%>
										<option value="<%=c.getId()%>"><%=c.getName()%></option>
										<%
											}
										%>
									</select>

								</div>
							</div>
							<jsp:include page="dashboard_parts/batch_student_reports.jsp"></jsp:include>

						</div>

					</div>


				</div>
				<div class="row">
					<div class="col-lg-6" style="margin-bottom: 10px;">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<div class="col-md-6">
									<h5>Event List</h5>
								</div>
								<div class="col-md-6" style="margin-top: -7px;">
									<select class="form-control m-b" id="org_filter2"
										name="select_drop" value="" Selected="selected">

										<option value="NONE" selected="selected">Select
											College</option>
										<%
										for(College c : colleges){
									
										%>
										<option value="<%=c.getId()%>"><%=c.getName()%></option>
										<%
											}
										%>
									</select>

								</div>

							</div>

							<jsp:include page="dashboard_parts/events.jsp"></jsp:include>


						</div>

					</div>
					<div class="col-lg-6">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<div class="col-md-6">
									<h5>Program Associated with all Organization</h5>
								</div>
								<div class="col-md-6" style="margin-top: -7px;">
									<select class="form-control m-b" id="org_filter1"
										name="select_drop" value="" Selected="selected">

										<option value="NONE" selected="selected">Select
											College</option>
										<%
										for(College c : colleges){
									
										%>
										<option value="<%=c.getId()%>"><%=c.getName()%></option>
										<%
											}
										%>
									</select>

								</div>
							</div>
							<jsp:include page="dashboard_parts/programs.jsp"></jsp:include>
						</div>
					</div>

				</div>
				<div class="row">
					<div id="fullCalModal" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal">
										<span aria-hidden="true">×</span> <span class="sr-only">close</span>
									</button>
									<h4 id="modalTitle" class="modal-title"></h4>
								</div>

								<div class="form-group">
									<label class="col-lg-3 control-label">Batch Name</label>
									<div class="col-lg-9">
										<p id="batchName" class="batchName"></p>
									</div>
								</div>
								<div class="form-group">
									<label class="col-lg-3 control-label">Org Name</label>
									<div class="col-lg-9">
										<p id="orgName" class="orgName">xyz</p>
									</div>
								</div>
								<div class="form-group">
									<label class="col-lg-3 control-label">Classroom</label>
									<div class="col-lg-9">
										<p id="class_room" class="class_room">xyz</p>
									</div>

								</div>
								<div class="form-group">
									<label class="col-lg-3 control-label">Duration</label>
									<div class="col-lg-9">
										<p id="duration" class="duration">xyz</p>
									</div>
								</div>

								<div class="form-group">
									<label class="col-lg-3 control-label">Trainer</label>
									<div class="col-lg-9">
										<p id="trainer" class="trainer">xyz</p>
									</div>
								</div>
								<div class="form-group">
									<label class="col-lg-3 control-label">Status</label>
									<div class="col-lg-9">
										<p id="status" class="status">xyz</p>
									</div>
								</div>

								<div class="modal-footer">
									<button class="btn btn-primary" type="submit"
										data-dismiss="modal">Close</button>


									<button class="btn btn-primary" type="submit">
										<a id="eventEdit" target="_new" style="color: white">Edit</a>
									</button>
									<button class="btn btn-primary" type="submit">
										<a id="eventDelete" target="_new" style="color: white">Delete</a>
									</button>
									<button class="btn btn-primary" type="submit">
										<a id="eventDetails" target="_new" style="color: white">Details</a>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--  Event list table -->
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Events associated with this organization</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-down"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" style="display: none;">
								<div id="calendar"></div>
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

	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>


	<!-- ChartJS-->
	<script src="<%=baseURL%>js/plugins/chartJs/Chart.min.js"></script>
	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<script src="<%=baseURL%>js/plugins/dataTables/datatables.min.js"></script>
	<script type="text/javascript" language="javascript"
		src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js"></script>


	<script>

        $(document).ready(function() {
        	
        	/*  $( "#org_filter1" ).change(function() {
       
        		  document.getElementById("test2").innerHTML = $('#org_filter1').val() ;
        		  
        		});
        	 */
       		//Event  List Code

       		
        	$( "#org_filter2" ).change(function() {
        		
          		var selectedorg =  $('#org_filter2').val() ;
        		var selectedtab = $('#event_data .active').text();
          		var dataString = 'selectedorg='+ selectedorg + '&selectedtab=' + selectedtab  ;
          		//alert(dataString);
         		 $.ajax({
                    url: '<%=baseURL%>dashboard_events_list',
                    data: dataString,
                    
                    success : function(data) {
                   	
                     if(data === "" ){
	                 //alert("empty")
                     }else{
                  		if(selectedtab === 'ALL'){                  		
                       $('#tab-3-group').html(data);}
                   	 else if(selectedtab === 'Today'){ 
                   	   $('#tab-4-group').html(data);}
                   	 else if(selectedtab === 'Current Week'){                  		
                              $('#tab-5-group').html(data);}
                   	 else if(selectedtab === 'Month'){                  		
                           $('#tab-6-group').html(data);}  }      			
                  		}
                    });

       	 
      		});
        	 
        	  $( "#event_data li" ).click(function() {
        		 
        		 var selectedorg =  $('#org_filter2').val() ;
         		 var selectedtab = $(this).text();
           		var dataString = 'selectedorg='+ selectedorg + '&selectedtab=' + selectedtab  ;
          		//alert(dataString);
          		 $.ajax({
                     url: '<%=baseURL%>dashboard_events_list',
                     data: dataString,
                     
                     success : function(data) {
                    	 
                    	 if(data === "" ){
                    			//alert("empty")
                    		}else{
                    	
                    	  if(selectedtab === 'ALL'){                  		
                             $('#tab-3-group').html(data);}
                    	 else if(selectedtab === 'Today'){                  		
                             $('#tab-4-group').html(data);}
                    	 else if(selectedtab === 'Current Week'){                  		
                             $('#tab-5-group').html(data);}
                    	 else if(selectedtab === 'Month'){                  		
                             $('#tab-6-group').html(data);}
                    		}
                    	 
                    		
         			}
                     });
          		
        		  
        		}); 
        	  $("#event_data li a")[1].click();
        		//End Event  List Code
      		
      		//Batch Report List Code
        	$( "#org_filter3" ).change(function() {
        	       
      		 //on selection of org
      		var selectedorg =  $('#org_filter3').val() ;
    		  
      		var dataString = 'selectedorg='+ selectedorg ;
      		//alert(dataString);
      		
      		//data sending to batch report list controler
       	 $.ajax({
                   url: '<%=baseURL%>batch_report_list',
                   data: dataString,
                   
                   success : function(data) {
                  	
                 
                  		$('#batch_filter1').html(data);
       			}
                   });
   		//data sending to student report list controler
       	 $.ajax({
       		 
             url: '<%=baseURL%>student_report_list',
             data: dataString,
             
             success : function(data) {
            	
           
            		$('#stud_filter1').html(data);
 			}
             });
      		   });
      		
     		 //on selection of student from the list
      		$( "#stud_filter1" ).change(function() {
     	       
         		 
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
       	 
      		   });
     		 
    		 //on selection of batch from the list
      		$( "#batch_filter1" ).change(function() {
      	       
        		 
        		//var actTab = $('#r_data .active').attr("value");
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
       	 
      		   });
       
        	   });
        	//end of batch report list code
        	
        var myVar = null;	
        
	function showSlide(event_id) {	
		//var oldtemp = "temp";
       // var newtemp = "temp";
		
		if(myVar != null){clearInterval(myVar);	}
		
		  
        			
	    myVar = setInterval(function(){ 
	    	$.ajax({
            url: '<%=baseURL%>get_lastest_slide_of_event',
            data: {
           	 event_id : event_id
            },
            
            success : function(data) {
            	
            	// oldtemp = $('#desktop > iframe ').attr('src');
            	//if(oldtemp != newtemp ){
            		
            		 $('#slide_out').html(data);
            		// newtemp = $('#desktop > iframe ').attr('src');
            //	}
 
           	
           	 
           	
          
			
            }
       }); }, 6000);

		
		}
        
	
    
        
    </script>

	<script>

/* initialize the external events
-----------------------------------------------------------------*/
$('#external-events div.external-event').each(function() {
	// store data so the calendar knows to render an event upon drop
	$(this).data('event', {
		title : $.trim($(this).text()), // use the element's text as the event title
		stick : true
	// maintain when user navigates (see docs on the renderEvent method)
	});
	// make the event draggable using jQuery UI
	$(this).draggable({
		zIndex : 1111999,
		revert : true, // will cause the event to go back to its
		revertDuration : 0
	//  original position after the drag
	});
});
/* initialize the calendar
-----------------------------------------------------------------*/
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
 $('#calendar').fullCalendar({
	header : {
		left : 'prev,next today',
		center : 'title',
		right : 'month,agendaWeek,agendaDay'
	},
	 eventClick:  function(event, jsEvent, view) {
           $('#modalTitle').html(event.title);				         
           $('#batchName').html(event.batch_name);
           $('#orgName').html(event.orgname);
           $('#class_room').html(event.classroom);
           $('#duration').html(event.duration); 
          // $('#eventTime').html(event.start);
           $('#trainer').html(event.trainer_name);
           $('#status').html(event.status);
           $('#eventDetails').attr('href',event.view_url);
           $('#eventDelete').attr('href',event.delete_url);
           $('#eventEdit').attr('href',event.edit_url);
           $('#fullCalModal').modal();
          
       },
	editable : true,
	droppable : true, // this allows things to be dropped onto the calendar
	drop : function() {
		// is the "remove after drop" checkbox checked?
		if ($('#drop-remove').is(':checked')) {
			// if so, remove the element from the "Draggable Events" list
			$(this).remove();
		}
	},
	events : [ 
<%List<HashMap<String, Object>> res = orgUtils.getEventAllOrganization();
			int count = 0;
			for (HashMap<String, Object> row : res) {
				String part1[] = (row.get("event_name")).toString().split("-");
				String status = (String) row.get("bse_status");
				int batch_id = (int) row.get("batch_id");
				String batch_name = (String) row.get("batch_name");
				int class_id = (int) row.get("class_id");
				String classroom_identifier = (String) row.get("classroom_identifier");
				classroom_identifier = classroom_identifier + "-" + class_id;
				int duration = (int) row.get("bse_eventhour") * 60 + (int) row.get("bse_eventmin");
				String tt = (String) row.get("batch_name") + ", Trainer: " + (String) row.get("trainer_name");
				long t = ((Timestamp) row.get("eventdate")).getTime();
				long m = duration * 60 * 1000;
				Timestamp end_time = new Timestamp(t + m);
				String desc = "";
				desc = desc + "Batch Name: " + batch_name + "<br/>Org Name: " + (String) row.get("org_name")
						+ "<br/>Classroom (ID): " + classroom_identifier + "(" + class_id + ").<br/>Duration: "
						+ duration + " mins.<br/> Event Time: " + t + "<br/>Trainer: "
						+ (String) row.get("trainer_name") + "<br/> Status: " + status;
				String col = "#A9CCE3";
				if (status.equalsIgnoreCase("SCHEDULED")) {
					col = "#A9CCE3";
				} else if (status.equalsIgnoreCase("TEACHING")) {
					col = "#58D68D";
				} else if (status.equalsIgnoreCase("ATTENDENCE")) {
					col = "#F7DC6F";
				} else if (status.equalsIgnoreCase("FEEDBACK")) {
					col = "#DC7633";
				} else if (status.equalsIgnoreCase("COMPLETED")) {
					col = "#626567";
				} else if (status.equalsIgnoreCase("STARTED")) {
					col = "#C0392B";
				} else if (status.equalsIgnoreCase("REACHED")) {
					col = "#FF00FF";
				}%>          					           
{		
start: '<%=(Timestamp) row.get("eventdate")%>',
end: '<%=end_time%>',
title:'<%=tt%>',
description: '<%=desc%>',
id: '<%=(String) row.get("id")%>',
batch_id:	<%=(Integer) row.get("batch_id")%>, 
color: '<%=col%>',
textColor: 'black',
class_id : '<%=class_id%>',
batch_name: '<%=batch_name%>',
classroom: '<%=classroom_identifier%>',
orgname:'<%=(String) row.get("org_name")%>',
status :'<%=status%>',
trainer_name:'<%=(String) row.get("trainer_name")%>',
duration :'<%=duration%>',
view_url:'<%=baseURL%>orgadmin/logs/trainer_logs.jsp?event_id=<%=(String) row.get("id")%>',
delete_url:'<%=baseURL%>delete_event?event_id=<%=(String) row.get("id")%>',
edit_url:'<%=baseURL%>orgadmin/events/create_events.jsp?event_id=<%=(String) row.get("id")%>&batch_id=<%=(Integer) row.get("batch_id")%>'
},
<%}%>], 
eventRender: function(event, element) {
//var icon  = 'The icon you want, HTML is possile';
// element.find('.fc-content').data("event_id", event.id );
//element.attr("categories",event.categoryname)
element.find('.fc-title').append("");  
element.attr("event_id",event.id);
element.attr("batch_id",event.batch_id)
}
}); 

</script>


</body>
</html>
