
var webSocket ;
function readyFn(jQuery) {
	 
	$.fn.extend({
	    treed: function (o) {
	        
	        var openedClass = 'glyphicon-minus-sign';
	        var closedClass = 'glyphicon-plus-sign';
	        
	        if (typeof o != 'undefined'){
	          if (typeof o.openedClass != 'undefined'){
	          openedClass = o.openedClass;
	          }
	          if (typeof o.closedClass != 'undefined'){
	          closedClass = o.closedClass;
	          }
	        };
	        
	          //initialize each of the top levels
	          var tree = $(this);
	          tree.addClass("tree");
	          tree.find('li').has("ul").each(function () {
	              var branch = $(this); //li with children ul
	              branch.prepend("<i class='indicator glyphicon " + closedClass + "'></i>");
	              branch.addClass('branch');
	              branch.on('click', function (e) {
	                  if (this == e.target) {
	                      var icon = $(this).children('i:first');
	                      icon.toggleClass(openedClass + " " + closedClass);
	                      $(this).children().children().toggle();
	                  }
	              })
	              branch.children().children().toggle();
	          });
	          //fire event from the dynamically added icon
	        tree.find('.branch .indicator').each(function(){
	          $(this).on('click', function () {
	              $(this).closest('li').click();
	              $('.fa').show();
	              $('div.progress div').show();
	          });
	        });
	          //fire event to open branch if the li contains an anchor instead of text
	          tree.find('.branch>a').each(function () {
	              $(this).on('click', function (e) {
	                  $(this).closest('li').click();
	                
	                  e.preventDefault();
	              });
	          });
	          //fire event to open branch if the li contains a button instead of text
	          tree.find('.branch>button').each(function () {
	              $(this).on('click', function (e) {
	                  $(this).closest('li').click();
	                  $('.fa').show();
	                  e.preventDefault();
	              });
	          });
	      }
	  });

		$('.tree1').treed();
	    
		//
	
	initiateGraphFilter();
	createGraphs();
	createDataTables();
	
	 $('.fa').show();
     $('div.progress div').show();
	
	/*
	 * Page specific js
	 */
	var body_id = document.getElementsByTagName("body")[0].id;
	
	$('.top_navbar_holder').css('color',' #676a6c');	
	switch (body_id) {
	case 'orgadmin_dashboard':
		init_orgadmin_dashboard();
		$('#Dashboard').css('color','  #eb384f');
		initChat();	
		initUnreadChatAndNotification();
		
		break;
	case 'orgadmin_admin':
		init_orgadmin_admin();
		$('#Admin').css('color','  #eb384f');
		break;
	case 'orgadmin_scheduler':
		init_orgadmin_scheduler();
		
		$('#Scheduler').css('color','  #eb384f');
		break;
		
	case 'orgadmin_report':
		init_orgadmin_report();
		
		$('#Reports').css('color','  #eb384f');
		break;
	
	case 'orgadmin_report_detail':
		init_orgadmin_report_detail();
		$('#Reports').css('color','  #eb384f');
		break;
	case 'superadmin_dashboard':
		init_super_admin_dashboard();
		initChat();	
		initUnreadChatAndNotification();
		$('#wizard').steps();
		$('#Dashboard').css('color','  #eb384f');
		break;
	case 'super_admin_account_managment':
		init_super_admin_account_mgmt();
		$('#AccountManagement').css('color','  #eb384f');
		break;
	case 'super_admin_user_managment':
		init_super_admin_usermgmt();
		$('#UserManagement').css('color',' #eb384f');
		break;
	case 'super_admin_scheduler':
		init_super_admin_scheduler();
		
		$('#Scheduler').css('color','  #eb384f');
		break;	
	case 'super_admin_analytics':
		init_super_admin_analytics();
		$('#Analytics').css('color','  #eb384f');
		break;

	case 'super_admin_comp_prof':
		init_super_admin_comp_prof();
		//$('#Dashboard').css('color',' #eb384f');
		break;
	case 'super_admin_placemenet':
		init_super_admin_placemenet();
	//	$('#Dashboard').css('color',' #eb384f');
		break;
	case 'super_admin_classroom':
		init_superadmin_class_room();

		$('#Classrooms').css('color','  #eb384f');
		break;
	case 'super_admin_report':
		init_super_admin_report();

		$('#StudentsReports').css('color','  #eb384f');
		break;
	case 'istar_notification':
		init_istar_notification();
		$('#Notification').css('color',' #eb384f');
		break;
	case 'super_admin_tickets':	
		initTicket();
		$('#Tickets').css('color',' #eb384f');
	case 'org_admin_tickets':	
		initTicket();
		$('#Tickets').css('color','  #eb384f');
	case 'student_dashboard':	
		$('#equalheight div.product-box').equalHeights();
	default:
		init_orgadmin_none();
	}
	
	createCalender();
	setInterval(event_details_card,3000);
	setInterval(init_session_logs, 10000);
	$('select').select2();
	loadTables();	
	$('#equalheight div.product-box').equalHeights();
}

function initUnreadChatAndNotification()
{
	//here last 8 unread notifications will be displayed in screen in the form of alert notification.
	//apart from top 8 other messages will be available in notification tab.
		
		//alert message will disappear automatically and can be removed manually
		$('.notification_item').delay(8000).fadeOut('slow', function () {
		     $(this).remove();	
		});
	
	//if notification is removed manually it will be marked as read.	
	$('.notification_close').unbind().on('click',function(){
		var notice_id = $(this).data("notice_id");
		var group_code = $(this).data("group_code");
		var notice_type = $(this).data("notice_type");		
		 var url = "/mark_notice_as_read";
		 $.ajax({
		        type: "POST",
		        url: url,
		        data: {notice_id:notice_id,group_code:group_code,notice_type:notice_type},
		        success: function(data) {		        	
		        
		        	var noticeCountPrev = $('#dashboard_notice_count').text();
		        	if(noticeCountPrev!=null && noticeCountPrev!=0)
		        	{
		        		
		        		var newNoticeCount = noticeCountPrev-1;		        		
		        		$('#dashboard_notice_count').text(newNoticeCount);
		        		if(newNoticeCount==0)
		        		{
		        			$('#no_notice_available').show();
		        		}else if(newNoticeCount <8)
		        		{
		        			$('.read_more_notification').hide();
		        			$('#no_notice_available').hide();
		        		}else
		        		{
		        			$('.read_more_notification').show();
		        			$('#no_notice_available').hide();
		        		}	
		        		
		        	}
		        	else 
		        	{
		        		$('.read_more_notification').hide();
		        		$('#no_notice_available').show();
		        	}	
		        }		        
		    });
	});
	
	//update notification count in notification tab
	//hidden id defined in dashboard_notification.jsp 
	var notice_count = $('#total_unread_notice').val();
	if(notice_count==0){
		$('.read_more_notification').hide();
		$('#no_notice_available').show();
	}	
	else{
		if(notice_count<8)
			{
				$('.read_more_notification').hide();
				$('#no_notice_available').hide();
				$('#dashboard_notice_count').text(notice_count);
			}
		else {
			$('.read_more_notification').show();
			$('#no_notice_available').hide();
			$('#dashboard_notice_count').text(notice_count);
		}		
	}
	//get more notoification and append to notification tab 
	$('.read_more_notification').unbind().on('click',function(){
		var prevOffset = $('.alert-dismissable').length;
		var newOffset = prevOffset+8;
		var not_count = $('#total_unread_notice').val();
		if(newOffset <= notice_count){
			var url = "/dashboard_notification.jsp";
			 $.ajax({
			        type: "POST",
			        url: url,
			        data: {offset:newOffset},
			        success: function(data) {
			        	if(data!=null)
			        		{
			        			if($('#admin_notifications .alert-dismissable').length===0)
			        			{
			        				$(data).insertBefore( $('.read_more_notification'));
			        			}
			        			else
			        			{
			        				$(data).insertAfter( $('#admin_notifications .alert-dismissable').last() );
			        			}				        						        						        			
			        		}
			        }
			    });
		}				
	});
}

function initTicket()
{
	
	$('#open_ticket').unbind().on('click', function(e) {
		$('#create_new_ticket_modal').modal();
		$("#new_ticket_form").bind("keypress", function(e) {
            if (e.keyCode == 13) {
               return false;
            }
         });
		
		$('.tagsinput').tagsinput({
            tagClass: 'label label-primary',
            confirmKeys: [32,13,188]
        });

		
	});
	
	
/*$('#create_new_ticket').unbind().on('click', function(e) {	
		 e.preventDefault();
		 $("#new_ticket_form").validate({
		        rules: {
		            title: {
		                required: true
		            },
		            details: {
		                required: true
		            },
		            ticket_type: {
		                required: true
		                
		            },
		            receivers: {
		                required: true		               
		            }
		        }
		    });
		 
		 
		 var url = "../../create_new_ticket";
		 $.ajax({
		        type: "POST",
		        url: url,
		        data: $("#new_ticket_form").serialize(), // serializes the form's elements.
		        success: function(data) {
		        	location.reload();
		        }
		    });
	});*/
	
	
	$('.ticket_summary_button').unbind().on('click', function() {	 
    	var ticket_id = $(this).data("ticket_id");
    	var your_jsp_page_to_request = "/ticket_summary.jsp";			 			 
		$.post(your_jsp_page_to_request,{ticket_id:ticket_id},		     
		     function(data){			
			//alert(data);
				$(".ticket_summary_body").empty();
				$(".ticket_summary_body").append(data);		  			
  		  		$('#ticket_summary_modal').modal();
  		  	 $('#ticket_summary_modal').on('hidden.bs.modal', function () {
  		    	
  		  		location.reload();
  		    	  
  		    	});
  		  		$('.ticket_status_change').on('click', function() {
  				//alert("asdas");
  		  		var ticketId = null;
  		  	    var status = null;
  		  	    var ticket_status= $(this);
  				 ticketId= $(this).data("ticket_id");
  				 status = $(this).data("status");
  				 $('#admin_page_loader').show();
  				$.ajax({
  		            type: "POST",
  		            url: "/change_ticket_status",
  		            data: {ticketId:ticketId, status:status},
  		            success: function(data){
  		            	var res = data;
  		            	if(res==='CLOSED')
  		            	{
  		            		//$(this).data("status","REOPENED");
  		            		$(ticket_status).data("status","REOPENED");
  	  		            	$(ticket_status).html("Re Open Ticket");
  	  		                $('#ticket_modal_status').html("CLOSED");
  	  		              //  $('#ticket_table_status').html("CLOSED");
  		            	}
  		            	else if(res==='REOPENED')
  		            	{
  		            		//$(this).data("status","CLOSED");
  		            		 $(ticket_status).data("status","CLOSED");
  	  		            	 $(ticket_status).html("Close Ticket");
  	  		                 $('#ticket_modal_status').html("REOPENED");
  	  		               //  $('#ticket_table_status').html("REOPENED");
  		            	}  	
  		            	$('#admin_page_loader').hide();
  		            }
  		        });
  				
  			});
  		  		
		     }
		 );
		
		
		
	});
	
	$(document).unbind().on('keypress','#add_comment_to_ticket', function (e) {

  		if (e.keyCode === 13) {
  			var tiketId = $(this).data("ticket_id");
  			var commentBy = $(this).data("commented_by");
  			var message = $(this).val();
  			if(message!='')
  			{
  				var your_jsp_page_to_request = "/ticket_comment.jsp";			 			 
  				$.post(your_jsp_page_to_request,{ticket_id:tiketId, message:message},		     
  				     function(data){			
  						$('#ticket_messages').append(data);
  						$('#add_comment_to_ticket').val("")
  						$('#add_comment_to_ticket').focus();
  						var d = $('#ticket_messages');
  		  				d.scrollTop(d.prop("scrollHeight"));
  		  			$.ajax({
  	  		            type: "POST",
  	  		            url: "/add_comment_to_ticket",
  	  		            data: {ticketId:tiketId, message:message,commentBy:commentBy},
  	  		            success: function(data){
  	  		            		
  	  		            	
  	  		            }
  	  		        });
  		  				
  				     }
  				 );
  			}
  			return false;
  		}
  		
	});	
	
}

function createDataTables()
{
	$("table.datatable_istar" ).each(function() {
		var id = $(this).attr('id');
		var url = '../data_table_controller?';
		var params ={}; 
		$.each($(this).context.dataset, function( index, value ) {		
			url +=index+'='+value+'&';						
			});		
		
		if ( $.fn.dataTable.isDataTable(this) ) {
		    console.log('dddd');
		    //this.DataTable();
		}
		else
		{
			console.log('>>>>eee>>>');
			$(this).DataTable({
		         pageLength: 10,
		         responsive: true,
		         dom: '<"html5buttons"B>lTfgitp',
		         buttons: [
		             { extend: 'copy'},
		             {extend: 'csv'},
		             {extend: 'excel', title: 'ExampleFile'},
		             {extend: 'pdf', title: 'ExampleFile'},
		             {extend: 'print',
		              customize: function (win){
		                     $(win.document.body).addClass('white-bg');
		                     $(win.document.body).css('font-size', '10px');
		                     $(win.document.body).find('table')
		                             .addClass('compact')
		                             .css('font-size', 'inherit');
		             }
		             }
		         ], "processing": true,
		         "serverSide": true,
		         "ajax": url,
		         "drawCallback": function( settings ) {
		            
		         }
		     });
			
			$(this).on( 'draw.dt', function () {
			    callColumnHandlerFunctions();
			});
			$('.dataTables_info').hide();
			
		}	
		
		
		
	});
	
	
}

function  callColumnHandlerFunctions(){
	initEditUserModalCall();
	initEditGroupModalCall();
	initDeleteGroupCall();
	initStudentProfileHandler();
}

function initStudentProfileHandler()
{
	$('.admin_student_holder').unbind().on("click",function(){
		$('#admin_page_loader').show();
    	var student_id=$(this).data('target');
    	var jsp="/student_card.jsp";
    	$.post(jsp, 
				{student_id:student_id}, 
				function(data) {
					$('#admin_student_card_modal').empty();
					$('#admin_student_card_modal').append(data);
					$('.tree1').treed();					
					$('#admin_page_loader').hide()
					$('#admin_student_card_modal').modal();
					userValidation();
					
		});
	 });		
}
function initDeleteGroupCall()
{
	$('.delete_group').click(function () {
    	var groupName = $(this).data('group_name');
    	var groupId = $(this).data('group_id');
    	var $trTobeDelete = $(this).parents('tr');
        swal({
                    title: "Are you sure about deleting this Group - "+groupName+" ?",
                    text: "All events, batches, and statistics will be deleted.!",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Yes, delete it!",
                    cancelButtonText: "No, cancel!",
                    closeOnConfirm: false,
                    closeOnCancel: false },
                function (isConfirm) {
                    if (isConfirm) {
                    	
                    	var urls = '../delete_group?group_id='+groupId;
    	    	        $.get(urls, function(data) {    	    	        	
    	    	        	swal("Deleted!", groupName+" has been deleted.", "success"); 
    	    	        	$trTobeDelete.remove();
    	    	        });   	                            		                            	
                    } else {
                        swal("Cancelled", "Group deletion cancelled successfully.", "error");
                    }
                });
        
    });
	
}

function markUserAsDropOut()
{
	 $(".user-edit-popup").unbind().on("click",function(){
		 		 
		 var user_id =  $(this).data('user_id');
		 var url ="../mark_student_as_dropout?user_id="+user_id;
		 $.get( urls, function( data ) {
			 
   		});
		 
	 });
}

function initEditGroupModalCall()
{
	 $(".group-edit-popup").unbind().on("click",function(){
	    	var group_id =  $(this).data('group_id');
	    	var urls = '../modal/admin_batch_group_modal.jsp?bg_id='+group_id;
	    	$.get( urls, function( data ) {
	    		
	    		$('#edit_group_modal_content').empty();
	    		$('#edit_group_modal_content').append(data);
	    		
	    		var cid = $('#edit_member_filter_by').data("college_id");
	    		
	    		
	    		var urls = '../get_filtered_students?entity_id='+cid+'&filter_by=ORG&batch_group_id='+group_id;
	    	    $.get(urls, function(data) {
	    	    	$('#edit_student_list_holder').empty();
	    	    	$('#edit_student_list_holder').append(data);
	    	    	$('#edit_student_list_holder').select2();
	    	    	
	    	    });
	    		
	    		
	    	    $('#edit_member_filter_by').unbind().on("change",function (){
	    	    	var filterBy=$(this).val();
	    	    	var collegeId = $(this).data("college_id");
	    	    	
	    	    	if(filterBy==='ROLE')
	    	    	{
	    	    		var urls = '../get_filtered_groups?college_id='+collegeId+'&filter_by='+filterBy;
	    	            $.get(urls, function(data) {
	    	            	$('#edit_role_section_options').empty();
	    	            	$('#edit_role_section_options').append(data);
	    	            	$('#edit_role_section_options').select2();
	    	            });
	    	    		$('#edit_role_section_holder').show();
	    	    	}
	    	    	else if(filterBy==='SECTION')
	    	    	{
	    	    		var urls = '../get_filtered_groups?college_id='+collegeId+'&filter_by='+filterBy;
	    	            $.get(urls, function(data) {
	    	            	$('#edit_role_section_options').empty();
	    	            	$('#edit_role_section_options').append(data);
	    	            	$('#edit_role_section_options').select2();
	    	            });
	    	    		$('#edit_role_section_holder').show();
	    	    	}
	    	    	else
	    	    	{    		
	    	    		$('#edit_role_section_holder').hide();
	    	    		var urls = '../get_filtered_students?entity_id='+collegeId+'&filter_by=ORG&batch_group_id='+group_id;
	    	            $.get(urls, function(data) {
	    	            	$('#edit_student_list_holder').empty();
	    	            	$('#edit_student_list_holder').append(data);
	    	            	$('#edit_student_list_holder').select2();
	    	            });
	    	    	}    	 
	    	    });
	    	    
	    	    $('#edit_role_section_options').unbind().on("change",function (){
	    	    	var groupId = $(this).val();    	
	    	    	var urls = '../get_filtered_students?entity_id='+groupId+'&filter_by=GROUP&batch_group_id='+group_id;
	    	        $.get(urls, function(data) {
	    	        	$('#edit_student_list_holder').empty();
	    	        	$('#edit_student_list_holder').append(data);
	    	        	$('#edit_student_list_holder').select2();
	    	        });        
	    	    });
	    		
	    	    $('select').select2();
	    		$('#edit_group_modal').modal();	    		   		 
	    		});
	    	// open modal using js now 
	    	// action goes here!!
	    });
}

function userValidation(){
	
	 $("#formUser").validate({
	        rules: {
	        	user_f_name: {
	                required: true,
	               
	            },
	            user_gender: {
	            	 selectcheck: true,
	               
	            },
	            user_mobile: {
	                required: true,
	               
	            },
	            user_email: {
	                required: true,
	               
	            }
	        }
	    });
}
function initEditUserModalCall()
{
	 $(".user-edit-popup").unbind().on("click",function(){
	    	var user_id =  $(this).data('user_id');
	    	var urls = 'partials/modal/admin_user_edit_modal.jsp?user_id='+user_id;
	    	$.get( urls, function( data ) {	    		  	    		  
	    		  if($('#edit_user_model_'+user_id).length>0){
	    			  $('#edit_user_model_'+user_id).remove(); 
	    		  }
	    		  $( "body" ).append(data);
	    		  $('select').select2();
	    		  admin_edit_modal_create();
	    		  $('#edit_user_model_'+user_id).modal();	
	    		  userValidation();
	    		 
	    		});
	    	// open modal using js now 
	    	// action goes here!!
	    });
}

