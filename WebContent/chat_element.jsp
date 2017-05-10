<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
IstarUser user = (IstarUser) session.getAttribute("user");
String userRole = user.getUserRoles().iterator().next().getRole().getRoleName();
List<HashMap<String,Object>> orgList = new ArrayList();
List<HashMap<String,Object>> groupList = new ArrayList();
List<HashMap<String,Object>> userList = new ArrayList();

DBUTILS util = new DBUTILS();
if(userRole.equalsIgnoreCase("SUPER_ADMIN"))
{
	String getListOfOrg = "SELECT user_role.user_id AS ID, ROLE .role_name, organization. NAME, org_type, ( CASE WHEN image IS NULL THEN 'video/android_images/' || SUBSTRING (TRIM(NAME) FROM 1 FOR 1) || '.png' ELSE image END ) AS image FROM organization, user_org_mapping, user_role, ROLE WHERE user_role.role_id = ROLE . ID AND organization. ID = user_org_mapping.organization_id AND user_org_mapping.user_id = user_role.user_id AND user_role.role_id IN (8, 15) GROUP BY user_role.user_id, organization. NAME, org_type, image, role_name ORDER BY NAME;  ";
	orgList = util.executeQuery(getListOfOrg);		

	String getBatchGroups="SELECT batch_group. ID, trim(batch_group. NAME) || ' ('||batch_group.type||')' as name, 'video/android_images/' || SUBSTRING ( TRIM (batch_group. NAME) FROM 1 FOR 1 ) || '.png' AS image FROM batch_group GROUP BY batch_group. ID, batch_group. NAME, image order by trim(batch_group. NAME) ";
	groupList = util.executeQuery(getBatchGroups);	

	String getUsers="SELECT istar_user.id, user_profile.first_name ,user_profile.profile_image, istar_user.email , count(chat_messages) as chat_count FROM chat_messages, istar_user, user_profile WHERE istar_user.id = user_profile.user_id AND chat_messages.receiver_id = istar_user.ID AND chat_messages.user_id IN (SELECT  user_role.user_id  FROM user_role WHERE user_role.role_id=13) AND chat_messages.receiver_id NOT IN (SELECT  user_role.user_id  FROM user_role WHERE user_role.role_id=8) AND sent='f' group by istar_user.id, user_profile.first_name ,user_profile.profile_image, istar_user.email "; 
	userList = util.executeQuery(getUsers);
}
else if(userRole.equalsIgnoreCase("ORG_ADMIN"))
{
	String getListOfOrg = "SELECT 	* FROM 	( 		SELECT 			user_role.user_id AS ID, 			ROLE .role_name, 			organization. NAME, 			org_type, 			( 				CASE 				WHEN image IS NULL THEN 					'video/android_images/' || SUBSTRING (TRIM(NAME) FROM 1 FOR 1) || '.png' 				ELSE 					image 				END 			) AS image 		FROM 			organization, 			 			user_org_mapping, 			user_role, 			ROLE 		WHERE 			user_role.role_id = ROLE . ID 		AND organization. ID = user_org_mapping.organization_id 		AND user_org_mapping.user_id = user_role.user_id 		AND user_role.role_id IN (13) 		 		GROUP BY 			user_role.user_id, 			organization. NAME, 			org_type, 			image, 			role_name 		ORDER BY 			NAME 	) TT UNION 	( 		SELECT 			user_role.user_id AS ID, 			ROLE .role_name, 			organization. NAME, 			org_type, 			( 				CASE 				WHEN image IS NULL THEN 					'video/android_images/' || SUBSTRING (TRIM(NAME) FROM 1 FOR 1) || '.png' 				ELSE 					image 				END 			) AS image 		FROM 			organization, 			 			user_org_mapping, 			user_role, 			ROLE 		WHERE 			user_role.role_id = ROLE . ID 		AND organization. ID = user_org_mapping.organization_id 		AND user_org_mapping.user_id = user_role.user_id 		AND user_role.role_id IN (15) 		 		GROUP BY 			user_role.user_id, 			organization. NAME, 			org_type, 			image, 			role_name 		ORDER BY 			NAME 	)";
	orgList = util.executeQuery(getListOfOrg);		

	String getBatchGroups="SELECT 	batch_group. ID, 	batch_group. NAME, 	'video/android_images/' || SUBSTRING ( 		TRIM (batch_group. NAME) 		FROM 			1 FOR 1 	) || '.png' AS image, 	COUNT (batch_group_messages. ID) AS chat_count FROM 	batch_group, 	batch_group_messages WHERE 	batch_group. ID = batch_group_messages.batch_group_id AND batch_group_messages.sent = 'f' and batch_group.college_id = (select organization_id from user_org_mapping where user_id = "+user.getId()+" limit 1) GROUP BY 	batch_group. ID, 	batch_group. NAME, 	image";
	groupList = util.executeQuery(getBatchGroups);	

	String getUsers="SELECT 	istar_user. ID, 	user_profile.first_name, 	user_profile.profile_image, 	istar_user.email, 	COUNT (chat_messages) AS chat_count FROM 	chat_messages, 	istar_user, 	user_profile, user_org_mapping WHERE istar_user. ID = user_profile.user_id and istar_user.id = user_org_mapping.user_id and user_org_mapping.organization_id  in (select organization_id from user_org_mapping where user_id = "+user.getId()+" limit 1) and ((chat_messages.receiver_id = "+user.getId()+" and chat_messages.user_id = istar_user.id ) OR (chat_messages.receiver_id = istar_user.id and chat_messages.user_id= "+user.getId()+" )) AND sent = 'f' GROUP BY 	istar_user. ID, 	user_profile.first_name, 	user_profile.profile_image, 	istar_user.email"; 
	System.out.println(getUsers);
	userList = util.executeQuery(getUsers);
}
else
{
	String getUsers="SELECT 	istar_user. ID, 	user_profile.first_name, 	user_profile.profile_image, 	istar_user.email, 	COUNT (chat_messages) AS chat_count FROM 	chat_messages, 	istar_user, 	user_profile, user_org_mapping WHERE istar_user. ID = user_profile.user_id and istar_user.id = user_org_mapping.user_id and user_org_mapping.organization_id  in (select organization_id from user_org_mapping where user_id = "+user.getId()+" limit 1) and ((chat_messages.receiver_id = "+user.getId()+" and chat_messages.user_id = istar_user.id ) OR (chat_messages.receiver_id = istar_user.id and chat_messages.user_id= "+user.getId()+" )) AND sent = 'f' GROUP BY 	istar_user. ID, 	user_profile.first_name, 	user_profile.profile_image, 	istar_user.email"; 
	userList = util.executeQuery(getUsers);
}	


