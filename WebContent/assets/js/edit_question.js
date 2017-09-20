
function enableMarkingOptionAsCorrect()
{
	$('.option_marking_scheme').unbind().on('click',function(){
		
		var questionType = $('#questionType').val();
		var countOfCorectOptions = $('.correct_option').length;
		var countOfIncorectOptions =$('.incorrect_option').length;
		
		var optionCounterId = $(this).parents('.option_in_form').attr('id').replace('option_form_','');
		
		if(questionType==1)
		{
			if(countOfCorectOptions >= 1)
			{
				if($(this).hasClass('correct_option'))
				{
					$(this).removeClass('correct_option');
					$(this).addClass('incorrect_option');
					$('#prev_option_'+optionCounterId).children('.edit_option_text').data('is_correct',false);
					
				}else
				{
					//error only one correct is possible
					alert('cannot select more than one option as corect');
				}
			}
			else if(countOfCorectOptions==0)
			{
				if($(this).hasClass('incorrect_option'))
				{
					$(this).removeClass('incorrect_option');
					$(this).addClass('correct_option');
					$('#prev_option_'+optionCounterId).children('.edit_option_text').data('is_correct',true);
				}
				else if($(this).hasClass('correct_option'))
				{
					$(this).removeClass('correct_option');
					$(this).addClass('incorrect_option');
					$('#prev_option_'+optionCounterId).children('.edit_option_text').data('is_correct',false);
				}else
				{
					$(this).removeClass('incorrect_option');
					$(this).addClass('correct_option');
					$('#prev_option_'+optionCounterId).children('.edit_option_text').data('is_correct',true);
				}
			}			
		}
		else
		{
			if($(this).hasClass('incorrect_option'))
			{
				$(this).removeClass('incorrect_option');
				$(this).addClass('correct_option');
				$('#prev_option_'+optionCounterId).children('.edit_option_text').data('is_correct',true);
			}
			else if($(this).hasClass('correct_option'))
			{
				$(this).removeClass('correct_option');
				$(this).addClass('incorrect_option');
				$('#prev_option_'+optionCounterId).children('.edit_option_text').data('is_correct',false);
			}else
			{
				$(this).removeClass('incorrect_option');
				$(this).addClass('correct_option');
				$('#prev_option_'+optionCounterId).children('.edit_option_text').data('is_correct',true);
			}	
		}	
		
	});	

}


function enablePassageViewer()
{	
	
	$('#question_passage_details_form').hide();
	if($('#edit_passage_text').html()!=null)
	{
		$('#passageText').empty();
		$('#passageText').html($('#edit_passage_text').html());	
	}
	
	$('#question_passage_container').hide();
	
}

function enableExplanationViewer()
{
	
	
	$('#question_explanation_details_form').hide();
	if($('#edit_explanation_text').html()!=null)
	{
		$('#explanationText').empty();
		$('#explanationText').html($('#edit_explanation_text').html());	
	}
	$('#question_explanation_container').hide();
	$('#explanation_preview').unbind().on('click',function(){
		
		var explanationPrev = $('#e_prev').is(':visible');
		var questionPrev = $('#q_prev').is(':visible');
		if(explanationPrev)
		{
			$('#e_prev').hide();
			$('#q_prev').show();
			
			
			$('#question_details_form').hide();
			$('#question_passage_details_form').hide();		
			$('#question_explanation_details_form').show();
			
			$('#question_container').hide();
			$('#question_passage_container').hide();
			$('#question_explanation_container').show();
			
			
		}
		else if(questionPrev)
		{
			$('#q_prev').hide();
			$('#e_prev').show();
			
			
			$('#question_explanation_details_form').hide();
			$('#question_passage_details_form').hide();
			$('#question_details_form').show();		
			
			$('#question_passage_container').hide();
			$('#question_explanation_container').hide();
			$('#question_container').show();
		}	
		
		
		
		
		for(name in CKEDITOR.instances)
	    {
	        CKEDITOR.instances[name].destroy()
	    }
	});
}