function initiateGraphFilter()
{
	
	$(".graph_filter_selector" ).each(function() {
		 
		
		
		var report_id = $(this).data("report_id");
		var data_table_id='chart_datatable_'+report_id;
		$(this).unbind().on('change',function() {
			
			var params ={}; 
			$.each($(this).context.dataset, function( index, value ) {
				 // alert( index + ": " + value );
				  params[index]=value;
				});
			
			var filter_name = $(this).attr("name");
			var filter_value = $(this).val();
			params[filter_name]=filter_value;
			
			
			
			  $.ajax({
		             type: "POST",
		             url: '../chart_filter',
		             data: jQuery.param( params ),
		             success: function(data){		            	
		            	 $('#'+data_table_id).replaceWith(data);
		            	 createGraphs();
		             }
		         });
		  });		
	});
	
	
	
	


}

function createGraphs()
 	{
 		try{
 			$('.datatable_report').each(function(i, obj) {
 				var tableID  = $(this).attr('id');
 			    var containerID = '#'+$(this).data('graph_containter');
 			    var graph_type = $(this).data('graph_type');
 			    var graph_title =$(this).data('report_title'); 
 			    var y_axis_title =$(this).data('y_axis_title');
 			    if(graph_type.indexOf('table')<=-1)
 			    	{
 						console.log("App.js::handleGraphs() -> graph found --> " + tableID);
 						
 						if(graph_type==='column') {
 							create_column_graph(tableID);
 						} else if(graph_type==='bar'){
 							create_bar_chart(tableID);
 						} else if(graph_type==='pie') {
 							create_pie_chart(tableID);
 						} else if(graph_type==='area') {
 							create_area_chart(tableID);
 						}else if(graph_type==='line') {
 							create_line_chart(tableID);
 						} else {
 							
 						}
 						
 						
 						
 			    	}
 			    
 			   
 			});
 			
 			//Hide Table
 			//$('.dataTables_wrapper').hide();

 		} catch (err) {
 		console.log(err);
 		}


 		
 	}

function create_bar_chart(tableID)
{
    var containerID = '#'+$('#'+tableID).data('graph_containter');
    var graph_type = $('#'+tableID).data('graph_type');
    var graph_title =$('#'+tableID).data('report_title'); 
    var y_axis_title =$('#'+tableID).data('y_axis_title');

$(containerID).highcharts({
        data: {
            table: tableID
        },
        chart: {
        	 zoomType: 'x',
            type: graph_type, 
            options3d: {
                enabled: true,
                alpha: 45
            }
        },
        credits: {
            enabled: false
          },
       title : {
			text : graph_title
		},
		yAxis : {
			allowDecimals : false,
			title : {
				text : y_axis_title
			}
		},
        tooltip: {
            crosshairs: [true,true],
            //pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
            formatter: function() {
                return this.series.name+': <b>'+this.y+'</b>';
            }
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        }
    });
}

function create_pie_chart(tableID)
{
    var containerID = '#'+$('#'+tableID).data('graph_containter');
    var graph_type = $('#'+tableID).data('graph_type');
    var graph_title =$('#'+tableID).data('report_title'); 
    var y_axis_title =$('#'+tableID).data('y_axis_title');

$(containerID).highcharts({
        data: {
            table: tableID
        },
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        credits: {
            enabled: false
          },
       title : {
			text : graph_title
		},
		yAxis : {
			allowDecimals : false,
			title : {
				text : y_axis_title
			}
		},
        tooltip: {
            crosshairs: [true,true],
            //pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
            formatter: function() {
                return this.series.name+': <b>'+this.y+'</b>';
            }
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: false
                },
                showInLegend: true
            }
        },
    });
	
}

function create_area_chart(tableID)
{
    var containerID = '#'+$('#'+tableID).data('graph_containter');
    var graph_type = $('#'+tableID).data('graph_type');
    var graph_title =$('#'+tableID).data('report_title'); 
    var y_axis_title =$('#'+tableID).data('y_axis_title');

$(containerID).highcharts({
        data: {
            table: tableID
        },
        chart: {
        	 zoomType: 'x',
            type: graph_type, 
            options3d: {
                enabled: true,
                alpha: 45
            }
        },
        credits: {
            enabled: false
          },
       title : {
			text : graph_title
		},
		yAxis : {
			allowDecimals : false,
			title : {
				text : y_axis_title
			}
		},
        tooltip: {
            crosshairs: [true,true],
            //pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
            formatter: function() {
                return this.series.name+': <b>'+this.y+'</b>';
            }
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        }
    });
}

function create_line_chart(tableID)
{
    var containerID = '#'+$('#'+tableID).data('graph_containter');
    var graph_type = $('#'+tableID).data('graph_type');
    var graph_title =$('#'+tableID).data('report_title'); 
    var y_axis_title =$('#'+tableID).data('y_axis_title');

$(containerID).highcharts({
        data: {
            table: tableID
        },
        chart: {
        	 zoomType: 'x',
            type: graph_type, 
            options3d: {
                enabled: true,
                alpha: 45
            }
        },
        credits: {
            enabled: false
          },
       title : {
			text : graph_title
		},
		yAxis : {
			allowDecimals : false,
			title : {
				text : y_axis_title
			}
		},
        tooltip: {
            crosshairs: [true,true],
            //pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
            formatter: function() {
                return this.series.name+': <b>'+this.y+'</b>';
            }
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        }
    });
}

function create_column_graph(tableID) {
	
	//	var tableID  = $(this).attr('id');
	    var containerID = '#'+$('#'+tableID).data('graph_containter');
	    var graph_type = $('#'+tableID).data('graph_type');
	    var graph_title =$('#'+tableID).data('report_title'); 
	    var y_axis_title =$('#'+tableID).data('y_axis_title');
	
	$(containerID).highcharts({
	        data: {
	            table: tableID
	        },
	        chart: {
	        	 zoomType: 'x',
	            type: graph_type, 
	            options3d: {
	                enabled: true,
	                alpha: 45
	            }
	        },
	        credits: {
	            enabled: false
	          },
	       title : {
				text : graph_title
			},
			yAxis : {
				allowDecimals : false,
				title : {
					text : y_axis_title
				}
			},
	        tooltip: {
	            crosshairs: [true,true],
	            //pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
	            formatter: function() {
	                return this.series.name+': <b>'+this.y+'</b>';
	            }
	        },
	        plotOptions: {
	            pie: {
	                allowPointSelect: true,
	                cursor: 'pointer',
	                dataLabels: {
	                    enabled: true,
	                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
	                    style: {
	                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
	                    }
	                }
	            }
	        }
	    });
}

function initChatEntitySearch()
{
	$('.search_chat_entity').unbind().on('keyup',function(){
		console.log($(this).val());
		var search_term = $(this).val();
		var report_id = $(this).data('report_id');
		var user_id = $(this).data('user_id');
		var default_report_id = $(this).data('default_report_id');
		var id = $(this).attr('id');
		if(search_term!=null && search_term!='')
		{
			var your_jsp_page_to_request = "/chat/search_entity.jsp";			 			 
			$.post(your_jsp_page_to_request,{search_term:search_term,user_id:user_id, report_id:report_id},		     
			     function(data){
					$('#'+id).parent('.panel-body').find('.users-list').empty();
					$('#'+id).parent('.panel-body').find('.users-list').prepend(data);
					initChatEntityClick();
			     }
			 );	
		}
		else
		{
			var your_jsp_page_to_request = "chat/search_entity.jsp";			 			 
			$.post(your_jsp_page_to_request,{report_id	:default_report_id,user_id:user_id},		     
			     function(data){
					$('#'+id).parent('.panel-body').find('.users-list').empty();
					$('#'+id).parent('.panel-body').find('.users-list').prepend(data);
					initChatEntityClick();
			     }
			 );	
		}	
	});
}

