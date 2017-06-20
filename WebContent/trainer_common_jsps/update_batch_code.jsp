<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%
String url = request.getRequestURL().toString();

String userId = request.getParameter("user_id");


String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";	
DBUTILS db = new DBUTILS();

SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

%>

				<div class="col-lg-6">
					<div class="ibox float-e-margins">

						<div class="ibox-content" style="    height: 116px;">
							<form class="form-horizontal" id="edit_batch_code" action="<%=baseURL%>edit_batch_code" method="post">
							<%
							DBUTILS util = new DBUTILS();
							String checkIfBatchCodeExist ="select batch_group.name, batch_group.batch_code from batch_group, batch_students where batch_group.id = batch_students.batch_group_id and batch_students.student_id = "+userId+" and batch_group.is_primary = 't'";
							List<HashMap<String,Object>> batchCodeDetails = util.executeQuery(checkIfBatchCodeExist);
							if(batchCodeDetails.size()>0)
							{
								String groupName =  batchCodeDetails.get(0).get("name").toString();
								String code  = batchCodeDetails.get(0).get("batch_code").toString();
								%>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-2 control-label">Primary Group Name:</label>
										<div class="col-sm-5">
											<input type="text" disabled value="<%=groupName %>"  required class="form-control">
										</div>
									</div>

								</div>
								
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-2 control-label">Batch Code:</label>
										<div class="col-sm-5">
											<input type="text" disabled value ="<%=code%>"  required class="form-control">
										</div>
									</div>

								</div>
								<% 
							}
							else
							{
								%>
								<input type="hidden" id="user_id" name="user_id" value="<%=userId%>">								
								<div class="col-lg-12">
									<div class="form-group">
										<label class="col-sm-2 control-label">Batch Code:</label>
										<div class="col-sm-5">
											<input type="text" placeholder="Enter Batch Code" name="batch_code"  required class="form-control">
										</div>
									</div>

								</div>

								

								<div class="form-group">
									<div class="col-lg-offset-2 col-lg-10">
										<button class="btn btn-sm btn-primary m-t-n-xs" type="submit">Sign in</button>
									</div>
								</div>
								<% 
							}	
							
							%>
								
								
								
							</form>
						</div>
					</div>
				</div>
				
				