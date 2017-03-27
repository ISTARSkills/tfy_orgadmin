<%@page import="in.orgadmin.utils.bulkupload.BulkUploadUtils"%>
<%@page import="in.orgadmin.orgadmin.controller.UserBulkUpload"%>
<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="com.istarindia.apps.dao.IstarUser"%>
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
<%@page import="java.sql.Timestamp"%>
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
%>

<%
    IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	BulkUploadUtils bulkUploadUtils = new BulkUploadUtils();
	DatatableUtils dtUtils = new DatatableUtils();
	OrganizationUtils orgUtils = new OrganizationUtils();
	HashMap<String, String> conditions = new HashMap<>();
	OrganizationUtils orgutils = new OrganizationUtils();
	int org_id = Integer.parseInt(request.getParameter("org_id"));
	Organization organization = new OrganizationDAO().findById(org_id);
	String tempStr = "";
%>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />

<title>Admin Portal | Organization Dashboard</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">


<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>
<!-- DataTable -->
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/bs-3.3.6/jszip-2.5.0/pdfmake-0.1.18/dt-1.10.12/af-2.1.2/b-1.2.2/b-colvis-1.2.2/b-flash-1.2.2/b-html5-1.2.2/b-print-1.2.2/cr-1.3.2/fc-3.2.2/fh-3.1.2/kt-2.1.3/r-2.1.0/rr-1.1.2/sc-1.4.2/se-1.2.0/datatables.min.css"/>
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css">


