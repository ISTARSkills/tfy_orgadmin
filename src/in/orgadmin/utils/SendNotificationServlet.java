package in.orgadmin.utils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.istarindia.apps.service.NotificationService;
import com.istarindia.apps.services.controllers.IStarBaseServelet;
import com.publisher.utils.PublishDelegator;

@WebServlet("/send_notification_recruiter")
public class SendNotificationServlet extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public SendNotificationServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("Printing Notifications");
		printParams(request);
		printAttrs(request);

		String[] allReceiver = request.getParameter("student_id").split(",");
		
		ArrayList<String> allReceiverIds = new ArrayList<String>();
		
		for(String receiver:allReceiver){
			if(!receiver.equalsIgnoreCase("")){
			allReceiverIds.add(receiver);
			}
			}
		
		int senderId = Integer.parseInt(request.getParameter("recruiter_id"));
		String notificationMessage = request.getParameter("msg");
		String notificationSubject = "Job Notification";
		String notificationType = "JOBS";
		String notificationAction = "No Action Required"; // To be done later
		String hiddenID = "No Session";

		System.out.println("Sending Notifications to: " + request.getParameter("student_id").toString());
		System.out.println("Message:" +notificationMessage);
		System.out.println("From" + senderId);
		
		NotificationService service = new NotificationService();
		for (String receiverId : allReceiverIds) {

			if (!receiverId.equalsIgnoreCase("") && !notificationMessage.trim().isEmpty()) {
				System.out.println("Sending Notification");
				service.createNONEventBasedNotification(notificationMessage, Integer.parseInt(receiverId), senderId,
						notificationSubject, notificationType, notificationAction);
				PublishDelegator pd = new PublishDelegator();
				pd.publishAfterCreatingNotification(allReceiverIds, notificationSubject, notificationMessage, hiddenID);				
				System.out.println("Notification Sent");
			}else{
				System.out.println("Blank Message Sent");
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
