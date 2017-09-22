
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<style>
.custom-list-plans {
	padding-left: 0px;
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

.custom-button-assign-user, .custom-button-assign-user:hover, .custom-button-assign-user:focus
	{
	width: 17vw;
	height: 7vh;
	background-color: rgb(221, 221, 221) !important;
	box-shadow: none;
	font-family: avenir-light;
	border: none;
	color: #000000;
	font-weight: bold;
	line-height: 2.3;
	font-size: 16px;
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
			</div>
		</div>
		<div class="container mt-5">
			<div class="card border-0">
				<h3 class="card-header p-5" style="font-family: avenir-light;font-weight: bold;font-size: 20px;background-color: #ffffff">ORDER CONFIRMATION</h3>
				<div class="card-block">
					<div class="card-body p-5">
						<h1 class="mt-0" style="font-family: avenir-light;font-weight: bold;font-size: 20px">Amount Paid: Rs. 4,00,000</h1>
						<div class="card w-75">
							<div class="card-header px-5 py-4" style="font-family: avenir-light;font-weight: bold;font-size: 16px;background-color: #ffffff">
								<div class="row m-0">
									<div class="col-md-4 pl-0">PLAN</div>
									<div class="col-md-4">PRICE</div>
									<div class="col-md-4">NO. OF LICENSES</div>
								</div>
							</div>
							<div class="card-block px-5 pt-4 pb-5" style="font-family: avenir-light;font-size: 16px;background-color: #ffffff">
								<div class="row m-0">
									<div class="col-md-4 pl-0">Talentify Pro</div>
									<div class="col-md-4">Rs. 300/mo</div>
									<div class="col-md-4">200</div>
								</div>
							</div>
						</div>
						<div class="row ml-0 mt-5">
							<a href="#" class="btn btn-secondary btn-lg custom-button-assign-user" role="button" aria-pressed="true">ASSIGN USERS</a>
							<a href="#" class="btn btn-secondary btn-lg custom-button-assign-user ml-4" role="button" aria-pressed="true">GENERATE BATCH CODE</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
	$(document).ready(function(){
		 
		
	});
	</script>
</body>
</html>