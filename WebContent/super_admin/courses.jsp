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
<jsp:include page="/inc/head.jsp"></jsp:include>
<%
 String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";
IstarUser user = (IstarUser)request.getSession().getAttribute("user");
%>
<body class="top-navigation" id="courses_page">
	<input type="hidden" name="admin_id" value="<%=user.getId()%>"id="hidden_admin_id">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			
			<% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Courses", brd) %>
			
			<div class="row customcss_istarnotification" >
			<div class="row" style="    margin-bottom: 10px;">
			<div class="col-lg-2 pull-right">
			<input type="text" placeholder="Search" class="form-control" id="course_search_box">
			</div>
			</div>
			<div class=''>
			
			<div class="row">
			<div class="col-lg-2" style="    height: 306px;">
                <div class="contact-box">
                    <a data-toggle="modal" href="#modal-form">
                    <div class="col-sm-12">
                        <div class="text-center">
                            <img alt="image" class="img-rounded img-responsive" src="/assets/images/add_new.png">
                            <h3 class="m-b-xs"><strong>Add New Course</strong></h3>
                        </div>
                    </div>
                    
                    <div class="clearfix"></div>
                        </a>
                </div>
            </div>
            <div id="modal-form" class="modal fade" aria-hidden="true" style="display: none;">
			<input type="hidden" id="hidden_lesson_id">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12 b-r"><h3 class="m-t-none m-b">Upload Excel to create course and time table</h3>

                                                    
                                                    <form role="form" id="SubmissionForm"  enctype="multipart/form-data">
                                                        
                                                        <div class="form-group"><div class="fileinput fileinput-new input-group" data-provides="fileinput">
                                <div class="form-control" data-trigger="fileinput"><i class="glyphicon glyphicon-file fileinput-exists"></i> <span class="fileinput-filename"></span></div>
                                <span class="input-group-addon btn btn-default btn-file"><span class="fileinput-new">Select file</span><span class="fileinput-exists">Change</span><input type="file" name="..."></span>
                                <a href="#" class="input-group-addon btn btn-default fileinput-exists" data-dismiss="fileinput">Remove</a>
                            </div></div>
                                                        <div>
                                                            <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="button" id="upload_file"><strong>Upload</strong></button>
                                                            </div>
                                                    </form>
                                                </div>
                                               
                                        </div>
                                    </div>
                                    </div>
                                </div>
                        </div>
			<%for(Course c : new CourseDAO().findAll()) 
			{
				String courseImage = "";
				if(c.getImage_url()!=null)
				{
					courseImage="http://elt.talentify.in:9999/"+c.getImage_url();
				}
				%>
				 <div class="col-lg-2 course_cards" style="    height: 306px;">
                <div class="contact-box">
                    <a href="edit_course.jsp?course_id=<%=c.getId()%>">
                    <div class="col-sm-12">
                        <div class="text-center">
                            <img alt="image" class="img-rounded img-responsive" src="<%=courseImage%>">
                            <h3 class="m-b-xs"><strong><%=c.getCourseName() %></strong></h3>
                        </div>
                    </div>
                    
                    <div class="clearfix"></div>
                        </a>
                </div>
            </div>
				
				<%
			}%>
			
           
            
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
			<div class='row'>
					<div class="row">
						<div class="col-lg-12 white-bg">
							<div class="ibox customcss_iboxcontent">
								<div class="ibox-content">
									<div id ="graph_ke_liye">
									</div>
								</div>

							</div>
						</div>
						
					</div>

			


			</div>

		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script type="text/javascript">
	console.log("asdasd");
	$(document).ready(function(){
		
		$('#course_search_box').keyup(function(){
			
		    var val = $(this).val().toLowerCase();
		    if(val==='')
		    {
		    	$('.course_cards').show();
		    }
		    else
		    {
		    	
		    	$('.course_cards').hide();
		    	 $('.course_cards').each(function() {
			    	 var course_name = $(this).text().trim().toLowerCase();
			    		    	
			    	 if(course_name.indexOf(val)>=0)
			    	 {
			    		// 
			    		 
			    		 $(this).show();
			    	 }
			    	 else
			    	 {
			    		 $(this).hide();
			    	 }
			    	});
		    }	
		   
		});
		
		
		$('#upload_file').click(function(event){
			  // Disable the default form submission
			   event.preventDefault();		
			  $('#modal-form').modal('toggle');
			
			  
			  var formData = new FormData($('#SubmissionForm')[0]);
			  $('input').each( function() {
			    formData.append($(this).attr('id'),$(this).val());
			  });
			  
			  swal({
	              title: "File upload started.",
	              text: "It will take a few minutes to import course."
	          });
			  
			  setTimeout(() => {
				  $.ajax({
				    url: '/course_creator_servlet',
				    type: 'POST',
				    data: formData,
				    async: false,
				    cache: false,
				    contentType: false,   // Important!
				    processData: false,   // Important!
				    success: function (returndata) {
				    	
				    	var xx = JSON.parse(returndata)
				    	if(xx.status==='OK')
				    	{
				    		swal({
				                title: "Your file has been uploaded. Successfully.",
				                text: "Course created successfully"
				            });
					    	
				    	}
				    	else
				    	{
				    		swal({
				                title: "Error in importing course.",
				                text: xx.message
				            });			    	
				    	}			    					
				    }
				  });
				  }, 2000);
				  return false;
				});
	});
	
	
	

		</script>
	</body>