function enableQuestionViewer()
{
	

	if($('#edit_question_text').html()!=null)
	{
		$('#questionText').empty();
		$('#questionText').html($('#edit_question_text').html());	
	}
	
	$('.edit_question_option').each(function(){
		var id = $(this).attr('id').replace('prev_option_','');
		var optionHtml = $(this).children('.edit_option_text').html();
		
		$('#option_form_'+id).find('.option_text').empty();		
		$('#option_form_'+id).find('.option_text').html(optionHtml);
	});
	
	
}

function addMoreOption(){
	//add_option
	
	var optionCount1 = 1;
    if($( "#option_container_form .option_in_form").length!=null && $( "#option_container_form .option_in_form").length!=0)
	{
		var lastOptionCounter1 = $("#option_container_form .option_in_form").first().attr('id').replace("option_form_","");
		optionCount1 = parseInt(lastOptionCounter1);
		
	}
    if(optionCount1>=5)
	{
		$('#add_option').hide();
	}
    
	$('#add_option').unbind().on('click',function(){
		//option_in_form
		//option_container_form
		var optionCount = 1;
		    if($( "#option_container_form .option_in_form").length!=null && $( "#option_container_form .option_in_form").length!=0)
			{
				var lastOptionCounter = $("#option_container_form .option_in_form").first().attr('id').replace("option_form_","");
				optionCount = parseInt(lastOptionCounter)+1;
				
			}
			
			var optionHTML =' \
				<div class="row my-3 option_in_form" id="option_form_'+optionCount+'"> \
					<div class="col-md-10 col-md-auto"> \
						<label><b>Option </b></label> \
						<div class="option_text" id="option_ckeditor_'+optionCount+'"> </div> \
					</div> \
					<div class="col-md-1 col-md-auto"> \
						<div style="margin-top: 25px;"> \
							<button type="button" class="btn option_marking_scheme incorrect_option">Correct</button> \
						</div> \
					</div> \
					<div class="col-md-1 col-md-auto m-auto"> \
						<a class="btn btn-icon btn-sm remove_option"> \
							<i class="fa fa-trash custom-btn-icon" aria-hidden="true"></i> \
						</a> \
					</div>  \
				</div>';
			
			$('#option_container_form').prepend(optionHTML);
			
			var optionPreviewHTML=' \
				<div class="row edit_question_option" id="prev_option_'+optionCount+'"> \
					<div class="col-md-12 edit_option_text" data-is_correct=false> \
					</div> \
				</div>';
			$('#option_prev_container').prepend(optionPreviewHTML);
		
			if(optionCount>=5)
			{
				$('#add_option').hide();
			}
			
			enableMarkingOptionAsCorrect();
			enableEdit();
			removeOption();
	});
}
function removeOption()
{

	$('.remove_option').unbind().on('click',function(){
		
		 var idToRemove = $(this).parents('.option_in_form').attr('id').replace('option_form_','');		 
		 $('#prev_option_'+idToRemove).remove();
		 $('#option_form_'+idToRemove).remove();
		 
		 if($('.option_in_form').length<5)
		 {
			 $('#add_option').show();
		 }
	});

}

