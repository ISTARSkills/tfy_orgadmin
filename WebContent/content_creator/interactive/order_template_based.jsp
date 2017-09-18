
<%
	int i = Integer.parseInt(request.getParameter("position"));
	String optionText = request.getParameter("opt_text") != null ? request.getParameter("opt_text") : "";
	String bg_image = request.getParameter("bg_image") != null ? request.getParameter("bg_image") : "";
	String correct_order=request.getParameter("correct_order") != null && !request.getParameter("correct_order").isEmpty()? request.getParameter("correct_order") : i+"";
%>
<div class='col-12 m-0 p-0 w-100' style='height: 150px;'>
	<div class="w-100 m-0 p-0 text-center m-auto opt-preview"
		id='option-preview-o<%=i%>' data-poistion='<%=i%>'
		style='<%=!bg_image.equalsIgnoreCase("")
					? "background:url(" + bg_image + ") no-repeat;background-size:100% 100%;" : ""%>'>


		<p class='text-center m-auto'><%=optionText.equalsIgnoreCase("") ? "element " + i : optionText%></p>
		<input type="hidden" name="option-order-text-<%=i%>"
			value='<%=optionText%>' /> <input type="file" style="display: none;"
			id="bg_image_opto<%=i%>" data-holder='option-preview-o<%=i%>'
			accept="image/jpg,image/png,image/jpeg,image/gif"
			name="bg_image-o-<%=i%>" class='opt_image_input' /> <input
			type="hidden" class='input_file' name="option-order-bg-<%=i%>"
			value='<%=bg_image%>' /> <input type='hidden' class='order-inputs'
			name='order-based-correct-<%=i%>' value='<%=correct_order%>' />


		<div class='float-right match-icon-holder'>
			<span class='text-center order-icon'><%=i%></span>
		</div>
	</div>
</div>