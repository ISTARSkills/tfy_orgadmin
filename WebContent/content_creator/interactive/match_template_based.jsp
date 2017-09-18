
<%
	int i = Integer.parseInt(request.getParameter("position"));
	String type = request.getParameter("type");
	String bg_image = request.getParameter("bg_image") != null ? request.getParameter("bg_image") : "";
	String optionText = request.getParameter("opt_text") != null ? request.getParameter("opt_text") : "";
	String correct_option = request.getParameter("correct_option") != null
			? request.getParameter("correct_option") : "";
%>

<div class="w-100 m-0 p-0 text-center m-auto opt-preview"
	<%=type.equalsIgnoreCase("ques") ? "draggable='true' ondragstart='drag(event)'"
					: "ondrop='drop(event)'  ondragover='allowDrop(event)'"%>
	id='option-preview-m<%=i%><%=type%>' data-poistion='<%=i%>'
	style='<%=!bg_image.equalsIgnoreCase("")
					? "background:url(" + bg_image + ") no-repeat;background-size:100% 100%;" : ""%>'>
	<p class='text-center m-auto'><%=optionText.equalsIgnoreCase("") ? "element " + i : optionText%></p>
	
	<input type="hidden" name="text-m-<%=type%><%=i%>"
		value='<%=optionText%>' /> <input type="file" style="display: none;"
		id="bg_image_optm<%=i%><%=type%>"
		data-holder='option-preview-m<%=i%><%=type%>'
		accept="image/jpg,image/png,image/jpeg,image/gif"
		class='opt_image_input' /> <input type="hidden" class='input_file'
		name="bg_image-m-<%=type%><%=i%>" value='<%=bg_image%>' />

	<%
		if (!type.equalsIgnoreCase("ques")) {
	%>
	<div class='float-right match-icon-holder custom-scroll'>
		<input name='option-correct-m-<%=i%>' value='<%=correct_option%>'
			class='option-correct' style="display: none;">

		<%
			if (!correct_option.isEmpty()) {
					for (String key : correct_option.split(",")) {
						if (!key.equalsIgnoreCase("")) {
		%>

		<span class='text-center match-icon' data-value='<%=key%>'><%=key%></span>

		<%
			}
					}
				}
		%>
	</div>
	<%
		}
	%>
</div>