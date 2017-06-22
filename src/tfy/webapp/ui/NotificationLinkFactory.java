package tfy.webapp.ui;

import com.istarindia.android.pojo.NotificationPOJO;

public class NotificationLinkFactory {

	public static String getURL(NotificationPOJO notification, int istarUSERID) {
		/*
		 * notification.getItemType().equalsIgnoreCase("ASSESSMENT") ||
		 * notification.getItemType().equalsIgnoreCase("CLASSROOM_SESSION") ||
		 * notification.getItemType().equalsIgnoreCase("LESSON") ||
		 * notification.getItemType().equalsIgnoreCase("MESSAGE")
		 */

		switch (notification.getItemType()) {
		case "ASSESSMENT":
			return "/student/user_assessment.jsp?task_id=" + notification.getItem().get("taskId") + "&assessment_id="
					+ notification.getItemId().intValue() + "&user_id=" + istarUSERID;

		case "LESSON":
			return "/student/presentation.jsp?lesson_id=" + notification.getItemId().intValue()	;
		
		
		case "LESSON_PRESENTATION":
			return "/student/presentation.jsp?lesson_id=" + notification.getItemId().intValue()	;
		
		case "CLASSROOM_SESSION":
			return "#";

		case "MESSAGE":
			return "#";
		default:
			return "#";
		}


	}
}
