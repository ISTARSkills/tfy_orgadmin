package in.talentify.core.utils;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.viksitpro.core.utilities.DBUTILS;

public class PublishDelegator {

	String deployment_type;

	public PublishDelegator() {
		super();
		initPublishDelegator();
	}

	private void initPublishDelegator() {
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			deployment_type = properties.getProperty("deployment_type");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

	public void publishAfterCreatingNotification(ArrayList<String> studentIDs, String title, String comment,
			String hidden_id, String courseName, String lessonName) {

		if (!deployment_type.equalsIgnoreCase("local")) {
			ExecutorService executor = Executors.newFixedThreadPool(50);

			for (String stuid : studentIDs) {
				DatabaseReference ref = FirebaseDatabase.getInstance().getReference(stuid);
				int stu = Integer.parseInt(stuid);
				System.out.println("sending notification " + title + " to " + stu);
				Map<String, Object> hopperUpdates = new HashMap<String, Object>();
				if (!hidden_id.equalsIgnoreCase("No_Session")) {

					String[] parts = hidden_id.split(";");

					String sql = "WITH ins1 AS ( 	INSERT INTO task ( 		ID, 		NAME, 		description, 		task_type, 		priority, 		OWNER, 		actor, 		STATE, 		parent_task, 		start_date, 		end_date, 		duration_in_hours, 		assignee_team, 		assignee_member, 		is_repeatative, 		followup_date, 		is_active, 		tags, 		created_at, 		updated_at, 		item_id, 		item_type, 		project_id, 		is_timed_task, 		follow_up_duration_in_days 	) 	VALUES 		( 			(SELECT MAX(ID) + 1 FROM task), 			'"
							+ lessonName
							+ "', 			NULL, 			'4', 			'1', 			'300', 			'" + stuid
							+ "', 			'INCOMPLETE', 			NULL, 			now(), 			now(), 			NULL, 			NULL, 			NULL, 			'f', 			NULL, 			't', 			NULL, 			now(), 			now(), 			'"
							+ parts[1]
							+ "', 			'LESSON', 			NULL, 			NULL, 			NULL 		) RETURNING ID )	INSERT INTO istar_notification ( 		ID, 		sender_id, 		receiver_id, 		title, 		details, 		status, 		ACTION, 		TYPE, 		is_event_based, 		created_at, 		task_id 	) SELECT 		( 			SELECT 				COALESCE (MAX(ID) + 1, 1) 			FROM 				istar_notification 		), 		300, 		'"
							+ stuid + "', 		'" + title + "', '" + comment + " \n " + courseName + " - " + lessonName
							+ ";" + hidden_id
							+ "', 		'UNREAD', 		NULL, 		'INCOMPLETE', 		't', 		now(), 		ins1. ID 	FROM 		ins1";
					DBUTILS db = new DBUTILS();
					db.executeUpdate(sql);
					
					String student_playlist_sql = "INSERT INTO student_playlist ( 	id, 	student_id, 	course_id, 	lesson_id, 	status ) VALUES 	( 		(SELECT MAX(ID) + 1 FROM student_playlist), 		'"+stuid+"', 		'"+parts[0]+"', 		'"+parts[1]+"', 		'INCOMPLETE' 	); ";

					db.executeUpdate(student_playlist_sql);
					
					if (!title.equalsIgnoreCase("UPDATE_COMPLEX_OBJECT")) {

						System.out.println("------------result------------------" + title + " - " + comment + courseName
								+ " - " + lessonName);

						hopperUpdates.put("type", "PLAY_LESSON");
						hopperUpdates.put("hidden_id", hidden_id);
						hopperUpdates.put("message", title + " \n" + comment + " \n" + courseName + " - " + lessonName);
					} else {

						System.out.println("------------result------------------" + title + " - " + comment + courseName
								+ " - " + lessonName);

						hopperUpdates.put("type", "PLAY_LESSON");
						hopperUpdates.put("hidden_id", hidden_id);
						hopperUpdates.put("message", "NO_MESSAGE" + " \n" + courseName + " - " + lessonName);

					}

				}

				else if (hidden_id.equalsIgnoreCase("No_Session") && title.equalsIgnoreCase("UPDATE_COMPLEX_OBJECT")) {
					hopperUpdates.put("type", "UPDATE_COMPLEX_OBJECT");
					hopperUpdates.put("hidden_id", "NO_ID");
					hopperUpdates.put("message", "NO_MESSAGE");
				} else {
					hopperUpdates.put("type", "MESSAGE");
					hopperUpdates.put("hidden_id", "NO_ID");
					hopperUpdates.put("message", title + " \n" + comment);
					System.out.println("------------result------------------" + title + " " + comment);
				}

				// ref.push().setValue(hopperUpdates);
				try {
					Thread.sleep(5000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				// Runnable worker = new PublishHandler(stu);
				// executor.execute(worker);

			}

		}

	}

}
