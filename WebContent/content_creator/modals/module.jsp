<div id="moduleModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content custom-modal-content"
			style="max-height: 352px">
			<div class="modal-header custom-modal-header">
				<h5 class="modal-title custom-modal-title" id="moduleModalLabel">Create
					Module</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body custom-no-padding">
				<div class="container-fluid bd-example-row">
					<div class='row' style="margin-top: 10px;">
						<div class='col-md-3 col-md-auto justify-content-md-center'>
							<label>Module Title</label>
						</div>
						<div class='col-md-9 col-md-auto'>
							<input style="width: 100%" class="form-control" id='moduleModalTitle'>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto'>
							<label>Description</label>
						</div>
						<div class='col-md-9 col-md-auto'>
							<textarea style="width: 100%" class="form-control" id='moduleModalDescription'></textarea>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto'>
							<label>Image</label>
						</div>
						<div class='col-md-5 col-md-auto'>
							<label for="moduleImageURL"><img class='moduleImage'
								src='http://localhost:8080//course_images/8.png' alt=''> </label><input
								style="display: none"
								value='http://localhost:8080//course_images/8.png'
								id='moduleImageURL' type='file'>
						</div>
						<div class='col-md-4 col-md-auto'>
							<button class="btn btn-sm btn-modal" style="margin-top: 22px" id='saveModule'>Save
								Changes</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>