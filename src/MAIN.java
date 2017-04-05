import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import com.viksitpro.core.utilities.EmailUtils;

import in.orgadmin.admin.services.EmailService;
import in.talentify.core.utils.EmailSendingUtility;

public class MAIN {
	
	
	public static void main(String[] args) {

	
		
		String email = "sumanth.hgbhat@gmail.com";
		String firstname = "Sumanth";
		String password = "test123";
		System.out.println("-------------------Test -> ");

		
		
			//new EmailSendingUtility();
		//	new EmailService().sendInviteMail(email, firstname,"test123");
		//	EmailUtils.sendEmail(request, emailTo, subject, message);
		try {
			EmailUtils.sendEmail(email, "asdasas das", "asdasdsa");
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			System.out.println("------------------done -> ");


	}
}
