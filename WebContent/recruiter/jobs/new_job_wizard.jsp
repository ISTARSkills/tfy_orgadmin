<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
		<div class="col-lg-12">
			<div class="ibox">
				<div class="ibox-title">
					<h5>Enter job details</h5>
				</div>
				<div class="ibox-content">
					<h2></h2>
					<p></p>

					<form id="form" action="#" class="wizard-big">
						<h1>Introduction</h1>
						<fieldset>
							<h2></h2>
							<div class="row">
								<div class="col-lg-8">


									<div class="row">
										<div class="form-group col-md-8">
											<label>Title *</label> <label id="title-error" class="error" for="title" style="display: none;"></label> <input id="title" name="title" type="text" class="form-control required valid" aria-required="true" aria-invalid="false" value="dd">
										</div>
										<div class="col-md-4">
											<label>No of positions *</label> <label id="position-error" class="error" for="position" style="display: none;"></label> <input id="position" name="position" type="number" class="form-control required valid" aria-required="true" aria-invalid="false" value="2">
										</div>
									</div>
									<div class="ibox float-e-margins">
										<div class="ibox-title">
											<h5>Job description *</h5>
										</div>
										<div class="ibox-content no-padding">

											<div class="summernote">
												<h2>Main responsibilities</h2>
												You will be in-charge of the the network systems. This role reports to the Head of Technology and based in Bangalore. Candidates with less than 3 years exp and less than 8 Lakhs salary please dont apply. <br /> <br />
												<h4>Minimum qualifications</h4>
												<ul style="margin-left: 20px">
													<li>Application server maintainance and deployement.(J2EE based)</li>
													<li>Linux Server Administration</li>
													<li>Clustering</li>
													<li>Hands on experience - Apache Tomcat.</li>
													<li>Primary and secondary data base synchronisation.</li>
												</ul>
											</div>

										</div>
									</div>
									<div class="form-group">
										<label>Location *</label> <label id="userName-error" class="error" for="userName" style="display: none;"></label> <input id="userName" name="location" type="text" class="form-control required valid" aria-required="true" aria-invalid="false" value="Bangalore">
									</div>

									<div class="form-group m-b-sm">
										<label>Salary range *</label>
									</div>
									<div id="ionrange_1"></div>


									<div class="form-group m-b-sm">
										<label>Experience range *</label>
									</div>
									<div id="ionrange_2"></div>

								</div>
								<div class="col-lg-4">
									<div class="text-center">
										<div style="margin-top: 20px">
											<i class="fa fa-sign-in" style="font-size: 180px; color: #e5e5e5"></i>
										</div>
									</div>
								</div>
							</div>

						</fieldset>
						<h1>Workflow</h1>
						<fieldset>
							<h2>Setup interview workflow</h2>

							<!-- <div id="droppable" class="ui-widget-header">
  								<p>Drop here to delete the step</p>
							</div> -->


							<div class="row">
								<div class="row col-lg-2">
									<div class="col-lg-12">
										<div class="ibox" style="opacity: 1; z-index: 0;">
											<div class="ibox-content toggle-on-hover" style="height: 16vh;">
												<div class="hide-on-hover text-center">
													<a><i class="fa fa-plus-circle big-fa-icon"></i></a>
												</div>
												<div class="show-on-hover add-step">


													<div class="text-center">
														<button class="btn btn-primary dim btn-primary-dim" data-toggle="modal" style="margin-top: 30%; margin-left: 5%;" type="button" href="#modal-form">Create Stage</button>
													</div>
													<div id="modal-form" class="modal fade" aria-hidden="true">
														<div class="modal-dialog">
															<div class="modal-content">
																<div class="modal-body">
																	<div class="row">

																		<div class="col-sm-12 b-r" id="DivIdContainer">
																			<h3 class="m-t-none m-b text-center text-info">Welcome to Create Stage</h3>
																			<div class="form-group">
																				<label>Select Stage Type</label> <select class="form-control m-b modalSelectBox " name="account">
																					<option>Technical Interview</option>
																					<option>Aptitude</option>
																					<option>HR Interview</option>
																					<option>Group Discussion</option>
																				</select>
																			</div>
																			<div class="form-group">
																				<label>Description</label> <input type="text" placeholder="Enter Description" id="stage_description" class="form-control">
																			</div>
																			<div class="form-group">
																				<button class="btn btn-w-m btn-primary " type="submit" onclick="createStep()">
																					<strong>Create Stage</strong>
																				</button>

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
								</div>






								<div class="row col-lg-10" id="mmm">
									<!-- <div id="sortable" class="ui-state-default" style="background: none !important; border: none !important;"></div> -->
									<div id="box-content" ></div>

								</div>
							</div>
							<div class="row ">
								<div class="row col-lg-2">
									<div class="col-lg-12 ">
										<div class="ibox " style="opacity: 1; z-index: 0;">
											<div class="ibox-content toggle-on-hover " id="droppable" style="height: 16vh;">
												<div class="hide-on-hover text-center">
													<a><i class="fa fa-minus-circle big-fa-icon"></i></a>
												</div>
												<div class="show-on-hover add-step">
													<h3>Delete the Step</h3>
													<small>by dropping the step box here</small>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

						</fieldset>

						<h1>Warning</h1>
						<fieldset>
							<div class="text-center" style="margin-top: 120px">
								<h2>You did it Man :-)</h2>
							</div>
						</fieldset>

						<h1>Finish</h1>
						<fieldset>
							<h2>Terms and Conditions</h2>
							<input id="acceptTerms" name="acceptTerms" type="checkbox" class="required"> <label for="acceptTerms">I agree with the Terms and Conditions.</label>
						</fieldset>
					</form>
				</div>
			</div>
		</div>

	</div>
</div>