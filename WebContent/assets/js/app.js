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
