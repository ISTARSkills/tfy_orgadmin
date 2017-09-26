<%@page import="com.viksitprodummy.SumanthDummyServices"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="com.talentify.admin.rest.pojo.AdminRoleThumb"%>
<%@page import="java.util.List"%>
<%@page import="com.talentify.admin.rest.pojo.AdminGroup"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.talentify.admin.rest.client.AdminRestClient"%>
<%@page import="java.util.Random"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<%@page import="com.istarindia.android.pojo.*"%>

<%@page import="com.viksitpro.user.service.*"%>

<jsp:include page="/inc/head.jsp"></jsp:include>
<style>
.Wizard {
	color: #fd6d81;
}

.Master {
	color: #7295fd;
}

.Apprentice {
	color: #30beef;
}

.Rookie {
	color: #bae88a;
}
</style>
<body id='orgadmin_individual_groups_report'>

	<%
		boolean flag = false;
	    int course_id =0;
 
		String url = request.getRequestURL().toString();

		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())

				+ request.getContextPath() + "/";

		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		if(request.getParameter("course_id")!=null){
			course_id = Integer.parseInt(request.getParameter("course_id"));
		}

		RestClient rc = new RestClient();

		ComplexObject cp = rc.getComplexObject(user.getId());

		if (cp == null) {

			flag = true;

			request.setAttribute("msg", "User Does Not Have Permission To Access");

			request.getRequestDispatcher("/login.jsp").forward(request, response);

		}

		request.setAttribute("cp", cp);

		int orgId = (int) request.getSession().getAttribute("orgId");
		System.out.println(orgId);
		SumanthDummyServices dummyService = new SumanthDummyServices();
	%>

	<jsp:include page="/inc/navbar.jsp"></jsp:include>



	<div class="jumbotron gray-bg">
		<div class="container">
			<div class="row ml-0">
				<a class='col-1 my-auto custom-no-padding' href="<%=baseURL%>student/report/groups_report.jsp"> <img class="custom-beginskill-backarrow" src="/assets/images/1165040-200.png" alt="">
				</a>
				<div class='col-11 custom-no-padding'>
					<h1 class='custom-beginskill-course-heading'>Credit Officer</h1>
				</div>
			</div>
		</div>
		<div class="container">
			<div class="card" style="box-shadow: 0 10px 24px 0 rgba(0, 0, 0, 0.05), 0 6px 8px 0 rgba(0, 0, 0, 0.04);">
				<div class="row m-5">
					<div class="col-md-11 pl-0">
						<h3 class="card-header-box" style="text-align: center !important;">ATTENDANCE RECORDS IN SECTIONS OVERTIME</h3>
					</div>

					<!-- <div class="col-1 p-0">
						<div class="dropdown">
							<button class="btn btn-secondary btn-sm dropdown-toggle" style="background-color: lightgray; border: none; box-shadow: none !important;" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">All Time</button>
							<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
								<a class="dropdown-item" style="font-size: 15px;" href="#">Action</a> <a class="dropdown-item" style="font-size: 15px;" href="#">Another action</a> <a class="dropdown-item" style="font-size: 15px;" href="#">Something else here</a>
							</div>
						</div>
					</div> -->
					<div class="col-1">
						<img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container">
					</div>

				</div>
				<div class="row m-0">
					<div class="col-12">
						<div id="columnchart_material" style="width: 100%; height: 500px;"></div>

					</div>
				</div>
			</div>
		</div>


		<div class="container mt-5">
			<div class="card" style="box-shadow: 0 10px 24px 0 rgba(0, 0, 0, 0.05), 0 6px 8px 0 rgba(0, 0, 0, 0.04);">
				<div class="row m-5">
					<div class="col-md-11 pl-0">
						<h3 class="card-header-box" style="text-align: center !important;">MASTERY LEVEL PER SKILL</h3>
						<div class="row m-0">
							<div class="col-4"></div>
							<div class="col-7">
								<div class="row m-0">
									<h4 class="mr-4">
										<span class="badge badge-default mr-4" style="background-color: #fd6c81; width: 14px; height: 15px;"> </span>Wizard
									</h4>
									<h4 class="mr-4">
										<span class="badge badge-default mr-4" style="background-color: #33b5e5; width: 14px; height: 15px;"> </span>Master
									</h4>
									<h4 class="mr-4">
										<span class="badge badge-default mr-4" style="background-color: #7692ff; width: 14px; height: 15px;"> </span>Apprentice
									</h4>
									<h4 class="mr-4">
										<span class="badge badge-default mr-4" style="background-color: #b8e986; width: 14px; height: 15px;"> </span>Rookie
									</h4>
								</div>
							</div>
						</div>
						<div class="col-1"></div>
					</div>


					<div class="col-1">
						<img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container">
					</div>

				</div>
				<div class="row m-0">
					<div class="col-12">
						<div id="master_level_perskill custom-scroll-holder" style="min-width: 310px; height: 400px; margin: 0 auto; overflow: auto;">


							<%=dummyService.getAttendanceDetailPerRole() %>



						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="container mt-5">
			<div class="card">
				<div class="card-block">
					<div class="card-body">
						<div class="row m-3">
							<div class="col-11">
								<h3 class='text-center card-header-box'>STUDENTS ENROLLED</h3>
							</div>
							<div class="col-1">
								<img src="/assets/images/ic_more2.png" srcset="/assets/images/ic_more2.png 2x, /assets/images/ic_more3.png 3x" class="float-right options-img-container">

							</div>
						</div>
						<div class="row m-0" style="border: 1px solid #e9ecef; height: 8vh; font-family: avenir-light; font-weight: bold; height: 70px;">
							<div class="col-md-3 text-center m-auto">STUDENT NAME</div>
							<div class="col-md-3 text-center m-auto">RANK</div>
							<div class="col-md-3 text-center m-auto">XP</div>
							<div class="col-md-3 text-center m-auto">LEVEL</div>
						</div>
						<div class="main-table custom-scroll-holder" style="border: 1px solid #e9ecef; max-height: 49.6vh; overflow: auto;">
							<%							
						String 	wizard ="Wizard";
						String master ="Master";
						String apprentice ="Apprentice";
						String rookie ="Rookie";
						
								 for(int i=0; i <4; i++){ %>

							<div class="row m-0" style="font-family: avenir-light; border: 1px solid #e9ecef; height: 70px;">
								<div class="col-md-3 text-center m-auto">
									<div class="row m-0">
										<div class="col-md-4 text-center m-auto">
											<img src="http://business.talentify.in:9999/users/449/8a74ac00-c354-47bf-a68b-3ce3c7578d0e.jpg" style="width: 55px; height: 55px; border-radius: 60px; border: 1px solid rgba(195, 194, 194, 0.22);">
										</div>
										<div class="col-md-8 text-center m-auto">
											<h3>Sumanth Bhat</h3>
										</div>
									</div>
								</div>
								<div class="col-md-3 text-center m-auto">
									#<%=i+10 %></div>
								<div class="col-md-3 text-center m-auto">4500</div>
								<div class="col-md-3 text-center m-auto <%=i==0?wizard:i==1?master:i==2?apprentice:i==3?rookie:wizard %>"><%=i==0?wizard:i==1?master:i==2?apprentice:i==3?rookie:wizard %></div>
							</div>

							<%} %>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>




	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script>
		$.fn
				.extend({
					treed : function(o) {
						var openedClass = 'glyphicon-minus-sign';
						var closedClass = 'glyphicon-plus-sign';
						if (typeof o != 'undefined') {
							if (typeof o.openedClass != 'undefined') {
								openedClass = o.openedClass;
							}
							if (typeof o.closedClass != 'undefined') {
								closedClass = o.closedClass;
							}
						}
						;
						var tree = $(this);
						tree.addClass("tree");
						tree
								.find('li')
								.has("ul")
								.each(
										function() {
											var branch = $(this);
											branch
													.prepend("<i class='indicator glyphicon " + closedClass + "'></i>");
											branch.addClass('branch');
											branch
													.on(
															'click',
															function(e) {
																if (this == e.target) {
																	var icon = $(
																			this)
																			.children(
																					'i:first');
																	icon
																			.toggleClass(openedClass
																					+ " "
																					+ closedClass);
																	$(this)
																			.children()
																			.children()
																			.toggle();
																	$(
																			'.progress')
																			.show();
																	$(
																			'.progress-bar')
																			.show();
																}
															})
											branch.children().children()
													.toggle();
											$('.progress').show();
											$('.progress-bar').show();
											$('.row.ll').show();
											$('.col-md-2.ll').show();

										});
						tree.find('.branch .indicator').each(function() {
							$(this).on('click', function() {
								$(this).closest('li').click();
							});
						});
						tree.find('.branch>a').each(function() {
							$(this).on('click', function(e) {
								$(this).closest('li').click();
								e.preventDefault();
							});
						});
						tree.find('.branch>button').each(function() {
							$(this).on('click', function(e) {
								$(this).closest('li').click();
								e.preventDefault();
							});
						});
					}
				});
		$(document).ready(function() {
			
			
			  google.charts.load('current', {'packages':['corechart']});
		      google.charts.setOnLoadCallback(drawChart);

		    
			
		
		      
		      
		      function drawChart() {

		    	  $.ajax({
					    url: '/SumanthDummyServlet',
					    type: 'GET',
					    async: true,
					    dataType: "json",
					    success: function (data) {
					    	 var dataTable = new google.visualization.DataTable();	
					    	 var col =[];
					      for(var i=0; i< data.length ; i++){
					    	  if(i == 0 ){
					    		  col.push(data[0]);
					    		  for(var k=0;k< data[i].length;k++){
					    			  if(k == 1){
					    				  dataTable.addColumn({'type': 'string', 'role': 'tooltip'});
					    		 
					    			  }else if(k == 0){
					    				  dataTable.addColumn('string', data[i][k]);
					    			  } else{
					    				  dataTable.addColumn('number', data[i][k]);
					    			  }
					    		}
					    		  
					    	  }else{
					    		  for(var k=0;k< data[i].length;k++){
					    			  if( k!=0 && k!=1 ){    			  
					    			  data[i][k] = parseFloat(data[i][k])
					    			 }
					    		  }
					    	  }
					      }
					      
					      
				        					    		       
					        
					        var row = []
					        
					        for(var i=1; i<data.length;i++){
					        	row.push(data[i]);
					        }
					         
					        dataTable.addRows(row);

					        var options = {
					                legend: 'bottom',
					                colors: ['#30beef','#bae88a','#fd6d81','#7295fd'],
						       	    fontName: 'avenir-light',					          
					                focusTarget: 'category',
					                tooltip: { isHtml: true }


					              };
					        var chart = new google.visualization.ColumnChart(document.getElementById('columnchart_material'));
					        chart.draw(dataTable, options);
					      
					  
					    
					    }
					  });
		    	  
		    	  
		        
		        }
 
					$('#tree1').treed();
					$('.progress').show();
					$('.progress-bar').show();
					$('.row.ll').show();
					$('.col-md-2.ll').show();

				});
	</script>

</body>
</html>