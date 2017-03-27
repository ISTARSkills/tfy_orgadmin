<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="in.orgadmin.utils.UserInterfaceUtils"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />

	
    <title>Talentify Recruiter | Dashboard</title>

    <link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="<%=baseURL%>css/animate.css" rel="stylesheet">
    <link href="<%=baseURL%>css/style.css" rel="stylesheet">
    <link href="<%=baseURL%>css/plugins/summernote/summernote.css" rel="stylesheet">
    <link href="<%=baseURL%>css/plugins/summernote/summernote-bs3.css" rel="stylesheet">

</head>

<body class="fixed-navigation">
    <div id="wrapper">
    	<jsp:include page="../includes/sidebar.jsp"></jsp:include>
        <div id="page-wrapper" class="gray-bg ">
	        
	        <div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
	        </div>
         
            
            <div class="wrapper wrapper-content">
                <div class="row">
					<div class="col-lg-12">
				        <div class="ibox float-e-margins">
                        <div class="ibox-title">
                             <h2>List of Colleges</h2>
                            
                        </div>
                        <div class="ibox-content">

                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>College Name</th>
                                    <th>Placement Officer</th>
                                    <th>Action</th>
                                    <th>Invite PlacementOfficer</th>
                                </tr>
                                </thead>
                                <tbody>
                               <% 
                               CollegeDAO dao = new CollegeDAO();
                               List<College>  list = dao.findAll();
                               for(College college:   list) { %>                             
                                <tr>
                                    <td><%=college.getId() %></td>
                                   <td><%=college.getName() %></td>
                                   <td><%= UserInterfaceUtils.printSetTPO(college.getPlacementOfficers()).toString() %></td>
                                   <td><a href="<%=baseURL %>orgadmin/organization/edit_organization.jsp?org_id=<%=college.getId() %>" class="btn btn-outline btn-info btn-xs">Edit College </a></td>
                                   <td><button style="float : left;" type="button" data-toggle="modal" class="btn btn-outline btn-info btn-xs invite_placement_officer" href="#add_placement_officer" data-college="<%=college.getName()%>" data-college_id="<%=college.getId()%>">
							Invite TPO</button></td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
				    </div>
                </div>
            </div>
            
        </div>
    </div>

    <!-- Mainly scripts -->
    <script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
    <script src="<%=baseURL%>js/bootstrap.min.js"></script>
    <script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Peity -->
    <script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
    <script src="<%=baseURL%>js/demo/peity-demo.js"></script>
    
    <script src="<%=baseURL%>js/highcharts-custom.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="<%=baseURL%>js/inspinia.js"></script>
    <script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

    <!-- jQuery UI -->
    <script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>

    <!-- Jvectormap -->
    <script src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
    <script src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

    <!-- Sparkline -->
    <script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>
    <script src="<%=baseURL%>js/plugins/summernote/summernote.min.js"></script>

    <!-- Sparkline demo data  -->
    <script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>
    
    	<script
		src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>


    <script>
        $(document).ready(function() {

        });
    </script>
    <script type="text/javascript">
  //Invite recruiter 
    $($(document)).on("click", ".inviteTPOButtn", function(){

   	var tpo_name = $('.tpo_name').val();
   	var tpo_email = $('.tpo_email').val();
   	var tpo_college= $('.hidden_college_id_modal').val();
   	console.log(tpo_college);
   		    	
   	var url = "/invitePlacementOfficer?name="+tpo_name+"&email="+tpo_email+"&college_id="+tpo_college;
   	$('#add_placement_officer').modal('toggle');
   	console.log(url);
   	
       $.ajax(url, {
           success: function(data) {
	        	 $('#output_message').html(data);
	        	 $('#result_notification').modal('toggle');
	        	 $('#add_placement_officer').find('.tpo_name').val('');
	        	 $('#add_placement_officer').find('.tpo_email').val('');
           },
           error: function() {
           }
       });
    });
  
  
    $($(document)).on("click", ".invite_placement_officer", function(){
  	  var college_name = $(this).data('college');
  	  var college_id = $(this).data('college_id');
  	  console.log(college_name + college_id);
  		$('.college_name_in_modal').append(college_name);
  		$('.hidden_college_id_modal').val(college_id);  	  
    });
    
    </script>
    <div id="add_placement_officer" class="modal fade" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-body">
							<div class="row">
									<div class="col-sm-12 b-r"><h3 class="m-t-none m-b college_name_in_modal">Invite Placement Officer of </h3>
		                                    <div class="form-group"><label>Name</label> <input type="text" data-validation="required" placeholder="Enter name of Placement Officer" class="form-control tpo_name"></div>
		                                    <div class="form-group"><label>Email</label> <input type="email" data-validation="required" placeholder="Enter email of Placement Officer" class="form-control tpo_email"></div>
												<input type="hidden" class="hidden_college_id_modal"/>
                       						<div>
		                                        <button
												class="btn btn-sm btn-primary pull-right inviteTPOButtn"
												style="margin-right: 25px; margin-top: 8px;">Invite</button>
		                                    </div>
		                            </div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
		<div id="result_notification" class="modal fade" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-12 b-r" id="output_message">
						
						</div>
					</div>
				</div>
			</div>
		</div>
</div>	
	
</body>
</html>
