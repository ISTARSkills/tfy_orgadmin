<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%
String url = request.getRequestURL().toString();
String userType = request.getParameter("user_type");
IstarUser user = null;
String actionUrl="user_signup";
if(request.getParameterMap().containsKey("user_id") && request.getParameter("user_id")!=null)
{
	user = new IstarUserDAO().findById(Integer.parseInt(request.getParameter("user_id")));
	actionUrl = "profile_update";
}	
String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";	
DBUTILS db = new DBUTILS();

SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

%>

				<div class="col-lg-6">
					<div class="ibox float-e-margins">

						<div class="ibox-content">
							<form class="form-horizontal" id="signup_form" action="<%=baseURL%><%=actionUrl%>" method="post">
							<input type="hidden" id="teaching_address" name="teaching_address" value="">
								<input type="hidden" id="user_type" name="user_type" value="<%=userType%>">
								<%if(user!=null){ %>
								<input type="hidden" id="user_id" name="user_id" value="<%=user.getId()%>">
								<%} %>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">First Name:</label>
										<div class="col-sm-8">
											<input type="text" placeholder="First Name" name="f_name" value ="<%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getFirstName()!=null){%><%=user.getUserProfile().getFirstName() %><%} %>" required class="form-control">
										</div>
									</div>

								</div>

								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">Last Name:</label>

										<div class="col-sm-8">
											<input type="text" required placeholder="Last Name" name="l_name" value ="<%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getLastName()!=null){%><%=user.getUserProfile().getLastName() %><%} %>" class="form-control">
										</div>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">Gender:</label>

										<div class="col-sm-8">
											<select class="form-control m-b" required name="gender">
												<option value="FEMALE" <%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getGender()!=null && user.getUserProfile().getGender().equalsIgnoreCase("FEMALE")){%>selected<%}%>>FEMALE</option>
												<option value="MALE" <%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getGender()!=null && user.getUserProfile().getGender().equalsIgnoreCase("MALE")){%>selected<%}%>>MALE</option>

											</select>
										</div>
									</div>

								</div>
								
								
								<div class="col-lg-12">

 
 <div class="form-group" id="data_2">
				<label class="col-sm-4 control-label">Date of Birth</label>
				<div class="input-group date col-sm-8">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						name="dob" type="text" class="form-control date_holder"
						value ="<%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getDob()!=null){%><%=df.format(user.getUserProfile().getDob()) %><%}%>">
				</div>
			</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-lg-4 control-label">Email:</label>
										<%
										String dis ="";
										if(user!=null)
										{
											dis ="disabled";
										}	
										%>
										<div class="col-lg-8">
											<input type="email"  required placeholder="Email" name="email" class="form-control" value="<%if(user!=null && user.getEmail()!=null){%><%=user.getEmail() %><%}%>">
										</div>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-lg-4 control-label">Password:</label>

										<div class="col-lg-8">
											<input type="password" required name="password" placeholder="Password" class="form-control" value="<%if(user!=null && user.getPassword()!=null){%><%=user.getPassword()
											%><%}%>">
										</div>
									</div>
								</div>

								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">Mobile Number:</label>

										<div class="col-sm-8">
											<input type="number" required placeholder="Mobile Number" name="mobile" class="form-control" value="<%if(user!=null && user.getMobile()!=null){%><%=user.getMobile()
											%><%}%>">
										</div>
									</div>

								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">Address Line 1:</label>

										<div class="col-sm-8">
											<input type="text" required placeholder="Address Line 1" name="address_line1" class="form-control" value="<%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getAddress()!=null && user.getUserProfile().getAddress().getAddressline1()!=null){%><%=user.getUserProfile().getAddress().getAddressline1() %>   <%} %>">
										</div>
									</div>

								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">Address Line 2:</label>

										<div class="col-sm-8">
											<input type="text" required placeholder="Address Line 2" name="address_line2" class="form-control" value="<%if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getAddress()!=null && user.getUserProfile().getAddress().getAddressline2()!=null){%><%=user.getUserProfile().getAddress().getAddressline2() %>   <%} %>">
										</div>
									</div>

								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">PinCode:</label>


										<div class="col-sm-8">
											<select class="js-data-example-ajax  form-control" data-pin_uri="<%=baseURL%>" name="pincode" data-validation="required" required>
												<option value="">Select Pincode</option>
												<%
												if(user!=null && user.getUserProfile()!=null && user.getUserProfile().getAddress()!=null && user.getUserProfile().getAddress().getPincode()!=null)
												{
													%>
													<option value="<%=user.getUserProfile().getAddress().getPincode().getPin()%>" selected><%=user.getUserProfile().getAddress().getPincode().getPin()%> </option>
													<%
												}
												
												%>
											</select>
										</div>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">UG Degree Name:</label>
										<div class="col-sm-8">
											<select class="form-control m-b" required name="ug_degree">
												<option value="">Select UG Degree</option>
												<%
												if(user!=null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getUnderGraduateDegreeName()!=null)
												{	
												%>
													<option selected value="<%=user.getProfessionalProfile().getUnderGraduateDegreeName()%>"><%=user.getProfessionalProfile().getUnderGraduateDegreeName() %></option>	
												<%
												}
												%>
												<option value="BTECH">BTECH</option>
												<option value="BA">BA</option>
												<option value="BCOM">BCOM</option>
												<option value="BBM">BBM</option>
												<option value="BSC">BSC</option>
												<option value="BE">BE</option>
												<option value="BBA">BBA</option>
												<option value="BED">BED</option>
												<option value="BSW">BSW</option>
												<option value="BCA">BCA</option>
												<option value="OTHERS">OTHERS</option>
											</select>
										</div>
									</div>

								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">PG Degree Name:</label>

										<div class="col-sm-8">
											<select class="form-control m-b" name="pg_degree">
												<option value="">Select PG Degree</option>
												<%
												if(user!=null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getPgDegreeName()!=null)
												{	
												%>
													<option selected value="<%=user.getProfessionalProfile().getPgDegreeName()%>"><%=user.getProfessionalProfile().getPgDegreeName() %></option>	
												<%
												}
												%>
												<option value="MTECH">MTECH</option>
												<option value="MA">MA</option>
												<option value="MCOM">MCOM</option>
												<option value="MTECH">MTECH</option>
												<option value="MCOM">MCOM</option>
												<option value="MBA">MBA</option>
												<option value="ME">ME</option>
												<option value="MCA">MCA</option>
												<option value="MSW">MSW</option>
												<option value="OTHERS">OTHERS</option>
											</select>
										</div>
									</div>
								</div>

