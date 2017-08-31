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

						<p>Sign in today for more expirience.</p>
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
								<textarea rows="3" cols="80" id='courseDesc'></textarea>
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
			/* initSessionEllipsisListener();
			initLessonEllipsisListener(); */
		}

		function initModuleEllipsisListener() {
			initModuleEllipsisEditModule();
			/* initModuleEllipsisAddSession();
			initModuleEllipsisAddModuleBelow();
			initModuleEllipsisMoveUp();
			initModuleEllipsisMoveDown();
			initModuleEllipsisDelete(); */
		}
		function initSessionEllipsisListener() {
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
									moduleModalSaveChangesController(
											createUpdateModule, 'create');
								}
							});
		}

		function moduleModalSaveChangesController(moduleModalCallBack,
				moduleMode) {
			$.get('./modals/module.jsp').done(function(data) {
				$('#modals').html(data);
				$('#moduleModal').modal('toggle');
				$('#saveModule').click(function() {
					var isModuleFormOK = false;
					isModuleFormOK = validateModuleModal();
					if (isModuleFormOK) {
						moduleModalCallBack(moduleMode);
						console.log('Form is OK');
					}
				});
			});
		}

		function createUpdateModule(mode) {
			var orderID = getAddModuleButtonOrderID();
			if (mode == 'create') {
				var dataPost = {
					moduleName : $('#moduleModalTitle').val().trim(),
					moduleDescription : $('#moduleModalDescription').val()
							.trim(),
					moduleImageURL : $('.moduleImage').attr('src'),
					parentCourse : window.courseID,
					moduleOrderID : orderID
				};
				var url = 'http://localhost:8080/tfy_content_rest/module/create';
			} else {
				var dataPost = {
					moduleName : $('#moduleModalTitle').val().trim(),
					moduleDescription : $('#moduleModalDescription').val()
							.trim(),
					moduleImageURL : $('.moduleImage').attr('src'),
				};
				var url = 'http://localhost:8080/tfy_content_rest/module/update';
			}
			$.ajax({
				type : "POST",
				url : url,
				data : JSON.stringify(dataPost),
			}).done(function(data) {
				console.log(data);
			});
		}

		function updateModule() {

		}

		function getAddModuleButtonOrderID() {
			return window.courseTree.length + 1;
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
		function initModuleEllipsisAddSession() {
			$('#skillTree')
					.on(
							"click",
							".addChildren",
							function() {
								$.get('./modals/module.jsp').done(
										function(data) {
											$('#modals').html(data);
											$('#moduleModal').modal('toggle');
										});
								var parentitemID = this.parentElement.parentElement.parentElement.parentElement.id;
								/* $(
										'#skillTree')
										.jstree(
												true)
										.create_node(
												parentitemID,
												{
													"id" : "ajson5",
													"text" : "newly added"
												},
												"last",
												function() {
													alert("done");
												}); */

							});
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
																	});
													moduleModalSaveChangesController(
															createUpdateModule,
															'update');
												});
							});

		}
	</script>
</body>
</html>