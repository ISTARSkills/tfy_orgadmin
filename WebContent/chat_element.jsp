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
    <div class="small-chat-box fadeInRight animated" style="height: 606px; width: 296px;" id="chat_element_holder">
		<div class="heading" draggable="true" id="chat_element_heading" style="cursor: pointer;">
           Welcome <%=user.getUserProfile().getFirstName() %><i class="fa fa-remove" style="float: right;"></i>
        </div>
        <div class="tabs-container" style="background-color: #f3f3f4;">
        <ul class="nav nav-tabs">
        <%if(userRole.equalsIgnoreCase("SUPER_ADMIN") || userRole.equalsIgnoreCase("ORG_ADMIN") || userRole.equalsIgnoreCase("COORDINATOR"))
        	{
        	%>
        	 <li class="active"><a data-toggle="tab_chat" href="/chat/admin_entities.jsp" data-logged_in_user_id="<%=user.getId()%>" data-logged_in_user_type="<%=userRole %>" id ="org_tab" data-target="#tab-orgs">Admin</a></li>
             <li class=""><a data-toggle="tab_chat" href="/chat/group_entities.jsp" data-logged_in_user_id="<%=user.getId()%>" data-logged_in_user_type="<%=userRole %>" id ="group_tab" data-target="#tab-groups">Groups</a></li>
        	<%}%>                           
             <li class=""><a data-toggle="tab_chat" href="/chat/user_entities.jsp" data-logged_in_user_id="<%=user.getId()%>" data-logged_in_user_type="<%=userRole %>" id="user_tab" data-target="#tab-users">Users</a></li>
        </ul>
        <div class="tab-content">
              <%
              if(userRole.equalsIgnoreCase("SUPER_ADMIN") || userRole.equalsIgnoreCase("ORG_ADMIN") || userRole.equalsIgnoreCase("COORDINATOR"))
          	{
            	  %>
<div id="tab-orgs" class="tab-pane active"></div>
<div id="tab-groups" class="tab-pane"></div>
<% 
} 
              %>                                                              
<div id="tab-users" class="tab-pane"></div></div>
                    </div>
        
    </div>
   
    <div id="small-chat">
        <span class="badge badge-warning pull-right" id="unread_chat_count"></span>
        <a class="open-small-chat">
            <i class="fa fa-comments"></i>
        </a>
    </div>
<script>
</script>