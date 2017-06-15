<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	DBUTILS util = new DBUTILS();
%>
<body class="top-navigation" id="admin_page">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>

			
			<div class="row">
			<div class="col-lg-12">
                    <div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#tab-1">User Creation</a></li>
                            
                        </ul>
                        <div class="tab-content">
                            <div id="tab-1" class="tab-pane active">
                                <div class="panel-body">
                                    
                                    <div class="row">
            
            <div class="col-lg-5">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Create User</h5>
                           
                        </div>
                        <div class="ibox-content">
                            <form class="form-horizontal" action="/utilies_create_user" method="post">
                               
                                <div class="form-group"><label class="col-lg-2 control-label">First Name</label>
												<div class="col-lg-10"><input type="text" placeholder="First Name" class="form-control" name="first_name"> 
												
                                </div>
                                </div>
                                
                                <div class="form-group"><label class="col-lg-2 control-label">Last Name</label>
												<div class="col-lg-10"><input type="text" placeholder="Last Name" class="form-control" last_name=""> 
												
                                </div>
                                </div>
                                <div class="form-group"><label class="col-lg-2 control-label">Email</label>
                                <div class="col-lg-10"><input type="email" placeholder="Email" class="form-control" name="email"></div>
                                </div>
                                
                                 <div class="form-group"><label class="col-lg-2 control-label">Gender</label>
                                <div class="col-lg-10">
                                <select name="gender">
                                <option value="MALE">MALE</option>
                                <option value="FEMALE">FEMALE</option>
                                </select></div>
                                </div>
                                
                                <div class="form-group"><label class="col-lg-2 control-label">User Type</label>
                                <div class="col-lg-10">
                                <select name="user_role">
                                <%
                                String findRoles = "select id, role_name from role";
                                List<HashMap<String,Object>> roles = util.executeQuery(findRoles);
                                for(HashMap<String,Object> role: roles)
                                {
                                	%>
                                	<option value="<%=role.get("id") %>"><%=role.get("role_name")  %></option>
                                	<%
                                }
                                %>
                                </select>
                                </div>
                                </div>
                                
                                <div class="form-group"><label class="col-lg-2 control-label">Organization</label>
                                <div class="col-lg-10">
                                <select name="user_org">
                                <%
                                String findOrg = "select id , name from organization";
                                List<HashMap<String,Object>> orgs = util.executeQuery(findOrg);
                                for(HashMap<String,Object> org: orgs)
                                {
                                	%>
                                	<option value="<%=org.get("id") %>"><%=org.get("name")  %></option>
                                	<%
                                }
                                %>
                                </select>
                                </div>
                                </div>
                                
                                
                                <div class="form-group">
                                    <div class="col-lg-offset-2 col-lg-10">
                                        <button class="btn btn-sm btn-danger" type="submit">Create User</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            <!-- <div class="col-lg-7">
                <div class="ibox float-e-margins">
                    
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-sm-6 b-r"><h3 class="m-t-none m-b">Sign in</h3>
                                <p>Sign in today for more expirience.</p>
                                <form role="form">
                                    <div class="form-group"><label>Email</label> <input type="email" placeholder="Enter email" class="form-control"></div>
                                    <div class="form-group"><label>Password</label> <input type="password" placeholder="Password" class="form-control"></div>
                                    <div>
                                        <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="submit"><strong>Log in</strong></button>
                                        <label> <div class="icheckbox_square-green" style="position: relative;"><input type="checkbox" class="i-checks" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div> Remember me </label>
                                    </div>
                                </form>
                            </div>
                            <div class="col-sm-6"><h4>Not a member?</h4>
                                <p>You can create an account:</p>
                                <p class="text-center">
                                    <a href=""><i class="fa fa-sign-in big-icon"></i></a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div> -->
                
            </div>											
											</div>
                            </div>
                           
                        </div>


                    </div>
                </div>
			
			</div>
</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="../inc/foot.jsp"></jsp:include>
</body>
</html>