<%if(userType.equalsIgnoreCase("TRAINER")){ %>
								<div class="col-lg-12">
									<div class="form-group form-inline">
										<label class="col-sm-4 control-label">Experience:</label>

										<div class="col-sm-3 ">
											<input type="number" placeholder="year" name="experince_years" class="form-control" value="<%if(user!=null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getExpereinceInYears()!=null ){%><%=user.getProfessionalProfile().getExpereinceInYears().trim()%><%}%>">
										</div>
										<div class="col-sm-3 ">
											<input type="number" placeholder="month" name="experince_months" class="form-control" value="<%if(user!=null && user.getProfessionalProfile()!=null && user.getProfessionalProfile().getExperienceInMonths()!=null ){%><%=user.getProfessionalProfile().getExperienceInMonths().trim() %><%}%>">
										</div>
									</div>

								</div>

								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-4 control-label">Interested Course:</label> <input type="hidden" id="session_id" name="session_id" value="">
										<div class="col-sm-8" style="margin-left: 0px">


											<%
											String course_sql = "select distinct  course.id, course_name from course, course_assessment_mapping		where course_assessment_mapping.course_id = course.id ";

											List<HashMap<String, Object>> data1 = db.executeQuery(course_sql);
											ArrayList<Integer> alreadyIntrestedCouorse = new ArrayList();
											if(user!=null){
												String getAlreadySelectedInterestedCourse ="select course_id from trainer_intrested_course where trainer_id="+user.getId();
												List<HashMap<String, Object>> selectedIntrested = db.executeQuery(getAlreadySelectedInterestedCourse);
												for(HashMap<String, Object> row : selectedIntrested)
												{
													int course_id = (int)row.get("course_id");
													alreadyIntrestedCouorse.add(course_id);
												}
											}
											%>
											<select data-placeholder="Choose a Course..." class="chosen-select course_holder" multiple style="width: 350px;" tabindex="4" name="course">
												<%
												if (data1.size() > 0) {
													for (HashMap<String, Object> row1 : data1) {
														String selected ="";
														if(alreadyIntrestedCouorse.contains((int)row1.get("id")))
														{
															selected ="selected";
														}
											%>
												<option value="<%=row1.get("id")%>" <%=selected %>><%=row1.get("course_name")%></option>
											<%
												}
												}
											%>
											</select>
										</div>
									</div>
								</div>
								<div class="col-lg-12">
									<label class="col control-label">Available Time Slots:</label> <input type="hidden" id="avaiable_time" name="avaiable_time" value=""><br />
									<br />
									<%
									HashMap<String, HashMap<Integer, Boolean>> slotData = new HashMap();
									if(user!=null)
									{
										String slots ="select * from trainer_available_time_sloat where trainer_id = "+user.getId();	
										List<HashMap<String,Object>> sl = db.executeQuery(slots);
										for(HashMap<String,Object> row: sl)
										{
											String day = row.get("day").toString();
											HashMap<Integer,Boolean> timeSlot = new HashMap();
											timeSlot.put(1, (boolean)row.get("t8am_9am"));
											timeSlot.put(2, (boolean)row.get("t9am_10am"));
											timeSlot.put(3, (boolean)row.get("t10am_11am"));
											timeSlot.put(4, (boolean)row.get("t11am_12pm"));
											timeSlot.put(5, (boolean)row.get("t12pm_1pm"));
											timeSlot.put(6, (boolean)row.get("t1pm_2pm"));
											timeSlot.put(7, (boolean)row.get("t2pm_3pm"));
											timeSlot.put(8, (boolean)row.get("t3pm_4pm"));
											timeSlot.put(9, (boolean)row.get("t4pm_5pm"));
											timeSlot.put(10, (boolean)row.get("t5pm_6pm"));
											slotData.put(day.toUpperCase(),timeSlot);
										}
									}
									%>
									
									<table class="table table-bordered" id='mytable' style="    margin-left: -20px;">
										<thead>
											<tr>
												<th>Days</th>
												<th>8:00 AM-9:00 AM</th>
												<th>9:00 AM-10:00 AM</th>
												<th>10:00 AM-11:00 AM</th>
												<th>11:00 AM-12:00 PM</th>
												<th>12:00 PM-1:00 PM</th>
												<th>1:00 PM-2:00 PM</th>
												<th>2:00 PM-3:00 PM</th>
												<th>3:00 PM-4:00 PM</th>
												<th>4:00 PM-5:00 PM</th>
												<th>5:00 PM-6:00 PM</th>

											</tr>
										</thead>
										<tbody>
											<tr>
												<td>Monday</td>
												<td style="text-align: center;"><input class="chechbox" id="monday1" type="checkbox" value="monday#&8:00 AM-9:00 AM!&" <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(1)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday2" type="checkbox" value="monday#&9:00 AM-10:00 AM!&" <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(2)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday3" type="checkbox" value="monday#&10:00 AM-11:00 AM!&" <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(3)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday4" type="checkbox" value="monday#&11:00 AM-12:00 PM!&" <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(4)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday5" type="checkbox" value="monday#&12:00 PM-1:00 PM!&"  <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(5)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday6" type="checkbox" value="monday#&1:00 PM-2:00 PM!&"  <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(6)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday7" type="checkbox" value="monday#&2:00 PM-3:00 PM!&"  <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(7)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday8" type="checkbox" value="monday#&3:00 PM-4:00 PM!&"  <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(8)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday9" type="checkbox" value="monday#&4:00 PM-5:00 PM!&"  <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(9)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="monday10" type="checkbox" value="monday#&5:00 PM-6:00 PM!&"  <%if(slotData.get("MONDAY")!=null && slotData.get("MONDAY").get(10)){%>checked<%} %>></td>
											</tr>
											<tr>
												<td>Tuesday</td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday1" type="checkbox" value="tuesday#&8:00 AM-9:00 AM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(1)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday2" type="checkbox" value="tuesday#&9:00 AM-10:00 AM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(2)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday3" type="checkbox" value="tuesday#&10:00 AM-11:00 AM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(3)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday4" type="checkbox" value="tuesday#&11:00 AM-12:00 PM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(4)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday5" type="checkbox" value="tuesday#&12:00 PM-1:00 PM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(5)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday6" type="checkbox" value="tuesday#&1:00 PM-2:00 PM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(6)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday7" type="checkbox" value="tuesday#&2:00 PM-3:00 PM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(7)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday8" type="checkbox" value="tuesday#&3:00 PM-4:00 PM" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(8)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday9" type="checkbox" value="tuesday#&4:00 PM-5:00 PM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(9)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="tuesday10" type="checkbox" value="tuesday#&5:00 PM-6:00 PM!&" <%if(slotData.get("TUESDAY")!=null && slotData.get("TUESDAY").get(10)){%>checked<%} %>></td>
											</tr>
											<tr>
												<td>Wednesday</td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday1" type="checkbox" value="wednesday#&8:00 AM-9:00 AM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(1)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday2" type="checkbox" value="wednesday#&9:00 AM-10:00 AM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(2)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday3" type="checkbox" value="wednesday#&10:00 AM-11:00 AM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(3)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday4" type="checkbox" value="wednesday#&11:00 AM-12:00 PM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(4)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday5" type="checkbox" value="wednesday#&12:00 PM-1:00 PM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(5)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday6" type="checkbox" value="wednesday#&1:00 PM-2:00 PM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(6)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday7" type="checkbox" value="wednesday#&2:00 PM-3:00 PM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(7)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday8" type="checkbox" value="wednesday#&3:00 PM-4:00 PM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(8)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday9" type="checkbox" value="wednesday#&4:00 PM-5:00 PM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(9)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="wednesday10" type="checkbox" value="wednesday#&5:00 PM-6:00 PM!&" <%if(slotData.get("WEDNESDAY")!=null && slotData.get("WEDNESDAY").get(10)){%>checked<%} %>></td>
											</tr>
											<tr>
												<td>Thrusday</td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday1" type="checkbox" value="thrusday#&8:00 AM-9:00 AM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(1)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday2" type="checkbox" value="thrusday#&9:00 AM-10:00 AM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(2)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday3" type="checkbox" value="thrusday#&10:00 AM-11:00 AM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(3)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday4" type="checkbox" value="thrusday#&11:00 AM-12:00 PM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(4)){%>checked<%} %>></td>

												<td style="text-align: center;"><input class="chechbox" id="thrusday5" type="checkbox" value="thrusday#&12:00 PM-1:00 PM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(5)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday6" type="checkbox" value="thrusday#&1:00 PM-2:00 PM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(6)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday7" type="checkbox" value="thrusday#&2:00 PM-3:00 PM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(7)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday8" type="checkbox" value="thrusday#&3:00 PM-4:00 PM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(8)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday9" type="checkbox" value="thrusday#&4:00 PM-5:00 PM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(9)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="thrusday10" type="checkbox" value="thrusday#&5:00 PM-6:00 PM!&" <%if(slotData.get("THURSDAY")!=null && slotData.get("THURSDAY").get(10)){%>checked<%} %>></td>

											</tr>
											<tr>
												<td>Friday</td>
												<td style="text-align: center;"><input class="chechbox" id="friday1" type="checkbox" value="friday#&8:00 AM-9:00 AM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(1)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday2" type="checkbox" value="friday#&9:00 AM-10:00 AM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(2)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday3" type="checkbox" value="friday#&10:00 AM-11:00 AM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(3)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday4" type="checkbox" value="friday#&11:00 AM-12:00 PM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(4)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday5" type="checkbox" value="friday#&12:00 PM-1:00 PM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(5)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday6" type="checkbox" value="friday#&1:00 PM-2:00 PM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(6)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday7" type="checkbox" value="friday#&2:00 PM-3:00 PM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(7)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday8" type="checkbox" value="friday#&3:00 PM-4:00 PM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(8)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday9" type="checkbox" value="friday#&4:00 PM-5:00 PM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(9)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="friday10" type="checkbox" value="friday#&5:00 PM-6:00 PM!&" <%if(slotData.get("FRIDAY")!=null && slotData.get("FRIDAY").get(10)){%>checked<%} %>></td>
											</tr>
											<tr>
												<td>Saturday</td>
												<td style="text-align: center;"><input class="chechbox" id="saturday1" type="checkbox" value="saturday#&8:00 AM-9:00 AM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(1)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday2" type="checkbox" value="saturday#&9:00 AM-10:00 AM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(2)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday3" type="checkbox" value="saturday#&10:00 AM-11:00 AM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(3)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday4" type="checkbox" value="saturday#&11:00 AM-12:00 PM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(4)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday5" type="checkbox" value="saturday#&12:00 PM-1:00 PM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(5)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday6" type="checkbox" value="saturday#&1:00 PM-2:00 PM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(6)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday7" type="checkbox" value="saturday#&2:00 PM-3:00 PM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(7)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday8" type="checkbox" value="saturday#&3:00 PM-4:00 PM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(8)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday9" type="checkbox" value="saturday#&4:00 PM-5:00 PM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(9)){%>checked<%} %>></td>
												<td style="text-align: center;"><input class="chechbox" id="saturday10" type="checkbox" value="saturday#&5:00 PM-6:00 PM!&" <%if(slotData.get("SATURDAY")!=null && slotData.get("SATURDAY").get(10)){%>checked<%} %>></td>
											</tr>
										</tbody>
									</table>
								</div>
<%
}
%>
								<div class="form-group">
									<div class="" style="float: right;margin-right: 20px">
										<button class="btn btn-sm btn-primary m-t-n-xs" type="submit">Update Details</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				
				<%if(userType.equalsIgnoreCase("TRAINER"))
					{%>
				<div class="col-lg-6">
					</br> <label class="col-sm-6 control-label">Mark the preferred College or Center locations:</label>
					<div id="floating-panel">
						<input id="address" type="textbox" value=""> <input id="submit" type="button" value="Search">
					</div>
					<div id="googleMap" style="width: 100%; height: 82vh;"></div>

					<div style="margin: 28px;" id="address_view"></div>

				</div>
				<%
					}
				%>