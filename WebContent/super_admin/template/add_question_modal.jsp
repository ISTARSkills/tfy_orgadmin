<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%
int question_id = 0;
if(request.getParameter("question_id")!=null){
	question_id = Integer.parseInt(request.getParameter("question_id"));
	System.out.println(">>>><<<< "+question_id);
	
}
LessonServices lessonService = new LessonServices();
List<HashMap<String, Object>> optionsdata =  lessonService.getAllOptionsForQuestion(question_id);
List<HashMap<String, Object>> questiondata =  lessonService.getQuestion(question_id);
String str = "";
%>
<div class="modal-body">
	<input type="hidden" value="" id="slide_id">
	<div class='form-group'>
		<label for='comment'>Question:</label>
		
		<textarea class='form-control' rows='3' id='question'>
         <%if(questiondata.size() != 0){ %>
		
		<%=questiondata.get(0).get("question_text")!=null?questiondata.get(0).get("question_text").toString().trim().replaceAll("<p>", "").replaceAll("</p>", ""):""%>
		  
		 <%} %> 
		</textarea>
	    
	</div>
	<label>Check The Correct Options</label>
	<div class="row">
		<div class="col-md-6">
			<div class='form-group'>
			
			<%if(optionsdata.size() != 0){ 
			 str = optionsdata.get(0).get("marking_scheme").toString().equalsIgnoreCase("0")?"":"checked";
			 } %>
				<input <%=str%> type="checkbox" aria-label="..."> <label
					for='option1'>Option 1:</label>
				<textarea class='form-control' rows='2' id='option1'>
				    <%if(optionsdata.size() != 0){%>
		
	            	<%=optionsdata.get(0).get("text")!=null?optionsdata.get(0).get("text").toString().trim().replaceAll("<p>", "").replaceAll("</p>", ""):""%>
		  
		            <%} %>
				
				</textarea>
			</div>
		</div>
		<div class="col-md-6">
			<div class='form-group'>
			<%
			 str = "";
			if(optionsdata.size() != 0 && optionsdata.size() >=1){ 
			 str = optionsdata.get(1).get("marking_scheme").toString().equalsIgnoreCase("0")?"":"checked";
			 } %>
				<input <%=str%> type="checkbox" aria-label="..."> <label
					for='option2'>Option 2:</label>
				<textarea class='form-control' rows='2' id='option2'>
				<%if(optionsdata.size() != 0 && optionsdata.size() >=1){  %>
		
	            	<%=optionsdata.get(1).get("text")!=null?optionsdata.get(1).get("text").toString().trim().replaceAll("<p>", "").replaceAll("</p>", ""):""%>
		  
		            <%} %>
				</textarea>
			</div>
		</div>
		<div class="col-md-6">
			<div class='form-group'>
			<%
			 str = "";
			if(optionsdata.size() != 0 && optionsdata.size() >=2){ 
			 str = optionsdata.get(2).get("marking_scheme").toString().equalsIgnoreCase("0")?"":"checked";
			 } %>
				<input <%=str%> type="checkbox" aria-label="..."> <label
					for='option3'>Option 3:</label>
				<textarea class='form-control' rows='2' id='option3'>
				
                   <%if(optionsdata.size() != 0 && optionsdata.size() >=2){  %>
		
	            	<%=optionsdata.get(2).get("text")!=null?optionsdata.get(2).get("text").toString().trim().replaceAll("<p>", "").replaceAll("</p>", ""):""%>
		  
		            <%} %>
				
				</textarea>
			</div>
		</div>
		<div class="col-md-6">
			<div class='form-group'>
			
			<%
			 str = "";
			if(optionsdata.size() != 0 && optionsdata.size() >=3){ 
			 str = optionsdata.get(3).get("marking_scheme").toString().equalsIgnoreCase("0")?"":"checked";
			 } %>
			 
				<input <%=str%> type="checkbox" aria-label="..."> <label
					for='option4'>Option 4:</label>
				<textarea class='form-control' rows='2' id='option4'>
				
				<%if(optionsdata.size() != 0 && optionsdata.size() >=3){%>
		
	            	<%=optionsdata.get(3).get("text")!=null?optionsdata.get(3).get("text").toString().trim().replaceAll("<p>", "").replaceAll("</p>", ""):""%>
		  
		            <%} %>
				
				</textarea>
			</div>
		</div>
	</div>
</div>