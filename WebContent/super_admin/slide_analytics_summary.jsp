<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.Assessment"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
 String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
IstarUser user = (IstarUser)request.getSession().getAttribute("user");
%>
<body class="top-navigation" id="istar_notificationwww">
	<input type="hidden" name="admin_id" value="<%=user.getId()%>"id="hidden_admin_id">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			
			<% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Trainer Slide Analytics Summary", brd) %>
			
			<div class="row customcss_istarnotification" >
			<div class=''>
			<div class="col-lg-12 card-box m-r-none bg-muted">
				
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Organization*</label>
							<div>
								<select data-placeholder="Select Organization" tabindex="4"
									id='slide_analytics_college_holder'>
									<option value="null">Select Organization</option>
									<%
								for(Organization org : (List<Organization>)new OrganizationDAO().findAll())
								{
									%>
									<option value="<%=org.getId()%>"><%=org.getName()%></option>
									<%
								}
								%>
								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-2">
						<div class="form-group">
							<label class="font-bold">Choose Batch*</label>
							<div>
								<select data-placeholder="Select Section" tabindex="4"
									id='slide_analytics_batchgroup_holder'>
									<option value="null">Select Section / Role</option>

								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-2">
							<div class="form-group">
								<label class="font-bold">Choose Course*</label>
								<div>
									<select data-placeholder="Select Course" tabindex="4"
										data-url='' id='slide_analytics_course_holder'>
									</select>
								</div>
							</div>
						</div>
					<div class="col-lg-2">
							<div class="form-group">
								<label class="font-bold">Choose Trainer*</label>
								<div>
									<select data-placeholder="Select Trainer" tabindex="4"
										data-url='' id='slide_analytics_trainer_holder'>
									</select>
								</div>
							</div>
						</div>
						<div class="col-lg-3">
					<div class="form-group" id="data_5">
                                <label class="font-bold">Select Date Range</label>
                                <div class="input-daterange input-group" id="datepicker">
                                    <input type="text" class="input-sm form-control" name="start">
                                    <span class="input-group-addon">to</span>
                                    <input type="text" class="input-sm form-control" name="end">
                                </div>
                            </div>	
                           </div> 
					<div class="col-lg-12">
					<div class="form-group">
								<label class="font-bold"></label>
								<div>
									<button class="btn btn-sm btn-danger pull-right m-t-n-xs"
											id="show_graph" type="button">
											<strong>Show Summary</strong>
										</button>
								</div>
							</div>
					
										</div>
				</div></div>
			</div>
			<div style="display: none" id="spinner_holder">
				<div style="width: 100%; z-index: 6; position: fixed;"
					class="spiner-example">
					<div style="width: 100%;"
						class="sk-spinner sk-spinner-three-bounce">
						<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
					</div>
				</div>
			</div>
			<div class='row'>
					<div class="row">
						<div class="col-lg-12 white-bg">
							<div class="ibox customcss_iboxcontent">
								<div class="ibox-content">
									<div id ="graph_ke_liye">
									</div>
								</div>

							</div>
						</div>
						
					</div>

			


			</div>

		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
	console.log("asdasd");
	$('#data_5 .input-daterange').datepicker({
        keyboardNavigation: false,
        forceParse: false,
        autoclose: true
    });

		$('select').select2();
		$('#slide_analytics_college_holder').on("change", function() {
			var orgId = $(this).select2('val');
			var type = 'ANALYTICS_ORG';						
			$.ajax({
				type : "POST",
				url : '../get_notification_data',
				data : {
					entity_id : orgId,
					entity_type : type
				},
				success : function(data) {					
					$('#slide_analytics_batchgroup_holder').select2('val','null');
					$('#slide_analytics_batchgroup_holder').html(data);
				}
			});		
		});

		$('#slide_analytics_batchgroup_holder').unbind().on("change", function() {
			var batchGroupId = $(this).val();
			var type = 'GROUP';
			if(batchGroupId!=null)
			{
				var entity_id = $('#slide_analytics_batchgroup_holder').val();
				var entity_type = 'LESSON';
				$.ajax({
					type : "POST",
					url : '../get_notification_data',
					data : {
						entity_id : entity_id,
						entity_type : entity_type
					},
					success : function(data) {
						$('#slide_analytics_course_holder').select2();;
						$('#slide_analytics_course_holder').html(data);
						
					}
				});
				//$('#slide_analytics_trainer_holder').select2();
				$('#slide_analytics_course_holder').select2();
				init_courseFilter();
				$('#slide_analytics_batchgroup_holder').select2();
			}	
			
		});
		
		function init_courseFilter() {
		$('#slide_analytics_course_holder').on("change", function() {
			var course = $(this).val();
			var type = 'TRAINER';
			var batchGroupId = $('#slide_analytics_batchgroup_holder').val();

			if (course!=undefined && course!='' && course != 'null') {
				$.ajax({
					type : "POST",
					url : '../get_notification_data',
					data : {
						entity_type : type,
						entity_id : course,
						batch_group_id : batchGroupId
					},
					success : function(data) {
						$('#slide_analytics_trainer_holder').html(data);
						$('#slide_analytics_trainer_holder').select2('val','null');
					}
				});
			}
		});
		}

		
		$( "#show_graph" ).unbind().on('click',function() {
			
			var orgId = $('#slide_analytics_college_holder').val();
			var batchGroupId =$('#slide_analytics_batchgroup_holder').val() ;
			var courseId = $('#slide_analytics_course_holder').val();
			var trainerId = $('#slide_analytics_trainer_holder').val(); 
			var startDate = $('#data_5').find('input[name="start"]').val();
			var endDate = $('#data_5').find('input[name="end"]').val();
			if(orgId ==null ||batchGroupId ==null ||courseId ==null ||trainerId ==null)
			{
				swal({
	                title: "Missing mandatory fields.",
	                text: "Organization, Batch, Course and Trainer are mandatory fields."
	            });
			}
			else
			{
				$('#spinner_holder').show();
				$.ajax({
					type : "POST",
					url : '../cutsom_chart_data',
					data : {
						trainer_id : trainerId,
						org_id : orgId,
						batch_group_id : batchGroupId,
						course_id : courseId,
						start_date : startDate,						
						end_date : endDate
						},
					success : function(data) {						
					  	$('#graph_ke_liye').html(data);
					  	createGraphs();
					  	$('#spinner_holder').hide();
					}
				});
			}
		});

		


	</script>
</body>