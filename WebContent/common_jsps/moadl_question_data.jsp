<%@page import="com.istarindia.android.pojo.OptionPOJO"%>
<%@page import="org.apache.commons.collections.CollectionUtils"%>
<%@page import="com.istarindia.android.pojo.QuestionPOJO"%>
<%@page import="com.istarindia.android.pojo.AssessmentPOJO"%>
<%@page import="com.istarindia.android.pojo.QuestionResponsePOJO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.istarindia.android.pojo.AssessmentResponsePOJO"%>
<%@page import="com.istarindia.android.pojo.AssessmentReportPOJO"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="in.superadmin.services.ReportDetailService"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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
	
	RestClient client = new RestClient();
	AssessmentReportPOJO report = client.getAssessmentReportForUserForAssessment(user_id, assessment_id);
	AssessmentPOJO assessmentPojo = client.getAssessment(assessment_id, user_id);
	HashMap<Integer, ArrayList<Integer>> userQueResPonse = new HashMap();
	if(report.getAssessmentResponse()!=null)
	{
		AssessmentResponsePOJO responsePojo =  report.getAssessmentResponse();
		for(QuestionResponsePOJO que : responsePojo.getResponse())
		{
			userQueResPonse.put(que.getQuestionId(), (ArrayList<Integer>)que.getOptions());
		}
	}
	
	ReportDetailService service = new ReportDetailService();
 
 %>
<div class="ibox-content full-height-scroll modal-height"
	id="modal_assessment_questions">
	<%
							
							
	for(QuestionPOJO quePojo : assessmentPojo.getQuestions())
	{
		String questionText="";
		if(quePojo.getComprehensivePassageText()!=null && !quePojo.getComprehensivePassageText().toString().equalsIgnoreCase("") && !quePojo.getComprehensivePassageText().toString().contains("<p>null</p>"))
		{
			questionText = quePojo.getComprehensivePassageText()+"<br/>";
		}
		if(quePojo.getText()!=null)
		{
			questionText+=quePojo.getText();
		}
								
							%>
	<div class="row">
		<div
			class="product-box p-xl b-r-lg border-left-right border-top-bottom">
			<div class="m-t-sm m-l-sm">
				<strong class="m-l-sm"><%=questionText%></strong>
			</div>
			<%
			ArrayList<Integer> correctAnswer = (ArrayList<Integer>)quePojo.getAnswers();
			if(userQueResPonse.get(quePojo.getId())!=null)
			{
				ArrayList<Integer> questionResponse = userQueResPonse.get(quePojo.getId());
				
				if(questionResponse.size()>0)
				{
					boolean isCorrect = CollectionUtils.isEqualCollection(questionResponse, correctAnswer);
					if(isCorrect)
					{
						%>
						<span style='margin-top: -36px;' class='label  pull-right m-r-sm'>Correct</span>
						<%
					}
					else
					{
						%>
						<span style='margin-top: -36px;' class='label  pull-right m-r-sm'>Incorrect</span>
						<%
					}	
				}	
				else
				{
					%>
					<span style='margin-top: -36px;' class='label  pull-right m-r-sm'>Skipped</span>
					<%
				}	
			}
			else
			{
				%>
				<span style='margin-top: -36px;' class='label  pull-right m-r-sm'>Absent</span>
				<%
			}
			
			for(OptionPOJO optionPojo : quePojo.getOptions())
			{
				String optionText = optionPojo.getText();
				int optionID = optionPojo.getId();
				String selected="";
				if(correctAnswer.contains(optionID))
				{
					selected="checked";
				}
				
				%>
				<div class='radio m-l-lg'><input type='radio' name='radio<%= quePojo.getId()%>' id='radio<%=optionID%>' value='<%=optionID%>' <%=selected %> disabled> <label style='padding-left: 3px;' for='radio" + item.get("id") + "'>
				<%=optionText %>
				</label></div>
				<%
			}	
			
			%>
			
		</div>
	</div>
	<br />
	<%}%>
</div>