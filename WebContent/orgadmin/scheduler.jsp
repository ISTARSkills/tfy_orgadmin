<%@page import="in.talentify.core.utils.ColourCodeUitls"%>
<%@page import="in.orgadmin.calender.utils.CalenderUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.*"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<jsp:include page="inc/head.jsp"></jsp:include>

<body class="top-navigation" id="orgadmin_scheduler">
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
				/* OrgAdmin u = (OrgAdmin) request.getSession().getAttribute("user"); */
				
				int colegeID = (int)request.getSession().getAttribute("orgId");
			%>
			<div class="row" style="padding:2px;">
				<div class="col-lg-12">
				<div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#tab-m" aria-expanded="true"> Manual Scheduler</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-a" aria-expanded="false" id="dddddddd">Auto Scheduler</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="tab-m" class="tab-pane active">
                                <div class="panel-body">
                                   <jsp:include page="scheduler/scheduler_wrapper.jsp"></jsp:include>
                                </div>
                            </div>
                            <div id="tab-a" class="tab-pane">
                                <div class="panel-body">
                                   <jsp:include page="scheduler/auto_scheduler.jsp"></jsp:include>
                                    </div>
                            </div>
                        </div>


                    </div>
			
			</div>
			</div>
		</div>
	</div>


	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>

</html>
