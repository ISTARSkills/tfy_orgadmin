var body_id = document.getElementsByTagName("body")[0].id;
var bodySpinner = "<div ng-if='rendered' id='page-loader' class='fade in'><span class='spinner'></span></div>";
$('body').prepend(bodySpinner);
var t2cPath = $('#talentify_logo_holder').data('t2c') + '/t2c/';
var cdnPath = $('#talentify_logo_holder').data('cdn');
var userId = $('#talentify_logo_holder').data('user');
var complexObject;

var app = angular.module(body_id, [ 'ngSanitize', 'elif' ]);

function getTime() {
	var today = new Date();
	var time = today.getHours() + ":" + today.getMinutes() + ":"
			+ today.getSeconds();
	return time;
}

function getUrlParameter(param, dummyPath) {
	var sPageURL = dummyPath || window.location.search.substring(1), sURLVariables = sPageURL
			.split(/[&||?]/), res;

	for (var i = 0; i < sURLVariables.length; i += 1) {
		var paramName = sURLVariables[i], sParameterName = (paramName || '')
				.split('=');

		if (sParameterName[0] === param) {
			res = sParameterName[1];
		}
	}

	return res;
}

app.controller(body_id + "Ctrl", function($scope, $http, $timeout, $location) {
	console.log('started---' + getTime());
	$scope.cdnPath = cdnPath;
	$scope.userId=userId;
	$scope.rendered = true;
	restClient($scope, $http, $timeout, $location);
});
setupAllDirectives();

function restClient($scope, $http, $timeout, $location) {
	$http.get(t2cPath + 'user/' + userId + '/complex').then(function(res) {
		$scope.studentProfile = res.data.studentProfile;
		$scope.tasks = res.data.tasks;
		$scope.courses = res.data.courses;
		$scope.notifications = res.data.notifications;
		complexObject = res.data;
		initControlSwitcher($scope, $timeout, $location);
		console.log('ended---' + getTime());
		$scope.rendered = false;
	});
}

function initControlSwitcher($scope, $timeout, $location) {
	switch (body_id) {
	case 'student_role':
		initStudentRole($scope, $location);
		initMenuLabel('courses');
		break;
	case 'student_dashbard':
		initstudent_dashbard($scope, $timeout);
		initMenuLabel('dashboard');
		break;
	case 'student_begin_skill':
		initstudent_begin_skill($scope, $timeout, $location);
		initMenuLabel('courses');
		break;
	case 'student_skill_profile':
		initstudent_skill_profile($scope, $timeout);
		initMenuLabel('skillprofile');
		break
	default:
		break;
	}
}

function initMenuLabel(labelId){
	$('#'+labelId).parent().addClass('active');
}

