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
<jsp:include page="/inc/head.jsp"></jsp:include>
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
<style>
.panel-default>.panel-heading {
	color: #333;
	background-color: #f5f5f5;
	border-color: #ddd;
}

.panel-heading {
	padding: 10px 15px;
	border-bottom: 1px solid transparent;
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
}

.panel-default {
	border-color: #ddd;
}

.panel {
	margin-bottom: 20px;
	background-color: #fff;
	border: 1px solid #eb384f;
	border-radius: 4px;
	-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
	box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
}

.panel-body {
	padding: 15px;
}
</style>
<body class="top-navigation" id="user_assessment"
	ng-app="user_assessment" ng-controller="user_assessmentCtrl">

	<jsp:include page="/inc/navbar.jsp"></jsp:include>
	<div class="jumbotron gray-bg">

		<div class="container">
			<div class="row mt-5">
				<div class="col-10">
					<h2>
						Assessment -
						<%=assessment.getName() %></h2>
					<h4>
						Number of Questions #
						<%=queCount%>
					</h4>
				</div>
				<div class="col-2">
					<button class="btn btn-primary btn-xs" type="button"
						style='background-color: #eb384f; border: none; float: right; line-height: 1.55; font-size: 16px; outline: none;'>
						<i class="fa fa-clock-o"></i> &nbsp;&nbsp; <span class="bold"
							id="demo"> </span>
					</button>
				</div>

			</div>

			<div class="row mt-5">
				<div class="col-12  text-center">


					<%for(int i=1;i<=questions.size();i++)
					{
					%>
					<button class="btn btn-danger btn-lg btn-outline question_thumb"
						type="button"
						style="margin-bottom: 11px; padding: 10px 16px; font-size: 18px; line-height: 1.3333333;"
						id="question_thumb_<%=i%>"><%=i%></button>
					<%}%>
				</div>
			</div>
			<form role="form" method="post" action="/submit_assessment"
				id="target">
				<input type="hidden" name="assessment_id" value="<%=assessmentId%>">
				<input type="hidden" name="task_id" value="<%=taskId%>">
				<% 
			
			for(int i=1;i<=questions.size();i++)
				{
				QuestionPOJO quePojo = questions.get(i-1);
					%>

				<div class="row question_row" id="question_row_<%=i%>"
					data-time_in_sec="<%=quePojo.getDurationInSec()%>">


					<div class="col-7">
						<div class="panel panel-default">
							<div class="panel-heading"
								style="font-size: 17px; font-weight: bold; color: #ed5565;">
								Question #<%=i%>
								<button type="button" class="btn btn-primary btn-xs float-right"
									style='background-color: #eb384f; border: none; line-height: 1.2; font-size: 16px;'>
									<i class="fa fa-clock-o"></i> &nbsp;&nbsp; <span class="bold"
										id="que_clock_<%=i%>"> </span>
								</button>
							</div>
							<div class="panel-body" style="user-select: none !important;">
								<p>
									<%=quePojo.getText()%>
								</p>
							</div>
						</div>
					</div>
					<div class="col-5">
						<div class="panel panel-default">
							<div class="panel-heading"
								style="font-size: 17px; font-weight: bold; color: #ed5565;">
								Choose the correct answer</div>
							<div class="panel-body" style="user-select: none !important;">
								<input type="hidden"
									name="question_time_taken_<%=quePojo.getId()%>" value=""
									id="question_time_taken_<%=i%>">
								<p>
									<%
                                            ArrayList<OptionPOJO> options = ( ArrayList<OptionPOJO>)quePojo.getOptions();
                                            
                                            if(!quePojo.getType().equalsIgnoreCase("1"))
                                            {
                                            	for(OptionPOJO option: options)
                                                {
                                                	%>
								
								<div>
									<label><input class="question_option" type="checkbox"
										value="<%=option.getId()%>"
										name="option_for_question_<%=quePojo.getId()%>"
										id="questionOption_<%=i%>"> &nbsp;<%=option.getText()%></label>
								</div>
								<%
                                                }
                                            }
                                            else
                                            {
                                            	for(OptionPOJO option: options)
                                                {
                                                	%>
								<div>
									<label><input class="question_option" type="radio"
										value="<%=option.getId()%>"
										name="option_for_question_<%=quePojo.getId()%>"
										id="questionOption_<%=i%>"> &nbsp;<%=option.getText()%></label>
								</div>
								<%
                                                }
                                            }	
                                            
                                            %>
								</p>
							</div>
						</div>
						<div class='w-100' style="min-height: 80px;">
						<button type="button"
							class="btn btn-w-m btn-danger prev float-left"
							style='background-color: #eb384f; border: none; line-height: 1.55; font-size: 16px; outline: none;'
							id="prev_<%=i%>">Prev Question</button>
						&nbsp; &nbsp;&nbsp;
						<button type="button"
							class="btn btn-w-m btn-danger next float-right"
							style='background-color: #eb384f; border: none; line-height: 1.55; font-size: 16px; outline: none;'
							id="next_<%=i%>">Next Question</button>
							</div>
						&nbsp; &nbsp;&nbsp;
						<button type="button" class="btn btn-w-m btn-danger mt-2 float-right skip_assessment"
							style='background-color: #eb384f; border: none; line-height: 1.55; font-size: 16px; outline: none;float: right'
							>Skip Questions & Submit</button>
							
							<button type="button" class="btn btn-w-m btn-danger mt-2 float-right submit_assessment"
							style='background-color: #eb384f; border: none; line-height: 1.55; font-size: 16px; outline: none;float: right'
							>Submit Assessment</button>
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
	<jsp:include page="/inc/foot.jsp"></jsp:include>
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
		
		if(parseInt(queNo)==1 && totalQuestionCount==1){
			  $('.submit_assessment').show();
				 $('.skip_assessment').hide();
				 $('.next').hide();	
				 $('.prev').hide();
		}
		
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
				  if(seconds===0 || minutes<0)
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
		
				
		if(questionNumToShow<=totalQuestionCount){
			startQuestionTimer(questionNumToShow);
		}
		
		
		 if(questionNumToShow===1)
		 {
				$('.prev').hide();
				$('.next').show();	
				 $('.submit_assessment').hide();
				 $('.skip_assessment').show();
		 }
		 
		 
		 
		 if(questionNumToShow===totalQuestionCount)
		 {
			 $('.submit_assessment').show();
			 $('.skip_assessment').hide();
			 $('.next').hide();	
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
		 else if(questionNumToShow<=totalQuestionCount){
			 $('.next').show();	
			 $('.prev').show();
			 $('.submit_assessment').hide();
			 $('.skip_assessment').show();
			 
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
		$( ".submit_assessment").unbind().on('click',function() {			  
			swal({
                title: "Are you sure ?",
                text: "Your assessment will be submitted now.",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, Submit it!",
                cancelButtonText: "No, cancel plx!",
                closeOnConfirm: false,
                closeOnCancel: false },
            function (isConfirm) {
                if (isConfirm) {
                	
                    swal("Submitted!", "Your assessment submitted successfully.", "success");
                    sumbitAssessment();
                    
                } else {
                    swal("Cancelled", "Your assessment submission cancelled", "error");
                }
            });
});
		
		$( ".skip_assessment").unbind().on('click',function() {			  
			swal({
                title: "Are you sure about skipping ?",
                text: "Remaining questions will be skipped and your assessment will be submitted now.",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, Submit it!",
                cancelButtonText: "No, cancel plx!",
                closeOnConfirm: false,
                closeOnCancel: false },
            function (isConfirm) {
                if (isConfirm) {
                	 
                    swal("Submitted!", "Your assessment submitted successfully.", "success");
                    sumbitAssessment();
                   
                } else {
                    swal("Cancelled", "Your assessment submission cancelled", "error");
                }
            });
});
		
		
	assessmentStartTime = new Date().getTime();	
	$('.question_row').hide();
	$('.submit_assessment').hide();
	$('.skip_assessment').show();
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
	  if(minutes===3 && seconds ===0)
		{
		  //remind for end of assessment
		  swal({
              title: "Hurry Up",
              text: "Only 3 minutes left for the assessment."
          });

		}
	  else if((minutes===0 && seconds ===0) || (minutes<0))
	  {
		  clearInterval(xx);
		  sumbitAssessment();
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
		 assessmentStartTime = new Date().getTime();
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
			$('.submit_assessment').show();
			 $('.skip_assessment').hide();
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
			$('.submit_assessment').hide();
			$('.skip_assessment').show();
		}
		else
		{
			$('.next').show();
			$('.submit_assessment').hide();
			$('.skip_assessment').show();
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
		 if(questionNumToShow==1 && totalQuestionCount==1){
		     $('.submit_assessment').show();
			 $('.skip_assessment').hide();
			 $('.next').hide();	
			 $('.prev').hide();
		} else if(questionNumToShow===1)
		 {
				$('.prev').hide();
				$('.next').show();
				$('.submit_assessment').hide();
				$('.skip_assessment').show();
		 }else if(questionNumToShow===totalQuestionCount)
		 {
				$('.next').hide();	
				$('.prev').show();	
				$('.submit_assessment').show();
				$('.skip_assessment').hide();
		 }
		 else
		 {
			 $('.next').show();	
			 $('.prev').show();
			 $('.submit_assessment').hide();
			 $('.skip_assessment').show();
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
	
	$(document).on("keydown", disableF5);
	
	 $('body').bind('cut copy paste', function (e) {
	        e.preventDefault();
	    });
	   
	    //Disable mouse right click
	    $("body").on("contextmenu",function(e){
	        return false;
	    });
	    
	    var elem = document.body; // Make the body go full screen.
		requestFullScreen(elem);
		

	});
	
	function sumbitAssessment(){
		    $.ajax({
		     type: "POST",
		      url: $("#target").attr('action'),
		      data: $("#target").serialize(),
		      success: function() {
			    	window.close();	
		       }
		    });
	}
	
	

	
	function disableF5(e) { if ((e.which || e.keyCode) == 116 || (e.which || e.keyCode) == 82) e.preventDefault(); };

	</script>
</body>