String userImage = user.getUserProfile().getProfileImage()!=null ?user.getUserProfile().getProfileImage() : "/video/android_images/"+user.getUserProfile().getFirstName().substring(0, 1).toUpperCase()+".png"; 
		userImage="http://api.talentify.in"+userImage;
%>    
<input type="hidden" id ="current_user_id" value="<%=user.getId()%>">
<input type="hidden" id ="current_user_type" value="<%=userRole%>">
<input type="hidden" id="current_user_name" value="<%=user.getUserProfile().getFirstName()%>">
<input type="hidden" id="current_user_image" value="<%=userImage%>">
<input type="hidden" id="current_user_email" value="<%=user.getEmail()%>">
<input type="hidden" id="current_user_org_id" value="<%=user.getUserOrgMappings().iterator().next().getOrganization().getId()%>">
<div class="small-chat-box fadeInRight animated" style="    height: 606px;    width: 310px;    right: 370px;  display:none" id="chat_holder" data-receiver_type=""
data-receiver_id="" data-receiver_name="" data-receiver_image="">
</div>

    <div class="small-chat-box fadeInRight animated" style="height: 606px; width: 296px;">
		<div class="heading" draggable="true">
           Welcome <%=user.getUserProfile().getFirstName() %>
        </div>
        <div class="tabs-container" style="background-color: #f3f3f4;">
        <ul class="nav nav-tabs">
        <%if(userRole.equalsIgnoreCase("SUPER_ADMIN") || userRole.equalsIgnoreCase("ORG_ADMIN"))
        	{
        	%>
        	 <li class="active"><a data-toggle="tab" href="#tab-orgs" id ="org_tab">Admin</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-groups" id ="group_tab">Groups</a></li>
        	<% 
        	}%>
                           
                            <li class=""><a data-toggle="tab" href="#tab-users" id="user_tab">Users</a></li>
                        </ul>
                        <div class="tab-content">
              <%
              if(userRole.equalsIgnoreCase("SUPER_ADMIN") || userRole.equalsIgnoreCase("ORG_ADMIN"))
          	{
            	  %>
<div id="tab-orgs" class="tab-pane active">
                                <div class="panel-body">
                                <div class="chat-users" style="height: 441px; margin-left: -24px; width: 296px;">
								<div class="users-list">
								<%
								 
								for(HashMap<String, Object> org  : orgList){
									String image="N.png";
									if(org.get("role_name")!=null)
									{
										//image = "/"+org.get("image").toString();
										image = "/video/android_images/"+org.get("role_name").toString().substring(0, 1)+".png";
									}
									else
									{
										image = "/video/android_images/"+org.get("role_name").toString().substring(0, 1)+".png";
									}
									
									%>
									<div class="chat-user" id="entity_user_<%=org.get("id")%>" data-user_id="<%=org.get("id") %>" 
									data-user_type="ORG" data-user_name="<%=org.get("name")%>" data-user_image="<%=image%>">
                                            <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                                            <div class="chat-user-name">
                                                <a href="#"><%=org.get("name")%>
                                                
                                            </div>
                                        </div>
									<%
									} %>                                      
                                    </div>

                                </div>                                    
                                </div>
                            </div>
                            <div id="tab-groups" class="tab-pane">
                                <div class="panel-body">
                                
                                <div class="chat-users" style="height: 441px; margin-left: -24px; width: 296px;">
								<div class="users-list">
								<%
								 
								for(HashMap<String, Object> group  : groupList){
									String image="N.png";
									if(group.get("image")!=null)
									{
										image = "/"+group.get("image").toString();
									}
									else
									{
										image = "/video/android_images/"+group.get("name").toString().substring(0, 1)+".png";
									}	
									
									%>
									<div class="chat-user" id="entity_bg_group_<%=group.get("id") %>" data-user_id="<%=group.get("id") %>" data-user_type="BG_GROUP" data-user_name="<%=group.get("name")%>" data-user_image="<%=image%>">
                                            <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                                            <div class="chat-user-name">
                                                <a href="#"><%=group.get("name")%><%-- <span class="label label-primary" style="float:right"><%=group.get("chat_count")%></span> --%></a>
                                            </div>
                                        </div>
									<%
									} %>                                      
                                    </div>

                                </div> 
                                
								</div>
                            </div>

<% 
} 
              %>          
                        
                            
                            <div id="tab-users" class="tab-pane">
                                <div class="panel-body">
                                <div class="chat-users" style="height: 441px; margin-left: -24px; width: 296px;">
								<div class="users-list">
								<%
								 
								for(HashMap<String, Object> users  : userList){
									String image="N.png";
									String name=users.get("email").toString();
									if(users.get("profile_image")!=null)
									{
										image = "/"+users.get("profile_image").toString();
									}
									else
									{
										if(users.get("first_name")!=null)
										{
											image = "/video/android_images/"+users.get("first_name").toString().substring(0, 1)+".png";
											name = users.get("first_name").toString();
										}
										else
										{
											image = "/video/android_images/"+users.get("email").toString().substring(0, 1)+".png";
										}	
										
									}	
									
									%>
									<div class="chat-user" id="entity_user_<%=users.get("id")%>" data-user_id="<%=users.get("id") %>" data-user_type="USER" data-user_name="<%=name%>" data-user_image="<%=image%>" >
                                            <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                                            <div class="chat-user-name">
                                                <a href="#"><%=name%>
                                                <%-- <span class="label label-primary" style="float:right"><%=users.get("chat_count")%></span> --%></a>
                                            </div>
                                        </div>
									<%
									} %>                                      
                                    </div>

                                </div> 
                                
								</div>
                            </div>
                        </div>


                    </div>
               
        
       
        
    </div>
    
    
    
    <div id="small-chat">

        <span class="badge badge-warning pull-right">5</span>
        <a class="open-small-chat">
            <i class="fa fa-comments"></i>

        </a>
    </div>
<script>




</script>