/*
 * Page specific js
 */
var body_id = document.getElementsByTagName("body")[0].id;
$('.nav-item').removeClass('active');
  switch (body_id) {
case 'student_dashbard':
	init_student_dashbard_variables();
	init_student_dashbard_function();
	break;
case 'student_role':
	init_student_role_variables();
	init_student_role_function();
	break;
case 'student_skill_profile':
	init_student_skill_profile_variables();
	init_student_skill_profile_function();
	break;
case 'orgadmin_dashbard':
	init_orgadmin_dashbard_variables();
	init_orgadmin_dashbard_function();
	break;
case 'orgadmin_roles_report':
	init_orgadmin_roles_report_variables();
	init_orgadmin_roles_report_function();
	break;
case 'orgadmin_groups_report':
	init_orgadmin_groups_report_variables();
	init_orgadmin_groups_report_function();
	break;
case 'orgadmin_individual_groups_report':
	init_orgadmin_individual_groups_report_variables();
	init_orgadmin_individual_groups_report_function();
	break;
case 'orgadmin_individual_role_report':
	init_orgadmin_individual_role_report_variables();
	init_orgadmin_individual_role_report_function();
	break;
	
	
	case 'student_begin_skill':
		init_student_begin_skill_variables();
		init_student_begin_skill_function();
		break;
	case 'org_scheduler':
		setupScheduler();
		break
	case 'org_scheduler_month':
		setupSchedulerMonthly()
		break
		
		
default:
	init_default_js();
}

  
function init_default_js() {

}

/* init student dashboard */
function init_student_dashbard_variables() {

	$('#dashboard').parent().addClass('active');

}
/* init student dashboard */

/* student dashboard functions*/
function init_student_dashbard_function() {

}
/* student dashboard functions*/

/* init student roles */
function init_student_role_variables() {

	$('#roles').parent().addClass('active');

}
/* init student roles */

/* student roles functions*/

function init_student_role_function() {

}
/* student roles functions*/

/* init student skill profile */
function init_student_skill_profile_variables() {

	$('#skillprofile').parent().addClass('active');

}
/* init student skill profile */

/* student skill_profile functions*/
function init_student_skill_profile_function() {

}
/* student skill_profile functions*/


/* init student begin skill */
function init_student_begin_skill_variables(){
	
	$('#roles').parent().addClass('active');
	
}
/* init student begin skill */

/* studentbegin skill functions*/
function init_student_begin_skill_function(){
	
	
}
/* student begin skill functions*/

function init_orgadmin_dashbard_variables(){
	$('#dashboard').parent().addClass('active');
	
}
function init_orgadmin_dashbard_function(){
	
}


function init_orgadmin_roles_report_variables(){
	$('#reports').parent().addClass('active');
}
function init_orgadmin_roles_report_function(){
	
}
function init_orgadmin_groups_report_variables(){
	$('#reports').parent().addClass('active');
}
function init_orgadmin_groups_report_function(){
	
}

function init_orgadmin_individual_role_report_variables(){
	$('#reports').parent().addClass('active');
}
function init_orgadmin_individual_role_report_function(){
	
}
function init_orgadmin_individual_groups_report_variables(){
	$('#reports').parent().addClass('active');
}
function init_orgadmin_individual_groups_report_function(){
	
}

