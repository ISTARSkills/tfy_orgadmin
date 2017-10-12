<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.talentify.admin.services.AdminUIServices"%>
<%@page import="com.talentify.admin.rest.pojo.EventsCard"%>
<%@page import="com.talentify.admin.rest.pojo.EventError"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.viksitpro.core.utilities.TrainerWorkflowStages"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="com.istarindia.android.pojo.*"%>
<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<body id="orgadmin_dashbard" ng-app="orgadmin_group" ng-controller="orgadmin_groupCtrl">
	<%
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";

		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());
		if (cp == null) {
			flag = true;
			request.setAttribute("msg", "User Does Not Have Permission To Access");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
		request.setAttribute("cp", cp);
		int orgId = (int) request.getSession().getAttribute("orgId");
		String admin_rest_url = (AppProperies.getProperty("admin_rest_url"));
	%>


	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg" >
		<div class="container">
			<div class="row justify-content-md-center custom-no-margins">


				<div class='col-6 custom-no-padding'>
					<h1>Sections</h1>
				</div>
				<div class='col-6 '>
					<div class="row mt-4">
						<div class="col-4">
							<div class="demo">
								<select ng-model="group_type">
									<option value="" selected>Choose Type</option>
									<option ng-repeat="value in groupsTypeFilter" value="{{value}}">{{value}}</option>
								</select>
							</div>
						</div>
						<div class="col-4">
							<div class="demo">

								<select ng-model="bg_groups" multiple>
									<option value=""> Choose Section</option>
									<option ng-repeat="value in groupsFilter" value="{{value.id}}" my-repeat-directive>{{value.name}}</option>

								</select>
							</div>
						</div>
						<div class="col-4">
							<div ng-init="fireEvent()"></div>
							<button type="button" class="btn btn-danger">Create Section</button>
						</div>
					</div>
				</div>



			</div>
		</div>
		<!--/row-->


		<div class="container">
			<div class="row group_holder">

				<div class='col-4 mb-3' ng-repeat="group in groups">
					<div class='card' style='height: 301px;'>
						<div class='card-header m-2' style='background-color: #ffffff;'>
							<div class='row'>
								<div class='col-8'>
									<h3 style='font-weight: bold; color: #eb384f !important;'>{{group[0]}}</h3>
								</div>
								<div class='col-4 my-auto'>
									<span class='badge badge-warning' style='float: right; color: white; font-size: 11px;'>{{group[1]}}</span>
								</div>
							</div>
						</div>
						<div class='card-block m-5'>
							<small class='text-muted' style="font-weight: bolder">Member</small>
							<h4>{{group[2]}}</h4>
							<small class='text-muted' style="font-weight: bolder">Skills</small>
							<p>
								<small ng-repeat="skill_list in group[3]" style="font-size: 12px !important;"> <i class='fa fa-circle text-muted' style='font-size: 9px; padding: 3px;' aria-hidden='true'></i>{{skill_list}}
								</small>

							</p>
						</div>
					</div>
				</div>
			</div>
		</div>



	</div>
	<!--/row-->

	<jsp:include page="/inc/foot.jsp"></jsp:include>


	<script>
		var app = angular.module("orgadmin_group", []);
		app.controller("orgadmin_groupCtrl",function($scope, $http, $timeout) {
							$http.get('http://192.168.1.15:8080/a/admin/group_list/283/groups').then(
											function(res) {

												$scope.groups = res.data.groupData;
												$scope.groupsTypeFilter = res.data.groupTypeFilter;
												$scope.groupsFilter = res.data.groupsFilter;

											});
							$scope.fireEvent = function() {
								$timeout(function() {
											$('.demo').dropdown({
											input : '<input type="text" maxLength="20" placeholder="Search">'
															});
										}, 0);

							};

						});
	</script>
</body>
</html>