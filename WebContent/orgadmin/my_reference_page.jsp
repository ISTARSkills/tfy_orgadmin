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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify Recruitor | Dashboard</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/cropper/cropper.min.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link
	href="<%=baseURL%>css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css"
	rel="stylesheet">
  <link href="<%=baseURL%>css/plugins/summernote/summernote.css" rel="stylesheet">
    <link href="<%=baseURL%>css/plugins/summernote/summernote-bs3.css" rel="stylesheet">

</head>

<body class="fixed-sidebar no-skin-config full-height-layout">

	<div id="wrapper">

		<jsp:include page="includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="includes/header.jsp"></jsp:include>
			</div>
			<div class="row">
				<div class="col-lg-12">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>
								All form elements <small>With custom checbox and radion
									elements.</small>
							</h5>
							<div class="ibox-tools">
								<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
								</a> <a class="dropdown-toggle" data-toggle="dropdown" href="#">
									<i class="fa fa-wrench"></i>
								</a>
								<ul class="dropdown-menu dropdown-user">
									<li><a href="#">Config option 1</a></li>
									<li><a href="#">Config option 2</a></li>
								</ul>
								<a class="close-link"> <i class="fa fa-times"></i>
								</a>
							</div>
						</div>
						<div class="ibox-content">
							<form method="get" class="form-horizontal" id="commentForm" >
								<div class="form-group">
									<label class="col-sm-2 control-label">Normal</label>

									<div class="col-sm-10">
										<input type="text" class="form-control" data-validation="required">
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label">I P</label>

									<div class="col-sm-10">
										<input type="number" class="form-control">
									</div>
								</div>

								
								<div class="form-group">
									<label class="col-sm-2 control-label">Inline radios</label>

									<div class="col-sm-10">
											<div class="radio radio-info radio-inline">

                                            <input type="radio" id="inlineRadio1" value="option1" name="radioInline" data-validation="required">
                                            <label for="inlineRadio1" data-validation="radio_button" > Inline One </label>
                                            
                                              <input type="radio" id="inlineRadio2" value="option2" name="radioInline" data-validation="required">
                                            <label for="inlineRadio2"> Inline Two </label>
                                            
                                            
                                        </div>									</div>
								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label">I P</label>

									<div class="col-sm-10">
									<div class="">
<input type="checkbox" value="option1" id="inlineCheckbox1"  name="newsletters[]" data-validation="checkbox_group" data-validation-qty="min1"> a  
                                        <input type="checkbox" value="option2" id="inlineCheckbox2"  name="newsletters[]" data-validation="checkbox_group" data-validation-qty="min1"> b  
                                        <input type="checkbox" value="option3" id="inlineCheckbox3" name="newsletters[]" data-validation="checkbox_group" data-validation-qty="min1"> c 															
								<label class="checkbox-inline" style="margin-right:5%;" > </label><label class="checkbox-inline" style="margin-right:5%;" ></label><label class="checkbox-inline"></label>	</div>
									</div>
								</div>
								
								
								<div class="hr-line-dashed"></div>


<div class="form-group">
                                    <label class="col-sm-2 control-label">IPV4</label>
                                    <div class="col-sm-10">
                                        <input type="text" class="form-control" data-mask="999.999.999.999" placeholder="" data-validation="required">
                                        <span class="help-block">192.168.100.200</span>
                                    </div>
                                </div>
								<div class="hr-line-dashed"></div>
								<div class="form-group">
									<label class="col-sm-2 control-label">Help text</label>
									<div class="col-sm-10">
										<input type="email" class="form-control"  data-validation="email"> <span
											class="help-block m-b-none">A block of help text that
											breaks onto a new line and may extend beyond one line.</span>
									</div>
								</div>
								<div class="hr-line-dashed"></div>
								<div class="form-group">
									<label class="col-sm-2 control-label">Password</label>

									<div class="col-sm-10">
										<input type="password" class="form-control" name="password" data-validation="strength" data-validation-strength="2">
									</div>
								</div>
								<div class="hr-line-dashed"></div>
								<div class="form-group">
									<label class="col-sm-2 control-label">Placeholder</label>

									<div class="col-sm-10">
										<input type="text" placeholder="placeholder"
											class="form-control">
									</div>
								</div>
								<div class="hr-line-dashed"></div>