function setupScheduler(){
	$('#scheduler').parent().addClass('active');
  //  $(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:ii'});
	var today = new Date();
	var dayOfWeekStartingSundayZeroIndexBased = today.getDay(); // 0 : Sunday ,1 : Monday,2,3,4,5,6 : Saturday
	var mondayOfWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay()+1);
	var sundayOfWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay()+7);
	
	$('.calendar-date-size').html(formatDate(mondayOfWeek)+' - '+formatDate(sundayOfWeek));
	
	$('.fa-long-arrow-left.custom-arrow-style').click(function (){
		//alert('left wla');
		 mondayOfWeek = new Date(mondayOfWeek.getFullYear(), mondayOfWeek.getMonth(), mondayOfWeek.getDate() - mondayOfWeek.getDay()-6);
		 sundayOfWeek = new Date(sundayOfWeek.getFullYear(), sundayOfWeek.getMonth(), sundayOfWeek.getDate() - sundayOfWeek.getDay()-7);
			$('.calendar-date-size').html(formatDate(mondayOfWeek)+' - '+formatDate(sundayOfWeek));
			$('.calendar-date-size').attr('data-calStartDate',formatJavaDate(mondayOfWeek));
			$('.calendar-date-size').attr('data-calEndDate',formatJavaDate(sundayOfWeek));
			var course_id =  $('#role-select').val();
			 var session_type = $('#session-select').val();
			var college_id = $('#session-select').attr('data-college_id');
			 getSchedulerData(session_type,course_id,formatJavaDate(mondayOfWeek),formatJavaDate(sundayOfWeek),college_id,'clearall');

	});
	$('.fa-long-arrow-right.custom-arrow-style').click(function (){
		//alert('right wla');
		 mondayOfWeek = new Date(mondayOfWeek.getFullYear(), mondayOfWeek.getMonth(), mondayOfWeek.getDate() - mondayOfWeek.getDay()+8);
		 sundayOfWeek = new Date(sundayOfWeek.getFullYear(), sundayOfWeek.getMonth(), sundayOfWeek.getDate() - sundayOfWeek.getDay()+7);
			$('.calendar-date-size').html(formatDate(mondayOfWeek)+' - '+formatDate(sundayOfWeek));
			$('.calendar-date-size').attr('data-calStartDate',formatJavaDate(mondayOfWeek));
			$('.calendar-date-size').attr('data-calEndDate',formatJavaDate(sundayOfWeek));
			var course_id =  $('#role-select').val();
			 var session_type = $('#session-select').val();
			var college_id = $('#session-select').attr('data-college_id');
			 getSchedulerData(session_type,course_id,formatJavaDate(mondayOfWeek),formatJavaDate(sundayOfWeek),college_id,'clearall');
			

	});
	
	$('select#session-select').on('change', function(){
			   // alert( this.value );
			    
			    var session_type = $(this).val();
				var course_id =  $('#role-select').val();
				
				var startDate =	$('.calendar-date-size').attr('data-calStartDate');
				var endDate = $('.calendar-date-size').attr('data-calEndDate');
				var college_id = $(this).attr('data-college_id');
				 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'clearall');
			});
	$('select#role-select').on('change', function(){
		
	//	 alert( this.value );
		    var session_type = $('#session-select').val();
			var course_id =  $(this).val();
			var startDate =	$('.calendar-date-size').attr('data-calStartDate');
			var endDate = $('.calendar-date-size').attr('data-calEndDate');
			
			var college_id = $('#session-select').attr('data-college_id');
			 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'clearall');
			   
			});
	$("a.green-border-dashboard").click(function() {
		
		//alert( 'clicked green' );
		var session_type = $('#session-select').val();
		var course_id =  $('#role-select').val();
		var startDate =	$('.calendar-date-size').attr('data-calStartDate');
		var endDate = $('.calendar-date-size').attr('data-calEndDate');
		
		var college_id = $('#session-select').attr('data-college_id');
		 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'ongoing');
		
	});
	$("a.blue-border-dashboard").click(function() {
		
	//	alert( 'clicked blue' );
		var session_type = $('#session-select').val();
		var course_id =  $('#role-select').val();
		var startDate =	$('.calendar-date-size').attr('data-calStartDate');
		var endDate = $('.calendar-date-size').attr('data-calEndDate');
		
		var college_id = $('#session-select').attr('data-college_id');
		 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'scheduled');
	});
	$("a.red-border-dashboard").click(function() {
		
	//	alert( 'clicked red' );
		var session_type = $('#session-select').val();
		var course_id =  $('#role-select').val();
		var startDate =	$('.calendar-date-size').attr('data-calStartDate');
		var endDate = $('.calendar-date-size').attr('data-calEndDate');
		
		var college_id = $('#session-select').attr('data-college_id');
		 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'completed');
	});
	
	$("a.default-border-dashboard").click(function() {
		
		//	alert( 'clicked red' );
			var session_type = $('#session-select').val();
			var course_id =  $('#role-select').val();
			var startDate =	$('.calendar-date-size').attr('data-calStartDate');
			var endDate = $('.calendar-date-size').attr('data-calEndDate');			
			var college_id = $('#session-select').attr('data-college_id');
			 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'clearall');
		});
	
	 $('#daterange').daterangepicker().on('apply.daterangepicker', function(ev, picker) {
		 
	        console.log(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
	        var startDate = picker.startDate.format('yyyy-mm-dd');
	        var endDate = picker.endDate.format('yyyy-mm-dd');
	        var session_type = $('#session-select').val();
	    	var course_id =  $('#role-select').val();
	    	var college_id = $('#session-select').attr('data-college_id');
	    	getSchedulerData(session_type,course_id,formatJavaDate(startDate),formatJavaDate(endDate),college_id,'clearall');
	       
	        
	        
	    });
	
	$(".calendar-icon").click(function() {
		//$('#datetimepicker1').daterangepicker('show');
		//$('.show-calendar').show();
	});
	
	
	function getSchedulerData(session_type,course_id,startDate,endDate,college_id,status){
		
		var url = 	$('#calendar_holder').attr('data-url');
		url += 'scheduler/'+college_id+'/scheduler_list/startDate/'+startDate+'/endDate/'+endDate+'/sessionType/'+session_type+'/status/'+status+'/course_id/'+course_id+'';
		
		var htmlAdd = "";
		 $.ajax({
			  url: url,
			 type: 'GET',
			    async: true,
			   dataType: "json",
       	  success:function(result) {
       		  

       		  
       		  console.log(result);
       		 var maxSize = "";  
       		
       		if(result.calendarData.monday.length != 0){
       		 maxSize = result.calendarData.monday.length;
       		}
         if(result.calendarData.tuesday.length != 0 && result.calendarData.tuesday.length > maxSize){
        	 maxSize = result.calendarData.tuesday.length;
       			
       		}
          if(result.calendarData.wednesday.length != 0 && result.calendarData.wednesday.length > maxSize){
        	  maxSize = result.calendarData.wednesday.length;
		
	     }
          if(result.calendarData.thrusday.length != 0 && result.calendarData.thrusday.length > maxSize){
    	   maxSize = result.calendarData.thrusday.length;
		
	      }
          if(result.calendarData.friday.length != 0 && result.calendarData.friday.length > maxSize){
        	 maxSize = result.calendarData.friday.length;
		
	    }
          if(result.calendarData.saturday.length != 0 && result.calendarData.saturday.length > maxSize){
        	  maxSize = result.calendarData.saturday.length;
		
	    }
          if(result.calendarData.sunday.length != 0 && result.calendarData.sunday.length > maxSize){
        	 maxSize = result.calendarData.sunday.length;
	
        }
          
         var onGoing = "#7ed321";
         var Scheduled = "#35bdf0";
         var Completed = "#df756a";
          var status="";
          
          var today = formatJavaDate(new Date());
          var dateFrom = startDate;
          var dateTo = endDate;

          var d1 = dateFrom.split("-");
          var d2 = dateTo.split("-");
          var c = today.split("-");
          var day = "";
          var from = new Date(d1[0], parseInt(d1[1])-1, d1[2]);  // -1 because months are from 0 to 11
          var to   = new Date(d2[0], parseInt(d2[1])-1, d2[2]);
          var check = new Date(c[0], parseInt(c[1])-1, c[2]);
       
          if(check > from && check < to){
        	  day = formatDay(new Date);
        	  $('.'+day+'date_holder').addClass('scheduler-calendar-event-bgcolor');
        	  $('.'+day+'date_holder').empty();
        	  $('.'+day+'date_holder').append('Today | '+ day.charAt(0).toUpperCase() + day.slice(1));
        	  
          }else{
        	      $('.scheduler-calendar-event-bgcolor').text($('.scheduler-calendar-event-bgcolor').text().split('|')[1])
        		  $('.scheduler-calendar-event-bgcolor').removeClass('scheduler-calendar-event-bgcolor');
        		 
        		 
        	 
          }
          
          if(maxSize!=0){
        	  
         
          
          for(var i = 0; i<maxSize; i++ ){
        	  
        	 
        	  htmlAdd += "<div class='row m-0 p-0 custom-scroll-holder' style='border-right: 1px solid #eee;border-left: 1px solid #eee; width: 163px;display: -webkit-inline-box; align-items: center;'>"; 
        	 
        	  if(result.calendarData.monday.length > i){
        		  
        		  if(result.calendarData.monday[i].status == 'TEACHING'){
        			  status = onGoing;
        		  }else if(result.calendarData.monday[i].status == 'SCHEDULED'){
        			  status = Scheduled;
        		  }else if(result.calendarData.monday[i].status == 'ASSESSMENT'){
        			  status = Scheduled;
        		  }else{
        			  status = Completed;
        		  }
        		  
        		  var eveDate = formatJavaDate(new Date(result.calendarData.monday[0].eve_date));
        		  var bgColor = '';
        		  if(today == eveDate){
        			  bgColor = 'scheduler-calendar-event-bgcolor';
        			  
        		  }else{
        			  bgColor = ''; 
        		  }
        		  
        		  htmlAdd += "<div class='custom-calendar-item-colums find_currentDate_child "+bgColor+"' data-currentDate='gbfgbf' style='width: 163px;'>";
    	       		 htmlAdd += "<div class='' style='border-top: 5px solid "+status+";justify-self: start; width: 147px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>";
    	       		 htmlAdd += " <div class='row scheduler-calendar-event-header m-0 p-2' >";
    	       		 htmlAdd += " <i style='color: #2196f2;' class='fa fa-clock-o aligncenter' aria-hidden='true'></i> <h2 class='calendar-time-size mx-auto mb-0 aligncenter'>"+result.calendarData.monday[i].event_time+"</h2>";      		 
    	       		 htmlAdd += "<i class='fa fa-video-camera aligncenter' style='color: #999999;' aria-hidden='true'></i>";
    	       		 htmlAdd += "</div>";
    	       		 htmlAdd += "<h2 class='w-100 cal-event-name p-2 popover-dismiss' data-toggle='popover, data-trigger='hover' data-placement='top' data-content='"+result.calendarData.monday[i].course_name+"'>"+result.calendarData.monday[i].course_name.substr(0,21)+'...'+"</h2>";
    	       		 htmlAdd += "<h2 class='w-100 cal-event-batch p-2'>"+result.calendarData.monday[i].bg_name+"</h2>";
    	       		 htmlAdd += "<h2 class='w-100 cal-event-trainer p-2'>By "+result.calendarData.monday[i].trainer_name+"</h2>";
    	       		 htmlAdd += "</div>";
    	       		 htmlAdd += "</div>";
        		  
        	  }
        	  htmlAdd += "</div>";
        	  htmlAdd += "<div class='row m-0 p-0 custom-scroll-holder' style='border-right: 1px solid #eee;border-left: 1px solid #eee; width: 163px;display: -webkit-inline-box; align-items: center;'>"; 
              if(result.calendarData.tuesday.length > i){
            	  
            	  if(result.calendarData.tuesday[i].status == 'TEACHING'){
        			  status = onGoing;
        		  }else if(result.calendarData.tuesday[i].status == 'SCHEDULED'){
        			  status = Scheduled;
        		  }else if(result.calendarData.tuesday[i].status == 'ASSESSMENT'){
        			  status = Scheduled;
        		  }else{
        			  status = Completed;
        		  }
            	  
            	  var eveDate = formatJavaDate(new Date(result.calendarData.tuesday[0].eve_date));
        		  var bgColor = '';
        		  if(today == eveDate){
        			  bgColor = 'scheduler-calendar-event-bgcolor';
        			  
        		  }else{
        			  bgColor = ''; 
        		  }
            	  
            	  htmlAdd += "<div class='custom-calendar-item-colums find_currentDate_child "+bgColor+"' data-currentDate='gbfgbf' style='width: 163px; border-left: 1px solid #eee;'>";
    	       		 htmlAdd += "<div class='' style='border-top: 5px solid "+status+";justify-self: start; width: 147px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>";
    	       		 htmlAdd += " <div class='row scheduler-calendar-event-header m-0 p-2' >";
    	       		 htmlAdd += " <i style='color: #2196f2;' class='fa fa-clock-o aligncenter' aria-hidden='true'></i> <h2 class='calendar-time-size mx-auto mb-0 aligncenter'>"+result.calendarData.tuesday[i].event_time+"</h2>";      		 
    	       		 htmlAdd += "<i class='fa fa-video-camera aligncenter' style='color: #999999;' aria-hidden='true'></i>";
    	       		 htmlAdd += "</div>";
    	       		 htmlAdd += "<h2 class='w-100 cal-event-name p-2 popover-dismiss' data-toggle='popover, data-trigger='hover' data-placement='top' data-content='"+result.calendarData.tuesday[i].course_name+"'>"+result.calendarData.tuesday[i].course_name.substr(0,21)+'...'+"</h2>";
    	       		 htmlAdd += "<h2 class='w-100 cal-event-batch p-2'>"+result.calendarData.tuesday[i].bg_name+"</h2>";
    	       		 htmlAdd += "<h2 class='w-100 cal-event-trainer p-2'>By "+result.calendarData.tuesday[i].trainer_name+"</h2>";
    	       		 htmlAdd += "</div>";
    	       		 htmlAdd += "</div>";
        		  
        	  }
              htmlAdd += "</div>";
        	  htmlAdd += "<div class='row m-0 p-0 custom-scroll-holder' style='border-right: 1px solid #eee;border-left: 1px solid #eee; width: 163px;display: -webkit-inline-box; align-items: center;'>"; 
             if(result.calendarData.wednesday.length > i){
            	 
            	 if(result.calendarData.wednesday[i].status == 'TEACHING'){
       			  status = onGoing;
       		  }else if(result.calendarData.wednesday[i].status == 'SCHEDULED'){
       			  status = Scheduled;
       		  }else if(result.calendarData.wednesday[i].status == 'ASSESSMENT'){
       			  status = Scheduled;
       		  }else{
       			  status = Completed;
       		  }
            	 var eveDate = formatJavaDate(new Date(result.calendarData.wednesday[0].eve_date));
       		  var bgColor = '';
       		  if(today == eveDate){
       			  bgColor = 'scheduler-calendar-event-bgcolor';
       			 
       			  
       		  }else{
       			  bgColor = ''; 
       		  }
            	 
            	 htmlAdd += "<div class='custom-calendar-item-colums find_currentDate_child "+bgColor+"' data-currentDate='gbfgbf' style='width: 163px; border-left: 1px solid #eee;'>";
   	       		 htmlAdd += "<div class='' style='border-top: 5px solid "+status+";justify-self: start; width: 147px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>";
   	       		 htmlAdd += " <div class='row scheduler-calendar-event-header m-0 p-2' >";
   	       		 htmlAdd += " <i style='color: #2196f2;' class='fa fa-clock-o aligncenter' aria-hidden='true'></i> <h2 class='calendar-time-size mx-auto mb-0 aligncenter'>"+result.calendarData.wednesday[i].event_time+"</h2>";      		 
   	       		 htmlAdd += "<i class='fa fa-video-camera aligncenter' style='color: #999999;' aria-hidden='true'></i>";
   	       		 htmlAdd += "</div>";
   	       		 htmlAdd += "<h2 class='w-100 cal-event-name p-2  popover-dismiss' data-toggle='popover, data-trigger='hover' data-placement='top' data-content='"+result.calendarData.wednesday[i].course_name+"'>"+result.calendarData.wednesday[i].course_name.substr(0,21)+'...'+"</h2>";
   	       		 htmlAdd += "<h2 class='w-100 cal-event-batch p-2'>"+result.calendarData.wednesday[i].bg_name+"</h2>";
   	       		 htmlAdd += "<h2 class='w-100 cal-event-trainer p-2'>By "+result.calendarData.wednesday[i].trainer_name+"</h2>";
   	       		 htmlAdd += "</div>";
   	       		 htmlAdd += "</div>";
	  
              }
             htmlAdd += "</div>";
       	  htmlAdd += "<div class='row m-0 p-0 custom-scroll-holder' style='border-right: 1px solid #eee;border-left: 1px solid #eee; width: 163px;display: -webkit-inline-box; align-items: center;'>"; 
            if(result.calendarData.thrusday.length > i){
            	
            	 if(result.calendarData.thrusday[i].status == 'TEACHING'){
       			  status = onGoing;
       		  }else if(result.calendarData.thrusday[i].status == 'SCHEDULED'){
       			  status = Scheduled;
       		  }else if(result.calendarData.thrusday[i].status == 'ASSESSMENT'){
       			  status = Scheduled;
       		  }else{
       			  status = Completed;
       		  }
            	 var eveDate = formatJavaDate(new Date(result.calendarData.thrusday[0].eve_date));
          		  var bgColor = '';
          		  if(today == eveDate){
          			  bgColor = 'scheduler-calendar-event-bgcolor';
          			
          		  }else{
          			  bgColor = ''; 
          		  }
          		  
            	 htmlAdd += "<div class='custom-calendar-item-colums find_currentDate_child "+bgColor+"' data-currentDate='gbfgbf' style='width: 163px; border-left: 1px solid #eee;'>";
   	       		 htmlAdd += "<div class='' style='border-top: 5px solid "+status+";justify-self: start; width: 147px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>";
   	       		 htmlAdd += " <div class='row scheduler-calendar-event-header m-0 p-2' >";
   	       		 htmlAdd += " <i style='color: #2196f2;' class='fa fa-clock-o aligncenter' aria-hidden='true'></i> <h2 class='calendar-time-size mx-auto mb-0 aligncenter'>"+result.calendarData.thrusday[i].event_time+"</h2>";      		 
   	       		 htmlAdd += "<i class='fa fa-video-camera aligncenter' style='color: #999999;' aria-hidden='true'></i>";
   	       		 htmlAdd += "</div>";
   	       		 htmlAdd += "<h2 class='w-100 cal-event-name p-2  popover-dismiss' data-toggle='popover' data-trigger='hover' data-placement='top' data-content='"+result.calendarData.thrusday[i].course_name+"'>"+result.calendarData.thrusday[i].course_name.substr(0,21)+'...'+"</h2>";
   	       		 htmlAdd += "<h2 class='w-100 cal-event-batch p-2'>"+result.calendarData.thrusday[i].bg_name+"</h2>";
   	       		 htmlAdd += "<h2 class='w-100 cal-event-trainer p-2'>By "+result.calendarData.thrusday[i].trainer_name+"</h2>";
   	       		 htmlAdd += "</div>";
   	       		 htmlAdd += "</div>";
	  
            }
            htmlAdd += "</div>";
      	  htmlAdd += "<div class='row m-0 p-0 custom-scroll-holder' style='border-right: 1px solid #eee;border-left: 1px solid #eee; width: 163px;display: -webkit-inline-box; align-items: center;'>"; 
           if(result.calendarData.friday.length > i){
        	   
        	   if(result.calendarData.friday[i].status == 'TEACHING'){
     			  status = onGoing;
     		  }else if(result.calendarData.friday[i].status == 'SCHEDULED'){
     			  status = Scheduled;
     		  }else if(result.calendarData.friday[i].status == 'ASSESSMENT'){
     			  status = Scheduled;
     		  }else{
     			  status = Completed;
     		  }
        	   
        	   var eveDate = formatJavaDate(new Date(result.calendarData.friday[0].eve_date));
       		  var bgColor = '';
       		  if(today == eveDate){
       			  bgColor = 'scheduler-calendar-event-bgcolor';
       			
       		  }else{
       			  bgColor = ''; 
       		  }
        	   
        	   htmlAdd += "<div class='custom-calendar-item-colums find_currentDate_child "+bgColor+"' data-currentDate='gbfgbf' style='width: 163px; border-left: 1px solid #eee;'>";
 	       		 htmlAdd += "<div class='' style='border-top: 5px solid "+status+";justify-self: start; width: 147px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>";
 	       		 htmlAdd += " <div class='row scheduler-calendar-event-header m-0 p-2' >";
 	       		 htmlAdd += " <i style='color: #2196f2;' class='fa fa-clock-o aligncenter' aria-hidden='true'></i> <h2 class='calendar-time-size mx-auto mb-0 aligncenter'>"+result.calendarData.friday[i].event_time+"</h2>";      		 
 	       		 htmlAdd += "<i class='fa fa-video-camera aligncenter' style='color: #999999;' aria-hidden='true'></i>";
 	       		 htmlAdd += "</div>";
 	       		 htmlAdd += "<h2 class='w-100 cal-event-name p-2  popover-dismiss' data-toggle='popover' data-trigger='hover' data-placement='top' data-content='"+result.calendarData.friday[i].course_name+"'>"+result.calendarData.friday[i].course_name.substr(0,21)+'...'+"</h2>";
 	       		 htmlAdd += "<h2 class='w-100 cal-event-batch p-2'>"+result.calendarData.friday[i].bg_name+"</h2>";
 	       		 htmlAdd += "<h2 class='w-100 cal-event-trainer p-2'>By "+result.calendarData.friday[i].trainer_name+"</h2>";
 	       		 htmlAdd += "</div>";
 	       		 htmlAdd += "</div>";
	  
            }
           htmlAdd += "</div>";
     	  htmlAdd += "<div class='row m-0 p-0 custom-scroll-holder' style='border-right: 1px solid #eee;border-left: 1px solid #eee; width: 163px;display: -webkit-inline-box; align-items: center;'>"; 
          if(result.calendarData.saturday.length > i){
        	  
        	  if(result.calendarData.saturday[i].status == 'TEACHING'){
    			  status = onGoing;
    		  }else if(result.calendarData.saturday[i].status == 'SCHEDULED'){
    			  status = Scheduled;
    		  }else if(result.calendarData.saturday[i].status == 'ASSESSMENT'){
    			  status = Scheduled;
    		  }else{
    			  status = Completed;
    		  }
        	  
        	  var eveDate = formatJavaDate(new Date(result.calendarData.saturday[0].eve_date));
       		  var bgColor = '';
       		  if(today == eveDate){
       			  bgColor = 'scheduler-calendar-event-bgcolor';
       			
       		  }else{
       			  bgColor = ''; 
       		  }
        	  htmlAdd += "<div class='custom-calendar-item-colums find_currentDate_child "+bgColor+"' data-currentDate='gbfgbf' style='width: 163px; border-left: 1px solid #eee;'>";
	       		 htmlAdd += "<div class='' style='border-top: 5px solid "+status+";justify-self: start; width: 147px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>";
	       		 htmlAdd += " <div class='row scheduler-calendar-event-header m-0 p-2' >";
	       		 htmlAdd += " <i style='color: #2196f2;' class='fa fa-clock-o aligncenter' aria-hidden='true'></i> <h2 class='calendar-time-size mx-auto mb-0 aligncenter'>"+result.calendarData.saturday[i].event_time+"</h2>";      		 
	       		 htmlAdd += "<i class='fa fa-video-camera aligncenter' style='color: #999999;' aria-hidden='true'></i>";
	       		 htmlAdd += "</div>";
	       		 htmlAdd += "<h2 class='w-100 cal-event-name p-2  popover-dismiss' data-toggle='popover' data-trigger='hover' data-placement='top' data-content='"+result.calendarData.saturday[i].course_name+"'>"+result.calendarData.saturday[i].course_name.substr(0,21)+'...'+"</h2>";
	       		 htmlAdd += "<h2 class='w-100 cal-event-batch p-2'>"+result.calendarData.saturday[i].bg_name+"</h2>";
	       		 htmlAdd += "<h2 class='w-100 cal-event-trainer p-2'>By "+result.calendarData.saturday[i].trainer_name+"</h2>";
	       		 htmlAdd += "</div>";
	       		 htmlAdd += "</div>";
	  
           }
          htmlAdd += "</div>";
    	  htmlAdd += "<div class='row m-0 p-0 custom-scroll-holder' style='border-right: 1px solid #eee;border-left: 1px solid #eee;width: 163px;display: -webkit-inline-box; align-items: center;'>"; 
          if(result.calendarData.sunday.length > i){
        	  
        	  if(result.calendarData.sunday[i].status == 'TEACHING'){
    			  status = onGoing;
    		  }else if(result.calendarData.sunday[i].status == 'SCHEDULED'){
    			  status = Scheduled;
    		  }else if(result.calendarData.sunday[i].status == 'ASSESSMENT'){
    			  status = Scheduled;
    		  }else{
    			  status = Completed;
    		  }
        	  
        	  var eveDate = formatJavaDate(new Date(result.calendarData.sunday[0].eve_date));
       		  var bgColor = '';
       		  if(today == eveDate){
       			  bgColor = 'scheduler-calendar-event-bgcolor';
       			
       		  }else{
       			  bgColor = ''; 
       		  }
        	  
        	     htmlAdd += "<div class='custom-calendar-item-colums find_currentDate_child "+bgColor+"' data-currentDate='gbfgbf' style='width: 163px; border-left: 1px solid #eee;'>";
	       		 htmlAdd += "<div class='' style='border-top: 5px solid "+status+";justify-self: start; width: 147px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>";
	       		 htmlAdd += " <div class='row scheduler-calendar-event-header m-0 p-2' >";
	       		 htmlAdd += " <i style='color: #2196f2;' class='fa fa-clock-o aligncenter' aria-hidden='true'></i> <h2 class='calendar-time-size mx-auto mb-0 aligncenter'>"+result.calendarData.sunday[i].event_time+"</h2>";      		 
	       		 htmlAdd += "<i class='fa fa-video-camera aligncenter' style='color: #999999;' aria-hidden='true'></i>";
	       		 htmlAdd += "</div>";
	       		 htmlAdd += "<h2 class='w-100 cal-event-name p-2  popover-dismiss' data-toggle='popover' data-trigger='hover' data-placement='top' data-content='"+result.calendarData.sunday[i].course_name+"'>"+result.calendarData.sunday[i].course_name.substr(0,21)+'...'+"</h2>";
	       		 htmlAdd += "<h2 class='w-100 cal-event-batch p-2'>"+result.calendarData.sunday[i].bg_name+"</h2>";
	       		 htmlAdd += "<h2 class='w-100 cal-event-trainer p-2'>By "+result.calendarData.sunday[i].trainer_name+"</h2>";
	       		 htmlAdd += "</div>";
	       		 htmlAdd += "</div>";
	  
          }
          htmlAdd += "</div>";  
         
          }
       		
          }else{
        	  htmlAdd += "<div class='card no-event-card w-100'><div class='card-block m-auto'><h1>No Event Scheduled for This Week</h1></div></div>";
          }
       		
       		  
       	
       		
       		
       		 
       	  $("#calendar_holder").empty();
      	$("#calendar_holder").append(htmlAdd); 
      	$('.popover-dismiss').popover();
       		  
       	  
       		  
       		  
       	  }
       	});
	}
	var session_type = $('#session-select').val();
	var course_id =  $('#role-select').val();
	var startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay()+1);
	var endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay()+7);
	var college_id = $('#session-select').attr('data-college_id');
	
	$('.calendar-date-size').attr('data-calStartDate',formatJavaDate(startDate));
	$('.calendar-date-size').attr('data-calEndDate',formatJavaDate(endDate));
	 getSchedulerData(session_type,course_id,formatJavaDate(startDate),formatJavaDate(endDate),college_id,'clearall');
	
}

