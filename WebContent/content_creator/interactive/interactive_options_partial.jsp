<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.elt.interactive.EntityOption"%>
<%@page
	import="com.viksitpro.core.elt.interactive.InteractiveLessonServices"%>
<%@page import="com.viksitpro.core.elt.interactive.CMSSlide"%>
<%@page import="com.viksitpro.core.elt.interactive.CMSLesson"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

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

	boolean isDTBased = false;
	if (cmsSlide != null && cmsSlide.getTemplate() != null && cmsSlide.getTemplate().equalsIgnoreCase("D-T")) {
		isDTBased = true;
	}
%>

<div class="row w-100 my-0 p-3">

	<div class='col-6'>
		<label class='col-form-label w-100 my-0'>Choose Template Type</label> <select
			name='slide_template' class='custom-dropdown-style'>
			<option value="D-T"
				<%=cmsSlide != null && cmsSlide.getTemplate() != null && cmsSlide.getTemplate().equalsIgnoreCase("D-T")
							? "selected" : ""%>>Drag
				& Tap Based</option>
			<option value="MATCH"
				<%=cmsSlide != null && cmsSlide.getTemplate() != null
					&& cmsSlide.getTemplate().equalsIgnoreCase("MATCH") ? "selected" : ""%>>Match
				The Following</option>
			<option value="ORDERING"
				<%=cmsSlide != null && cmsSlide.getTemplate() != null
					&& cmsSlide.getTemplate().equalsIgnoreCase("ORDERING") ? "selected" : ""%>>Ordering</option>
		</select>
	</div>
	
	<div class='col-6 text-right m-auto'>
		<button type='button' class='submit-form' id='submit-form'><%=null == cmsSlide?"Create":"Update"%></button>
	</div>

</div>

