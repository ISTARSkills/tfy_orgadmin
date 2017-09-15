<%@page import="com.viksitpro.cms.utilities.LessonTypeNames"%>
<%@page import="com.viksitpro.cms.utilities.URLServices"%>
<%
	URLServices services = new URLServices();
	String cdnPath = services.getAnyProp("cdn_path");
%>
<div id="lessonModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content custom-modal-content"
			style="max-height: 482px">
			<div class="modal-header custom-modal-header">
				<h5 class="modal-title custom-modal-title" id="lessonModalLabel">Create/Modify
					Lesson</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body custom-no-padding">
				<div class="container-fluid bd-example-row">
					<div class='row' style="margin-top: 10px;">
						<div class='col-md-3 col-md-auto justify-content-md-center'>
							<label>Lesson Title</label>
							
						</div>
						<div class='col-md-9 col-md-auto input-group'>
							<input style="width: 100%" class="form-control"
								id='lessonModalTitle' maxlength="255">
								<span class="input-group-addon"
								id="lessonModalTitleSize">0/255</span>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto input-group'>
							<label>Description</label>
						</div>
						<div class='col-md-9 col-md-auto' >
							<textarea style="width: 100%" class="form-control"
								id='lessonModalDescription'></textarea><span class="pull-right badge badge-secondary"
									id="lessonModalDescriptionSize"
									style="background-color: smoke; margin-right: 5px; margin-top: 3px;"></span>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto'>
							<label>Lesson Type</label>
						</div>
						<div class='col-md-9 col-md-auto'>
							<select style="width: 100%; height: 30px" class="form-control"
								id='lessonModalType'>
								<%
									LessonTypeNames[] somethingList = LessonTypeNames.values();
									for (LessonTypeNames lessonTypeNames : somethingList) {
								%>
								<option><%=lessonTypeNames.toString()%></option>
								<%
									}
								%>
							</select>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto'>
							<label>Lesson Duration</label>
						</div>
						<div class='col-md-9 col-md-auto input-group'>
							<input type="number" id="lessonModalDuration" min="5" max="60"
								step="5"><span class="pull-right badge badge-secondary"
									id="lessonModalDescriptionSize"
									style="background-color: smoke; margin-right: 5px; margin-top: 3px;">Minutes</span><span>(MAX.90 minutes) </span>
						</div>
					</div>
					<hr>
					<div class='row'>
						<div class='col-md-3 col-md-auto'>
							<label>Image</label>
						</div>
						<div class='col-md-5 col-md-auto'>
							<label for="lessonImageURL"><img class='lessonImage'
								src='<%=cdnPath%>course_images/l_0.png' alt=''> </label><input
								style="display: none"
								value='<%=cdnPath%>course_images/l_0.png'
								id='lessonImageURL' type='file'>
						</div>
						<div class='col-md-4 col-md-auto'>
							<button class="btn btn-sm btn-modal" style="margin-top: 22px"
								id='saveLesson'>Save Changes</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>