function initChatEntityClick()
{
	$('.chat-user').unbind().on('click', function() {	
		
		var user_type = $(this).data("user_type");
		var user_id = $(this).data("user_id");
		var user_name = $(this).data("user_name");	   
		var user_image= $(this).data("user_image");
		
		if(user_type==='ORG')
		{
			$('#org_tab').css("background", "#fff");
			$('#entity_user_'+user_id).css("background", "#fff");
			var receiverId = $('#current_user_id').val();
			var jsonMessage = JSON.stringify({
			      receiverId : receiverId+"",      
			      type : "MARK_CHAT_AS_SENT",
			      senderId : user_id+"",      
			      });					
			if (jsonMessage !== ""){
				webSocket.send(jsonMessage);	      				
			}
			
			$('#entity_user_'+user_id+'_chat_count').hide();
		}
		else if(user_type==='BG_GROUP')
		{
			$('#group_tab').css("background", "#fff");
			$('#entity_bg_group_'+user_id).css("background", "#fff");
			var receiverId = $('#current_user_id').val();
			var jsonMessage = JSON.stringify({
			      receiverId : receiverId+"",      
			      type : "MARK_GROUP_CHAT_AS_READ",
			      groupId : user_id+"",      
			      });					
			if (jsonMessage !== ""){
				webSocket.send(jsonMessage);	      				
			}
			
			$('#entity_bg_group_'+user_id+'_chat_count').hide();
		}
		else if(user_type==='USER')
		{
			$('#user_tab').css("background", "#fff");
			$('#entity_user_'+user_id).css("background", "#fff");
			var receiverId = $('#current_user_id').val();
			var jsonMessage = JSON.stringify({
			      receiverId : receiverId+"",      
			      type : "MARK_CHAT_AS_SENT",
			      senderId : user_id+"",      
			      });					
			if (jsonMessage !== ""){
				webSocket.send(jsonMessage);	      				
			}
			
			$('#entity_user_'+user_id+'_chat_count').hide();
		}
		
		
		var your_jsp_page_to_request = "/chat_box.jsp";			 			 
		$.post(your_jsp_page_to_request,{user_type:user_type,user_id:user_id, user_name:user_name},		     
		     function(data){				
			 $('#chat_holder').empty().append(data);	
			 $('#chat_holder').data('receiver_id',user_id);
			 $('#chat_holder').data('receiver_name',user_name);
			 $('#chat_holder').data('receiver_image',user_image);
			 $('#chat_holder').data('receiver_type',user_type);
			 $('#chat_holder').show();
			 $('#chatter_heading').unbind().on('click', function() {
					$('#chat_holder').empty();
					$('#chat_holder').hide();
				});
			 
		     }
		 );
		
		
		});	
}
function initChat()
{			
	$('#small-chat').on('click', function() {
		$('#chat_element_holder').show();
		if($('#chat_holder').length >0)
		{
			//$('#chat_holder').removeClass("active")
			$('#chat_holder').empty();
			$('#chat_holder').hide();
		}
	});
	
	
	$('#chat_element_heading').unbind().on('click', function() {
		$('#chat_element_holder').toggle();
		if($('#chat_holder').length >0)
		{
			//$('#chat_holder').removeClass("active")
			$('#chat_holder').empty();
			$('#chat_holder').hide();
		}
	});
	
//load first tabe by default
	
	var $firstTab = $('[data-toggle="tab_chat"]').first();
	var urll = $firstTab.attr('href');
	var targett = $firstTab.attr('data-target');
	 $.get(urll, function(data) {
	        $(targett).html(data);
	        initChatEntityClick();
	        initChatEntitySearch();
	    });
	 $firstTab.tab('show');
		
$('[data-toggle="tab_chat"]').click(function(e) {
	$(this).css("background", "#fff");
	    var $this = $(this),
	        loadurl = $this.attr('href'),
	        targ = $this.attr('data-target');
	    $.get(loadurl, function(data) {
	        $(targ).html(data);
	        initChatEntityClick();
	        initChatEntitySearch();
	    });
	    $this.tab('show');
	    return false;
	});

	function connect() {
		try {
			//variables defined in foot.jsp
			var userEmail = $('#current_user_email').val();
			//console.log('>>>>>>>' + userEmail);
			if (userEmail != undefined && userEmail != null) {
				var host_name = location.hostname;
				console.log("ws://" + host_name + ":" + "4568" + "/chat/" + userEmail);
				webSocket = new ReconnectingWebSocket("ws://" + host_name + ":" + "4568" + "/chat/" + userEmail);
			}

		} catch (err) {
			console.log(err);
		}
		return webSocket;
	}
	
	if (webSocket == null) {
		connect();
	}
	
	try{
	webSocket.onmessage = function(msg) {
			console.log('in on message ' + msg);
			updateChat(msg);

		};

	webSocket.onclose = function() {
			console.log("WebSocket connection closed");

		};	
		
	}catch(err)
	{
		console.log(err);
	}
	
	function getElement(id) {
		return document.getElementById(id);
	} 
	
	function updateChat(msg) {
		try {
			var str = JSON.stringify(msg, null, 2);
			console.log('got message in js'+str);
			//console.log('got message in js'+str);
			var data = JSON.parse(msg.data);
			var type = data.type;
			
			if(type === 'USER_CHAT')
			{
				var senderId = data.senderId;
				var senderName = data.currUserName;
				//chat window is not open then need to highlight incoming messages 
				if(($('#chat_holder').data('receiver_id')!= senderId) && ($('#chat_holder').data('receiver_type')!= 'USER'))
				{
					//highlight the tab
					$('#user_tab').css("background", "antiquewhite");
					//create a chat user tab and append to list on top
					if($('#entity_user_'+senderId).length!=0)
					{
						//unread user tab already exist
						
						
						var alreadyUnreadMessageCount = 0;
						if($('#entity_user_'+senderId+'_chat_count').text()!=null)
						{
							alreadyUnreadMessageCount= $('#entity_user_'+senderId+'_chat_count').text();
							alreadyUnreadMessageCount= parseInt(alreadyUnreadMessageCount,10);
						}
						alreadyUnreadMessageCount = alreadyUnreadMessageCount+1;
						$('#entity_user_'+senderId+'_chat_count').text(alreadyUnreadMessageCount);
						var html = $('#entity_user_'+senderId);
						$('#entity_user_'+senderId).remove();
						$('#tab-users .users-list').prepend(html);
					}	
					else{
						
						//add tab
						var alreadyUnreadMessageCount = 1;
						var htmlDiv ="<div class='chat-user' id='entity_user_"+senderId+"' data-user_id='"+senderId+"' data-user_type='USER' " +
						"data-user_name='"+senderName+"' data-user_image='"+data.currUserImage+"'>" +
								"<img class='chat-avatar' src='http://cdn.talentify.in"+data.currUserImage+"' " +
										"alt='' style='width:36px ; height:36px'><div class='chat-user-name'><a href='#'>"+senderName+"</a>" +
												"<span class='label label-primary' style='float:right' id='entity_user_"+senderId+"_chat_count'>"+alreadyUnreadMessageCount+"</span></div></div>";
						$('#tab-users .users-list').prepend(htmlDiv);
						
					}
					initChatEntityClick();
					$('#entity_user_'+senderId).css("background", "antiquewhite");
					var audio = new Audio('/assets/sound/stuffed-and-dropped.mp3');
					audio.play();
				}
				else 
				{
					var message = data.message;
					var senderName = data.currUserName;	
					var receiverId =  $('#current_user_id').val();
					var chatMessage = createMessageHtml(message,senderId,senderName,'user');
					var commentsCount = $('#'+senderUserID).children('.comment').length;
					if(commentsCount >6)
					{							
						$('#'+senderUserID+' > .comment').slice(0,1).remove();
					}										
					$('#'+senderUserID).append(chatMessage);
					
					var jsonMessage = JSON.stringify({
					      receiverId : receiverId+"",      
					      type : "MARK_CHAT_AS_SENT",
					      senderId : senderId+"",      
					      });					
					if (jsonMessage !== ""){
	      				webSocket.send(jsonMessage);	      				
	      			}
					$('#entity_user_'+senderId+'_chat_count').hide();
				}					
			}else if(type === 'ORG_CHAT')
			{
				var senderId = data.senderId;				
				//chat window is not open then need to highlight incoming messages 
				if(($('#chat_holder').data('receiver_id')!= senderId) && ($('#chat_holder').data('receiver_type')!= 'ORG'))
				{
					//highlight the tab
					$('#org_tab').css("background", "antiquewhite");
					if($('#entity_user_'+senderId).length!=0)
					{
						//unread user tab already exist 
						var alreadyUnreadMessageCount = 0;
						if($('#entity_user_'+senderId+'_chat_count').text()!=null)
						{
							alreadyUnreadMessageCount= $('#entity_user_'+senderId+'_chat_count').text();
							alreadyUnreadMessageCount= parseInt(alreadyUnreadMessageCount,10);
						}
						alreadyUnreadMessageCount = alreadyUnreadMessageCount+1;
						$('#entity_user_'+senderId+'_chat_count').text(alreadyUnreadMessageCount);
						var html = $('#entity_user_'+senderId);
						$('#entity_user_'+senderId).remove();
						$('#tab-orgs .users-list').prepend(html);
					}	
					else{						
						//add tab
						var alreadyUnreadMessageCount = 1;
						
						var htmlDiv ="<div class='chat-user' id='entity_user_"+senderId+"' data-user_id='"+senderId+"' data-user_type='ORG' " +
						"data-user_name='"+senderName+"' data-user_image='"+data.currUserImage+"'>" +
								"<img class='chat-avatar' src='http://cdn.talentify.in"+data.currUserImage+"' " +
										"alt='' style='width:36px ; height:36px'><div class='chat-user-name'><a href='#'>"+senderName+"</a>" +
												"<span class='label label-primary' style='float:right' id='entity_user_"+senderId+"_chat_count'>"+alreadyUnreadMessageCount+"</span></div></div>";
						console.log(htmlDiv);
						$('#tab-orgs .users-list').prepend(htmlDiv);
						
					}
					initChatEntityClick();
					//highlight the user
					$('#entity_user_'+senderId).css("background", "antiquewhite");
					var audio = new Audio('/assets/sound/stuffed-and-dropped.mp3');
					audio.play();
				}
				else 
				{
					var message = data.message;
					var senderName = data.currUserName;		
					var chatMessage = createMessageHtml(message,senderId,senderName,'user');
					var commentsCount = $('#chat_content').children('.chat_comment').length;
					if(commentsCount >6)
					{							
						$('#chat_content > .comment').slice(0,1).remove();
					}										
					$('#chat_content').append(chatMessage);
					var d = $('#chat_content');
	  				d.scrollTop(d.prop("scrollHeight"));
	  				
	  				var receiverId =  $('#current_user_id').val();
	  				var jsonMessage = JSON.stringify({
					      receiverId : receiverId+"",      
					      type : "MARK_CHAT_AS_SENT",
					      senderId : senderId+"",      
					      });					
					if (jsonMessage !== ""){
	      				webSocket.send(jsonMessage);	      				
	      			}
					$('#entity_user_'+senderId+'_chat_count').hide();
				}
			}
			else if (type === 'BG_CHAT')
			{				
				var senderId = data.senderId;
				var groupId = data.groupId;
				//alert(senderId);
				//alert(groupId);
				//chat window is not open then need to highlight incoming messages 
				if(($('#chat_holder').data('receiver_id')!= groupId) && ($('#chat_holder').data('receiver_type')!= 'BG_GROUP'))
				{
					//highlight the tab
					$('#group_tab').css("background", "antiquewhite");
					//highlight the entity_bg_group_15
					if($('#entity_bg_group_'+groupId).length!=0)
					{
						//unread user tab already exist 
						var alreadyUnreadMessageCount = 0;
						if($('#entity_bg_group_'+groupId+'_chat_count').text()!=null)
						{
							alreadyUnreadMessageCount= $('#entity_bg_group_'+groupId+'_chat_count').text();
							alreadyUnreadMessageCount = parseInt(alreadyUnreadMessageCount,10);
						}
						alreadyUnreadMessageCount = alreadyUnreadMessageCount+1;
						$('#entity_bg_group_'+groupId+'_chat_count').text(alreadyUnreadMessageCount);
						var html = $('#entity_bg_group_'+groupId);
						$('#entity_bg_group_'+groupId).remove();
						$('#tab-groups .users-list').prepend(html);
						$('#entity_bg_group_'+groupId).css("background", "antiquewhite");
					}	
					else
					{						
						//add tab
						var alreadyUnreadMessageCount = 1;
						var htmlDiv ="<div class='chat-user' id='entity_bg_group_"+groupId+"' data-user_id='"+groupId+"' data-user_type='BG_GROUP' " +
						"data-user_name='"+senderName+"' data-user_image='"+data.currUserImage+"'>" +
								"<img class='chat-avatar' src='http://cdn.talentify.in"+data.currUserImage+"' " +
										"alt='' style='width:36px ; height:36px'><div class='chat-user-name'><a href='#'>"+senderName+"</a>" +
												"<span class='label label-primary' style='float:right' id='entity_bg_group_"+senderId+"_chat_count'>"+alreadyUnreadMessageCount+"</span></div></div>";
						$('#tab-groups .users-list').prepend(htmlDiv);						
						$('#entity_bg_group_'+groupId).css("background", "antiquewhite");
					}			
					initChatEntityClick();										
					var audio = new Audio('/assets/sound/stuffed-and-dropped.mp3');
					audio.play();
				}				
				var message = data.message;
				var senderName = data.currUserName;						
				var chatMessage = createMessageHtml(message, senderId,senderName, 'user');				
				var commentsCount = $('#chat_content').children('.comment').length;
				//console.log('commentsCount>>>'+commentsCount);
				if(commentsCount >6)
					{					
					$('#chat_content > .chat_comment').slice(0,1).remove();
					}
				
				$('#chat_content').append(chatMessage);  				
  				var d = $('#chat_content');
  				d.scrollTop(d.prop("scrollHeight"));				
			}
			else if(type === 'GROUP_CHAT')
			{
				var senderId = data.senderId;
				var groupId = data.groupId;
				//chat window is not open then need to highlight incoming messages 
				if($('#chat_holder #convo_wrap_group_'+groupId).length ==0)
				{				
					$('a[data-user_id="chat_entity_group_'+groupId+'"]').css("background", "antiquewhite");;
					var audio = new Audio('/assets/sound/stuffed-and-dropped.mp3');
					audio.play();
				}
				
				var message = data.message;
				var targetId = 'convo_wrap_group_' + groupId;
				var senderName = data.currUserName;		
				var chatMessage = createMessageHtml(message, senderId,senderName, 'user');
				
				var commentsCount = $('#'+targetId).children('.comment').length;
				//console.log('commentsCount>>>'+commentsCount);
				if(commentsCount >6)
					{					
					$('#chat_content > .chat_comment').slice(0,1).remove();
					}
				
				$('#chat_content').append(chatMessage);
  				
  				var d = $('#chat_content');
  				d.scrollTop(d.prop("scrollHeight"));				
			}
			else if(type === 'NOTIFICATION')
			{
				var notificationType = data.notification_type;
				var notificationMessage = data.message;
				
				var notificationHtml = getNotificationHTML(notificationType,notificationMessage);			
				getElement('chat_notification_id').insertAdjacentHTML("afterBegin", notificationHtml);
				initiateNotificationHandlers();				 
	 		}
			else if (type ==='JOINING_MESSAGE')
			{
				console.log('got joining message');
				// set online user count
				var onlineUserCount = data.onlineUserCount;
				$('#side').text('Chat( '+onlineUserCount+' )');				
				var userList = JSON.parse(data.userList);
				for(var i =0; i<userList.length;i++)
				{
					var username = userList[i].username
					var userId =userList[i].userId;
					var onlineStatus = userList[i].online;
					//console.log('online status>>>>'+onlineStatus);
					if(onlineStatus==='true')
					{
						var divId = 'status_user_'+userId;
						console.log('making div id '+divId+ ' online'); 
						$('#'+divId).css('background-color', '#53DD6C');
						$('a[data-user_id="chat_entity_user_'+userId+'"]').attr( "class", "item chat_entity online" );
						$('a[data-user_id="chat_entity_user_'+userId+'"]').show();
						showOnlineUsers();
					}
					else
					{
						//$('#chat_entity_user_'+userId).attr( "class", "item chat_entity offine" );
						$('a[data-user_id="chat_entity_user_'+userId+'"]').hide();
					}	
				}
				
			}
		} catch (err) {
			console.log(err);
		}

	}
	
	
	
	
	    	
	    
	    	
	    	function createMessageHtml(message, senderId,senderName, user_type)
	      	{
	      		var profileImage='';
	      		var userName ='';
	      		//these varible defined in foot.jsp
	      		var currentUserImage = $('#current_user_image').val();;
	    		var currentUserName =$('#current_user_name').val();
	    		var currUserId  = $('#current_user_id').val();
	    		
	    		console.log('currentUserImage----'+currentUserImage);
	    		console.log('currUserId----'+currUserId);
	    		console.log('currentUserName----'+currentUserName);
	    		console.log('senderId----'+senderId);
	    		var messageHTML ='';
	    		if(senderId===currUserId)
	    		{
	    			profileImage= currentUserImage;
	    			userName= currentUserName; 
	    			 messageHTML="<div class='left'> <div class='author-name'>"+userName+"<small class='chat-date'> moments ago</small>   " +
	       	 		"              </div>                 <div class='chat-message active'>                    "+message+"                </div>    </div>"	;
	    		}
	    		else
	    		{
	    			 
	    			 var senderUserID = 'entity_'+user_type+'_' + senderId;
	    	  		 userName = senderName;	    	  		 
	    			 //profileImage = $('#'+senderUserID).data('user_image');	    			 
	    			 messageHTML="<div class='right'> <div class='author-name'>"+userName+"<small class='chat-date'> moments ago</small>   " +
	       	 		"              </div>                 <div class='chat-message'>                    "+message+"                </div>    </div>"	;
	      		
	    		}
	    		//console.log('username'+userName);
	    		//console.log('profileImage'+profileImage);
	      	
	      		
	      								
	      								return messageHTML;	      									      						
	      								
	      	}
	    	
	    	
	    	
	    	
	    	$(document).on('keypress','.chat_message', function (e) {

	      		if (e.keyCode === 13) {
	      			//sendMessage(e.target.value); 
	      			var buttonId = $(this).attr('id');
	      			//console.log('button id is '+buttonId);
	      			var message = $(this).val();
	      			if(message !=''){
	      			//these varible defined in chat_element.jsp
	      			var currUserId  = $('#current_user_id').val();
	      			var currUserOrgId = $('#current_user_org_id').val();
	      			var currUserType = $('#current_user_type').val();
	      			var currUserName = $('#current_user_name').val();
	      			var currUserImage = $('#current_user_image').val();
	      			var jsonMessage = '';
	      			if (buttonId.indexOf('user') != -1) {
	      				//it is user to user chat
	      				var receiverId = buttonId.replace("user_", "");
	      				//console.log("sending message " + message + " to user>" + receiverId);
	      				if (message !== "") {
	      					jsonMessage = JSON.stringify({
	      						receiverId : receiverId,
	      						message : message,
	      						type : "USER_CHAT",
	      						senderId : currUserId,
	      						sessionId: null,
	      						currUserName :currUserName, currUserImage: currUserImage
	      					});
	      				}
	      				var chatMessage = createMessageHtml(message, currUserId, 'user');  				
	      				//var receivUserID = 'convo_wrap_' + buttonId;
	      				
	      				
	      				var commentsCount = $('#chat_content').children('.chat_comment').length;
	    			//	console.log('commentsCount>>>'+commentsCount);
	    				if(commentsCount >8)
	    					{	    						
	    						$('#chat_content > .chat_comment').slice(0,1).remove();
	    					}
	    				
	    				
	    				$('#chat_content').append(chatMessage);
	      				
	      				var d = $('#chat_content');
	      				d.scrollTop(d.prop("scrollHeight"));
	      			}
	      			else if (buttonId.indexOf('org') != -1)
	      			{
	      				var receiverId = buttonId.replace("org_", "");
	      				//console.log("sending message " + message + " to user>" + receiverId);
	      				if (message !== "") {
	      					jsonMessage = JSON.stringify({
	      						receiverId : receiverId,
	      						message : message,
	      						type : "ORG_CHAT",
	      						senderId : currUserId,
	      						sessionId: null, currUserName: currUserName,currUserImage:currUserImage
	      					});
	      				}
	      				var chatMessage = createMessageHtml(message, currUserId, 'org');  				
	      				//var receivUserID = 'convo_wrap_' + buttonId;
	      				
	      				
	      				var commentsCount = $('#chat_content').children('.chat_comment').length;
	    			//	console.log('commentsCount>>>'+commentsCount);
	    				if(commentsCount >8)
	    					{
	    						
	    						$('#chat_content > .chat_comment').slice(0,1).remove();
	    					}	    					    				
	    				$('#chat_content').append(chatMessage);	      				
	      				var d = $('#chat_content');
	      				d.scrollTop(d.prop("scrollHeight"));
	      			}
	      			else  if (buttonId.indexOf('bg_group_') != -1) {
	      				//it is batch group chat
	      				var receiverGroupId = buttonId.replace("bg_group_", "");;
	      				if (message !== "") {
	      					jsonMessage = JSON.stringify({
	      						groupId : receiverGroupId,
	      						message : message,
	      						type : "BG_CHAT",
	      						sessionId:null,
	      						senderType: currUserType,
	      						senderId : currUserId, currUserName: currUserName, currUserImage:currUserImage
	      					});
	      				}
	      				/*var chatMessage = createMessageHtml(message, currUserId, 'bg_group');  				
	      				var commentsCount = $('#chat_content').children('.chat_comment').length;
	    				if(commentsCount >8)
	    					{	    						
	    						$('#chat_content > .chat_comment').slice(0,1).remove();
	    					}	    				
	    				$('#chat_content').append(chatMessage);
	      				
	      				var d = $('#chat_content');
	      				d.scrollTop(d.prop("scrollHeight"));*/
	      				
	      			}
	      			else if(buttonId.indexOf('custom_group') != -1)
	      			{
	      				//its custom group chat
	      				var receiverGroupId = buttonId.replace("custom_group_", "");;
	      				if (message !== "") {
	      					jsonMessage = JSON.stringify({
	      						groupId : receiverGroupId,
	      						message : message,
	      						type : "CUSTOM_CHAT",
	      						sessionId:null,
	      						senderId : currUserId, currUserName: currUserName,currUserImage:currUserImage
	      					});
	      				}
	      			}
	      			
	      			if (jsonMessage !== ""){
	      				webSocket.send(jsonMessage);
	      				getElement(buttonId).value = "";
	      				$('#'+buttonId).focus();
	      			}
	      			
	      			}
	      		}
	      	});   	
	

}
function init_session_logs(){
	//console.log("called"+new Date());
	$('.ajax-session-holder').each(function(e){
		
		if($('#childtab1'+$(this).data('event-id')).hasClass('active') && $($(this).parent()).hasClass('active'))
		{
			var url=$(this).data('url');
			var eventId=$(this).data('event-id');
			var holder=$('#ajax-session-holder_'+eventId);
			$.ajax({
	            type: "POST",
	            url: url,
	            data: {eventId:eventId},
	            success: function(data){
	            	holder.html(data);
	            }
	        });
		}
	});
}

function init_edit_delete_event(eventID,status){
	
	var eventid = eventID;
	var status = status;
	$('.key').unbind().on('click', function() {
		var key = $(this).attr('id');
	if(key === 'delete'){
			
        console.log('----------status------->'+$(this).data('status'));
		
		 
		
		$.post(
   				"../event_utility_controller", 
   				{deleteEventid : eventid,status:$(this).data('status')}, 
   				function(data) {location.reload();})
	}
	else if(key === 'edit'){
		
		var org_id = $('#org_id').val();
		var url;
		
		if(org_id != undefined && org_id != null){
			
			url= "../orgadmin/edit_old_event.jsp";
			
		}else{
			
			url= "../super_admin/edit_old_event.jsp";
		}
		
		
		$.post(url, 
				{eventid : eventid}, 
				function(data) {
					
					       $('.event-edit-modal').empty();
								$('.event-edit-modal').append(data);
								 $('#myModal2').modal('show');
								 $('.select2-dropdown').select2();
								 scheduler_onShowOfModal();
							});
	}
	
	});
	
}
function event_details_card() {
$('.fc-event').unbind().on('click', function() {
	var status = $(this).data('status');
	var eventid =$(this).attr('event_id');
	  console.log('----------event_id------->'+$(this).attr('event_id'));
		
	  var org_id = $('#org_id').val();
			var url;
			
			if(org_id != undefined && org_id != null){
				
				url= "../orgadmin/event_details.jsp";
				
			}else{
				
				url= "../orgadmin/event_details.jsp";
			}
			
			
			$.post(url, 
					{eventid : eventid,status :status}, 
					function(data) {
						
						       $('.event_details').empty();
									$('.event_details').append(data);
									 $('#event_details').modal('show');
									 init_edit_delete_event(eventid,status);
								});
			
	
});

}


function loadTables(){
	/*var url=$('.datatable').attr('url');
	
	$('table.datatable_istar').each(function(){
	  var id=$(this).attr('id');
	  var url=$(this).data('url');
	  
	  $('#'+id).on( 'draw.dt', function () {   
		 
		  $('#classroom_list_info').css('display','none');
		  $('#feedback_list_info').css('display','none');
		  $('#trainer_details_list_info').css('display','none');
		  $('#account_details_list_info').css('display','none');
		  
		  
		  $(".class-room-edit-popup").click(function(){
		    	var classRoomId =  $(this).data('class_id');
		    	var urls = 'partials/modal/create_edit_classroom_modal.jsp?type=Edit&class_id='+classRoomId;
		    	$.get( urls, function( data ) {
		    		  $('#edit_class_room_model').remove(); 
		    		  $("body").append(data);
		    		  init_classRoom_Modal();
		    		  $('#edit_class_room_model').modal();
		    		});
		    });
		} );
	  
	  
	  $('#'+id).DataTable({
	         pageLength: 10,
	         responsive: true,
	         dom: '<"html5buttons"B>lTfgitp',
	         buttons: [
	             { extend: 'copy'},
	             {extend: 'csv'},
	             {extend: 'excel', title: 'ExampleFile'},
	             {extend: 'pdf', title: 'ExampleFile'},

	             {extend: 'print',
	              customize: function (win){
	                     $(win.document.body).addClass('white-bg');
	                     $(win.document.body).css('font-size', '10px');

	                     $(win.document.body).find('table')
	                             .addClass('compact')
	                             .css('font-size', 'inherit');
	             }
	             }
	         ], "processing": true,
	         "serverSide": true,
	         "ajax": url

	     });
	  
	});*/

	
}

$( document ).ready( readyFn );

function init_orgadmin_none() {
	
}

function mark_as_read_notification(){
	 $(".notification_read").click(function(){
	//$('.notification_read').unbind().on("click", function() {
       var notificationEventID = $(this).attr('id');
       var parentID = $('#'+notificationEventID).parent().parent().attr('id');;
       var notice_count = $('#admin_notice_count').text();
		var url = '../event_utility_controller'
		    $.post(url, {
		    	notificationEventID : notificationEventID,
		    	type : "markasread"
		        },
		        function(data) {
		        	//location.reload();	
		        	
		        	$("#"+parentID ).remove();
		        	if(notice_count != 0){
		        		notice_count = notice_count -1;
		        		$("#admin_notice_count").html(notice_count);
		        	}

	
		        });
	});
	
}

function init_orgadmin_dashboard() {
    console.log('intiliazing Dashboard');
    
   
    $('#myModal2').on('shown.bs.modal', function() {
		var otherEventData = []
		//$('#myModal5').modal('toggle');
		 scheduler_createOldEvent();
		 scheduler_DeleteEvent();
		 scheduler_init_edit_new_trainer_associated();
		 scheduler_init_edit_old_trainer_associated();
		 scheduler_ClockDate(false);
		 $('select').select2();
		

	});
  //  create_progress_view_chart(true);
    //create_competetion_view_calendar(true);
    create_dashboard_calendar();
   // create_course_view_datatable(true);
   // create_program_view_datatable(true);

    scheduler_createOldEvent();

    mark_as_read_notification();
  
    
}

function init_orgadmin_admin() {
    console.log('intiliazing Admin');
    //Edit User Call goes here
    initEditUserModalCall();
	$.get('partials/admin_user_tab_content.jsp', function(data) {        	
    $('#admintab1').html(data);
    $('select').select2();
	createDataTables();
	user_filter_by_course_batch();
		
	$('#data_2 .input-group.date').datepicker({
		startView : 1,
		todayBtn : "linked",
		keyboardNavigation : false,
		forceParse : false,
		autoclose : true,
		format : "dd/mm/yyyy"
	});
	$('#admin_user_tab').tab('show');
	  
	
	});
    
    
    $('[data-toggle="tabajax"]').unbind().on('click',function(e) {
    	$('#admin_page_loader').show();
        	var $this = $(this),
            loadurl = $this.attr('href'),
            targ = $this.attr('data-target');
        	$.get(loadurl, function(data) {        	
            $(targ).html(data);
            $('#admin_page_loader').hide();
            $('select').select2();
        	createDataTables();
        	user_filter_by_course_batch();
        	initCreateSectionCall();
        	//admin_load_resources();
            load_content_mapping();
            $.extend($.expr[":"], {
                "containsIN": function(elem, i,match, array) {
                    return (elem.textContent ||
                            elem.innerText || "")
                        .toLowerCase()
                        .indexOf(
                            (match[3] || "")
                            .toLowerCase()) >= 0;
                }
            });
            
            $('#data_2 .input-group.date').datepicker({
        		startView : 1,
        		todayBtn : "linked",
        		keyboardNavigation : false,
        		forceParse : false,
        		autoclose : true,
        		format : "dd/mm/yyyy"
        	});
        });

        	
        	
        $this.tab('show');
        return false;
    });
    
    $('.click_loader').click(function(){
    	$('#spinner_holder').show();
    	
    });
    
}

