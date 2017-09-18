$(document).ready(function() {
		initTemplate();
		initFileSelector();
		initForm();
	});
	
	
	function initForm(){
		$('#submit-form').unbind().on("click",function(){
			
			var data=$('#slide_form').serialize();
			
			
			var getData=$('#slide_form').serializeArray();
			var match_questions="";
			var match_options="";
			var order_options="";

			try{
			$(getData).each(function(i, field){
				 if(field.name.toLowerCase().includes("bg_image-m-ques")){
					 match_questions+=field.name+",";
				 }
				 if(field.name.toLowerCase().includes("bg_image-m-option")){
					 match_options+=field.name+",";
				 }
				 
				 if(field.name.toLowerCase().includes("option-order-bg")){
					 order_options+=field.name+","; 
				 }
				 
				});			
			match_questions=match_questions.replace(/bg_image-m-ques/g,'');
			match_options=match_options.replace(/bg_image-m-option/g,'');
			order_options=order_options.replace(/option-order-bg-/g,'');
			
			match_questions=match_questions.endsWith(",")?match_questions.substr(0,match_questions.length-1):match_questions;
			match_options=match_options.endsWith(",")?match_options.substr(0,match_options.length-1):match_options;
			order_options=order_options.endsWith(",")?order_options.substr(0,order_options.length-1):order_options;
			}catch(err){
				
			}
			console.log('match_questions:'+match_questions+'--------- match_options:'+match_options+"-----order_options:"+order_options);
			data+="&match_questions="+match_questions+"&match_options="+match_options+"&order_options="+order_options;
			
			$.ajax({
				type : "POST",
				url : "/tfy_content_rest/interactive_slide",
				data : data,
				success : function(data) {
					$('#back-button')[0].click();
					
				}
			});
			
			
		});
		
		
	}

	function allowDrop(ev) {
		ev.preventDefault();
	}

	function drag(ev) {
		ev.dataTransfer.setData("text", ev.target.id);
	}

	function drop(ev) {
		ev.preventDefault();
		var data = ev.dataTransfer.getData("text");
		var position = $("#" + data).data('poistion');
		var contains = false;
		$("#" + ev.target.id).find('.match-icon-holder').children().each(
				function() {
					if ($(this).data('value') == position) {
						contains = true;
					}
				});

		if (!contains) {

			var inputVal = $("#" + ev.target.id).find(
					'.match-icon-holder>.option-correct').val();
			inputVal += "," + position;
			inputVal = inputVal.startsWith(",") ? inputVal.substring(1,
					inputVal.length) : inputVal;
			$("#" + ev.target.id).find('.match-icon-holder>.option-correct')
					.attr('value', inputVal);
			$("#" + ev.target.id).find('.match-icon-holder').append(
					"<span class='text-center match-icon' data-value='"+position+"'>"
							+ position + "</span>");
			initDragIcons();
		}
	}

	function initDragIcons() {
		$('.match-icon').unbind().on('click',
				function() {
					var inputVal = $(this).parent().find('.option-correct')
							.val();
					var input = inputVal.split(",");
					var pos = $(this).data('value');
					inputVal = "";
					for (var i = 0; i < input.length; i++) {
						if (input[i] != pos) {
							inputVal += "," + input[i];
						}
					}
					inputVal = inputVal.startsWith(",") ? inputVal.substring(1,inputVal.length) : inputVal;

					$(this).parent().find('.option-correct').attr('value',inputVal);
					$(this).remove();
				});

	}

	function initFileSelector() {
		$('.opt-preview').unbind().on('click', function(e) {
			if (e.target !== e.currentTarget)
				return;
			var cli = ($(this).attr('id').replace('option-preview-', ''));
			$('#bg_image_opt' + cli).click();
		});

		$('.opt_image_input').unbind().on('change',
				function(e) {
			
					if($(this).attr('type')!=undefined && $(this).attr('type')=='audio'){
						
					}else{
					
					$('#' + $(this).data('holder')).css('cssText',
							'border:none');
					}
					
					var inputFile = $(this);
					if (this && this.files[0]) {
						var formData = new FormData();
						formData.append('lesson_id', $('input[name=lesson_id]')
								.val());
						formData.append(this.files[0].name, this.files[0]);

						$.ajax({
							type : "POST",
							enctype : 'multipart/form-data',
							url : "/interactive_media_upload",
							data : formData,
							processData : false,
							contentType : false,
							cache : false,
							timeout : 600000,
							success : function(data) {
								console.log("SUCCESS : ", data);
								$(inputFile).next().attr('value', data.trim());
							},
							error : function(e) {
								console.log("ERROR : ", e);

							}
						});
						
						if($(this).data('holder')!=undefined){
							readBackgroundURL(this, $(this).data('holder'));
						}
					}
				});

		$('.bacground-part').unbind().on('click', function() {
			$('#' + $(this).data('holder')).click();
		});

		//implement plugin
		$('.opt-preview>p').unbind().editable().on('editsubmit', function(event, val) {
			$(this).next().attr('value',val);
		});

		$('#sortable').on("click", "li", function() {
			$('#option-preview-o' + $(this).data('id')).parent().remove();
			$(this).remove();

			$('#oderring-template>#sortable').children().each(function(i) {
				$(this).attr('data-order', (i + 1));
				$('input[name=order-based-correct-'+$(this).data('id')+']').attr('value', (i + 1));
			});
		});
		
		initDragIcons();
	}

	function readBackgroundURL(input, previewHolder) {
		if (input.files && input.files[0]) {
			var reader = new FileReader();
			reader.onload = function(e) {
				$('#' + previewHolder).css('background','url(' + e.target.result + ') no-repeat');
				$('#' + previewHolder).css("background-size", "100% 100%");
			}
			reader.readAsDataURL(input.files[0]);
		}
	}

	$.fn.extend({
		editable : function() {
			$(this).each(
					function() {
						var $el = $(this), $edittextbox = $(
								'<input type="text"></input>').css('min-width',
								$el.width()), submitChanges = function() {
							if ($edittextbox.val() !== '') {
								$el.html($edittextbox.val());
								$el.show();
								$el.trigger('editsubmit', [ $el.html() ]);
								$(document).unbind('click', submitChanges);
								$edittextbox.detach();
							}
						}, tempVal;
						$edittextbox.click(function(event) {
							event.stopPropagation();
						});

						$el.dblclick(function(e) {
							e.stopPropagation();
							tempVal = $el.html();
							$edittextbox.val(tempVal).insertBefore(this).bind(
									'keypress',
									function(e) {
										var code = (e.keyCode ? e.keyCode
												: e.which);
										if (code == 13) {
											submitChanges();
										}
									}).select();
							$el.hide();
							$(document).click(submitChanges);
						});
					});
			return this;
		}
	});

	function initTemplate() {

		dropZoneChange($('select[name=drop_zone]').val());
		$('select[name=drop_zone]').unbind().on('change', function() {
			dropZoneChange($(this).val());
		});

		slideTemplateChange($('select[name=slide_template]').val());
		$('select[name=slide_template]').unbind().on('change', function() {
			slideTemplateChange($(this).val());
		});

		$('.btn-add-match')
				.unbind()
				.on(
						"click",
						function() {

							var count = 0;
							var holder = $(this).data('type');
							var url = './interactive/match_template_based.jsp';
							count = $('.' + holder).children().length;
							var type = "ques";
							if (holder == 'match-holder-options') {
								type = "option";
							} else if (holder == 'match-holder-orders') {
								url = './interactive/order_template_based.jsp';
							}

							$
									.ajax({
										type : "GET",
										url : url,
										data : {
											position : (count + 1),
											type : type
										},
										success : function(data) {
											$('.' + holder).append(data);
											if (holder == 'match-holder-orders') {
												var list = "<li class='ui-state-default text-center' data-id='"
														+ (count + 1)
														+ "' data-order='"
														+ (count + 1)
														+ "'>Item "
														+ (count + 1) + "</li>";
												$('#oderring-template>#sortable').append(list);
											}

											initFileSelector();

										}
									});

						});

		$("#sortable").sortable({
			stop : function(event, ui) {
				console.log('ordering stopped');
				$('#oderring-template>#sortable').children().each(function(i) {
					$(this).attr('data-order', (i + 1));
					$('input[name=order-based-correct-'+$(this).data('id')+']').attr('value', (i + 1));
				});
			}
		});
		$("#sortable").disableSelection();

	}

	function slideTemplateChange(holder) {
		switch (holder) {
		case "D-T":
			$('.mobile_preview').hide();
			$('.dt-template').show();
			$('.option_navigation').hide();
			$('.option_navigation_dt').show();
			dropZoneChange($('select[name=drop_zone]').val());

			break;
		case "MATCH":
			$('.dt-template').hide();
			$('.mobile_preview').hide();
			$('.option_navigation').hide();
			$('.option_navigation_mt').show();
			$('.match-based-holder').show();
			break;
		case "ORDERING":
			$('.dt-template').hide();
			$('.mobile_preview').hide();
			$('.option_navigation').hide();
			$('.option_navigation_od').show();
			$('.order-based-holder').show();

			break;
		}
	}

	function dropZoneChange(holder) {
		if (holder == 'TOP') {
			$('.top-based-holder').show();
			$('.bottom-based-holder').hide();
		} else {
			$('.top-based-holder').hide();
			$('.bottom-based-holder').show();
		}
	}