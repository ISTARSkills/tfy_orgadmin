<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<style>
.champa {
	background-color: antiquewhite !important;
}
</style>
<body id="student_role">
	<%
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());
		if (cp == null) {
			flag = true;
			request.setAttribute("msg", "User Does Not Have Permission To Access");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
		request.setAttribute("cp", cp);
		StudentRolesService studentrolesservice = new StudentRolesService();
		URLServices services = new URLServices();
		String cdnPath = services.getAnyProp("cdn_path");
		String content_rest_url = services.getAnyProp("content_rest_url");
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<%
		if (request.getParameterMap().containsKey("course")) {
	%>
	<input style='display: hidden' id='courseID'
		value='<%=request.getParameter("course")%>'>
	<input style='display: hidden' id='isNewCourse' value='false'>
	<%
		} else {
	%>
	<input style='display: hidden' id='isNewCourse' value='true'>
	<%
		}
	%>
	<input style="display: hidden" id='cdnPath' value="<%=cdnPath%>">
	<input style="display: hidden" id='content_rest_url'
		value="<%=content_rest_url%>">
	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row">
				<h1 id='coursePageHeading'></h1>
			</div>
		</div>
		<div class="form-container">
			<div class="row">
				<div class="col-md-8">
					<form>
						<div class="form-group row">
							<label for="courseName" class="col-sm-2 col-form-label">Course
								Name</label>
							<div class="col-sm-10">
								<input type="text" id='courseName' class="form-control">
							</div>
						</div>
						<div class="form-group row">
							<label for="courseDesc" class="col-sm-2 col-form-label">Description</label>
							<div class="col-sm-10">
								<textarea class="form-control" rows="3" style="width: 100%"
									id='courseDesc'></textarea>
							</div>
						</div>
						<div class="form-group row">
							<label for="courseCategory" class="col-sm-2 col-form-label">Category</label>
							<div class="col-sm-10">
								<input type="text" id='courseCategory' class="form-control">
							</div>
						</div>
						<div class="form-group row">
							<div class="col-lg-offset-2 col-lg-10">
								<button class="btn btn-sm btn-primary " type="button"
									id='updateCourseDetails'>Update Detail</button>
								<button class="btn btn-sm btn-primary" id='addLastModule'
									type='button'>Add Module</button>
							</div>
						</div>
					</form>

				</div>
				<div class="col-md-3">
					<label for="courseImageURL"><img class='courseImage'
						id='courseImage' src='<%=cdnPath%>course_images/plusIcon.png'
						alt=''> </label><input style="display: none"
						value='<%=cdnPath%>course_images/plusIcon.png' id='courseImageURL'
						type='file' accept="image/png">
				</div>
			</div>

		</div>
		<div class="container" style="margin-top: 20px;">
			<div class="card">

				<div class="row">
					<div id="skillTree"></div>
				</div>
			</div>
		</div>
	</div>
	<div id='modals'></div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
			initializeCourseTreeVariables();
			if (!window.isNewCourse) {
				fillCourseEditFormFields();
				loadCourseTree();
			} else {
				$('#coursePageHeading').html('New Course');
			}
			initializeAddModuleButton();
			initializeUpdateCourseDetailsButton();
			initializeCourseImageUploader();
			inititalizeEllipsisListeners();
		});
		function inititalizeEllipsisListeners() {
			initModuleEllipsisListener();
			initSessionEllipsisListener();
			initLessonEllipsisListener();
		}

		function initModuleEllipsisListener() {
			initModuleEllipsisEditModule();
			initModuleEllipsisAddSession();
			initModuleEllipsisAddModuleBelow();
			initModuleEllipsisMoveUp();
			initModuleEllipsisMoveDown();
			initModuleEllipsisDelete();
		}
		function initSessionEllipsisListener() {
			initSessionEllipsisEditSession();
			initSessionEllipsisAddLesson();
			initSessionEllipsisAddSessionBelow();
			initSessionEllipsisMoveUp();
			initSessionEllipsisMoveDown();
			initSessionEllipsisChangeModule();
			initSessionEllipsisDuplicateFrom();
			initSessionEllipsisLinkFrom();
			initSessionEllipsisDelete();
		}
		function initLessonEllipsisListener() {
			initLessonEllipsisEditLessonDetails();
			initLessonEllipsisAddLessonBelow();
			initLessonEllipsisMoveUp();
			initLessonEllipsisMoveDown();
			initLessonEllipsisDelete();
			initLessonEllipsisChangeSession();
			initLessonEllipsisEditLesson();
			initLessonEllipsisAddLearningObjectives();
			initLessonEllipsisPublish();
		}

		function initializeAddModuleButton() {
			$("#addLastModule")
					.click(
							function() {
								if (window.isNewCourse) {
									alert('Please save the course first by clicking on the update detail button!')
								} else {
									$
											.get('./modals/module.jsp')
											.done(
													function(data) {
														$('#modals').html(data);
														$('#moduleModal')
																.modal('toggle');
														initModuleModalImageUploader();
														$('#saveModule')
																.click(
																		function() {
																			var orderID = window.courseTree.length + 1;
																			var isModuleFormOK = false;
																			isModuleFormOK = validateModuleModal();
																			if (isModuleFormOK) {
																				var dataPost = {
																					moduleName : $(
																							'#moduleModalTitle')
																							.val()
																							.trim(),
																					moduleDescription : $(
																							'#moduleModalDescription')
																							.val()
																							.trim(),
																					moduleImageURL : $(
																							'.moduleImage')
																							.attr(
																									'src')
																							.split(
																									'/')
																							.splice(
																									3)
																							.join(
																									'/'),
																					parentCourse : window.courseID,
																					moduleOrderID : orderID
																				};
																				var url = window.content_rest_url
																						+ 'module/create';
																				$
																						.ajax(
																								{
																									type : "POST",
																									url : url,
																									data : JSON
																											.stringify(dataPost),
																								})
																						.done(
																								function(
																										data) {
																									if (data.success) {
																										$(
																												"#skillTree")
																												.jstree(
																														'destroy');
																										$(
																												'#moduleModal')
																												.modal(
																														'toggle');
																										loadCourseTree(
																												animateCourseTreeNode,
																												'M'
																														+ data.moduleID);
																									} else {
																										alert('Contact Support!');
																									}
																								});
																			}
																		});
													});
								}
							});
		}
		function dummyCallBack(callBackParams) {
			console.log(callBackParams);
		}
		function loadCourseTree(callBack, callBackParams) {
			if (callBack === undefined) {
				callBack = dummyCallBack;
			}
			if (callBackParams === undefined) {
				callBackParams = 'Dummy callback!';
			}
			var courseID = $('#courseID').val();
			var url = window.content_rest_url + 'course/getTree/' + courseID;
			var jsonData;
			$
					.get(url, function(data) {
						window.courseTree = data.courseTree;
					})
					.done(
							function() {
								$('#skillTree').bind('loaded.jstree',
										function(e, data) {
											// invoked after jstree has loaded
											callBack(callBackParams);
											callBack = dummyCallBack;
											callBackParams = 'Dummy callback!';
										}).jstree({
									'core' : {
										'check_callback' : true,
										'data' : window.courseTree
									}
								});
								$('#skillTree')
										.on(
												'open_node.jstree',
												function(e, data) {
													if (typeof callBack !== 'undefined'
															&& callBack == dummyCallBack) {
														var nodesToKeepOpen = [];

														// get all parent nodes to keep open
														$('#' + data.node.id)
																.parents(
																		'.jstree-node')
																.each(
																		function() {
																			nodesToKeepOpen
																					.push(this.id);
																		});

														// add current node to keep open
														nodesToKeepOpen
																.push(data.node.id);

														// close all other nodes
														$('.jstree-node')
																.each(
																		function() {
																			if (nodesToKeepOpen
																					.indexOf(this.id) === -1) {
																				$(
																						"#skillTree")
																						.jstree()
																						.close_node(
																								this.id);
																			}
																		})
													}
												});
							});
		}
		function initializeCourseTreeVariables() {
			window.courseTree = {};
			window.isNewCourse = ($('#isNewCourse').val() == 'true');
			if (!isNewCourse) {
				window.courseID = $('#courseID').val();
			}
			window.cdnPath = $('#cdnPath').val();
			window.content_rest_url = $('#content_rest_url').val();
		}
		function validateModuleModal() {
			var isModalOK = true;
			if ($('#moduleModalTitle').val().trim() == '') {
				$('#moduleModalTitle').addClass('faultyFormElement');
				$('#moduleModalTitle').focus();
				isModalOK = false;
			} else {
				$('#moduleModalTitle').removeClass('faultyFormElement');
			}
			if ($('#moduleModalDescription').val().trim() == '') {
				$('#moduleModalDescription').addClass('faultyFormElement');
				$('#moduleModalDescription').focus();
				isModalOK = false;
			} else {
				$('#moduleModalDescription').removeClass('faultyFormElement');
			}
			return isModalOK;
		}

		function initializeUpdateCourseDetailsButton() {
			$('#updateCourseDetails').click(function() {
				createUpdateCourse();
			});
		}

		function createUpdateCourse() {
			var isCourseFormValid = validateCourseEditFields();
			if (isCourseFormValid) {
				var dataPost = {
					courseName : $('#courseName').val().trim(),
					courseDescription : $('#courseDesc').val().trim(),
					courseCategory : $('#courseCategory').val().trim(),
					courseImageURL : $('#courseImage').attr('src').split('/')
							.splice(3).join('/')
				};

				if (window.isNewCourse) {
					var url = window.content_rest_url + 'course/create';
				} else {
					var url = window.content_rest_url + 'course/update/'
							+ window.courseID;
				}
				$.ajax({
					type : "POST",
					url : url,
					data : JSON.stringify(dataPost),
				}).done(
						function(data) {
							window.location.replace('./editCourse.jsp?course='
									+ data.courseID)
						});
			}
		}

		function validateCourseEditFields() {
			var isCourseFormOK = true;
			if ($('#courseName').val().trim() == '') {
				$('#courseName').addClass('faultyFormElement');
				$('#courseName').focus();
				isCourseFormOK = false;
			} else {
				$('#courseName').removeClass('faultyFormElement');
			}
			if ($('#courseDesc').val().trim() == '') {
				$('#courseDesc').addClass('faultyFormElement');
				$('#courseDesc').focus();
				isCourseFormOK = false;
			} else {
				$('#courseDesc').removeClass('faultyFormElement');
			}
			if ($('#courseCategory').val().trim() == '') {
				$('#courseCategory').addClass('faultyFormElement');
				$('#courseCategory').focus();
				isCourseFormOK = false;
			} else {
				$('#courseCategory').removeClass('faultyFormElement');
			}
			return isCourseFormOK;
		}

		function fillCourseEditFormFields() {
			if (!window.isNewCourse) {
				$.get(
						window.content_rest_url + 'course/read/'
								+ window.courseID).done(
						function(courseObject) {
							$('#coursePageHeading').html(
									courseObject.course.title);
							$('#courseName').val(courseObject.course.title);
							$('#courseDesc').val(
									courseObject.course.description);
							$('#courseImage').attr(
									'src',
									window.cdnPath
											+ courseObject.course.imageURL);
							$('#courseCategory').val(
									courseObject.course.category);
						});
			}
		}

		function initializeCourseImageUploader() {
			$('#courseImageURL')
					.change(
							function() {
								if (document.getElementById('courseImageURL').files.length > 0) {
									var data = new FormData();
									var imageFile = document
											.getElementById('courseImageURL').files[0];
									data.append('image', imageFile);
									$.ajax(
											{
												url : window.content_rest_url
														+ 'file/imageupload',
												data : data,
												cache : false,
												contentType : false,
												processData : false,
												type : 'POST',
											}).done(
											function(response) {
												$('#courseImage').attr('src',
														response);
											});
								} else {
									console.log('No image found!');
								}
							});
		}
		function initModuleModalImageUploader() {
			$('#moduleImageURL')
					.change(
							function() {
								if (document.getElementById('moduleImageURL').files.length > 0) {
									var data = new FormData();
									var imageFile = document
											.getElementById('moduleImageURL').files[0];
									data.append('image', imageFile);
									$.ajax(
											{
												url : window.content_rest_url
														+ 'file/imageupload',
												data : data,
												cache : false,
												contentType : false,
												processData : false,
												type : 'POST',
											}).done(
											function(response) {
												$('.moduleImage').attr('src',
														response);
											});
								} else {
									console.log('No image found!');
								}
							});
		}
		function initSessionModalImageUploader() {
			$('#sessionImageURL')
					.change(
							function() {
								if (document.getElementById('sessionImageURL').files.length > 0) {
									var data = new FormData();
									var imageFile = document
											.getElementById('sessionImageURL').files[0];
									data.append('image', imageFile);
									$.ajax(
											{
												url : window.content_rest_url
														+ 'file/imageupload',
												data : data,
												cache : false,
												contentType : false,
												processData : false,
												type : 'POST',
											}).done(
											function(response) {
												$('.sessionImage').attr('src',
														response);
											});
								} else {
									console.log('No image found!');
								}
							});
		}
		function initLessonModalImageUploader() {
			$('#lessonImageURL')
					.change(
							function() {
								if (document.getElementById('lessonImageURL').files.length > 0) {
									var data = new FormData();
									var imageFile = document
											.getElementById('lessonImageURL').files[0];
									data.append('image', imageFile);
									$.ajax(
											{
												url : window.content_rest_url
														+ 'file/imageupload',
												data : data,
												cache : false,
												contentType : false,
												processData : false,
												type : 'POST',
											}).done(
											function(response) {
												$('.lessonImage').attr('src',
														response);
											});
								} else {
									console.log('No image found!');
								}
							});
		}
		function initModuleEllipsisEditModule() {
			$(document)
					.on(
							'click',
							'.editModule',
							function() {
								var chosenModuleID = $(this).data('moduleid');
								$
										.get('./modals/module.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													$
															.get(
																	window.content_rest_url
																			+ 'module/read/'
																			+ chosenModuleID)
															.done(
																	function(
																			moduleObject) {
																		$(
																				'#moduleModalTitle')
																				.val(
																						moduleObject.module.title);
																		$(
																				'#moduleModalDescription')
																				.val(
																						moduleObject.module.description);
																		$(
																				'.moduleImage')
																				.attr(
																						'src',
																						window.cdnPath
																								+ moduleObject.module.imageURL);
																		initModuleModalImageUploader();
																		$(
																				'#moduleModal')
																				.modal(
																						'toggle');
																		$(
																				'#saveModule')
																				.click(
																						function() {
																							var isModuleFormOK = false;
																							isModuleFormOK = validateModuleModal();
																							if (isModuleFormOK) {
																								var dataPost = {
																									moduleName : $(
																											'#moduleModalTitle')
																											.val()
																											.trim(),
																									moduleDescription : $(
																											'#moduleModalDescription')
																											.val()
																											.trim(),
																									moduleImageURL : $(
																											'.moduleImage')
																											.attr(
																													'src')
																											.split(
																													'/')
																											.splice(
																													3)
																											.join(
																													'/'),
																								};
																								var url = window.content_rest_url
																										+ 'module/update/'
																										+ chosenModuleID;
																								$
																										.ajax(
																												{
																													type : "POST",
																													url : url,
																													data : JSON
																															.stringify(dataPost),
																												})
																										.done(
																												function(
																														data) {
																													//update the node

																													$(
																															'#moduleModal')
																															.modal(
																																	'toggle');
																													console
																															.log('Module updated!');
																													$(
																															"#skillTree")
																															.jstree(
																																	'destroy');
																													if (!data.success) {
																														alert('Module changes couldnt be saved. Contact Support if problem persists!');
																													}
																													loadCourseTree(
																															animateCourseTreeNode,
																															'M'
																																	+ chosenModuleID);
																												});

																							}
																						});
																	});

												});
							});

		}
		function animateCourseTreeNode(entityID) {
			$('#skillTree').jstree(true).get_node(entityID, true).children(
					'.jstree-anchor').focus();
			$('#skillTree').jstree(true).get_node(entityID, true).children(
					'.jstree-anchor').addClass('champa');
		}
		function animateChildNode(entityID) {
			//var moduleNode = $('#skillTree').jstree(true).get_parent(entityID, true);
			//$('#skillTree').jstree(true).open_node(moduleNode);
			$('#skillTree').jstree(true)._open_to(entityID, true).focus();
			$('#skillTree').jstree(true).get_node(entityID, true).children(
					'.jstree-anchor').focus();
			$('#skillTree').jstree(true).get_node(entityID, true).children(
					'.jstree-anchor').addClass('champa');
		}
		function initModuleEllipsisAddSession() {
			$(document)
					.on(
							'click',
							'.addSession',
							function() {
								var chosenModuleID = $(this).data('moduleid');
								var nodeID = 'M' + chosenModuleID;
								var orderID = $('#skillTree').jstree(true)
										.get_node(nodeID).children.length + 1;
								$
										.get('./modals/cmsession.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													$('#sessionModal').modal(
															'toggle');
													initSessionModalImageUploader();
													$('#saveSession')
															.click(
																	function() {
																		var isSessionFormOK = false;
																		isSessionFormOK = validateSessionModal();
																		if (isSessionFormOK) {
																			var dataPost = {
																				sessionName : $(
																						'#sessionModalTitle')
																						.val()
																						.trim(),
																				sessionDescription : $(
																						'#sessionModalDescription')
																						.val()
																						.trim(),
																				sessionImageURL : $(
																						'.sessionImage')
																						.attr(
																								'src')
																						.split(
																								'/')
																						.splice(
																								3)
																						.join(
																								'/'),
																				parentModule : chosenModuleID,
																				sessionOrderID : orderID
																			};
																			var url = window.content_rest_url
																					+ 'session/create';
																			$
																					.ajax(
																							{
																								type : "POST",
																								url : url,
																								data : JSON
																										.stringify(dataPost),
																							})
																					.done(
																							function(
																									data) {
																								//update the node
																								if (data.success) {
																									$(
																											'#sessionModal')
																											.modal(
																													'toggle');
																									console
																											.log('Session updated!');
																									$(
																											"#skillTree")
																											.jstree(
																													'destroy');
																									loadCourseTree(
																											animateChildNode,
																											'S'
																													+ data.sessionID);
																								} else {
																									alert('Something went wrong. Please try again.');
																								}
																							});
																		}

																	});
												});
							});
		}

		function validateSessionModal() {
			var isModalOK = true;
			if ($('#sessionModalTitle').val().trim() == '') {
				$('#sessionModalTitle').addClass('faultyFormElement');
				$('#sessionModalTitle').focus();
				isModalOK = false;
			} else {
				$('#sessionModalTitle').removeClass('faultyFormElement');
			}
			if ($('#sessionModalDescription').val().trim() == '') {
				$('#sessionModalDescription').addClass('faultyFormElement');
				$('#sessionModalDescription').focus();
				isModalOK = false;
			} else {
				$('#sessionModalDescription').removeClass('faultyFormElement');
			}
			return isModalOK;
		}
		function validateLessonModal() {
			var isModalOK = true;
			if ($('#lessonModalTitle').val().trim() == '') {
				$('#lessonModalTitle').addClass('faultyFormElement');
				$('#lessonModalTitle').focus();
				isModalOK = false;
			} else {
				$('#lessonModalTitle').removeClass('faultyFormElement');
			}
			if ($('#lessonModalDescription').val().trim() == '') {
				$('#lessonModalDescription').addClass('faultyFormElement');
				$('#lessonModalDescription').focus();
				isModalOK = false;
			} else {
				$('#lessonModalDescription').removeClass('faultyFormElement');
			}
			if ($('#lessonModalType').val() == null) {
				$('#lessonModalType').addClass('faultyFormElement');
				$('#lessonModalType').focus();
				isModalOK = false;
			} else {
				$('#lessonModalType').removeClass('faultyFormElement');
			}
			if ($('#lessonModalDuration').val() == ''
					|| $('#lessonModalDuration').val() == null) {
				$('#lessonModalDuration').addClass('faultyFormElement');
				$('#lessonModalDuration').focus();
				isModalOK = false;
			} else {
				$('#lessonModalDuration').removeClass('faultyFormElement');
			}
			return isModalOK;
		}

		function initModuleEllipsisAddModuleBelow() {
			$(document)
					.on(
							'click',
							'.addModuleAfter',
							function() {
								var orderID = parseInt($(this).data(
										'moduleOrderID')) + 1;
								$
										.get('./modals/module.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													$('#moduleModal').modal(
															'toggle');
													initModuleModalImageUploader();
													$('#saveModule')
															.click(
																	function() {
																		var orderID = window.courseTree.length + 1;
																		var isModuleFormOK = false;
																		isModuleFormOK = validateModuleModal();
																		if (isModuleFormOK) {
																			var dataPost = {
																				moduleName : $(
																						'#moduleModalTitle')
																						.val()
																						.trim(),
																				moduleDescription : $(
																						'#moduleModalDescription')
																						.val()
																						.trim(),
																				moduleImageURL : $(
																						'.moduleImage')
																						.attr(
																								'src')
																						.split(
																								'/')
																						.splice(
																								3)
																						.join(
																								'/'),
																				parentCourse : window.courseID,
																				moduleOrderID : orderID
																			};
																			var url = window.content_rest_url
																					+ 'module/create';
																			$
																					.ajax(
																							{
																								type : "POST",
																								url : url,
																								data : JSON
																										.stringify(dataPost),
																							})
																					.done(
																							function(
																									data) {
																								$(
																										"#skillTree")
																										.jstree(
																												'destroy');
																								$(
																										'#moduleModal')
																										.modal(
																												'toggle');
																								loadCourseTree(
																										animateCourseTreeNode,
																										'M'
																												+ data.moduleID);
																							});
																		}
																	});
												});
							});
		}

		function initModuleEllipsisMoveUp() {
			$(document)
					.on(
							'click',
							'.moveModuleUp',
							function() {
								var chosenModuleID = $(this).data('moduleid');
								var currentOrderID = parseInt($(this).data(
										'moduleorderid'));
								var newOrderID = parseInt($(this).data(
										'moduleorderid')) - 1;
								var dataPost = {
									parentCourse : window.courseID,
									currentModuleOrderID : currentOrderID,
									newModuleOrderID : newOrderID
								};
								var url = window.content_rest_url
										+ 'module/reorder';
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(
										function(data) {
											$("#skillTree").jstree('destroy');
											loadCourseTree(
													animateCourseTreeNode, 'M'
															+ chosenModuleID);
										});
							});
		}

		function initModuleEllipsisMoveDown() {
			$(document)
					.on(
							'click',
							'.moveModuleDown',
							function() {
								var chosenModuleID = $(this).data('moduleid');
								var currentOrderID = parseInt($(this).data(
										'moduleorderid'));
								var newOrderID = parseInt($(this).data(
										'moduleorderid')) + 1;
								var dataPost = {
									parentCourse : window.courseID,
									currentModuleOrderID : currentOrderID,
									newModuleOrderID : newOrderID
								};
								var url = window.content_rest_url
										+ 'module/reorder';
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(
										function(data) {
											$("#skillTree").jstree('destroy');
											loadCourseTree(
													animateCourseTreeNode, 'M'
															+ chosenModuleID);
										});
							});
		}

		function initModuleEllipsisDelete() {
			$(document).on(
					'click',
					'.deleteModule',
					function() {
						var chosenModuleID = $(this).data('moduleid');
						var nodeID = 'M' + chosenModuleID;
						var node = $('#skillTree').jstree(true)
								.get_node(nodeID);
						if (node.children.length != 0) {
							alert('Module is not empty, cant be deleted!');
						} else {
							$.get(
									window.content_rest_url + 'module/delete/'
											+ chosenModuleID).done(
									function(response) {
										$("#skillTree").jstree('destroy');
										loadCourseTree();
									});
						}
					});
		}

		function initSessionEllipsisEditSession() {
			$(document)
					.on(
							'click',
							'.editSession',
							function() {
								var chosenSessionID = $(this).data(
										'cmsessionid');
								$
										.get('./modals/cmsession.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													$
															.get(
																	window.content_rest_url
																			+ 'session/read/'
																			+ chosenSessionID)
															.done(
																	function(
																			sessionObject) {
																		$(
																				'#sessionModalTitle')
																				.val(
																						sessionObject.session.title);
																		$(
																				'#sessionModalDescription')
																				.val(
																						sessionObject.session.description);
																		$(
																				'.sessionImage')
																				.attr(
																						'src',
																						window.cdnPath
																								+ sessionObject.session.imageURL);
																		$(
																				'#sessionModal')
																				.modal(
																						'toggle');
																		initSessionModalImageUploader();
																		$(
																				'#saveSession')
																				.click(
																						function() {
																							var isSessionFormOK = false;
																							isSessionFormOK = validateSessionModal();
																							if (isSessionFormOK) {
																								var dataPost = {
																									sessionName : $(
																											'#sessionModalTitle')
																											.val()
																											.trim(),
																									sessionDescription : $(
																											'#sessionModalDescription')
																											.val()
																											.trim(),
																									sessionImageURL : $(
																											'.sessionImage')
																											.attr(
																													'src')
																											.split(
																													'/')
																											.splice(
																													3)
																											.join(
																													'/')
																								};
																								var url = window.content_rest_url
																										+ 'session/update/'
																										+ chosenSessionID;
																								$
																										.ajax(
																												{
																													type : "POST",
																													url : url,
																													data : JSON
																															.stringify(dataPost),
																												})
																										.done(
																												function(
																														data) {
																													//update the node
																													if (data.success) {
																														$(
																																'#sessionModal')
																																.modal(
																																		'toggle');
																														console
																																.log('Session updated!');
																														$(
																																"#skillTree")
																																.jstree(
																																		'destroy');
																														loadCourseTree(
																																animateChildNode,
																																'S'
																																		+ chosenSessionID);
																													} else {
																														alert('Something went wrong. Session couldnt be updated!');
																													}
																												});

																							}
																						});
																	});

												});
							});
		}

		function initSessionEllipsisAddLesson() {
			$(document)
					.on(
							'click',
							'.addLesson',
							function() {
								var chosenSessionID = $(this).data(
										'cmsessionid');
								var nodeID = 'S' + chosenSessionID;
								var orderID = $('#skillTree').jstree(true)
										.get_node(nodeID).children.length + 1;
								$
										.get('./modals/lesson.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													initLessonModalImageUploader();
													$('#lessonModal').modal(
															'toggle');
													$('#saveLesson')
															.click(
																	function() {
																		var isLessonFormOK = false;
																		isLessonFormOK = validateLessonModal();
																		if (isLessonFormOK) {
																			var dataPost = {
																				lessonName : $(
																						'#lessonModalTitle')
																						.val()
																						.trim(),
																				lessonDescription : $(
																						'#lessonModalDescription')
																						.val()
																						.trim(),
																				lessonImageURL : $(
																						'.lessonImage')
																						.attr(
																								'src')
																						.split(
																								'/')
																						.splice(
																								3)
																						.join(
																								'/'),
																				lessonType : $(
																						'#lessonModalType')
																						.val(),
																				lessonDuration : $(
																						'#lessonModalDuration')
																						.val(),
																				lessonCourse : window.courseID,
																				parentSession : chosenSessionID,
																				lessonOrderID : orderID
																			};
																			var url = window.content_rest_url
																					+ 'lesson/create';
																			$
																					.ajax(
																							{
																								type : "POST",
																								url : url,
																								data : JSON
																										.stringify(dataPost),
																							})
																					.done(
																							function(
																									data) {
																								//update the node
																								if (data.success) {
																									$(
																											'#lessonModal')
																											.modal(
																													'toggle');
																									console
																											.log('Lesson updated!');
																									$(
																											"#skillTree")
																											.jstree(
																													'destroy');
																									loadCourseTree(
																											animateChildNode,
																											'L'
																													+ data.lessonID);
																								} else {
																									alert('Something went wrong. Couldnt create the lesson.');
																								}
																							});
																		}

																	});
												});
							});
		}

		function initSessionEllipsisAddSessionBelow() {
			$(document)
					.on(
							'click',
							'.addSessionAfter',
							function() {
								var orderID = parseInt($(this).data(
										'cmsessionorderid')) + 1;
								var chosenSessionID = $(this).data(
										'cmsessionid');
								var chosenSessionNode = $('#skillTree').jstree(
										true).get_node('S' + chosenSessionID);
								var parentModuleID = $('#skillTree').jstree(
										true).get_parent(chosenSessionNode)
										.substring(1);
								$
										.get('./modals/cmsession.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													initSessionModalImageUploader();
													$('#sessionModal').modal(
															'toggle');
													$('#saveSession')
															.click(
																	function() {
																		var isSessionFormOK = false;
																		isSessionFormOK = validateSessionModal();
																		if (isSessionFormOK) {
																			var dataPost = {
																				sessionName : $(
																						'#sessionModalTitle')
																						.val()
																						.trim(),
																				sessionDescription : $(
																						'#sessionModalDescription')
																						.val()
																						.trim(),
																				sessionImageURL : $(
																						'.sessionImage')
																						.attr(
																								'src')
																						.split(
																								'/')
																						.splice(
																								3)
																						.join(
																								'/'),
																				parentModule : parentModuleID,
																				sessionOrderID : orderID
																			};
																			var url = window.content_rest_url
																					+ 'session/create';
																			$
																					.ajax(
																							{
																								type : "POST",
																								url : url,
																								data : JSON
																										.stringify(dataPost),
																							})
																					.done(
																							function(
																									data) {
																								if (data.success) {
																									$(
																											'#sessionModal')
																											.modal(
																													'toggle');
																									console
																											.log('Session updated!');
																									$(
																											"#skillTree")
																											.jstree(
																													'destroy');
																									loadCourseTree(
																											animateChildNode,
																											'S'
																													+ data.sessionID);
																								} else {
																									alert('Something went wrong. Please try again.');
																								}
																							});
																		}
																	});
												});
							});
		}

		function initSessionEllipsisMoveUp() {
			$(document).on(
					'click',
					'.moveSessionUp',
					function() {
						var chosenSessionID = $(this).data('cmsessionid');
						var chosenSessionNode = $('#skillTree').jstree(true)
								.get_node('S' + chosenSessionID);
						var parentModuleID = $('#skillTree').jstree(true)
								.get_parent(chosenSessionNode).substring(1);
						var currentOrderID = parseInt($(this).data(
								'cmsessionorderid'));
						var newOrderID = parseInt($(this).data(
								'cmsessionorderid')) - 1;
						var dataPost = {
							parentModule : parentModuleID,
							currentSessionOrderID : currentOrderID,
							newSessionOrderID : newOrderID
						};
						var url = window.content_rest_url + 'session/reorder/';
						$.ajax({
							type : "POST",
							url : url,
							data : JSON.stringify(dataPost),
						}).done(
								function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree(animateChildNode, 'S'
											+ chosenSessionID);
								});
					});
		}

		function initSessionEllipsisMoveDown() {
			$(document).on(
					'click',
					'.moveSessionDown',
					function() {
						var chosenSessionID = $(this).data('cmsessionid');
						var chosenSessionNode = $('#skillTree').jstree(true)
								.get_node('S' + chosenSessionID);
						var parentModuleID = $('#skillTree').jstree(true)
								.get_parent(chosenSessionNode).substring(1);
						var currentOrderID = parseInt($(this).data(
								'cmsessionorderid'));
						var newOrderID = parseInt($(this).data(
								'cmsessionorderid')) + 1;
						var dataPost = {
							parentModule : parentModuleID,
							currentSessionOrderID : currentOrderID,
							newSessionOrderID : newOrderID
						};
						var url = window.content_rest_url + 'session/reorder/';
						$.ajax({
							type : "POST",
							url : url,
							data : JSON.stringify(dataPost),
						}).done(
								function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree(animateChildNode, 'S'
											+ chosenSessionID);
								});
					});
		}

		function initSessionEllipsisChangeModule() {
			$(document)
					.on(
							'click',
							'.changeModule',
							function() {
								//alert('Features work under progress.');
								var chosenSessionID = $(this).data(
										'cmsessionid');
								var chosenSessionNode = $('#skillTree').jstree(
										true).get_node('S' + chosenSessionID);
								var parentModuleID = $('#skillTree').jstree(
										true).get_parent(chosenSessionNode)
										.substring(1);
								$
										.get('./modals/changeModule.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													var optionData = '';
													$
															.each(
																	window.courseTree,
																	function(i,
																			v) {
																		if (v.id
																				.substring(1) !== parentModuleID) {
																			optionData += '<option id='
																					+ v.id
																							.substring(1)
																					+ '>';
																			optionData += v.moduleTitle;
																			optionData += '</option>';
																		}
																	});
													$('#chooseModule').append(
															optionData);
													$('#changeModuleModal')
															.modal('toggle');
													$(
															'#changeModuleModalSubmit')
															.click(
																	function() {
																		if ($(
																				'#chooseModule')
																				.children(
																						":selected")
																				.attr(
																						"id") !== undefined) {
																			var dataPost = {
																				chosenSessionID : chosenSessionID,
																				currentParentModuleID : parentModuleID,
																				newParentModuleID : $(
																						'#chooseModule')
																						.children(
																								":selected")
																						.attr(
																								"id")
																			};
																			var url = window.content_rest_url
																					+ 'session/changeParentModule/';
																			$
																					.ajax(
																							{
																								type : "POST",
																								url : url,
																								data : JSON
																										.stringify(dataPost),
																							})
																					.done(
																							function(
																									data) {
																								if (data.success) {
																									$(
																											'#changeModuleModal')
																											.modal(
																													'toggle');
																									console
																											.log('Module changed!');
																									$(
																											"#skillTree")
																											.jstree(
																													'destroy');
																									loadCourseTree(
																											animateChildNode,
																											'S'
																													+ chosenSessionID);
																								} else {
																									alert('Something went wrong. Couldnt move the session.');
																								}
																							});

																		} else {
																			$(
																					'#chooseModule')
																					.addClass(
																							'faultyFormElement');
																		}
																	});
												});
							});
		}

		function initSessionEllipsisDelete() {
			$(document).on(
					'click',
					'.deleteSession',
					function() {
						var chosenSessionID = $(this).data('cmsessionid');
						var nodeID = 'S' + chosenSessionID;
						var node = $('#skillTree').jstree(true)
								.get_node(nodeID);
						if (node.children.length != 0) {
							alert('Session is not empty, can"t be deleted!');
						} else {
							$.get(
									window.content_rest_url + 'session/delete/'
											+ chosenSessionID).done(
									function(response) {
										$("#skillTree").jstree('destroy');
										loadCourseTree();
									});
						}
					});
		}

		function initLessonEllipsisEditLessonDetails() {
			$(document)
					.on(
							'click',
							'.editLesson',
							function() {
								var chosenLessonID = $(this).data('lessonid');
								$
										.get('./modals/lesson.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													$
															.get(
																	window.content_rest_url
																			+ 'lesson/read/'
																			+ chosenLessonID)
															.done(
																	function(
																			lessonObject) {
																		$(
																				'#lessonModalTitle')
																				.val(
																						lessonObject.lesson.title);
																		$(
																				'#lessonModalDescription')
																				.val(
																						lessonObject.lesson.description);
																		$(
																				'.lessonImage')
																				.attr(
																						'src',
																						window.cdnPath
																								+ lessonObject.lesson.imageURL);
																		$(
																				'#lessonModalType')
																				.val(
																						lessonObject.lesson.type);
																		$(
																				'#lessonModalType')
																				.prop(
																						'disabled',
																						'disabled');
																		$(
																				'#lessonModalDuration')
																				.val(
																						parseInt(lessonObject.lesson.duration));
																		initLessonModalImageUploader();
																		$(
																				'#lessonModal')
																				.modal(
																						'toggle');
																		$(
																				'#saveLesson')
																				.click(
																						function() {
																							var isLessonFormOK = false;
																							isLessonFormOK = validateLessonModal();
																							if (isLessonFormOK) {
																								var dataPost = {
																									lessonName : $(
																											'#lessonModalTitle')
																											.val()
																											.trim(),
																									lessonDescription : $(
																											'#lessonModalDescription')
																											.val()
																											.trim(),
																									lessonImageURL : $(
																											'.lessonImage')
																											.attr(
																													'src')
																											.split(
																													'/')
																											.splice(
																													3)
																											.join(
																													'/'),
																									lessonDuration : $(
																											'#lessonModalDuration')
																											.val()
																								};
																								var url = window.content_rest_url
																										+ 'lesson/update/'
																										+ chosenLessonID;
																								$
																										.ajax(
																												{
																													type : "POST",
																													url : url,
																													data : JSON
																															.stringify(dataPost),
																												})
																										.done(
																												function(
																														data) {
																													if (data.success) {
																														$(
																																'#lessonModal')
																																.modal(
																																		'toggle');
																														console
																																.log('Lesson updated!');
																														$(
																																"#skillTree")
																																.jstree(
																																		'destroy');
																														loadCourseTree(
																																animateChildNode,
																																'L'
																																		+ data.lessonID);
																													} else {
																														alert('Something went wrong. Couldnt create the lesson.');
																													}
																												});

																							}
																						});
																	});

												});
							});
		}

		function initLessonEllipsisAddLessonBelow() {
			$(document)
					.on(
							'click',
							'.addLessonAfter',
							function() {
								var orderID = parseInt($(this).data(
										'lessonorderid')) + 1;
								var chosenLessonID = $(this).data('lessonid');
								var chosenLessonNode = $('#skillTree').jstree(
										true).get_node('L' + chosenLessonID);
								var parentSessionID = $('#skillTree').jstree(
										true).get_parent(chosenLessonNode)
										.substring(1);
								$
										.get('./modals/lesson.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													initLessonModalImageUploader();
													$('#lessonModal').modal(
															'toggle');
													$('#saveLesson')
															.click(
																	function() {
																		var isLessonFormOK = false;
																		isLessonFormOK = validateLessonModal();
																		if (isLessonFormOK) {
																			var dataPost = {
																				lessonName : $(
																						'#lessonModalTitle')
																						.val()
																						.trim(),
																				lessonDescription : $(
																						'#lessonModalDescription')
																						.val()
																						.trim(),
																				lessonImageURL : $(
																						'.lessonImage')
																						.attr(
																								'src')
																						.split(
																								'/')
																						.splice(
																								3)
																						.join(
																								'/'),
																				lessonType : $(
																						'#lessonModalType')
																						.val(),
																				lessonDuration : $(
																						'#lessonModalDuration')
																						.val(),
																				lessonCourse : window.courseID,
																				parentSession : parentSessionID,
																				lessonOrderID : orderID
																			};
																			var url = window.content_rest_url
																					+ 'lesson/create';
																			$
																					.ajax(
																							{
																								type : "POST",
																								url : url,
																								data : JSON
																										.stringify(dataPost),
																							})
																					.done(
																							function(
																									data) {
																								if (data.success) {
																									$(
																											'#lessonModal')
																											.modal(
																													'toggle');
																									console
																											.log('Lesson updated!');
																									$(
																											"#skillTree")
																											.jstree(
																													'destroy');
																									loadCourseTree(
																											animateChildNode,
																											'L'
																													+ data.lessonID);
																								} else {
																									alert('Something went wrong. Couldnt create the lesson.');
																								}
																							});
																		}
																	});
												});
							});
		}

		function initLessonEllipsisMoveUp() {
			$(document)
					.on(
							'click',
							'.moveLessonUp',
							function() {
								var chosenLessonID = $(this).data('lessonid');
								var chosenLessonNode = $('#skillTree').jstree(
										true).get_node('L' + chosenLessonID);
								var parentSessionID = $('#skillTree').jstree(
										true).get_parent(chosenLessonNode)
										.substring(1);
								var currentOrderID = parseInt($(this).data(
										'lessonorderid'));
								var newOrderID = parseInt($(this).data(
										'lessonorderid')) - 1;
								var dataPost = {
									parentSession : parentSessionID,
									currentLessonOrderID : currentOrderID,
									newLessonOrderID : newOrderID
								};
								var url = window.content_rest_url
										+ 'lesson/reorder/';
								$
										.ajax({
											type : "POST",
											url : url,
											data : JSON.stringify(dataPost),
										})
										.done(
												function(data) {
													if (data.success) {
														console
																.log('Lesson reordered!');
														$("#skillTree").jstree(
																'destroy');
														loadCourseTree(
																animateChildNode,
																'L'
																		+ chosenLessonID);
													} else {
														alert('Something went wrong. Couldnt reorder the lesson.');
													}
												});
							});
		}

		function initLessonEllipsisMoveDown() {
			$(document)
					.on(
							'click',
							'.moveLessonDown',
							function() {
								var chosenLessonID = $(this).data('lessonid');
								var chosenLessonNode = $('#skillTree').jstree(
										true).get_node('L' + chosenLessonID);
								var parentSessionID = $('#skillTree').jstree(
										true).get_parent(chosenLessonNode)
										.substring(1);
								var currentOrderID = parseInt($(this).data(
										'lessonorderid'));
								var newOrderID = parseInt($(this).data(
										'lessonorderid')) + 1;
								var dataPost = {
									parentSession : parentSessionID,
									currentLessonOrderID : currentOrderID,
									newLessonOrderID : newOrderID
								};
								var url = window.content_rest_url
										+ 'lesson/reorder/';
								$
										.ajax({
											type : "POST",
											url : url,
											data : JSON.stringify(dataPost),
										})
										.done(
												function(data) {
													if (data.success) {
														console
																.log('Lesson reordered!');
														$("#skillTree").jstree(
																'destroy');
														loadCourseTree(
																animateChildNode,
																'L'
																		+ chosenLessonID);
													} else {
														alert('Something went wrong. Couldnt reorder the lesson.');
													}
												});
							});
		}
		function initLessonEllipsisDelete() {
			$(document).on(
					'click',
					'.deleteLesson',
					function() {
						var chosenLessonID = $(this).data('lessonid');
						$.get(
								window.content_rest_url + 'lesson/delete/'
										+ chosenLessonID).done(
								function(response) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
									//open the session NOde TO|DO
								});
					});
		}

		function initLessonEllipsisChangeSession() {
			//TO DO
			$(document)
					.on(
							'click',
							'.changeSession',
							function() {
								var chosenLessonID = $(this).data('lessonid');
								var chosenLessonNode = $('#skillTree').jstree(
										true).get_node('L' + chosenLessonID);
								var parentSessionID = $('#skillTree').jstree(
										true).get_parent(chosenLessonNode)
										.substring(1);
								$
										.get('./modals/changeSession.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													var optionData = '';
													$
															.each(
																	window.courseTree,
																	function(i,
																			v) {
																		optionData += '<option id='
																				+ v.id
																						.substring(1)
																				+ '>';
																		optionData += v.moduleTitle;
																		optionData += '</option>';
																	});
													$('#chooseModule').append(
															optionData);
													$('#changeSessionModal')
															.modal('toggle');
													$('#chooseModule')
															.on(
																	'change',
																	function(e) {
																		if ($(
																				'#chooseModule')
																				.children(
																						":selected")
																				.attr(
																						"id") !== undefined) {
																			var chosenModalModuleID = $(
																					'#chooseModule')
																					.children(
																							":selected")
																					.attr(
																							"id");
																			$
																					.each(
																							window.courseTree,
																							function(
																									a,
																									b) {
																								if (b.id == 'M'
																										+ chosenModalModuleID) {
																									var sessionSelectHTML = '';
																									$
																											.each(
																													b.children,
																													function(
																															c,
																															d) {
																														if (d.id
																																.substring(1) !== parentSessionID) {
																															sessionSelectHTML += '<option id='
																																	+ d.id
																																			.substring(1)
																																	+ '>';
																															sessionSelectHTML += d.sessionTitle;
																															sessionSelectHTML += '</option>';
																														}
																													});
																									$(
																											'#chooseSession')
																											.html(
																													sessionSelectHTML);
																									$(
																											'#changeSessionModalSubmit')
																											.click(
																													function() {
																														if ($(
																																'#chooseSession')
																																.children(
																																		":selected")
																																.attr(
																																		"id") !== undefined) {
																															$(
																																	'#chooseSession')
																																	.removeClass(
																																			'faultyFormElement');

																															var dataPost = {
																																chosenLessonID : chosenLessonID,
																																currentParentSessionID : parentSessionID,
																																newParentSessionID : $(
																																		'#chooseSession')
																																		.children(
																																				":selected")
																																		.attr(
																																				"id")
																															};
																															var url = window.content_rest_url
																																	+ 'lesson/changeParentSession/';
																															$
																																	.ajax(
																																			{
																																				type : "POST",
																																				url : url,
																																				data : JSON
																																						.stringify(dataPost),
																																			})
																																	.done(
																																			function(
																																					data) {
																																				if (data.success) {
																																					$(
																																							'#changeSessionModal')
																																							.modal(
																																									'toggle');
																																					console
																																							.log('Session changed!');
																																					$(
																																							"#skillTree")
																																							.jstree(
																																									'destroy');
																																					loadCourseTree(
																																							animateChildNode,
																																							'L'
																																									+ chosenLessonID);
																																				} else {
																																					alert('Something went wrong. Couldnt move the lesson.');
																																				}
																																			});

																														} else {
																															$(
																																	'#chooseSession')
																																	.addClass(
																																			'faultyFormElement');
																														}
																													});
																								}
																							})

																		} else {
																			$(
																					'#chooseModule')
																					.addClass(
																							'faultyFormElement');
																		}
																	});
												});
							});
		}

		function initLessonEllipsisAddLearningObjectives() {
			$(document)
					.on(
							'click',
							'.addLOs',
							function() {
								var chosenLessonID = $(this).data('lessonid');
								$
										.get(
												'./modals/addLearningObjectives.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													$
															.get(
																	window.content_rest_url
																			+ 'learningObjective/getLesonLO/'
																			+ chosenLessonID
																			+ '/'
																			+ window.courseID)
															.done(
																	function(
																			response) {
																		var loaddition = '';
																		$
																				.each(
																						response.learningObjectives,
																						function(
																								a,
																								b) {
																							loaddition += "<li class='selectedLO list-group-item' id='"
																									+ b.id
																									+ "'>"
																									+ b.text
																									+ "</li>";
																						});
																		$(
																				'#selectedLOs')
																				.append(
																						loaddition);
																		$(
																				'#loModal')
																				.modal(
																						'toggle');
																		initLearningObjectiveSearch(chosenLessonID);
																		initRemoveSelectedLO(chosenLessonID);
																	});
												});
							});
		}

		function initLearningObjectiveSearch(chosenLessonID) {
			$('#searchLO')
					.on(
							"keyup",
							function(e) {
								if (e.which == 13) {
									var searchString = $('#searchLO').val()
											.trim();
									if (searchString != ''
											&& searchString.length > 3) {
										$
												.get(
														window.content_rest_url
																+ 'learningObjective/create/'
																+ searchString)
												.done(
														function(response) {
															if (response.success) {
																var searchResults = '';
																searchResults += "<li class='searchLOResults list-group-item' id='"+response.id+"'>";
																searchResults += response.text;
																searchResults += "</li>";
																$(
																		'#searchLOResult')
																		.html(
																				searchResults);
																initAddSearchedLO(chosenLessonID);
															} else {
																alert('Learning Objective couldnt be created.');
															}
														});
										$('#searchLO').val('');
									} else {
										alert("Type atleast 10 characters for the learning objective");
									}
								} else {
									var searchString = $('#searchLO').val()
											.trim();
									if (searchString != ''
											&& searchString.length > 3) {
										$
												.get(

														window.content_rest_url
																+ 'learningObjective/search?s='
																+ searchString)
												.done(
														function(response) {
															var searchResults = '';
															$
																	.each(
																			response.learningObjectives,
																			function(
																					index,
																					value) {
																				searchResults += "<li class='searchLOResults list-group-item' id='"+value.id+"'>";
																				searchResults += value.text;
																				searchResults += "</li>";
																			});
															$('#searchLOResult')
																	.html(
																			searchResults);
															initAddSearchedLO(chosenLessonID);
														});
									}
								}
							});
		}

		function initAddSearchedLO(chosenLessonID) {
			$('.searchLOResults')
					.on(
							'click',
							function() {
								var loid = $(this).attr('id');
								var lotext = $(this).text();
								var listitem = this;
								$
										.get(

												window.content_rest_url
														+ 'lesson/addLO/'
														+ chosenLessonID + '/'
														+ loid + '/'
														+ window.courseID)
										.done(
												function(response) {
													if (response.success) {
														var selectedLOaddition = '';
														selectedLOaddition += "<li class='selectedLO list-group-item list-group-item-success' id='"
															+ loid
															+ "'>"
																+ lotext
																+ "</li>";
														$('#selectedLOs')
																.prepend(
																		selectedLOaddition);
														$(listitem).remove();
													} else {
														alert('Learning Objective is already associated with the lesson.')
													}
												});
							});
		}

		function initRemoveSelectedLO(chosenLessonID) {
			$(document).on(
					'click',
					'.selectedLO',
					function() {
						var loid = $(this).attr('id');
						var listitem = this;
						$.get(

								window.content_rest_url + 'lesson/remLO/'
										+ chosenLessonID + '/' + loid + '/'
										+ window.courseID).done(
								function(response) {
									if (response.success) {
										$(listitem).remove();
									}
								});
					});
		}

		function initSessionEllipsisDuplicateFrom() {
			$(document)
					.on(
							'click',
							'.duplicateLesson',
							function() {
								var chosenSessionID = $(this).data(
										'cmsessionid');
								$
										.get('./modals/duplicateLessonFrom.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													var url = window.content_rest_url
															+ 'course/getAll';
													var addition = '';
													$
															.get(
																	url,
																	function(
																			data) {
																		$(
																				data.courses)
																				.each(
																						function(
																								key,
																								course) {
																							if (course.id != window.courseID) {
																								addition += '<option id="'+course.id+'">';
																								addition += course.title;
																								addition += '</option>';
																							}
																						});
																		$(
																				'#chooseCourseDuplicateModal')
																				.find(
																						'option')
																				.not(
																						':first')
																				.remove();
																		$(
																				'#chooseCourseDuplicateModal')
																				.append(
																						addition);
																		duplicateModalCourseChangeListener(chosenSessionID);
																		$(
																				'#duplicatLessonFromModal')
																				.modal(
																						'toggle');
																	});
												});
							});
		}
		function duplicateModalCourseChangeListener(chosenSessionID) {
			$(document)
					.on(
							'change',
							'#chooseCourseDuplicateModal',
							function() {
								var courseID = $('#chooseCourseDuplicateModal')
										.children(":selected").attr("id");
								var url = window.content_rest_url
										+ 'course/getTree/' + courseID;
								var jsonData;
								$
										.get(
												url,
												function(data) {
													window.courseTreeDuplicateModal = data.courseTree;
												})
										.done(
												function() {
													var moduleAddition = '';
													$
															.each(
																	window.courseTreeDuplicateModal,
																	function(a,
																			b) {
																		moduleAddition += '<option id="'
																				+ b.id
																						.substring(1)
																				+ '">';
																		moduleAddition += b.moduleTitle;
																		moduleAddition += '</option>';
																	});
													$(
															'#chooseModuleDuplicateModal')
															.find('option')
															.not(':first')
															.remove();
													$(
															'#chooseModuleDuplicateModal')
															.append(
																	moduleAddition);

													duplicateModalModuleChangeListener(chosenSessionID);
												});

							});
		}
		function duplicateModalModuleChangeListener(chosenSessionID) {
			$(document)
					.on(
							'change',
							'#chooseModuleDuplicateModal',
							function() {
								var sessionAddition = '';
								$
										.each(
												window.courseTreeDuplicateModal,
												function(a, b) {
													if (b.id.substring(1) == $(
															'#chooseModuleDuplicateModal')
															.children(
																	":selected")
															.attr("id")) {
														var sessionAddition = '';
														$
																.each(
																		b.children,
																		function(
																				c,
																				d) {
																			sessionAddition += '<option id="'
																					+ d.id
																							.substring(1)
																					+ '">';
																			sessionAddition += d.sessionTitle;
																			sessionAddition += '</option>';
																		});
														$(
																'#chooseSessionDuplicateModal')
																.find('option')
																.not(':first')
																.remove();
														$(
																'#chooseSessionDuplicateModal')
																.append(
																		sessionAddition);
														duplicateModalSessionChangeListener(chosenSessionID);
													}

												});

							});
		}
		function duplicateModalSessionChangeListener(chosenSessionID) {
			$(document)
					.on(
							'change',
							'#chooseSessionDuplicateModal',
							function() {
								$
										.each(
												window.courseTreeDuplicateModal,
												function(a, b) {
													var lessonAddition = '';
													if (b.id.substring(1) == $(
															'#chooseModuleDuplicateModal')
															.children(
																	":selected")
															.attr("id")) {
														$
																.each(
																		b.children,
																		function(
																				c,
																				d) {
																			if (d.id
																					.substring(1) == $(
																					'#chooseSessionDuplicateModal')
																					.children(
																							":selected")
																					.attr(
																							"id")) {

																				$
																						.each(
																								d.children,
																								function(
																										e,
																										f) {
																									lessonAddition += '<option id="'
																											+ f.id
																													.substring(1)
																											+ '">';
																									lessonAddition += f.lessonTitle;
																									lessonAddition += '</option>';
																								});
																			}
																		});
														$(
																'#chooseLessonDuplicateModal')
																.find('option')
																.not(':first')
																.remove();
														$(
																'#chooseLessonDuplicateModal')
																.append(
																		lessonAddition);
														duplicateModalSaveButtonListener(chosenSessionID);
													}

												});

							});
		}

		function duplicateModalSaveButtonListener(chosenSessionID) {
			$('#duplicateLessonButton').on(
					'click',
					function() {
						var lessonToBeDuplicated = $(
								'#chooseLessonDuplicateModal').children(
								":selected").attr("id");
						var url = window.content_rest_url + 'session/'
								+ chosenSessionID + '/duplicateLesson/'
								+ lessonToBeDuplicated;
						$.get(url).done(
								function(response) {
									if (response.success) {
										$("#skillTree").jstree('destroy');
										$('#duplicatLessonFromModal').modal(
												'toggle');
										loadCourseTree(animateChildNode, 'L'
												+ response.lessonID);
									} else {
										$('#duplicatLessonFromModal').modal(
												'toggle');
										alert('Failed!');
									}
								});

					});
		}

		function initSessionEllipsisLinkFrom() {
			$(document)
					.on(
							'click',
							'.linkLesson',
							function() {
								var chosenSessionID = $(this).data(
										'cmsessionid');
								$
										.get('./modals/linkLessonFrom.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
													var url = window.content_rest_url
															+ 'course/getAll';
													var addition = '';
													$
															.get(
																	url,
																	function(
																			data) {
																		$(
																				data.courses)
																				.each(
																						function(
																								key,
																								course) {
																							if (course.id != window.courseID) {
																								addition += '<option id="'+course.id+'">';
																								addition += course.title;
																								addition += '</option>';
																							}
																						});
																		$(
																				'#chooseCourseLinkModal')
																				.find(
																						'option')
																				.not(
																						':first')
																				.remove();
																		$(
																				'#chooseCourseLinkModal')
																				.append(
																						addition);
																		linkModalCourseChangeListener(chosenSessionID);
																		$(
																				'#linkLessonFromModal')
																				.modal(
																						'toggle');
																	});
												});
							});
		}
		function linkModalCourseChangeListener(chosenSessionID) {
			$(document)
					.on(
							'change',
							'#chooseCourseLinkModal',
							function() {
								var courseID = $('#chooseCourseLinkModal')
										.children(":selected").attr("id");
								var url = window.content_rest_url
										+ 'course/getTree/' + courseID;
								var jsonData;
								$
										.get(
												url,
												function(data) {
													window.courseTreeModal = data.courseTree;
												})
										.done(
												function() {
													var moduleAddition = '';
													$
															.each(
																	window.courseTreeModal,
																	function(a,
																			b) {
																		moduleAddition += '<option id="'
																				+ b.id
																						.substring(1)
																				+ '">';
																		moduleAddition += b.moduleTitle;
																		moduleAddition += '</option>';
																	});
													$('#chooseModuleLinkModal')
															.find('option')
															.not(':first')
															.remove();
													$('#chooseModuleLinkModal')
															.append(
																	moduleAddition);

													linkModalModuleChangeListener(chosenSessionID);
												});

							});
		}
		function linkModalModuleChangeListener(chosenSessionID) {
			$(document)
					.on(
							'change',
							'#chooseModuleLinkModal',
							function() {
								var sessionAddition = '';
								$
										.each(
												window.courseTreeModal,
												function(a, b) {
													if (b.id.substring(1) == $(
															'#chooseModuleLinkModal')
															.children(
																	":selected")
															.attr("id")) {
														var sessionAddition = '';
														$
																.each(
																		b.children,
																		function(
																				c,
																				d) {
																			sessionAddition += '<option id="'
																					+ d.id
																							.substring(1)
																					+ '">';
																			sessionAddition += d.sessionTitle;
																			sessionAddition += '</option>';
																		});
														$(
																'#chooseSessionLinkModal')
																.find('option')
																.not(':first')
																.remove();
														$(
																'#chooseSessionLinkModal')
																.append(
																		sessionAddition);
														linkModalSessionChangeListener(chosenSessionID);
													}

												});

							});
		}
		function linkModalSessionChangeListener(chosenSessionID) {
			$(document)
					.on(
							'change',
							'#chooseSessionLinkModal',
							function() {
								$
										.each(
												window.courseTreeModal,
												function(a, b) {
													var lessonAddition = '';
													if (b.id.substring(1) == $(
															'#chooseModuleLinkModal')
															.children(
																	":selected")
															.attr("id")) {
														$
																.each(
																		b.children,
																		function(
																				c,
																				d) {
																			if (d.id
																					.substring(1) == $(
																					'#chooseSessionLinkModal')
																					.children(
																							":selected")
																					.attr(
																							"id")) {

																				$
																						.each(
																								d.children,
																								function(
																										e,
																										f) {
																									lessonAddition += '<option id="'
																											+ f.id
																													.substring(1)
																											+ '">';
																									lessonAddition += f.lessonTitle;
																									lessonAddition += '</option>';
																								});
																			}
																		});
														$(
																'#chooseLessonLinkModal')
																.find('option')
																.not(':first')
																.remove();
														$(
																'#chooseLessonLinkModal')
																.append(
																		lessonAddition);
														linkModalSaveButtonListener(chosenSessionID);
													}

												});

							});
		}

		function linkModalSaveButtonListener(chosenSessionID) {
			$('#linkLessonButton').on(
					'click',
					function() {
						var lessonToBeLinked = $('#chooseLessonLinkModal')
								.children(":selected").attr("id");
						var url = window.content_rest_url + 'session/'
								+ chosenSessionID + '/linkLesson/'
								+ lessonToBeLinked;
						$.get(url).done(
								function(response) {
									if (response.success) {
										$("#skillTree").jstree('destroy');
										$('#linkLessonFromModal').modal(
												'toggle');
										loadCourseTree(animateChildNode, 'L'
												+ lessonToBeLinked);
									} else {
										$('#linkLessonFromModal').modal(
												'toggle');
										alert('Failed!');
									}
								});

					});
		}

		function initLessonEllipsisPublish() {
			$(document)
					.on(
							'click',
							'.publishLesson',
							function() {
								var chosenLessonID = $(this).data('lessonid');
								var url = window.content_rest_url
										+ 'lesson/publish/' + chosenLessonID
										+ '/course/' + window.courseID;
								$
										.get(url)
										.done(
												function(response) {
													if (response.success) {
														alert('Lesson has been published!');
													} else {
														$
																.get(
																		'./modals/publishLesson.jsp')
																.done(
																		function(
																				data) {
																			$(
																					'#modals')
																					.html(
																							data);
																			if (response.image) {
																				$(
																						'#isImage')
																						.addClass(
																								'list-group-item-success');
																			} else {
																				$(
																						'#isImage')
																						.addClass(
																								'list-group-item-danger');
																			}
																			if (response.los) {
																				$(
																						'#isLos')
																						.addClass(
																								'list-group-item-success');
																			} else {
																				$(
																						'#isLos')
																						.addClass(
																								'list-group-item-danger');
																			}
																			if (response.assets) {
																				$(
																						'#isAssets')
																						.addClass(
																								'list-group-item-success');
																			} else {
																				$(
																						'#isAssets')
																						.addClass(
																								'list-group-item-danger');
																			}
																			if (response.description) {
																				$(
																						'#isDesc')
																						.addClass(
																								'list-group-item-success');
																			} else {
																				$(
																						'#isDesc')
																						.addClass(
																								'list-group-item-danger');
																			}
																			if (response.title) {
																				$(
																						'#isTitle')
																						.addClass(
																								'list-group-item-success');
																			} else {
																				$(
																						'#isTitle')
																						.addClass(
																								'list-group-item-danger');
																			}
																			$(
																					'#publishLesson')
																					.modal(
																							'toggle');
																		});

													}
												});
							});
		}

		function initLessonEllipsisEditLesson() {
			$(document).on(
					'click',
					'.editLesson_content',
					function() {
						var chosenLessonID = $(this).data('lessonid');
						var typ = $(this).data('lesson_type');
						if (typ == 'PRESENTATION') {
							window.open('./edit_lesson_ppt.jsp?lesson_id='
									+ chosenLessonID, '_blank');

						} else if (typ == 'ASSESSMENT') {
							window.open('./edit_lesson_asses.jsp?lesson_id='
									+ chosenLessonID + '&course_id='
									+ window.courseID, '_blank');

						} else if (typ == 'INTERACTIVE') {
							window.open('./edit_lesson_inter.jsp?lesson_id='
									+ chosenLessonID, '_blank');

						}
					});
		}
	</script>
</body>
</html>