<div class='w-100 m-0 p-0 custom-scroll evaluation-holder'>

	<div class="panel panel-warning w-100">
		<div class="panel-heading">
			<h3 class="panel-title">Slide Evaluation</h3>
		</div>
		<div class="panel-body">
			<div class="form-group row">
				<div class='row m-0 dt-template w-100 mb-3'>
					<div class="col-3">
						<label class='col-form-label w-100 my-0'>Drop Zone</label> <select
							name='drop_zone' class='custom-dropdown-style option_pos'>
							<option value="TOP"
								<%=isDTBased && cmsSlide != null && cmsSlide.getSub_type() != null
					&& cmsSlide.getSub_type().equalsIgnoreCase("TOP") ? "selected" : ""%>>Top</option>
							<option value="BOTTOM"
								<%=isDTBased && cmsSlide != null && cmsSlide.getSub_type() != null
					&& cmsSlide.getSub_type().equalsIgnoreCase("BOTTOM") ? "selected" : ""%>>Bottom</option>
						</select>
					</div>


					<div class="col-3">
						<label class='col-form-label w-100 my-0'>Action Type</label> <select
							name='action_type' class='custom-dropdown-style option_pos'>
							<option value="DRAG"
								<%=isDTBased && cmsSlide != null && cmsSlide.getAction() != null
					&& cmsSlide.getAction().equalsIgnoreCase("DRAG") ? "selected" : ""%>>Drag</option>
							<option value="TAP"
								<%=isDTBased && cmsSlide != null && cmsSlide.getAction() != null
					&& cmsSlide.getAction().equalsIgnoreCase("TAP") ? "selected" : ""%>>TAP</option>
						</select>
					</div>

					<div class="col-3">
						<label class='col-form-label w-100 my-0'>Correct Option</label> <select
							name='correct_option' class='custom-dropdown-style option_pos'
							data-level="">
							<option value="OPT-1"
								<%=isDTBased && cmsSlide != null && cmsSlide.getMarking_scheme() != null
					&& cmsSlide.getMarking_scheme().equalsIgnoreCase("OPT-1") ? "selected" : ""%>>Option
								1</option>
							<option value="OPT-2"
								<%=isDTBased && cmsSlide != null && cmsSlide.getMarking_scheme() != null
					&& cmsSlide.getMarking_scheme().equalsIgnoreCase("OPT-2") ? "selected" : ""%>>Option
								2</option>
							<option value="OPT-3"
								<%=isDTBased && cmsSlide != null && cmsSlide.getMarking_scheme() != null
					&& cmsSlide.getMarking_scheme().equalsIgnoreCase("OPT-3") ? "selected" : ""%>>Option
								3</option>
							<option value="OPT-4"
								<%=isDTBased && cmsSlide != null && cmsSlide.getMarking_scheme() != null
					&& cmsSlide.getMarking_scheme().equalsIgnoreCase("OPT-4") ? "selected" : ""%>>Option
								4</option>
							<option value="OPT-5"
								<%=isDTBased && cmsSlide != null && cmsSlide.getMarking_scheme() != null
					&& cmsSlide.getMarking_scheme().equalsIgnoreCase("OPT-5") ? "selected" : ""%>>Option
								5</option>
							<option value="OPT-6"
								<%=isDTBased && cmsSlide != null && cmsSlide.getMarking_scheme() != null
					&& cmsSlide.getMarking_scheme().equalsIgnoreCase("OPT-6") ? "selected" : ""%>>Option
								6</option>
						</select>
					</div>
				</div>

				<div class="col-3">
					<label class="col-form-label w-100 my-0">Slide Audio</label> <input
						type="button" value="Browse" class="btn-file"
						onclick="$('#bg_audio_slide').click();" /> <input type="file"
						style="display: none;" id="bg_audio_slide" name="bg_audio"
						class='opt_image_input' data-type='audio' accept=".mp3,.wav" /> <input
						type="hidden" class='input_file' name="bg_audio"
						value='<%=cmsSlide != null && cmsSlide.getAudio_BG() != null ? cmsSlide.getAudio_BG() : ""%>' />
				</div>

				<div class="col-3">
					<label class='col-form-label w-100 my-0'>Audio Type</label> <select
						name='slide_audio_type' class='custom-dropdown-style option_pos'
						data-level="">
						<option value="REPEATABLE"
							<%=cmsSlide != null && cmsSlide.getAudio_type() != null
					&& cmsSlide.getAudio_type().equalsIgnoreCase("REPEATABLE") ? "selected" : ""%>>Repeatable</option>
						<option value="NON-REPEATABLE"
							<%=cmsSlide != null && cmsSlide.getAudio_type() != null
					&& cmsSlide.getAudio_type().equalsIgnoreCase("NON-REPEATABLE") ? "selected" : ""%>>NON-Repeatable</option>
					</select>
				</div>

				<div class="col-3 text-holder">
					<label class="col-form-label w-100 my-0">Coins</label> <input
						type="number" min='0'
						value='<%=cmsSlide != null ? cmsSlide.getCoins() : 0%>'
						name='coins_slide' class="form-control">
				</div>

				<div class="col-3 text-holder">
					<label class="col-form-label w-100 my-0">Points</label> <input
						type="number" min='0' max='100'
						value='<%=cmsSlide != null ? cmsSlide.getPoints() : 0%>'
						name='points_slide' class="form-control">
				</div>
			</div>
		</div>
	</div>

	<div
		class="panel panel-warning w-100 mt-1 option_navigation option_navigation_dt">
		<div class="panel-heading">
			<h3 class="panel-title">Slide Options</h3>
		</div>
		<div class="panel-body">
			<div class="form-group row">

				<div class="col-4 my-2">
					<label class="col-form-label">Option 1 Audio</label> <input
						type="button" value="Browse" class="btn-file"
						onclick="$('#option_audio1').click();" /> <input type="file"
						style="display: none;" id="option_audio1" accept=".mp3,.wav"
						class='opt_image_input' data-type='audio' /> <input type="hidden"
						class='input_file' name="option_audio1"
						value='<%=isDTBased && cmsSlide != null && cmsSlide.getEntityOptions() != null
					? cmsSlide.getEntityOptions().getEntityOptions().get(0).getBg_audio() : ""%>' />
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 2 Audio</label> <input
						type="button" value="Browse" class="btn-file"
						onclick="$('#option_audio2').click();" /> <input type="file"
						style="display: none;" id="option_audio2" accept=".mp3,.wav"
						class='opt_image_input' data-type='audio' /> <input type="hidden"
						class='input_file' name="option_audio2"
						value='<%=isDTBased && cmsSlide != null && cmsSlide.getEntityOptions() != null
					? cmsSlide.getEntityOptions().getEntityOptions().get(1).getBg_audio() : ""%>' />
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 3 Audio</label> <input
						type="button" value="Browse" class="btn-file"
						onclick="$('#option_audio3').click();" /> <input type="file"
						style="display: none;" id="option_audio3" name="bg_audio"
						class='opt_image_input' data-type='audio' accept=".mp3,.wav" /> <input
						type="hidden" class='input_file' name="option_audio3"
						value='<%=isDTBased && cmsSlide != null && cmsSlide.getEntityOptions() != null
					? cmsSlide.getEntityOptions().getEntityOptions().get(2).getBg_audio() : ""%>' />
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 4 Audio</label> <input
						type="button" value="Browse" class="btn-file"
						onclick="$('#option_audio4').click();" /> <input type="file"
						style="display: none;" id="option_audio4" name="bg_audio"
						class='opt_image_input' data-type='audio' accept=".mp3,.wav" /> <input
						type="hidden" class='input_file' name="option_audio4"
						value='<%=isDTBased && cmsSlide != null && cmsSlide.getEntityOptions() != null
					? cmsSlide.getEntityOptions().getEntityOptions().get(3).getBg_audio() : ""%>' />
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 5 Audio</label> <input
						type="button" value="Browse" class="btn-file"
						onclick="$('#option_audio5').click();" /> <input type="file"
						style="display: none;" id="option_audio5" name="bg_audio"
						class='opt_image_input' data-type='audio' accept=".mp3,.wav" /> <input
						type="hidden" class='input_file' name="option_audio4"
						value='<%=isDTBased && cmsSlide != null && cmsSlide.getEntityOptions() != null
					? cmsSlide.getEntityOptions().getEntityOptions().get(4).getBg_audio() : ""%>' />
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 6 Audio</label> <input
						type="button" value="Browse" class="btn-file"
						onclick="$('#option_audio6').click();" /> <input type="file"
						style="display: none;" id="option_audio6" name="bg_audio"
						class='opt_image_input' data-type='audio' accept=".mp3,.wav" /> <input
						type="hidden" class='input_file' name="option_audio5"
						value='<%=isDTBased && cmsSlide != null && cmsSlide.getEntityOptions() != null
					? cmsSlide.getEntityOptions().getEntityOptions().get(5).getBg_audio() : ""%>' />
				</div>


			</div>
		</div>
	</div>

	<%
		int opt1Nav = -1, opt2Nav = -1, opt3Nav = -1, opt4Nav = -1, opt5Nav = -1, opt6Nav = -1;

		if (isDTBased && cmsSlide != null && cmsSlide.getEntityOptions() != null) {
			int i = 0;
			for (EntityOption entityOption : cmsSlide.getEntityOptions().getEntityOptions()) {

				if (i == 0)
					opt1Nav = entityOption.getNext_slide();
				if (i == 1)
					opt2Nav = entityOption.getNext_slide();
				if (i == 2)
					opt3Nav = entityOption.getNext_slide();
				if (i == 3)
					opt4Nav = entityOption.getNext_slide();
				if (i == 4)
					opt5Nav = entityOption.getNext_slide();
				if (i == 5)
					opt6Nav = entityOption.getNext_slide();
				i++;
			}
		}
	%>

	<div
		class="panel panel-warning w-100 mt-1 option_navigation option_navigation_dt">
		<div class="panel-heading">
			<h3 class="panel-title">Slide Options Navigation</h3>
		</div>
		<div class="panel-body">
			<div class="form-group row">

				<div class="col-4 my-2">
					<label class="col-form-label">Option 1</label> <select
						name='option_1_nav' class='custom-dropdown-style option_pos'>

						<%
							if (cmsLesson != null && cmsLesson.getSlides() != null) {
								for (CMSSlide slide : cmsLesson.getSlides()) {
						%>
						<option value="<%=slide.getOrder_id()%>"
							<%=(opt1Nav == slide.getOrder_id()) ? "selected" : ""%>>Slide
							<%=slide.getOrder_id()%></option>
						<%
							}
						%>
						<option value="<%=cmsLesson.getSlides().size() + 1%>">Slide
							<%=cmsLesson.getSlides().size() + 1%></option>
						<%
							} else {
						%>
						<option value="1" selected>Slide 1</option>
						<%
							}
						%>
					</select>
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 2</label> <select
						name='option_2_nav' class='custom-dropdown-style option_pos'>
						<%
							if (cmsLesson != null && cmsLesson.getSlides() != null) {
								for (CMSSlide slide : cmsLesson.getSlides()) {
						%>
						<option value="<%=slide.getOrder_id()%>"
							<%=(opt2Nav == slide.getOrder_id()) ? "selected" : ""%>>Slide
							<%=slide.getOrder_id()%></option>
						<%
							}
						%>
						<option value="<%=cmsLesson.getSlides().size() + 1%>">Slide
							<%=cmsLesson.getSlides().size() + 1%></option>
						<%
							} else {
						%>
						<option value="1" selected>Slide 1</option>
						<%
							}
						%>
					</select>
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 3</label> <select
						name='option_3_nav' class='custom-dropdown-style option_pos'>
						<%
							if (cmsLesson != null && cmsLesson.getSlides() != null) {
								for (CMSSlide slide : cmsLesson.getSlides()) {
						%>
						<option value="<%=slide.getOrder_id()%>"
							<%=(opt3Nav == slide.getOrder_id()) ? "selected" : ""%>>Slide
							<%=slide.getOrder_id()%></option>
						<%
							}
						%>
						<option value="<%=cmsLesson.getSlides().size() + 1%>">Slide
							<%=cmsLesson.getSlides().size() + 1%></option>
						<%
							} else {
						%>
						<option value="1" selected>Slide 1</option>
						<%
							}
						%>
					</select>
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 4</label> <select
						name='option_4_nav' class='custom-dropdown-style option_pos'>
						<%
							if (cmsLesson != null && cmsLesson.getSlides() != null) {
								for (CMSSlide slide : cmsLesson.getSlides()) {
						%>
						<option value="<%=slide.getOrder_id()%>"
							<%=(opt4Nav == slide.getOrder_id()) ? "selected" : ""%>>Slide
							<%=slide.getOrder_id()%></option>
						<%
							}
						%>
						<option value="<%=cmsLesson.getSlides().size() + 1%>">Slide
							<%=cmsLesson.getSlides().size() + 1%></option>
						<%
							} else {
						%>
						<option value="1" selected>Slide 1</option>
						<%
							}
						%>
					</select>
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 5</label> <select
						name='option_5_nav' class='custom-dropdown-style option_pos'>
						<%
							if (cmsLesson != null && cmsLesson.getSlides() != null) {
								for (CMSSlide slide : cmsLesson.getSlides()) {
						%>
						<option value="<%=slide.getOrder_id()%>"
							<%=(opt5Nav == slide.getOrder_id()) ? "selected" : ""%>>Slide
							<%=slide.getOrder_id()%></option>
						<%
							}
						%>
						<option value="<%=cmsLesson.getSlides().size() + 1%>">Slide
							<%=cmsLesson.getSlides().size() + 1%></option>
						<%
							} else {
						%>
						<option value="1" selected>Slide 1</option>
						<%
							}
						%>
					</select>
				</div>

				<div class="col-4 my-2">
					<label class="col-form-label">Option 6</label> <select
						name='option_6_nav' class='custom-dropdown-style option_pos'>
						<%
							if (cmsLesson != null && cmsLesson.getSlides() != null) {
								for (CMSSlide slide : cmsLesson.getSlides()) {
						%>
						<option value="<%=slide.getOrder_id()%>"
							<%=(opt6Nav == slide.getOrder_id()) ? "selected" : ""%>>Slide
							<%=slide.getOrder_id()%></option>
						<%
							}
						%>
						<option value="<%=cmsLesson.getSlides().size() + 1%>">Slide
							<%=cmsLesson.getSlides().size() + 1%></option>
						<%
							} else {
						%>
						<option value="1" selected>Slide 1</option>
						<%
							}
						%>
					</select>
				</div>
			</div>
		</div>
	</div>




	<div
		class="panel panel-warning w-100 mt-1 option_navigation option_navigation_mt">
		<div class="panel-heading">
			<h3 class="panel-title">Slide Options</h3>
		</div>
		<div class="panel-body">
			<div class="form-group row p-3">
				<div class='row w-100 p-5'>
					<button type='button' class='btn-add-match'
						data-type='match-holder-questions'>
						<i class="fa fa-plus-circle" aria-hidden="true"></i> Add Question
					</button>
					<button type='button' class='btn-add-match ml-3'
						data-type='match-holder-options'>
						<i class="fa fa-plus-circle" aria-hidden="true"></i> Add Option
					</button>
				</div>
			</div>
		</div>
	</div>

	<div
		class="panel panel-warning w-100 mt-1 option_navigation option_navigation_od">
		<div class="panel-heading">
			<h3 class="panel-title">Slide Options</h3>
		</div>
		<div class="panel-body">
			<div class="form-group row p-3">
				<div class='row w-100 p-5'>
					<button type='button' class='btn-add-match'
						data-type='match-holder-orders'>
						<i class="fa fa-plus-circle" aria-hidden="true"></i> Add Element
					</button>
				</div>

				<div id='oderring-template' class='custom-scroll'
					style='overflow: auto;'>
					<ul id="sortable">
						<%
							if (cmsSlide != null && cmsSlide.getTemplate() != null
									&& cmsSlide.getTemplate().equalsIgnoreCase("ORDERING") && cmsSlide.getEntityOptions() != null
									&& cmsSlide.getEntityOptions().getEntityOptions().size() != 0) {

								ArrayList<EntityOption> orderingList = cmsSlide.getEntityOptions().getEntityOptions();

								try {
									Collections.sort(orderingList, new Comparator<EntityOption>() {
										public int compare(EntityOption o1, EntityOption o2) {
											if (o1.getCorrect_order_id() == null) {
												return (o2.getCorrect_order_id() == null) ? 0 : 1;
											}
											if (o2.getCorrect_order_id() == null) {
												return -1;
											}
											return o1.getCorrect_order_id().compareTo(o2.getCorrect_order_id());
										}
									});
								} catch (Exception e) {

								}

								for (EntityOption entityOption : orderingList) {
									int order = entityOption.getCorrect_order_id();
									System.out.println(order);
						%>

						<li class='ui-state-default text-center'
							data-id='<%=entityOption.getId()%>' data-order='<%=order%>'>Item
							<%=entityOption.getId()%></li>

						<%
							}
							}
						%>
					</ul>
				</div>
			</div>
		</div>
	</div>

</div>



