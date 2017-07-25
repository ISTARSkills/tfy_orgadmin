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
                            <li ><a data-toggle="tab" href="#tab-trainers">Trainers</a></li>
                            <li ><a data-toggle="tab" href="#tab-master_trainers">Master Trainers</a></li>
                            
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
            
                
            </div>											
											</div>
                            </div>
                           <div id="tab-trainers" class="tab-pane">
                                <div class="panel-body">
                                    
                                    <div class="row">
                                    <div class="ibox-content">

                        <table class="table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>First Name</th>
                                <th>Email</th>
                                <th>Roles</th>
                                <th>Presentor</th>
                                <th>Action</th>
                                
                            </tr>
                            </thead>
                            <tbody>
                            <%
                           
                            String findTrainers = "select T1.*, COALESCE(user_profile.first_name,'NA') as fname, string_agg(role.role_name,', ') as roles ,string_agg(cast (role.id as varchar),', ') as role_ids , trainer_presentor.presentor_id from (select distinct istar_user.id , istar_user.email, istar_user.mobile from istar_user, user_role where istar_user.id = user_role.user_id and user_role.role_id in (select id from role where role_name='TRAINER') )T1 left join user_profile on (user_profile.user_id = T1.id) left join user_role on (user_role.user_id = T1.id) left join role on (role.id = user_role.role_id) left join trainer_presentor on (trainer_presentor.trainer_id = T1.id) group by T1.id, email, mobile, first_name,trainer_presentor.presentor_id order by fname";
                            List<HashMap<String	,Object>> trainerData = util.executeQuery(findTrainers);
                            String findAllRoles = "select id, role_name from role";
                            List<HashMap<String	,Object>> roleData = util.executeQuery(findAllRoles);
                            
                            
                            for(HashMap<String	,Object> row: trainerData)
                            {
                            	int trainerId =(int)row.get("id");
                            	String email = row.get("email").toString();
                            	String mobile = "";
                            	if(row.get("mobile")!=null)
                            	{
                            		mobile =row.get("mobile").toString();
                            	}
                            	String fname = row.get("fname").toString();	
                            	String roleses = row.get("roles").toString();
                            	String presentor="";
                            	if(row.get("presentor_id")!=null)
                            	{
                            		presentor = row.get("presentor_id").toString();
                            	}
                            	else
                            	{
                            		presentor ="<a class='btn btn-primary btn-xs' href ='"+ baseURL+"create_presentor?trainer_id="+trainerId+"'>Create Presentor</a>";
                            	}
                            	String roleIds = row.get("role_ids").toString();
                            	%>
                            	
                            	<tr>
                            	<td><%=trainerId %></td>
                            	<td><%=fname %></td>
                            	<td><%=email %></td>
                            	<td><%=roleses %></td>
                            	<td><%=presentor %></td>
                            	<td><a class='btn btn-primary btn-xs' href ='#edit_roles_<%=trainerId%>' data-toggle="modal">Edit Roles</a>
                            	 &nbsp;&nbsp;<a class='btn btn-primary btn-xs' href ='<%=baseURL%>delete_trainer?trainer_id=<%=trainerId%>'>Delete User</a>
                            	 <div id="edit_roles_<%=trainerId%>" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12 b-r"><h3 class="m-t-none m-b">Add / Remove Roles</h3>
<form role="form" action="<%=baseURL %>alter_roles" method="post">
                                                        <div class="form-group"><label>Roles</label> 
                                                      	<select name="roles" multiple>
                                                      	
                                                      	<%for(HashMap<String	,Object> rowRole: roleData)
                                                      	{
                                                      		int roleId = (int)rowRole.get("id");
                                                      		String selected ="";
                                                      		if(roleIds.contains(roleId+""))
                                                      		{
                                                      			selected="selected";
                                                      		}
                                                      		%>
                                                      		<option value="<%=roleId%>" <%=selected %>><%=rowRole.get("role_name")%> </option>
                                                      		<% 
                                                      	}	%>
                                                      	
                                                      	</select>
                                                        </div>
                                                        
                                                        <input type="hidden" name="user_id" value="<%=trainerId%>">
                                                        <div>
                                                            <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="submit"><strong>Save Changes</strong></button>
                                                           
                                                        </div>
                                                    </form>
                                                </div>
                                                
                                        </div>
                                    </div>
                                    </div>
                                </div>
                                    
                                    
                                    </div>
                            	 </td>
                            	</tr>
                            	
                            	<%
                            }	
                            %>
                            
                                    </tbody>
                                    </table>
                                    </div>
                                    
                                    
                                    </div>
                                    
                                    
                                    </div>
                                    <div id="tab-master_trainers" class="tab-pane">
                                    <div class="panel-body">                                    
                                    <div class="row">
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
	<script type="text/javascript">
	$(document).ready()
	{
		$('select').select2();
	}
	</script>
</body>
</html>
