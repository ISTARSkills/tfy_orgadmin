<%@page import="in.superadmin.services.ReportDetailService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	int assessment_id = 0;
	if (request.getParameter("assessment_id") != null) {
		assessment_id = Integer.parseInt(request.getParameter("assessment_id"));
	}

	int batch_id = 0;
	if (request.getParameter("batch_id") != null) {
		batch_id = Integer.parseInt(request.getParameter("batch_id"));
	}
	
	int user_id=0;
	if (request.getParameter("user_id") != null) {
		user_id = Integer.parseInt(request.getParameter("user_id"));
	}
	
	ReportDetailService service = new ReportDetailService();
 
 %>
<div class="ibox-content full-height-scroll modal-height"
	id="modal_assessment_questions">
	<%
							List<HashMap<String, Object>> questionList=service.getAllQuestions(assessment_id);
							for (HashMap<String, Object> item : questionList) {
								
							String questionText="";
							
							if(item.get("comprehensive_passage_text")==null || item.get("comprehensive_passage_text").toString().equalsIgnoreCase("") || item.get("comprehensive_passage_text").toString().equalsIgnoreCase("<p>null</p>")){
								questionText=item.get("question_text").toString();
							}else{
								questionText=item.get("comprehensive_passage_text").toString()+"<br/>"+item.get("question_text").toString();
							}
								
							%>
	<div class="row">
		<div
			class="product-box p-xl b-r-lg border-left-right border-top-bottom">
			<div class="m-t-sm m-l-sm">
				<strong class="m-l-sm"><%=questionText%></strong>
			</div>
			<%=service.getAllOptions((int)item.get("id"),user_id, assessment_id)%>
		</div>
	</div>
	<br />
	<%}%>
</div>