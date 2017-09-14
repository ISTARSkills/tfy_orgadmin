<%
if(request.getParameter("image_type")!=null && request.getParameter("image_type").equalsIgnoreCase("foreground")){
%>

<form method="POST" enctype="multipart/form-data" id="fileUploadForm">
	<input type="hidden" id='element_type' name="element_type" value=''> 
	<input type="hidden" id='image_type' name="image_type" value='foreground'>
	 <input type="hidden" value="" name="slide_id" id ="slide_id">
      <input type="hidden" value="" name="lesson" id ="lesson">
      <input type="hidden" value="" name="isnew_slide" id ="isnew_slide">
      <input type="hidden" value="" name="template_type" id ="template_type">
	<div class="form-group custom_img">
		<label class="col-sm-4 control-label">Mobile Image</label>
		<div class="col-sm-5">
			<input class='file_upload' id="upload_file1" type="file" name="files1" accept="image/x-png" />
		</div>
	</div>

	<div class="form-group custom_img">
		<label class="col-sm-4 control-label">Desktop Image</label>
		<div class="col-sm-5">
			<input class='file_upload' id="upload_file2" type="file" name="files2" accept="image/x-png" />
		</div>
	</div>
	
	<div class="form-group custom_video">
		<label class="col-sm-4 control-label">Video Upload</label>
		<div class="col-sm-5">
			<input class='file_upload' id="upload_file1" type="file" name="files3" accept="video/mp4" />
		</div>
	</div>
	

</form>
<%
}

if(request.getParameter("image_type")!=null && request.getParameter("image_type").equalsIgnoreCase("background")){
%>

<form method="POST" enctype="multipart/form-data" id="fileUploadForm">
	<input type="hidden" id='element_type' name="element_type" value='IMAGE'> 
	<input type="hidden" id='image_type' name="image_type" value='background'>
	 <input type="hidden" value="" name="slide_id" id ="slide_id">
     <input type="hidden" value="" name="lesson" id ="lesson">
     <input type="hidden" value="" name="isnew_slide" id ="isnew_slide">
     <input type="hidden" value="" name="template_type" id ="template_type">
	<div class="form-group">
		<label class="col-sm-4 control-label">Upload Media:</label>
		<div class="col-sm-5">
			<input class='file_upload' id="upload_file1" type="file" name="files" accept="image/x-png" />
		</div>
	</div>
<input type="submit"  style="float: right;" value="Remove Background Image" id="btnRemove"/>
</form>
<%
}
%>