function setupSchedulerMonthly(){
	var month = new Array();
	month[0] = "January";
	month[1] = "February";
	month[2] = "March";
	month[3] = "April";
	month[4] = "May";
	month[5] = "June";
	month[6] = "July";
	month[7] = "August";
	month[8] = "September";
	month[9] = "October";
	month[10] = "November";
	month[11] = "December";
	
	
	
	var firstDay = new Date(parseInt($('.calendar-date-size').attr('data-currentyear')), parseInt($('.calendar-date-size').attr('data-monthnos')), 1);
	var lastDay = new Date(parseInt($('.calendar-date-size').attr('data-currentyear')), parseInt($('.calendar-date-size').attr('data-monthnos')) + 1, 0);

	$('.fa-long-arrow-left.custom-arrow-style').click(function (){
		//alert('left wla');
		var monthnos = parseInt($('.calendar-date-size').attr('data-monthnos'));
		var remove_month =monthnos -1;
		var new_year = parseInt($('.calendar-date-size').attr('data-currentyear'));
		if(remove_month < 0){
			remove_month = 11;
			new_year = new_year-1;
			$('.calendar-date-size').attr('data-currentyear',new_year);
		}
		var new_month = month[remove_month];
		$('.calendar-date-size').attr('data-monthnos',remove_month);
		$('.calendar-date-size').html(new_month+' '+$('.calendar-date-size').attr('data-currentyear'));
		var firstDay = new Date(new_year, remove_month, 1);
		var lastDay = new Date(new_year, remove_month + 1, 0);
		var session_type = $('#session-select').val();
		var course_id =  $('#role-select').val();		
		var college_id = $('#session-select').attr('data-college_id');
		console.log(formatDateYear(firstDay) +' - '+ formatDateYear(lastDay) );
		$('.calendar-date-size').attr('data-calStartDate',formatJavaDate(firstDay));
		$('.calendar-date-size').attr('data-calEndDate',formatJavaDate(lastDay));
		 getSchedulerData(session_type,course_id,formatJavaDate(firstDay),formatJavaDate(lastDay),college_id,'clearall');
		 $('#calendar').fullCalendar('prev');
	});
	$('.fa-long-arrow-right.custom-arrow-style').click(function (){
		var monthnos = parseInt($('.calendar-date-size').attr('data-monthnos'));
		var add_month =monthnos +1;
		var new_year = parseInt($('.calendar-date-size').attr('data-currentyear'));
		if(add_month >=12){
			add_month = 12 - add_month;
			new_year = new_year+1;
			$('.calendar-date-size').attr('data-currentyear',new_year);
		}
		var new_month = month[add_month];
		$('.calendar-date-size').attr('data-monthnos',add_month);
		$('.calendar-date-size').html(new_month+' '+$('.calendar-date-size').attr('data-currentyear'));
		
		var firstDay = new Date(new_year, add_month, 1);
		var lastDay = new Date(new_year, add_month + 1, 0);

		console.log(formatDateYear(firstDay) +' - '+ formatDateYear(lastDay) );
		var session_type = $('#session-select').val();
		var course_id =  $('#role-select').val();
		
		var college_id = $('#session-select').attr('data-college_id');

		$('.calendar-date-size').attr('data-calStartDate',formatJavaDate(firstDay));
		$('.calendar-date-size').attr('data-calEndDate',formatJavaDate(lastDay));
		 getSchedulerData(session_type,course_id,formatJavaDate(firstDay),formatJavaDate(lastDay),college_id,'clearall');
		  $('#calendar').fullCalendar('next');
		
	});
	
	$('select#session-select').on('change', function(){
		   // alert( this.value );
		    
		    var session_type = $(this).val();
			var course_id =  $('#role-select').val();
			
			var startDate =	$('.calendar-date-size').attr('data-calStartDate');
			var endDate = $('.calendar-date-size').attr('data-calEndDate');
			var college_id = $(this).attr('data-college_id');
			 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'clearall');
		});