function initstudent_dashbard($scope, $timeout) {
	var todayTaskCount = 0;
	var todayTaskCompletedCount = 0;

	var currentdate = new Date().setHours(0, 0, 0, 0);
	var todayIncompletedTasks = [];
	var todayCompletedTasks = [];

	for (i = 0; i < complexObject.tasks.length; i++) {

		var task = complexObject.tasks[i];
		var taskDate = new Date(task.date).setHours(0, 0, 0, 0);
		if (currentdate == taskDate && task.status != 'COMPLETED') {
			todayIncompletedTasks.push(task);
		}

		if (currentdate == taskDate) {
			todayTaskCount++;
		}

		if ((currentdate == taskDate && task.status == 'COMPLETED')) {
			todayCompletedTasks.push(task);
			todayTaskCompletedCount++;
		}

		if (complexObject.tasks[i].status == 'COMPLETED'
				&& (task.itemType == 'ASSESSMENT'
						|| task.itemType == 'LESSON_PRESENTATION' || task.itemType == 'CUSTOM_TASK')
				&& (task.completedDate != undefined && (new Date(
						task.completedDate).setHours(0, 0, 0, 0) == currentdate))) {
			todayCompletedTasks.push(task);
			todayTaskCompletedCount++;
		}
	}

	for (i = 0; i < complexObject.tasks.length; i++) {
		var task = complexObject.tasks[i];
		var taskDate = new Date(task.date).setHours(0, 0, 0, 0);
		if (taskDate <= currentdate) {
			if (complexObject.tasks[i].status != 'COMPLETED'
					&& (task.itemType == 'ASSESSMENT'
							|| task.itemType == 'LESSON_PRESENTATION' || task.itemType == 'CUSTOM_TASK')) {
				todayIncompletedTasks.push(task);
				todayTaskCount++;
			}
		}
	}

	var chunk_size = 3;
	$scope.todayCompletedTasks = todayCompletedTasks;
	$scope.incompletedTasks = todayIncompletedTasks.map(
			function(e, i) {
				return i % chunk_size === 0 ? todayIncompletedTasks.slice(i, i
						+ chunk_size) : null;
			}).filter(function(e) {
		return e;
	});

	$scope.completed = todayTaskCompletedCount + " of " + todayTaskCount
			+ " Tasks Completed";

	$scope.m_names = [ "January", "February", "March", "April", "May", "June",
			"July", "August", "September", "October", "November", "December" ];
	$scope.currentMonth = $scope.m_names[new Date().getMonth()];
	setupUserCalendar($scope, new Date().getMonth());

	$scope.monthChange = function($index) {
		$scope.currentMonth = $scope.m_names[$index];
		setupUserCalendar($scope, $index);
	};

	$scope.fireEvent = function() {
		$timeout(function() {
			$('.popover-dismiss').popover();
		}, 1000);

	};
	$scope.fireEvent();
}

function setupUserCalendar($scope, monthIndex) {
	if (complexObject.events != undefined) {
		var date = new Date(2017, monthIndex, 1);
		var days = [];
		while (date.getMonth() === monthIndex) {
			days.push(new Date(date));
			date.setDate(date.getDate() + 1);
		}
		$scope.map_events = {};
		$scope.currentMonthDates = [];
		$scope.formatMessage = function(name) {
			var data = name.replace(
					'A class has been scheduled for the course', '');
			return data;
		};

		$scope.startEndTime = function(time) {
			return new Date(time);
		};

		for (var i = 1; i < days.length; i++) {
			var currentDate = new Date(days[i]).setHours(0, 0, 0, 0);
			for (var j = 0; j < complexObject.events.length; j++) {
				var event = complexObject.events[j];
				var eventDate = new Date(event.startDate).setHours(0, 0, 0, 0);
				if (currentDate == eventDate) {
					if ($scope.map_events.hasOwnProperty(currentDate)) {
						$scope.map_events[currentDate].push(event);
					} else {
						var eventList = [];
						eventList.push(event);
						$scope.map_events[currentDate] = eventList;
						$scope.currentMonthDates.push(currentDate);
					}
				}
			}
		}
	}

	$scope.todayDate = function(day) {
		var style = "";
		if (new Date(day).setHours(0, 0, 0, 0) == new Date().setHours(0, 0, 0,
				0)) {
			style = "{'background':'rgba(33, 150, 242, 0.04)'}"
		}
		return style;
	};
}

function initStudentRole($scope, $location) {
	$scope.gotoBeginSkill = function(courseID) {
		window.location = $location.$$protocol + "://" + $location.$$host + ":"
				+ $location.$$port + "/student/"
				+ './partials/begin_skill.jsp?course_id=' + courseID;
	};
}

