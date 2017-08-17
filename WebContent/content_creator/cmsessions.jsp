<%@page import="java.util.ArrayList"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.viksitpro.cms.services.LessonServices"%>
<%@page import="com.viksitpro.core.dao.entities.CmsessionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Cmsession"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.dao.entities.ModuleDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.Module"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<%
	IstarUser istarUser = (IstarUser) request.getAttribute("user");
	ModuleDAO moduleDAO = new ModuleDAO();
	CmsessionDAO cmsessionDAO = new CmsessionDAO();
	List<Module> modules = (List<Module>) moduleDAO.findAll();
	List<Cmsession> cmsessions = (List<Cmsession>) cmsessionDAO.findAll();
	LessonServices lessonServices = new LessonServices();
	String cdnPath = lessonServices.getAnyPath("media_url_path");
	cdnPath = cdnPath.substring(0, cdnPath.length() - 1);
%>

<body class="top-navigation" id="sesssion_list"
	data-helper='This page is used to show list of sessions. '>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			<%
				String[] brd = { "Dashboard", "Sessions" };
			%>
			<%=UIUtils.getPageHeader("Sessions Grid", brd)%>


			<%-- <div class="col-lg-4 form-group" >
					<select class="js-example-basic-single" id="filters">
						<option></option>
						<option value="NONE">None</option>
						<%
							for (Module module : modules) {
								String modulesearchstring = module.getModuleName().replaceAll(" ", "").toLowerCase();
						%>
						<option value="<%=modulesearchstring%>"><%=module.getModuleName()%></option>
						<%
							}
						%>
					</select>
				</div> --%>
			<!-- <div class="col-lg-1">
					<button class="btn btn-primary dim" type="button" id="create_cmsession">
						<i class="fa fa-plus-circle" title="Create a Session"></i>&nbsp;Create
					</button>
				</div> -->
			<div class="row card-box scheduler_margin-box">
				<div class="col-lg-2">
					<button type="button" id="create_cmsession"
						class="btn btn-w-m btn-danger">
						<i class="fa fa-plus"></i> Create Session
					</button>
				</div>
				<div class="col-lg-2 form-group customcss_search-box">
					<input class="form-control quicksearch" autocomplete="off" type="text"
						id="quicksearch" placeholder="Search Session" />
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
							for (Cmsession cmsession : cmsessions) {
								String course_category = "";

								try {
									
									 String moduleStringLong = cmsession.getModules().iterator().next().getModuleName();
									 String moduleString = moduleStringLong.replaceAll(" ", "").toLowerCase();
									 String courseStringLong = cmsession.getModules().iterator().next().getCourses().iterator().next().getCourseName();
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
			<div
				class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
				<div class="row grid">
					<%
						for (Cmsession cmsession : cmsessions) {
							if (!cmsession.getIsDeleted()) {
								String moduleString = "NONE";
								String moduleStringLong = "NONE";
								String courseStringLong = "NONE";
								 String courseString = "";
								try {
									moduleStringLong = cmsession.getModules().iterator().next().getModuleName();
									moduleString = moduleStringLong.replaceAll(" ", "").toLowerCase();
									courseStringLong = cmsession.getModules().iterator().next().getCourses().iterator().next().getCourseName();
								    courseString = courseStringLong.replaceAll(" ", "").replaceAll("&", "").replaceAll("/", "").toLowerCase();
								} catch (Exception e) {

								}
					%>

					<div class="col-md-2 transition element-item pageitem <%=moduleString%> <%=courseString%>">
						<div class="ibox product-box customcss_height-prod-box">
							<div class="ibox-content  customcss_ibox_product_border">
								<div class="imgWrap">
									<img alt="image" class="customcss_img-size"
										src="<%=cdnPath + cmsession.getImage_url()%>">
								</div>
								<div class="product-desc">
									<span class="product-price customcss_product_price"><span
										class="label label-primary customcss_font-size">Course Name - <%=courseStringLong%></span>
									</span> <a
										href="/content_creator/cmsession.jsp?session=<%=cmsession.getId()%>"
										class="product-name"><%=cmsession.getTitle()%> </a>
									<div class="small m-t-xs">
										<%
											if (cmsession.getDescription().length() > 100) {
										%>
										<%=cmsession.getDescription().substring(0, 100)%>
										<%
											} else {
										%>
										<%=cmsession.getDescription()%>
										<%
											}
										%>
									</div>
									
								</div>
								<div class="col-md-12 customcss_lesson-button">
<div class="col-md-6 text-center">
										<a
											href="/content_creator/cmsession.jsp?session=<%=cmsession.getId()%>"
											class="btn btn-xs btn-outline btn-primary customcss_lesson-button_btn">Edit <i
											class="fa fa-pencil"></i>
										</a> </div><div class="col-md-6 text-center"> <a data-cmsession_id='<%=cmsession.getId()%>' href="#"
											class="btn btn-xs btn-outline btn-primary delete_cmsession customcss_lesson-button_btn">Delete
											<i class="fa fa-trash-o"></i>
										</a>
										</div>
									</div>
							</div>
						</div>
					</div>
					<%
						}
						}
					%>

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