package com.viksitpro.chat.services;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.websocket.server.ServerEndpoint;

import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.BatchStudents;
import com.viksitpro.core.dao.entities.ChatGroup;
import com.viksitpro.core.dao.entities.ChatMessages;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.notification.PublishDelegator;
import com.viksitpro.core.utilities.ChatType;
import com.viksitpro.core.utilities.NotificationType;

import in.talentify.core.utils.AndroidNoticeDelegator;




@WebSocket
@ServerEndpoint(value = "/chat/*")
public class ChatWebSocketHandler   {

    @OnWebSocketConnect
    public void onConnect(Session user) throws Exception {
    	//System.out.println(user.getUpgradeRequest().getRequestURI());
    	String url = user.getUpgradeRequest().getRequestURI().toString();
    	String email = url.split("/")[4];
    	//System.out.println("---"+email);
    	List<IstarUser> users = new IstarUserDAO().findByEmail(email);
    	if(users.size()>0)
    	{
    		IstarUser IstarUser = new IstarUserDAO().findByEmail(email).get(0);
        	
        	String username = IstarUser.getUserProfile()!=null ? (IstarUser.getUserProfile().getFirstName()!=null ? IstarUser.getUserProfile().getFirstName(): IstarUser.getEmail()) : IstarUser.getEmail() ;
        	Chat.userUsernameMap.put(user, username);
        	Chat.sessionUserIdMap.put(user,IstarUser.getId());
        	
        	if(IstarUser.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("ORG_ADMIN"))
        	{
        		
        		Organization org = IstarUser.getUserOrgMappings().iterator().next().getOrganization();
        		ArrayList<Integer> bgids = new ArrayList<>();
        		for(BatchGroup  bg : org.getBatchGroups())
        		{
        			bgids.add(bg.getId());
        			
        		}
        		Chat.userIdBGGroupIdMap.put(IstarUser.getId(), bgids);
        		
        	}else if(IstarUser.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN"))
        	{
        		ArrayList<Integer> bgids = new ArrayList<>();
        		for(BatchGroup  bg : (ArrayList<BatchGroup>)new BatchGroupDAO().findAll())
        		{
        			bgids.add(bg.getId());
        			
        		}
        		Chat.userIdBGGroupIdMap.put(IstarUser.getId(), bgids);
        	}
        		
        	
        	//check and make a set of custom groups a user belongs to
        	if(!Chat.userIdCustomGroupIdMap.keySet().contains(IstarUser.getId()))
        	{
        		ArrayList<Integer> groupIds = new ArrayList<>();
        		for(ChatGroup group : IstarUser.getChatGroups())
        		{
        			groupIds.add(group.getId());
        		}
        		Chat.userIdCustomGroupIdMap.put(IstarUser.getId(), groupIds);
        	}
        	
        	// check and make a set pf batch group a user belongs to
        	if(!Chat.userIdBGGroupIdMap.keySet().contains(IstarUser.getId()))
        	{
        		ArrayList<Integer> groupIds = new ArrayList<>();
        		for(BatchStudents bs : IstarUser.getBatchStudentses())
        		{
        			if(!groupIds.contains(bs.getBatchGroup().getId()))
        			{
        				groupIds.add(bs.getBatchGroup().getId());
        			} 			
        		}
        		Chat.userIdBGGroupIdMap.put(IstarUser.getId(), groupIds);
        	}
        	
        	
        	
        	MessageService msgService = new MessageService();
        	//JSONObject obj = getJoiningMsgJSONObject(user, IstarUser);
        	//msgService.addJoiningMessage(IstarUser,username+" joined the chat");
        	//Chat.broadcastJoiningMessage(IstarUser, obj.toString());
        	//System.out.println("connected");
    	}
    	
    	
    }

   
	/*public String getReceivers(IstarUser IstarUser) {
		JSONArray userArray = new JSONArray();
		ArrayList<Integer> allreadyAdded = new ArrayList<>();
		for(ChatGroupMember member : IstarUser.getChatGroupMembers())
		{
			
			for(ChatGroupMember  cgm: member.getChatGroup().getChatGroupMembers())
			{
				IstarUser memberUser = cgm.getIstarUser();
				if(!allreadyAdded.contains(memberUser.getId()))
				{
					allreadyAdded.add(memberUser.getId());
			    	String username = memberUser.getIstarUserProfile()!=null ? (memberUser.getIstarUserProfile().getFirstName()!=null ? memberUser.getIstarUserProfile().getFirstName(): memberUser.getEmail()) : memberUser.getEmail() ;
					JSONObject receiverObject = new JSONObject();
					try {
						receiverObject.put("username", username);
						receiverObject.put("online", "false");
						receiverObject.put("userId",memberUser.getId()+"");
						if(Chat.sessionUserIdMap.containsValue(memberUser.getId()))
						{
							receiverObject.put("online", "true");
							
						}
						userArray.put(receiverObject);
					
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}
			}
			
		}
		
		return userArray.toString();
	}*/

	@OnWebSocketClose
    public void onClose(Session user, int statusCode, String reason) {
        String username = Chat.userUsernameMap.get(user);
        Chat.userUsernameMap.remove(user);
        int IstarUserId = Chat.sessionUserIdMap.get(user);
        Chat.userIdBGGroupIdMap.remove(IstarUserId);
        Chat.userIdCustomGroupIdMap.remove(IstarUserId);
        Chat.sessionUserIdMap.remove(user);
        //System.out.println("closed");
	}

    @OnWebSocketMessage
    public void onMessage(Session user, String message) {
    	MessageService msgService = new MessageService();
    	//System.out.println("json string in onMessage >>>>>>>"+ message);
    	IstarNotificationServices serv = new IstarNotificationServices();
    	AndroidNoticeDelegator delegator = new AndroidNoticeDelegator();
    	Integer senderId = Chat.sessionUserIdMap.get(user);
    	if(senderId!=null)
    	{
    		IstarUser IstarUser = new IstarUserDAO().findById(senderId);
    		String username = Chat.userUsernameMap.get(user);
        	try {
    			JSONObject data = new JSONObject(message);
    			String type = (String)data.get("type");
    			switch (type) {
    			/*case ChatType.JOINING_MESSAGE:
    				JSONObject obj = getJoiningMsgJSONObject(user, IstarUser);
    		    	msgService.addJoiningMessage(IstarUser,username+" joined the chat");
    		    	Chat.broadcastJoiningMessage(IstarUser, obj.toString());
    				break;*/
    			case ChatType.MARK_GROUP_CHAT_AS_READ:
    				String readBy = data.getString("receiverId");
    				String group = data.getString("groupId");
    				Chat.markGroupChatAsReadForUser(readBy,group);
    				break;
    			case ChatType.MARK_CHAT_AS_SENT:
    				String recID = data.getString("receiverId");
    				String sndrId = data.getString("senderId");
    				Chat.markChatAsSentBetweenUser(sndrId, recID);
    				break;
    			case ChatType.USER_CHAT:
    				int receiverId = Integer.parseInt(data.getString("receiverId"));
    				ChatMessages msg = msgService.addUserMessage(senderId, data.getString("message"), receiverId);
    				Chat.broadcastMessageToUser(senderId, message, receiverId, msg.getId());
    				IstarUser userReceiver = new IstarUserDAO().findById(receiverId);
    				if(userReceiver.getUserRoles() !=null && userReceiver.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("STUDENT")){
	    				String groupNotificationCode = UUID.randomUUID().toString();
	    				IstarNotification not = serv.createIstarNotification(senderId, receiverId, data.getString("message").replace("'", ""), "", "UNREAD", null, NotificationType.GENERIC, true, null, groupNotificationCode);    				
	    				HashMap<String, Object> item = new HashMap<String, Object>();    				
	    				delegator.sendNotificationToUser(not.getId(),receiverId+"", data.getString("message").replace("'", ""), NotificationType.GENERIC, item);
    				}
    				break;
    			case ChatType.ORG_CHAT:
    				int receiverAdminId = Integer.parseInt(data.getString("receiverId"));
    				ChatMessages chatmsg = msgService.addOrgMessage(senderId, data.getString("message"), receiverAdminId);
    				if(chatmsg.getId()!=null){
    					Chat.broadcastMessageToOrgAdmin(senderId, message, receiverAdminId, chatmsg.getId());
    				}
    				break;	
    			case ChatType.BG_CHAT:
    				int groupId = Integer.parseInt(data.getString("groupId"));
    				int  msg_id = msgService.addBGroupMessage(senderId, data.getString("message"), groupId);    				
    				Chat.broadcastMessageInBGGroup(senderId, message, groupId, msg_id);
    				break;
    			case ChatType.CUSTOM_GROUP_CHAT:
    				int bggroupId = Integer.parseInt(data.getString("groupId"));
    				ChatMessages msgq = msgService.addCustomGroupMessage(senderId, data.getString("message"), bggroupId);
    				Chat.broadcastMessageInCustomGroup(senderId, message, bggroupId, msgq.getId());
    				break;
    			/*case ChatType.ASK_DOUBT:
    				int slideId = Integer.parseInt(data.getString("slideId"));
    				msgService.addNewDoubt(senderId, data.getString("message"), slideId);
    				Chat.broadcastNewDoubt(senderId, message);
    				break;
    			case ChatType.NOTIFICATION:    				    						
    				noticeService.addNotificationMessages(message);    				
    				Chat.broadcastNotification(message );
    				break;   */ 				
    			default:
    				break;
    			}
    			    			
        	}catch(Exception e)
        	{
        		e.printStackTrace();
        	}
    	}
		
    }

	/*private JSONObject getJoiningMsgJSONObject(Session user, IstarUser IstarUser) {
		JSONObject obj = new  JSONObject();		
		String username = Chat.userUsernameMap.get(user);
    	try {
			obj.put("senderId", IstarUser.getId());
			obj.put("username",username);
	    	obj.put("type", "JOINING_MESSAGE");
	    	obj.put("message", username+" joined the chat");
	    	String uniqueSessionId = Integer.toHexString(user.hashCode());
	    	obj.put("sessionId", uniqueSessionId);
	    	String receivers = getReceivers(IstarUser);
	    	obj.put("userList",receivers);
	    	int onlineUserCount = IstarUserservce.onlineUsersInGroup(IstarUser.getEmail()).size();
	    	obj.put("onlineUserCount",onlineUserCount);
	    	String groups = getGroups(IstarUser);
	    	obj.put("groups", groups);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	return obj;
	}

	
	private String getGroups(IstarUser IstarUser) {
		
		ArrayList<Integer> groups = new ArrayList<>();
		JSONArray groupArray = new JSONArray();
		for(ChatGroupMember cgm : IstarUser.getChatGroupMembers())
		{
			if(!groups.contains(cgm.getChatGroup().getId()))
			{
				groups.add(cgm.getChatGroup().getId());
				JSONObject obj = new JSONObject();
				try {
					obj.put("groupId", cgm.getChatGroup().getId()+"");
					obj.put("groupName", cgm.getChatGroup().getName());
					groupArray.put(obj);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		}
		return groupArray.toString();
	}*/

	

}
