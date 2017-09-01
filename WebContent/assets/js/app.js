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
	case 'student_begin_skill':
		init_student_begin_skill_variables();
		init_student_begin_skill_function();
		break;
	case 'org_scheduler':
		setupScheduler();
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



function setupScheduler(){
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

	});
	$('.fa-long-arrow-right.custom-arrow-style').click(function (){
		//alert('right wla');
		 mondayOfWeek = new Date(mondayOfWeek.getFullYear(), mondayOfWeek.getMonth(), mondayOfWeek.getDate() - mondayOfWeek.getDay()+8);
		 sundayOfWeek = new Date(sundayOfWeek.getFullYear(), sundayOfWeek.getMonth(), sundayOfWeek.getDate() - sundayOfWeek.getDay()+7);
			$('.calendar-date-size').html(formatDate(mondayOfWeek)+' - '+formatDate(sundayOfWeek));

	});
	
	$('select#session-select').on('change', function()
			{
			    alert( this.value );
			});
	$('select#role-select').on('change', function()
			{
			    alert( this.value );
			});
	$("a.green-border").click(function() {
		alert( 'clicked green' );
	});
	$("a.blue-border").click(function() {
		alert( 'clicked blue' );
	});
	$("a.red-border").click(function() {
		alert( 'clicked red' );
	});
	
	 $('#daterange').daterangepicker().on('apply.daterangepicker', function(ev, picker) {
	        console.log(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
	    });
	
	$(".calendar-icon").click(function() {
		//$('#datetimepicker1').daterangepicker('show');
		//$('.show-calendar').show();
	});
	
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