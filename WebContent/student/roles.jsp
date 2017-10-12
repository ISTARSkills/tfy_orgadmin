<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.viksitpro.user.service.StudentRolesService"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="student_role" ng-app="student_role"
	ng-controller="student_roleCtrl">
	<%
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";

				
		String t2c_path = (AppProperies.getProperty("t2c_path")) + "/t2c/";
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row">

				<h1 class='custom-dashboard-header'>My Courses</h1>


			</div>
		</div>

		<div class="container">
			<div class='row custom-margin-rolescard'>
				<div class='card-deck m-3' ng-repeat="course in courses">

					<div class='card custom-roles-cards m-0'
						ng-click="gotoBeginSkill(course.id)"
						data-course_id='{{course.id}}'>
						<img class='custom-roles-img' src='{{course.imageURL}}'
							alt='No Image Available'>
						<div class='card-block'>
							<h4 class=' custom-roles-subtitle'>{{course.category}}</h4>
							<h1 class='card-title custom-roles-titletext'>{{course.name}}</h1>
							<h4 class='custom-roles-progress'>{{course.message}}</h4>
						</div>
						<div class='progress custom-progressbar'>
							<div class='progress-bar ' role='progressbar'
								style='width: "{{course.progress}}"%'
								aria-valuenow='{{course.progress}}' aria-valuemin='0'
								aria-valuemax='100'></div>
						</div>
					</div>

				</div>
			</div>
		</div>


	</div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>


	<%-- <script>
		var app = angular.module("student_role", []);
		app.controller("student_roleCtrl",function($scope, $http, $timeout,$location) {
			$http.get('<%=t2c_path%>user/<%=user.getId()%>/complex').then(
					function(res) {

						$scope.courses = res.data.courses;

					});

			$scope.gotoBeginSkill = function(courseID) {
				window.location  = $location.$$protocol+"://"+$location.$$host+":"+$location.$$port+"/student/"+'./partials/begin_skill.jsp?course_id='+ courseID;
			};

		});
	</script> --%>


	<%-- <script>
		$(document).ready(function() {
			
			$('.custom-roles-cards').click(function(){
				
				var course_id = $(this).attr("data-course_id");
				
				if(course_id !='0'){
				
				 window.location.href= '<%=baseURL%>student/partials/begin_skill.jsp?course_id='+ course_id;

												}
											});
						});
	</script> --%>
</body>
</html>