<div class="form-group">
									<label class="col-sm-2 control-label">Placeholder</label>

									<div class="col-sm-10">
										<div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Wyswig Summernote Editor</h5>
                        <div class="ibox-tools">
                            <a class="collapse-link">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                <i class="fa fa-wrench"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-user">
                                <li><a href="#">Config option 1</a>
                                </li>
                                <li><a href="#">Config option 2</a>
                                </li>
                            </ul>
                            <a class="close-link">
                                <i class="fa fa-times"></i>
                            </a>
                        </div>
                    </div>
                    <div class="ibox-content no-padding">

                        <div class="summernote">
                            <h3>Lorem Ipsum is simply</h3>
                            dummy text of the printing and typesetting industry. <strong>Lorem Ipsum has been the industry's</strong> standard dummy text ever since the 1500s,
                            when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic
                            typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with
                            <br/>
                            <br/>
                            <ul>
                                <li>Remaining essentially unchanged</li>
                                <li>Make a type specimen book</li>
                                <li>Unknown printer</li>
                            </ul>
                        </div>

                    </div>
                </div>
										
									</div>
								</div>






								

								<div class="form-group">
									<label class="col-sm-2 control-label">Inline checkboxes</label>

									<div class="col-sm-10">
										
									</div>
								</div>
								<div class="hr-line-dashed"></div>
								<div class="form-group">
									<label class="col-sm-2 control-label">Select</label>

									<div class="col-sm-10">
										<select class="form-control m-b" name="account" >
											<option>option 1</option>
											<option>option 2</option>
											<option>option 3</option>
											<option>option 4</option>
										</select>


									</div>
								</div>
								<div class="hr-line-dashed"></div>
								
								
								<div class="hr-line-dashed"></div>
								<div class="form-group">
									<label class="col-sm-2 control-label">Control sizing</label>

									<div class="col-sm-10">

										<div class="col-lg-12">
											<div class="ibox float-e-margins">
												<div class="ibox-title  back-change">
													<h5>
														Image cropper <small>http://fengyuanchen.github.io/cropper/</small>
													</h5>
													<div class="ibox-tools">
														<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
														</a> <a class="dropdown-toggle" data-toggle="dropdown"
															href="#"> <i class="fa fa-wrench"></i>
														</a>
														<ul class="dropdown-menu dropdown-user">
															<li><a href="#">Config option 1</a></li>
															<li><a href="#">Config option 2</a></li>
														</ul>
														<a class="close-link"> <i class="fa fa-times"></i>
														</a>
													</div>
												</div>
												<div class="ibox-content">
													<p>A simple jQuery image cropping plugin.</p>
													<div class="row">
														<div class="col-md-6">
															<div class="image-crop">
																<img src="img/p3.jpg">
															</div>
														</div>
														<div class="col-md-6">
															<h4>Preview image</h4>
															<div class="img-preview img-preview-sm"></div>
															<h4>Comon method</h4>
															<p>You can upload new image to crop container and
																easy download new cropped image.</p>
															<div class="btn-group">
																<label title="Upload image file" for="inputImage"
																	class="btn btn-primary"> <input type="file"
																	accept="image/*" name="file" id="inputImage"
																	class="hide"> Upload new image
																</label> <label title="Donload image" id="download"
																	class="btn btn-primary">Download</label>
															</div>
															<h4>Other method</h4>
															<p>
																You may set cropper options with
																<code>$(image}).cropper(options)</code>
															</p>
															<div class="btn-group">
																<button class="btn btn-white" id="zoomIn" type="button">Zoom
																	In</button>
																<button class="btn btn-white" id="zoomOut" type="button">Zoom
																	Out</button>
																<button class="btn btn-white" id="rotateLeft"
																	type="button">Rotate Left</button>
																<button class="btn btn-white" id="rotateRight"
																	type="button">Rotate Right</button>
																<button class="btn btn-warning" id="setDrag"
																	type="button">New crop</button>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>

									</div>
								</div>

								


								<div class="form-group">
									<div class="col-sm-4 col-sm-offset-2">
										<button class="btn btn-white" type="submit">Cancel</button>
										<button class="btn btn-primary" type="submit">Save
											changes</button>
									</div>
								</div>






							</form>
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
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>

	<!-- Flot -->
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.tooltip.min.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.spline.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.resize.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.pie.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/jquery.flot.symbol.js"></script>
	<script src="<%=baseURL%>js/plugins/flot/curvedLines.js"></script>

	<!-- Peity -->
	<script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
	<script src="<%=baseURL%>js/demo/peity-demo.js"></script>
	<script src="<%=baseURL%>js/plugins/cropper/cropper.min.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI -->
	<script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>

	<!-- Jvectormap -->
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
	<script
		src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

	<!-- Sparkline -->
	<script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>

	<!-- Sparkline demo data  -->
	<script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>