function load_content_mapping()
{	
	  $('[data-toggle="tabajax_content_mapping"]').unbind().on('click',function(e) {
	    	$('#admin_page_loader').show();
	        	var $this = $(this),
	             loadurl = $this.attr('href'),
	             targ = $this.attr('data-target'),
	             entity_type = $this.data('type'),
	             college_id = $this.data('org');
	        	 loadurl += '?type='+entity_type+'&colegeID='+college_id;	
	        	$.get(loadurl, function(data) {        	
	            $(targ).html(data);
	            $('#admin_page_loader').hide();	            	        	
	        	//admin_load_resources();
	        	 $('.full-height-scroll').each(function(){
				    	$(this).slimscroll({height:$(this).parent().height()});
				    });	        	 
	            init_user_pagination_in_user_tab();
	            init_section_pagination_in_section_tab();
	            init_role_pagination_in_role_tab();
	            init_user_search_in_user_tab();
	            init_child_entity_tabs();
	            
	            
	            $.extend($.expr[":"], {
	                "containsIN": function(elem, i,match, array) {
	                    return (elem.textContent ||
	                            elem.innerText || "")
	                        .toLowerCase()
	                        .indexOf(
	                            (match[3] || "")
	                            .toLowerCase()) >= 0;
	                }
	            });
	        });

	        $this.tab('show');
	        return false;
	    });
}
function init_child_entity_tabs()
{
	
	$('[data-toggle="tabajax_admin_child"]').unbind().on('click',function(e) {
    	$('#admin_page_loader').show();
        	var $this = $(this),
             loadurl = $this.attr('href'),
             targ = $this.attr('data-target'),
             entity_type = $this.data('entity_type'),
             college_id = $this.data('college_id'),
        	 entity_id = $this.data('entity_id');
        	 loadurl += '?entity_id='+entity_id+'&entityType='+entity_type+'&college_id='+college_id;	
        	$.get(loadurl, function(data) {        	
            $(targ).html(data);
            $('#admin_page_loader').hide();	            	        	
        	$('.full-height-scroll').each(function(){
			    $(this).slimscroll({height:$(this).parent().height()});
			    });	        	 
            $.extend($.expr[":"], {
                "containsIN": function(elem, i,match, array) {
                    return (elem.textContent ||
                            elem.innerText || "")
                        .toLowerCase()
                        .indexOf(
                            (match[3] || "")
                            .toLowerCase()) >= 0;
                }
            });
            admin_skill_content_search_init();
            init_admin_skill_addition();
            init_admin_skill_removal();
        });

        $this.tab('show');
        return false;
    });
}

function init_admin_skill_addition()
{
	//add_content
	$('.add_content').unbind().on('click',function(){
		var skillId = $(this).data('skill_id');
		var entityId = $(this).data('entity_id');
		var entityType = $(this).data('entity_type');
		var adminId = $(this).data('admin_id');
		var college_id = $(this).data('college_id');
		var loadurl = $(this).data('href');
        var targ = $(this).parents('.tab-pane').attr('id');

          loadurl += '?entity_id='+entityId+'&entityType='+entityType+'&college_id='+college_id;	
		
		$('#admin_page_loader').show();
		var jsp="/add_content_to_entity";
		$.post(jsp, 
				{skill_id : skillId,entity_id:entityId,entity_type:entityType, admin_id:adminId }, 
				function(data) {					
					
					$.get(loadurl, function(data2) {
						
						$('#'+targ).empty();
			            $('#'+targ).html(data2);
			        	            	        	
			    	$('.full-height-scroll').each(function(){
					    $(this).slimscroll({height:$(this).parent().height()});
					    });	        	 
			        $.extend($.expr[":"], {
			            "containsIN": function(elem, i,match, array) {
			                return (elem.textContent ||
			                        elem.innerText || "")
			                    .toLowerCase()
			                    .indexOf(
			                        (match[3] || "")
			                        .toLowerCase()) >= 0;
			            }
			        });
			        admin_skill_content_search_init();
			        init_admin_skill_addition();
			        init_admin_skill_removal();
			    });

					
					$('#admin_page_loader').hide();	
					
		});

	});
}

function init_admin_skill_removal()
{
	$('.remove_content').unbind().on('click',function(){
		var contentId = $(this).data('content_id');
		var entityId = $(this).data('entity_id');
		var entityType = $(this).data('entity_type');
		$('admin_page_loader').show();
		var jsp="/remove_content_from_entity";
    	$.post(jsp, 
				{content_id : contentId,entity_id:entityId,entity_type:entityType }, 
				function(data) {					
					
					$('#admin_page_loader').hide();
					
		});
		
		
		
		
	});
}


function init_user_search_in_user_tab()
{
	$('.content-user-search').on('keypress', function(e) {		
		if(e.keyCode === 13)
			{
			$('#admin_page_loader').show();
			var searchkey=$(this).val().replace(' ','%20');
			var tab=$(this);
			var type=$(this).data('type');
			var id=$(this).data('org');
			var url=$(this).data('url')+'?colegeID='+id+'&type='+type;
			
			if(searchkey.length!=0){
			 url=url+'&searchkey='+searchkey+'&limit=all';
			 
			}else{
				url=url+'&offset=0';
				$('#admin_page_loader').hide();
			}			
			console.log(url);
			
			$.get(url, function( data ) {			  
				  $(tab).parent().parent().parent().find('.actual_content_body').remove();			  
				  $(tab).parent().parent().parent().append(data);					  
				    $('.full-height-scroll').each(function(){
				    	$(this).slimscroll({height:$(this).parent().height()});
				    });
				    init_child_entity_tabs();
				    $('#admin_page_loader').hide();
				    
				    
				}).done(function() {
				  });
			}		
		});

}
function init_user_pagination_in_user_tab()
{
	$('#user_page-selection').bootpag({
        total: parseInt($('#user_page-selection').data('size')/10+1),
        maxVisible: 10
    }).on("page", function(event, /* page number  here */ num){
    		$('#admin_page_loader').show();
			var offset=(num*10)-10;						
			var tab=$(this);			
			var type=$(this).data('type');
			var id=$(this).data('org');
			var url=$(this).data('url')+'?colegeID='+id+'&type='+type;
			url=url+'&offset='+offset;	
			$.get(url, function( data ) {				 				  
				  $(tab).parent().parent().find('.actual_content_body').remove();				 
				  $(tab).parent().parent().append(data);	
				  init_child_entity_tabs();
				    $('.full-height-scroll').each(function(){
				    	$(this).slimscroll({height:$(this).parent().height()});
				    });
				    $('#admin_page_loader').hide();
				});
    });
}
function init_role_pagination_in_role_tab()
{
	$('#role_page-selection').bootpag({
        total: parseInt($('#role_page-selection').data('size')/10+1),
        maxVisible: 10
    }).on("page", function(event, /* page number  here */ num){
    		$('#admin_page_loader').show();
			var offset=(num*10)-10;						
			var tab=$(this);			
			var type=$(this).data('type');
			var id=$(this).data('org');
			var url=$(this).data('url')+'?colegeID='+id+'&type='+type;
			url=url+'&offset='+offset;	
			$.get(url, function( data ) {				 				  
				  $(tab).parent().parent().find('.actual_content_body').remove();				 
				  $(tab).parent().parent().append(data);	
				  init_child_entity_tabs();
				    $('.full-height-scroll').each(function(){
				    	$(this).slimscroll({height:$(this).parent().height()});
				    });
				    $('#admin_page_loader').hide();
				});
    });
}
function init_section_pagination_in_section_tab()
{
	$('#section_page-selection').bootpag({
        total: parseInt($('#section_page-selection').data('size')/10+1),
        maxVisible: 10
    }).on("page", function(event, /* page number  here */ num){
    		$('#admin_page_loader').show();
			var offset=(num*10)-10;						
			var tab=$(this);			
			var type=$(this).data('type');
			var id=$(this).data('org');
			var url=$(this).data('url')+'?colegeID='+id+'&type='+type;
			url=url+'&offset='+offset;	
			$.get(url, function( data ) {				 				  
				  $(tab).parent().parent().find('.actual_content_body').remove();				 
				  $(tab).parent().parent().append(data);	
				  init_child_entity_tabs();
				    $('.full-height-scroll').each(function(){
				    	$(this).slimscroll({height:$(this).parent().height()});
				    });
				    $('#admin_page_loader').hide();
				});
    });
}

function user_filter_by_course_batch() {
	$('.dataTables_info').hide();
	var tableID = $('.datatable_istar').attr('id');
	
    $('#admin_page_course').on('change', function() {
        var key = $('#admin_page_course').val();
        var prevKey=$('#admin_page_batchgroup').val();
        var selectBox=$($('#admin_page_batchgroup >option'));
    	var searchArray=[];
    	
    	
    	
        var searchKey = "";
        
        if(prevKey!=null)
        	{
        	//searchKey = prevKey+",";
	        	if(prevKey!=null){
	        		$.each(prevKey, function(index, value) {
	        			selectBox.each(function(){
	        				if($(this).val()==value){
	        					searchArray.push($(this).text());
	        				}
	        			});
	        		});
	        	}
	        	searchKey =searchArray+",";
        	}
        if (key != null) {
            $.each(key, function(index, value) {
                if (index != 0) {
                    searchKey = searchKey + "," + value;
                } else {
                    searchKey = searchKey + value;
                }
            });
        }
        filter_user_table(searchKey,tableID);
    });
    
    
    $('#admin_page_batchgroup').on('change', function() {
    	var prevKey=$('#admin_page_course').val();
    	var key = $('#admin_page_batchgroup').val();
    	var selectBox=$($('#admin_page_batchgroup >option'));
    	var searchArray=[];
    	if(key!=null){
    		$.each(key, function(index, value) {
    			selectBox.each(function(){
    				if($(this).val()==value){
    					searchArray.push($(this).text());
    				}
    			});
    		});
    	}
        var searchKey = "";
        if(prevKey!=null)
    	{
        	searchKey = prevKey+",";
    	}
        key=searchArray;
        if (key != null) {
            $.each(key, function(index, value) {
                if (index != 0) {
                    searchKey = searchKey + "," + value;
                } else {
                    searchKey = searchKey + value;
                }
            });
        }
        filter_user_table(searchKey,tableID);
    });
    
    $('#admin_page_orgs').on('change', function() {
		var key = $('#admin_page_orgs').val();
		var selectBox = $($('#admin_page_orgs >option'));
		var searchArray = [];
		if (key != null) {
			$.each(key, function(index, value) {
				selectBox.each(function() {
					if ($(this).val() == value) {
						searchArray.push($(this).text());
					}
				});
			});
		}
		var searchKey = "";
		key = searchArray;
		if (key != null) {
			$.each(key, function(index, value) {
				if (index != 0) {
					searchKey = searchKey + "," + value;
				} else {
					searchKey = searchKey + value;
				}
			});
		}
		filter_user_table(searchKey,tableID);
	});
}

function filter_user_table(key,tableID) {
    if (key == null) {
        key = '';
    }
    var table_id =tableID;
    var table = $('#'+tableID).DataTable();
    table.search(key).draw();
}


function initCreateSectionCall()
{
	
	$("#create_group_model" ).on('shown', function(){
		$('#member_filter_by').select2();
	});

	
		var cid = $('#member_filter_by').data("college_id");
		var urls = '../get_filtered_students?entity_id='+cid+'&filter_by=ORG';
		if(cid!=null)
			{
	    $.get(urls, function(data) {
	    	$('#student_list_holder').empty();
	    	$('#student_list_holder').append(data);
	    	$('#student_list_holder').select2();
	    });
	    
			}
	
	
	
	$('#member_filter_by').unbind().on("change",function (){
    	var filterBy=$(this).val();
    	var collegeId = $(this).data("college_id");
    	if(filterBy==='ROLE')
    	{
    		var urls = '../get_filtered_groups?college_id='+collegeId+'&filter_by='+filterBy;
            $.get(urls, function(data) {
            	$('#role_section_options').empty();
            	$('#role_section_options').append(data);
            	$('#role_section_options').select2();
            });
    		$('#role_section_holder').show();
    	}
    	else if(filterBy==='SECTION')
    	{
    		var urls = '../get_filtered_groups?college_id='+collegeId+'&filter_by='+filterBy;
            $.get(urls, function(data) {
            	$('#role_section_options').empty();
            	$('#role_section_options').append(data);
            	$('#role_section_options').select2();
            });
    		$('#role_section_holder').show();
    	}
    	else
    	{    		
    		$('#role_section_holder').hide();
    		var urls = '../get_filtered_students?entity_id='+collegeId+'&filter_by=ORG';
            $.get(urls, function(data) {
            	$('#student_list_holder').empty();
            	$('#student_list_holder').append(data);
            	$('#student_list_holder').select2();
            });
    	}   
    	
    	$('#member_filter_by').select2();
    });
    
    $('#role_section_options').unbind().on("change",function (){
    	var groupId = $(this).val();    	
    	var urls = '../get_filtered_students?entity_id='+groupId+'&filter_by=GROUP';
        $.get(urls, function(data) {
        	$('#student_list_holder').empty();
        	$('#student_list_holder').append(data);
        	$('#student_list_holder').select2();
        });        
    });	
 }


function init_orgadmin_scheduler() {
    console.log('intiliazing scheduler');    	
    init_auto_scheduler();
    
    $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
    	$('.associateTrainer').select2();
    	});
    
  //---form submiton function
    scheduler_submitModal();
    
    scheduler_init_trainer_associated();
    scheduler_init_edit_new_trainer_associated();
    scheduler_init_edit_old_trainer_associated();
	
	//---clock Date 
    scheduler_ClockDate(true);
    
    //onChange filter function for batchGroup,course and assessment
    scheduler_onChange_init();
    
    var otherEventData = [];
    
    //delete assessment
    scheduler_DeleteAssessment();
    //delete event
    scheduler_DeleteEvent();
     //create new assessment and event 
    scheduler_createNewEventAssessment();
     //modify old event
    scheduler_createOldEvent();
    //UI to modify old event
    scheduler_modifyOldEventModal2();
    //UI to modify new event
    scheduler_newSchedularmodifyModal();
    //create modified event  
    scheduler_createEditedNewModal5();
    //function to add another function on show of modal
    scheduler_onShowOfModal();  
    //auto scheduler
     
}

function init_auto_scheduler()
{
	$('#wizard').steps();
	$('#org_selector').unbind().on('change', function(){
		var orgId = $(this).val();
		$('#entity_type_selector').data('college_id',orgId);
		$('#entity_type_selector').select2();
		$('#entity_list_holder').empty();
		$('#entity_course_holder').empty();
		$('#auto_scheduler_edit_course').empty();
	});
	
	
	$('#entity_type_selector').unbind().on('change', function(){
		$('#admin_page_loader').show();
		var entityType = $(this).val();
		var orgId = $(this).data('college_id');
		var reportId = '3057';
		var course_report_id ='';
		 
		if(entityType==='USER' )
		{			
			reportId =  $(this).data('user_report_id');
			course_report_id = $(this).data('course_report_id_for_user');
		}else if (entityType==='SECTION' )
		{
			reportId =  $(this).data('section_report_id');
			course_report_id = $(this).data('course_report_id_for_section');
		}
		else if(entityType==='ROLE' )
		{
			reportId =  $(this).data('role_report_id');
			course_report_id = $(this).data('course_report_id_for_role');
		}	

		var jsp="/get_data_table_header";
    	$.post(jsp, 
				{report_id : reportId,college_id:orgId}, 
				function(data) {
					$('#entity_list_holder').empty();
					$('#entity_list_holder').append(data);
					
					//starts here
					$("table.datatable_istar" ).each(function() {
						var id = $(this).attr('id');
					var url = '../data_table_controller?';
					var params ={}; 
					$.each($(this).context.dataset, function( index, value ) {		
						url +=index+'='+value+'&';						
						});							
					if ( $.fn.dataTable.isDataTable(this) ) {
					    console.log('dddd');
					    //this.DataTable();
					}
					else
					{
						console.log('>>>>eee>>>');
						$(this).DataTable({
					         pageLength: 10,
					         responsive: true,
					         dom: '<"html5buttons"B>lTfgitp',
					         buttons: [
					             { extend: 'copy'},
					             {extend: 'csv'},
					             {extend: 'excel', title: 'ExampleFile'},
					             {extend: 'pdf', title: 'ExampleFile'},
					             {extend: 'print',
					              customize: function (win){
					                     $(win.document.body).addClass('white-bg');
					                     $(win.document.body).css('font-size', '10px');
					                     $(win.document.body).find('table')
					                             .addClass('compact')
					                             .css('font-size', 'inherit');
					             }
					             }
					         ], "processing": true,
					         "serverSide": true,
					         "ajax": url,
					         "drawCallback": function( settings ) {
					        	 $('input[name=radio_button_'+reportId+']:radio').on('click', function(){
										var selectedEntityId = $('input[name=radio_button_'+reportId+']:checked').val();
										
										$.post(jsp, 
												{report_id : course_report_id, entity_id:selectedEntityId}, 
												function(data2) {
													$('#entity_course_holder').empty();
													$('#entity_course_holder').append(data2);
													
													
													var url2 = '../data_table_controller?';
													var params2 ={}; 
													$.each($('#chart_datatable_'+course_report_id)[0].dataset, function( index, value ) {		
														url2 +=index+'='+value+'&';						
														});	
													$('#chart_datatable_'+course_report_id).dataTable({
														pageLength: 10,
												         responsive: true,
												         dom: '<"html5buttons"B>lTfgitp',
												         buttons: [
												             { extend: 'copy'},
												             {extend: 'csv'},
												             {extend: 'excel', title: 'ExampleFile'},
												             {extend: 'pdf', title: 'ExampleFile'},
												             {extend: 'print',
												              customize: function (win){
												                     $(win.document.body).addClass('white-bg');
												                     $(win.document.body).css('font-size', '10px');
												                     $(win.document.body).find('table')
												                             .addClass('compact')
												                             .css('font-size', 'inherit');
												             }
												             }
												         ], "processing": true,
												         "serverSide": true,
												         "ajax": url2,
														"drawCallback": function( settings ) {
													    	//to preserve selected entityId after data table refresh.
															//$('input[name=radio_button_'+reportId+'][value='+selectedEntityId+']').attr('checked',true);
															// now what happens after selecting a course
															$('input[name=radio_button_'+course_report_id+']:radio').unbind().on('change', function(){
																$('#admin_page_loader').show();
																var courseId = $('input[name=radio_button_'+course_report_id+']:checked').val();
																var entityId = selectedEntityId;
																var edit_course_page_url="/edit_course_for_auto_scheduler.jsp";
														    	$.post(edit_course_page_url, 
																		{entity_type : entityType,entity_id:entityId, course_id :courseId}, 
																		function(data3) {
																			$('#auto_scheduler_edit_course').empty();
																			$('#auto_scheduler_edit_course').append(data3);
																			$('#data_5 .input-daterange').datepicker({
																                keyboardNavigation: false,
																                forceParse: false,
																                autoclose: true
																            });
																			
																		    
																			init_edit_course_changes();

																			$('#admin_page_loader').hide();													
																		});
															});
																$('.pagination .paginate_button').css('display','inline');
													    }
													});
													$('#entity_course_holder').show();
												});
									});		
					         }
					     });
						
						$(this).on( 'draw.dt', function () {
						    callColumnHandlerFunctions();
						    $('.pagination .paginate_button').css('display','inline');
						});
						$('.dataTables_info').hide();
						
					}						
				});
					//ends here
					
								
					$('#entity_list_holder').show();
					$('#admin_page_loader').hide();
		});		
	});
}

