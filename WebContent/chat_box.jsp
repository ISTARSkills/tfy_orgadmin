<%@page import="java.util.Arrays"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@page import="com.viksitpro.core.utilities.RoleTypes"%>
<%@page import="com.viksitpro.chat.services.Chat"%>
<%@page import="com.viksitpro.chat.services.MessageService"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<% 
IstarUser user = (IstarUser) session.getAttribute("user");
DBUTILS util= new DBUTILS();
String type= request.getParameter("user_type");
String userId = request.getParameter("user_id");
String userName = request.getParameter("user_name");
String currentUserId = user.getId()+"";
String currentUserName =  user.getUserProfile().getFirstName();
List<HashMap<String, Object	>> data =new ArrayList();
Chat chat = new Chat();
if(type.equalsIgnoreCase("ORG"))
{
	String getMessages="SELECT 	chat_messages. ID, cast ('"+userName+"' as varchar) as name, chat_messages.created_at, 	chat_messages.message, 	user_id, 	receiver_id FROM 	chat_messages WHERE 	( 		user_id = "+currentUserId+" 		AND receiver_id = "+userId+" 	) OR ( 	user_id = "+userId+"	AND receiver_id = "+currentUserId+" ) ORDER BY 	chat_messages.created_at desc  LIMIT 10;";
	System.out.println(getMessages);
	data =  util.executeQuery(getMessages);
	
	String markOldMessageAsSent ="update chat_messages set sent ='t'  WHERE 	(( 		user_id = "+currentUserId+" 		AND receiver_id = "+userId+" 	) OR ( 	user_id = "+userId+"	AND receiver_id = "+currentUserId+" ))";
	util.executeUpdate(markOldMessageAsSent);
	
}
else if(type.equalsIgnoreCase("BG_GROUP"))
{
	String getMessages="SELECT 	batch_group_messages. ID, batch_group_messages.created_at ,	message, 	user_profile.first_name as name, 	batch_group_messages.sender_id  as user_id FROM 	batch_group_messages, 	user_profile WHERE 	user_profile.user_id = batch_group_messages.sender_id AND batch_group_id = "+userId+"  ORDER BY 	batch_group_messages.created_at desc  LIMIT 10;";
	System.out.println(getMessages);
	data =  util.executeQuery(getMessages);
	
	String markOldBGMessageAsSent ="update batch_group_messages set sent='t' where batch_group_id="+userId;
	util.executeUpdate(markOldBGMessageAsSent);
	
}
else if (type.equalsIgnoreCase("USER")){
	String getMessages="SELECT 	chat_messages. ID, cast ('"+userName+"' as varchar) as name,  chat_messages.created_at ,	chat_messages.user_id, 	chat_messages.receiver_id, 	chat_messages.message FROM 	chat_messages WHERE 	( 		user_id = "+currentUserId+" 		AND receiver_id = "+userId+" 	) OR ( 	user_id = "+userId+" 	AND receiver_id ="+currentUserId+" ) ORDER BY 	created_at desc LIMIT 10;";
	System.out.println(getMessages);
	data =  util.executeQuery(getMessages);
	
	String markOldMessageAsSent ="update chat_messages set sent ='t' where (( 		user_id = "+currentUserId+" 		AND receiver_id = "+userId+" 	) OR ( 	user_id = "+userId+" 	AND receiver_id ="+currentUserId+" ))";
	util.executeUpdate(markOldMessageAsSent);
}	

%>   
        <div class="heading" draggable="true" id="chatter_heading" style="cursor:pointer">
            <!-- <small class="chat-date pull-right">
                02.19.2015
            </small> -->
            <%=userName %>
        </div>
        <div class="content" style="overflow-y: scroll; height: 511px;" id="chat_content">
			<% 
			PrettyTime ptime = new PrettyTime();
				for(int i=data.size()-1; i>=0 ; i--)
				{					
					HashMap<String, Object> row= data.get(i);
					Timestamp created_at = (Timestamp)row.get("created_at");					
					if(row.get("user_id").toString().equalsIgnoreCase(currentUserId))
					{
						%>						
				<div class="chat_comment">
				<div class="left">
                <div class="author-name">
                    <%=currentUserName%>
                    <small class="chat-date">
                        <%=ptime.format(created_at)%>
                    </small>
                </div>
                <div class="chat-message active">
                   <%=row.get("message") %>
                </div>
            </div>
            </div>
						<% 
					}
					else
					{
						%>
						<div class="chat_comment">
						<div class="right">
                <div class="author-name">
                    <%=row.get("name") %> <small class="chat-date">
                     <%=ptime.format(created_at)%>
                </small>
                </div>
                <div class="chat-message">
                   <%=row.get("message") %>
                </div>

            </div>
            </div>
						<%
					}
				}
			%>
            


        </div>
        <div class="form-chat" >
            <div class="input-group input-group-sm" style="    top: 550px; position: absolute; width: 276px;">
            <input type="text" class="form-control chat_message" id="<%=type.toLowerCase()%>_<%=userId%>"> 
            <%
            String allowedRoleToSendNotification[] ={RoleTypes.SUPER_ADMIN, RoleTypes.ORG_ADMIN, RoleTypes.COORDINATOR};
            if(Arrays.asList(allowedRoleToSendNotification).contains(user.getUserRoles().iterator().next().getRole().getRoleName())) 
            {
            	%>
            	<span class="input-group-btn"> <%-- <button
                    class="btn btn-primary" type="button" id="send_notification" data-user_id="<%=user.getId()%>" data-user_type="<%=user.getUserRoles().iterator().next().getRole().getRoleName()%>">
            	</button>  --%></span>
            	<% 
            }%>
            
            
            </div>
        </div>

