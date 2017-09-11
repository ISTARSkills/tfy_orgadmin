<div id="loModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content custom-modal-content"
			style="width: 810px !important;">
			<div class="modal-header custom-modal-header"
				style="width: 808px !important;">
				<h5 class="modal-title custom-modal-title" id="loModalLabel">Add
					Learning Objectives</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body custom-no-padding">
				<div class="container-fluid">
					<div class='row'>
						<div class='col-md-6 col-md-auto'>
							<input type="text"
								placeholder="Search or type a new and press enter to create.."
								id='searchLO' class="form-control"
								style="margin-top: 10px; margin-bottom: 10px">
							<hr>
							<ul class="list-group" id='searchLOResult'
								style="max-height: 400px; overflow: auto;"></ul>
						</div>
						<div class='col-md-6 col-md-auto'>
							<h4 style="margin-top: 10px">Selected Learning Objectives</h4>
							<ul class="list-group" id='selectedLOs'
								style="max-height: 420px; overflow: auto;">
								<!-- <li class="list-group-item active" style="margin-top: 10px">Selected
									Learning Objectives</li> -->

							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>