function initstudent_skill_profile($scope, $timeout) {
	var courseObject = $scope.courses;
	$.fn.extend({
		treed : function(o) {

			var openedClass = 'glyphicon-minus-sign';
			var closedClass = 'glyphicon-plus-sign';

			if (typeof o != 'undefined') {
				if (typeof o.openedClass != 'undefined') {
					openedClass = o.openedClass;
				}
				if (typeof o.closedClass != 'undefined') {
					closedClass = o.closedClass;
				}
			}
			;

			// initialize each of the top levels
			var tree = $(this);
			tree.addClass("tree");
			tree.find('li').has("ul").each(
					function() {
						var branch = $(this); // li with children ul
						branch.prepend("<i class='indicator glyphicon "
								+ closedClass + "'></i>");
						branch.addClass('branch');
						branch.on('click', function(e) {
							if (this == e.target) {
								var icon = $(this).children('i:first');
								icon.toggleClass(openedClass + " "
										+ closedClass);
								$(this).children().children().toggle();
							}
						})
						branch.children().children().toggle();
					});
			// fire event from the dynamically added icon
			tree.find('.branch .indicator').each(function() {
				$(this).on('click', function() {
					$(this).closest('li').click();
				});
			});
			// fire event to open branch if the li contains an anchor instead of
			// text
			tree.find('.branch>a').each(function() {
				$(this).on('click', function(e) {
					$(this).closest('li').click();
					e.preventDefault();
				});
			});
			// fire event to open branch if the li contains a button instead of
			// text
			tree.find('.branch>button').each(function() {
				$(this).on('click', function(e) {
					$(this).closest('li').click();
					e.preventDefault();
				});
			});
		}
	});
	$scope.skillIndex=0;
	$scope.skillFunction = function(index) {
		$scope.skillIndex = index;
		$scope.courses = courseObject;
		$scope.skills = courseObject[index].skillObjectives;
	};

	if (courseObject.length != 0) {
		$scope.skillFunction(0);
	}
	
	$('#uploadfile').change(function() {
		var form = $('#fileUploadForm')[0];
		var data = new FormData(form);
		var upload_file = $('#uploadfile').val();
		var file_ext = $('#uploadfile').val().split('.')[1];
		var servlet = "/UserMediaUploadController";

		if (upload_file != '') {
			$.ajax({
				type : "POST",
				enctype : 'multipart/form-data',
				url : servlet,
				data : data,
				processData : false,
				contentType : false,
				cache : false,
				timeout : 600000,
				success : function(data) {

					var ddd = data;
					$('.custom-skill-profile-img').attr("src", ddd);

				},
				error : function(e) {
					alert('Please Retry Again');
				}
			});
		}

	});

	$("#btnfile").click(function() {
		$("#uploadfile").click();
		return false;
	});

}

function setupAllDirectives() {

	app.directive('studentSkillSetup', function() {
		return function(scope, element, attrs) {
			if (scope.$last) {
				setTimeout(function(){
					$('#tree1').treed();					
				},1000);

			}
		};
	});

	app.directive('dashbordTaskDirective', function() {
		return function(scope, element, attrs) {
			if (scope.$last) {
				$('.carousel').carousel();
				setTimeout(function(){
					$('.start-assessment-button').unbind().on('click',function(){
						var base=window.location.origin;
						var url=base+$(this).data('url');
						window.open(url,'', 'fullscreen=yes, scrollbars=auto');
						
					});					
				},1000);
				
			}
		};
	});

	app.directive('studentBeginSkillSetup', function() {
		return function(scope, element, attrs) {
			if (scope.$last) {
				$('.collapse').collapse();
				$('.custom-beginskill-collapsed-img').click(function() {
					if ($(this).attr("src") == '/assets/images/expanded.png') {
						$(this).attr("src", "/assets/images/collapsed.png");
					} else {
						$(this).attr("src", "/assets/images/expanded.png");
					}
				});
			}
		};
	});

}

function initstudent_begin_skill($scope, $timeout, $location) {
	$scope.roundNumber = function(i) {
		return Math.round(i);
	}
	$scope.course_id = getUrlParameter('course_id');
	if (complexObject.courses != undefined) {
		$scope.course = {};
		$scope.iteration = [ 0, 1, 2 ];
		for (var i = 0; i < complexObject.courses.length; i++) {
			if (complexObject.courses[i].id == parseInt($scope.course_id)) {
				$scope.course = complexObject.courses[i];
			}
		}
	}

	$scope.checkIsCompleted = function(session) {
		var isCompleted = true;
		if (session && session.lessons!=undefined && session.lessons.length!=0) {
			for(var i=0;i<session.lessons.length;i++){
				var lesson=session.lessons[i];
				if(lesson.status!='COMPLETED'){
					isCompleted=false;
				}
			}
		}
		return isCompleted;
	};
}
