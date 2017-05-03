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

public class AndroidNoticeDelegator {

	String deployment_type;

	public AndroidNoticeDelegator() {
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

	public void sendAndroidNotification(String type,ArrayList<String> studentIDs, String message,String hidden_id) {

		if (!deployment_type.equalsIgnoreCase("local")) {
			ExecutorService executor = Executors.newFixedThreadPool(50);
			for (String stuid : studentIDs) {
				DatabaseReference ref = FirebaseDatabase.getInstance().getReference(stuid);
				int stu = Integer.parseInt(stuid);
				System.out.println("sending notification " + message + " to " + stu);
				Map<String, Object> hopperUpdates = new HashMap<String, Object>();
				
				System.out.println("------------result---------new publsidh---------"+ type +"-"+hidden_id+"-"+ message);

				hopperUpdates.put("type", type);
				hopperUpdates.put("hidden_id", hidden_id);			
				hopperUpdates.put("message", message);

				 ref.push().setValue(hopperUpdates);
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