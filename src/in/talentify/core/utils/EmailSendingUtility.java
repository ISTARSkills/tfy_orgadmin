package in.talentify.core.utils;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



 
public class EmailSendingUtility {
	private static final Logger logger = LoggerFactory.getLogger(EmailSendingUtility.class);

    
    public static void sendEmail(String host, String port, final String userName, final String password, String toAddress, String subject, String message) throws AddressException, MessagingException {
		// sets SMTP server properties
		Properties properties = new Properties();
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.port", port);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");
		// creates a new session with an authenticator
		Authenticator auth = new Authenticator() {
			public PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(userName, password);
			}
		};
		//com.viksitpro.core.dao.entities.UUIUtils.printlog("After authenticator and befores session");
		Session session = Session.getInstance(properties, auth);
		// creates a new e-mail message
		Message msg = new MimeMessage(session);
		msg.setFrom(new InternetAddress(userName));
		String address = toAddress;
		InternetAddress[] iAdressArray = InternetAddress.parse(address);
		msg.setRecipients(Message.RecipientType.TO, iAdressArray);
		msg.setSubject(subject);
		msg.setSentDate(new Date());
		msg.setText(message);
		// sends the e-mail
		Transport.send(msg);
	}

	public static void sendEmail(String host, String port, String userName, final String password, HashMap<String, String> toAddress, String subject, String message) throws AddressException, MessagingException {
		try {
			//com.viksitpro.core.dao.entities.UUIUtils.printlog("message sending" + message);
			// sets SMTP server properties
			Properties properties = new Properties();
			properties.put("mail.smtp.host", host);
			properties.put("mail.smtp.port", port);
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.starttls.enable", "true");
			// creates a new session with an authenticator
			Authenticator auth = new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(userName, password);
				}
			};
			//com.viksitpro.core.dao.entities.UUIUtils.printlog("After authenticator and befores session");
			Session session = Session.getInstance(properties, auth);
			// creates a new e-mail message
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(userName));
			String toAddress1 = "";
			for (String iterable_element : toAddress.keySet()) {
				toAddress1 = toAddress1 + "," + iterable_element;
			}
			toAddress1 = toAddress1.replaceFirst(",", "");
			InternetAddress[] iAdressArray = InternetAddress.parse(toAddress1);
			msg.setRecipients(Message.RecipientType.TO, iAdressArray);
			msg.setSubject(subject);
			msg.setSentDate(new Date());
			msg.setText(message);
			// sends the e-mail
			Transport.send(msg);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}