/**
 * 
 */
package com.viksitpro.chat.services;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Notification;
import com.viksitpro.core.dao.entities.NotificationDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;
import com.viksitpro.core.dao.utils.user.IstarUserServices;

/**
 * @author ComplexObject
 *
 */
public class NotificationService {

	
	public List<Notification> getListOfUnreadNotifications(int userId)
	{
		List<Notification> pendingNotification = new ArrayList<>();
		IstarUserServices userServices = new IstarUserServices();
		IstarUser user = userServices.getIstarUser(userId);
		if(user!=null)
		{
			for(Notification notice : user.getNotificationsForReceiverId())
			{
				if(!notice.getSent())
				{
					pendingNotification.add(notice);
					
				}
				notice.setSent(true);
				updateNotificationToDAO(notice);
			}
		}		
		return pendingNotification;				
	}
	
	
	public void addNotificationMessages(String message) {
		/*
		 * JSONArray userArray = new JSONArray();
		 * JSONObject obj = new JSONObject();
		 * obj.put("id",5);
		 * obj.put("id",16);
		 * obj.put("id",18);
		 * userArray.put(obj);
		 * JSONObject data = new JSONObject();
		 * data.put("userIds",userArray);
		 * data.put("batch_group_id",35);
		 * data.put("sender_id",5);
		 * data.put("notification_type","UPDATE_COMPLEX_OBJECT");
		 * data.put("message","Update Complex Object"); 
		 * data.put("type","NOTIFICATION"); 
		 */
		
		try {
			JSONObject data = new JSONObject(message);
			JSONArray userArray = data.getJSONArray("userIds");
			String notificationType = data.getString("notification_type");
			String msg_txt = data.getString("message");
			for(int  i=0; i< userArray.length();i++)
			{
				try {
					JSONObject user = userArray.getJSONObject(i);
					int userId = Integer.parseInt(user.getString("id"));
					Notification notification = new Notification();
					if(data.has("batch_group_id") && data.getString("batch_group_id")!=null)
					{
						int batchGroupId = Integer.parseInt(data.getString("batch_group_id"));
						BatchGroup bg = new BatchGroupDAO().findById(batchGroupId);
						notification.setBatchGroup(bg);						
					}
						notification.setCreatedAt(new Timestamp(System.currentTimeMillis()));
					if(data.has("sender_id") && data.getString("sender_id")!=null)
					{
						int senderId = Integer.parseInt(data.getString("sender_id"));
						IstarUser sender = new IstarUserServices().getIstarUser(senderId);
						notification.setIstarUserBySenderId(sender);
					}
					
						int receiverId = userId;
						IstarUser receiver = new IstarUserServices().getIstarUser(receiverId);
						notification.setIstarUserByReceiverId(receiver);
					    notification.setSent(false);
						notification.setType(notificationType);
						notification.setNotificationMessage(msg_txt);
					
				notification = saveNotificationToDAO(notification);
						
				} catch (JSONException e) {					
					e.printStackTrace();
				}				
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}


	public Notification saveNotificationToDAO(Notification notification) {
		NotificationDAO notificationDAO = new NotificationDAO();

		Session session = HibernateSessionFactory.getSession();
		Transaction notificationTransaction = null;
		try {
			notificationTransaction = session.beginTransaction();
			session.save(notification);
			notificationTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (notificationTransaction != null)
				notificationTransaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}	
		return notification;
	}
	
	public void updateNotificationToDAO(Notification notification) {
		NotificationDAO notificationDAO = new NotificationDAO();

		Session session = HibernateSessionFactory.getSession();
		Transaction notificationTransaction = null;
		try {
			notificationTransaction = session.beginTransaction();
			session.update(notification);
			notificationTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (notificationTransaction != null)
				notificationTransaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}				
	}
	
	
}
