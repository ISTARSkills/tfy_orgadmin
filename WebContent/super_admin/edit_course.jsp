<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="com.viksitpro.core.dao.entities.AssessmentDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.Assessment"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="in.superadmin.ops.service.OpsReportSevices"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%
	String path = request.getContextPath();
String basePath = "http://cdn.talentify.in/";

try{
	Properties properties = new Properties();
	String propertyFileName = "app.properties";
	InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
		if (inputStream != null) {
			properties.load(inputStream);
			basePath =  properties.getProperty("cdn_path");
			//System.out.println("basePath"+basePath);
		}
	} catch (IOException e) {
		e.printStackTrace();
	}
	
%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<link href="<%=basePath%>assets/css/gijgo.min.css" rel="stylesheet" type="text/css" />

<%
 String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
IstarUser user = (IstarUser)request.getSession().getAttribute("user");
String courseId = request.getParameter("course_id");
%>
<body class="top-navigation" id="courses_page">
	<input type="hidden" name="admin_id" value="<%=user.getId()%>"id="hidden_admin_id">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			
			<% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Edit Course", brd) %>
			
			<div class="row customcss_istarnotification" >
			<div class=''>
			<div class="row">
			<input type="hidden" name="course_id" value="<%=courseId%>" id="course_id">
						<div class="container-fluid">
							<div id="tree"></div>
						</div>
						          
        	</div>
			
			</div>
			</div>
			<div id="modal-form" class="modal fade" aria-hidden="true" style="display: none;">
			<input type="hidden" id="hidden_lesson_id">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12 b-r"><h3 class="m-t-none m-b">Import PowerPoint/Excel</h3>

                                                    
                                                    <form role="form"  id="SubmissionForm" enctype="multipart/form-data">
                                                    <input type="hidden" id="hidden_lesson_id">
                                                    <div class="form-group"><label>Lesson Name</label> <input type="text" disabled class="form-control" id="lesson_name"></div>
                                                        <div class="form-group"><div class="fileinput fileinput-new input-group" data-provides="fileinput">
                                <div class="form-control" data-trigger="fileinput"><i class="glyphicon glyphicon-file fileinput-exists"></i> <span class="fileinput-filename"></span></div>
                                <span class="input-group-addon btn btn-default btn-file"><span class="fileinput-new">Select file</span><span class="fileinput-exists">Change</span><input type="file" name="..."></span>
                                <a href="#" class="input-group-addon btn btn-default fileinput-exists" data-dismiss="fileinput">Remove</a>
                            </div></div>
                                                        <div>
                                                            <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="submit" id="upload_file"><strong>Upload</strong></button>
                                                            </div>
                                                    </form>
                                                </div>
                                               
                                        </div>
                                    </div>
                                    </div>
                                </div>
                        </div>
			<div style="display: none" id="spinner_holder">
				<div style="width: 100%; z-index: 6; position: fixed;"
					class="spiner-example">
					<div style="width: 100%;"
						class="sk-spinner sk-spinner-three-bounce">
						<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
						<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
					</div>
				</div>
			</div>
			

		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script src="<%=basePath %>assets/js/gijgo.min.js" type="text/javascript"></script>
	<script type="text/javascript">
	var courseId = $('#course_id').val();
	 var tree = $('#tree').tree({
         primaryKey: 'node_id',
         dataSource: '/get_course_tree?course_id='+courseId,
         imageUrlField: 'flagUrl',
         uiLibrary: 'bootstrap', 
         imageHtmlField: 'id'
     });
	 tree.expandAll();
	 tree.on('select', function (e, node, id) {
		var itemId = node.attr('id');
		if(itemId.indexOf("lesson")!=-1)
		{
			//lert('select is fired for node with id=' + node.attr('id'));
			$
			$('#hidden_lesson_id').val(node.attr('id'));
			$('#lesson_name').val(node.data('title'));
			$('#modal-form').modal();
		} 
		('#course_'+courseId).css('background-color','#f3f3f4');
		$('#course_'+courseId).css('color','#333');
     });
	 tree.on('unselect', function (e, node, id) {
		 var itemId = node.attr('id');
			if(itemId.indexOf("lesson")!=-1)
			{
				//lert('select is fired for node with id=' + node.attr('id'));
				
				$('#hidden_lesson_id').val(node.attr('id'));
				$('#lesson_name').val(node.data('title'));
				$('#modal-form').modal();
			} 
			$('#course_'+courseId).css('background-color','#f3f3f4');
			$('#course_'+courseId).css('color','#333');
     });
	 tree.on('nodeDataBound', function (e, node, id, record) {
        
     });
	 
	 $('#SubmissionForm').submit(function(event){
		  // Disable the default form submission
		  $('#modal-form').modal('toggle');
		  event.preventDefault();
		  var lessonId = $('#hidden_lesson_id').val().replace("lesson_","");
		  var formData = new FormData($(this)[0]);
		  $('input').each( function() {
		    formData.append($(this).attr('id'),$(this).val());
		  });
		  // Submit form to Domino server using specified form
		  $.ajax({
		    url: '/import_power_point?lesson_id='+lessonId,
		    type: 'POST',
		    data: formData,
		    async: false,
		    cache: false,
		    contentType: false,   // Important!
		    processData: false,   // Important!
		    success: function (returndata) {
		    	swal({
	                title: "Your file has been uploaded. Successfully.",
	                text: "It will take a few minutes to import the file."
	            });
		    	
				
		    }
		  });
		  return false;
		});

	</script>
</body>