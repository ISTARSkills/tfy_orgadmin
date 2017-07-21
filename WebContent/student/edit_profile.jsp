<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
IstarUser trainer = (IstarUser)request.getSession().getAttribute("user");	

RestClient rc = new RestClient();
ComplexObject co = rc.getComplexObject(trainer.getId());

String userType = co.getStudentProfile().getUserType();

request.setAttribute("cp", co	);

%><style>
.row {
	margin-right: 0px !important;
	margin-left: 0px !important;
}

.h-370 {
	min-height: 375px !important;
	max-height: 375px !important;
}

.button-top {
	margin-top: -12px !important;
}

.assessment-circle-img {
	width: 50%;
	height: 40%;
}

.session-square-img {
	width: 160px;
	height: 160px;
}

.btn-rounded {
	min-width: 200px;
	background: #eb384f;
	color: white;
}

.task-complete-header {
	background: #23b6f9 !important;
}

#vertical-timeline {
	overflow-x: hidden;
	overflow-y: auto;
	max-height: 250px;
}

.vertical-container {
	width: 99% !important;
}

.vertical-timeline-content p {
	margin-bottom: 2px !important;
	margin-top: 0 !important;
	line-height: 1.6 !important;
}

.content-border {
	border: none !important;
}

.btn.banner:hover {
	color: white !important
}

.nav-tabs>li.active>a:hover, a:focus, a:active {
	border-radius: 50px !important;
}

.btn.banner.focus, .btn.banner:focus, .btn.banner:hover {
	color: white !important;
}
</style>
<body class="top-navigation" id="trainer_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
		<jsp:include page="inc/navbar.jsp"></jsp:include>
		<div class="row">
				
				
				<div class="row wrapper border-bottom white-bg page-heading" style="padding-bottom: 10px;
    padding-left: 20px;">
					 <div class="col-lg-10">
                    <h2>Profile</h2>
                    <ol class="breadcrumb">
                        <li>
                            <a href="dashboard.jsp">Dashboard</a>
                        </li>
                        <li class="active">
                            <strong>Profile</strong>
                        </li>
                    </ol>
                </div>
                <div class="col-lg-2">
<div class="pull-right" style=" margin-top: 18px;margin-right: 80px;">
                  <button type="button" class="btn btn-sm btn-primary m-t-n-xs signup_button">Update Details</button>
               </div>
                </div>
					
				</div>
				<jsp:include page="/trainer_common_jsps/profile_and_signup.jsp">
				<jsp:param value="<%=userType %>" name="user_type"/>
				<jsp:param value="<%=trainer.getId()%>" name="user_id"/>
				</jsp:include>
				
			</div>
			
			

		</div>
		
		
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
</body>

<script type="text/javascript">
	var map = {};
	
