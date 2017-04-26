/**
 * 
 */
package in.talentify.core.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;

/**
 * @author mayank
 *
 */
public class NotificationAndTicketServices {

	public List<HashMap<String, Object>> getNotificationAndTicket(int userId)
	{
		DBUTILS util = new DBUTILS();		
		String getNotification ="SELECT istar_notification.ID, 	title, 	details , sender_id, created_at, type,	COALESCE(user_profile.first_name, 'NA') as first_name FROM 	istar_notification,  user_profile WHERE status = 'UNREAD' and user_profile.user_id = sender_id and 	( 		receiver_id = "+userId+" 		OR sender_id = "+userId+" 	) AND TYPE in ( '"+NotificationType.ADMIN_NOTIFICATION+"', '"+NotificationType.TICKET_NOTIFICATION+"')";
		List<HashMap<String, Object>> notices = util.executeQuery(getNotification);		
		return notices;
	}
	
	public void markNotificationAsRead(String notificationID){
		System.out.println(notificationID);
		DBUTILS util = new DBUTILS();
		String sql = "UPDATE istar_notification SET status = 'READ'  WHERE 	( 		cast(id as varchar) = '"+notificationID+"' 	)"; 
		util.executeUpdate(sql);
		System.out.println(sql);
		
		
	}
	
	public List<HashMap<String, Object>> getTickets(int user_id)
	{
		DBUTILS util = new DBUTILS();
		String sql = "select id, title, description, creator_id, receiver_id, created_at, updated_at, status, ticket_type from ticket where ticket.creator_id = "+user_id+" or ticket.receiver_id ="+user_id;
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;
	}
	public List<HashMap<String, Object>> getTicket(String ticketID)
	{
		DBUTILS util = new DBUTILS();
		String sql = "select id, title, description, creator_id, receiver_id, created_at, updated_at, status, ticket_type from ticket where ticket.id ="+ticketID;
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;
	}
	public List<HashMap<String, Object>> getTicketSummary(String ticket_id)
	{
		DBUTILS util = new DBUTILS();
		String sql = "select ticket.id, ticket.title, ticket.description, ticket.creator_id, ticket.receiver_id, ticket.created_at, ticket.updated_at, ticket.status, ticket.ticket_type, ticket.tags, ticket_comment.comment_by, ticket_comment.created_at as comment_created_at,ticket_comment.comment from ticket,ticket_comment where ticket.id = ticket_comment.ticket_id and ticket.id = "+ticket_id+" order by comment_created_at";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;
	}
	
	public void createTicket(String title, String description,String creatorId, String receiverId, String status, String ticketType)
	{
		DBUTILS util = new DBUTILS();
		String createTicket="INSERT INTO ticket (id, title, description, creator_id, receiver_id, created_at, status, ticket_type, updated_at) VALUES "
				+ "((select COALESCE(max(id),0)+1 from ticket), '"+title+"', '"+description+"', "+creatorId+", "+receiverId+", now(), '"+status+"', '"+ticketType+"', now());";
		util.executeUpdate(createTicket);
	}
}