$('select#role-select').on('change', function(){
	
//	 alert( this.value );
	    var session_type = $('#session-select').val();
		var course_id =  $(this).val();
		var startDate =	$('.calendar-date-size').attr('data-calStartDate');
		var endDate = $('.calendar-date-size').attr('data-calEndDate');
		
		var college_id = $('#session-select').attr('data-college_id');
		
		 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'clearall');
		   
		});
$("a.green-border-dashboard").click(function() {
	
	//alert( 'clicked green' );
	var session_type = $('#session-select').val();
	var course_id =  $('#role-select').val();
	var startDate =	$('.calendar-date-size').attr('data-calStartDate');
	var endDate = $('.calendar-date-size').attr('data-calEndDate');
	
	var college_id = $('#session-select').attr('data-college_id');
	 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'ongoing');
	
});
$("a.blue-border-dashboard").click(function() {
	
//	alert( 'clicked blue' );
	var session_type = $('#session-select').val();
	var course_id =  $('#role-select').val();
	var startDate =	$('.calendar-date-size').attr('data-calStartDate');
	var endDate = $('.calendar-date-size').attr('data-calEndDate');
	
	var college_id = $('#session-select').attr('data-college_id');
	 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'scheduled');
});
$("a.red-border-dashboard").click(function() {
	
//	alert( 'clicked red' );
	var session_type = $('#session-select').val();
	var course_id =  $('#role-select').val();
	var startDate =	$('.calendar-date-size').attr('data-calStartDate');
	var endDate = $('.calendar-date-size').attr('data-calEndDate');
	
	var college_id = $('#session-select').attr('data-college_id');
	 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'completed');
});

