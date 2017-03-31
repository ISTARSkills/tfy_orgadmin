<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.orgadmin.utils.BatchGroupUtils"%>
<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="in.orgadmin.services.OrgadminCourseService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
	
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Portal | Report Dashboard</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css"
	rel="stylesheet">

<link href="<%=baseURL%>css/plugins/iCheck/custom.css" rel="stylesheet">



<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/codemirror.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/plugins/codemirror/ambiance.css"
	rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">

</head>

<body class="fixed-sidebar no-skin-config full-height-layout">
	<%
		int batch_group_id = Integer.parseInt(request.getParameter("batch_group_id"));
		int skill_id = Integer.parseInt(request.getParameter("skill_id"));
		System.out.println("skill_id---"+skill_id);
		BatchGroup b = new BatchGroupDAO().findById(batch_group_id);
		/**batch level changes*/
String sql="select FinalTable.tt,FinalTable.max_score, batch_group.name,  cast (FinalTable.total_score / FinalTable.total_user as integer) as perc  from (select cast (timestamp as date) as tt, batch_students.batch_group_id as batch_gp_id, max(score) as max_score ,  sum(report.score) as total_score, count(report.user_id) as total_user from skill_precentile, report, batch_students where skill_precentile.student_id =report.user_id and report.user_id = batch_students.student_id and batch_students.batch_group_id="+batch_group_id+" and cast(report.created_at as date) = cast (skill_precentile.timestamp as date) and skill_precentile.skill_id = "+skill_id+" and report.assessment_id in ( SELECT DISTINCT 				assessment. ID 			FROM 				skill_learning_obj_mapping, 				lesson, 				learning_objective_lesson, 				assessment 			WHERE 				skill_learning_obj_mapping.learning_objective_id = learning_objective_lesson.learning_objectiveid 			AND learning_objective_lesson.lessonid = lesson. ID 			AND lesson. ID = assessment.lesson_id 			AND skill_learning_obj_mapping.skill_id IN ( 				SELECT 					"+skill_id+" AS ID 				UNION 					( 						WITH RECURSIVE supplytree AS ( 							SELECT 								ID, 								skill_title, 								parent_skill 							FROM 								skill 							WHERE 								parent_skill = "+skill_id+" 							UNION ALL 								SELECT 									si. ID, 									si.skill_title, 									si.parent_skill 								FROM 									skill AS si 								INNER JOIN supplytree AS sp ON (si.parent_skill = sp. ID) 						) SELECT 							ID 						FROM 							supplytree 					) 			) ) group by batch_gp_id,tt order by batch_group_id, tt ) FinalTable,batch_group  where FinalTable.batch_gp_id = batch_group.id 	 order by batch_group.name";
System.out.println(sql);
		/***/
		
		DBUTILS util = new DBUTILS();

		List<HashMap<String, Object>> res = util.executeQuery(sql);
	%>
	

	
	<div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2><%=b.getName().toUpperCase()%></h2>
					<p><%=b.getOrganization().getName().toUpperCase()%></p>

				</div>
			</div>
			<div class="row white-bg dashboard-header" style="padding: 0px">

				<div class="col-sm-12">
					<div class="white-bg border-left">
						<div class="element-detail-box">
							<div class="tab-content">
						<div id="tab-2" class="tab-pane active">

									<div class="wrapper wrapper-content animated fadeInUp">

										<div class="ibox">
											<div class="ibox-title">
												<h5> Report associated with this Batch</h5>
												<div class="ibox-tools">
													<a class="collapse-link "> <i class="fa fa-chevron-up"></i>
													</a> <a class="close-link"> <i class="fa fa-times"></i>
													</a> 
												</div>

											</div>
											<div class="ibox-content" style="display:none">
												
												<div class="project-list">
													<table class="table table-hover">
														<tbody>
														<div class='row pie-progress-charts margin-bottom-60'>
	<div class='panel panel-sea margin-bottom-40'
		style=' margin: 10px; border: 3px solid #1ABC9C; margin: 0 10px;'>
		<div id='datatable_report_panel_body' class='panel-body' style="padding: 0px;"></div>
		<table
			class='table table-striped table-bordered display responsive dt-responsive  dataTable datatable_report'
			id='datatable_report_222' data-graph_type='datetime'
			data-graph_title='' data-graph_containter='report_container_222' style="display: none">
			<thead>
				<tr>
					<th style="max-width: 100px !important; word-wrap: break-word;">Date</th>
					<th style="max-width: 100px !important; word-wrap: break-word;">Max Score</th>
					<th style="max-width: 100px !important; word-wrap: break-word;">Average Score</th>
				</tr>
			</thead>
			<tbody id='datatable_report_222_body'>
				<%
					for (HashMap<String, Object> row : res) {
						Date timestamp = (Date) row.get("tt");
						/**batch level changes*/
						//int batch_percentile = (int) row.get("percentile_batch");
						int max_score = (int) row.get("max_score");
						int perc = (int) row.get("perc");
						/**batch level changes*/
				%>

				<tr id=534>
					<td style='max-width: 100px !important; word-wrap: break-word;'><%=timestamp%></td>
					<td style='max-width: 100px !important; word-wrap: break-word;'><%=max_score%></td>
					<td style='max-width: 100px !important; word-wrap: break-word;'><%=perc%></td>
				</tr>

				<%
					}
				%>
			</tbody>
		</table>
		
	</div>
