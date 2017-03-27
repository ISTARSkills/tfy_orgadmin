package in.orgadmin.utils;

import java.util.Date;
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

public class EmailUtils {

	public static void sendEmail(String emailTo, String subject, String message)
 {

		try {
			String senderEmail = "vaibhav@istarindia.com";
			String senderPassword = "U6Zt0CrZBDnKvnHTNl2EKA";

			// sets SMTP server properties
			Properties properties = new Properties();
			properties.put("mail.smtp.host", "smtp.mandrillapp.com");
			properties.put("mail.smtp.port", "587");
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.starttls.enable", "false");

			// creates a new session with an authenticator
			Authenticator auth = new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(senderEmail, senderPassword);
				}
			};

			// Create transport session
			Session session = Session.getInstance(properties, auth);
			InternetAddress[] iAdressArray = InternetAddress.parse(emailTo);

			// creates a new e-mail message
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(senderEmail));
			msg.setRecipients(Message.RecipientType.TO, iAdressArray);
			msg.setSubject(subject);
			msg.setSentDate(new Date());
			msg.setText(message);

			// sends the e-mail
			Transport.send(msg);
			System.out.println("sending");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	
	public static void main(String[] args) {
		EmailUtils e = new EmailUtils();
		e.sendEmail("vaibhav@istarindia.com", "poaurfyoidsjghof", "dddd4444444444444444444");
		System.out.println("sent");
	}
}
