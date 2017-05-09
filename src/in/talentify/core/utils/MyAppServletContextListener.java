package in.talentify.core.utils;

import java.io.InputStream;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

@WebListener
public class MyAppServletContextListener implements ServletContextListener {
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		System.out.println("ServletContextListener destroyed");
	}

/*	// Run this before web application is started
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		try {
			InputStream targetStream = getClass().getClassLoader().getResourceAsStream("istarNotification-a99cf1d1dd05.json");
			FirebaseOptions options = new FirebaseOptions.Builder().setDatabaseUrl("https://istarnotification.firebaseio.com/").setServiceAccount(targetStream).build();
			FirebaseApp.initializeApp(options);
			System.out.println("ServletContextListener started");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
		}
	}*/
	
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		try {
			System.out.println("ServletContextListener starting ArgAdmin");
			InputStream targetStream = MyAppServletContextListener.class.getClassLoader().getResourceAsStream("Viksit-ac716147c574.json");
			FirebaseOptions options = new FirebaseOptions.Builder().setDatabaseUrl("https://fir-viksit.firebaseio.com").setServiceAccount(targetStream).build();
			FirebaseApp.initializeApp(options);
			System.out.println("ServletContextListener started OrgAdmin");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	
}
