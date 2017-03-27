<%@page import="in.orgadmin.utils.BatchGroupUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="com.istarindia.apps.service.*"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>

<%@page import="in.orgadmin.services.*"%>



<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int org_id = Integer.parseInt(request.getParameter("org_id"));
	
	College cid = new CollegeDAO().findById(org_id);
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Portal | Notice Board</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">



<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<!-- DataTable -->
<link href="<%=baseURL%>css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">
<link
	href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css"
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
					<h2>Create Notification</h2>
				</div>
			</div>
			<div class="row white-bg dashboard-header" style="padding: 0px">

				<div class="col-sm-12">
					<div class="white-bg border-left">

						<div class="element-detail-box">

							<div class="tab-content">
								<div id="tab-1" class="tab-pane active">

									<div
										class="wrapper wrapper-content animated fadeInUp ecommerce">
										<div class="ibox">
											<div class="ibox-title">
												<h5>Select User To send Notification</h5>
												<div class="ibox-tools">
													<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
													</a> <a class="close-link"> <i class="fa fa-times"></i>
													</a>
												</div>
											</div>
											<div class="ibox-content">
												<form action="/send_notification" method="get"
													class="form-horizontal" id="form-1">
													<div class="form-group">
														<label for="message">Message</label>
														<textarea class="form-control" id="message" rows="3"
															name="message" placeholder="Enter a message ..."></textarea>
													</div>
													<div class="form-group">
														<label for="details">Details</label>
														<textarea class="form-control" id="details" rows="3"
															name="details" placeholder="Enter details ..."></textarea>
													</div>

													<div class="form-group">
														<label class="col-sm-0 control-label">Select
															Course</label>
														<div class="col-sm-0">
															<%
																	List<Course> courses = new CourseDAO().findAll();
																	
																%>
															<select class="form-control m-b" name="course_id"
																id='id_course_id'>
																<option value="No Course" disabled selected>No
																	Course</option>
																<%for (Course c : courses) { %>
																<option value="<%=c.getId()%>"><%=c.getId() %>--<%=c.getCourseName()%></option>

																<%
																	}
																%>


															</select>
														</div>
													</div>


													<div class="form-group">
														<label class="col-sm-0 control-label">Select
															Session</label>

														<div class="col-sm-0">
															<select class="form-control m-b" name="session_id"
																id='id_session_id'>

															</select>
														</div>
													</div>

													<%-- <div class="form-group">
														<label class="col-sm-0 control-label">Select Batch</label>
														<div class="col-sm-0">
															<%
				                                             	Set<BatchGroup> bgs = cid.getBatchGroups();
				                                                 	if(bgs.size()>0)
				                                                    	{
					                                            	
						                                        	%>

															<select class="form-control m-b" name="batchg_id"
																id='id_bg_id'>
																<option value="No Batch" disabled selected>No
																	Batch</option>
																<%for (BatchGroup bg : cid.getBatchGroups()) { %>
																<option value="<%=bg.getId()%>"><%=bg.getId() %>--<%=bg.getName()%></option>

																<%
																}}
																%>


															</select>
														</div>
													</div> --%>
                                          
													<button class="btn btn-primary" type="button" name="btn_id_up" id=send_data>Send Notification</button>
													
													 <button class="btn btn-w-m btn-danger pull-right" id="clear-btn" type="button" name="btn_id_down">Clear All Notification</button> 
													
														<label style='margin-left: 1%; color: gray'>[NOTE: Select Student and submit]</label>
														<label style='margin-left: 40%; color: gray'>[NOTE: Clear Notification From Firebase]</label>
										               <label id='errLabel' style='color: red'></label>
 
                                      <div class="checkbox checkbox-inline" style="    float: right;">
                                            <!-- <input type="checkbox" id="inlineCheckbox1" name="inlineCheckbox1" value="option1"> -->
                                            <input type="hidden" id="students" name="students" value="">
                                           <!--  <label for="inlineCheckbox1"> Select All </label> -->
                                        </div>

													<%
														DatatableUtils dtUtils = new DatatableUtils();
														HashMap<String, String> conditions = new HashMap<>();
														conditions.clear();
														conditions.put("org_id", org_id + "");
													%>
													<%=dtUtils.getReport(209, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString()%>
											

													
												</form>
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
	<script src="http://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>

	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
	<script src="<%=baseURL%>js/plugins/dataTables/datatables.min.js"></script>
	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
	
	<script
		src="<%=baseURL%>js/plugins/dataTables/jquery.dataTables.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/dataTables/dataTables.colVis.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/dataTables/dataTables.tableTools.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/dataTables/dataTables.bootstrap.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/datatable-responsive/datatables.responsive.min.js"></script>/

	<script>
	
	
	

	
		$(document).ready(function() {
			
			
			$( "#clear-btn" ).click(function() {
				
				 $.ajax({
			           url: '<%=baseURL%>DeleteFireBaseContent',
			           
			           success : function(data) {
			        	   
			         alert("Cleared")
						}
			           });
				  
				});
			
			    var datatab= [];
			    var batch_idnew = 0 ;
			    var stu_idsnew = 0;
		        
		                
			var table = $('#datatable_report_209').DataTable( {
				                       destroy: true,
					                    initComplete: function () {
					                        this.api().columns().every( function () {
					                            var column = this;
					                            var select = $('<select><option value=""></option></select>')
					                                .appendTo( $(column.footer()).empty() )
					                                .on( 'change', function () {
					                                    var val = $.fn.dataTable.util.escapeRegex(
					                                        $(this).val()
					                                    );
					             						
					                                    column
					                                        .search( val ? '^'+val+'$' : '', true, false )
					                                        .draw();
					                                } );
					                            		
					                            column.data().unique().sort().each( function ( d, j ) {
					                                select.append( '<option value="'+d+'">'+d+'</option>' )
					                            } );
					                            column.on( 'click', function () {
					                		        $(this).toggleClass('selected');
					                		        
					                		         } );
					                        } );
					                        
					 
					                    }
					                } ); 
			
					        
			table.on( 'click', 'tbody>tr', function () {
		        $(this).toggleClass('selected');
		        var datatab= [];
		        var batch_id_arr =[];
		        var student_ids =[];
		        
		        for (var i = 0; i < table.rows('.selected').data().length; i++) 
		        { 
		        	 datatab = table.rows('.selected').data()[i];
		        	
		        	 batch_id_arr.push(datatab[0]);
		        	 student_ids.push(datatab[2]);
		        	
			         } 
		         batch_idnew = batch_id_arr.join(',');
		        stu_idsnew = student_ids.join(',');
		        console.log(batch_idnew);
		        console.log(stu_idsnew);
		    } );


		 
			 $('#id_course_id').change (
			
					 function() {
						 
						 /* alert('course id hai '+this.value); */
		                $.ajax({
		                    type: "POST",
		                    url: '<%=baseURL%>AllPublishedSessionsFilter',
		                    data: {course_id: this.value },
		                    success: function(data){
		                     /*  alert('id_session_id '+data); */
		                      $('#id_session_id').html(data);
		                    }
		                });
		            }
		        );
		        
		        
			$("#send_data").click(function(event){  
				
				var course_id = $("#id_course_id").val();
				var session_id = $("#id_session_id").val();
				var message = $("#message").val();
				var details = $("#details").val();
				
				if (stu_idsnew.length < 1 || $('#message').val().length < 1 || $('#details').val().length < 1 ) 
	            {
	            	$("#errLabel").text("  (Note: Please select at least one student before proceeding)");
	            	event.preventDefault();
	            } else {
				
				
				var dataString = 'course_id='+ course_id +'&session_id=' + session_id +'&message='+ message + '&details=' + details + '&batch_idnew=' + batch_idnew + '&stu_idsnew=' + stu_idsnew ;
				
				$.ajax({
                    url: '<%=baseURL%>send_notification',
                    data: dataString,
                    
                    success : function(data) {
                   	 alert("Sent");

        			}
                    });
		
	            }
			});
			
			/////////
		
			
			////////

		});
	</script>


</body>
</html>