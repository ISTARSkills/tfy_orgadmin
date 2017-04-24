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
}
