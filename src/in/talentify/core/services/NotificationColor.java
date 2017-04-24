/**
 * 
 */
package in.talentify.core.services;

/**
 * @author mayank
 *
 */
public class NotificationColor {

	
	public String getColor(String type)
	{
		switch(type)
		{
		case "ADMIN_NOTIFICATION":
			return "info";
			
		case "UPDATE_COMPLEX_OBJECT":
			return "info";
			
		case "LESSON_PUBLISHED":
			return "info";
			
		case "ASSESSMENT_EVENT":
			return "info";
			
		case "PLAY_PPT":
			return "info";
			
		case "PLAY_ASSESSMENT":
			return "info";
			
		case "UPDATE_COMPLEX_OBJECT_MESSAGE":
			return "info";
			
		case "TICKET_NOTIFICATION":
			return "danger";
			
		default: 
			return "info";
						
		}
	}
	


}
