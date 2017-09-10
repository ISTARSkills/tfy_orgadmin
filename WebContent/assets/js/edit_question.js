function enableCorrectQuestionSelector()
{
	$('.edit_option_text').each(function(){
		if($(this).data('is_correct')==true)
		{
			//$(this).parent('.edit_question_option').css('background-color','#7ed321');
			//$(this).parent('.edit_question_option').css('color','white');
		}
	});
}

function enableMarkingOptionAsCorrect()
{
	$('.option_marking_scheme').unbind().on('click',function(){
		var optionId = $(this).attr('id').replace('option_marking_scheme_','');
		if($(this).hasClass('incorrect_option'))
		{
			$(this).removeClass('incorrect_option');
			$(this).addClass('correct_option');
		}
		else if($(this).hasClass('correct_option'))
		{
			$(this).removeClass('correct_option');
			$(this).addClass('incorrect_option');
		}else
		{
			$(this).removeClass('incorrect_option');
			$(this).addClass('correct_option');
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
	$('#passage_preview').unbind().on('click',function(){
		$('#question_details_form').hide();
		$('#question_explanation_details_form').hide();
		$('#question_passage_details_form').show();
		
		$('#question_container').hide();
		$('#question_explanation_container').hide();
		$('#question_passage_container').show();		
		
		for(name in CKEDITOR.instances)
	    {
	        CKEDITOR.instances[name].destroy()
	    }
	});
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
		$('#question_details_form').hide();
		$('#question_passage_details_form').hide();		
		$('#question_explanation_details_form').show();
		
		$('#question_container').hide();
		$('#question_passage_container').hide();
		$('#question_explanation_container').show();
		
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
		var id = $(this).attr('id').replace('option_','');
		var optionHtml = $(this).children('.edit_option_text').html();
		
		$('#option_text_'+id).empty();
		$('#option_text_'+id).html(optionHtml);
	});
	
	$('#question_preview').unbind().on('click',function(){	
				
		$('#question_explanation_details_form').hide();
		$('#question_passage_details_form').hide();
		$('#question_details_form').show();		
		
		$('#question_passage_container').hide();
		$('#question_explanation_container').hide();
		$('#question_container').show();
		
		for(name in CKEDITOR.instances)
	    {
	        CKEDITOR.instances[name].destroy()
	    }
		
		
	});
}

function enableEdit(){
	//$('#passageText').editable();
	 var editor= null;
	$('#edit_passage_text, #passageText').click(function(e) {
        e.stopPropagation();
        e.preventDefault();
        for(name in CKEDITOR.instances)
        {
            CKEDITOR.instances[name].destroy()
        }
        
        editor = CKEDITOR.replace('passageText',{        	
       	height: '400px',
   		});
       editor.on('change',function(){
    	   var content = editor.getData();
    	   $('#edit_passage_text').empty();
    	   $('#edit_passage_text').append(content);
       });
       //$('#passageText').editable('toggle');
   });  
	
	
	
	$('#edit_explanation_text, #explanationText').click(function(e) {
        e.stopPropagation();
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
	
	
	//
	$('#edit_question_text, #questionText').click(function(e) {
        e.stopPropagation();
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
        e.stopPropagation();
        e.preventDefault();
        var optionId =null;
        if($(this).hasClass('edit_question_option'))
        {
        	optionId= $(this).attr('id').replace('option_','');
        }else if($(this).hasClass('option_text'))
        {
        	optionId= $(this).attr('id').replace('option_text_','');
        }	
        for(name in CKEDITOR.instances)
        {
            CKEDITOR.instances[name].destroy()
        }
        if(optionId!=null)
        {
        	editor = CKEDITOR.replace('option_text_'+optionId,{        	
            	height: '400px',
            	});
            editor.on('change',function(){
        	   var content = editor.getData();
        	   $('#edit_option_text_'+optionId).empty();
        	   $('#edit_option_text_'+optionId).append(content);
           }); 
        }	
              
   });
}




