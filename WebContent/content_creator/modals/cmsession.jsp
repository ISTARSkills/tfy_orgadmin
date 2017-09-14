<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%
	URLServices services = new URLServices();
	String cdnPath = services.getAnyProp("cdn_path");
%>
<div id="sessionModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content custom-modal-content"
			style="max-height: 352px">
			<div class="modal-header custom-modal-header">
				<h5 class="modal-title custom-modal-title" id="sessionModalLabel">Create/Modify
					Session</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body custom-no-padding">
				<div class="container-fluid bd-example-row">
					<div class='row' style="margin-top: 10px;">
						<div class='col-md-3 col-md-auto justify-content-md-center'>
							<label>Session Title</label>
						</div>
						<div class='col-md-9 col-md-auto'>
							<input style="width: 100%" class="form-control"
								id='sessionModalTitle'>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto'>
							<label>Description</label>
						</div>
						<div class='col-md-9 col-md-auto'>
							<textarea style="width: 100%" class="form-control"
								id='sessionModalDescription'></textarea>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto'>
							<label>Image</label>
						</div>
						<div class='col-md-5 col-md-auto'>
							<label for="sessionImageURL"><img class='sessionImage'
								src='<%=cdnPath %>course_images/plusIcon.png' alt=''> </label><input
								style="display: none"
								value='<%=cdnPath %>course_images/plusIcon.png'
								id='sessionImageURL' type='file'>
						</div>
						<div class='col-md-4 col-md-auto'>
							<button class="btn btn-sm btn-modal" style="margin-top: 22px"
								id='saveSession'>Save Changes</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>