$("a.default-border-dashboard").click(function() {
	
	//	alert( 'clicked red' );
		var session_type = $('#session-select').val();
		var course_id =  $('#role-select').val();
		var startDate =	$('.calendar-date-size').attr('data-calStartDate');
		var endDate = $('.calendar-date-size').attr('data-calEndDate');			
		var college_id = $('#session-select').attr('data-college_id');
		 getSchedulerData(session_type,course_id,startDate,endDate,college_id,'clearall');
	});

$('#daterange').daterangepicker().on('apply.daterangepicker', function(ev, picker) {
	 
     console.log(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
     var startDate = picker.startDate.format('yyyy-mm-dd');
     var endDate = picker.endDate.format('yyyy-mm-dd');
     var session_type = $('#session-select').val();
 	var course_id =  $('#role-select').val();
 	var college_id = $('#session-select').attr('data-college_id');
 	getSchedulerData(session_type,course_id,formatJavaDate(startDate),formatJavaDate(endDate),college_id,'clearall');
    
     
     
 });

function getSchedulerData(session_type,course_id,startDate,endDate,college_id,status){
	
	var url = 	$('#calendar').attr('data-url');
	url += 'scheduler/'+college_id+'/scheduler_month/startDate/'+startDate+'/endDate/'+endDate+'/sessionType/'+session_type+'/status/'+status+'/course_id/'+course_id+'';
	
	var htmlAdd = "";
	 $.ajax({
		  url: url,
		 type: 'GET',
		    async: true,
		   dataType: "json",
   	  success:function(result) {
   		  
   		  console.log(result);
   		
   		$('#calendar').fullCalendar('removeEventSources'); 
   		$('#calendar').fullCalendar( 'addEventSource', result.calendarData );
   		$('.fc-h-event').css('height','40px');
   		$('.fc-h-event').css('width','125px');
   		$('.fc-content').css('margin','4px');
   		 $('.fc-day-header').css('height','51px');
   			$('.fc-day-header').css('background-color','rgba(244, 244, 244, 0.99)');
   			$('.fc-day-header').css('border-style','none');
   			$('.fc-day-header').css('vertical-align','middle');
   			$('.fc-day-header >span').css('color','#999999');
   			$('.fc-day-header >span').css('font-size','14px');
   			$('.fc-day-header >span').css('font-weight','100');
   			$('.fc-body').css('background','#ffffff');
   			$('.fc-header-toolbar').css('background','#ffffff');
   		    $('.fc-header-toolbar').css('margin-bottom','0px'); 
          
   		  
   		}
   	});
}
var session_type = $('#session-select').val();
var course_id =  $('#role-select').val();
var college_id = $('#session-select').attr('data-college_id');
$('.calendar-date-size').attr('data-calStartDate',formatJavaDate(firstDay));
$('.calendar-date-size').attr('data-calEndDate',formatJavaDate(lastDay));

$('#calendar').fullCalendar({
		header:false,
		 columnFormat: 'dddd',
		dayNames:['Sunday', 'Monday', 'Tuesday', 'Wednesday','Thursday', 'Friday', 'Saturday'],
		 eventLimit: true, // for all non-agenda views
		    views: {
		        agenda: {
		            eventLimit: 3 // adjust to 6 only for agendaWeek/agendaDay
		        }
		    },
		    
		   
		    
			 eventRender: function(event, element) { 
		            element.find('.fc-title').append("<br/><p style='font-weight:100;font-size:10px'>" + event.description+"</p>"); 
		            element.find('.fc-time').hide();
		            element.find('.fc-title').css('font-size','12px');
		            element.find('.fc-title').css('font-weight','bold');
		            element.find('.fc-title').css('font-family','avenir-light');
		           
		          
		        
		            
		        }   			
	});




 getSchedulerData(session_type,course_id,formatJavaDate(firstDay),formatJavaDate(lastDay),college_id,'clearall');



}


