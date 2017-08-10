<!DOCTYPE html>
<%@page import="com.viksitpro.core.delivery.pojo.DeliveryLesson"%>
<%@page import="com.viksitpro.core.delivery.pojo.DeliverySession"%>
<%@page import="com.viksitpro.core.delivery.pojo.DeliveryModule"%>
<%@page import="com.viksitpro.core.delivery.pojo.DeliveryCourse"%>
<%@page import="com.viksitpro.core.delivery.services.DeliveryServcies"%>
<%@page import="com.viksitpro.core.skill.pojo.LearningObjective"%>
<%@page import="com.viksitpro.core.skill.pojo.SessionLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.ModuleLevelSkill"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.Module"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.skill.pojo.CourseLevelSkill"%>
<%@page import="com.viksitpro.core.skill.services.SkillService"%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="http://localhost:8080/img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="http://localhost:8080/assets/css/bootstrap.min.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/timepicki.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/dataTables/datatables.min.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.min.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.print.css" rel='stylesheet' media='print'>

<link href="http://localhost:8080/assets/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<link href="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />

<link href="http://localhost:8080/assets/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/animate.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/style.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/toastr/toastr.min.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/chosen/bootstrap-chosen.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link rel="stylesheet" href="http://localhost:8080/assets/css/jquery.rateyo.min.css">
<link href="http://localhost:8080/assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/steps/jquery.steps.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">


</head>


<%
int course_id = Integer.parseInt(request.getParameter("course_id"));
Course c= new CourseDAO().findById(course_id);
DeliveryServcies service = new DeliveryServcies();
DeliveryCourse dCourse = service.getDeliveryCourseTree(course_id);
%>
<body class="top-navigation" >
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
<div class="row border-bottom white-bg">
<nav class="navbar navbar-static-top" role="navigation">
					<div class="navbar-header">
						<button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
							<i class="fa fa-reorder"></i>
						</button>
						<a href="/coordinator/dashboard.jsp" class="navbar-brand">Talentify</a>
					</div>
					<div class="navbar-collapse collapse" id="navbar">
						<ul class="nav navbar-nav">

							<li><a id="Dashboard" href="/coordinator/dashboard.jsp">Dashboard</a></li>