function submitQuestionData()
{
	
	$('.submit_question').unbind().on('click',function(){
		var questionId = $('#questionID').val();
		var difficultyLevel = $('#difficultyLevel').val();
		var questionType = $('#questionType').val();
		var questionDuration = $('#questionDuration').val();	
		var questionText = $('#edit_question_text').html();	
		var passageText = '';
		if($('#edit_passage_text').html()!=null)
		{
			passageText = $('#edit_passage_text').html();
		}
		
		var explanationText ='';
		if($('#edit_explanation_text').html()!=null)
		{
			explanationText = $('#edit_explanation_text').html();
		}
		var durationIsNegative =false;
		var optionArray=[];
		var correctOptionCount=0;
		var optionEmpty = false;
		var singleChoiceError =  false;
		$('.edit_option_text').each(function(){
			var optionId= null;
			if($(this).parents('.edit_question_option').data('option_id')!=null)
			{
				optionId = $(this).parents('.edit_question_option').data('option_id');
			}
			var optionText=$(this).html();
			var markingScheme=0;
			
			if($(this).data('is_correct')==true)
			{
				markingScheme= 1;
				correctOptionCount++;
			}
			else
			{
				markingScheme= 0;
			}
			
			if($(this).text()!=null && $(this).text().trim().length>0 && $(this).text().trim()!==''){
				var optionObject ={'id':optionId, 'option_text':$.trim(optionText), 'markingScheme':markingScheme};
				optionArray.push(optionObject);
			}else{
				optionEmpty = true;
			}
			
			
		});
	
	
		var questionType = $('#questionType').val();
		if(questionType==1)
		{
			if(correctOptionCount > 1)
			{
				singleChoiceError= true;
			}
		}
		if($('#questionDuration').val()!=null && $('#questionDuration').val()<=0)
		{
			durationIsNegative =true;
		}	
			
		var sessionSkills = [];
		var learning_objectives =[];
		if($('#question_lo_selector').val()!=null)
		{
			var loArray = $('#question_lo_selector').val();
			$.each(loArray, function( index, value ) {
				if(jQuery.inArray({'id':value}, learning_objectives) == -1)
				{
					learning_objectives.push({'id':value});
				}				
			});
		}
		
		var skillOptGroup = $('#question_lo_selector :selected').parent();
		$(skillOptGroup).each(function(index){
			var optionSkill = $(this).attr('label');
			if(optionSkill!=null && jQuery.inArray(optionSkill, sessionSkills) == -1)
			{
				sessionSkills.push(optionSkill);
			}
		});
		
		var errorExist = false;
		var dataInErrorList='';
		
		if($('#edit_question_text').text()!=null && $('#edit_question_text').text().trim().length==0 && $('#edit_question_text').text().trim()==='')
		{
			errorExist = true;
			dataInErrorList+='<p>Question Text cannot be empty.</p>';
		}
		if(optionArray.length==0)
		{
			errorExist = true;
			dataInErrorList+='<p>Please provide atleast one option.</p>';
		}
		if(correctOptionCount==0){
			errorExist = true;
			dataInErrorList+='<p>Please mark atleast one option as correct option.</p>';
		}
		if(learning_objectives.length==0)
		{
			errorExist = true;
			dataInErrorList+='<p>Question should me mapped to atleast one learning objective. If you cannot find the learning objective required to map with the question. Take a step back and map that learning objective to any lesson of this course.</p>';
		}
		if(optionEmpty){
			errorExist = true;
			dataInErrorList+='<p>Option Text cannot be empty.</p>';
		}
		if(singleChoiceError)
		{
			errorExist = true;
			dataInErrorList+='<p>For question with type "Single Correct Option", multiple options cannot be marked as correct.</p>';
		}
		if(durationIsNegative)
		{
			errorExist = true;
			dataInErrorList+='<p>Duration of question cannot be negative or zero.</p>';
		}
		if(!errorExist)
		{
			var questionObject ={
					'id':questionId,
					'difficultyLevel':difficultyLevel,
					'questionType':questionType,
					'questionDuration':questionDuration,
					'questionText':$.trim(questionText),
					'passageText':$.trim(passageText),
					'explanationText': $.trim(explanationText),
					'options':optionArray,
					'learning_objectives':learning_objectives
			};		
			var questionJson = JSON.stringify(questionObject);
			//console.log(questionJson);
			if(questionId!=null && questionId!='null'){		
				$.ajax({
				    url: '../tfy_content_rest/question/update/'+ questionId,
				    type: "POST",
				    data: questionJson,
				    processData: false,
				    contentType: "application/json; charset=UTF-8",
				    success: function(data) {
				    	$('#editQuestionModal').modal('toggle');
				    	$('#question_'+questionId).find('td:eq(1)').html($.trim(questionText));
				    	$('#question_'+questionId).removeClass('level_1 level_2 level_3 level_4');
				    	$('#question_'+questionId).addClass('level_'+difficultyLevel);
				    	
				    	if(questionType==="1")
				    	{
				    		$('#question_'+questionId).find('td:eq(2)').html("S");
				    	}
				    	else if(questionType==="2")
				    	{
				    		$('#question_'+questionId).find('td:eq(2)').html("M");				    		
				    	}
				    	var updatedSkills ='';
				    	if(sessionSkills.length>0)
			    		{
				    		updatedSkills = sessionSkills.join(',<br>');
			    		}
				    	$('#question_'+questionId).find('td:eq(3)').html(updatedSkills);
				    }
				});
			}
			else
			{
				$.ajax({
				    url: '../tfy_content_rest/question/insert',
				    type: "POST",
				    data: questionJson,
				    processData: false,
				    contentType: "application/json; charset=UTF-8",
				    success: function(data) {
				    			    	
				    	$
						.get(
								'../tfy_content_rest/assessment/add_question/'
										+ data.id
										+ '/assessment/'
										+ window.assessmentID)
						.done(
								function(responseObject) {
									fillExistingQuestionsInAssessment();
							    	$('#editQuestionModal').modal('toggle');
								});
				    	
				    		
				    }
				});
			}
			
			
		}else
		{
			$('#que_error_list').empty();
			$('#que_error_list').append(dataInErrorList);
			var $alertMsg = $("#que_error").find('.alert');
			
			$alertMsg.on("close.bs.alert", function () {
				$('#que_error').hide();
			      return false;
			});
			$('#que_error').show();
		}	
			
		
	});
	
}


