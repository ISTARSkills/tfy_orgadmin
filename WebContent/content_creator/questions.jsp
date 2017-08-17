<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<style>
tr.row_selected {
	background: silver;
}

tr.selected, tr:hover.selected, .table-striped>tbody>tr:nth-of-type(odd).selected
	{
	background-color: rgba(26, 179, 148, 0.45) !important;
	background-color: rgba(18, 220, 179, 1) !important;
	color: #000 !important;
}

.select2-container, .select2-search__field, .select2-search {
	width: 100% !important;
}

.select2-dropdown {
	z-index: 4050 !important;
}

.dataTables_info {
	display: none !important;
}

.hidden-holder {
	display: none !important;
}

.show-holder {
	display: block !important;
}

.custom-modal {
	width: 90% !important;
}
</style>
<body class="top-navigation" id="question_list"
	data-helper='This page is used to list questions.'>
	<div id="wrapper">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg">
			<div class="row wrapper border-bottom white-bg page-heading"
				style="padding-left: 30px; padding-bottom: 13px;">
				<div class="col-lg-10">
					<h2>Questions Table</h2>
					<ol class="breadcrumb">
						<li><a href="index.html">Home</a></li>
						<li><a>Course Administration</a></li>
						<li class="active"><strong>Questions Table</strong></li>
					</ol>
				</div>
				<div class="col-lg-2">
					<button class="btn btn-outline btn-primary dim question-edit-popup"
						data-question_id="-3" type="button" style="margin-top: 4vh">
						<i class="fa fa-plus-circle"></i>
					</button>
				</div>
			</div>
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Skill Filter</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="dropdown-toggle" data-toggle="dropdown" href="#">
									</a>
								</div>
							</div>
							<div class="ibox-content" style="display: none;">
								<div class="form-group">
									<label class="font-normal">Select context skill</label> <select
										id="context_skill"
										data-placeholder="Choose a Context Skill..." class=""
										tabindex="-1">
										<option value="">Select</option>
									</select>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Questions Table</h5>
								<div class="ibox-tools">
									<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
									</a> <a class="dropdown-toggle" data-toggle="dropdown" href="#">
									</a>
								</div>
							</div>
							<div class="ibox-content">

								<!-- table start -->

								<table class="table table-bordered datatable_istar"
									id='question_list_table'
									data-url='../AssessmentEngineMasterController'>
									<thead>
										<tr>
											<th data-visisble='true'>#</th>
											<th data-visisble='true'>Question Text</th>
											<th data-visisble='true'>Question Type</th>
											<th data-visisble='true'>Difficulty Level</th>
											<th data-visisble='true'>action</th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table>

								<!-- table end -->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<!-- Mainly scripts -->
<jsp:include page="../inc/foot.jsp"></jsp:include>
<script type="text/javascript">
</script>