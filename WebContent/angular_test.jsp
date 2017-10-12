<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app="App">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<style type="text/css">
#slides_control > div{
  height: 200px;
}
img{
  margin:auto;
  width: 400px;
}
#slides_control {
  position:absolute;
  width: 400px;
  left:50%;
  top:20px;
 margin-left:-200px;
}

</style>
</head>



<body>



<div ng-app="app">
  <div ng-controller="CarouselDemoCtrl" id="slides_control">
    <div>
      <carousel interval="myInterval">
        <slide ng-repeat="task in tasks" active="task.active">
          <img ng-src="{{task.imageURL}}">
          <div class="carousel-caption">
            <h4>Slide {{$index+1}}</h4>
             <h4 class="card-title">{{task.title}}</h4>
			<h6 class="card-subtitle mb-2 text-muted">{{task.header}}</h6>
          </div>
        </slide>
      </carousel>
    </div>
  </div>
</div>  


	<!-- <h1>{{complexs.studentProfile.email}}</h1>
	-
	<h2>{{complexs.studentProfile.firstName}}</h2>

	<div ng-app="app">
  <div ng-controller="complexObj" id="slides_control">
    <div>
      <carousel interval="3000">
        <slide ng-repeat="task in tasks" active="task.active">
          <img ng-src="{{task.imageURL}}">
          <div class="carousel-caption">
            <h4>Slide {{$index+1}}</h4>
            <h4 class="card-title">{{task.title}}</h4>
			<h6 class="card-subtitle mb-2 text-muted">{{task.header}}</h6>
          </div>
        </slide>
      </carousel>
    </div>
  </div>
</div> -->
    
    <!-- <div class="row">

		 <div class="col-3" ng-repeat="task in tasks">
		 <input type="hidden" value='{{task.status}}' ng-value="key" />
			<div  ng-if="key == 'COMPLETED'">
				<div class="card" style="width: 20rem;">
					<img class="card-img-top" src="{{task.imageURL}}" alt="Card image cap">
					<div class="card-block">
						<h4 class="card-title">{{task.title}}</h4>
						<h6 class="card-subtitle mb-2 text-muted">{{task.header}}</h6>
						 <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                         <a href="#" class="btn btn-primary">Go somewhere</a>
					</div>
				</div>
			</div>
		</div> 
	</div> -->



</body>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/angularjs/1.0.8/angular.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.10.0/ui-bootstrap-tpls.min.js"></script>
<script type="text/javascript">

 var App = angular.module('App', ['ui.bootstrap']);

App.controller('CarouselDemoCtrl', function($scope, $http) {
  $http.get('http://localhost:8080/t2c/user/449/complex')
       .then(function(res){
          $scope.complexs = res.data; 
          $scope.tasks = res.data.tasks;
         
         
        });
  CarouselDemoCtrl($scope); 
     
});  



angular.module('app', ['ui.bootstrap']);
function CarouselDemoCtrl($scope){
  $scope.myInterval = 3000;
}

</script>
</html>