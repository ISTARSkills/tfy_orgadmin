<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>

<!DOCTYPE html>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String cdnUrl = "http://cdn.talentify.in/";

	try {
		Properties properties = new Properties();
		String propertyFileName = "app.properties";
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
		if (inputStream != null) {
			properties.load(inputStream);
			cdnUrl = properties.getProperty("cdn_path");
		}
	} catch (IOException e) {
		e.printStackTrace();
	}

	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	DBUTILS db = new DBUTILS();
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=cdnUrl%>assets/img/user_images/new_talentify_logo.png" />
<title>Talentify | Sign Up</title>
<link href="<%=cdnUrl%>assets/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
	rel="stylesheet">
<link
	href="<%=cdnUrl%>assets/css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">
<link
	href="<%=cdnUrl%>assets/css/plugins/jasny/jasny-bootstrap.min.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/plugins/datapicker/datepicker3.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/plugins/select2/select2.min.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/plugins/chosen/bootstrap-chosen.css"
	rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/animate.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/style.css" rel="stylesheet">
<link href="<%=cdnUrl%>assets/css/custom.css" rel="stylesheet">

</head>

<body class="top-navigation" id="">
	<div id="wrapper">
		<div id="page-wrapper" class="white-bg">
			<%
				if (request.getParameterMap().containsKey("msg")) {
			%>
			<div class="alert alert-danger">
				<%=request.getParameter("msg")%>
			</div>
			<%
				}
			%>
			<div class="row">
				<div class="row wrapper border-bottom white-bg page-heading">
					<div class="col-lg-10">
						<h2 style="margin-left: 31px;">Student Sign Up</h2>
					</div>
					<div class="pull-right"
						style="margin-top: 18px; margin-right: 80px;">
						<button type="button"
							class="btn btn-sm btn-primary m-t-n-xs signup_button">Update
							Details</button>
					</div>
				</div>
				<jsp:include page="/trainer_common_jsps/profile_and_signup.jsp">
					<jsp:param value="STUDENT" name="user_type" />
				</jsp:include>
			</div>
		</div>
	</div>


	<!-- Mainly scripts -->
</body>

<script src="<%=cdnUrl%>assets/js/jquery-2.1.1.js"></script>
<script src="<%=cdnUrl%>assets/js/bootstrap.min.js"></script>
<!-- Chosen -->
<script src="<%=cdnUrl%>assets/js/plugins/chosen/chosen.jquery.js"></script>
<!-- Input Mask-->
<script src="<%=cdnUrl%>assets/js/plugins/jasny/jasny-bootstrap.min.js"></script>
<!-- Jquery Validate -->
<script
	src="<%=cdnUrl%>assets/js/plugins/validate/jquery.validate.min.js"></script>
<!-- Select2 -->
<script src="<%=cdnUrl%>assets/js/plugins/select2/select2.full.min.js"></script>


<script
	src="<%=cdnUrl%>assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>

