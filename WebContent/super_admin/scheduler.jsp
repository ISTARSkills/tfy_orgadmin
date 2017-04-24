<%@page import="in.talentify.core.utils.ColourCodeUitls"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.*"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<jsp:include page="inc/head.jsp"></jsp:include>

<body class="top-navigation" id="super_admin_scheduler">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<%
				String url = request.getRequestURL().toString();
				String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
						+ request.getContextPath() + "/";
			%>


			<%
				UIUtils ui = new UIUtils();

				int colegeID = 0;
				String target ="tab_1";
				if (request.getParameterMap().containsKey("orgID")) {
					colegeID = Integer.parseInt(request.getParameter("orgID"));

				}
				if(request.getParameterMap().containsKey("target")){
					target = request.getParameter("target");
				}
				
			%>
			<div class="row">
				<div class="col-lg-12">
					<div class="ibox float-e-margins no-margins bg-muted">

						<div class="ibox-content">
							
							

							<div class="row show-grid white-bg">
								<div class="col-lg-3 white-bg no-borders whit-bg-schedular">
									<h1 class="text-info font-bold">Create a new Event</h1>
									<div class="tabs-container">
										<ul class="nav nav-tabs gray-bg-schedular">
											<li class="<%=target.equalsIgnoreCase("tab_1")? "active":"" %>"><a id="tab_1" data-toggle="tab" href="#tab-1">Single Event</a></li>
											<li class="<%=target.equalsIgnoreCase("tab_2")? "active":"" %>"><a id="tab_2" data-toggle="tab" href="#tab-2">Daily</a></li>
											<li class="<%=target.equalsIgnoreCase("tab_3")? "active":"" %>"><a id="tab_3" data-toggle="tab" href="#tab-3">Weekly</a></li>
										</ul>
										
										<div class="tab-content">
										
										<div id="tab-1" class="<%=target.equalsIgnoreCase("tab_1")? "active":"" %> tab-pane">
										<jsp:include page="./scheduler/single_event.jsp">
										
												<jsp:param name="orgID" value='<%=target.equalsIgnoreCase("tab_1")?colegeID:0%>' />
											</jsp:include>
										</div>
										
										<div id="tab-2" class="<%=target.equalsIgnoreCase("tab_2")? "active":"" %> tab-pane">
										<jsp:include page="./scheduler/daily_event.jsp">
												<jsp:param name="orgID" value='<%=target.equalsIgnoreCase("tab_2")?colegeID:0%>' />
											</jsp:include>
										</div>
										
										<div id="tab-3" class="<%=target.equalsIgnoreCase("tab_3")? "active":"" %> tab-pane">
										<jsp:include page="./scheduler/weekly_event.jsp">
												<jsp:param name="orgID" value='<%=target.equalsIgnoreCase("tab_3")?colegeID:0%>' />
											</jsp:include>
										</div>
									</div>


									</div>


								</div>
								<div class="col-lg-9 no-padding bg-muted">
									<div class="ibox no-padding no-margins bg-muted p-xs" style="padding-top: 5px;">
										<%=new ColourCodeUitls().getColourCode() %>
										<div class="ibox-content">
											<%
											CalenderUtils  calUtil = new CalenderUtils();
											HashMap<String, String> input_params = new HashMap();
				
											%>
											<%=calUtil.getCalender(input_params).toString()%> 
										</div>
									</div>
								</div>

								<!-- Events details modal -->
								<div class="modal inmodal fade" id="myModal5" tabindex="-1"
									role="dialog" aria-hidden="true">
									<input id="orgID" type="hidden" value="<%=colegeID %>" />
									<div class="modal-dialog modal-lg">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal">
													<span aria-hidden="true">&times;</span><span
														class="sr-only">Close</span>
												</button>
												<h4 class="modal-title">Events details</h4>
												<h4 class="text-danger modal-subTitle"></h4>
											</div>
											<div class="modal-body">
												<div class="row" id="modal_data"></div>
											</div>

											<div class="modal-footer">
												<h4 class="text-danger modal-subTitle pull-left"></h4>
												<button type="button" class="btn btn-white"
													data-dismiss="modal">Close</button>
												<button type="button" id="final_submit_btn"
													data-dismiss="modal"
													class="btn btn-primary final-submit-btn">Save
													changes</button>
											</div>
										</div>
									</div>
								</div>

								<!--  -->

								<!-- modal -->

								<div class="modal inmodal" id="myModal2" tabindex="-1"
									role="dialog" aria-hidden="true">
									<%-- <input id="orgID" type="hidden" value="<%=colegeID %>" /> --%>
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event-edit-modal">

										</div>
									</div>
								</div>
								<!--  -->


							</div>

						</div>


					</div>
				</div>
			</div>
		</div>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
		
			

						}); 
	</script>
</body>

</html>