function init_edit_course_changes()
{
		
	var scheduler_entity_id = $('#scheduler_entity_id').val();
	var scheduler_entity_type =$('#scheduler_entity_type').val();
	var scheduler_course_id = $('#scheduler_course_id').val();
	var scheduler_total_lessons =$('#scheduler_total_lessons').val();
	var schedule_days = new Array();
	
	$.each( $('input[name=scheduled_days]:checked'), function() {
		console.log($(this).val());
		schedule_days.push($(this).val());
		  // or you can do something to the actual checked checkboxes by working directly with  'this'
		  // something like $(this).hide() (only something useful, probably) :P
		});
	
	//$('input[name=scheduled_days][type=checkbox]:checked').serialize();
	var start_date = $('#sd').val();
	var end_date = $('#ed').val();
	//scheduled_days
	$('input[name=scheduled_days][type=checkbox]').unbind().on('change',function(){
		schedule_days = new Array();
		$.each( $('input[name=scheduled_days]:checked'), function() {
			schedule_days.push($(this).val());
			  // or you can do something to the actual checked checkboxes by working directly with  'this'
			  // something like $(this).hide() (only something useful, probably) :P
			});
	});
	
	$('#sd').on('change', function(){
		//alert($('#sd').val());
		start_date = $('#sd').val();		
	});
	
	$('#ed').on('change', function(){
		//alert($('#ed').val());
		end_date = $('#ed').val();		
	});
	
	$('#save_auto_schedule').unbind().on('click',function(){
		if(schedule_days !=null && start_date!=null && end_date!=null){
			$('#admin_page_loader').show();
			var jsp="/auto_schedule";
	    	$.post(jsp, 
					{scheduled_days : schedule_days,start_date:start_date,scheduler_entity_type: scheduler_entity_type, scheduler_course_id:scheduler_course_id, end_date:end_date,scheduler_total_lessons:scheduler_total_lessons, type:'checking'}, 
					function(data) {						
						
						swal({
	                        title: "Are you sure?",
	                        text: data,
	                        type: "warning",
	                        showCancelButton: true,
	                        confirmButtonColor: "#DD6B55",
	                        confirmButtonText: "Yes, Schedule it!",
	                        cancelButtonText: "No, cancel!",
	                        closeOnConfirm: false,
	                        closeOnCancel: false },
	                    function (isConfirm) {
	                        if (isConfirm) {
	                            swal("Created!", "Tasks has been scheduled.", "success");
	                            $.post(jsp, 
	                					{scheduler_entity_id: scheduler_entity_id,scheduled_days : schedule_days, scheduler_entity_type: scheduler_entity_type,scheduler_course_id:scheduler_course_id,start_date:start_date,end_date:end_date,scheduler_total_lessons:scheduler_total_lessons, type:'create'}, 
	                					function(data2) {
	                						if(data2!=null)
	                							{
	                								var tasks_per_day = data2.split('!#')[0];
	                								var days_scheduled = data2.split('!#')[1];
	                								$('#tasks_per_day').val(tasks_per_day);
	                								$('#total_days_scheduled').val(days_scheduled);
	                								$('#admin_page_loader').hide();
	                							}
	                					});	
	                        } else {
	                            swal("Cancelled", "Task scheduling cancelled successfully.", "error");
	                        }
	                    });
						
			});
		}
		else
			{
			//alert('null ');
			}
	});
}


function init_orgadmin_report(){
	$('.course_rating').each(function(){
		var rating = $(this).data('report')	;
		var rating_class = 'rateYo'+rating;
			$('.'+rating_class).rateYo({
			    rating: rating,
			    readOnly: true,starWidth: "20px"
			  });
		});
	  $('.scroll_content').slimscroll({
           height: '300px'
       });
}

