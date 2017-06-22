<%@page import="com.istarindia.android.pojo.SkillReportPOJO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.istarindia.android.pojo.StudentProfile"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<style>
.rank {
	margin-top: 3%;
}

.profile-header {
	background: lightgray;
	vertical-align: middle;
	padding: 6px;
	height: 30px;
	color: grey;
}

@media only screen and (min-width: 992px) {
	.position-no {
		font-size: 14px;
		color: #ffffff;
		background-color: #23b6f9;
		padding: 6px 12px;
		position: absolute;
		bottom: 55;
		right: 37%;
		border-radius: 50%;
		padding-left: 5px;
		padding-right: 6px;
	}
	.account-setting-camera-position {
		font-size: 14px;
		color: #ffffff;
		background-color: #23b6f9;
		padding: 6px 12px;
		position: absolute;
		bottom: 55;
		right: 42%;
		border-radius: 50%;
		padding-left: 5px;
		padding-right: 6px;
	}
}

@media only screen and (min-device-width : 320px) and (max-device-width
	: 480px) {
	.position-no {
		font-size: 14px;
		color: #ffffff;
		background-color: #23b6f9;
		padding: 6px 12px;
		position: absolute;
		top: 75;
		right: 0;
		border-radius: 50%;
		padding-left: 7px;
		padding-right: 7px;
	}
}

.scroll-horizontally-div {
	overflow: auto;
	display: flex;
	background: lightgray;
}

/*start  */
.tree1>li {
	padding: 0 !important;
}

.progress {
	height: 6px;
	margin-bottom: 0px !important;
}

ul>.progress {
	margin-left: 2%;
}

li>.progress {
	
}

ul>p {
	margin-left: 2%;
}

.tree, .tree ul {
	margin: 0;
	padding: 0;
	list-style: none
}

.tree ul {
	margin-left: 5px;
	position: relative
}

.tree ul ul {
	margin-left: .5em
}

.tree ul:before {
	content: "";
	display: block;
	width: 0;
	position: absolute;
	top: 0;
	bottom: 0;
	left: 0;
	border-left: 1px solid
}

.tree li {
	margin: 0;
	padding: 0 33px;
	line-height: 2em;
	font-weight: 700;
	position: relative
}

.tree ul li:before {
	content: "";
	display: block;
	width: 30px;
	height: 0;
	border-top: 1px solid;
	margin-top: -1px;
	position: absolute;
	top: 1em;
	left: 0
}

.tree ul li:last-child:before {
	background: #fff;
	height: auto;
	top: 1em;
	bottom: 0
}

.indicator {
	margin-right: 5px;
}

.tree li a {
	text-decoration: none;
	color: #369;
}

.tree li button, .tree li button:active, .tree li button:focus {
	text-decoration: none;
	color: #369;
	border: none;
	background: transparent;
	margin: 0px 0px 0px 0px;
	padding: 0px 0px 0px 0px;
	outline: 0;
}
/* end */
/*Start of plugin css  */
.circular-progress-bar {
	position: relative;
	margin: 0 auto;
}

.progress-percentage, .progress-text {
	position: absolute;
	width: 100%;
	top: 50%;
	left: 59%;
	transform: translate(-50%, -50%);
	text-align: center;
}

.progress-percentage {
	font-size: 18px;
	transform: translate(-50%, -85%);
}

.progress-text {
	transform: translate(-50%, 0%);
	color: #888888;
	font-size: 11px;
}
/* End */
</style>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject co = rc.getComplexObject(user.getId());

	request.setAttribute("cp", co);

	StudentProfile studentProfile = co.getStudentProfile();
	SimpleDateFormat sd = new SimpleDateFormat("dd-MMM-YYYY");
	Integer batch_rank = studentProfile.getBatchRank() != null ? studentProfile.getBatchRank() : 0;
	String fname = studentProfile.getFirstName() != null ? studentProfile.getFirstName() : "";
	String email = studentProfile.getEmail() != null ? studentProfile.getEmail() : "";
	String profileImage = studentProfile.getProfileImage() != null
			? studentProfile.getProfileImage()
			: "../assets/img/user_images/student.png";
	Integer exp_points = studentProfile.getExperiencePoints() != null
			? studentProfile.getExperiencePoints()
			: 0;
	String pass = studentProfile.getPassword() != null ? studentProfile.getPassword() : "";
	String dob = studentProfile.getDateOfBirth() != null ? sd.format(studentProfile.getDateOfBirth()) : "";
	String mobile = studentProfile.getMobile() != null ? studentProfile.getMobile() + "" : "";
%>

<style>
.row {
	margin-right: 0px !important;
	margin-left: 0px !important;
}

.h-370 {
	min-height: 375px !important;
	max-height: 375px !important;
}

.button-top {
	margin-top: -12px !important;
}

.assessment-circle-img {
	width: 50%;
	height: 40%;
}

.session-square-img {
	width: 160px;
	height: 160px;
}

.btn-rounded {
	min-width: 200px;
	background: #eb384f;
	color: white;
}

.task-complete-header {
	background: #23b6f9 !important;
}

#vertical-timeline {
	overflow-x: hidden;
	overflow-y: auto;
	max-height: 250px;
}

.vertical-container {
	width: 99% !important;
}

.vertical-timeline-content p {
	margin-bottom: 2px !important;
	margin-top: 0 !important;
	line-height: 1.6 !important;
}

.content-border {
	border: none !important;
}

.btn.banner:hover {
	color: white !important
}

.nav-tabs>li.active>a:hover, a:focus, a:active {
	border-radius: 50px !important;
}