<script type="text/javascript">
	var map = {};
	function formatRepo(repo) {
		if (repo.loading)
			return repo.text;

		var markup = "<div class='select2-result-repository clearfix'>"
				+ repo.id + "</div>";

		if (repo.description) {
			markup += "<div class='select2-result-repository__description'>"
					+ repo.id + "</div>";
		}
		return markup;
	}

	function formatRepoSelection(repo) {
		return repo.id;
	}
	$(document)
			.ready(
					function() {
						$("input[name='email'],input[name='mobile']").click(function() {
							$(this).unbind().focusout(function(){
								var current_input =$(this);
								var key = current_input.attr('name');
						        var url = "<%=baseURL%>email_mobile_validator";
						        var value=current_input.val();
								 $.ajax({
								        type: "POST",
								        url: url,
								        data: {key:key,value:value},
								        success: function(data) {
								        	if(data != null && data != 'undefined'){
								        		if(data==='new email'){
									        		$('#email_error').remove();
									        	}
								        		if(data==='new mobile'){
								        			$('#mobile_error').remove();
									        	}
								        		if(data === 'Email already exist'){
								        			$('#email_error').remove();
								        			$(current_input).after('<label id="email_error" class="error">'+data+'</label>');
								        		}
								        		if(data === 'Mobile already exist'){
								        			$('#mobile_error').remove();
								        			$(current_input).after('<label id="mobile_error" class="error">'+data+'</label>');
								        		}
								        	}
								        }		        
								    });
						    });
						});

						$('.signup_button').unbind().click(function() {
							$('#signup_form').submit();
						});

						//$('select').select2();
						$('#data_2 .input-group.date').datepicker({
							startView : 1,
							todayBtn : "linked",
							keyboardNavigation : false,
							forceParse : false,
							autoclose : true,
							format : "dd/mm/yyyy"
						});
						var baseURL = $(".js-data-example-ajax")
								.data("pin_uri");
						var urlPin = baseURL + "PinCodeController";

						$(".js-data-example-ajax")
								.select2(
										{
											ajax : {
												url : urlPin,
												dataType : 'json',
												delay : 250,
												data : function(params) {
													return {
														q : params.term, // search term
														page : params.page
													};
												},
												processResults : function(data,
														params) {
													params.page = params.page || 1;
													return {
														results : data.items,
														pagination : {
															more : (params.page * 30) < data.total_count
														}
													};
												},
												cache : true
											},
											escapeMarkup : function(markup) {
												return markup;
											},
											minimumInputLength : 1,
											templateResult : formatRepo,
											templateSelection : formatRepoSelection
										});
						//$('.js-data-example-ajax').select2();

						$("#signup_form").validate({
							rules : {
								password : {
									required : true,
									minlength : 6
								},

								mobile : {
									required : true,
									minlength : 10,
									maxlength : 10

								}

							}
						});

						$(".select2_demo_1").select2();

						$('.chosen-select').chosen({
							width : "70%"
						});

						$.validator.setDefaults({
							ignore : ":hidden:not(select)"
						});

						// validation of chosen on change
						if ($("select.chosen-select").length > 0) {
							$("select.chosen-select").each(function() {
								if ($(this).attr('required') !== undefined) {
									$(this).on("change", function() {
										$(this).valid();
									});
								}
							});
						}

						$('.course_holder').change(function() {

							$('#session_id').val($(this).val());
						});
						var sThisVal = {};

						$('.chechbox')
								.change(
										function() {
											var row = $(this).parent().parent()
													.children().index(
															$(this).parent());
											var th = $("#mytable thead tr th")
													.eq(row);
											var time = th.text();
											var day = $(this).parent().closest(
													'tr').children('td:first')
													.text();
											if (this.checked) {

												if (sThisVal
														.hasOwnProperty(day))
													sThisVal[day] = sThisVal[day]
															+ '##' + time;
												else
													sThisVal[day] = time;
												console.log(th.text());
												console.log($(this).parent()
														.closest('tr')
														.children('td:first')
														.text());
											} else {
												if (sThisVal
														.hasOwnProperty(day)) {
													var list_of_values = sThisVal[day]
															.split('##');
													var index = list_of_values
															.indexOf(time);
													list_of_values.splice(
															index, 1);
													if (list_of_values.length > 0)
														sThisVal[day] = list_of_values
																.join('##');
													else
														delete sThisVal[day];
												}

											}
											console.log('kahatm');

											//	sThisVal.push($($('.chechbox:checkbox:checked')[i]).val());
											var sThisVal1 = JSON
													.stringify(sThisVal);
											$('#avaiable_time').val(sThisVal1);
										});

						init_form();

					});

	function init_form() {

		$('#ug_degree').unbind().on('change', function() {
			$.ajax({
				type : "GET",
				url : "/student_signup_ui",
				data : {
					type : "ug_degree",
					value : $(this).val()
				},
				success : function(data) {
					if ($(data) != undefined) {
						$('#underGraduationSpecializationName').html(data);
					}
				}
			});
		});

		$('#pg_degree').unbind().on('change', function() {
			$.ajax({
				type : "GET",
				url : "/student_signup_ui",
				data : {
					type : "pg_degree",
					value : $(this).val()
				},
				success : function(data) {
					if ($(data) != undefined) {
						$('#postGraduationSpecializationName').html(data);
					}
				}
			});
		});

		$('.stu_file_uploader').unbind().on('change', function() {
			var file = $(this).prop('files')[0];
			var type = $(this).data('type');
			var urlPath = $(this).data('url');

			if (file != undefined) {

				var data = new FormData();
				data.append('type', type);
				data.append('image', file);
				$.ajax({
					url : '/student_signup_ui',
					data : data,
					cache : false,
					contentType : false,
					processData : false,
					type : 'POST',
					success : function(data) {
						console.log('type : ' + type + '    url----' + data);
						$('#' + urlPath).val(data);
					}
				});
			}else{
				$('#' + urlPath).val('');
			}
		});
	}
</script>

</html>