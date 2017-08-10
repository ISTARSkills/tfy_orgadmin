<%@page import="in.talentify.core.utils.ColourCodeUitls"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.*"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<jsp:include page="/inc/head.jsp"></jsp:include>

<body class="top-navigation" id="super_admin_scheduler">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>

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
			   <%
					String[] brd = { "Dashboard" };
				%>
				<%=UIUtils.getPageHeader("Scheduler", brd)%>
			<div class="row card-box scheduler_margin-box card-box">
				<div class="col-lg-12">
					<div class="" id='scheduler_tab_cotainer'>
                      <ul class="nav nav-tabs tabs-bordered nav-justified">
                            <li class="active"><a data-toggle="tab" href="#tab-m" aria-expanded="true"> Manual Scheduler</a></li>
    
                            <li class=""><a data-toggle="tab" href="#tab-a" aria-expanded="false" id="dddddddd">Auto Scheduler</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="tab-m" class="active tab-pane div-min-height">
                                <div class="panel-body">
                                   <jsp:include page="scheduler/super_admin_scheduler_wrapper.jsp"></jsp:include>
                                </div>
                            </div>
                            <div id="tab-a" class="tab-pane div-min-height">
                                <div class="panel-body">
                                   <jsp:include page="scheduler/super_admin_auto_scheduler.jsp"></jsp:include>
                                    </div>
                            </div>
                        </div>


                    </div>
				</div>
			</div>
		</div>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
		$(document).ready(function() {
		
			

						}); 
	</script>
</body>

</html>
