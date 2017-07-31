package tfy.webapp.ui;

import com.istarindia.android.pojo.NotificationPOJO;

public class NotificationLinkFactory {

	public static String getURL(NotificationPOJO notification, int istarUSERID) {
		switch (notification.getItemType()) {
		case "ASSESSMENT":
			return "/student/user_assessment.jsp?task_id=" + ((Double) notification.getItem().get("taskId")).intValue()
					+ "&assessment_id=" + notification.getItemId().intValue() + "&user_id=" + istarUSERID;

		case "LESSON":
			return "/student/presentation.jsp?lesson_id=" + notification.getItemId().intValue();

		case "LESSON_PRESENTATION":
			return "/student/presentation.jsp?lesson_id=" + notification.getItemId().intValue();

		case "WEBINAR_STUDENT":
			return "/start_webinar?task_id="+notification.getItemId().intValue();

		case "WEBINAR_TRAINER":
			return "/start_webinar?task_id="+notification.getItemId().intValue();

		case "REMOTE_CLASS_TRAINER":
			return "#";

		case "REMOTE_CLASS_STUDENT":
			return "#";
			
		case "CLASSROOM_SESSION":
			return "#";

		case "MESSAGE":
			return "#";
		default:
			return "#";
		}

	}
}
