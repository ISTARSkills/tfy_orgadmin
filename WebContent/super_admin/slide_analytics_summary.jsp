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
<body class="top-navigation" id="istar_notification">
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
							<label class="font-bold">Choose Organization</label>
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
							<label class="font-bold">Choose Batch</label>
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
								<label class="font-bold">Choose Course</label>
								<div>
									<select data-placeholder="Select Course" tabindex="4"
										data-url='' id='slide_analytics_course_holder'>
									</select>
								</div>
							</div>
						</div>
					<div class="col-lg-2">
							<div class="form-group">
								<label class="font-bold">Choose Trainer</label>
								<div>
									<select data-placeholder="Select Trainer" tabindex="4"
										data-url='' id='slide_analytics_trainer_holder'>
									</select>
								</div>
							</div>
						</div>
					<div class="col-lg-2">
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
			<div class='row'  id="">
				<form role="form">

					<div class="row">

						<div class="col-lg-12 white-bg">
							<div class="ibox customcss_iboxcontent">
								<div class="ibox-content">
									<div class="form-group">
										<label>Title</label> <input type="text" id="title"
											placeholder="Write Title..." class="form-control">
									</div>
									<div class="form-group">
										<label>Description</label>
										<textarea class="form-control" id="comment"
											placeholder="Write Comment..."></textarea>
									</div>
									<div class="form-group">
										

									</div>

								</div>

							</div>
						</div>
						
					</div>

				</form>


			</div>

		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
	console.log("asdasd");

		$('select').select2();
		$('#slide_analytics_college_holder').on("change", function() {
			var orgId = $(this).select2('val');
			var type = 'ORG';
			
			
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
			
			$('#slide_analytics_course_holder').select2();
			init_courseFilter();
			$('#notification_batchgroup_holder').select2();
		});
		
		function init_courseFilter() {
		$('#course_holder').on("change", function() {
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

		
		$( "#send_notification" ).unbind().on('click',function() {
			
			
			
			var flag = false;
			var notification_type = $('#notification_type_holder').val();
			// defined in istar_notification
			
			var adminId = $('#hidden_admin_id').val();
			//
			if(notification_type==='LESSON')
			{			
				var group_id = $('#notification_batchgroup_holder').val();
				var notification_type = 'LESSON';
				var course_id =$('#course_holder').val(); ;
				var cmsession_id = $('#notification_cmsession_holder').val(); ;
				var lesson_id =$('#notification_ppt_holder').val();;
				var studentlistID=[];			
				$('input:checkbox.student_checkbox_holder').each(function () {	
					if($(this).is(":checked")){
						studentlistID.push(this.checked ? $(this).val() : ""); 	
					}
				  });
				
				var title = $('#title').val();
				var comment = $('#comment').val(); 
				
				if(group_id==null || course_id ==null || cmsession_id==null || lesson_id == null || studentlistID.length <=0)
				{
					
			            swal({
			                title: "Missing mandatory fields",
			                text: "Section, Course, Session, Lesson and Students are mandatory to send lesson as notification."
			            });
			        
				}
				else
				{
					$('#spinner_holder').show();				
					$.ajax({
						type : "POST",
						url : '../create_notification',
						data : {
							notification_type : notification_type,
							title : title,
							comment : comment,
							course_id : course_id,
							group_id : group_id,						
							cmsession_id : cmsession_id,
							lesson_id:lesson_id,						
							admin_id:adminId,
							studentlist_id : studentlistID.toString()
							},
						success : function(data) {
							$('#spinner_holder').hide();
						   location.reload();
						}
					});
				}	
			}
			else if(notification_type==='ASSESSMENT')
			{
				var group_id = $('#notification_batchgroup_holder').val();
				var notification_type = 'ASSESSMENT';
				var assessment_id = $('#notification_assessment_holder').val();
				var studentlistID=[];			
				$('input:checkbox.student_checkbox_holder').each(function () {	
					if($(this).is(":checked")){
						studentlistID.push(this.checked ? $(this).val() : ""); 	
					}
				  });
				
				var title = $('#title').val();
				var comment = $('#comment').val(); 			
				
				if(assessment_id ==null || studentlistID.length <=0)
				{
					
			            swal({
			                title: "Missing mandatory fields",
			                text: "Assessment and Students are mandatory to send assessment as notification."
			            });
			        
				}
				else
				{
					$('#spinner_holder').show();				
					$.ajax({
						type : "POST",
						url : '../create_notification',
						data : {
							notification_type : notification_type,
							title : title,
							comment : comment,												
							assessment_id: 	assessment_id,			
							admin_id:adminId,
							studentlist_id : studentlistID.toString()
							},
						success : function(data) {
							$('#spinner_holder').hide();
						   location.reload();
						}
					});
				}	
			}		
			else if(notification_type==='COMPLEX_UPDATE')
			{
				var group_id = $('#notification_batchgroup_holder').val();
				var notification_type = 'COMPLEX_UPDATE';
				
				var studentlistID=[];			
				$('input:checkbox.student_checkbox_holder').each(function () {	
					if($(this).is(":checked")){
						studentlistID.push(this.checked ? $(this).val() : ""); 	
					}
				  });
				
				if(studentlistID.length <=0)
					{
					 swal({
			                title: "Missing mandatory fields",
			                text: "Students are mandatory to send updated content as notification."
			            });
			        
					}
				else
				{
					$('#spinner_holder').show();				
					$.ajax({
						type : "POST",
						url : '../create_notification',
						data : {
							notification_type : notification_type,												
							admin_id:adminId,
							studentlist_id : studentlistID.toString()
							},
						success : function(data) {
							$('#spinner_holder').hide();
						   location.reload();
						}
					});
				}	
			}
			else if(notification_type==='MESSAGE')
			{
				var notification_type = 'MESSAGE';
				var studentlistID=[];			
				$('input:checkbox.student_checkbox_holder').each(function () {	
					if($(this).is(":checked")){
						studentlistID.push(this.checked ? $(this).val() : ""); 	
					}
				  });
				var title = $('#title').val();
				var comment = $('#comment').val(); 			
				if(studentlistID.length <=0 || title==null || comment==null)
				{
					swal({
		                title: "Missing mandatory fields.",
		                text: "Title, Description and Students are mandatory to send message."
		            });
				}
				else
					{
					$('#spinner_holder').show();				
					$.ajax({
						type : "POST",
						url : '../create_notification',
						data : {
							notification_type : notification_type,												
							admin_id:adminId,
							title : title,
							comment : comment,
							studentlist_id : studentlistID.toString()
							},
						success : function(data) {
							$('#spinner_holder').hide();
						   location.reload();
						}
					});
					}
				
			}
			else
			{
				swal({
	                title: "Missing mandatory fields.",
	                text: "Select a type of notification."
	            });
			}	
		});

		
	

	</script>
</body>