var sThisVal = {};
	
	function getAllcheckeddata(){
		var sThisVal1;
		$('input[type=checkbox]').each(function () {
		   // yourArray.push($(this).val());
		 //  console.log('>>>>>'+$(this).val());
	 if (this.checked) {
		    
		    
 var row = $(this).parent().parent().children().index($(this).parent());
	var th = $("#mytable thead tr th")
			.eq(row);
	var time = th.text();
	var day = $(this).parent().closest('tr').children('td:first').text();
	if (this.checked) {

		if (sThisVal.hasOwnProperty(day))
			sThisVal[day] = sThisVal[day]+ '##' + time;
		else
			sThisVal[day] = time;
		//console.log(th.text());
		//console.log($(this).parent().closest('tr').children('td:first').text());
	} else {
		if (sThisVal.hasOwnProperty(day)) {
			var list_of_values = sThisVal[day].split('##');
			var index = list_of_values.indexOf(time);
			list_of_values.splice(index, 1);
			if (list_of_values.length > 0)
				sThisVal[day] = list_of_values.join('##');
			else
				delete sThisVal[day];
		}

	}
	
	 sThisVal1 = JSON.stringify(sThisVal);
	
	 $('#avaiable_time').val(sThisVal1);
	 }
	});
		

		    
	}
	
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

	function check_cluster_validation(){
		var flag =false;
		$( ".cluster_button" ).each(function() {
			  if($(this).hasClass('active')){
			  console.log($(this).data('id'));
			  flag = true;
			  }
		  });
		
		if($( ".cluster_button" ).length==0){
			flag=true;
		}
		
		return flag;
	}
	
	function check_time_slot_validation(){
		var flag =false;
		if($('.checkbox').length > 0){
		$('.chechbox').each(function(){
			if($(this).prop('checked')){
				flag = true;
			}
		});
	}else{
		flag = true;
	}
		return flag;
	}
	function formatRepoSelection(repo) {
		return repo.id;
	}
	$(document)
			.ready(
					function() {
						
						$('.signup_button').unbind().click(function() {
							
							 if($('#signup_form').valid()){	 
							  if(check_cluster_validation() && check_time_slot_validation()){
								  console.log('validation sucess');
								  $('#signup_form').submit();
							  }else{
								  console.log('validation falil');
								  swal({
						                title: "Please select atleast one Cluster and time slot",
						                type: "warning",
						                confirmButtonColor: "#eb384f"
						                //text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
						            });


							  }
							 }
						});
						getAllcheckeddata();
						//$('select').select2();
						var selected_cluster = [];
						//selected_cluster = $('#cluster-table button.active').attr('id');
						//console.log("selected_cluster   "+selected_cluster);
						$('.cluster_button').each(function() {
							if($(this).hasClass('active')){
								selected_cluster.push($(this).data('id'));
							}
						});
						
						$('.cluster_button').unbind().click(function() {
							//alert('abc');
							 if($(this).hasClass('btn-default')){
								 
								selected_cluster.push($(this).data('id'));
								$(this).addClass('btn-primary');
								$(this).removeClass('btn-default');
							}else{
								$(this).removeClass('btn-primary');
								$(this).addClass('btn-default');
								var i = selected_cluster.indexOf($(this).data('id'));
								if(i != -1) {
									selected_cluster.splice(i, 1);
								}

							} 
							console.log('idssss--- '+selected_cluster.join(','));
							
							$('#submit_cluster').val(selected_cluster.join(','));
						});
						
						$('#data_2 .input-group.date').datepicker({
		startView : 1,
		todayBtn : "linked",
		keyboardNavigation : false,
		forceParse : false,
		autoclose : true,
		format : "dd/mm/yyyy"
	});
						var baseURL = $(".js-data-example-ajax").data("pin_uri");
						var urlPin = baseURL + "PinCodeController";

						$(".js-data-example-ajax").select2({
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
								processResults : function(data, params) {
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
			                 rules: {
			                     password: {
			                         required: true,
			                         minlength: 8
			                     },
			                    
			                   
			                     mobile: {
			                         required: true,
			                         minlength: 10,
			                         maxlength: 10

			                        
			                     }
			                  
			                 }
			             });
						 
						 $(".select2_demo_1").select2();


						/* $('.chosen-select').chosen({
							width : "70%"
						}); */
						
						$.validator.setDefaults({ ignore: ":hidden:not(select)" });

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
						$('.course_holder').select2();
						$('.course_holder').change(function() {

							$('#session_id').val($(this).val());
						});
						

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

					});

	function trainerPlace(markerId, formatted_address) {

		if (formatted_address === undefined) {
			delete map[markerId];
			$("#id_"+markerId.replace('.','_').replace('.','_')).remove();
		} else {
			map[markerId] = formatted_address;
			
			var txt = "<p id='id_"+markerId.replace('.','_').replace('.','_')+"'><b>Address:</b> "+formatted_address+"</p>"; 
			 $("#address_view").append(txt);
		}

		var map1 = JSON.stringify(map);
		$('#teaching_address').val(map1);
		
		
		
	}
	function myMap() {
		var map;

		var myOptions = {
			zoom : 7,
			center : new google.maps.LatLng(12.97, 77.59),
			mapTypeId : 'roadmap'
		};
		map = new google.maps.Map($('#googleMap')[0], myOptions);

		var markers = {};
		var getMarkerUniqueId = function(lat, lng) {
			return lat + '_' + lng;
		}

		/**
		 * Creates an instance of google.maps.LatLng by given lat and lng values and returns it.
		 * This function can be useful for getting new coordinates quickly.
		 * @param {!number} lat Latitude.
		 * @param {!number} lng Longitude.
		 * @return {google.maps.LatLng} An instance of google.maps.LatLng object
		 */
		var geocoder = new google.maps.Geocoder();

		function coordinates_to_address(lat, lng) {
			var latlng = new google.maps.LatLng(lat, lng);

			geocoder.geocode({
				'latLng' : latlng
			}, function(results, status) {
				if (status == google.maps.GeocoderStatus.OK) {
					// alert('result '+results[0].formatted_address);

					var markerId = getMarkerUniqueId(lat, lng);
					var formatted_address = results[0].formatted_address;

					trainerPlace(markerId, formatted_address);

					//  $('#teaching_address').val(markerId+':'+formatted_address);

				} else {
					//alert('error --> ');

				}
			});
		}
		var getLatLng = function(lat, lng) {
			//alert('lat --> '+lat +' long --> '+lng);
			coordinates_to_address(lat, lng);
			return new google.maps.LatLng(lat, lng);
		};

		var addMarker = google.maps.event.addListener(map, 'click',
				function(e) {
					var lat = e.latLng.lat(); // lat of clicked point
					var lng = e.latLng.lng(); // lng of clicked point
					var markerId = getMarkerUniqueId(lat, lng); // an that will be used to cache this marker in markers object.
					var marker = new google.maps.Marker({
						position : getLatLng(lat, lng),
						map : map,
						id : 'marker_' + markerId
					});
					markers[markerId] = marker; // cache marker in markers object
					bindMarkerEvents(marker); // bind right click event to marker
				});
		var bindMarkerEvents = function(marker) {
			google.maps.event.addListener(marker, "rightclick",
					function(point) {
						var markerId = getMarkerUniqueId(point.latLng.lat(),
								point.latLng.lng()); // get marker id by using clicked point's coordinate
						var marker = markers[markerId]; // find marker
						removeMarker(marker, markerId); // remove it
					});
		};

		/**
		 * Removes given marker from map.
		 * @param {!google.maps.Marker} marker A google.maps.Marker instance that will be removed.
		 * @param {!string} markerId Id of marker.
		 */
		var removeMarker = function(marker, markerId) {

			trainerPlace(markerId);
			marker.setMap(null); // set markers setMap to null to remove it from map
			delete markers[markerId]; // delete marker instance from markers object

		};
		document.getElementById('submit').addEventListener('click', function() {
	          geocodeAddress(geocoder, map);
	        });
		
		 function geocodeAddress(geocoder, resultsMap) {
		        var address = document.getElementById('address').value;
		        geocoder.geocode({'address': address}, function(results, status) {
		          if (status === 'OK') {
		            resultsMap.setCenter(results[0].geometry.location);
		            var marker = new google.maps.Marker({
		              map: resultsMap,
		              position: results[0].geometry.location
		            });
		            
		            var markerId = getMarkerUniqueId(results[0].geometry.location.lat(), results[0].geometry.location.lng());
		            coordinates_to_address(results[0].geometry.location.lat(), results[0].geometry.location.lng());
		            markers[markerId] = marker; 
		            bindMarkerEvents(marker);
		          } else {
		            alert('Geocode was not successful for the following reason: ' + status);
		          }
		        });
		      }

	}
	
	
</script>

</html>