function init_orgadmin_report_detail(){
	
	var maxHeight = Math.max.apply(null, $(".batch-session-button").map(function ()
			{
			    return $(this).height();
			}).get());
	
	$(".batch-session-button").css('height',maxHeight);
	
	$('#page-selection').bootpag({
        total: $('#nosofpages').data('content'),
        maxVisible: 10

    }).on("page", function(event, /* page number  here */ num) {
        console.log("num --> " + num);
        console.log("ddd " + $('#myid').attr('data-course'));
        console.log("ccc " + $('#myid').attr('collegeid'));

        $.post("/GetAllStudentByCourse", {
                page: (num - 1),
                id: $('#myid').attr('data-course'),
                college_id: $('#myid').attr('collegeid'),
                type: $('#myid').attr('type')
            },
            function(data) {
            	$("#student_list_container").empty();
                $("#student_list_container").html(data);
                initiateStudentReportHolder();
                
                
            });
    });
	
	  $('#myModal2').on('shown.bs.modal', function() {
			var otherEventData = []
			//$('#myModal5').modal('toggle');
			 scheduler_createOldEvent();
			 scheduler_DeleteEvent();
			 scheduler_init_edit_new_trainer_associated();
			 scheduler_init_edit_old_trainer_associated();
			 scheduler_ClockDate(false);
			$('select').select2();
			

		});
	//session
	$('#session-page-selection').bootpag({
        total: parseInt($('#session-page-selection').data('size')/3)+1,
        maxVisible: 10
    }).on("page", function(event, /* page number  here */ num) {
        console.log("num --> " + num);
        console.log("batch " + $('#session-page-selection').data('batch'));
        if(num==1){
        	num=0
        }else{
        	num=(num*3)-3;
        }
        
        $.post("../batch_session_model_data.jsp", {
        	      offset: num,
        	      batch_id:$('#session-page-selection').data('batch')
            },
            function(data) {
                $("#batch_session_content").html(data);
                bind_report_session_clicks();
                var maxHeight = Math.max.apply(null, $(".batch-session-button").map(function ()
            			{
            			    return $(this).height();
            			}).get());
            	
            	$(".batch-session-button").css('height',maxHeight);
            });
    });
	
		bind_report_session_clicks();
		
	//assessment
	$('#assessment-page-selection').bootpag({
        total: parseInt($('#assessment-page-selection').data('size')/3)+1,
        maxVisible: 10

    }).on("page", function(event, /* page number  here */ num) {
        console.log("num --> " + num);
        console.log("batch " + $('#assessment-page-selection').data('batch'));
        if(num==1){
        	num=0
        }else{
        	num=(num*3)-3;
        }

        $.post("./report_section/batch_assessment_model_data.jsp", {
  	      offset: num,
  	      batch_id:$('#assessment-page-selection').data('batch')
      },
      function(data) {
          $("#batch_assessment_content").html(data);
          bind_report_session_clicks();
      });
        
    });


    $(".tip-top").tooltip({
        html: true
    });
    var piechart;


    Highcharts.setOptions({
        colors: ['#eb384f', '#ED561B', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
    });

	
    
    initiateStudentReportHolder();
    	
   	
}

function initiateStudentReportHolder()
{
	$('.student_holder').unbind().on("click",function(){
		$('#admin_page_loader').show();
    	var student_id=$(this).data('target');
    	var course_id = $(this).data("course_id");
    	var jsp="/student_card.jsp";
    	$.post(jsp, 
				{course_id : course_id,student_id:student_id}, 
				function(data) {
					$('#student_card_modal').empty();
					$('#student_card_modal').append(data);
					$('.tree1').treed();					
					$('#admin_page_loader').hide()
					$('#student_card_modal').modal();
					
		});
	 });	
}



function bind_report_session_clicks() {
    $('.batch-session-button').unbind().on("click", function() {
        var event_id = $(this).data('event-id');

        var urls = 'modal_session.jsp?event_id=' + event_id;
        $.get(urls, function(data) {
            $(".result").html(data);

            if ($('#session_modal_' + event_id).length > 0) {
                $('#session_modal_' + event_id).remove();
            }
            $("body").append(data);

            $('#session_modal_' + event_id).unbind().on('shown.bs.modal', function() {
            	$('.full-height-scroll').each(function() {
                    $(this).slimscroll({
                        height: $(this).parent().height()
                    });
                    
                    $('iframe').on('load', function() {
                    	$("#session-iframe").contents().keypress(function (event) {
                            console.log(event.which);
                            if (event.which == 13) {
                                return false;
                            }
                        });
                    });
                    
                });
            });
            
            $('#session_modal_' + event_id).on('hidden.bs.modal', function() {
            	$('#session_modal_' + event_id).remove();
            });
            
            
            $('#session_modal_' + event_id).modal();
    
        });
    });



    $('.batch-assessment-button').unbind().on("click", function() {
        var assessment_id = $(this).data('assessment-id');
        var batch_id = $(this).data('batch-id');

        var urls = './modal_assessment.jsp?assessment_id=' + assessment_id + '&batch_id=' + batch_id;
        $.get(urls, function(data) {
            $(".result").html(data);

            if ($('#assessment_modal_' + assessment_id).length > 0) {
                $('#assessment_modal_' + assessment_id).remove();
            }
            $("body").append(data);

            $('#assessment_modal_' + assessment_id).unbind().on('shown.bs.modal', function() {

                $('.modal-student').unbind().on("click", function() {
                	$('.modal-student').css('border-color','');
                    var assessment_id = $(this).data('assessment');
                    var batch_id = $(this).data('batch');
                    var user_id = $(this).data('user');

                    var urls = './moadl_question_data.jsp?assessment_id=' + assessment_id + '&batch_id=' + batch_id + '&user_id=' + user_id;
                    $('#'+$(this).attr('id')).css('border-color','  #eb384f');
                    $.get(urls, function(data) {
                        $(".result").html(data);
                        $('#modal_question_holder').html(data);
                       
                        $('.full-height-scroll').each(function() {
                            $(this).slimscroll({
                                height: $(this).parent().height()
                            });
                        });
                    });
                });

                //onload 
                if ($($('.modal-student')[0])) {
                    var assessment_id = $($('.modal-student')[0]).data('assessment');
                    var batch_id = $($('.modal-student')[0]).data('batch');
                    var user_id = $($('.modal-student')[0]).data('user');

                    var urls = './moadl_question_data.jsp?assessment_id=' + assessment_id + '&batch_id=' + batch_id + '&user_id=' + user_id;
                    $.get(urls, function(data) {
                        $(".result").html(data);
                        $('#modal_question_holder').html(data);
                        $('.full-height-scroll').each(function() {
                            $(this).slimscroll({
                                height: $(this).parent().height()
                            });
                        });
                    });
                }
                $('.full-height-scroll').each(function() {
                    $(this).slimscroll({
                        height: $(this).parent().height()
                    });
                });

            });

            $('#assessment_modal_' + assessment_id).on('hidden.bs.modal', function() {
            	$('#assessment_modal_' + assessment_id).remove();
            });
            
            $('#assessment_modal_' + assessment_id).modal();
        });
    });

}

function createCalender()
{
    $( "div.orgadmin_calendar" ).each(function( index ) {
		 
		var  data_url = $(this).data('url');
		$(this).fullCalendar(
				{     
					header : {
						left : 'prev,next today',
						center : 'title',
						right : 'month,agendaWeek,agendaDay,listWeek'
					},
					navLinks : true, // can click day/week names to navigate views
					editable : true,
					eventLimit : true, // allow "more" link when too many events
					events: data_url,
					
					eventRender: function(event, element) { 
						element.attr("event_id",event.id),
						element.attr("data-status",event.status)
						
						if(event.status=='ASSESSMENT'){
							element.draggable = false;
							event.editable = false;
						}
						 var rigt_box_height = $('#dashboard_right_box').css('height');
			        	    $('#dashboard_left_box').css('height',rigt_box_height);
			        	    $('#dashboard_left_box').css('overflow-y','scroll');
			         var right_box_height_in_super_admin = $('#dashboard_right_holder').css('height');
			        	    $('#dashboard_left_holder').css('height',right_box_height_in_super_admin);
			        	    $('#dashboard_left_holder').css('overflow-y','scroll');	    
			        	    
						},
						complete: function() {
				        	  var rigt_box_height = $('#dashboard_right_box').css('height');
				        	    $('#dashboard_left_box').css('height',rigt_box_height);
				        	    $('#dashboard_left_box').css('overflow-y','scroll');
				        	    alert('rezied'+rigt_box_height);
				         },
						
						
						eventDrop: function (event, delta, revertFunc) {
				            //inner column movement drop so get start and call the ajax function......	
				          //  console.log(event.start.format());
				          //  console.log(event.id);
				          //  var defaultDuration = moment.duration($('#calendar').fullCalendar('option', 'defaultTimedEventDuration'));
				           // var end = event.end || event.start.clone().add(defaultDuration);
				         //   console.log('end is ' + end.format());
				            
				            var editEventId =  event.id;
				            var eventDateTime = event.start.format();
				       		
				       		$.post(
				       				"../event_utility_controller", 
				       				{editEventId : editEventId,
				       				 eventDateTime : eventDateTime}, 
				       				function(data) {
				       						 
				       						location.reload(); 
				       						
				       					
				       					
				       					 });
				        }
				
             });
		
		}); 
    
}



function create_progress_view_chart(flag) {
	
	if(flag){
		$.ajax({
            type: "POST",
            url: '../dashboard_report',
            data: {collegeId:$('#progress_view_datatable').data('college'),report_name:'PROGRESSVIEWREPORT' },
            success: function(data){
           	 $('#progress_view_datatable').replaceWith(data);
           	create_progress_view_chart(false);
            }
        });
	}
	
	 Highcharts.chart('progress_view', {
             data: {
                 table: document
                     .getElementById('progress_view_datatable')
             },
             chart: {
                 type: 'line'
             },
             title: {
                 text: 'Monthly Average Performance'
             },
             credits: {
            	    enabled: false
            	  },
             yAxis: {
                 allowDecimals: false,
                 title: {
                     text: 'Average Adjusted Score'
                 }
             },
             tooltip: {
                 formatter: function() {
                     return '<b>' +
                         this.series.name +
                         '</b><br/>' +
                         this.point.y +
                         ' ' +
                         this.point.name
                         ;
                 }
             }
         });
}
function create_dashboard_calendar() {
	 $('#dashboard_calendar')
     .fullCalendar({
         header: {
             left: 'prev,next today',
             center: 'title',
             right: 'month,agendaWeek,agendaDay,listWeek'
         },
         //defaultDate: '2016-12-12',
         navLinks: true, // can click day/week names to navigate views
         editable: true,
         eventLimit: true, // allow "more" link when too many events
         events: null,
         complete: function() {
        	  var rigt_box_height = $('#dashboard_right_box').css('height');
        	    $('#dashboard_left_box').css('height',rigt_box_height);
        	    $('#dashboard_left_box').css('overflow-y','scroll');
         },
     });
}

function create_competetion_view_calendar(flag) {
	
	if(flag){
		$.ajax({
            type: "POST",
            url: '../dashboard_report',
            data: {collegeId:$('#competition_view_datatable').data('college'),report_name:'COMPETITIONVIEWREPORT' },
            success: function(data){
           	 $('#competition_view_datatable').replaceWith(data);
           	 create_competetion_view_calendar(false);
            }
        });
	}
	 Highcharts
     .chart(
         'competition_view', {
             data: {
                 table: document
                     .getElementById('competition_view_datatable')
             },
             chart: {
                 type: 'bar'
             },
             title: {
                 text: 'Monthly Average Performance'
             },
             credits: {
            	    enabled: false
            	  },
             yAxis: {
                 allowDecimals: false,
                 title: {
                     text: 'Average Adjusted Score'
                 }
             },
             tooltip: {
                 formatter: function() {
                     return '<b>' +
                         this.series.name +
                         '</b><br/>' +
                         this.point.y +
                         ' ' +
                         this.point.name
                         ;
                 }
             }
         });
}

function create_course_view_datatable(flag){
	
	if(flag){
		$.ajax({
            type: "POST",
            url: '../dashboard_report',
            data: {collegeId:$('#select_batchgroup_course_view').data('college'),batchGroupId:$('#select_batchgroup_course_view').val(),report_name:'COURSEVIEWREPORT' },
            success: function(data){
           	 $('#course_view_datatable').replaceWith(data);
           	create_course_view_datatable(false);
            }
        });
	}
	
	 $('#select_batchgroup_course_view').unbind().on('change',function() {
         $.ajax({
             type: "POST",
             url: '../dashboard_report',
             data: {collegeId:$(this).data('college'),batchGroupId:$(this).val(),report_name:'COURSEVIEWREPORT' },
             success: function(data){
            	 $('#course_view_datatable').replaceWith(data);
            		create_course_view_datatable(false);
             }
         });
     });
	
	 Highcharts
     .chart(
         'course_view', {
             data: {
                 table: document
                     .getElementById('course_view_datatable')
             },
             chart: {
                 type: 'column'
             },
             title: {
                 text: 'Monthly Average Performance'
             },
             credits: {
            	    enabled: false
            	  },
             yAxis: {
                 allowDecimals: false,
                 title: {
                     text: 'Average Adjusted Score'
                 }
             },
             tooltip: {
                 formatter: function() {
                     return '<b>' +
                         this.series.name +
                         '</b><br/>' +
                         this.point.y +
                         ' ' +
                         this.point.name
                         ;
                 }
             }
         });
}

function  create_program_view_datatable(flag) {
	
	if(flag){
		$.ajax({
            type: "POST",
            url: '../dashboard_report',
            data: {collegeId:$('#select_course_program_view').data('college'),courseId:$('#select_course_program_view').val(),report_name:'PROGRAMVIEWREPORT' },
            success: function(data){
           	 $('#program_view_datatable').replaceWith(data);
           	 create_program_view_datatable(false);
            }
        });
	}
	
	 $('#select_course_program_view').unbind().on('change',function() {
         $.ajax({
             type: "POST",
             url: '../dashboard_report',
             data: {collegeId:$(this).data('college'),courseId:$(this).val(),report_name:'PROGRAMVIEWREPORT' },
             success: function(data){
            	 $('#program_view_datatable').replaceWith(data);
            	 create_program_view_datatable(false);
             }
         });
     });
	 
	Highcharts
	.chart(
			'program_view',
			{
				data : {
					table : document
							.getElementById('program_view_datatable')
				},
				chart : {
					type : 'column'
				},
				title : {
					text : 'Monthly Average Performance'
				},
				 credits: {
					    enabled: false
					  },
				yAxis : {
					allowDecimals : false,
					title : {
						text : 'Average Adjusted Score'
					}
				},
				tooltip : {
					formatter : function() {
						return '<b>'
								+ this.series.name
								+ '</b><br/>'
								+ this.point.y
								+ ' '
								+ this.point.name
										;
					}
				}
			});

}



function admin_edit_modal_create() {
	    $('.edit_modal').unbind().on('shown.bs.modal', function() {
	        var x = $('#' + $(this).attr('id'));
	        setTimeout(function() {
	                var sel = "";
	                x.find('.modal-body').find('select.select2-dropdown>option:selected').each(
	                    function() {
	                        sel += this.value +",";
	                    });

	                $("input[name='student_list']").val(sel.substring(0, sel.length - 1));
	                $("input[name='batch_groups']").val(sel.substring(0, sel.length - 1));

	               // $('select').select2();
	                
	                $('.select2-dropdown').on("change",function() {
	                        var kk = $(this).val();
	                        $("input[name='student_list']").val(kk);
	                        $("input[name='batch_groups']").val(kk);
	                 });
	            }, 1000);

	    });
}



function admin_course_batch_init() {
	$('.dataTables_info').hide();
	
    $('#admin_page_course').on('change', function() {
        var key = $('#admin_page_course').val();
        var prevKey=$('#admin_page_batchgroup').val();
        var selectBox=$($('#admin_page_batchgroup >option'));
    	var searchArray=[];
    	
    	
    	
        var searchKey = "";
        
        if(prevKey!=null)
        	{
        	//searchKey = prevKey+",";
	        	if(prevKey!=null){
	        		$.each(prevKey, function(index, value) {
	        			selectBox.each(function(){
	        				if($(this).val()==value){
	        					searchArray.push($(this).text());
	        				}
	        			});
	        		});
	        	}
	        	searchKey =searchArray+",";
        	}
        if (key != null) {
            $.each(key, function(index, value) {
                if (index != 0) {
                    searchKey = searchKey + "," + value;
                } else {
                    searchKey = searchKey + value;
                }
            });
        }
        filter_user_table(searchKey);
    });
    
    
    $('#admin_page_batchgroup').on('change', function() {
    	var prevKey=$('#admin_page_course').val();
    	var key = $('#admin_page_batchgroup').val();
    	var selectBox=$($('#admin_page_batchgroup >option'));
    	var searchArray=[];
    	if(key!=null){
    		$.each(key, function(index, value) {
    			selectBox.each(function(){
    				if($(this).val()==value){
    					searchArray.push($(this).text());
    				}
    			});
    		});
    	}
        var searchKey = "";
        if(prevKey!=null)
    	{
        	searchKey = prevKey+",";
    	}
        key=searchArray;
        if (key != null) {
            $.each(key, function(index, value) {
                if (index != 0) {
                    searchKey = searchKey + "," + value;
                } else {
                    searchKey = searchKey + value;
                }
            });
        }
        filter_user_table(searchKey);
    });
}




function admin_skill_content_search_init() {
    $('input[name=input-role-skill]').keyup(function(e) {
        var key = this.value;
        var entityType = $(this).data('entity_type');
        var entityId = $(this).data('entity_id');
        if (key.length > 0) {
            $('#skill_' + entityType+'_'+entityId).each(function() {
                $(this).each(function() {
                    $(this).find('.skill-avilable').each(function() {
                        $(this).css(
                            "cssText",
                            "display:none !important;");
                    });
                });

                $(this).find('.skill-avilable:containsIN(' + key + ')').each(function() {
                    $(this)
                        .css(
                            "cssText",
                            "display:block !important;");
                });
            });
        } else {
            $('.skill-avilable').each(function() {
                $(this).css("cssText","display:block !important;");
            });
        }
    });

    
}



function admin_skill_alertBinding() {
    $('.alert').unbind().on('closed.bs.alert', function(e) {

        var type = $($(this).find('.role-skill')).data('type');

         	if (type != null && type == 'content') {

            var roleIdType = $($(this).find('.role-skill')).data('role-id');
            var skillId = $($(this).find('.role-skill')).data('skill-id');
            var lessonType = $($(this).find('.role-skill')).data('lesson-type');

            var text = $(this).text();
            var typeId = "",
                userType = "";
            if (roleIdType.startsWith("U")) {
                userType = "User";
                typeId = roleIdType.replace("User", "");
            } else if (roleIdType.startsWith("G")) {
                userType = "Group";
                typeId = roleIdType.replace("Group", "");
            } else if (roleIdType.startsWith("R")) {
                userType = "Role";
                typeId = roleIdType.replace("Role", "");
            }

            console.log("typeId " + typeId + " , " + "userType " + userType + " , " + "skillId " + skillId + " , " + "lessonType " + lessonType);
            var url = "../create_delete_content_map"; // the script where you handle the form input.
            $.ajax({
                type: "POST",
                url: url,
                data: {entityId: typeId,entityType: userType,skillId: skillId,skillType: lessonType,type: 'content_map'},
                success: function(data) {
                    $('#role_associated_' + roleIdType).prepend(data);
                    $('#role_skill_count_' + roleIdType).html(parseInt($('#role_skill_count_' + roleIdType).text()) + parseInt($(data).length));
                    //admin_skill_alertBinding();
                }
            });

        }else if(type != null && type == 'course'){
        	
        	var couse_id=$($(this).find('.role-skill')).data('couse-id');
        	var batch_group=$($(this).find('.role-skill')).data('role');
        	
        	
        	var avialable = true;
        	 $('#batch_associated_' + batch_group).find('.role-map').each(function() {
                 if ($(this).data('course') === couse_id) {
                     avialable = false;
                 }
             });
        	
        	if (avialable) {
        	var url = "../create_or_update_batch"; // the script where you handle the form input.
            $.ajax({
                type: "POST",
                url: url,
                data: {couse_id:couse_id,batch_group:batch_group},
                success: function(data) {
                		if($(data).length>0){
                    $('#batch_associated_'+batch_group).prepend(data);
                    //admin_skill_alertBinding();
                		}
                }
            });
        	}else{
        		console.log('Batch already exist');
        	}
        	
        } else {

            var roleIdType = $($(this).find('.skill-map')).data('content-type') + $($(this).find('.skill-map')).data('role');
            var typeId = $($(this).find('.skill-map')).data('role');
            var userType = $($(this).find('.skill-map')).data('content-type');
            var lessonId = $($(this).find('.skill-map')).data('role_skill');

            var url = "../roleSkillCreateOrDelete"; // the script where you handle the form input.
            $.ajax({
                type: "POST",
                url: url,
                data: { type: 'delete_content_map',typeId: typeId,userType: userType, lessonId: lessonId},
                success: function(data) {
                    $('#role_skill_count_' + roleIdType).html(parseInt($('#role_skill_count_' + roleIdType).text()) - 1);
                }
            });
        }
    });
}

//function to delete Assessment
function scheduler_DeleteAssessment() {
	 
	 $(".deleteAssessment-modal").click(function(){ 
		 
		var assessmentData =  $(this).attr('id');
		
		$.post(
				"../event_utility_controller", 
				{deleteAssessment : assessmentData}, 
				function(data) {
					
							});

						});

					}

//function to associated trainer 
function scheduler_init_trainer_associated() {
	 
	 $(".associateTrainer").change(function(){ 
		 
		var associateTrainerID =  $('#'+$(this).attr('id')).val();
		
		$('#'+$(this).attr('id')+'_holder').val(associateTrainerID);

						});

					}
//function to edit old event associated trainer 
function scheduler_init_edit_old_trainer_associated() {
	 
	 $("#edit_old_associateTrainerID").change(function(){ 
		 
		var associateTrainerID = $("#edit_old_associateTrainerID").val();
		$('#edit_old_associateTrainerID_holder').val(associateTrainerID);

						});

					}


//function to edit new event associated trainer 
function scheduler_init_edit_new_trainer_associated() {
	 
	 $("#edit_associateTrainerID").change(function(){ 
		 
		var associateTrainerID = $("#edit_associateTrainerID").val();
		$('#edit_associateTrainerID_holder').val(associateTrainerID);

						});

					}


//function to delete Event
function scheduler_DeleteEvent() {
	 
	 $(".delete-event").click(function(){ 
		 
		var eventid =  $(this).attr('id');
		
		$.post(
				"../event_utility_controller", 
				{deleteEventid : eventid}, 
				function(data) {
	
							});

						});

					}

//form submission for validation with existing events and assessments 
function scheduler_submitModal() {
    $(".form-submit-btn").unbind().click(function(e) {

        e.preventDefault();
        var flag = false;
        var formID = $(this).data('form');

        flag =  scheduler_formValidation(formID,flag);
        
if(flag == true){
	
	  var url = "../createorupdate_events"; // the script where you handle the form input.

      $.ajax({
        type: "POST",
        url: url,
        data: $("#" + formID).serialize(), // serializes the form's elements.



        success: function(data) {
             // show response from the php script.
            var resdata = data

            $('#modal_data').html(data);
            $('#myModal5').modal('show');
            $('#idOfForm').val(formID);
            if (resdata.indexOf('panel-warning') > -1) {
                $("#final_submit_btn").addClass('disabled');
                $('#final_submit_btn').prop('onclick', null).off('click');

                if ($('.panel-warning').length === 1) {
                    $(".modal-subTitle").html("Trainer is teaching in another college");
                } else {
                    $(".modal-subTitle").html("error while creating event Modify your Event");
                }
            } else {
                $("#final_submit_btn").removeClass('disabled');
                $(".modal-subTitle").empty();
            }


        }
    });
	
}else{toastr.error('Please Fill required Fileds!')}

      

    });
}

//validations
function scheduler_formValidation(formID,flag){
	
	//console.log('-formID-'+formID);
	if($('#'+formID+' select.eventType').val() === 'session'){
		
		$('#'+formID).find(':input,select').each(function(){
		
		var inputs = $(this); 
		 var inputsname = $(this).attr('name');
		 console.log('--'+$(this).attr('name')+'---->'+inputs.val());
	
		 if (inputsname != undefined && $(inputs).attr('type')!='submit' && inputs.val() == '') {
			 flag = false;
			 return flag;
		 }else{
			 flag = true; 
		 }
	
		})
		return flag;	
	}else{
		$('#'+formID).find(':input,select').each(function(){
			
			var inputs = $(this); 
			 var inputsname = $(this).attr('name');
			 console.log('--'+$(this).attr('name')+'---->'+inputs.val());
			 if (inputsname != undefined && $(inputs).attr('type')!='submit' && inputs.val() == '') {
				 if(inputsname === 'trainerID' || inputsname === 'classroomID' || inputsname === 'batchID' || inputsname === 'assessmentID' || inputsname === 'eventDate' || inputsname ==='startTime' ){
					 flag = false;
					 return flag;
				 }else{
					 flag = true; 
				 }
				
			 }else{
				 flag = true; 
			 }
		
			})
			return flag;
	}
	
}

// adding clock and date js
//adding clock and date js
function scheduler_ClockDate(flag) {


	
	var d = new Date();
	var time="10:10";
	$.date = function(dateObject) {
		var d = new Date(dateObject); 
		var day = d.getDate(); 
		var month = d.getMonth() + 1; 
		var year = d.getFullYear(); 
		if (day < 10) { day = "0" + day; } 
		if (month < 10) { month = "0" + month; } 
		var date = day + "/" + month + "/" + year; return date; };
		
		$('.clockpicker').clockpicker();
		

    $('#data_2 .input-group.date').datepicker({
		startView : 1,
		todayBtn : "linked",
		keyboardNavigation : false,
		forceParse : false,
		autoclose : true,
		format : "dd/mm/yyyy"
	});
		
		$('#data_5 .input-daterange').datepicker({
            keyboardNavigation: false,
            forceParse: false,
            autoclose: true,
            format : "dd/mm/yyyy"
        });
	if(flag === true){
	//$('.time_holder').val(d.getHours()+':'+d.getMinutes());
//	$('.date_holder').val($.date(d));
/*	$('.date_holder').val($.date(d));
	$('.date_holder').val($.date(d));*/
	 time = d.getHours()+':'+d.getMinutes();
	 $('.time_element').val(time);
	}else{
		//time = $('#currenTime').val();
		 $('#currenTime').val();
	}
	/* var options = {
  		    now: time, //hh:mm 24 hour format only, defaults to current time
  	        twentyFour: true,  //Display 24 hour format, defaults to false
  	        upArrow: 'wickedpicker__controls__control-up',  //The up arrow class selector to use, for custom CSS
  	        downArrow: 'wickedpicker__controls__control-down', //The down arrow class selector to use, for custom CSS
  	        close: 'wickedpicker__close', //The close class selector to use, for custom CSS
  	        hoverState: 'hover-state', //The hover state class to use, for custom CSS
  	        title: 'Event Time', //The Wickedpicker's title,
  	        showSeconds: false, //Whether or not to show seconds,
  	        timeSeparator: ':', // The string to put in between hours and minutes (and seconds)
  	        secondsInterval: 1, //Change interval for seconds, defaults to 1,
  	        minutesInterval: 1, //Change interval for minutes, defaults to 1
  	        beforeShow: null, //A function to be called before the Wickedpicker is shown
  	        afterShow: null, //A function to be called after the Wickedpicker is closed/hidden
  	        show: null, //A function to be called when the Wickedpicker is shown
  	        clearable: false, //Make the picker's input clearable (has clickable "x")
	    };
	   
	 $('.timepicker').wickedpicker(options);*/
	
	 $('.time_element').timepicki({
			show_meridian:false,
			min_hour_value:0,
			max_hour_value:23,
			step_size_minutes:1,
			overflow_minutes:true,
			increase_direction:'up',
			disable_keyboard_mobile: true});
	       
	       
	
}

function scheduler_onChange_init(){
	
	//-----course filter
	 $('.batchGroupID').change(function() {
				
               $.ajax({
                   type: "POST",
                   url: '../event_utility_controller',
                   data: {batchGroupID: this.value },
                   success: function(data){
                    $('.courseID').html(data);
                   }
               });
           });
	
	
	
	/*//-----BatchGroup filter
	 $('.courseID').change(function() {
				
               $.ajax({
                   type: "POST",
                   url: '../event_utility_controller',
                   data: {courseID: this.value },
                   success: function(data){
                   	
                    $('.batchGroupID').html(data);
                   }
               });
           });*/
	
	//-----eventType filter
	 $('.eventType').change(function() {
		 var eventType = this.value
		 var course_id = $($('.courseID>option:selected')).data('course');
		 
		 if(eventType === 'assessment' ){
			 
			 if(course_id === null || course_id === undefined){
				
				 alert('Select Course...');
				
				 
			 }else{
				 
			
		 
               $.ajax({
                   type: "POST",
                   url: '../event_utility_controller',
                   data: {assessmentData:course_id},
                   success: function(data){
                   	
                     $('.assessment').html(data); 
                     $(".assessment_list").css("display", "block");
                   }
               });
			 }
               }else{
               	$('.assessment').val('');
               	$(".assessment_list").css("display", "none");
               	
               }
           });
}

//final-submit to create event or assessment 
function scheduler_createNewEventAssessment() {
	 var fID = null;
	 var fullEventData = [];
	 var tabType;
	 var eventType;
$(".final-submit-btn").unbind().click(function(event ){
	    var $target  = $(event.target);
	    if( $target.is('.disabled') ) {
	        return false;
	    }
	 var url = "../createorupdate_events"; // the script where you handle the form input.
	 	 		 
	 $(".new_schedule").each(function(index ){
		  
		 //Assessment Event creation
		 if($(this).data('trainer_data') === undefined ){
			 
			 
			 fullEventData.push($(this).data('assessment_data'));
			     tabType = $(this).data('assessment_data').tabType;
				 eventType = $(this).data('assessment_data').eventType;

		 }
		 //Event creation
		 else if($(this).data('assessment_data') === undefined ){
			 
			 fullEventData.push($(this).data('trainer_data'));
			  
			     eventType = $(this).data('trainer_data').eventType;
			     tabType = $(this).data('trainer_data').tabType;
			 
		  }
		 	
	 });
	 
	 $.ajax({
	       type: "POST",
	       url: url,
	       data: { tabType:tabType,
	    	       eventDataDetails:JSON.stringify(fullEventData),
	    	       eventType:eventType,
	    	       eventValue:'createEvent'},  

	       success: function(data)
	       
	       {  
	    	   
	    	   if(eventType === 'assessment'){
	    		   
	    		   toastr.success('Assessment Has Been Scheduled!');
	    	   }else{
	    		   
	    		   
	    		   toastr.success('Event Has Been Scheduled!');
	    	   }
	    		   
	    }
	     });
	 
	 toastr.options.onHidden = function() { location.reload(); }
      
   });
}


// old event  submit to create the changed event
function scheduler_createOldEvent() {
	 var fID = null;
$(".edit-submit-btn").unbind().click(function(){
	
	 

	  var url = "../createorupdate_events"; // the script where you handle the form input.

		 $.ajax({
		       type: "POST",
		       url: url,
		       data: $("#idForm4").serialize()+ "&eventValue=" + 'updateEvent', // serializes the form's elements.
		       success: function(data)
		       { $('#myModal2').modal('toggle');
		       }
		     });
      
   });
}

//edit_old_event ui
function scheduler_modifyOldEventModal2() {
	 
$(".modify-modal").click(function(){ 
	 
	var eventid =  $(this).attr('id');
	var orgID = $('#orgID').val();
	var url;
	
	if(orgID === undefined && orgID === null){
		
		url= "../orgadmin/edit_old_event.jsp";
	}else{
		
		url= "../super_admin/edit_old_event.jsp";
	}
	
	
	$.post(url, 
			{eventid : eventid}, 
			function(data) {
				
				          
				            $('.event-edit-modal').empty();
							$('.event-edit-modal').append(data);
							 $('#myModal2').modal('show');
						});

					});

				}


//add new events data into otherEventData using this function and send it to edit_event_modal.jsp
function scheduler_newSchedularmodifyModal() {
	 
	 $(".modify-modal-newSchedular").unbind().click(function(){ 
		 
		 otherEventData = [];
				
		var newEventID = $('#new_schedule_parent_'+$(this).attr('id')).attr('id');
		var trainerID = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').trainerID;
		var hours = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').hours;
		var minute = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').minute;
		var batchID = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').batchID;
		var classroomID = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').classroomID;
		var AdminUserID = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').AdminUserID;
		var orgID = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').orgID;
		var eventType = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').eventType;
		var eventDate =$('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').eventDate;
		var startTime = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').startTime;
		var tabType = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').tabType;
		var associateTrainerID = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').associateTrainerID;
		var uType = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').uType;
		var CurrentSession = $('#new_schedule_parent_'+$(this).attr('id')).data('trainer_data').CurrentSession;
		
		$(".new_schedule").each(function(){
			if(($(this).attr('id')) != newEventID){
				otherEventData.push($(this).data('trainer_data'));
			}
			
	    });
		
		var url
		if(uType != 'SUPER_ADMIN'){
			
			url= "../orgadmin/edit_event_modal.jsp";
			
		}else{
			
			url= "../super_admin/edit_event_modal.jsp";
			
		}
		 
		
		$.post(url, 
				{newEventID:newEventID,
			     trainerID:trainerID,
   	       hours:hours,
   	       minute:minute,
   	       batchID:batchID,
   	       classroomID:classroomID,
   	    AdminUserID:AdminUserID,
   	       orgID:orgID,
   	       associateTrainerID:associateTrainerID,
   	       eventType:eventType,
   	       eventDate:eventDate,
   	       startTime:startTime,
   	       tabType:tabType,
   	      CurrentSession:CurrentSession}, 
				function(data) {
					
					          
					            $('.event-edit-modal').empty();
								$('.event-edit-modal').append(data);
								 $('#myModal2').modal('show');
							});

						});

					}

// sending changed data to controller for verification
function scheduler_createEditedNewModal5() {
	 var fID = null;
$(".newschedule_edit-submit-btn").unbind().click(function(){
	
	 var data = {};
	 $("#idForm4").serializeArray().map(function(x){data[x.name] = x.value;}); 

	  var url = "../createorupdate_events"; // the script where you handle the form input.
	  otherEventData.push(data);
	 
		
			 
		 $.ajax({
		       type: "POST",
		       url: url,
		       data: {eventDataDetails:JSON.stringify(otherEventData)},  

		       success: function(data)
		       {  
		    	   var resdata = data
		    	   $('#modal_data').empty();
		    	   $('#modal_data').html(data); 
		           $('#myModal5').modal('show');
		           
		           if(resdata.indexOf('panel-warning') > -1){  
		        	   $( "#final_submit_btn" ).addClass('disabled'); 
		        	   $( ".modal-subTitle" ).html("error while creating event Modify your Event"); 
		           }else{ $( "#final_submit_btn" ).removeClass('disabled');
		           $( ".modal-subTitle" ).empty();
		           }
		    	   
		       }
		     });
      
   });
}

// functions to add on show of modal
function scheduler_onShowOfModal(){
	
	 $('#myModal5').on('shown.bs.modal', function() {
			
		 scheduler_submitModal();
		 scheduler_createNewEventAssessment();
		 scheduler_modifyOldEventModal2();
		 scheduler_newSchedularmodifyModal();
		 scheduler_DeleteAssessment();

		});
	 
	 
	 $('#myModal2').on('shown.bs.modal', function() {
			var otherEventData = []
			
			if( $('#myModal5').is(':visible') ) {
				$('#myModal5').modal('toggle');
			}
			else {
			    // it's not visible so do something else
			}
			 scheduler_submitModal();
			 scheduler_createOldEvent();
			//deletenewSchedulareditModal();
			 scheduler_init_edit_new_trainer_associated();
			 scheduler_init_edit_old_trainer_associated();
			 scheduler_DeleteEvent();
			 scheduler_newSchedularmodifyModal();
			 scheduler_createEditedNewModal5();
			 scheduler_ClockDate(false);
			 $('select').select2();
			 
			

		}); 
}


function init_super_admin_dashboard(){
	
	
	 
	 $('#myModal2').on('shown.bs.modal', function() {
			var otherEventData = []
			//$('#myModal5').modal('toggle');
			 scheduler_createOldEvent();
			 scheduler_DeleteEvent();
			 scheduler_init_edit_new_trainer_associated();
			 scheduler_init_edit_old_trainer_associated();
			 scheduler_ClockDate(false);
			$('select').select2();
			

		});
	
	 $('.activeaccount').click(function() {
			var id=$(this).data('id');
			if(id==-3){
				window.location.reload();
			}else{
			var url='/super_admin/ajax_partials/dashboard_left.jsp?colegeID='+id;
			$.get(url, function( data ) {
				 
				  $('#dashboard_left_holder').remove();
				  $('#dashboard_holder').prepend(data);				      				    
				});	
			
			/* Calendar FUnctionality*/
			
			$("#dashoboard_cal").fullCalendar('destroy');
			$('#dashoboard_cal').data('url','/get_events_controller?org_id='+id);
			console.log($('#dashoboard_cal').data('url'));
			createCalender();
			//mark_as_read_notification();
		}
			//mark_as_read_notification();			
		});
	
// load js via ajax 
	 mark_as_read_notification();
	 
}

function update_dashboard_left() {
	 /*$.get("response.php", function(data) {
	   $("#some_div").html(data);
	   window.setTimeout(update, 10000);
	 });*/
	
	$.ajax({
	 url: "/super_admin/ajax_partials/dashboard_left.jsp",
	 cache: false
	})
	 .done(function( html ) {
	 $('#loader_left').hide();
	 $( "#dashboard_left_holder" ).empty();
	   $( "#dashboard_left_holder" ).append( html );
	   window.setTimeout(update_dashboard_left, 60000);
	   init_orgadmin_dashboard();
	 });
	}

function init_super_admin_account_mgmt(){
	$('.scroll_content').slimscroll({
	    height: '600px'
	});
	$('.paginatedalphabet').click(
	    function() {

	        $('.paginatedalphabet').each(
	            function() {
	                $(this).parent().removeClass('active');
	            });
	        $(this).parent().addClass(
	            'active');
	        var firstChar = $(this).data(
	            'char')
if(firstChar!='add'){
	        var url = '/super_admin/ajax_partials/college_cards.jsp?firstLetter=' +
	            firstChar;
	        $.get(url, function(data) {
	            $(".result").html(data);
	            $('#account_mgmt_org_holder').children().remove();
	            $('#account_mgmt_org_holder').prepend(data);

	            accountmanagment_card_init();
	        });
}else if(firstChar=='add'){
	init_create_edit_organization(false,0);
}


	    });
	//accountmanagment_card_init();
	$('.paginatedalphabet')[1].click();
}

function init_create_edit_organization(flag,org){ 
	var url="";
if(flag){	
	url='./partials/modal/create_edit_org_modal.jsp?type=Edit&org_id='+org;
}
else{
	url='./partials/modal/create_edit_org_modal.jsp?type=Create';
}

	$.get(url, function(data) {
     
		$('#edit_org_model').remove();
		$('body').append(data);	        			
		
		$('#edit_org_model').on("shown.bs.modal",function(e){
			
			var baseURL = $(".js-data-example-ajax").data("pin_uri");
			var urlPin = baseURL + "PinCodeController";

			$(".js-data-example-ajax").select2({
				ajax : {
					url : urlPin,
					dataType : 'json',
					delay : 250,
					data : function(params) {
						return {
							q : params.term, // search term
							page : params.page
						};
					},
					processResults : function(data, params) {
						params.page = params.page || 1;
						return {
							results : data.items,
							pagination : {
								more : (params.page * 30) < data.total_count
							}
						};
					},
					cache : true
				},
				escapeMarkup : function(markup) {
					return markup;
				}, 
				minimumInputLength : 1,
				templateResult : formatRepo,
				templateSelection : formatRepoSelection
			});
			
		});	        			
		$('.js-data-example-ajax').select2();
		$('#org_profile').unbind().on("keyup",function (){
			
			$('input[name=org_profile]').val($(this).val());
		});

		$('#org_modal_submit').unbind().on("click",function (e){
			    				
				var checkData =function(){
						
					$('#edit_org_model_form').find(':input,select').each(function(){
						var inputs = $(this); 
						var inputsname = $(this).attr('name');
						console.log('--'+$(this).attr('name')+'---->'+inputs.val());
						
						 if (inputsname != undefined && $(inputs).attr('type')!='submit' && $(inputs).attr('name')!='org_profile' && inputs.val() == '') {
							 flag = false;
							 return flag;
						 }else{
							 flag = true; 
						 }
						});
						return flag;
				}
			
			if(checkData()){
				
			var url='../create_or_update_organization';
			 $.post(url, $('#edit_org_model_form').serialize().toString(),
					 function(data) {
				 if(data=="success"){
					 toastr.success('SuccessFully '+$('#org_modal_submit').html()+'d');
					 $('#edit_org_model').modal('hide');
				 }else{
					 toastr.error('Please Provide Proper Information');
				 }
		        });
		}else{
			toastr.error('Please Fill required Fileds!');
		}
		});
		
		$('#edit_org_model').modal('show');
    });
	
}
function formatRepo(repo) {
	if (repo.loading)
		return repo.text;

	var markup = "<div class='select2-result-repository clearfix'>"
			+ repo.id + "</div>";

	if (repo.description) {
		markup += "<div class='select2-result-repository__description'>"
				+ repo.id + "</div>";
	}
	return markup;
}

function formatRepoSelection(repo) {
	return repo.id;
}
function accountmanagment_card_init() {
    $('.clickablecards').unbind().on("click",function() {
            $('.clickablecards').each(function() {
                $(this).removeClass('college-bg');

            });
            $(this).addClass('college-bg');
            $('#modal-title').html($(this).find('h3').text());
            $("#account_managment_iframe").attr("src",
                $(this).data('url'));
            $('#account_managment_model').modal('show');
        });

    $('.full-height-scroll').each(function() {
        $(this).slimscroll({
            height: $(this).parent().height()
        });
    });
    
 $('#account_managment_model').on('hidden.bs.modal', function () {
    	
    	var url = '../orgadmin_login'
		    $.post(url, {delete_session : true },
		        function(data) {
                      console.log('session ended');
		        });
    	  
    	});
 
    $('.edit_organization').unbind().on("click",function(e){
    	var orgId=$(this).data('org');	
    	init_create_edit_organization(true,orgId);
    });
}

function set_batchgroup_data(){

	$('#main_batch_group_holder').on('change', function(){
		var setOfBatchGroup = []
		var batchGroup = $(this).val();
		
		
		setOfBatchGroup.push(batchGroup);
		
		$('#batch_groups').val(setOfBatchGroup);
		
	});
	
}

function init_super_admin_usermgmt(){
	//use existing orgadmin scripts
	
	user_filter_by_course_batch();
	admin_edit_modal_create();
	set_batchgroup_data();
	
$('#college_id').on('change', function(){
		
		var college_id = $(this).val();
		var url = '../event_utility_controller'
		    $.post(url, {
		    	college_id : college_id,
		    	type : "userOrgfilter"
		        },
		        function(data) {

		      $('#batch_group_holder').html(data);
		      set_batchgroup_data();
		      $('#main_batch_group_holder').select2();
		     
	
		        });
		
		
	});
	
	$('.userType').on('change', function(){
		var user_type = $(this).val();
		if(user_type === 'TRAINER'){
			$('#hide_college_holder').hide();
			//$('#hide_group_holder').hide();
			$('#hide_role_holder').hide();
			$('#user_type').val('TRAINER');
			$('#college_id').val('2').trigger('change');
			var url = '../event_utility_controller'
			    $.post(url, {
			    	college_id : '2',
			    	type : "userOrgfilter"
			        },
			        function(data) {

			      $('#batch_group_holder').html(data);
			      set_batchgroup_data();
			      $('#main_batch_group_holder').select2();
			     
		
			        });
			
			
		}else{
			$('#hide_college_holder').show();
			//$('#hide_group_holder').show();
			$('#hide_role_holder').show();
			$('#user_type').val('STUDENT');
		}
		 set_batchgroup_data();
		
	});
	
	
}

function init_super_admin_scheduler(){
	init_auto_scheduler();
	
	   $('.org_holder').change(function() {
			 var orgID =  this.value;
			 
			 var target = $('.super_admin_scheduler.nav-tabs>li.active').find('a').attr('id');
						 
			 var url = '../super_admin/scheduler.jsp?orgID='+ orgID+'&target='+target;
											window.location.href = url;
											
	   });
	   
	   $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
	    	$('.associateTrainer').select2();
	    	});
	    
	   
	   //---form submiton function
	    scheduler_submitModal();
	    
	    scheduler_init_trainer_associated();
	    scheduler_init_edit_new_trainer_associated();
	    scheduler_init_edit_old_trainer_associated();
		
		//---clock Date 
	    scheduler_ClockDate(true);
	    
	    //onChange filter function for batchGroup,course and assessment
	    scheduler_onChange_init();
	    
	    var otherEventData = [];
	    
	    //delete assessment
	    scheduler_DeleteAssessment();
	    //delete event
	    scheduler_DeleteEvent();
	     //create new assessment and event 
	    scheduler_createNewEventAssessment();
	     //modify old event
	    scheduler_createOldEvent();
	    //UI to modify old event
	    scheduler_modifyOldEventModal2();
	    //UI to modify new event
	    scheduler_newSchedularmodifyModal();
	    //create modified event  
	    scheduler_createEditedNewModal5();
	    //function to add another function on show of modal
	    scheduler_onShowOfModal();   
	
	
}


