<%@page import="com.istarindia.apps.dao.College"%>
<%@page import="com.istarindia.apps.dao.OrganizationDAO"%>
<%@page import="com.istarindia.apps.dao.Organization"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
	College o = new College();
	boolean newCollege = true;
	
	if(request.getParameterMap().containsKey("org_id")) {
	String college_id = request.getParameter("org_id");
		newCollege = false;
		o = (College)new OrganizationDAO().findById(Integer.parseInt(college_id));
		}
	
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />


<title>Talentify Recruitor | Dashboard</title>

<link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="<%=baseURL%>css/animate.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/summernote/summernote.css" rel="stylesheet">
<link href="<%=baseURL%>css/style.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="<%=baseURL%>css/plugins/dropzone/basic.css" rel="stylesheet">
<link href="<%=baseURL%>css/plugins/dropzone/dropzone.css" rel="stylesheet">

</head>

<body class="fixed-navigation">
		<div id="wrapper" style="overflow-y:hidden">
		<jsp:include page="../includes/sidebar.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg ">
			<div class="row">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>


			<div class="wrapper">
				<div class="vacancy_tabs_pane white-bg page-heading">
					<h2 style="padding-top: 15px;">Create or Update College</h2>
				</div>

				<div class="panel-body" style="background-color:white;">
				
											<form method="post" class="form-horizontal" action="<%=baseURL%>update_organization_details" enctype="multipart/form-data">
							
									<div class="form-group">									
										<label class="col-sm-2 control-label">Name</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" placeholder="College Name" name="name" data-validation="required" value="<%=!newCollege?o.getName():"" %>">
										</div>
									</div>
									
									<div class="form-group">									
										<label class="col-sm-2 control-label">College Logo</label>
										<div class="col-sm-6">
										<input type="file" placeholder="Upload College Logo" data-validation="required" name="name" class="hidden upload_college_logo"/>
										<div class="">
										<img class="college_image" style="width: 100px; height: 100px; border: solid #f3f3f3; border-width: 1px;" src="<%=!newCollege?o.getImage():"/video/company_image/default.png"%>"/>
										</div>
										</div>
									</div>
									
									<div class="hr-line-dashed"></div>

									<div class="form-group">
										<label class="col-sm-2 control-label">Profile</label>
										<div class="col-sm-10 ttr">
											<div class="summernote">
											<%=!newCollege?o.getCompany_profile():"" %>
											</div>
											<input type="hidden" name="profile" id="profileD"/>
										</div> 
									
									</div>
									
									<div class="form-group">
										<label class="col-sm-2 control-label">Number of Students</label>
										<div class="col-sm-3">
											<input type="number" min="1" class="form-control" data-validation="required" name="numberOfStudents" value="<%=!newCollege?o.getMaxStudents():0 %>">
										</div>
									</div>

									<div class="hr-line-dashed"></div>

									<div class="form-group">
										<label class="col-sm-2 control-label">Address Line 1</label>
										<div class="col-sm-10">
											<input type="text" class="form-control" data-validation="required" placeholder="Eg. Infosys Gate 1, 1st Main Rd" name="addressline1" value="<%=!newCollege?o.getAddress().getAddressline1():"" %>">
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-2 control-label">Address Line 2</label>
										<div class="col-sm-10">
											<input type="text" class="form-control" data-validation="required" placeholder="Eg. Electronics City Phase 1, Electronic City" name="addressline2" value="<%=!newCollege?o.getAddress().getAddressline2():"" %>">
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-2 control-label">PIN</label>
										<div class="col-sm-10">
											<select class="js-data-example-ajax  form-control" data-pin_uri="<%=baseURL %>" name="pincode" data-validation="required" >
											<option value="<%=!newCollege?o.getAddress().getPincode().getPin():"" %>" <%=!newCollege?"selected":"" %> style="width: 350px;" tabindex="2"><%=!newCollege?o.getAddress().getPincode().getPin():"Select Pincode" %></option>
										</select>
											
										</div>
									</div>

									<div class="hr-line-dashed"></div>

									<p>
										
										<button style="float: right;" type="submit" class="btn btn-w-m btn-success">
											<i class="fa fa-check"></i>&nbsp;Submit
										</button>
										<br/><br/>
									</p>
									<%if(request.getParameter("org_id")!=null){ %>
									<input type="hidden" name="college_id" value="<%=request.getParameter("org_id").toString()%>">
									<%} %>
								</form>

				</div>
			</div>
		</div>
	</div>
	
	

	<!-- Mainly scripts -->
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="<%=baseURL%>js/bootstrap.min.js"></script>
	<script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="<%=baseURL%>js/inspinia.js"></script>
	<script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
	
