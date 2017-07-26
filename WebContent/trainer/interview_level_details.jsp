<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.util.HashMap"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
int trainer_id = Integer.parseInt(request.getParameter("trainer_id"));
%>
<body class="top-navigation" id="interview_level_details">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>

			<div class="wrapper wrapper-content" style="padding: 4px;">

				<div class="row">
					<div class="col-lg-12">
						<div class="tabs-container">
							<ul class="nav nav-tabs">
								<li class="active"><a data-toggle="tab" href="#tab-l3">L3-Trainer Assessment Details</a></li>
								<li class=""><a data-toggle="tab" href="#tab-l4">L4-Trainer Question</a></li>
							</ul>
							<div class="tab-content">
								<div id="tab-l3" class="tab-pane active">
									<jsp:include page="/trainer_common_jsps/main_level_3.jsp">
									<jsp:param value="<%=trainer_id%>" name='trainer_id'/>
									</jsp:include>
								</div>
								<div id="tab-l4" class="tab-pane">
									<div class="panel-body">
										<strong>Donec quam felis</strong>

										<p>Thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath</p>

										<p>I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet.</p>
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
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
</html>
