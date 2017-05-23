package com.viksitpro.chat.services;
import static spark.Spark.init;
import static spark.Spark.staticFiles;
import static spark.Spark.webSocket;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.eclipse.jetty.websocket.api.Session;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.viksitpro.core.dao.entities.ChatMessages;
import com.viksitpro.core.dao.entities.ChatMessagesDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Notification;
import com.viksitpro.core.dao.utils.user.IstarUserServices;
import com.viksitpro.core.utilities.ChatUtility;
import com.viksitpro.core.utilities.DBUTILS;


public class Chat {

    // this map is shared between sessions and threads, so it needs to be thread-safe (http://stackoverflow.com/a/2688817)
   public  static Map<Session, String> userUsernameMap = new ConcurrentHashMap<>();
   public  static Map<Session,Integer> sessionUserIdMap = new ConcurrentHashMap<>();
   public static Map<Integer, ArrayList<Integer>> userIdCustomGroupIdMap = new ConcurrentHashMap<>();
   public static Map<Integer, ArrayList<Integer>> userIdBGGroupIdMap = new ConcurrentHashMap<>();
    public static void main(String[] args) {
        //staticFiles.location("/"); //index.html is served at localhost:4567 (default port)
        //staticFiles.expireTime(600);
        webSocket("/chat/*", ChatWebSocketHandler.class);
        init();
    }

    
  

