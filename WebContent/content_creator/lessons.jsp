<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.CmsessionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<%
	IstarUser istarUser = (IstarUser) request.getAttribute("user");
	LessonDAO lessonDAO = new LessonDAO();
	CmsessionDAO cmsessionDAO = new CmsessionDAO();
	List<Lesson> lessons = new ArrayList<Lesson>();
	lessons = (List<Lesson>) lessonDAO.findAll();
	List<Cmsession> cmsessions = (List<Cmsession>) cmsessionDAO.findAll();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0,cdnPath.length()-1);
%>

<body class="top-navigation" id="lesson_list" data-helper='This page is used to show list of lessons. '>
	<div id="wrapper" class='customcss_overflowy'>
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			
			<% 
			   String[] brd = {"Dashboard","Lessons"};
			%>
			<%=UIUtils.getPageHeader("Lessons Grid", brd) %>
				
				<div class="row card-box scheduler_margin-box">
				<%-- <div class="col-lg-4 form-group">
					<select class="js-example-basic-single" id="filters">
						<option></option>
						<option value="NONE">None</option>
						<%
							for (Cmsession cmsession : cmsessions) {
								String cmsessionSearchString = cmsession.getTitle().replaceAll(" ", "").toLowerCase();
						%>
						<option value="<%=cmsessionSearchString%>"><%=cmsession.getTitle()%></option>
						<%
							}
						%>
					</select>
				</div> --%>
				<div class="col-lg-1" >
					<!-- <button class="btn btn-primary dim" type="button" style="float: right;" id="create_lessonzz">
						<i class="fa fa-plus-circle" title="Create a Lesson"></i>&nbsp;Create
					</button> -->
					<button type="button" id="create_lessonzz" class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Lesson
					</button>
				</div>
				<!-- <div class="col-lg-1" style="margin-top: 26px; padding: 0px">
					<p style="text-align: center;">All lessons</p>
					<input  type="checkbox" id="show_all_lessons" />
				</div> -->
				<div class="modal inmodal fade" id="myModal6" tabindex="-1" role="dialog" aria-hidden="true">
					<div class="modal-dialog modal-sm">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal">
									<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
								</button>
								<h4 class="modal-title">Select Lesson Type</h4>
							</div>
							<div class="modal-body">
								<button type="button" class="btn btn-primary create_lesson" id="elt">Interactive Lesson</button>
								<button type="button" class="btn btn-primary create_lesson" id="vlt">Video Lesson</button>
								<button type="button" class="btn btn-primary create_lesson" id="ilt">ILT Lesson</button>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-white" data-dismiss="modal">Close</button>
								<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
							</div>
						</div>
					</div>
				</div>

				<div class="col-lg-2 form-group customcss_search-box">
					<input class="form-control quicksearch" autocomplete="off" type="text" id="quicksearch" placeholder="Search" />
				</div>
</div>
<div class="row card-box scheduler_margin-box">
			
			<div class="ui-group ">
					<h3 class="ui-group__title">Filter</h3>
					<div class="filters button-group js-radio-button-group btn-group">
						<button class="button btn button_spaced btn-xs btn-danger" data-filter="*">show all</button>
						<%
							ArrayList<String> arrayList = new ArrayList<>();
						ArrayList<String> displayList = new ArrayList<>();
							for (Lesson lesson : lessons) {
								String cmsessionString = "NONE";
								String cmsessionStringLong = "NONE";
								String courseStringLong = "";

								try {
									cmsessionStringLong = lesson.getCmsessions().iterator().next().getTitle();
									cmsessionString = cmsessionStringLong.replaceAll(" ", "").toLowerCase();
									courseStringLong = lesson.getCmsessions().iterator().next().getModules().iterator().next().getCourses().iterator().next().getCategory();
									String courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "").toLowerCase();
									 if(!arrayList.contains(courseString)){
										 arrayList.add(courseString);
										 displayList.add(courseStringLong);
									 }
									 
								} catch (Exception e) {

								}
							}
							int i = 0;
							for (String c_category : arrayList) {
						%>

						<button class="button btn button_spaced btn-xs btn-white"
							data-filter=".<%=c_category%>"><%=displayList.get(i)%></button>
						<%
						i++;}
						%>
					</div>
				</div>
			
			</div>
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box " id='only_lesson_items'>

				<div class="sk-spinner sk-spinner-three-bounce">
					<div class="sk-bounce1"></div>
					<div class="sk-bounce2"></div>
					<div class="sk-bounce3"></div>
				</div>

			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
</body>

<script type="text/javascript">
	
</script>
</html>