function init_super_admin_comp_prof()
{
	company_profile();
	
	}

function init_super_admin_placemenet()
{
	company_profile();
	}

//analytics js start
function init_super_admin_analytics() {
		//init org report js
		init_orgadmin_report();
	
    trainerRatingGraph();
    trainerLevelGraph();
    trainerSkillGraph();
    //studentFeedBackGraph();
    //studentFeedbackDetailsTable();
   
    accountsData($('.org_holder').val());

    //-----account org filter
    $('.org_holder').change(function() {
        var orgID = this.value;
        accountsData(orgID);

    });

   /* coursesData($('.org_holder_programTab').val());
    $('.course_holder').change(function() {
        var courseID = this.value;
        var orgID = $('.org_holder_programTab').val();
        $('#program_spiner').css('cssText', 'display:block !important');
        programGraph(courseID, orgID);
    });

    $('.org_holder_programTab').change(function() {
        var orgID = this.value;
        coursesData(orgID);
        var courseID = $('.course_holder').val();
        programGraph(courseID, orgID);
        $('#program_spiner').css('cssText', 'display:block !important');
    });*/
    
  
}

function accountsUtils() {
    $('.course_rating').each(function() {
        var rating = $(this).data('report');
        var rating_class = 'rateYo' + rating;

        $('.' + rating_class).rateYo({
            rating: rating,
            readOnly: true,starWidth: "20px"
        });
    });

    $('.scroll_content').slimscroll({
        height: '300px'
    });

}


function accountsData(orgID) {
    var url = '/common_jsps/batch_programs_cards.jsp'
    $.post(url, {
            college_id: orgID
        },
        function(data) {

            $('#super_admin_batch_programs').html(data);
            
            accountsUtils();
        });
}

function coursesData(orgID) {
    var url = '../event_utility_controller'
    $.post(url, {
            program_tab_getcourse: orgID
        },
        function(data) {

            $('.course_holder').html(data);
            $('.course_holder').select2();
            programGraph($('.course_holder').val(), $('.org_holder_programTab').val());
        });
}


function programGraph(cID, oID) {
    var urls = '../program_graphs?courseID=' + cID + '&orgID=' + oID;
    $.get(urls, function(data) {

        $('#program_spiner').css('cssText', 'display:none !important');

        $("#datatable10").html(data);
        Highcharts.chart('container10', {
            data: {
                table: 'datatable10'
            },
            chart: {
                type: 'column'
            },
            title: {
                text: 'Program Statistics'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'Units'
                }
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.series.name + '</b><br/>' +
                        this.point.y + ' ' + this.point.name.toLowerCase();
                }
            }
        });

        /*Highcharts.chart('container10', {
            data: {
                table: document.getElementById('datatable10')
            },
            chart: {
                type: 'column'
            },
            title: {
                text: 'Program Statistics'
            },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'Units'
                }
            },
            showInLegend: true,
            tooltip: {
                formatter: function() {
                    return '<b>' + this.series.name + '</b><br/>' +
                        this.point.y + ' ' + this.point.name.toLowerCase();
                }
            },

            legend: {
                enabled: false
            }
        });*/
    });


}

