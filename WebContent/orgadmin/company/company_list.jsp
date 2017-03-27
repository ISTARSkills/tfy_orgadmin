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

	
    <title>Talentify Recruitor | Dashboard</title>

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
                             <h2>List of Companies</h2>
                            
                        </div>
                        <div class="ibox-content">

                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Company Name</th>
                                    <th>Industry</th>
                                    <th>Recruiters</th>
                                    <th>Action</th>
                                    <th>Invite Recruiter</th>
                                </tr>
                                </thead>
                                <tbody>
                               <% 
                               CompanyDAO dao = new CompanyDAO();
                               List<Company>  list = dao.findAll();
                               for(Company company:   list) { %>                             
                                <tr>
                                    <td><%=company.getId() %></td>
                                   <td><%=company.getName() %></td>
                                   <td><%=company.getIndustry() %></td>
                                   <td><%= UserInterfaceUtils.printSet(company.getRecruiters()).toString() %></td>
                                   <td><a href="<%=baseURL %>orgadmin/company/create_new_company.jsp?company_id=<%=company.getId() %>" class="btn btn-outline btn-info btn-xs">Edit Company </a></td>
                                   <td><button style="float : left;" type="button" data-toggle="modal" class="btn btn-outline btn-info btn-xs invite_recruiter" href="#add_recruiter" data-company="<%=company.getName()%>" data-company_id="<%=company.getId()%>">
							Invite Recruiter</button></td>
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

    <!-- Custom and plugin javascript -->
    	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
    
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
    $($(document)).on("click", ".inviteRecruiterButtn", function(){

   	var recruiter_name = $('.recruiter_name').val();
   	var recruiter_email = $('.recruiter_email').val();
   	var recruiter_companyId = $('.hidden_company_id_modal').val();
   	console.log(recruiter_companyId);
	var recruiter_collegeId = $('.recruiter_college').val();
   		    	
   	var url = "/invite_recruiter?name="+recruiter_name+"&email="+recruiter_email+"&company_id="+recruiter_companyId+"&tpo_college_id="+recruiter_collegeId;
   	$('#add_recruiter').modal('toggle');
   	console.log(url);
   	
       $.ajax(url, {
           success: function(data) {
           },
           error: function() {
           }
       });
    });
  
  
    $($(document)).on("click", ".invite_recruiter", function(){
  	  var company_name = $(this).data('company');
  	  var company_id = $(this).data('company_id');
  	  console.log(company_name + company_id);
  		console.log(company_name);
  		$('.company_name_in_modal').append(company_name);
  		$('.hidden_company_id_modal').val(company_id);  	  
    });
    
    </script>
    <div id="add_recruiter" class="modal fade" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-body">
							<div class="row">
									<div class="col-sm-12 b-r"><h3 class="m-t-none m-b company_name_in_modal">Invite a Recruiter: </h3>
		                                <p>Invite a recruiter: </p>
		                                    <div class="form-group"><label>Name</label> <input type="text" data-validation="required" placeholder="Enter name of Recruiter" class="form-control recruiter_name"></div>
		                                    <div class="form-group"><label>Email</label> <input type="email" data-validation="required" placeholder="Enter email of Recruiter" class="form-control recruiter_email"></div>
		                                    
											<div class="form-group">
		                                    	<label>College</label>	         
											<select data-placeholder="Choose College" class="form-control chosen-select recruiter_college" tabindex="2" data-validation="required">
											<option value="" selected>Select College </option>
												<% 
		                                    List<College> allcollege = new CollegeDAO().findAll();
		                                    for(College college: allcollege){%>
		                                    	<option value="<%=college.getId()%>"><%=college.getName() %></option>
												<%} %>
											</select>
											</div>
											  	<input type="hidden" class="hidden_company_id_modal"/>
                       						<div>
		                                        <button
												class="btn btn-sm btn-primary pull-right inviteRecruiterButtn"
												style="margin-right: 25px; margin-top: 8px;">Invite</button>
		                                    </div>
		                            </div>
							</div>
						</div>
					</div>
				</div>
			</div>
</body>
</html>
