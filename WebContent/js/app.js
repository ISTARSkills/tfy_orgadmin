function readyFn(jQuery) {

	$('select').select2();
	loadTables();

	/*
	 * Page specific js
	 */
	var body_id = document.getElementsByTagName("body")[0].id;
	
	switch (body_id) {
	case 'orgadmin_dashboard':
		init_orgadmin_dashboard();
		break;
	case 'orgadmin_admin':
		init_orgadmin_admin();
		break;
	case 'orgadmin_scheduler':
		init_orgadmin_scheduler();
		break;
		
	case 'orgadmin_report':
		init_orgadmin_report();
		break;
	
	case 'orgadmin_report_detail':
		init_orgadmin_report_detail();
		break;
	case 'superadmin_dashboard':
		init_super_admin_dashboard();
		break;
	case 'super_admin_account_managment':
		init_super_admin_account_mgmt();
		break;
	case 'super_admin_user_managment':
		init_super_admin_usermgmt();
		break;
	case 'super_admin_scheduler':
		init_super_admin_scheduler();
		break;	
	case 'super_admin_analytics':
		init_super_admin_analytics();
		break;

	case 'super_admin_comp_prof':
		init_super_admin_comp_prof();
		break;
	case 'super_admin_placemenet':
		init_super_admin_placemenet();
		break;

	default:
		init_orgadmin_none();
	}
	
	createCalender();
	
	setInterval(init_session_logs, 10000);
	
	$.contextMenu({
        selector: '.fc-event', 
        callback: function(key, options) {
            var m = "clicked: " + key;           
           var eventid =  $(this).attr('event_id');
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
   								});
   		}
   		
           
            
            
        },
        items: {
            "delete": {name: "Delete", icon: "delete"},
            "edit": {name: "Edit", icon: "edit",visible:true},
        },
        events:{show : function(options){
           	if($(this).data('status')==='ASSESSMENT'){
           		options.$menu.find('.context-menu-icon-edit').addClass('display-hidden');
           	}else{
           		options.$menu.find('.context-menu-icon-edit').removeClass('display-hidden');
           	}
          },
          hide : function(options){
                      
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




function loadTables(){
	var url=$('.datatable').attr('url');
	
	$('table.datatable_istar').each(function(){
	  var id=$(this).attr('id');
	  var url=$(this).data('url');
	  
	  $('#'+id).on( 'draw.dt', function () {   
		  $(".user-edit-popup").click(function(){
		    	var user_id =  $(this).data('user_id');
		    	var urls = 'partials/modal/admin_user_edit_modal.jsp?user_id='+user_id;
		    	$.get( urls, function( data ) {
		    		  $( ".result" ).html( data );
		    		  
		    		  if($('#edit_user_model_'+user_id).length>0){
		    			  $('#edit_user_model_'+user_id).remove(); 
		    		  }
		    		  $( "body" ).append(data);
		    		  admin_edit_modal_create();
		    		  $('#edit_user_model_'+user_id).modal();
		    		 
		    		});
		    	// open modal using js now 
		    	// action goes here!!
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
	  
	});

	
}

$( document ).ready( readyFn );

function init_orgadmin_none() {
	
}



function init_orgadmin_dashboard() {
    console.log('intiliazing Dashboard');
    create_progress_view_chart(true);
    create_competetion_view_calendar(true);
    create_dashboard_calendar();
    create_course_view_datatable(true);
    create_program_view_datatable(true);
    scheduler_createOldEvent();
}

function init_orgadmin_admin() {
    console.log('intiliazing Admin');
    trainerDataTable();
    //init user tab search box
    admin_course_batch_init();
    
    //init multiple selection inupt boxes
    admin_choosen_init();
    
    //event handlings of edit window
    admin_edit_modal_create();
    
  //ajax requests
    admin_load_resources();
    
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
    
}

function init_orgadmin_scheduler() {
    console.log('intiliazing scheduler');
    
  //---form submiton function
    scheduler_submitModal();
    
    scheduler_init_trainer_associated();
    scheduler_init_edit_new_trainer_associated();
    scheduler_init_edit_old_trainer_associated();
	
	//---clock Date 
    scheduler_ClockDate();
    
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
                $("#student_list_container").html(data);
            });
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
        
        $.post("./report_section/batch_session_model_data.jsp", {
        	      offset: num,
        	      batch_id:$('#session-page-selection').data('batch')
            },
            function(data) {
                $("#batch_session_content").html(data);
                bind_report_session_clicks();
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
        colors: ['#50B432', '#ED561B', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
    });

    Highcharts.chart('container1', {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: 'Student Performance'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
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
        series: [{
            name: 'Brands',
            colorByPoint: true,

            data: $('#pieChartData').data('content')
        }]
    });


    Highcharts.chart('container2', {
        chart: {
            type: 'bar'
        },
        title: {
            text: 'Level of Mastery'
        },
        subtitle: {
            text: 'Data Analytics Program'
        },
        xAxis: {
            categories: $('#barchartTitle').data('content')
        },
        yAxis: {
            min: 0,
            max: 100,
            title: {
                text: 'Percentage of Students'
            }
        },
        legend: {
            reversed: true
        },
        plotOptions: {
            series: {
                stacking: 'normal'
            }
        },
        series: $('#barchartContent').data('content')
    });


    Highcharts.chart('container', {
        data: {
            table: document.getElementById('datatable')
        },
        chart: {
            type: 'area'
        },
        title: {
            text: 'Weekly Attendance Records'
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
                    this.point.y;
            }
        }
    });
	
    $('.student_holder').on("click",function(){
    	var target=$(this).find('.holder-data').data('target');
    	$(target).modal().show();
    });	
}

function bind_report_session_clicks() {
    $('.batch-session-button').unbind().on("click", function() {
        var event_id = $(this).data('event-id');

        var urls = './report_section/modal_session.jsp?event_id=' + event_id;
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

        var urls = './report_section/modal_assessment.jsp?assessment_id=' + assessment_id + '&batch_id=' + batch_id;
        $.get(urls, function(data) {
            $(".result").html(data);

            if ($('#assessment_modal_' + assessment_id).length > 0) {
                $('#assessment_modal_' + assessment_id).remove();
            }
            $("body").append(data);

            $('#assessment_modal_' + assessment_id).unbind().on('shown.bs.modal', function() {

                $('.modal-student').unbind().on("click", function() {
                    var assessment_id = $(this).data('assessment');
                    var batch_id = $(this).data('batch');
                    var user_id = $(this).data('user');

                    var urls = './report_section/moadl_question_data.jsp?assessment_id=' + assessment_id + '&batch_id=' + batch_id + '&user_id=' + user_id;
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

                    var urls = './report_section/moadl_question_data.jsp?assessment_id=' + assessment_id + '&batch_id=' + batch_id + '&user_id=' + user_id;
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
         defaultDate: '2016-12-12',
         navLinks: true, // can click day/week names to navigate views
         editable: true,
         eventLimit: true, // allow "more" link when too many events
         events: null
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

	                $('select').select2();
	                
	                $('.select2-dropdown').on("change",function() {
	                        var kk = $(this).val();
	                        $("input[name='student_list']").val(kk);
	                        $("input[name='batch_groups']").val(kk);
	                 });
	            }, 1000);

	    });
}

function admin_choosen_init() {
	 $('select').select2();
	 $('.select2-dropdown').on("change",function() {
         var kk = $(this).val();
         $("input[name='student_list']").val(kk);
         $("input[name='batch_groups']").val(kk);
  });
}

function admin_course_batch_init() {
	$('.dataTables_info').hide();
	
    $('#admin_page_course').on('change', function() {
        var key = $('#admin_page_course').val();
        var searchKey = "";
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

function filter_user_table(key) {
    if (key == null) {
        key = '';
    }
    var table = $('#student_list').DataTable();
    table.search(key).draw();
}

function admin_load_resources(){
	var count=0;
	$('.content-map-ajax-request').each(function(){
		var tab=$(this);
		var type=$(this).data('type');
		var id=$(this).data('org');
		var url=$(this).data('url')+'?colegeID='+id+'&type='+type;
		if(type=='User'){
			url=url+'&offset=0'
		}
	
		//console.log(url);
		$.get(url, function( data ) {
			  $(".result").html(data);
			  
			  $('.spinner-animation-holder_'+type).css("cssText","display:none !important;");
			  tab.append(data);
			  count++;
			  if(count==3){
			  
			    //initilize and event handling of skills search box
			   admin_skill_content_search_init();
			    
			    //removeing conetent skills event handling and ajax calls
			   admin_skill_alertBinding();
			    
			   
			    $('.full-height-scroll').each(function(){
			    	$(this).slimscroll({height:$(this).parent().height()});
			    });
			    
			  }
			  
			});
	});
	
	$('#page-selection').bootpag({
        total: parseInt($('#page-selection').data('size')/10+1),
        maxVisible: 10
    }).on("page", function(event, /* page number  here */ num){
			var offset=(num*10)-10;
						
			var tab=$(this);
			var type=$(this).data('type');
			var id=$(this).data('org');
			var url=$(this).data('url')+'?colegeID='+id+'&type='+type;
			if(type=='User'){
				url=url+'&offset='+offset
			}
		
			//console.log(url);
			$.get(url, function( data ) {
				  $(".result").html(data);
				  
				  $(tab).parent().parent().find('.tabs-container').remove();
				  
				  $(tab).parent().parent().append(data);					  
				  
				    //initilize and event handling of skills search box
				   admin_skill_content_search_init();
				    
				    //removeing conetent skills event handling and ajax calls
				   admin_skill_alertBinding();
				    
				    $('.full-height-scroll').each(function(){
				    	$(this).slimscroll({height:$(this).parent().height()});
				    });
				    
				});
    });
	
	$('#content-user-search').on('change', function() {
		var searchkey=$(this).val().replace(' ','%20');
		var tab=$(this);
		var type=$(this).data('type');
		var id=$(this).data('org');
		var url=$(this).data('url')+'?colegeID='+id+'&type='+type;
		
		if(searchkey.length!=0){
		 url=url+'&searchkey='+searchkey;
		}else{
			url=url+'&offset=0';
		}
			
		console.log(url);
		$.get(url, function( data ) {
			  $(".result").html(data);
			  
			  $(tab).parent().parent().parent().find('.tabs-container').remove();
			  
			  $(tab).parent().parent().parent().append(data);					  
			  
			    //initilize and event handling of skills search box
			   admin_skill_content_search_init();
			    
			    //removeing conetent skills event handling and ajax calls
			   admin_skill_alertBinding();
			    
			    $('.full-height-scroll').each(function(){
			    	$(this).slimscroll({height:$(this).parent().height()});
			    });
			    
			});
		});
	
	}

function admin_skill_content_search_init() {
    $('input[name=input-role-skill]').keyup(function(e) {
        var key = this.value;
        var data_role = $(this)
            .data('role');
        if (key.length > 0) {
            $('#skill_' + data_role).each(function() {
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

        if (type != null && type == 'skill') {

            var roleId = $($(this).find('.role-skill')).data('role-id');
            var skillId = $($(this).find('.role-skill')).data('skill-id');
            var text = $(this).text();

            var avialable = true;
            $('#role_associated_' + roleId).find('.role-map').each(function() {
                if ($(this).data('role_skill') === skillId) {
                    avialable = false;
                }
            });

            if (avialable) {

                //<button aria-hidden='true' data-dismiss='alert' data-role='"+roleId+"' data-role_skill='"+skillId+"'	class='close role-map' type='button'>x</button>
                var appendingDiv = "<div class='alert alert-dismissable gray-bg'>" + text + "</div>";

                $('#role_skill_count_' + roleId).html(parseInt($('#role_skill_count_' + roleId).text()) + 1);
                $('#role_associated_' + roleId).prepend(appendingDiv);

                var url = "../roleSkillCreateOrDelete"; // the script where you handle the form input.
                $.ajax({
                    type: "POST",
                    url: url,
                    data: {roleId: roleId,skillId: skillId,type: 'roles_map'},
                    success: function(data) {
                        console.log('successfullly mapped');
                    }
                });

            } else {
                console.log('already exist');
            }
        } else if (type != null && type == 'content') {

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
            var url = "../roleSkillCreateOrDelete"; // the script where you handle the form input.
            $.ajax({
                type: "POST",
                url: url,
                data: {typeId: typeId,userType: userType,skillId: skillId,lessonType: lessonType,type: 'content_map'},
                success: function(data) {
                    $('#role_associated_' + roleIdType).prepend(data);
                    $('#role_skill_count_' + roleIdType).html(parseInt($('#role_skill_count_' + roleIdType).text()) + parseInt($(data).length));
                    admin_skill_alertBinding();
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
                    admin_skill_alertBinding();
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
function scheduler_ClockDate() {

	
	
	
	var d = new Date();
	
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
	
	$('.time_holder').val(d.getHours()+':'+d.getMinutes());
	$('.date_holder').val($.date(d));
	$('.date_holder').val($.date(d));
	$('.date_holder').val($.date(d));
	
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
		       { $('#myModal2').modal('toggle');}
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
   	       tabType:tabType}, 
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
			 scheduler_ClockDate();
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
			 scheduler_ClockDate();
			 $('select').select2();
			

		});
	
	$('.activeaccount').click(function() {
		var id=$(this).data('id');
		var url='/super_admin/ajax_partials/dashboard_left.jsp?colegeID='+id;
		$.get(url, function( data ) {
			  $(".result").html(data);
			  $('#dashboard_left_holder').remove();
			  $('#dashboard_holder').prepend(data);					      				    
			});	
		
		/* Calendar FUnctionality*/
		
		$("#dashoboard_cal").fullCalendar('destroy');
		$('#dashoboard_cal').data('url','/get_events_controller?org_id='+id);
		console.log($('#dashoboard_cal').data('url'));
		createCalender();
				
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

	        var url = '/super_admin/ajax_partials/college_cards.jsp?firstLetter=' +
	            firstChar;
	        $.get(url, function(data) {
	            $(".result").html(data);
	            $('#account_mgmt_org_holder').children().remove();
	            $('#account_mgmt_org_holder').prepend(data);

	            accountmanagment_card_init();
	        });

	    });
	accountmanagment_card_init();
}


function accountmanagment_card_init() {
    $('.clickablecards').unbind().on("click",function() {
            $('.clickablecards').each(function() {
                $(this).removeClass('lazur-bg');

            });
            $(this).addClass('lazur-bg');
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
}


function init_super_admin_usermgmt(){
	//use existing orgadmin scripts
	admin_course_batch_init();
	admin_choosen_init();
	admin_edit_modal_create();
	
	
	
	$('.userType').on('change', function(){
		var user_type = $(this).val();
		if(user_type === 'TRAINER'){
			$('#hide_college_holder').hide();
			$('#hide_group_holder').hide();
			$('#hide_role_holder').hide();
			$('#user_type').val('TRAINER');
			
			
		}else{
			$('#hide_college_holder').show();
			$('#hide_group_holder').show();
			$('#hide_role_holder').show();
			$('#user_type').val('STUDENT');
		}
		
		
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
		filter_user_table(searchKey);
	});
}

function init_super_admin_scheduler(){
	
	   $('.org_holder').change(function() {
			 var orgID =  this.value;
			 
			 var target = $('.nav-tabs>li.active').find('a').attr('id');
						 
			 var url = '../super_admin/scheduler.jsp?orgID='+ orgID+'&target='+target;
											window.location.href = url;
});
	   
	   //---form submiton function
	    scheduler_submitModal();
	    
	    scheduler_init_trainer_associated();
	    scheduler_init_edit_new_trainer_associated();
	    scheduler_init_edit_old_trainer_associated();
		
		//---clock Date 
	    scheduler_ClockDate();
	    
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
    studentFeedBackGraph();
    trainerDetailsTable();
    studentFeedbackDetailsTable();
   
    accountsData($('.org_holder').val());

    //-----account org filter
    $('.org_holder').change(function() {
        var orgID = this.value;
        accountsData(orgID);

    });

    coursesData($('.org_holder_programTab').val());
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
    });
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
    var url = '../program_graphs'
    $.post(url, {
            account_tab_orgID: orgID
        },
        function(data) {

            $('#course_event_card').html($(data)[0]);
            $('#batch_event_card').html($(data)[1]);
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
            tooltip: {
                formatter: function() {
                    return '<b>' + this.series.name + '</b><br/>' +
                        this.point.y + ' ' + this.point.name.toLowerCase();
                }
            },

            legend: {
                enabled: false
            }
        });
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

function trainerDataTable() {
    $('.dataTables-example').each(function(){
    	$(this).DataTable({
        pageLength: 15,
        responsive: true,
        dom: '<"html5buttons"B>lTfgitp',
        buttons: [{
                extend: 'copy'
            },
            {
                extend: 'csv'
            },
            {
                extend: 'excel',
                title: 'ExampleFile'
            },
            {
                extend: 'pdf',
                title: 'ExampleFile'
            },

            {
                extend: 'print',
                customize: function(win) {
                    $(win.document.body).addClass('white-bg');
                    $(win.document.body).css('font-size', '10px');

                    $(win.document.body).find('table')
                        .addClass('compact')
                        .css('font-size', 'inherit');
                }
            }
        ]

    });
    	});
    
}



function trainerDetailsTable() {
    var urls = '../program_graphs?trainerDetails=trainerDetails';
    $.get(urls, function(data) {
        $("#trainer_details_body").html(data);
        trainerDataTable();
    });
}




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