function enableEdit(){
	//$('#passageText').editable();
	 var editor= null;
	$('#edit_passage_text, #passageText').click(function(e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        for(name in CKEDITOR.instances)
        {
            CKEDITOR.instances[name].destroy()
        }
        
        editor = CKEDITOR.replace('passageText',{        	
       	height: '400px'
   		});
       editor.on('change',function(){
    	   var content = editor.getData();
    	   $('#edit_passage_text').empty();
    	   $('#edit_passage_text').append(content);
       });       
   });  
	
	
	
	$('#edit_explanation_text, #explanationText').click(function(e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        for(name in CKEDITOR.instances)
        {
            CKEDITOR.instances[name].destroy()
        }
        editor = CKEDITOR.replace('explanationText',{        	
        	height: '400px',
        	});
        editor.on('change',function(){
    	   var content = editor.getData();
    	   $('#edit_explanation_text').empty();
    	   $('#edit_explanation_text').append(content);
       });       
   });  
	
	$('#edit_question_text, #questionText').click(function(e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        for(name in CKEDITOR.instances)
        {
            CKEDITOR.instances[name].destroy()
        }
        editor = CKEDITOR.replace('questionText',{        	
        	height: '400px',
        	});
        editor.on('change',function(){
    	   var content = editor.getData();
    	   $('#edit_question_text').empty();
    	   $('#edit_question_text').append(content);
       });       
   });
	
	
	$('.edit_question_option, .option_text').click(function(e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        var optionId =null;
        if($(this).hasClass('edit_question_option'))
        {
        	optionId= $(this).attr('id').replace('prev_option_','');        	
        }else if($(this).hasClass('option_text'))
        {
        	optionId= $(this).parents('.option_in_form').attr('id').replace('option_form_','');
        }	
        for(name in CKEDITOR.instances)
        {
            CKEDITOR.instances[name].destroy()
        }
        if(optionId!=null)
        {
        	
        	editor = CKEDITOR.replace('option_ckeditor_'+optionId,{        	
            	height: '400px',
            	});
            editor.on('change',function(){
        	   var content = editor.getData();
        	   $('#prev_option_'+optionId).find('.edit_option_text').empty();
        	   $('#prev_option_'+optionId).find('.edit_option_text').append(content);
           }); 
        }	
              
   });
}




