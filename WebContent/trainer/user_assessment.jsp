<%@page import="com.istarindia.android.pojo.OptionPOJO"%>
<%@page import="com.istarindia.android.pojo.QuestionPOJO"%>
<%@page import="com.istarindia.android.pojo.AssessmentPOJO"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";	
String userId = request.getParameter("user_id");
String assessmentId = request.getParameter("assessment_id");
String taskId = request.getParameter("task_id");
RestClient client = new  RestClient();
AssessmentPOJO assessment = client.getAssessment(Integer.parseInt(assessmentId), Integer.parseInt(userId));
DBUTILS db = new DBUTILS();
SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
ArrayList<QuestionPOJO> questions = (ArrayList<QuestionPOJO>)assessment.getQuestions();
int queCount = questions.size();
int assessmentMinutes = assessment.getDurationInMinutes();
%>
<body class="top-navigation" id="user_assessment">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="inc/navbar.jsp"></jsp:include>
		
		<div class="wrapper wrapper-content animated fadeInRight" style="padding-top:4px;">
					<div class="row">
				<div class="row wrapper border-bottom white-bg page-heading">
					<div class="col-lg-10">
						<h2 >Assessment - <%=assessment.getName() %></h2>
						<h4 > Number of Questions # <%=queCount%> </h4>						
					</div>
					<div class="col-lg-2">
					<button class="btn btn-primary btn-xs" type="button" style="margin-top: 42px;
    font-size: 17px;    float: right;"><i class="fa fa-clock-o"></i> &nbsp;&nbsp;
					<span class="bold" id="demo"> </span></button>
					</div>
				</div>
				
			</div>
			
			<div class="row" style="text-align: center;   margin-top: 10px;">				
				<%
				for(int i=1;i<=questions.size();i++)
				{
					%>
					<button class="btn btn-danger btn-lg btn-outline question_thumb" type="button" style="margin-bottom: 11px;" id="question_thumb_<%=i%>"><%=i%></button>
					<% 
				}
				%>								
			</div>
			 <form role="form" method="post" action="/submit_assessment" id="target">
			<input type="hidden" name="assessment_id" value="<%=assessmentId%>">
			<input type="hidden" name="task_id" value="<%=taskId%>">
			<% 
			
			for(int i=1;i<=questions.size();i++)
				{
				QuestionPOJO quePojo = questions.get(i-1);
					%>
					
					<div class="row question_row" id="question_row_<%=i%>" data-time_in_sec="<%=quePojo.getDurationInSec()%>"> 
			<div class="row wrapper border-bottom white-bg page-heading" style="padding-bottom: 13px;">			
			                      
			<div class="col-lg-8" style="    margin-top: 12px;
    margin-left: -12px;
    padding-right: 0px;">
                                    <div class="panel panel-default">
                                        <div class="panel-heading" style="font-size: 17px;
    font-weight: bold;color:#ed5565; ">
                                            Question #<%=i%>
									 <button type="button" class="btn btn-primary btn-xs" style="    font-size: 17px;
    float: right;
    z-index: 5;
    position: absolute;
    margin-top: -2px;
    margin-left: 76%;"><i class="fa fa-clock-o"></i> &nbsp;&nbsp;
					<span class="bold" id="que_clock_<%=i%>"> </span></button> 
								</div>
                                        <div class="panel-body">
                                            <p>
                                            <%=quePojo.getText()%>
                                            </p>
                                        </div>
                                    </div>
                                </div>
            <div class="col-lg-4" style="    margin-top: 12px;
    margin-left: -12px;
    padding-right: 0px;">
                                    <div class="panel panel-default">
                                        <div class="panel-heading" style="font-size: 17px;
    font-weight: bold;color:#ed5565; ">
                                            Choose the correct answer
                                             
                                        </div>
                                        <div class="panel-body">
                                        <input type="hidden" name="question_time_taken_<%=quePojo.getId()%>" value="" id="question_time_taken_<%=i%>">
                                            <p>
                                            <%
                                            ArrayList<OptionPOJO> options = ( ArrayList<OptionPOJO>)quePojo.getOptions();
                                            
                                            if(!quePojo.getType().equalsIgnoreCase("1"))
                                            {
                                            	for(OptionPOJO option: options)
                                                {
                                                	%>
                                                	<div><label><input class="question_option" type="checkbox" value="<%=option.getId()%>" name="option_for_question_<%=quePojo.getId()%>" id="questionOption_<%=i%>">  &nbsp;<%=option.getText()%></label></div>
                                                	<%
                                                }
                                            }
                                            else
                                            {
                                            	for(OptionPOJO option: options)
                                                {
                                                	%>
                                                	<div><label><input class="question_option" type="radio" value="<%=option.getId()%>" name="option_for_question_<%=quePojo.getId()%>" id="questionOption_<%=i%>">  &nbsp;<%=option.getText()%></label></div>
                                                	<%
                                                }
                                            }	
                                            
                                            %>
                                            </p>
                                        </div>
                                    </div> 
                                    <button type="button" class="btn btn-w-m btn-danger prev" id="prev_<%=i%>" >Prev Question</button>
                                    &nbsp;
                                    &nbsp;&nbsp;
                                    <button type="button" class="btn btn-w-m btn-danger next" id="next_<%=i%>" >Next Question</button>
                                     &nbsp;
                                    &nbsp;&nbsp;
                                    <button type="submit" class="btn btn-w-m btn-danger"  style="float:right">Submit Assessment</button>                                  
                                </div>
                               
             </div>  
                                                  
			</div>
					<% 
				}
				%>
			</form>
		</div>
				
	
		</div>		
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
	<script src="../trainer_common_jsps/custom_assessment.js"></script>
	<script type="text/javascript">
	var totalQuestionCount = <%=queCount%>;
	var questionAttempted =[];
	var x ;
	var assessmentStartTime;
	function startQuestionTimer(queNo)
	{
		 var timeInSec = $('#question_row_'+queNo).data('time_in_sec');
		var d =  new Date(); 
		d.setSeconds(d.getSeconds() + (parseInt(timeInSec)));
		var countDownDate = d.getTime();
		// Update the count down every 1 second
		
		if(parseInt(queNo)<=totalQuestionCount)
		{
			x= setInterval(function() {
				  // Get todays date and time
				  var now = new Date().getTime();

				  // Find the distance between now an the count down date
				  var distance = countDownDate - now;

				  // Time calculations for days, hours, minutes and seconds
				  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
				  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
				  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
				  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

				  // Display the result in the element with id="demo"
				  document.getElementById("que_clock_"+queNo).innerHTML = minutes + "m " + seconds + "s ";

				  // If the count down is finished, write some text
				  if(seconds===0)
				  {
					  jumpToNext(queNo);	  
				  }
				 
				}, 1000);
		}
		else
		{
			clearInterval(x); 
		}	
		 
		
			
	}
	
	function jumpToNext(queNo)
	{
		//jump to next one
		
		var questionNumToShow = parseInt(queNo)+1;
		clearInterval(x);
		startQuestionTimer(questionNumToShow);
		
		 if(questionNumToShow===1)
		 {
				$('.prev').hide();
				$('.next').show();	
		 }
		 if(questionNumToShow===totalQuestionCount)
		 {
				$('.next').hide();	
				$('.prev').show();
		 }
		 else
		 {
			 $('.next').show();	
			 $('.prev').show();
			 
			 $( ".question_thumb" ).each(function( index ) {
				 var id = $(this).attr('id');
				 var qqno = id.split('_')[2];
				$("#question_thumb_"+qqno).css('background-color','rgba(96, 70, 70, 0)');
				$("#question_thumb_"+qqno).css('border-color','#ed5565');
				$("#question_thumb_"+qqno).css('color','#ed5565');
			 });
			 for(var j=0;j<questionAttempted.length;j++)
			 {
				 $("#question_thumb_"+questionAttempted[j]).css('background-color','#d6c5c6');
				 $("#question_thumb_"+questionAttempted[j]).css('border-color','#d6c5c6');
				 $("#question_thumb_"+questionAttempted[j]).css('color','white');		
				 
				 
			 }
			 
			 
			 
			 $("#question_thumb_"+questionNumToShow).css('background-color','#ec4758');
			 $("#question_thumb_"+questionNumToShow).css('border-color','#b69fa1');
			 $("#question_thumb_"+questionNumToShow).css('color','white');
			 $('.question_row').hide();
			 $('#question_row_'+questionNumToShow).show();
		 }	
	}
	
	$(document).ready(function(){		
	
	assessmentStartTime = new Date().getTime();	
	$('.question_row').hide();
	$('.prev').hide();
	var currentQuestionNumber=1;
	$('#question_row_'+currentQuestionNumber).show();
	$("#question_thumb_"+currentQuestionNumber).css('background-color','#ec4758');
	$("#question_thumb_"+currentQuestionNumber).css('border-color','#b69fa1');
	$("#question_thumb_"+currentQuestionNumber).css('color','white');
	clearInterval(x);
	startQuestionTimer(currentQuestionNumber);
	var allowedAssessmentMin = <%=assessmentMinutes%>;	
	var d =  new Date(); 
	d.setMinutes(d.getMinutes() + (parseInt(allowedAssessmentMin)));
	var countDownDate = d.getTime();
	// Update the count down every 1 second
	var xx = setInterval(function() {
	  // Get todays date and time
	  var now = new Date().getTime();

	  // Find the distance between now an the count down date
	  var distance = countDownDate - now;

	  // Time calculations for days, hours, minutes and seconds
	  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
	  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
	  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

	  // Display the result in the element with id="demo"
	  document.getElementById("demo").innerHTML = minutes + "m " + seconds + "s ";

	  // If the count down is finished, write some text
	  if(minutes===3)
		{
		  //remind for end of assessment
		  swal({
              title: "Hurry Up",
              text: "Only 3 minutes left for the assessment."
          });

		}
	  else if(minutes===0)
	  {
		  clearInterval(xx);
		  $( "#target" ).submit();
	  }
	 
	}, 1000);
	
	
	$( ".question_option" ).unbind().on('change',function(){
		 var id = $(this).attr('id');
		 //questionOption_5
		 var queNo = id.split('_')[1];
		 $("#question_thumb_"+queNo).css('background-color','#d6c5c6');
		 $("#question_thumb_"+queNo).css('border-color','#d6c5c6');
		 $("#question_thumb_"+queNo).css('color','white');		 		 
		 questionAttempted.push(queNo);
		 var now = new Date().getTime();

		  // Find the distance between now an the count down date
		 var timeTookToAnswer = now - assessmentStartTime;
		 var timeTookToAnswerInseconds = Math.floor((timeTookToAnswer % (1000 * 60)) / 1000); 
		 $('#question_time_taken_'+queNo).val(timeTookToAnswerInseconds);
	});
	
	$( ".next" ).unbind().on('click',function(){
		var id = $(this).attr('id');		
		var queNo = id.split('_')[1];
		var questionNumToShow = parseInt(queNo) + 1;
		$('.question_row').hide();
		$('#question_row_'+questionNumToShow).show();
		$('.prev').show();
		if(questionNumToShow===totalQuestionCount)
		{
			$('.next').hide();	
			$('.prev').show();
		}
		$( ".question_thumb" ).each(function( index ) {
			 var id = $(this).attr('id');
			 var qqno = id.split('_')[2];
			$("#question_thumb_"+qqno).css('background-color','rgba(96, 70, 70, 0)');
			$("#question_thumb_"+qqno).css('border-color','#ed5565');
			$("#question_thumb_"+qqno).css('color','#ed5565');
		 });
		
		 for(var j=0;j<questionAttempted.length;j++)
		 {
			 $("#question_thumb_"+questionAttempted[j]).css('background-color','#d6c5c6');
			 $("#question_thumb_"+questionAttempted[j]).css('border-color','#d6c5c6');
			 $("#question_thumb_"+questionAttempted[j]).css('color','white');		
			 
			 
		 }
		 $("#question_thumb_"+questionNumToShow).css('background-color','#ec4758');
		 $("#question_thumb_"+questionNumToShow).css('border-color','#b69fa1');
		 $("#question_thumb_"+questionNumToShow).css('color','white');
		clearInterval(x);
		startQuestionTimer(questionNumToShow);
		
	});	
	
	$( ".prev" ).unbind().on('click',function(){
		var id = $(this).attr('id');
		var queNo = id.split('_')[1];
		var questionNumToShow = parseInt(queNo) - 1;
		$('.question_row').hide();
		$('#question_row_'+questionNumToShow).show();
		
		if(questionNumToShow===1)
		{
			$('.prev').hide();
			$('.next').show();	
		}
		$( ".question_thumb" ).each(function( index ) {
			 var id = $(this).attr('id');
			 var qqno = id.split('_')[2];
			$("#question_thumb_"+qqno).css('background-color','rgba(96, 70, 70, 0)');
			$("#question_thumb_"+qqno).css('border-color','#ed5565');
			$("#question_thumb_"+qqno).css('color','#ed5565');
		 });
		 for(var j=0;j<questionAttempted.length;j++)
		 {
			 $("#question_thumb_"+questionAttempted[j]).css('background-color','#d6c5c6');
			 $("#question_thumb_"+questionAttempted[j]).css('border-color','#d6c5c6');
			 $("#question_thumb_"+questionAttempted[j]).css('color','white');		
			 
			 
		 }
		 $("#question_thumb_"+questionNumToShow).css('background-color','#ec4758');
		 $("#question_thumb_"+questionNumToShow).css('border-color','#b69fa1');
		 $("#question_thumb_"+questionNumToShow).css('color','white');
		clearInterval(x);
		startQuestionTimer(questionNumToShow);	
	});	
	
	$( ".question_thumb" ).unbind().on('click',function(){
		 var id = $(this).attr('id');
		 var currentQueNo = id.split('_')[2];
		 var questionNumToShow = parseInt(currentQueNo);
		 clearInterval(x);
		 startQuestionTimer(questionNumToShow);	
		 if(questionNumToShow===1)
		 {
				$('.prev').hide();
				$('.next').show();	
		 }
		 if(questionNumToShow===totalQuestionCount)
		 {
				$('.next').hide();	
				$('.prev').show();				
		 }
		 else
		 {
			 $('.next').show();	
			 $('.prev').show();
		 }	 
			 $( ".question_thumb" ).each(function( index ) {
				 var id = $(this).attr('id');
				 var qqno = id.split('_')[2];
				$("#question_thumb_"+qqno).css('background-color','rgba(96, 70, 70, 0)');
				$("#question_thumb_"+qqno).css('border-color','#ed5565');
				$("#question_thumb_"+qqno).css('color','#ed5565');
			 });
			 for(var j=0;j<questionAttempted.length;j++)
			 {
				 $("#question_thumb_"+questionAttempted[j]).css('background-color','#d6c5c6');
				 $("#question_thumb_"+questionAttempted[j]).css('border-color','#d6c5c6');
				 $("#question_thumb_"+questionAttempted[j]).css('color','white');		
				 
				 
			 }
			 $("#question_thumb_"+questionNumToShow).css('background-color','#ec4758');
			 $("#question_thumb_"+questionNumToShow).css('border-color','#b69fa1');
			 $("#question_thumb_"+questionNumToShow).css('color','white');
			 $('.question_row').hide();
			 $('#question_row_'+questionNumToShow).show();
		 
		 	 
	});
	
	});
	</script>
</body>		