.btn.banner.focus, .btn.banner:focus, .btn.banner:hover {
	color: white !important;
}
</style>
<body class="top-navigation" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>

			<!-- Start Table -->
			<div class="row">
				<div class="panel-body">
					<div class="row text-center font-normal p-xxs">
						<div class="col-xs-4 col-md-4 rank">
							<strong style="font-size: 68px;">#<%=batch_rank%></strong> <br /> <small class="text-muted" style="font-size: 30px;">Batch Rank</small>
						</div>
						<div class="col-xs-4 col-md-4">
							<img src="<%=profileImage%>" class="img-circle" style="width: 120px !important; height: 120px !important;"> <span class="position-no"> <i class="fa fa-camera"></i></span> <br /> <br />
							<%=fname%>
						</div>
						<div class="col-xs-4 col-md-4 rank">
							<strong style="font-size: 68px;"><%=exp_points%></strong> <br /> <small class="text-muted" style="font-size: 30px;">XP Earned</small>
						</div>
					</div>
					<div class="row">
						<div class="tabs-container">
							<div id="container2" style="overflow: hidden;">

								<ul class="nav nav-tabs scroll-horizontally-div" style="overflow: visible !important;">
									<%
										int min = Math.min(5, co.getSkills().size());
										for (int i = 0; i < co.getSkills().size(); i++) {
											String class_tag = "";
											if (i == 1) {
												class_tag = "active";
											} else {
												class_tag = "";
											}
											if (co.getSkills().get(i).getSkills().size() > 0) {
									%>
									<li class="<%=class_tag%> text-center" style="width: 97px;"><a data-toggle="tab" href="#course<%=i%>" aria-expanded="true"><img src="<%=co.getSkills().get(i).getImageURL()%>" class="img-circle" style="width: 65px !important; height: 65px !important;"> <br />
											<h3 sty>
												<small><%=co.getSkills().get(i).getName()%></small>
											</h3> </a></li>
									<%
										}
										}
									%>
								</ul>
							</div>

							<div class="tab-content">
								<%
									for (int i = 0; i < co.getSkills().size(); i++) {
										String class_tag1 = "";
										if (i == 1) {
											class_tag1 = "active";
										} else {
											class_tag1 = "";
										}
								%>
								<div id="course<%=i%>" class="tab-pane <%=class_tag1%>">
									<div class="panel-body">
										<div class="ibox ">
											<div class="ibox-title">
												<h2><%=co.getSkills().get(i).getName()%></h2>
											</div>
											<div class="ibox-content">
												<div class=" ">
													<div class="">

														<div class="col-md-12" style="padding-left: 0px !important;">
															<ul class="tree1">

																<%
																	for (SkillReportPOJO subSkill : co.getSkills().get(i).getSkills()) {
																%>
																<li><%=subSkill.getName()%>
																	<div class="progress" style="height: 5px !important; display: block;">
																		<div id='skill_<%=subSkill.getId()%>' style="width: <%=subSkill.getPercentage()%>%;" aria-valuemax="<%=subSkill.getTotalPoints()%>" aria-valuemin="0" aria-valuenow="<%=subSkill.getUserPoints()%>" role="progressbar" class="progress-bar "></div>
																	</div>
																	<p><%=subSkill.getUserPoints().intValue()%>
																		/
																		<%=subSkill.getTotalPoints().intValue()%> 
																		XP  &nbsp;  <%=subSkill.getSkills().size() %> SubSkills

																	</p>

																	<ul>

																		<%
																			for (SkillReportPOJO subsubSkill : subSkill.getSkills()) {
																		%>
																		<li><%=subsubSkill.getName()%>
																			<div class="progress" style="height: 5px !important;">
																				<div style="width: <%=subsubSkill.getPercentage()%>%;" aria-valuemax="<%=subsubSkill.getTotalPoints()%>" aria-valuemin="0" aria-valuenow="<%=subsubSkill.getUserPoints()%>0" role="progressbar" class="progress-bar"></div>
																			</div>
																			<p><%=subsubSkill.getUserPoints().intValue()%>
																				/
																				<%=subsubSkill.getTotalPoints().intValue()%>
																				XP 
																			</p></li>
																		<%
																			}
																		%>
																	</ul></li>
																<%
																	}
																%>
															</ul>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>


								<%
									}
								%>
							</div>
						</div>
					</div>
				</div>

			</div>

		</div>


	</div>
	<div id="progress-nos" va="50"></div>


	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#data_2 .input-group.date').datepicker({
                startView: 1,
                todayBtn: "linked",
                keyboardNavigation: false,
                forceParse: false,
                autoclose: true,
                format: "dd/mm/yyyy"
            });

			
			var progress;
			progress = $('#progress-nos').attr('va');
			console.log("progress------" + progress);
			$(".my-progress-bar").circularProgress({
				line_width : 4,
				height : "140px",
				width : "140px",
				color : "#eb384f",
				starting_position : 0, // 12.00 o' clock position, 25 stands for 3.00 o'clock (clock-wise)
				percent : 0, // percent starts from
				percentage : true,
				text : "Profile Completed"
			}).circularProgress('animate', progress, 5000);
			
			$('.btn-white').click(function(){
				var icon_class = $(this).find('i').attr('class');
				var button_icon = $(this).find('i');
				if(icon_class === 'fa fa-pencil'){
					button_icon.removeClass(icon_class);
					button_icon.addClass('fa fa-check');
					$(this).parent().siblings().removeAttr('disabled');
					
				}else{
					button_icon.removeClass(icon_class);
					button_icon.addClass('fa fa-pencil');
					$(this).parent().siblings().attr('disabled', 'disabled');
					
					
					var serialized = form.serialize();
					console.log(serialized);
					$.ajax({
				        type: "POST",
				        url: "gvygv",
				        data: {serialized},
				        success: function(data) {
				        	console.log('success');
				        }});
					
				}
			});
		});
	</script>
</body>

</html>
