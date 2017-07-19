package com.viksitpro.chat.services;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.ChatMessages;
import com.viksitpro.core.dao.entities.ChatMessagesDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.dao.entities.UserOrgMapping;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;
import com.viksitpro.core.utilities.ChatType;
import com.viksitpro.core.utilities.DBUTILS;



public class MessageService {
/*
	*//**
	 * 
	 * @param senderId Integer value of Id of IstarUser who is raising doubt
	 * @param messageContent String value of message content
	 * @param slideId Integer value of Slide Id.
	 *//*
	public void addNewDoubt(int senderId, String messageContent, int slideId) {
		
		DoubtMessage doubt = new DoubtMessage();
		doubt.setActive(true);
		doubt.setCreatedAt(new Timestamp(System.currentTimeMillis()));
		doubt.setDoubt(messageContent);
		IstarUser user = new IstarUserDAO().findById(senderId);
		doubt.setIstarUserBySenderId(user);
		Slide slide = new SlideDAO().findById(slideId);
		doubt.setSlide(slide);
 			
		saveDoubtToDAO(doubt);
	}

	private void saveDoubtToDAO(DoubtMessage doubt) {

		Session session = HibernateSessionFactory.getSession();
		Transaction doubtMessagaeTransaction = null;
		try {
			doubtMessagaeTransaction = session.beginTransaction();
			session.save(doubt);
			doubtMessagaeTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (doubtMessagaeTransaction != null)
				doubtMessagaeTransaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}*/
	
	/**
	 * 
	 * @param groupId Integer value of group Id
	 * @param limit Integer value of count of conversation required
	 * @return List of ChatMessages 
	 *//*
	public List<ChatMessages> getLastNMessageOfGroup(Integer groupId, Integer limit)
	{
		Session session = ChatHibernateSessionFactory.getSession();
		session.beginTransaction();
		String SQL_QUERY = "FROM ChatMessages groupMsg where groupMsg.chatGroup=:groupId and groupMsg.type='"+ChatType.GROUP_CHAT+"' ORDER BY groupMsg.createdAt DESC";
		Query query = session.createQuery(SQL_QUERY);
		query.setMaxResults(limit);
		query.setInteger("groupId", groupId);
		List<ChatMessages> chatMessages = query.getResultList();
		session.close();
		
		return chatMessages;
	}
	
	*//**
	 * 
	 * @param senderId Integer value of Chat User Id of Sender 
	 * @param receiverId Integer value of Chat User Id of Receiver 
	 * @param limit Integer of value max records required
	 * @return List of Chat Messages between sender and receiver.
	 *//*
	public List<ChatMessages> getLastNMessageOfBetweenUser(Integer senderId, Integer receiverId, Integer limit)
	{
		Session session = HibernateSessionFactory.getSession();
		session.beginTransaction();
		String SQL_QUERY = "FROM ChatMessages user where (user.chatUserReceiver =:receiverId and user.chatUserSender=:senderId) "
				+ "or (user.chatUserReceiver =:senderId and user.chatUserSender=:receiverId) "
				+ "and user.chatGroup is null and user.type='"+ChatType.USER_CHAT+"' ORDER BY user.createdAt DESC";
		
		Query query = session.createQuery(SQL_QUERY);
		query.setInteger("receiverId", receiverId);
		query.setInteger("senderId", senderId);
		
		query.setMaxResults(limit);
		List<ChatMessages> chatMessages =   query.getResultList();
		session.close();
		return chatMessages;
	}
*/
	
	/**
	 * 
	 * @param senderId Sender Id of ChatUser
	 * @param message String value of message
	 * @param receiverId Integer value of GroupId
	 * @return
	 */
	public int addBGroupMessage(int senderId, String message, int receiverId) {
		String insertIntoBGMEssages="INSERT INTO batch_group_messages (id, batch_group_id, message, created_at, sender_id, sent, read_by) VALUES "
				+ "((select COALESCE(max(id),0)+1 from batch_group_messages), "+receiverId+", '"+message+"', now(), "+senderId+", 'f', '!#"+senderId+"#!') returning id;";
		//System.out.println(insertIntoBGMEssages);
		DBUTILS util = new  DBUTILS();
		return util.executeUpdateReturn(insertIntoBGMEssages);
		
		
	}
	
	/**
	 * 
	 * @param senderId Sender Id of ChatUser
	 * @param message String value of message
	 * @param receiverId Integer value of GroupId
	 * @return
	 */
	public ChatMessages addCustomGroupMessage(int senderId, String message, int receiverId) {
		ChatMessages msg = new ChatMessages();		
	
		msg.setType(ChatType.CUSTOM_GROUP_CHAT);
		msg.setChatGroupId(receiverId);;
		msg.setUserId(senderId);
		msg.setCreatedAt(new Timestamp(System.currentTimeMillis()));
		msg.setMessage(message);
		msg.setSent(false);
		msg=saveChatMessageToDAO(msg);
		return msg;
	}

	private ChatMessages saveChatMessageToDAO(ChatMessages msg) {
		ChatMessagesDAO istarUserDAO = new ChatMessagesDAO();

		Session session = HibernateSessionFactory.getSession();
		Transaction istarUserTransaction = null;
		try {
			istarUserTransaction = session.beginTransaction();
			session.save(msg);
			istarUserTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (istarUserTransaction != null)
				istarUserTransaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		
		return msg;
		
	}
	
	
	/**
	 * 
	 * @param msg ChatMEssage Object to be updated
	 * @return
	 */
	public ChatMessages updateChatMessageToDAO(ChatMessages msg) {
		ChatMessagesDAO istarUserDAO = new ChatMessagesDAO();

		Session session = HibernateSessionFactory.getSession();
		Transaction istarUserTransaction = null;
		try {
			istarUserTransaction = session.beginTransaction();
			session.update(msg);
			istarUserTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (istarUserTransaction != null)
				istarUserTransaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		
		return msg;
		
	}
	

	public ChatMessages addUserMessage(int senderId, String message, int receiverId) {
		ChatMessages msg = new ChatMessages();		
				
		msg.setUserId(senderId);
		msg.setCreatedAt(new Timestamp(System.currentTimeMillis()));
		msg.setMessage(message);
		msg.setType(ChatType.USER_CHAT);
		msg.setReceiverId(receiverId);
		msg.setSent(false);
		msg = saveChatMessageToDAO(msg);
		
		return msg;
	}

	/**
	 * @param chatUser
	 */
	public void addJoiningMessage(IstarUser chatUser, String message) {
		ChatMessages msg = new ChatMessages();		
				
		msg.setReceiverId(chatUser.getId());
		msg.setCreatedAt(new Timestamp(System.currentTimeMillis()));
		msg.setMessage(ChatType.JOINING_MESSAGE);
		msg.setType(ChatType.JOINING_MESSAGE);		
		saveChatMessageToDAO(msg);
		
	}

	public ChatMessages addOrgMessage(Integer senderId, String message, int receiverAdminId) {
		ChatMessages msg = new ChatMessages();		
		
		msg.setUserId(senderId);
		msg.setCreatedAt(new Timestamp(System.currentTimeMillis()));
		msg.setMessage(message);
		msg.setType(ChatType.ORG_CHAT);
		msg.setReceiverId(receiverAdminId);
		msg.setSent(false);
		msg = saveChatMessageToDAO(msg);
		
		return msg;
	}




	
	
}
