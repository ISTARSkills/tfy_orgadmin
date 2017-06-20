<%
String header=request.getParameter("header");
String title = request.getParameter("title");
String imageUrl = request.getParameter("image_url");
String taskDescription = request.getParameter("description");
%>
<div class='col-md-3 '>
	<div class='ibox'>
		<div class='ibox-content product-box h-370'>
			<h6 class='p-xxs font-normal bg-muted m-l-xs'>task.getHeader()</h6>
			<h3 class='p-xxs m-l-xs'>task.getTitle()</h3>
			<div class='product-imitation' style='padding: 0px !important; background: transparent;'>
				<img alt='' class='img-circle assessment-circle-img' src='
task.getImageURL()
'>
			</div>
			<div class='product-desc'>
				<div class='medium m-t-xs'>Many desktop publishing packages and web page editors now.Many desktop publishing packages and web page editors now.</div>
				<br />
				<div class='row text-center font-bold medium'>
					<div class='col-xs-4 col-md-4'>task.getNumberOfQuestions()</div>
					<div class='col-xs-4 col-md-4'>task.getItemPoints()</div>
					<div class='col-xs-4 col-md-4'>task.getDuration()</div>
				</div>
				<div class='row text-center font-normal bg-muted small'>
					<div class='col-xs-4 col-md-4'>Questions</div>
					<div class='col-xs-4 col-md-4'>Experience</div>
					<div class='col-xs-4 col-md-4'>Time Limit</div>
				</div>
			</div>
		</div>
		<div class='m-t text-center button-top'>
			<a class='btn btn-rounded' href='#'>START ASSESSMENT</a>
		</div>
	</div>
</div>