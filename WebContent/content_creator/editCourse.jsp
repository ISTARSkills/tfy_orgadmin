<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
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
	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row">
				<h1>Direct Skill Theory</h1>
			</div>
		</div>
		<div class="container">
			<form class="form-horizontal">
				<div class="row">
					<div class="col-md-8">
						<div class="form-group">
							<label class="col-lg-2 control-label">Course Name</label>

							<div class="col-lg-10">
								<input type="text" placeholder="course_name"
									class="form-control" id='courseName'>
							</div>
						</div>
						<div class="form-group">
							<label class="col-lg-2 control-label">Description</label>

							<div class="col-lg-10">
								<textarea rows="3" style="width: 100%" id='courseDesc'></textarea>
							</div>
						</div>

						<div class="form-group">
							<div class="col-lg-offset-2 col-lg-10">
								<button class="btn btn-sm btn-primary " type="button"
									id='updateCourseDetails'>Update Detail</button>
								<button class="btn btn-sm btn-primary" id='addLastModule'
									type='button'>Add Module</button>
							</div>
						</div>
					</div>
					<div class="col-md-3">
						<label for="courseImageURL"><img class='courseImage'
							id='courseImage'
							src='http://localhost:8080/course_images/plusIcon.png' alt=''>
						</label><input style="display: none"
							value='http://localhost:8080/course_images/plusIcon.png'
							id='courseImageURL' type='file' accept="image/png">
					</div>
				</div>
			</form>

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
			initSessionEllipsisDelete();
		}
		function initLessonEllipsisListener() {
			initLessonEllipsisEditLessonContent();
			initLessonEllipsisAddLessonBelow();
			initLessonEllipsisMoveUp();
			initLessonEllipsisMoveDown();
			initLessonEllipsisDelete();
			initLessonEllipsisChangeSession();
			initLessonEllipsisDuplicate();
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
																									'src'),
																					parentCourse : window.courseID,
																					moduleOrderID : orderID
																				};
																				var url = 'http://localhost:8080/tfy_content_rest/module/create';
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
																									loadCourseTree();
																								});
																			}
																		});
													});
								}
							});
		}
		function loadCourseTree() {
			var courseID = $('#courseID').val();
			var url = '../tfy_content_rest/course/getTree/' + courseID;
			var jsonData;
			$
					.get(url, function(data) {
						window.jsonData = data;
						window.courseTree = data.courseTree;
					})
					.done(
							function() {
								$('#skillTree').jstree({
									'core' : {
										'check_callback' : true,
										'data' : window.jsonData.courseTree
									}
								});

								//inititalizeEllipsisListeners();

								$('#skillTree')
										.on(
												'open_node.jstree',
												function(e, data) {

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
												})
							});
		}
		function initializeCourseTreeVariables() {
			window.courseTree = {};
			window.isNewCourse = ($('#isNewCourse').val() == 'true');
			if (!isNewCourse) {
				window.courseID = $('#courseID').val();
			}
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
				if (window.isNewCourse) {
					var dataPost = {
						courseName : $('#courseName').val().trim(),
						courseDescription : $('#courseDesc').val().trim(),
						courseImageURL : $('#courseImage').attr('src')
					};
					var url = 'http://localhost:8080/tfy_content_rest/course/create';
				} else {
					var dataPost = {
						courseName : $('#courseName').val().trim(),
						courseDescription : $('#courseDesc').val().trim()
					};
					var url = 'http://localhost:8080/tfy_content_rest/course/update';
				}
				$
						.ajax({
							type : "POST",
							url : url,
							data : JSON.stringify(dataPost),
						})
						.done(
								function(data) {
									window.location
											.replace('http://localhost:8080/content_creator/editCourse.jsp?course='
													+ JSON.parse(data).courseID)
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
			return isCourseFormOK;
		}

		function fillCourseEditFormFields() {
			if (!window.isNewCourse) {
				$.get('../tfy_content_rest/course/read/' + window.courseID)
						.done(
								function(courseObject) {
									$('#courseName').val(
											courseObject.course.title);
									$('#courseDesc').val(
											courseObject.course.description);
									$('#courseImage').attr('src',
											courseObject.course.imageURL);
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
									$
											.ajax(
													{
														url : '/tfy_content_rest/file/imageupload',
														data : data,
														cache : false,
														contentType : false,
														processData : false,
														type : 'POST',
													})
											.done(
													function(response) {
														$('#courseImage')
																.attr('src',
																		response);
													});
								} else {
									console.log('No image');
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
																	'../tfy_content_rest/module/read/'
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
																						moduleObject.module.imageURL);
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
																													'src'),
																								};
																								var url = 'http://localhost:8080/tfy_content_rest/module/update/'
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
																													loadCourseTree();
																												});

																							}
																						});
																	});

												});
							});

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
																								'src'),
																				parentModule : chosenModuleID,
																				sessionOrderID : orderID
																			};
																			var url = 'http://localhost:8080/tfy_content_rest/session/create';
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
																										'#sessionModal')
																										.modal(
																												'toggle');
																								console
																										.log('Session updated!');
																								$(
																										"#skillTree")
																										.jstree(
																												'destroy');
																								loadCourseTree();

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
																								'src'),
																				parentCourse : window.courseID,
																				moduleOrderID : orderID
																			};
																			var url = 'http://localhost:8080/tfy_content_rest/module/create';
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
																								loadCourseTree();
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
										'moduleOrderID'));
								var newOrderID = parseInt($(this).data(
										'moduleOrderID')) - 1;
								var dataPost = {
									parentCourse : window.courseID,
									currentModuleOrderID : currentOrderID,
									newModuleOrderID : newOrderID
								};
								var url = 'http://localhost:8080/tfy_content_rest/module/reorder'
										+ chosenModuleID;
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
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
										'moduleOrderID'));
								var newOrderID = parseInt($(this).data(
										'moduleOrderID')) + 1;
								var dataPost = {
									parentCourse : window.courseID,
									currentModuleOrderID : currentOrderID,
									newModuleOrderID : newOrderID
								};
								var url = 'http://localhost:8080/tfy_content_rest/module/reorder'
										+ chosenModuleID;
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
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
									'../tfy_content_rest/module/delete/'
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
																	'../tfy_content_rest/session/read/'
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
																						sessionObject.session.imageURL);
																		$(
																				'#sessionModal')
																				.modal(
																						'toggle');
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
																								};
																								var url = 'http://localhost:8080/tfy_content_rest/session/update/'
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
																															'#sessionModal')
																															.modal(
																																	'toggle');
																													console
																															.log('Session updated!');
																													$(
																															"#skillTree")
																															.jstree(
																																	'destroy');
																													loadCourseTree();
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
																								'src'),
																				parentSession : chosenSessionID,
																				lessonOrderID : orderID
																			};
																			var url = 'http://localhost:8080/tfy_content_rest/lesson/create';
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
																										'#lessonModal')
																										.modal(
																												'toggle');
																								console
																										.log('Lesson updated!');
																								$(
																										"#skillTree")
																										.jstree(
																												'destroy');
																								loadCourseTree();
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
										'cmsessionOrderID')) + 1;
								var chosenSessionID = $(this).data(
										'cmsessionID');
								var chosenSessionNode = $('#skillTree').jstree(
										true).get_node('S' + chosenSessionID);
								var parentModuleID = $('#skillTree').jstree(
										true).get_parent(chosenSessionNode)
										.substring(1);
								var nodeID = 'M' + chosenModuleID;
								$
										.get('./modals/cmsession.jsp')
										.done(
												function(data) {
													$('#modals').html(data);
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
																								'src'),
																				parentModule : parentModuleID,
																				sessionOrderID : orderID
																			};
																			var url = 'http://localhost:8080/tfy_content_rest/session/create';
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
																										'#sessionModal')
																										.modal(
																												'toggle');
																								console
																										.log('Session updated!');
																								$(
																										"#skillTree")
																										.jstree(
																												'destroy');
																								loadCourseTree();
																							});
																		}
																	});
												});
							});
		}

		function initSessionEllipsisMoveUp() {
			$(document)
					.on(
							'click',
							'.moveSessionUp',
							function() {
								var chosenSessionID = $(this).data(
										'cmsessionID');
								var chosenSessionNode = $('#skillTree').jstree(
										true).get_node('S' + chosenSessionID);
								var parentModuleID = $('#skillTree').jstree(
										true).get_parent(chosenSessionNode)
										.substring(1);
								var currentOrderID = parseInt($(this).data(
										'cmsessionOrderID'));
								var newOrderID = parseInt($(this).data(
										'cmsessionOrderID')) - 1;
								var dataPost = {
									parentModule : parentModuleID,
									currentSessionOrderID : currentOrderID,
									newSessionOrderID : newOrderID
								};
								var url = 'http://localhost:8080/tfy_content_rest/session/reorder'
										+ chosenSessionID;
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
								});
							});
		}

		function initSessionEllipsisMoveDown() {
			$(document)
					.on(
							'click',
							'.moveSessionDown',
							function() {
								var chosenSessionID = $(this).data(
										'cmsessionID');
								var chosenSessionNode = $('#skillTree').jstree(
										true).get_node('S173');
								var parentModuleID = $('#skillTree').jstree(
										true).get_parent(chosenSessionNode)
										.substring(1);
								var currentOrderID = parseInt($(this).data(
										'cmsessionOrderID'));
								var newOrderID = parseInt($(this).data(
										'cmsessionOrderID')) + 1;
								var dataPost = {
									parentModule : parentModuleID,
									currentSessionOrderID : currentOrderID,
									newSessionOrderID : newOrderID
								};
								var url = 'http://localhost:8080/tfy_content_rest/session/reorder'
										+ chosenSessionID;
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
								});
							});
		}

		function initSessionEllipsisChangeModule() {
			//to DO
		}

		function initSessionEllipsisDelete() {
			$(document).on(
					'click',
					'.deleteSession',
					function() {
						var chosenSessionID = $(this).data('cmsessionID');
						var nodeID = 'S' + chosenSessionID;
						var node = $('#skillTree').jstree(true)
								.get_node(nodeID);
						if (node.children.length != 0) {
							alert('Session is not empty, can"t be deleted!');
						} else {
							$.get(
									'../tfy_content_rest/session/delete/'
											+ chosenSessionID).done(
									function(response) {
										$("#skillTree").jstree('destroy');
										loadCourseTree();
									});
						}
					});
		}

		function initLessonEllipsisEditLessonContent() {
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
																	'../tfy_content_rest/lesson/read/'
																			+ chosenSessionID)
															.done(
																	function(
																			sessionObject) {
																		$(
																				'#lessonModalTitle')
																				.val(
																						sessionObject.session.title);
																		$(
																				'#lessonModalDescription')
																				.val(
																						sessionObject.session.description);
																		$(
																				'.lessonImage')
																				.attr(
																						'src',
																						sessionObject.session.imageURL);
																		$(
																				'#lessonModal')
																				.modal(
																						'toggle');
																		$(
																				'#saveLesson')
																				.click(
																						function() {
																							var isSessionFormOK = false;
																							isSessionFormOK = validateSessionModal();
																							if (isSessionFormOK) {
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
																								};
																								var url = 'http://localhost:8080/tfy_content_rest/lesson/update/'
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
																															'#lessonModal')
																															.modal(
																																	'toggle');
																													console
																															.log('Lesson updated!');
																													$(
																															"#skillTree")
																															.jstree(
																																	'destroy');

																													loadCourseTree();
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
																								'src'),
																				parentSession : parentSessionID,
																				lessonOrderID : orderID
																			};
																			var url = 'http://localhost:8080/tfy_content_rest/session/create';
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
																										'#sessionModal')
																										.modal(
																												'toggle');
																								console
																										.log('Session updated!');
																								$(
																										"#skillTree")
																										.jstree(
																												'destroy');
																								loadCourseTree();
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
								var url = 'http://localhost:8080/tfy_content_rest/lesson/reorder'
										+ chosenLessonID;
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
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
								var url = 'http://localhost:8080/tfy_content_rest/lesson/reorder'
										+ chosenLessonID;
								$.ajax({
									type : "POST",
									url : url,
									data : JSON.stringify(dataPost),
								}).done(function(data) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
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
								'../tfy_content_rest/lesson/delete/'
										+ chosenLessonID).done(
								function(response) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
								});
					});
		}

		function initLessonEllipsisChangeSession() {
			//TO DO
		}

		function initLessonEllipsisDuplicate() {
			$(document).on(
					'click',
					'.duplicateLesson',
					function() {
						var chosenLessonID = $(this).data('lessonid');
						var chosenLessonNode = $('#skillTree').jstree(true)
								.get_node('L' + chosenLessonID);
						var parentSessionID = $('#skillTree').jstree(true)
								.get_parent(chosenLessonNode).substring(1);
						$.get(
								'../tfy_content_rest/lesson/duplicate/'
										+ chosenLessonID + '/'
										+ parentSessionID).done(
								function(response) {
									$("#skillTree").jstree('destroy');
									loadCourseTree();
								});
					});
		}
	</script>
</body>
</html>