<link href="<%=baseURL%>css/plugins/steps/jquery.steps.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/dropzone/dropzone.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/style.css" rel="stylesheet">
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
					<h2><%=organization.getName()%></h2>
					<p><%=orgUtils.getOrganizationDetails(org_id)%></p>
				</div>
               <%if(user.getUserType().equalsIgnoreCase("super_admin")){ %>
				<div class="col-lg-10">
					<a href="<%=baseURL%>orgadmin/organization/edit_organization.jsp?org_id=<%=org_id%>" class="btn btn-outline btn-success"> Edit Organization</a>
				</div>
				<%} %>
			</div>

			<br>
			<div class="wrapper wrapper-content">

				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Batch Attendence Report</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<%
									conditions.clear();
									conditions.put("org_id", org_id + "");
								%>
								<%=dtUtils.getReport(201, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
						</div>
					</div>
				</div>
<%if(user.getUserType().equalsIgnoreCase("super_admin")){ %>
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Feedback by Trainer Per Batch</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-down"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<%
									conditions.clear();
									conditions.put("org_id", org_id + "");
								%>
								<%=dtUtils.getReport(202, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
						</div>
					</div>
				</div>
				
		<%} %>
				<%if(user.getUserType().equalsIgnoreCase("super_admin")){ %>
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Trainer duration Report associated with this organization</h5>
								<div class="ibox-tools">

									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" style="display: none;">
								<%
									conditions.clear();
									conditions.put("org_id", org_id + "");
								%>
								<%=dtUtils.getReport(215, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
						</div>
					</div>
				</div>
<%} %>
				<!--  Assessment Report associated with this org -->


				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Assessment Report associated with this organization</h5>
								<div class="ibox-tools">

									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" style="display: none;">
								<%
									conditions.clear();
									conditions.put("org_id", org_id + "");
								%>
								<%=dtUtils.getReport(206, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
						</div>
					</div>
				</div>

              <%if(user.getUserType().equalsIgnoreCase("super_admin")){ %>
				<!--  Student bulk upload form -->
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
		                    <div class="ibox-title">
								<h5>Upload Student in Organization</h5>
		                        <div class="ibox-tools">
		                            <a class="collapse-link">
		                                <i class="fa fa-chevron-down"></i>
		                            </a>
		                        </div>
		                    </div>
		                    <div class="ibox-content" >
		                        <div id="wizard">
		                            <h1>Upload excel sheet</h1>
		                            <div class="step-content">
		                                <form action="<%=baseURL%>excel_upload" id="excel_upload_students" class="dropzone" method="post"  enctype="multipart/form-data">
											<input type="hidden" name="org_id" value="<%=org_id%>" />
											<input type="hidden" name="type" value="students" />
											<input type="hidden" name="column_order" value="" />
											<div class="dropzone-previews" id="dropzonePreview"></div>
											<div class="dz-default dz-message"> <span>Drop files here to upload</span> </div>
										</form>
		                            </div>
		                            
		                            <h1>Confirm column details</h1>
		                            <div class="step-content">
			                            <% 	int ite = 0;
				                            ArrayList<String> columns = bulkUploadUtils.getStudentColumns();
			                            	for (String column : columns) { %>
			                                <div class="form-group">
												<label class="col-sm-2 control-label columns-label">Column <%=ite %></label>
												<div class="col-sm-10">
													<select id="column_<%=ite%>" class="colum_order_holder form-control m-b">
														<option value ="None">Select</option>
														<% for (String option : columns) { %>
														<option value ="<%=column%>"><%=option%></option>
														<% } %>
													</select>
												</div>
											</div>
										<% ite ++; } %>
										<div id="warning" class="warning-note" style="display:none">Note: Proceed to verify and confirm the details in the next step</div>
		                            </div>
		                            
		                            <!-- The next step to confirm the details would be dynamically created by Wizard API written in script part! -->
		                            
		                        </div>
		                    </div>
						</div>
					</div>
				</div>
<%} %>
				<!--  Student list table -->
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Students Associated with this organization</h5>
								<div class="ibox-tools">

									<a
										href="<%=baseURL%>orgadmin/trainer/edit_trainerlist.jsp?org_id=<%=org_id%>"><button
											type="button" class="btn btn-outline btn-success">Create
											new Student</button></a> &nbsp; &nbsp; <a class="collapse-link"> <i
										class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" style="display: none;">
								<%
									conditions.clear();
									conditions.put("org_id", org_id + "");
								%>
								<%=dtUtils.getReport(198, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
						</div>
					</div>
				</div>

				<!--  Batch group list table -->
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Programs Associated with this organization</h5>
								<div class="ibox-tools">
									<a
										href="<%=baseURL%>orgadmin/batch_group/edit_batchgroup.jsp?org_id=<%=org_id%>"><button
											type="button" class="btn btn-outline btn-success">Create
											New BatchGroup</button></a> &nbsp; &nbsp; <a class="collapse-link"> <i
										class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" style="display: none;">
								<%
									conditions.clear();
									conditions.put("org_id", org_id + "");
								%>
								<%=dtUtils.getReport(197, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
						</div>
					</div>
				</div>

				<!--  Batch list table -->
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Classrooms Associated with this organization</h5>
								<div class="ibox-tools">
									<a
										href="<%=baseURL%>orgadmin/organization/edit_classroomdetails.jsp?org_id=<%=org_id%>"><button
											type="button" class="btn btn-outline btn-success">Create
											New Class Room</button></a> &nbsp; &nbsp; <a class="collapse-link"> <i
										class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" style="display: none;">
								<%
									conditions.clear();
									conditions.put("org_id", org_id + "");
								%>
								<%=dtUtils.getReport(108, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
							</div>
						</div>
					</div>
				</div>
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

				<!--  batch list table -->
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
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=baseURL%>js/jquery.contextMenu.js"
		type="text/javascript"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/v/bs-3.3.6/jszip-2.5.0/pdfmake-0.1.18/dt-1.10.12/af-2.1.2/b-1.2.2/b-colvis-1.2.2/b-html5-1.2.2/b-print-1.2.2/cr-1.3.2/fc-3.2.2/fh-3.1.2/kt-2.1.3/r-2.1.0/rr-1.1.2/se-1.2.0/datatables.js"></script>	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- DROPZONE -->
	<script src="<%=baseURL%>js/plugins/dropzone/dropzone.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
	<!-- Full Calendar -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/fullcalendar.min.js"></script>

	<!-- Steps -->
	<script src="<%=baseURL%>js/plugins/staps/jquery.steps.min.js"></script>
	<script src="<%=baseURL%>js/plugins/validate/jquery.validate.min.js"></script>
	<script>
	
	
		function getColumnOrder() {
			var order = ""; 
			$(".colum_order_holder").each(function(index,element) {
				order = order + $("#column_"+index+" option:selected").text() + ",";
			});
			
			console.log("selected column order --> " + order);
			return order  + "#";	// '#' would work as the data delimitor while processing
		}
		
		function getTableDataInJson() {
			var rowId ;
			var jsonArrayString = "[";
			$('.DTrow').each(function(index,element) {
				rowId = $(element).attr("id");
				//console.log("row --> " + rowId);
				var cellId ;
				var cellColumnName ;
				var cellText ;
				var jsonObjectString = "{";
				
				$('.'+rowId).each(function(index,element) {
					cellId = $(element).attr("id");
					cellColumnName = cellId.replace(rowId+"_",'');
					cellText = $(element).text();
					//console.log("columnName ----> " + cellColumnName + " ; text ----> " + cellText);
					jsonObjectString = jsonObjectString + '\"' + cellColumnName + '\" : \"' + cellText + '\",';
				});
				jsonObjectString = (jsonObjectString + '##').replace(',##' , '') + '},';	// To remove the unnecessa comma at the end
				jsonArrayString = jsonArrayString + jsonObjectString;
			});
			jsonArrayString = (jsonArrayString + '##').replace(',##' , '') + ']';			// To remove the unnecessa comma at the end
			console.log(jsonArrayString);
			return jsonArrayString;
		}
		
		$(document).ready(function() {
			var  temp =0;

			$('.home-icon').click(function() {
				if(temp%2 ==0){
			  $(this).addClass('open');
				}else{
					  $(this).removeClass('open');

				}
			  temp++;
			});
			$('.fa-chevron-up').click();
			var excelUploadForm ;
			var response;
			var columnOrder = "";
			var wizard = $("#wizard").steps({
	            onStepChanging: function(event, currentIndex, newIndex)
	            {
	                console.log("Step changing from --> " + currentIndex);
	                return true;
	            },
	            onStepChanged: function(event, currentIndex, newIndex)
	            {
	                console.log("Step changed to --> " + currentIndex);
	                return true;
	            },
				onFinishing: function (event, currentIndex) {
					if(currentIndex === 1) {
						columnOrder = getColumnOrder();
						$('[name=column_order]').val(columnOrder);
						excelUploadForm = $('#excel_upload_students');
	             	  	myDropzone.processQueue();
	             	  	myDropzone.on("success", function(file,response) {
	                 	  	console.log("Response recieved!");
	                 	    wizard.steps("insert", 2, {
	                        	title: "Confirm details",
								content: response
	                        });
	             	  	});
						$("#warning").show();
					}
					if(currentIndex === 2) {
						
						
						var jsonArrayString = getTableDataInJson();
						$.ajax({
				            url: '/save_bulk_students?org_id=<%=org_id%>',
				            type: 'post',
				           
				            data: { 'jsonData' : jsonArrayString , 'org_id' : <%=org_id%>},
				            success : function(data) {
				            	alert("Student data uploaded ");
				            	window.location = "<%=baseURL%>/orgadmin/organization/dashboard.jsp?org_id=<%=org_id%>";
			        			}
				        });
						
					}
					return true; 
				}  
	        });

			Dropzone.autoDiscover = false;

			var myDropzone = new Dropzone(".dropzone", {
			  url: "<%=baseURL%>excel_upload",                        
			  autoProcessQueue: false,
			});
			 
			var org_id = <%=org_id%>;
			
			 
		});
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
<%List<HashMap<String, Object>> res = orgutils.getEventPerOrganization(organization);
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