</div>
																													
<div class="graph_container" id='report_container_222' >

</div>
<br/><br/><br/>
<div>
<p>
<%
String child_skill="WITH RECURSIVE supplytree AS (SELECT id, skill_title, parent_skill FROM skill WHERE parent_skill ="+skill_id+" UNION ALL SELECT si.id,si.skill_title, 	si.parent_skill FROM skill As si 	INNER JOIN supplytree AS sp 	ON (si.parent_skill = sp.id) ) SELECT id, skill_title FROM supplytree";

List<HashMap<String, Object>> child_skill_data = util.executeQuery(child_skill);
for(HashMap<String, Object> row: child_skill_data)
{
		int child_skill_id = (int)row.get("id");
		String skill_title = (String)row.get("skill_title");
%>
<a class="btn btn-primary btn-rounded" href="<%=baseURL%>orgadmin/reports/org_report.jsp?batch_group_id=<%=batch_group_id%>&skill_id=<%=child_skill_id%>" style="margin-bottom: 8px;"><%=skill_title %></a>
<%
}
%>
</p>
</div>




														</tbody>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
								
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
	<!-- Mainly scripts -->

	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI custom -->
	<script src="<%=baseURL%>js/jquery-ui.custom.min.js"></script>
 <script src="<%=baseURL%>js/highcharts-custom.js"></script>
	<!-- iCheck -->
	<script src="<%=baseURL%>js/plugins/iCheck/icheck.min.js"></script>

 	<script>
        $(document).ready(function(){
            $('.i-checks').iCheck({
                checkboxClass: 'icheckbox_square-green',
                //radioClass: 'iradio_square-green',
            });
        });
    </script>

	<script type="text/javascript">
		function handleGraphs() {
			try {
				var graph_title = $(this).data('graph_title');

				$('#report_container_222').highcharts({
					data : {
						table : 'datatable_report_222'
					},
					title : {
						text : ''
					},
					yAxis : {
						title : {
							text : ''
						},
						gridLineColor : 'transparent',
						labels : {
							enabled : false
						},

					},
					chart : {

						zoomType : 'x',

						// Edit chart spacing
						spacingBottom : 0,
						spacingTop : 10,
						spacingLeft : 0,
						spacingRight : 0,

						// Explicitly tell the width and height of a chart
						width : null,
						height : null,
						backgroundColor : 'transparent'

					},
					legend : {
						enabled : false
					},
					plotOptions : {
						line : {
							fillColor : {
								linearGradient : {
									x1 : 0,
									y1 : 0,
									x2 : 0,
									y2 : 1
								}
							},
							marker : {
								radius : 2
							},
							lineWidth : 4,
							states : {
								hover : {
									lineWidth : 1
								}
							},
							threshold : null
						}
					},
					xAxis : {
						lineWidth : 1,
						minorGridLineWidth : 1,
						lineColor : '#149098',
						labels : {
							enabled : true
						},
						gridLineColor : '#149098',

					},
					series : [ {
						type : 'spline',

					} ]

				});

				//Hide Table
				//$('.dataTables_wrapper').hide();

			} catch (err) {
				console.log(err);
			}
		}
	</script>
</body>
</html>