	public static void broadcastNewDoubt(int senderId, String message) {
		
		ArrayList<Integer> groupIds =	Chat.userIdBGGroupIdMap.get(senderId);
		
		ArrayList<Integer> userIdToBroadCast = new ArrayList<>();
		for(Integer userId : Chat.userIdBGGroupIdMap.keySet())
		{
			if(!userIdToBroadCast.contains(userId) &&  Chat.userIdBGGroupIdMap.get(userId).contains(groupIds))
			{
				userIdToBroadCast.add(userId);				
			}
		}
		
		
		for(Session sesson : sessionUserIdMap.keySet())
		{
			//sending message from user beloging to students group
			if(sesson!=null && sesson.isOpen() && userIdToBroadCast.contains(sessionUserIdMap.get(sesson)))
			{
				try {
					sesson.getRemote().sendString(message);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			//sending message to content group
			
			if(sesson!=null && sesson.isOpen() && userIdBGGroupIdMap.get(sessionUserIdMap.get(sesson)).contains(ChatUtility.CONTENT_GROUP))
			{
				try {
					sesson.getRemote().sendString(message);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		
	}


	public static void broadcastMessageInCustomGroup(Integer sender, String message, Integer groupId, Integer integer)
    {
    	
    	sessionUserIdMap.keySet().stream().filter(Session::isOpen).forEach(session -> {
            try {
            	int currentUserId = sessionUserIdMap.get(session);
            	if(userIdCustomGroupIdMap.get(currentUserId)!=null && userIdCustomGroupIdMap.get(currentUserId).contains(groupId))
	            	{	      
            			System.out.println("sending message to "+currentUserId);
	            		session.getRemote().sendString(message);
	            		markChatMessageAsSent(integer);
	            	}               
            	}
            catch (Exception e) {
                e.printStackTrace();
            }
        });
    	
    	
    }
    
   

   

	public static void broadcastMessageToUser(Integer senderId, String message, int receiverId ,Integer messageId) {
	
		Session receiverSession = null;
		for(Session sess : sessionUserIdMap.keySet())
		{
			if(sessionUserIdMap.get(sess)==receiverId)
			{
				System.out.println("got user to send message "+receiverId);
				receiverSession = sess;
			}
		}
		
		if(receiverSession!=null && receiverSession.isOpen())
			try {
				receiverSession.getRemote().sendString(message);
				//markChatMessageAsSent(messageId);
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}


	private static void markChatMessageAsSent(Integer messageId) {
		ChatMessages msg = new ChatMessagesDAO().findById(messageId);
		msg.setSent(true);
		MessageService service = new MessageService();
		service.updateChatMessageToDAO(msg);				
	}

	private static void markBatchGroupMsgAsSent(Integer messageId) {
		String updateBGMessage ="update batch_group_messages set sent = 't' where id ="+messageId ;
		DBUTILS util= new DBUTILS();
		util.executeUpdate(updateBGMessage);
	}



	/**
	 * @param newUser 
	 * @param string
	 */
	public static void broadcastJoiningMessage(IstarUser newUser, String jsonObject) {
		
		/*ArrayList<Integer> userToBroadcast = new ArrayList<>();
		List<IstarUser> IstarUsersToBroadCast = new  ChatUserService().onlineUsersInBGroup(newUser.getId());
		for(IstarUser member : IstarUsersToBroadCast)
		{			
			if(!userToBroadcast.contains(member.getId()))
			{
				userToBroadcast.add(member.getId());
			}
		}
		
		List<IstarUser> IstarUsersToBroadCast2 = new  ChatUserService().onlineUsersInCustomGroup(newUser.getId());
		for(IstarUser member : IstarUsersToBroadCast2)
		{			
			if(!userToBroadcast.contains(member.getId()))
			{
				userToBroadcast.add(member.getId());
			}
		}
		
		
		for(Session session : Chat.sessionUserIdMap.keySet())
		{
			System.out.println("use in session is "+Chat.sessionUserIdMap.get(session));
			//if(userToBroadcast.contains(Chat.sessionUserIdMap.get(session)))
			{
				System.out.println("sending msg to "+Chat.sessionUserIdMap.get(session));
				try {
					session.getRemote().sendString(jsonObject);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}*/
		
	}


	public static void broadcastNotification(String message) {
		JSONObject data;
		try {
			data = new JSONObject(message);
			JSONArray userArray = data.getJSONArray("userIds");
			List<Integer> subscribers = new ArrayList<>();
			for(int i=0; i<userArray.length();i++ )
			{					
					JSONObject user = (JSONObject) userArray.get(i);
					int userId = Integer.parseInt(user.getString("id"));
					if(!subscribers.contains(userId))
					{
						subscribers.add(userId);
					}
			}
			
			for(Session session : Chat.sessionUserIdMap.keySet())
			{
				int userId = Chat.sessionUserIdMap.get(session);
				System.out.println("checking for user id "+userId);
				if(subscribers.contains(userId))
				{
					System.out.println("got user to send notification "+userId);
					try {
						session.getRemote().sendString(message);
						markUserNotificationAsSent(userId);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		
		
	}




	private static void markUserNotificationAsSent(Integer userID) {
		IstarUserServices service = new IstarUserServices();
		NotificationService notificationService = new NotificationService();
		IstarUser user = service.getIstarUser(userID);
		if(user!=null)
		{
			for(Notification notice : user.getNotificationsForReceiverId())
			{
				notice.setSent(true);
				notificationService.updateNotificationToDAO(notice);
			}
		}
		
	}




	public static void broadcastMessageToOrgAdmin(Integer senderId, String message, int receiverAdminId, Integer messageId) {
		Session receiverSession = null;
		for(Session sess : sessionUserIdMap.keySet())
		{
			if(sessionUserIdMap.get(sess)==receiverAdminId)
			{
				System.out.println("got user to send message "+receiverAdminId);
				receiverSession = sess;
			}
		}
		
		if(receiverSession!=null && receiverSession.isOpen())
			try {
				receiverSession.getRemote().sendString(message);
				//markChatMessageAsSent(messageId);
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
	}


	public static void markChatAsSentBetweenUser(String senderId, String recId)
	{
		DBUTILS util = new DBUTILS();
		String markAsRead="update chat_messages set sent='t' where user_id="+senderId+" and receiver_id="+recId;
		util.executeUpdate(markAsRead);
	}

	public static void broadcastMessageInBGGroup(Integer senderId, String message, int groupId, int msg_id) {
		sessionUserIdMap.keySet().stream().filter(Session::isOpen).forEach(session -> {
            try {
            	int currentUserId = sessionUserIdMap.get(session);
            	if(userIdBGGroupIdMap.get(currentUserId)!=null && userIdBGGroupIdMap.get(currentUserId).contains(groupId))
	            	{	      
            			System.out.println("sending message to "+currentUserId);
	            		session.getRemote().sendString(message);
	            		markBatchGroupMsgAsSent(msg_id);
	            	}               
            	}
            catch (Exception e) {
                e.printStackTrace();
            }
        });
    	
		
	}




	public static void markGroupChatAsReadForUser(String readBy, String group) {

		DBUTILS util = new DBUTILS();
		String update ="update batch_group_messages set read_by = COALESCE(read_by,'') || '!#"+readBy+"#!' where batch_group_id="+group;
		System.out.println(update);
		util.executeUpdate(update);
	}

}