<script src="<%=baseURL%>js/plugins/summernote/summernote.min.js"></script>

	<!-- ChartJS-->
	<script src="<%=baseURL%>js/plugins/chartJs/Chart.min.js"></script>
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>
    <script src="<%=baseURL%>js/plugins/jasny/jasny-bootstrap.min.js"></script>

	<script>
		$(document)
				.ready(
						function() {
							
							
							$.formUtils.addValidator({
								  name : 'even_number',
								  validatorFunction : function(value, $el, config, language, $form) {
									  
									  if(value==='option 1'){
										  return false;
									  }else{
										  return true;
									  }
									  
								  },
								  errorMessage : 'You have to answer with an even number',
								  errorMessageKey: 'badEvenNumber'
								});
							
							
							$.formUtils.addValidator({
								  name : 'ffffff',
								  validatorFunction : function(value, $el, config, language, $form) {
									  
									  if(value==='option 1'){
										  return false;
									  }else{
										  return true;
									  }
									  
								  },
								  errorMessage : 'You have to answer with an even number',
								  errorMessageKey: 'ffffff'
								});
							
							
							
							$.validate({
								  modules : 'security',
								  onModulesLoaded : function() {
								    var optionalConfig = {
								      fontSize: '12pt',
								      padding: '4px',
								      bad : 'Very bad',
								      weak : 'Weak',
								      good : 'Good',
								      strong : 'Strong'
								    };

								    $('input[name="password"]').displayPasswordStrength(optionalConfig);
								  }
								});

							
							$("[name='newsletters[]']:eq(0)")
							  .valAttr('','validate_checkbox_group')
							  .valAttr('qty','1-2')
							  .valAttr('error-msg','chose 1, max 2');
							
							
							
							
							$('.i-checks').iCheck({
								checkboxClass : 'icheckbox_square-green',
								radioClass : 'iradio_square-green',
							});
				            $('.summernote').summernote();

							var $image = $(".image-crop > img")
							$($image).cropper({
								aspectRatio : 1.618,
								preview : ".img-preview",
								done : function(data) {
									// Output the result data for cropping image.
								}
							});

							var $inputImage = $("#inputImage");
							if (window.FileReader) {
								$inputImage
										.change(function() {
											var fileReader = new FileReader(), files = this.files, file;

											if (!files.length) {
												return;
											}

											file = files[0];

											if (/^image\/\w+$/.test(file.type)) {
												fileReader.readAsDataURL(file);
												fileReader.onload = function() {
													$inputImage.val("");
													$image.cropper("reset",
															true).cropper(
															"replace",
															this.result);
												};
											} else {
												showMessage("Please choose an image file.");
											}
										});
							} else {
								$inputImage.addClass("hide");
							}

							$("#download").click(function() {
								window.open($image.cropper("getDataURL"));
							});

							$("#zoomIn").click(function() {
								$image.cropper("zoom", 0.1);
							});

							$("#zoomOut").click(function() {
								$image.cropper("zoom", -0.1);
							});

							$("#rotateLeft").click(function() {
								$image.cropper("rotate", 45);
							});

							$("#rotateRight").click(function() {
								$image.cropper("rotate", -45);
							});

							$("#setDrag").click(function() {
								$image.cropper("setDragMode", "crop");
							});

							
							//note-codable data-validation="required"
							$('.note-codable').removeAttr( "data-validation-skipped" );
							$('.note-codable').attr('data-validation', 'even_number');
						});
	</script>
</body>
</html>
