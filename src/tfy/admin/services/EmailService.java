package tfy.admin.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {
	
	
	public void emailTicketToTargetUsers(ArrayList<String>emails, int ticketId)
	{
		
	}
	
public void sendInviteMail(String email, String name, String password) {
		
		String subject="Welcome to Talentify";
		
	 String message = "Hi " + name + ", Your user id is: " + email
	+ " and password is "+password;
	
	 Runnable mailThread =	new Runnable() {
			@Override
			public void run() {
				sendEmail(email, subject, message);
				System.out.println("Starting Thread for sending mail");
			}
		};
		
		mailThread.run();
	}
	
	
	public  void sendEmail(String emailTo, String subject, String message)
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
			javax.mail.Session session = javax.mail.Session.getInstance(properties, auth);
			InternetAddress[] iAdressArray = InternetAddress.parse(emailTo);

			// creates a new e-mail message
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(senderEmail));
			msg.setRecipients(Message.RecipientType.TO, iAdressArray);
			msg.setSubject(subject);
			msg.setSentDate(new Date());
			
			msg.setContent(message, "text/html; charset=utf-8");

			// sends the e-mail
			Transport.send(msg);
			System.out.println("sending");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void emailTicketStatusChange(ArrayList<String> receiverEmails, int parseInt, String status) {
		// TODO Auto-generated method stub
		
	}

}