</ul>


						<ul class="nav navbar-top-links navbar-right">
							<li><a href="/auth/logout"> <i class="fa fa-sign-out"></i> Log out
							</a></li>
						</ul>


					</div>
				</nav>

				<div style="display: none" id="admin_page_loader">
					<div style="width: 100%; z-index: 6; position: fixed;" class="spiner-example">
						<div style="width: 100%;" class="sk-spinner sk-spinner-three-bounce">
							<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
							<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
							<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
						</div>
					</div>
				</div>
			</div>

			<!-- Start Table -->

			<!-- End Table -->
			<div class="wrapper wrapper-content animated fadeInRight">
				<div class="row">
					<div class="col-md-4">
                    <div id="nestable-menu">
                        <!-- <button type="button" data-action="expand-all" class="btn btn-white btn-sm">Expand All</button>
                        <button type="button" data-action="collapse-all" class="btn btn-white btn-sm">Collapse All</button> -->
                    </div>
                    </div>
                  </div>  
                    <div class="row">
                    <div class="col-lg-6">
                    <div class="ibox ">
                        <div class="ibox-title">
                            <h5>Delivery Tree</h5>
                        </div>
                       
                        <div class="ibox-content">
                         <div><span class="label label-success">Module</span>
                        <span class="label label-info">Session</span>
                        <span class="label label-warning">LO</span>
                        <span class="label label-success">Danger</span>
                        <span class="label label-plain">Danger</span>
                        <span class="label label-green" style="">Danger</span>
                      <!--   
                        <span class="label label-danger">Danger</span></div> -->
                            <div>
                                <ol class="dd-list">                                    
                                    <li class="dd-item">
                                        <div class="dd-handle" style="    color: RED !important;">
                                        <%=dCourse.getCourseName()%>
                                        &nbsp;
                                        <%if(dCourse.getModuleLevelSkill().size()==0){ 
                                        	%>
                                        	<a  class="btn btn-danger btn-xs" style="float:right" href="/skill_tree_creator?creation_type=COURSE_TREE&course_id=<%=course_id%>">Create Tree</a>
                                        	<%
                                        }
                                        else if(!dCourse.getIsPerfect())
                                        {
                                        	%>
                                        	<a  class="btn btn-danger btn-xs" style="float:right" href="/skill_tree_creator?creation_type=COURSE_TREE&course_id=<%=course_id%>">Complete Tree</a>
                                        	&nbsp;
                                        	<span class="label label-success">Mod Skill - <%=dCourse.getModuleLevelSkill().size()%></span>
                                        	<span class="label label-success">Mod Total - <%=dCourse.getModules().size()%></span>
                                        	<span class="label label-success">Mod Mapped  - <%=dCourse.getMappedModules().size()%></span>
                                        	<%
                                        } %>
                                        </div>
                                        <ol class="dd-list">
                                            <%
                                            for(DeliveryModule m : dCourse.getModules()){
                                            %>
                                            <li class="dd-item" data-id="course_<%=c.getId()%>_module<%=m.getId()%>">
                                                <div class="dd-handle" style="    color: BLUE !important;"><%=m.getId() %> - <%=m.getModuleName() %>
                                                <%
                                                if(!m.getIsPerfect())
                                                {
                                                	%>
                                                	<a  class="btn btn-danger btn-xs" style="float:right" href="/skill_tree_creator?creation_type=MODULE_TREE&course_id=<%=course_id%>&module_id=<%=m.getId()%>">Complete Module Tree</a>
                                                	&nbsp;
                                                	
                                                	<%
                                                }	
                                                %>
                                                <span class="label label-success">Mod Skill - <%=m.getModuleLevelSkills().size()%></span>
                                                <span class="label label-info">CM Skill - <%=m.getSessionLevelSkills().size()%></span>
                                                <span class="label label-info">CM Total - <%=m.getSessions().size()%></span>
                                                <span class="label label-info">
                                                <%
                                                for(SessionLevelSkill ss : m.getSessionLevelSkills())
                                                {
                                                	%>
                                                	<%=ss.getId() %><%=ss.getSkillName()%>,
                                                	<%
                                                }	
                                                
                                                %>
                                                </span>
                                               <%--  <span class="label label-info">CM Mapped - <%=m.getMappedSessions().size()%></span>	 --%>
                                                </div>
                                                <ol class="dd-list">
                                                <% for(DeliverySession cms : m.getSessions())
                                                {
                                                	%>
                                                  <li class="dd-item" data-id="course_<%=c.getId()%>_module<%=m.getId()%>_cms<%=cms.getId()%>">
                                                <div class="dd-handle" style="    color: GREEN !important;"><%=cms.getSessionName()%>
                                                <%
                                                if(!cms.getIsPerfect())
                                                {
                                                	%>
                                                	<a  class="btn btn-danger btn-xs" style="float:right" href="/skill_tree_creator?creation_type=SESSION_TREE&course_id=<%=course_id%>&module_id=<%=m.getId()%>&session_id=<%=cms.getId()%>">Complete Session Tree</a>
                                                	<%
                                                }	
                                                %>
                                                <span class="label label-info">S - <%=cms.getSessionSkills().size()%></span>
                                                <span class="label label-warning">LO - <%=cms.getLos().size()%></span>
                                                </div>
                                                <%
                                                for(DeliveryLesson l : cms.getLessons())
                                                {
                                                	%>
                                                	 <ol class="dd-list">
                                                	 <li class="dd-item" data-id="course_<%=c.getId()%>_module<%=m.getId()%>_cms<%=cms.getId()%>_lesson<%=l.getId()%>">
                                                	 <div class="dd-handle"><%=l.getLessonName() %>
                                                	 <%
                                                if(!l.getIsPerfect())
                                                {
                                                	%>
                                                	<a  class="btn btn-danger btn-xs" style="float:right" href="/skill_tree_creator?creation_type=LO_TREE&course_id=<%=course_id%>&module_id=<%=m.getId()%>&session_id=<%=cms.getId()%>&lesson_id=<%=l.getId()%>">Map Learn Obj</a>
                                                	<%
                                                }	
                                                %>
                                                	 <span class="label label-warning">LO - <%=l.getMappedLO().size()%></span>
                                                	 </div>
                                                 </ol>
                                                	<%
                                                }	
                                                %>
                                                
                                                </li>
                                                	<% 
                                                }	
                                                %>
                                                </ol>
                                            </li>
                                            <%
                                            }
                                            %>
                                        </ol>
                                    </li>
                                    
                                </ol>
                            </div>
                            

                        </div>
                    </div>
                </div>
                <%
                SkillService  s = new  SkillService();
                //CourseLevelSkill skillTree = s.getCourseSkillTree(c.getId());
                
                %>
                <%-- <div class="col-lg-6">
                    <div class="ibox ">
                        <div class="ibox-title">
                            <h5>Skill Tree</h5>
                        </div>
                        <div class="ibox-content">

                           
                            <div class="dd">
                                <ol class="dd-list">
                                    
                                    <li class="dd-item" data-id="course_skill<%=skillTree.getId()%>">
                                        <div class="dd-handle" style="    color: RED !important;"><%=c.getCourseName()%></div>
                                         <ol class="dd-list">
                                            <%
                                            for(ModuleLevelSkill m : skillTree.getModuleLevelSkill()){
                                            	String modules = "";
                                            	for(Module mo : m.getModules())
                                            	{
                                            		modules += mo.getModuleName()+", ";
                                            	}	
                                            %>
                                            <li class="dd-item" data-id="course_<%=skillTree.getId()%>_module<%=m.getId()%>">
                                                <div class="dd-handle" style="    color: BLUE !important;"><%=m.getSkillName()%> (<%=m.getCreationType().charAt(0) %>)&nbsp; [<%=modules %>]</div>
                                                 <ol class="dd-list">
                                                <% for(SessionLevelSkill cms : m.getSessionLevelSkill())
                                                {
                                                	%>
                                                  <li class="dd-item" data-id="course_<%=c.getId()%>_module<%=m.getId()%>_cms<%=cms.getId()%>">
                                                <div class="dd-handle" style="    color: GREEN !important;"><%=cms.getSkillName() %> (<%=cms.getCreationType().charAt(0)%>)</div>
                                                <%
                                                for(LearningObjective l : cms.getLearningObjectives())
                                                {
                                                	%>
                                                	 <ol class="dd-list">
                                                	 <li class="dd-item" data-id="course_<%=c.getId()%>_module<%=m.getId()%>_cms<%=cms.getId()%>_lesson<%=l.getId()%>">
                                                	 <div class="dd-handle"><%=l.getLearningObjectiveName()%></div>
                                                 </ol>
                                                	<%
                                                }	
                                                %>
                                                
                                                </li>
                                                	<% 
                                                }	
                                                %>
                                                </ol>
                                            </li>
                                            <%
                                            }
                                            %>
                                        </ol> 
                                    </li>
                                    
                                </ol>
                            </div>
                            


                        </div>

                    </div>
                </div> --%>
                    </div>
                </div>
				
				</div>
				
			</div>




	<!-- Mainly scripts -->





	<script src="http://localhost:8080/assets/js/plugins/fullcalendar/moment.min.js"></script>

	<script src="http://localhost:8080/assets/js/jquery-2.1.1.js"></script>



	<script src="http://localhost:8080/assets/js/bootstrap.min.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="http://localhost:8080/assets/js/inspinia.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/pace/pace.min.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/dataTables/datatables.min.js"></script>
	<script type="text/javascript" src="http://localhost:8080/assets/js/jquery.bootpag.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>
	<!-- Clock picker -->
	<script src="http://localhost:8080/assets/js/plugins/clockpicker/clockpicker.js"></script>
	<script src="http://localhost:8080/assets/js/plugins/select2/select2.full.min.js"></script>
	 <script src="http://localhost:8080/assets/js/plugins/nestable/jquery.nestable.js"></script>
	
	<script src="http://localhost:8080/assets/js/app.js"></script>
	<script>
         $(document).ready(function(){

            
        	


             // output initial serialised data
            

             /* $('#nestable-menu').on('click', function (e) {
                 var target = $(e.target),
                         action = target.data('action');
                 if (action === 'expand-all') {
                     $('.dd').nestable('expandAll');
                 }
                 if (action === 'collapse-all') {
                     $('.dd').nestable('collapseAll');
                 }
             }); */
         });
    </script>

	
	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

		  ga('create', 'UA-103015121-1', 'auto');
		  ga('send', 'pageview');
		  ga('set', 'userId', 'NOT_LOGGED_IN_USER'); // Set the user ID using signed-in user_id.

	</script>
</body>

</html>
