package in.talentify.core.utils;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class AndroidNoticeDelegator {

	String deployment_type="";
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");

	public AndroidNoticeDelegator() {
		super();
		initAndroidNoticeDelegator();
	}

	private void initAndroidNoticeDelegator() {
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			deployment_type = properties.getProperty("deploymentType");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

	// Send notification to a ALL USERS of GROUP (List)
	// The argument value inside the HashMap<String, Object> item is based upon
	// "type" of entity
	// if type = "lesson", the keys should be--> lessonId, lessonType, courseId,
	// moduleId, cmsessionId
	// if type = "assessment", the keys should be --> assessmentId,
	// assessmentType (if required), courseId
	public void sendNotificationToGroup(List<String> allIstarUserIds, String message, String type,
			HashMap<String, Object> item) {
		if (deployment_type.equalsIgnoreCase("prod")) {

			for (String istarUserId : allIstarUserIds) {
				DatabaseReference databaseReferenceForUser = FirebaseDatabase.getInstance()
						.getReference("istar-notification").child(istarUserId);

				// databaseReferenceForUser.child(istarUserId);
				Map<String, Object> hopperUpdates = new HashMap<String, Object>();
				hopperUpdates.put("item", item);
				hopperUpdates.put("message", message);
				hopperUpdates.put("type", type);
				hopperUpdates.put("time", dateFormat.format(new Date()));
				// hopperUpdates.put("eventDate", eventDate);
				// databaseReferenceForUser.setValue(hopperUpdates);

				String key = databaseReferenceForUser.push().getKey();
				databaseReferenceForUser.child(key).updateChildren(hopperUpdates);

			}
			/*
			 * try { Thread.sleep(10000); } catch (InterruptedException e) {
			 * //System.out.println("error in sending notification"); }
			 */
			//System.out.println("Notification sent to all the users");
		} else {
			//System.out.println("DEV SERVER");
			for (String istarUserId : allIstarUserIds) {
				DatabaseReference databaseReferenceForUser = FirebaseDatabase.getInstance()
						.getReference("istar-notification-dev").child(istarUserId);

				Map<String, Object> hopperUpdates = new HashMap<String, Object>();
				hopperUpdates.put("item", item);
				hopperUpdates.put("message", message);
				hopperUpdates.put("type", type);
				hopperUpdates.put("time", dateFormat.format(new Date()));
				// hopperUpdates.put("eventDate", eventDate);
				// databaseReferenceForUser.setValue(hopperUpdates);
				String key = databaseReferenceForUser.push().getKey();
				databaseReferenceForUser.child(key).updateChildren(hopperUpdates);
			}
			/*
			 * try { Thread.sleep(10000); } catch (InterruptedException e) {
			 * //System.out.println("error in sending notification"); }
			 */
			//System.out.println("Notification sent to all the users");
		}
	}

	public void sendNotificationToUser(int notificationId, String istarUserId, String message, String type,
			HashMap<String, Object> item) {
		if (deployment_type.equalsIgnoreCase("prod")) {

			DatabaseReference databaseReferenceForUser = FirebaseDatabase.getInstance()
					.getReference("istar-notification").child(istarUserId);

			// databaseReferenceForUser.child(istarUserId);
			Map<String, Object> hopperUpdates = new HashMap<String, Object>();
			hopperUpdates.put("id", notificationId);
			hopperUpdates.put("item", item);
			hopperUpdates.put("message", message);
			hopperUpdates.put("type", type);
			hopperUpdates.put("time", dateFormat.format(new Date()));
			// hopperUpdates.put("eventDate", eventDate);
			// databaseReferenceForUser.setValue(hopperUpdates);

			String key = databaseReferenceForUser.push().getKey();
			databaseReferenceForUser.child(key).updateChildren(hopperUpdates);

			/*
			 * try { Thread.sleep(10000); } catch (InterruptedException e) {
			 * //System.out.println("error in sending notification"); }
			 */
			//System.out.println("Notification sent to all the users");
		} else {
			//System.out.println("DEV SERVER");

			DatabaseReference databaseReferenceForUser = FirebaseDatabase.getInstance()
					.getReference("istar-notification-dev").child(istarUserId);

			Map<String, Object> hopperUpdates = new HashMap<String, Object>();
			hopperUpdates.put("id", notificationId);
			hopperUpdates.put("item", item);
			hopperUpdates.put("message", message);
			hopperUpdates.put("type", type);
			hopperUpdates.put("time", dateFormat.format(new Date()));
			// hopperUpdates.put("eventDate", eventDate);
			// databaseReferenceForUser.setValue(hopperUpdates);

			String key = databaseReferenceForUser.push().getKey();
			databaseReferenceForUser.child(key).updateChildren(hopperUpdates);

			/*
			 * try { Thread.sleep(10000); } catch (InterruptedException e) {
			 * //System.out.println("error in sending notification"); }
			 */
			//System.out.println("Notification sent to all the users");
		}
	}

	/*
	 * public void sendAndroidNotification(String type,ArrayList<String>
	 * studentIDs, String message,String hidden_id) {
	 * 
	 * if (!deployment_type.equalsIgnoreCase("local")) { ExecutorService
	 * executor = Executors.newFixedThreadPool(50); for (String stuid :
	 * studentIDs) { DatabaseReference ref =
	 * FirebaseDatabase.getInstance().getReference(stuid); int stu =
	 * Integer.parseInt(stuid); //System.out.println("sending notification " +
	 * message + " to " + stu); Map<String, Object> hopperUpdates = new
	 * HashMap<String, Object>();
	 * 
	 * //System.out.println("------------result---------new publsidh---------"+
	 * type +"-"+hidden_id+"-"+ message);
	 * 
	 * hopperUpdates.put("type", type); hopperUpdates.put("hidden_id",
	 * hidden_id); hopperUpdates.put("message", message);
	 * 
	 * ref.push().setValue(hopperUpdates); try { Thread.sleep(5000); } catch
	 * (InterruptedException e) { // TODO Auto-generated catch block
	 * e.printStackTrace(); } // Runnable worker = new PublishHandler(stu); //
	 * executor.execute(worker);
	 * 
	 * }
	 * 
	 * }
	 * 
	 * }
	 */

}