function studentFeedBackGraph()
{
	var urls = '../get_student_feedback?param=projector';
    $.get(urls, function(data) {
        // console.log(data);
        $("#datatable_projector").html(data);
        Highcharts.chart('container_projector', {
            data: {
                table: document.getElementById('datatable_projector')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Projector Issue'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    
    var urlsinternet = '../get_student_feedback?param=internet';
    $.get(urlsinternet, function(data) {
        // console.log(data);
        $("#datatable_internet").html(data);
        Highcharts.chart('container_internet', {
            data: {
                table: document.getElementById('datatable_internet')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Internet Issue'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    var urlstrainer_knowledge = '../get_student_feedback?param=trainer_knowledge';
    $.get(urlstrainer_knowledge, function(data) {
        // console.log(data);
        $("#datatable_trainer_knowledge").html(data);
        Highcharts.chart('container_trainer_knowledge', {
            data: {
                table: document.getElementById('datatable_trainer_knowledge')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Trainer Knowledge'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    
    var urlstrainer_too_fast = '../get_student_feedback?param=trainer_too_fast';
    $.get(urlstrainer_too_fast, function(data) {
        // console.log(data);
        $("#datatable_trainer_too_fast").html(data);
        Highcharts.chart('container_trainer_too_fast', {
            data: {
                table: document.getElementById('datatable_trainer_too_fast')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Trainer Pace'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    
    var urlsclass_control_by_trainer = '../get_student_feedback?param=class_control_by_trainer';
    $.get(urlsclass_control_by_trainer, function(data) {
        // console.log(data);
        $("#datatable_class_control_by_trainer").html(data);
        Highcharts.chart('container_class_control_by_trainer', {
            data: {
                table: document.getElementById('datatable_class_control_by_trainer')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Class Control By Trainer'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    
    var urlstoo_tough_content = '../get_student_feedback?param=too_tough_content';
    $.get(urlstoo_tough_content, function(data) {
        // console.log(data);
        $("#datatable_too_tough_content").html(data);
        Highcharts.chart('container_too_tough_content', {
            data: {
                table: document.getElementById('datatable_too_tough_content')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Content Toughness'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    var urlstoo_much_theoritic = '../get_student_feedback?param=too_much_theoritic';
    $.get(urlstoo_much_theoritic, function(data) {
        // console.log(data);
        $("#datatable_too_much_theoritic").html(data);
        Highcharts.chart('container_too_much_theoritic', {
            data: {
                table: document.getElementById('datatable_too_much_theoritic')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Content Theory Balance'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    
    var urlsno_fun_in_class = '../get_student_feedback?param=no_fun_in_class';
    $.get(urlsno_fun_in_class, function(data) {
        // console.log(data);
        $("#datatable_no_fun_in_class").html(data);
        Highcharts.chart('container_no_fun_in_class', {
            data: {
                table: document.getElementById('datatable_no_fun_in_class')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Class Fun'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
    
    var urlsenough_examples = '../get_student_feedback?param=enough_examples';
    $.get(urlsenough_examples, function(data) {
        // console.log(data);
        $("#datatable_enough_examples").html(data);
        Highcharts.chart('container_enough_examples', {
            data: {
                table: document.getElementById('datatable_enough_examples')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Examples related To Content'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'percentage'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }

        });

    });
}


function trainerSkillGraph() {

    var urls = '../program_graphs?trainerSkill= trainerSkill';
    $.get(urls, function(data) {
        // console.log(data);
        $("#datatable11").html(data);
        Highcharts.chart('container11', {
            data: {
                table: document.getElementById('datatable11')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Trainer Skill Distribution'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'Units'
                }
            },
            plotOptions: {
            	pie : {
					allowPointSelect : true,
					cursor : 'pointer',
					dataLabels : {
						enabled : false,
						format : '<b>Trainers</b>: {point.percentage:.1f} %',
						style : {
							color : (Highcharts.theme && Highcharts.theme.contrastTextColor)
									|| 'black'
						}
					}
				}
            }

        });

    });
}


function trainerLevelGraph() {

    var urls = '../program_graphs?trainerLevel=trainerLevel';
    $.get(urls, function(data) {
        // console.log(data);

        $("#datatable12").html(data);

        Highcharts.chart('container12', {
            data: {
                table: document.getElementById('datatable12')
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Trainer Level Distribution'
            },
            credits: {
                enabled: false
              },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: 'Units'
                }
            },
            tooltip: {
                formatter: function() {
                    return '<b>' + this.series.name + '</b><br/>' +
                        this.point.y + ' ' + this.point.name.toLowerCase();
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }
        });

    });
}


function trainerRatingGraph() {
    var urls = '../program_graphs?trainerRating=trainerRating';
    $.get(urls, function(data) {
        // console.log(data);
        $("#datatable13").html(data);
        Highcharts.chart('container13', {
            data: {
                table: 'datatable13'
            },
            chart: {
                type: 'pie'
            },
            title: {
                text: 'Trainer Rating Distribution'
            },
            tooltip: {
                formatter: function() {
                    return '<b>' + this.series.name + '</b><br/>' +
                        this.point.y + ' ' + this.point.name.toLowerCase();
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            }
        });

    });
}





/*function trainerDetailsTable() {
    var urls = '../program_graphs?trainerDetails=trainerDetails';
    $.get(urls, function(data) {
        $("#trainer_details_body").html(data);
        trainerDataTable();
    });
}*/




function studentFeedbackDetailsTable() {
    var urls = '../get_student_feedback?param=stuData';
    $.get(urls, function(data) {
        $("#student_feedback_body").html(data);
       // trainerDataTable();
    });
    
    
    Highcharts.chart('piiie_piiie', {
        data: {
            table: document.getElementById('piiie')
        },
        chart: {
            type: 'pie'
        },
        title: {
            text: 'Projector Issue'
        },
        yAxis: {
            allowDecimals: false,
            title: {
                text: 'percentage'
            }
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: false
                },
                showInLegend: true
            }
        }

    });
}

function company_profile() {
    console.log('asdas');
	 Highcharts.chart('container_comp_prof', {
         data: {
             table: document.getElementById('datatable_comp_prof')
         },
         chart: {
             type: 'column'
         },
         title: {
             text: 'Employer Statistics'
         },
         yAxis: {
             allowDecimals: false,
             title: {
                 text: 'Students'
             }
         },
         tooltip: {
             formatter: function() {
                 return '<b> Candidates </b><br/>' +
                     this.point.y + ' ' ;
             }
         },

         legend: {
             enabled: false
         }
     });
	 
	 
	 Highcharts.chart('container_comp_prof1', {
         data: {
             table: document.getElementById('datatable_comp_prof1')
         },
         chart: {
             type: 'line'
         },
         title: {
             text: 'Employer Statistics'
         },
         yAxis: {
             allowDecimals: false,
             title: {
                 text: 'Students'
             }
         },
         tooltip: {
             formatter: function() {
                 return '<b> Candidates </b><br/>' +
                     this.point.y + ' ' ;
             }
         },

         legend: {
             enabled: false
         }
     });
	 
	 
	 
	
	 $( ".year_wise_salary_breakdown" ).each(function() {
		  
		 var year = $(this).attr('id').replace("datatable_comp_prof_","");
		
		 Highcharts.chart('container_comp_prof_'+year, {
	         data: {
	             table: document.getElementById('datatable_comp_prof_'+year)
	         },
	         chart: {
	             type: 'column'
	         },
	         title: {
	             text: null
	         },
	         yAxis: {
	             allowDecimals: false,
	             title: {
	                 text: 'Students'
	             }
	         },
	         tooltip: {
	             formatter: function() {
	                 return '<b> Candidates </b><br/>' +
	                     this.point.y + ' ' ;
	             }
	         },

	         legend: {
	             enabled: false
	         }
	     });
		 
		 
		 
		});
	 
}

function init_istar_notification(){
	
	
	console.log('istar Notification');
	$('#notification_type_holder').on("change", function() {
		
		if($(this).val() === 'LESSON' ){
			
			var entity_id = $('#notification_batchgroup_holder').val();
			var entity_type = 'LESSON';
			$.ajax({
				type : "POST",
				url : '../get_notification_data',
				data : {
					entity_id : entity_id,
					entity_type : entity_type
				},
				success : function(data) {
					$('#course_holder').select2();;
					$('#course_holder').html(data);
					$('#notification_assessment_holder').select2('val','null');
				}
			});
			
			$('#course_holder').select2();
			init_courseFilter();			
			$('#play_presentation_holder').show();
			$('#play_assessment_holder').hide();
			
			
		}else if($(this).val() === 'ASSESSMENT' ){
			$('#play_presentation_holder').hide();
			init_courseFilterForAssessment();
			
			$('#play_assessment_holder').show();
			
			
			
			
			
			
			var entity_id = '0';
			var entity_type = 'ASSESSMENT';
			$.ajax({
				type : "POST",
				url : '../get_notification_data',
				data : {
					entity_id : entity_id,
					entity_type : entity_type
				},
				success : function(data) {
					
					$('#notification_assessment_holder').html(data);
					$('#notification_assessment_holder').select2();
					$('#course_holder').select2('val','null');
					$('#notification_cmsession_holder').select2('val','null');
					$('#notification_ppt_holder').select2('val','null');
				}
			});
			
				
			$('#play_presentation_holder').hide();			
			$('#play_assessment_holder').show();
			
			
		}else{
			$('#play_presentation_holder').hide();
			$('#play_assessment_holder').hide();
			$('#course_holder').select2('val','null');
			$('#notification_cmsession_holder').select2('val','null');
			$('#notification_ppt_holder').select2('val','null');
			$('#notification_assessment_holder').select2('val','null');
		}
		
	});

	$('#notification_college_holder').on("change", function() {
		var orgId = $(this).val();
		var type = 'ORG';
		$.ajax({
			type : "POST",
			url : '../get_notification_data',
			data : {
				entity_id : orgId,
				entity_type : type
			},
			success : function(data) {
				
				$('#notification_batchgroup_holder').select2('val','null');
				$('#notification_batchgroup_holder').html(data);
			}
		});
		
		var type = 'ORG_STUDENTS';
		
		$.ajax({
			type : "POST",
			url : '../get_notification_data',
			data : {
				entity_id : orgId,
				entity_type : type
			},
			success : function(data) {
				
				$('#student_holder').html(data);													
				init_checkAllStudent();	
			}
		});
	});

	$('#notification_batchgroup_holder').unbind().on("change", function() {
		var batchGroupId = $(this).val();
		var type = 'GROUP';

		if (batchGroupId != 'null') {
			$.ajax({
				type : "POST",
				url : '../get_notification_data',
				data : {
					entity_id : batchGroupId,
					entity_type : type
				},
				success : function(data) {					
					$('#student_holder').html(data);													
					init_checkAllStudent();	
					$('#notification_type_holder').select2('val','null');
				}
			});
		}				
	});
	
	function init_courseFilter() {
	$('#course_holder').on("change", function() {
		var course = $(this).val();
		var type = 'COURSE';

		if (course != 'null') {
			$.ajax({
				type : "POST",
				url : '../get_notification_data',
				data : {
					entity_type : type,
					entity_id : course
				},
				success : function(data) {
					$('#notification_cmsession_holder').html(data);
					$('#notification_cmsession_holder').select2('val','null');
					init_cmsessionFilter();
				}
			});
		}
	});
	}
	
	
	function init_courseFilterForAssessment() {
		$('#notification_assessment_course_holder').on("change", function() {
			var course = $(this).val();
			var type = 'ASSESSMENT_COURSE';

			if (course != 'null') {
				$.ajax({
					type : "POST",
					url : '../get_notification_data',
					data : {
						entity_type : type,
						entity_id : course
					},
					success : function(data) {
						$('#notification_assessment_holder').html(data);
						$('#notification_assessment_holder').select2();
					}
				});
			}
		});
		}
	
	function init_cmsessionFilter() {
		$('#notification_cmsession_holder').on("change", function() {
			var cmsession = $(this).val();
			var type = 'CMSESSION';

			if (cmsession != 'null') {
				$.ajax({
					type : "POST",
					url : '../get_notification_data',
					data : {
						entity_type : type,
						entity_id : cmsession
					},
					success : function(data) {
						
						$('#notification_ppt_holder').html(data);
						$('#notification_ppt_holder').select2('val','null');
					}
				});
			}
		});
		}
	
	
	function init_checkAllStudent() {
		$("#checkAll").change(function(){
		        if($(this).is(":checked")) {
		          
		            $('.student_checkbox_holder').prop('checked', true);

		        } else {
		        	 $('.student_checkbox_holder').prop('checked', false);
		        }		        
		    });		
	}
	
	$( "#send_notification" ).unbind().on('click',function() {
		
		var flag = false;
		var notification_type = $('#notification_type_holder').val();
		//defined in istar_notification
		
		var adminId = $('#hidden_admin_id').val();
		//
		if(notification_type==='LESSON')
		{			
			var group_id = $('#notification_batchgroup_holder').val();
			var notification_type = 'LESSON';
			var course_id =$('#course_holder').val(); ;
			var cmsession_id = $('#notification_cmsession_holder').val(); ;
			var lesson_id =$('#notification_ppt_holder').val();;
			var studentlistID=[];			
			$('input:checkbox.student_checkbox_holder').each(function () {	
				if($(this).is(":checked")){
					studentlistID.push(this.checked ? $(this).val() : ""); 	
				}
			  });
			
			var title = $('#title').val();
			var comment = $('#comment').val(); 
			
			if(group_id==null || course_id ==null || cmsession_id==null || lesson_id == null || studentlistID.length <=0)
			{
				
		            swal({
		                title: "Missing mandatory fields",
		                text: "Section, Course, Session, Lesson and Students are mandatory to send lesson as notification."
		            });
		        
			}
			else
			{
				$('#spinner_holder').show();				
				$.ajax({
					type : "POST",
					url : '../create_notification',
					data : {
						notification_type : notification_type,
						title : title,
						comment : comment,
						course_id : course_id,
						group_id : group_id,						
						cmsession_id : cmsession_id,
						lesson_id:lesson_id,						
						admin_id:adminId,
						studentlist_id : studentlistID.toString()
						},
					success : function(data) {
						$('#spinner_holder').hide();
					   location.reload();
					}
				});
			}	
		}
		else if(notification_type==='ASSESSMENT')
		{
			var group_id = $('#notification_batchgroup_holder').val();
			var notification_type = 'ASSESSMENT';
			var assessment_id = $('#notification_assessment_holder').val();
			var studentlistID=[];			
			$('input:checkbox.student_checkbox_holder').each(function () {	
				if($(this).is(":checked")){
					studentlistID.push(this.checked ? $(this).val() : ""); 	
				}
			  });
			
			var title = $('#title').val();
			var comment = $('#comment').val(); 			
			
			if(assessment_id ==null || studentlistID.length <=0)
			{
				
		            swal({
		                title: "Missing mandatory fields",
		                text: "Assessment and Students are mandatory to send assessment as notification."
		            });
		        
			}
			else
			{
				$('#spinner_holder').show();				
				$.ajax({
					type : "POST",
					url : '../create_notification',
					data : {
						notification_type : notification_type,
						title : title,
						comment : comment,												
						assessment_id: 	assessment_id,			
						admin_id:adminId,
						studentlist_id : studentlistID.toString()
						},
					success : function(data) {
						$('#spinner_holder').hide();
					   location.reload();
					}
				});
			}	
		}		
		else if(notification_type==='COMPLEX_UPDATE')
		{
			var group_id = $('#notification_batchgroup_holder').val();
			var notification_type = 'COMPLEX_UPDATE';
			
			var studentlistID=[];			
			$('input:checkbox.student_checkbox_holder').each(function () {	
				if($(this).is(":checked")){
					studentlistID.push(this.checked ? $(this).val() : ""); 	
				}
			  });
			
			if(studentlistID.length <=0)
				{
				 swal({
		                title: "Missing mandatory fields",
		                text: "Students are mandatory to send updated content as notification."
		            });
		        
				}
			else
			{
				$('#spinner_holder').show();				
				$.ajax({
					type : "POST",
					url : '../create_notification',
					data : {
						notification_type : notification_type,												
						admin_id:adminId,
						studentlist_id : studentlistID.toString()
						},
					success : function(data) {
						$('#spinner_holder').hide();
					   location.reload();
					}
				});
			}	
		}
		else if(notification_type==='MESSAGE')
		{
			var notification_type = 'MESSAGE';
			var studentlistID=[];			
			$('input:checkbox.student_checkbox_holder').each(function () {	
				if($(this).is(":checked")){
					studentlistID.push(this.checked ? $(this).val() : ""); 	
				}
			  });
			var title = $('#title').val();
			var comment = $('#comment').val(); 			
			if(studentlistID.length <=0 || title==null || comment==null)
			{
				swal({
	                title: "Missing mandatory fields.",
	                text: "Title, Description and Students are mandatory to send message."
	            });
			}
			else
				{
				$('#spinner_holder').show();				
				$.ajax({
					type : "POST",
					url : '../create_notification',
					data : {
						notification_type : notification_type,												
						admin_id:adminId,
						title : title,
						comment : comment,
						studentlist_id : studentlistID.toString()
						},
					success : function(data) {
						$('#spinner_holder').hide();
					   location.reload();
					}
				});
				}
			
		}
		else
		{
			swal({
                title: "Missing mandatory fields.",
                text: "Select a type of notification."
            });
		}	
	});

	
}

function init_opsReport2(){
	
	$('.ops_report_data_table').each(
			function(e) {

				var question_id = $(this).data('question');

				var table = 'ops_report_' + question_id;

				Highcharts.chart('container_' + question_id, {
					data : {
						table : table
					},
					chart : {
						type : 'column'
					},
					title : {
						text : 'NO of Students'
					},
					yAxis : {
						allowDecimals : false,
						title : {
							text : 'student'
						}
					},
					plotOptions : {
						series : {
							borderWidth : 0,
							dataLabels : {
								enabled : true,
								format : '{point.y}'
							}
						}
					},
					tooltip : {
						formatter : function() {
							return this.point.y + ' ' + this.point.name
									+ ' <b>' + this.series.name
									+ '</b> this question<br/>';
						}
					}, colors: ['#eb384f','#f8ac59', '#8f938f']
				});

			});
}

function init_opsReport(){

	
	Highcharts.chart('student_score_graph_container',
			{
				data : {
					table : 'student_score_graph_table'
				},
				chart : {
					type : 'column'
				},
				title : {
					text : 'Student Score Graph'
				},
				yAxis : {
					allowDecimals : false,
					title : {
						text : 'Units'
					}
				},
				tooltip : {
					formatter : function() {
						return this.point.y
								+ ' <b>'
								+ this.series.name
								+ '</b><br/>'
								+ ' '
								+ this.point.name
										.toLowerCase();
					}
				}
			});

	Highcharts.chart('student_precentage_graph_container',
			{
				data : {
					table : 'student_precentage_graph_datatable'
				},
				chart : {
					type : 'column'
				},
				title : {
					text : 'Student Percentage Graph'
				},
				yAxis : {
					allowDecimals : false,
					title : {
						text : 'Units'
					}
				},
				tooltip : {
					formatter : function() {
						return this.point.y
								+ ' <b>'
								+ this.series.name
								+ '</b><br/>'
								+ ' are '
								+ this.point.name
										.toLowerCase();
					}
				}
			});
	
	
}


function init_reports_section(){
	
	
	  $('.report_college').on("change", function() {
			var orgId = $(this).val();
			var type = 'org';
			$.ajax({
				type : "POST",
				url : '/get_ops_report',
				data : {
					orgId : orgId,
					type : type
				},
				success : function(data) {
					$('.report_batch').html(data);
				}
			});
		});
	
	$('.report_batch').on("change", function() {
		var batch = $(this).val();
		var type = 'batch';

		if (batch != 'null') {
			$.ajax({
				type : "POST",
				url : '/get_ops_report',
				data : {
					type : type,
					batch : batch
				},
				success : function(data) {
					$('.report_assessment').html(data);

				}
			});
		}
	});

	$('.report_assessment').on("change", function() {
		var batch = $('.report_batch').val();
		var flag = false;
		if(batch == 'null'){
			flag = true;
			batch = $('.report_batch_holder').val();
		}
		
		var assessment = $(this).val();
		var url=$(this).data('url');
		if (assessment != 'null') {
			$.ajax({
				type : "POST",
				url : url,
				data : {
					assessmentId : assessment,
					batchId : batch
				},
				success : function(data) {
					
					if(flag == false){
						$('#ops_report_holder_result1').html(data);
						init_opsReport();
					}else{
						$('#ops_report_holder_result2').html(data);
						init_opsReport2();
					}
					
				}
			});
		}else{
			if(flag == false){
				$('#ops_report_holder_result1').html("<div class='col-lg-4'></div><div class='alert alert-danger text-center col-lg-4'>Sorry No Data Found</div><div class='col-lg-4'></div>");
				
			}else{
				$('#ops_report_holder_result2').html("<div class='col-lg-4'></div><div class='alert alert-danger text-center col-lg-4'>Sorry No Data Found</div><div class='col-lg-4'></div>");
	
			}
			
		}
	});
}

function init_super_admin_report(){
	
	init_reports_section();
	
}

function init_superadmin_class_room(){
	
	$('#class-add').on("click",function(){
		var urls = 'partials/modal/create_edit_classroom_modal.jsp?type=Create';
    	$.get( urls, function( data ) {
    		  $('#edit_class_room_model').remove(); 
    		  $("body").append(data);
    		  init_classRoom_Modal();
    		  $('#edit_class_room_model').modal();
    		});
		
		
		
	});
	
}

function init_classRoom_Modal(){
	
	$('#class_modal_submit').unbind().on("click",function (e){
		var checkData =function(){
			$('#edit_class_model_form').find(':input,select').each(function(){
				var inputs = $(this); 
				var inputsname = $(this).attr('name');
				console.log('--'+$(this).attr('name')+'---->'+inputs.val());
				
				 if (inputsname != undefined && $(inputs).attr('type')!='submit' && inputs.val() == '') {
					 flag = false;
					 return flag;
				 }else if ($(inputs).attr('name')=='class_ip' && !ValidateIPaddress(inputs.val())){
					 flag = false;
					 return flag;
				 }else{
					 flag = true; 
				 }
				});
				return flag;
		}
	
	if(checkData()){
		
	var url='../create_or_update_classroom';
	 $.post(url, $('#edit_class_model_form').serialize().toString(),
			 function(data) {
		 				$('#edit_class_room_model').modal('hide');
		 				var table=$('#classroom_list').DataTable();
		 			  table.search('').draw();
        });
}else{
	toastr.error('Please Fill required Fileds!');
}
});	
	
}

function ValidateIPaddress(ipaddress)   
{	  
 if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipaddress))  
  {  
    return (true)  
  }  
return (false)  
}



yes_js_login = function() {
    // Your code here
    return false;
}