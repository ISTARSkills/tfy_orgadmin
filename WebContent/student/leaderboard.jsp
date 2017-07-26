<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<style>
.img-small {
	width: 40%;
	margin-top: auto;
}

.img-medium {
	width: 50%;
	margin-top: auto;
}

.img-large {
	width: 60%;
	margin-top: auto;
}

.image-center1 {
	margin-top: 2%;
}

.image-center2 {
	margin-top: 3%;
}

.position-no {
	font-size: 14px;
	color: #ffffff;
	background-color: #23b6f9;
	padding: 6px 12px;
	position: absolute;
	bottom: 0;
	border-radius: 50%;
	padding-left: 7px;
	padding-right: 11px;
}

.content-border {
	border: none !important;
}

.feed-activity-list {
	padding-top: 0px !important;
}
</style>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
%>


<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" style="background: #ffffff;">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->


			<div class="row text-center font-normal p-xxs">
				<div class="col-xs-4 col-md-4 image-center1">
					<img
						src="http://cdn.talentify.in/users/4972/c442ad6b-362d-4770-b9fa-e6159ddb5b1c.jpg"
						class="img-circle img-medium"> <span class="position-no">
						#2 </span>
				</div>
				<div class="col-xs-4 col-md-4">
					<img
						src="http://cdn.talentify.in/users/4972/c442ad6b-362d-4770-b9fa-e6159ddb5b1c.jpg"
						class="img-circle img-large"> <span class="position-no">
						#1 </span>
				</div>
				<div class="col-xs-4 col-md-4 image-center2">
					<img
						src="http://cdn.talentify.in/users/4972/c442ad6b-362d-4770-b9fa-e6159ddb5b1c.jpg"
						class="img-circle img-small"> <span class="position-no">
						#3 </span>
				</div>
			</div>
			<br />
			<div class="row text-center">
				<div class="col-xs-4 col-md-4">akshay</div>
				<div class="col-xs-4 col-md-4">ajith</div>
				<div class="col-xs-4 col-md-4">vinay</div>
			</div>
			<div class="row text-center">
				<div class="col-xs-4 col-md-4">2 XP</div>
				<div class="col-xs-4 col-md-4">5 XP</div>
				<div class="col-xs-4 col-md-4">1 XP</div>
			</div>
			<hr>
			<div class="ibox float-e-margins">

				<div class="ibox-content content-border">

					<div>
						<div class="feed-activity-list">

							<% for(int i = 0;i<5;i++) {%>
							<div class="feed-element">
								<a href="#" class="pull-left"> <img alt="image"
									class="img-circle"
									style="width: 64px !important; height: 64px !important;"
									src="http://cdn.talentify.in/users/4972/c442ad6b-362d-4770-b9fa-e6159ddb5b1c.jpg">
								</a>
								<div class="media-body ">


									<div class="row">
										<div class="col-xs-4 col-md-4 m-t-md">
											<strong class=" m-l-md">Feroz</strong>
										</div>
										<div class="col-xs-4 col-md-4 m-t-md text-center">
											<strong><%=4+i%> th</strong>
										</div>
										<div class="col-xs-4 col-md-4 m-t-md text-center">
											<strong>0 XP</strong>
										</div>
									</div>
								</div>
							</div>
							<%} %>
						</div>



					</div>

				</div>
			</div>
			<!-- End Table -->

		</div>
	</div>



	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>


</body>

</html>
