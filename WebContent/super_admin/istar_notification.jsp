<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
	OpsReportSevices opsReport = new OpsReportSevices();
	
	
	
%>
<jsp:include page="inc/head.jsp"></jsp:include>

<body class="top-navigation" id="super_admin_ops_report">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="row p-xl">
				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Choose College</label>
						<div>
							<select data-placeholder="select College" tabindex="4" id='notification_college_holder'>
								<%=opsReport.getOrganization()%>
							</select>
						</div>
					</div>
				</div>

				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Choose BatchGroup</label>
						<div>
							<select data-placeholder="select BatchGroup" tabindex="4" id='notification_batchgroup_holder'></select>
						</div>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Choose Course</label>
						<div id= "notification_course_holder" >
							 <select data-placeholder="select Course" tabindex="4" data-url='' id='course_holder'></select> 
						</div>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Choose Lesson</label>
						<div>
							<select data-placeholder="select Lessson" tabindex="4" data-url='' id='notification_lesson_holder'> </select>
						</div>
					</div>
				</div>
				<!-- <div class="col-lg-2">
					<div class="form-group">
						<label class="font-bold">Choose Assessment</label>
						<div>
							<select data-placeholder="select Assessment" tabindex="4"
								data-url='' id='notification_assessment_holder'>
							</select>
						</div>
					</div>
				</div> -->



			</div>

			<div id="">
				<form role="form">

					<div class="row">

						<div class="col-lg-6">
							<div class="ibox">
								<div class="ibox-content">


									<div class="form-group">
										<label>Title</label> <input type="text" id="title"
											placeholder="Write Title..." class="form-control">
									</div>
									<div class="form-group">
										<label>Comments</label>
										<textarea class="form-control" id="comment" placeholder="Write comment..."></textarea>
									</div>
									<div class="form-group">
										<button class="btn btn-sm btn-primary pull-right m-t-n-xs" id ="send_notification" type="button">
											<strong>Send Notification</strong>
										</button>

									</div>

								</div>

							</div>
						</div>
						<div class="col-lg-6">
							<div class="ibox">
								<div class="ibox-content">

									<h3 class="m-b-xxs">Student List <label class="checkbox-inline pull-right"> <input type="checkbox" id="checkAll"> checkAll </label></h3>
									<div id="student_holder">
									
									
									</div>

								</div>

							</div>
						</div>
					</div>

				</form>


			</div>

		</div>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {

			$('#notification_college_holder').on("change", function() {
				var orgId = $(this).val();
				var type = 'org';
				$.ajax({
					type : "POST",
					url : '../get_notification',
					data : {
						orgId : orgId,
						type : type
					},
					success : function(data) {
						$('#notification_batchgroup_holder').html(data);
					}
				});
			});

			$('#notification_batchgroup_holder').unbind().on("change", function() {
				var batchGroup = $(this).val();
				var type = 'batchGroup';

				if (batchGroup != 'null') {
					$.ajax({
						type : "POST",
						url : '../get_notification',
						data : {
							type : type,
							batchGroup : batchGroup
						},
						success : function(data) {
							$('#notification_batchgroup_holder').select2();
							$('#student_holder').html($(data)[1]);			
							$('#notification_course_holder').html($(data)[0]);
							$('#course_holder').select2();
							init_checkAllStudent();
							init_courseFilter();


						}
					});
				}
			});
			
			function init_courseFilter() {
			$('#course_holder').on("change", function() {
				var course = $(this).val();
				var type = 'course';

				if (course != 'null') {
					$.ajax({
						type : "POST",
						url : '../get_notification',
						data : {
							type : type,
							course : course
						},
						success : function(data) {
							
							$('#notification_cmsession_holder').html(data);

						}
					});
				}
			});
			}
			
			
			function init_checkAllStudent() {
	
				$("#checkAll").change(function(){
				        if($(this).is(":checked")) {
				          
				            $('.student_checkbox_holder').prop('checked', true);

				        } else {
				        	 $('.student_checkbox_holder').prop('checked', false);
				        }
				        
				    });
				
			}
			
			$( "#send_notification" ).click(function() {
				var flag = false;
				var type = 'sendNotification';
				var title = $('#title').val();
				var comment = $('#comment').val();
				var courseID = $('#course_holder').val();
				var batchGroupID = $('#notification_batchgroup_holder').val();
				var collegeID = $('#notification_college_holder').val();
				var lessonID = $('#notification_lesson_holder').val();	
				var studentlistID=[];
				
				$('input:checkbox.student_checkbox_holder').each(function () {	
					if($(this).is(":checked")){
						studentlistID.push(this.checked ? $(this).val() : ""); 	
					}
				  });
				
				console.log(title+","+comment+","+courseID+","+batchGroupID+","+collegeID+","+lessonID+","+studentlistID);
				
			if(studentlistID.length > 0){
				
				if(courseID != 'null'){
					
					if(cmsessionID != 'null'){
						
						flag = true;
						
					}else{
						flag = false;
						alert('Select Session');
					}
			
				}else{
					flag = true;
				}
				
				
			}else{
				
				flag = false;
				alert('Select Student');
			}
				
			if(flag == true){
				$.ajax({
					type : "POST",
					url : '../get_notification',
					data : {
						type : type,
						title : title,
						comment : comment,
						courseID : courseID,
						batchGroupID : batchGroupID,
						collegeID : collegeID,
						lessonID : lessonID,
						studentlistID : studentlistID.toString()
					},
					success : function(data) {
						
						

					}
				});
				
			}
				
			});
			
			
		});
	</script>
</body>

</html>