<%-- 	<script src="<%=baseURL%>js/plugins/summernote/summernote.min.js"></script> --%>
	   
	<!-- Chosen -->
	<script src="<%=baseURL%>js/plugins/chosen/chosen.jquery.js"></script>

	<!-- Sparkline -->
	<script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>
	<script src="<%=baseURL%>js/plugins/summernote/summernote.min.js"></script>

	<!-- Sparkline demo data  -->
	<script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>
	<script src="<%=baseURL%>js/plugins/select2/select2.full.min.js"></script>

	<!-- IonRangeSlider -->
	<script src="<%=baseURL%>js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>

	<!-- TouchSpin -->
	<script src="<%=baseURL%>js/plugins/touchspin/jquery.bootstrap-touchspin.min.js"></script>
	<script src="<%=baseURL%>js/plugins/staps/jquery.steps.min.js"></script>
	       <script src="<%=baseURL%>js/highcharts-custom.js"></script>
	
	
      <!-- DROPZONE -->
    <script src="<%=baseURL%>js/plugins/dropzone/dropzone.js"></script>
    
	<script>
	
	 function formatRepo (repo) {
	      if (repo.loading) return repo.text;

	      var markup = "<div class='select2-result-repository clearfix'>" + repo.id + "</div>";

	      if (repo.description) {
	        markup += "<div class='select2-result-repository__description'>" + repo.id + "</div>";
	      }
	      return markup;
	    }

	
	 function formatRepoSelection (repo) {
	      return repo.id;
	    }
	 
	 $('.college_image').on("click", function(){
		 $('.upload_college_logo').click();
	 });
	 
	$('.upload_college_logo').on("change", function(){
		readImage(this);
		 }) 

	  
	  function readImage(input) {

		    if (input.files && input.files[0]) {
		        var reader = new FileReader();

		        reader.onload = function (e) {
		            $('.college_image').attr('src', e.target.result);
		        }

		        reader.readAsDataURL(input.files[0]);
		    }
		}

	  
        $(document).ready(function() {
        	
        	       	        	
        	$(".chosen-select").chosen({disable_search_threshold: 10}); //To choose Industry Type from Chosen JQuery
        	

        	
        	$('.summernote').summernote({
        		height: 300,
        		resize: false,
        		placeholder: "Enter College Description",
        	    onChange: function() {
        	    profileData = $('.note-editable').html(); 
        		$('#profileD').val(profileData); }   //Storing profile data in input tag 
        	});

        	//Variable to retrieve profile data on page load        	
        	var profileData = $('.note-editable').html();
        	$('#profileD').val(profileData);

            $.validate();
            
            var baseURL = $(".js-data-example-ajax").data("pin_uri");
            var urlPin = baseURL + 	"PinCodeController";
            
            $(".js-data-example-ajax").select2({
            	  ajax: {
            	    url: urlPin,
            	    dataType: 'json',
            	    delay: 250,
            	    data: function (params) {
            	      return {
            	        q: params.term, // search term
            	        page: params.page
            	      };
            	    },
            	    processResults: function (data, params) {
            	      // parse the results into the format expected by Select2
            	      // since we are using custom formatting functions we do not need to
            	      // alter the remote JSON data, except to indicate that infinite
            	      // scrolling can be used
            	      params.page = params.page || 1;

            	      return {
            	        results: data.items,
            	        pagination: {
            	          more: (params.page * 30) < data.total_count
            	        }
            	      };
            	    },
            	    cache: true
            	  },
            	  escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
            	  minimumInputLength: 1,
            	  templateResult: formatRepo,
                  templateSelection: formatRepoSelection
            	});
        });
    </script>
</body>
</html>