function formatDate(date) {
	  var monthNames = [
	    "Jan", "Feb", "Mar",
	    "Apr", "May", "Jun", "Jul",
	    "Aug", "Sept", "Oct",
	    "Nov", "Dec"
	  ];

	  var day = date.getDate();
	  var monthIndex = date.getMonth();

	  return day + ' ' + monthNames[monthIndex] ;
	}



function formatJavaDate(date) {
	  var monthNames = [
	    "01", "02", "03",
	    "04", "05", "06", "07",
	    "08", "09", "10",
	    "11", "12"
	  ];

	  var day = date.getDate();
	  
	  if(parseInt(day)<10){
		  day='0' +day;
	  }
	  var monthIndex = date.getMonth();
	  var year = date.getFullYear();

	  return  year +'-'+ monthNames[monthIndex]+'-'+day;
	}

function formatDateYear(date) {
	var monthNames = [
	    "Jan", "Feb", "Mar",
	    "Apr", "May", "Jun", "Jul",
	    "Aug", "Sep", "Oct",
	    "Nov", "Dec"
	  ];

	  var day = date.getDate();
	  var monthIndex = date.getMonth();
	  var year = date.getFullYear();
	  if(parseInt(day)<10){
		  day='0' +day;
	  }
	  return day + '-' + monthNames[monthIndex] + '-' + year;
	}


function formatDay(date) {
	var dayNames = ["monday", "tuesday", "wednesday",
	    "thursday", "friday", "saturday", "sunday"];

	  var day = date.getDay();
	  
	  return dayNames[day-1];
	}