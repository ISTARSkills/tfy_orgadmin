<div class="modal-dialog" role="document">
		<div class="modal-content custom-edit-question-modal-content">
			<div class="modal-header custom-edit-question-modal-header">
				<h5 class="modal-title custom-edit-question-modal-title"
					id="editQuestionModalLabel">Edit Question</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body custom-no-padding">
				<div class="container-fluid bd-example-row">
					<div class='row' style="margin-top: 10px;">
						<div class='col-md-3 col-md-auto justify-content-md-center  my-3'>
							<label>Choose Module</label>
						</div>
						<div class='col-md-9 col-md-auto'>
							<select id='chooseModule' class="custom-select d-block my-3"
								required>
								<option value="">Open this select menu</option>
							</select>
						</div>
					</div>
					<hr>
					<div class='row'>
						<button type="button" class="btn btn-sm btn-modal"
							style="margin: auto;" id='changeModuleModalSubmit'>Move Session</button>
					</div>
				</div>
			</div>
		</div>
	</div>