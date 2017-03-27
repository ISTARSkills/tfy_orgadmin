
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="in.orgadmin.utils.*"%>
<%@page import="java.util.*"%>
<%

String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";

IstarUser user= (IstarUser)request.getSession().getAttribute("user");

OrgadminUtil util = new OrgadminUtil();
ArrayList<College> colleges= util.getOrgInFilter( user,  baseURL);

 %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><div class="col-lg-6" style="margin-top: 10px; max-height: 650px; min-height: 650px">

	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<h5>Current Programs</h5>
			<div class="ibox-tools">
				<a class="collapse-link"> <i class="fa fa-chevron-up"></i>
				</a> <a class="dropdown-toggle" data-toggle="dropdown" href="#"
					aria-expanded="false"> <i class="fa fa-wrench"></i>
				</a>
				<ul id="org_filter_currrentstate" class="dropdown-menu dropdown-user"
					style="width: 301px;">
					<li><a value="None" href="#">Select College</a> <%
										for(College c : colleges){
											String collegeName = c.getName().trim();
											if(collegeName.trim().length()>40) {
												collegeName = collegeName.substring(0,40).trim();
											}
										%> <label style="width: 100%; margin-left: 10px;"> <input
							value="<%=c.getId()%>" checked="checked" type="checkbox"
							class="i-checks"> <%=collegeName.trim()%></label> <%
											}
										%></li>
				</ul>
				<a class="close-link"> <i class="fa fa-times"></i>
				</a>
			</div>
		</div>
		 <div class="ibox-content" style="display: block; max-height: 435px; min-height: 685px;">
				
		
			
			<div class="tabs-container" style="background: #23c6c8" id="dashboard2" >
				<ul class="nav nav-tabs" id="cs_data">
					<li  value= "batchgroup" class="active"><a data-toggle="tab" href="#tab-10">Batch Group</a></li>
					<li  value= "course" class=""><a data-toggle="tab" href="#tab-9">Course</a></li>
				</ul>
				<div class="tab-content" >
					
				
			<div id="tab-10" class="tab-pane active">
			<div class="col-sm-12" id="Bggraph" style="display: inline-block; overflow: auto; max-height: 47em;">
                        
                    </div>
				
			</div>
			<div id="tab-9" class="tab-pane ">
			<div class="col-sm-12" id="cgraph" style="display: inline-block; overflow: auto; max-height: 47em;">
                        
                    </div>
					
						</div>
					</div>
		</div>
	</div>
		</div> 
	</div>
