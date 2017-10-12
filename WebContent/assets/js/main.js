var body_id = document.getElementsByTagName("body")[0].id;

var app = angular.module(body_id, [ 'ngSanitize' ]);
var t2cPath = "http://192.168.1.9:8080/t2c/";
var cdnPath = "http://192.168.1.9:8080/";
var userId = 10490;
var complexObject;

function getTime() {
	var today = new Date();
	// var date =
	// today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
	var time = today.getHours() + ":" + today.getMinutes() + ":"
			+ today.getSeconds();
	return time;
}

app.controller(body_id + "Ctrl", function($scope, $http, $timeout, $location) {
	console.log('started---' + getTime());
	$scope.cdnPath = cdnPath;
	restClient($scope, $http, $timeout, $location);
});

function restClient($scope, $http, $timeout, $location) {
	$http.get(t2cPath + 'user/' + userId + '/complex').then(function(res) {
		$scope.studentProfile = res.data.studentProfile;
		$scope.tasks = res.data.tasks;
		$scope.courses = res.data.courses;
		$scope.notifications = res.data.notifications;
		complexObject = res.data;
		initControlSwitcher($scope, $timeout, $location);
		console.log('ended---' + getTime());
	});
}

function initControlSwitcher($scope, $timeout, $location) {
	switch (body_id) {
	case 'student_role':
		initStudentRole($scope, $location);
		break;

	case 'student_dashbard':
		initstudent_dashbard($scope, $timeout);
		break;
	default:
		break;
	}
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

	app.directive('dashbordTaskDirective', function() {
		return function(scope, element, attrs) {
			if (scope.$last) {
				$('.carousel').carousel();
			}

		};
	});

	$scope.fireEvent = function() {
		$timeout(function() {
			$('.popover-dismiss').popover();
		}, 1000);

	};
	$scope.fireEvent();
}

function initStudentRole($scope, $location) {
	$scope.gotoBeginSkill = function(courseID) {
		window.location = $location.$$protocol + "://" + $location.$$host + ":"
				+ $location.$$port + "/student/"
				+ './partials/begin_skill.jsp?course_id=' + courseID;
	};
}
