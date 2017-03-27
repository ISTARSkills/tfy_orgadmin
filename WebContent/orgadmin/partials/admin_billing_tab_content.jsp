<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	String baseURL = (String) request.getAttribute("base_url");
%>
<div class="ibox border-left-right border-top-bottom b-r-md">
	<h3 class="m-l-sm">
		<strong>Your Subscriptions</strong>
	</h3>
	<div class="row">
		<div class="col-lg-4 text-right">
			<p>
				<span><strong>Payment Plan: </strong></span><br /> <span><strong>Users:
				</strong></span><br /> <span><strong>Cost: </strong></span><br /> <span><strong>Estimated
						Monthly Bill: </strong></span>
			</p>
		</div>
		<div class="col-lg-8">
			<p>
				<span>Flexible</span><br /> <span>158</span><br /> <span>Rs.
					120 per user</span><br /> <span>Rs. 18000</span>
			</p>
		</div>
	</div>
</div>

<div class="ibox border-left-right border-top-bottom b-r-md">
	<h3 class="m-l-sm">
		<strong>Your Balance <i class="fa fa-rupee"></i> 12,543
		</strong>
	</h3>
	<br />
	<p class="m-l-sm">
		Your last payment was on Jan 1 for <i class="fa fa-rupee"></i> 19,543
	</p>
</div>

<div class="row">
	<div class="col-lg-6">
		<div class="ibox border-left-right border-top-bottom b-r-md">
			<h3 class="m-l-sm">
				<strong>Transactions</strong>
			</h3>
			<div class="row">
				<div class="col-lg-8 m-l-sm text-left">
					<p>
						<span>Jan 1-29, 2017</span><br /> <span>Dec 1-31, 2016</span><br />
						<span>Nov 1-30, 2016</span>
					</p>
				</div>
				<div class="col-lg-3 text-center">
					<p>
						<span><i class="fa fa-rupee"></i> 19,543</span><br /> <span><i
							class="fa fa-rupee"></i> 19,543</span><br /> <span><i
							class="fa fa-rupee"></i> 19,543</span>
					</p>
				</div>
			</div>
			<button type="button" class="btn btn-default dim m-l-sm m-b-sm">View
				Transactions</button>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="ibox border-left-right border-top-bottom b-r-md">
			<h3 class="m-l-sm">
				<strong>How you pay</strong>
			</h3>
			<p class="m-l-sm">
				<span><i class="fa fa-cc-mastercard text-warning"></i> Master
					card ****7541</span><br /> <span>Expires 10/19 </span><br />
			</p>
			<button type="button" class="btn btn-default dim m-l-sm m-b-sm">Manage
				Payment Methods</button>
		</div>
	</div>
</div>