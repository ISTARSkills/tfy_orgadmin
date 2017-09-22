
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<style>
.custom-list-plans {
	padding-left: 5px;
}

.custom-list-plans li {
	display: block;
	margin-bottom: 8px;
	font-family: avenir-light;
}

.custom-list-plans li::before {
	content: "\002022";
	color: #ececec;
	padding-right: 15px;
	font-size: 25px;
	vertical-align: bottom;
	line-height: 0.8;
}

.custom-button-link, .custom-button-link:hover, .custom-button-link:focus
	{
	width: 17vw;
	height: 7vh;
	background-color: #ececec !important;
	box-shadow: none;
	font-family: avenir-light;
	border: none;
	color: #000000;
	font-weight: bold;
	line-height: 2.3;
	font-size: 16px;
	position: absolute;
	bottom: 5%;
	right: 15%;
}
</style>
<body>
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
		
		int orgId = (int)request.getSession().getAttribute("orgId");
		System.out.println(orgId);
				
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row custom-no-margins">
				<h1>Plans</h1>
			</div>
		</div>
		<div class="container">
			<div class="row m-0">
				<div class="col-md-4 pl-0">
					<div class="card" style="height: 75vh; border: none;">
					<div class="head text-center h-25 p-4" style="margin-top: 40px;">
								<h1 style="font-size: 18px;font-weight: bold;font-family: avenir-light;">BASIC</h1>
								<h1 style="font-size: 28px;font-family: avenir-light;font-weight: 900;margin-top: 30px;"><strong>Rs. 300 /MO</strong></h1>
							</div>
							
							<div style="border: 1.2px solid #eeeeee; width: 100%;"></div>
						<div class="card-block h-75 p-4">
							<ul class="custom-list-plans">
								<li>Role Aligned E-Learning</li>
								<li>Learning Analytics</li>
								<li>Private Content Hosting</li>
								<li>Testing</li>
							</ul>
							<!-- <div style="width: 70%;height: 9%;text-align: center;position: absolute;bottom: 5%;left: 15%;background-color: #ececec;"><h2>BUY</h2></div> -->
							<a href="../billing/cart.jsp" class="btn btn-secondary btn-lg custom-button-link" role="button" aria-pressed="true">BUY</a>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card" style="height: 75vh; border: none;">
					<div class="head text-center h-25 p-4" style="margin-top: 40px;">
								<h1 style="font-size: 18px;font-weight: bold;font-family: avenir-light;">PRO</h1>
								<h1 style="font-size: 28px;font-family: avenir-light;font-weight: 900;margin-top: 30px;"><strong>Rs. 500 /MO</strong></h1>
							</div>
							
							<div style="border: 1.2px solid #eeeeee; width: 100%;"></div>
						<div class="card-block h-75 p-4">
							<ul class="custom-list-plans">
								<li>Role Aligned E-Learning</li>
								<li>Learning Analytics</li>
								<li>Private Content Hosting</li>
								<li>Testing</li>
								<li>Personal Coaching</li>
								<li>Recruitment Center</li>
								<li>Assessment Center</li>
							</ul>
							<!-- <div style="width: 70%;height: 9%;position: absolute;bottom: 5%;left: 15%;background-color: #ececec;">BUY</div> -->
							<a href="#" class="btn btn-secondary btn-lg custom-button-link" role="button" aria-pressed="true">BUY</a>
						</div>
					</div>
				</div>
				<div class="col-md-4 pr-0">
					<div class="card" style="height: 75vh; border: none;">
					<div class="head text-center h-25 p-4" style="margin-top: 40px;">
								<h1 style="font-size: 18px;font-weight: bold;font-family: avenir-light;">ENTERPRISE</h1>
							</div>
							
							<div class="mt-3" style="border: 1.2px solid #eeeeee; width: 100%;"></div>
						<div class="card-block h-75 p-4">
							<ul class="custom-list-plans">
								<li>Role Aligned E-Learning</li>
								<li>Learning Analytics</li>
								<li>Private Content Hosting</li>
								<li>Testing</li>
								<li>Personal Coaching</li>
								<li>Recruitment Center</li>
								<li>Assessment Center</li>
								<li>Talentify-U</li>
								<li>On Site Training</li>
								<!-- <div style="width: 70%;height: 9%;position: absolute;bottom: 5%;left: 15%;background-color: #ececec;">CONTACT SALES</div> -->
								<a href="#" class="btn btn-secondary btn-lg custom-button-link" role="button" aria-pressed="true">CONTACT SALES</a>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</div>
		
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
	
	</script>
</body>
</html>