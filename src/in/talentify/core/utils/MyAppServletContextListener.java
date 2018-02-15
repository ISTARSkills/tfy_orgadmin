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
		//ViksitLogger.logMSG(this.getClass().getName(),"ServletContextListener destroyed");
	}

/*	// Run this before web application is started
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		try {
			InputStream targetStream = getClass().getClassLoader().getResourceAsStream("istarNotification-a99cf1d1dd05.json");
			FirebaseOptions options = new FirebaseOptions.Builder().setDatabaseUrl("https://istarnotification.firebaseio.com/").setServiceAccount(targetStream).build();
			FirebaseApp.initializeApp(options);
			//ViksitLogger.logMSG(this.getClass().getName(),"ServletContextListener started");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
		}
	}*/
	
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		try {
			////ViksitLogger.logMSG(this.getClass().getName(),"ServletContextListener starting ArgAdmin");
			InputStream targetStream = MyAppServletContextListener.class.getClassLoader().getResourceAsStream("istartv2-fde8335fd63d.json");
			FirebaseOptions options = new FirebaseOptions.Builder().setDatabaseUrl("https://istartv2.firebaseio.com/").setServiceAccount(targetStream).build();
			FirebaseApp.initializeApp(options);
			//ViksitLogger.logMSG(this.getClass().getName(),"ServletContextListener started OrgAdmin");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	
}
