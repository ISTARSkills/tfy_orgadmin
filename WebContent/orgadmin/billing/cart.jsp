
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

.custom-button-link, .custom-button-link:hover, .custom-button-link:focus
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
	position: absolute;
	bottom: 15%;
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
				<h1>Cart</h1>
			</div>
		</div>
		<div class="container">
			<div class="row m-0">
				<div class="col-md-8 pl-0 pr-3">
					<div class="card p-1">
						<div class="card-block">
							<div class="card-body">
								<div class="row m-0">
									<div class="col-md-7">
										<h1 style="font-family: avenir-light;font-weight: bold;font-size: 22px">TALENTIFY BASIC PLAN</h1>
										<h3 class="mb-5" style="font-family: avenir-light;"><strong>Rs. 300/mo</strong></h3>
										<ul class="custom-list-plans">
											<li>Role Aligned E-Learning</li>
											<li>Learning Analytics</li>
											<li>Private Content Hosting</li>
											<li>Testing</li>
										</ul>
									</div>
									<div class="col-md-5">
										<h3 style="font-family: avenir-light;font-weight: bold;" class="mt-4">How many licenses do you want?</h3>
										<div class="row input-group mt-4 ml-0" style="display: flex; width: 12vw;">
											<span class="input-group-btn mr-3">
												<button class="btn btn-white btn-minuse border-0" type="button" style="border-radius: 0px !important;"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button>
											</span> <input type="text" style="font-size: 16px;font-family: avenir-light;"
												class="form-control text-center"maxlength="3" value="0"> 
												<span class="input-group-btn ml-3">
												<button class="btn btn-red btn-pluss border-0" type="button" style="border-radius: 0px !important;"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
											</span>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>	
				</div>
				
				<div class="col-md-4 pr-0 pl-3">
					<div class="card p-1" style="height: 34vh;">
						<div class="card-block">
							<div class="card-body p-5">
								<h1 class="text-muted mt-0" style="font-family: avenir-light;font-weight: bold;font-size: 22px;">TOTAL</h1>
								<h1 style="font-family: avenir-light;font-weight: bold;font-size: 24px;">Rs. 4,00,000</h1>
							</div>
							<a href="./order_confirmation.jsp" class="btn btn-secondary btn-lg custom-button-link" role="button" aria-pressed="true">CHECKOUT</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
	$(document).ready(function(){
		$('.btn-minuse').on('click', function(){
			$(this).parent().siblings('input').val(parseInt($(this).parent().siblings('input').val()) - 1)
		})

		$('.btn-pluss').on('click', function(){
			$(this).parent().siblings('input').val(parseInt($(this).parent().siblings('input').val()) + 1)
		})
		    
		
	});
	</script>
</body>
</html>