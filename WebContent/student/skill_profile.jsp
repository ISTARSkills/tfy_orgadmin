<%@page import="com.viksitpro.user.service.UserSkillProfile"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>


<jsp:include page="/inc/head.jsp"></jsp:include>



<body id="student_skill_profile">
	<%
		boolean flag = false;
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";

		IstarUser user = (IstarUser) request.getSession().getAttribute("user");
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user.getId());
		if (cp == null) {
			flag = true;
			request.setAttribute("msg", "User Does Not Have Permission To Access");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
		request.setAttribute("cp", cp);
		UserSkillProfile userskillprofile = new UserSkillProfile();
	%>
	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">

		<div class="container">
			<div class="row ">
				<div class="card custom-skill-profile-card justify-content-md-center mt-lg-5">
					<div class="card-block">
						<div class="row justify-content-md-center">
							<div class="col-4 col-md-auto text-center m-5">
								<h1 class='custom-skill-profile-batch-raking'>
									#
									<%=cp.getStudentProfile().getBatchRank()%></h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">Batch Rank</h3>
							</div>
							<div class="col-3 col-md-auto text-center m-5">
								<img class='img-circle custom-skill-profile-img' src='<%=cp.getStudentProfile().getProfileImage()%>' alt='No Image Available'>
								<div id='skill_profile_uploadicon' class="img-circle custom-skillprofile-uploadicon" >
								<form method="POST" enctype="multipart/form-data" id="fileUploadForm">
									<!-- <img  class='img-circle mt-3 custom-skillprofile-icontag' src='/assets/images/group-5.png' alt='No Image Available'>
									
					            	<input id="upload_file" type="file" name="files"  accept="image/*" /> -->


										<button id="btnfile" class='p-0 m-0 border-0' style='background: transparent;'>
											<img class='img-circle mt-3 custom-skillprofile-icontag' src='/assets/images/group-5.png' alt='No Image Available'>
										</button>
										<div class="wrapper" style='display:none !important;'>
											 <input id="uploadfile" type="file" name="files"  accept="image/x-png,image/jpg,image/jpeg"/>
											 <input name='user_id' type="hidden" value="<%=user.getId() %>" />
										</div>



									</form>
								</div>
								<h1 class='custom-skill-profile-name'><%=cp.getStudentProfile().getFirstName()%></h1>
							</div>
							<div class="col-4 col-md-auto text-center m-5">
								<h1 class='custom-skill-profile-batch-raking'><%=cp.getStudentProfile().getExperiencePoints()%></h1>
								<h3 class="text-muted custom-skill-profile-batch-raking-title">XP Earned</h3>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>



		<%-- <div class="container">
			<div class="row">

				<h1>Badges</h1>


			</div>
		</div>

		<div class="container">

			<div class="row ">
				<div class="card custom-skill-badges-card justify-content-md-center">
					<div class="card-block">
						<div class="row custom-no-margins">


							<div id="carouselExampleControls" class="carousel slide  w-100" data-ride="carousel" data-interval="false">
								<div class="carousel-inner" role="listbox">
									<%=userskillprofile.StudentRoles(cp)%>

								</div>
								<a class="carousel-control-prev custom-arrows-width" href="#carouselExampleControls" role="button" data-slide="prev"> <img class="custom-skillprofile-arrow-img" src="/assets/images/992180-2001-copy.png" alt="">
								</a> <a class="carousel-control-next custom-arrows-width" href="#carouselExampleControls" role="button" data-slide="next"><img class="custom-skillprofile-arrow-img" src="/assets/images/992180-200-copy.png" alt=""> </a>
							</div>


						</div>
					</div>
				</div>
			</div>


		</div> --%>

		<div class="container">
			<div class="row">

				<h1 class='custom-dashboard-header'>Skills</h1>


			</div>
		</div>


		<div class="container">

			<div class="row ">
				<div class="col-3 pl-0">
					<nav class="nav flex-column">

						<%=userskillprofile.getSkillList(cp)%>

					</nav>

				</div>
				<div class="col-9">
					<div class="card custom-skill-tree ml-5 custom-scroll-holder">
						<div class="card-block my-auto mx-auto" id='skillTreeHolder'>
						
						
                             <div class="loader"></div>
                            

							
						</div>
					</div>
				</div>
			</div>


		</div>


	</div>

	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script>
	$(document).ready(function() {
		
		
		
		function getSkillsfunction(skill_id){
			
			$("#skillTreeHolder").empty();
			 $("#skillTreeHolder").addClass(' my-auto').addClass(' mx-auto');
			 $("#skillTreeHolder").append('<div class="loader"></div>');
			
			  $.ajax({
	            	url:'<%=baseURL%>get_user_service',
	            	data :{'skill_id':skill_id,'user_id':<%=user.getId()%>},
	            	success: function(result){
	            		
	                $("#skillTreeHolder").removeClass(' my-auto').removeClass(' mx-auto');
	                $("#skillTreeHolder").html(result);
	              
	                $('#tree1').treed();
	            }
	           });
			
		}
		
		
		getSkillsfunction($('.skill_list_active').attr('data-skillId'));

            $('.skill_list').click(function() {
                        $('.skill_list').removeClass('skill_list_active');
                        $('.skill_list').addClass('skill_list_disable');
                        $('.skill_list').children().removeClass('custom-skill-list-active').addClass('custom-skill-list-disabled');
                        $(this).removeClass('skill_list_disable');
                        $(this).addClass('skill_list_active');
                        $(this).children().removeClass('custom-skill-list-disabled');
                        $(this).children().addClass('custom-skill-list-active');

              var skill_id = $(this).attr('data-skillid');
              
              
              getSkillsfunction(skill_id);
            
            
             });
            

            $.fn.extend({treed: function(o) {

                        var openedClass = 'glyphicon-minus-sign';
                        var closedClass = 'glyphicon-plus-sign';

                        if (typeof o != 'undefined') {
                            if (typeof o.openedClass != 'undefined') {
                                openedClass = o.openedClass;
                            }
                            if (typeof o.closedClass != 'undefined') {
                                closedClass = o.closedClass;
                            }
                        };

                        //initialize each of the top levels
                        var tree = $(this);
                        tree.addClass("tree");
                        tree.find('li').has("ul").each( function() {
                                    var branch = $(this); //li with children ul
                                    branch.prepend("<i class='indicator glyphicon " + closedClass + "'></i>");
                                    branch.addClass('branch');
                                    branch.on('click',function( e) {
                                                if (this == e.target) {
                                                    var icon = $( this) .children('i:first');
                                                    icon.toggleClass(openedClass +" " +closedClass);
                                                    $(this).children().children().toggle();
                                                }
                                            })
                                    branch.children().children().toggle();
                                });
                        //fire event from the dynamically added icon
                        tree.find('.branch .indicator').each(
                                function() {
                                    $(this).on('click',function() {
                                                $(this).closest('li').click();
                                            });
                                });
                        //fire event to open branch if the li contains an anchor instead of text
                        tree.find('.branch>a').each(
                                function() {
                                    $(this).on('click',function(e) {
                                                $(this).closest('li').click();
                                                e.preventDefault();
                                            });
                                });
                        //fire event to open branch if the li contains a button instead of text
                        tree.find('.branch>button').each(function() {
                                    $(this).on('click',function(e) {
                                                $(this).closest('li').click();
                                                e.preventDefault();
                                            });
                                });
                    }
                });

            //
            
            
            
             
             $("#btnfile").click(function () {
            	 
            	    $("#uploadfile").click();
            	 return false;
            	});
            
            $('#uploadfile').change(function() {
            	
            	var form = $('#fileUploadForm')[0];
				
				// Create an FormData object
				var data = new FormData(form);
				
				var upload_file = $('#uploadfile').val();
		        var file_ext = $('#uploadfile').val().split('.')[1];
		        var servlet = "/UserMediaUploadController";
            	
        if (upload_file != '') {    	
			    $.ajax({
						type : "POST",
						enctype : 'multipart/form-data',
						url : servlet,
						data : data,
						processData : false,
						contentType : false,
						cache : false,
						timeout : 600000,
						success : function(data) {
							
							var ddd = '<%=baseURL%>'+data;
							$('.custom-skill-profile-img').attr("src",ddd);
							
							
							
						},
						error : function(e) {
							alert('Please Retry Again');
						}
					}); 
		} 

            });  

        });
	</script>
</body>
</html>