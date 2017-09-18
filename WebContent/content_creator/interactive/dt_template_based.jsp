<%@page
	import="com.viksitpro.core.elt.interactive.InteractiveLessonServices"%>
<%@page import="com.viksitpro.core.elt.interactive.CMSSlide"%>
<%@page import="com.viksitpro.core.elt.interactive.CMSLesson"%>
<%
	int lessonId = -1, slide_id = -1;
	CMSLesson cmsLesson = null;
	CMSSlide cmsSlide = null;
	InteractiveLessonServices services = new InteractiveLessonServices();

	if (request.getParameter("lesson_id") != null) {
		lessonId = Integer.parseInt(request.getParameter("lesson_id"));
		cmsLesson = services.getCmsInteractiveLesson(lessonId);
	}

	if (request.getParameter("slide_id") != null && !request.getParameter("slide_id").equalsIgnoreCase("-1")) {
		slide_id = Integer.parseInt(request.getParameter("slide_id"));
	}

	if (slide_id != -1 && cmsLesson != null) {
		for (CMSSlide cmsSlide1 : cmsLesson.getSlides()) {
			if (cmsSlide1.getId() == slide_id) {
				cmsSlide = cmsSlide1;
			}
		}
	}

	boolean isTopBased = true;

	if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("TOP")) {
		isTopBased = true;
	} else {
		isTopBased = false;
	}
	
	boolean isTopSelected = false;
	boolean isBottomSelected=false;
	if (cmsSlide != null && cmsSlide.getTemplate()!= null && cmsSlide.getTemplate().equalsIgnoreCase("D-T")) {
		if(cmsSlide.getSub_type()!=null && cmsSlide.getSub_type().equalsIgnoreCase("TOP")){
			isTopSelected=true;
		}else if(cmsSlide.getSub_type()!=null && cmsSlide.getSub_type().equalsIgnoreCase("BOTTOM")){
			isBottomSelected=true;
		}
	}
		

	if (isTopBased) {
%>



<div class='w-100 h-100 m-0 p-0 mobile_preview top-based-holder'  style='<%=isTopSelected?"background:url("+cmsSlide.getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
	id='mobile_preview_top'>
	<div class='w-100 bacground-part' data-holder='slide_bg_image_top'
		style="height: 20%; background-color: transparent;"></div>
	<div class='w-100 mobile-inside-part2' style="height: 80%; background-color: transparent;">
		<div class='row w-100 m-0 p-0'>
			<div class="col-6 m-0 p-0 text-center m-auto opt-preview" style='<%=isTopSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(0).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
				id='option-preview-01'>
				<p class='text-center m-auto'><%=isTopSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(0).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(0).getOption_text():"Option 1"%></p>
				<input type="hidden"  name="bg_text_opt01" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(0).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt01"
					data-holder='option-preview-01'
					accept="image/jpg,image/png,image/jpeg,image/gif" name="bg_image_1"
					class='opt_image_input' /> <input type="hidden" class='input_file'
					name="bg_image_opt01" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(0).getImage_BG():""%>' />
			</div>


			<div class="col-6 m-0 p-0 text-center m-auto opt-preview"
				id='option-preview-02' style='<%=isTopSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(1).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'>
				<p class='text-center m-auto'><%=isTopSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(1).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(1).getOption_text():"Option 2"%></p>
				<input type="hidden" name="bg_text_opt02" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(1).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt02"
					data-holder='option-preview-02'
					accept="image/jpg,image/png,image/jpeg,image/gif" name="bg_image_2"
					class='opt_image_input' /> <input type="hidden" class='input_file'
					name="bg_image_opt02" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(1).getImage_BG():""%>' />
			</div>

		</div>

		<div class='row w-100 m-0 p-0'>
			<div class="col-6 m-0 p-0 text-center m-auto opt-preview "
				id='option-preview-03' style='<%=isTopSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(2).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'>
				<p class='text-center m-auto'><%=isTopSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(2).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(2).getOption_text():"Option 3"%></p>
				<input type="hidden"  name="bg_text_opt03" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(2).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt03"
					data-holder='option-preview-03' name="bg_image_3"
					accept="image/jpg,image/png,image/jpeg,image/gif"
					class='opt_image_input' /><input type="hidden" class='input_file'
					name="bg_image_opt03" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(2).getImage_BG():""%>' />
			</div>

			<div class="col-6 m-0 p-0 text-center m-auto opt-preview "
				id='option-preview-4' style='<%=isTopSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(3).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'>
				<p class='text-center m-auto'><%=isTopSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(3).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(3).getOption_text():"Option 4"%></p>
				<input type="hidden"  name="bg_text_opt04" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(3).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt04"
					data-holder='option-preview-04' name="bg_image_4"
					accept="image/jpg,image/png,image/jpeg,image/gif"
					class='opt_image_input' /><input type="hidden" class='input_file'
					name="bg_image_opt04" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(3).getImage_BG():""%>' />
			</div>

		</div>

		<div class='row w-100 m-0 p-0'>
			<div class="col-6 m-0 p-0 text-center m-auto opt-preview "
				id='option-preview-05' style='<%=isTopSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(4).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'>
				<p class='text-center m-auto'><%=isTopSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(4).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(4).getOption_text():"Option 5"%></p>
				<input type="hidden"  name="bg_text_opt05" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(4).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt05"
					data-holder='option-preview-05' name="bg_image_5"
					class='opt_image_input'
					accept="image/jpg,image/png,image/jpeg,image/gif" /><input
					type="hidden" class='input_file' name="bg_image_opt05" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(4).getImage_BG():""%>' />
			</div>

			<div class="col-6 m-0 p-0  text-center m-auto opt-preview"
				id='option-preview-06' style='<%=isTopSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(5).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'>
				<p class='text-center m-auto'><%=isTopSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(5).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(5).getOption_text():"Option 6"%></p>
				<input type="hidden"  name="bg_text_opt06" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(5).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt06"
					data-holder='option-preview-06' name="bg_image_6"
					class='opt_image_input'
					accept="image/jpg,image/png,image/jpeg,image/gif" /><input
					type="hidden" class='input_file' name="bg_image_opt06" value='<%=isTopSelected?cmsSlide.getEntityOptions().getEntityOptions().get(5).getImage_BG():""%>' />
			</div>

		</div>

	</div>
	<input type="file" style="display: none;" id="slide_bg_image_top"
		data-holder='mobile_preview_top' name="slide_bg_image"
		class='opt_image_input'
		accept="image/jpg,image/png,image/jpeg,image/gif" /> <input
		type="hidden" class='input_file' name="slide_bg_image_top" value='<%=isTopSelected?cmsSlide.getImage_BG():""%>'  />
</div>


<%
	} else {
%>
<div class='w-100 h-100 m-0 p-0 mobile_preview bottom-based-holder' style='<%=isBottomSelected?"background:url("+cmsSlide.getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
	id='mobile_preview_bottom'>
	<div class='w-100 mobile-inside-part2'
		style="height: 80%; background-color: transparent;">
		<div class='row w-100 m-0 p-0'>
			<div class="col-6 m-0 p-0 text-center m-auto opt-preview" style='<%=isBottomSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(0).getImage_BG().trim()+") no-repeat;background-size:100% 100%;":""%>'
				id='option-preview-1'>
				<p class='text-center m-auto'><%=isBottomSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(0).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(0).getOption_text():"Option 1"%></p>
				<input type="hidden"  name="bg_text_opt1" value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(0).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt1"
					data-holder='option-preview-1'
					accept="image/jpg,image/png,image/jpeg,image/gif" name="bg_image_1"
					class='opt_image_input' /> <input type="hidden" class='input_file' value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(0).getImage_BG():""%>'
					name="bg_image_opt1" />
			</div>


			<div class="col-6 m-0 p-0 text-center m-auto opt-preview" style='<%=isBottomSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(1).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
				id='option-preview-2'>
				<p class='text-center m-auto'><%=isBottomSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(1).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(1).getOption_text():"Option 2"%></p>
				<input type="hidden"  name="bg_text_opt2" value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(1).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt2"
					data-holder='option-preview-2'
					accept="image/jpg,image/png,image/jpeg,image/gif" name="bg_image_2"
					class='opt_image_input' /> <input type="hidden" class='input_file' value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(1).getImage_BG():""%>'
					name="bg_image_opt2" />
			</div>

		</div>

		<div class='row w-100 m-0 p-0'>
			<div class="col-6 m-0 p-0 text-center m-auto opt-preview " style='<%=isBottomSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(2).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
				id='option-preview-3'>
				<p class='text-center m-auto'><%=isBottomSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(2).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(2).getOption_text():"Option 3"%></p>
				<input type="hidden"  name="bg_text_opt3" value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(2).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt3"
					data-holder='option-preview-3' name="bg_image_3"
					accept="image/jpg,image/png,image/jpeg,image/gif"
					class='opt_image_input' /><input type="hidden" class='input_file' value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(2).getImage_BG():""%>'
					name="bg_image_opt3" />
			</div>

			<div class="col-6 m-0 p-0 text-center m-auto opt-preview " style='<%=isBottomSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(3).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
				id='option-preview-4'>
				<p class='text-center m-auto'><%=isBottomSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(3).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(3).getOption_text():"Option 4"%></p>
				<input type="hidden"  name="bg_text_opt4" value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(3).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt4"
					data-holder='option-preview-4' name="bg_image_4"
					accept="image/jpg,image/png,image/jpeg,image/gif"
					class='opt_image_input' /><input type="hidden" class='input_file' value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(3).getImage_BG():""%>'
					name="bg_image_opt4" />
			</div>

		</div>

		<div class='row w-100 m-0 p-0'>
			<div class="col-6 m-0 p-0 text-center m-auto opt-preview " style='<%=isBottomSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(4).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
				id='option-preview-5'>
				<p class='text-center m-auto'><%=isBottomSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(4).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(4).getOption_text():"Option 5"%></p>
				<input type="hidden"  name="bg_text_opt5" value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(4).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt5"
					data-holder='option-preview-5' name="bg_image_5"
					class='opt_image_input'
					accept="image/jpg,image/png,image/jpeg,image/gif" /> <input value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(4).getImage_BG():""%>'
					type="hidden" class='input_file' name="bg_image_opt5" />
			</div>

			<div class="col-6 m-0 p-0  text-center m-auto opt-preview" style='<%=isBottomSelected?"background:url("+cmsSlide.getEntityOptions().getEntityOptions().get(5).getImage_BG()+") no-repeat;background-size:100% 100%;":""%>'
				id='option-preview-6'>
				<p class='text-center m-auto'><%=isBottomSelected && !cmsSlide.getEntityOptions().getEntityOptions().get(5).getOption_text().isEmpty()?cmsSlide.getEntityOptions().getEntityOptions().get(5).getOption_text():"Option 6"%></p>
				<input type="hidden"  name="bg_text_opt6" value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(5).getOption_text():""%>' />
				<input type="file" style="display: none;" id="bg_image_opt6"
					data-holder='option-preview-6' name="bg_image_6"
					class='opt_image_input'
					accept="image/jpg,image/png,image/jpeg,image/gif" /> <input value='<%=isBottomSelected?cmsSlide.getEntityOptions().getEntityOptions().get(5).getImage_BG():""%>'
					type="hidden" class='input_file' name="bg_image_opt6" />
			</div>
		</div>
	</div>
	<div class='w-100 bacground-part' data-holder='slide_bg_image_bottom'
		style="height: 20%; background-color: transparent;"></div>
	<input type="file" style="display: none;" id="slide_bg_image_bottom"
		data-holder='mobile_preview_bottom' name="slide_bg_image"
		class='opt_image_input'
		accept="image/jpg,image/png,image/jpeg,image/gif" /> <input
		type="hidden" class='input_file' name="slide_bg_image_bottom" value='<%=isBottomSelected?cmsSlide.getImage_BG():""%>' />
</div>
<%
	}
%>