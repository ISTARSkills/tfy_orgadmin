package in.talentify.core.controllers;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.NotificationType;
import com.viksitpro.core.utilities.TicketStates;

import in.talentify.core.services.NotificationAndTicketServices;
import tfy.admin.services.EmailService;
import tfy.admin.services.SMSServices;
/**
 * Servlet implementation class CreateNewTicketController
 */
@WebServlet("/create_new_ticket")
public class CreateNewTicketController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateNewTicketController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		  /*Parameter Name - title, Value - asdasd
			Parameter Name - description, Value - asdasdasd
			Parameter Name - receivers, Value - 5108
			Parameter Name - ticket_type, Value - EARLY_FINISH_CLASS
		  */
		String user_type =null;
		if(		   request.getParameterMap().containsKey("title") 
				&& request.getParameterMap().containsKey("description") 
				&& request.getParameterMap().containsKey("ticket_type") 
				&& request.getParameterMap().containsKey("receivers") 
				&& request.getParameterMap().containsKey("created_by")
				&& request.getParameterMap().containsKey("department"))
		{
			String title=request.getParameter("title").replaceAll("'", "");
			String description=request.getParameter("description").replaceAll("'", "");
			String ticketType[]=request.getParameterValues("ticket_type");
			String receivers [] = request.getParameterValues("receivers");
			String createdBy = request.getParameter("created_by");
			String department[] = request.getParameterValues("department");
			String otherMembers =request.getParameter("other_members");
			IstarNotificationServices noticeServices = new IstarNotificationServices();
			NotificationAndTicketServices serv = new NotificationAndTicketServices();
			System.out.println(receivers.length);
			
			ArrayList<String> receiverEmails = new ArrayList<>();
			ArrayList<String> receiverMobiles = new ArrayList<>();
			
			if(otherMembers!=null)
			{
				for(String email : otherMembers.split(","))
				{
					if(email.contains("@") && !receiverEmails.contains(email))
					{
						receiverEmails.add(email);
					}
				}
			}
			
			try {
				Properties properties = new Properties();
				String propertyFileName = "app.properties";
				InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
				if (inputStream != null) {
					properties.load(inputStream);
				} else {
					throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
				}
				for(String dep : department)
				{
					String departmentHeadEmail = properties.getProperty(dep.toLowerCase()+"_head_email");
					String departmentHeadMobile = properties.getProperty(dep.toLowerCase()+"_head_mobile");
					String otherMemberEmail = properties.getProperty(dep.toLowerCase()+"_other_member_email");
					String otherMemberMobile = properties.getProperty(dep.toLowerCase()+"_other_member_mobile");
					if(departmentHeadEmail!=null && !departmentHeadEmail.equalsIgnoreCase(""))
					{
						for(String email: departmentHeadEmail.split("!#"))
						{
							if(email.contains("@") && !receiverEmails.contains(email)){
								receiverEmails.add(email);	
							}							
						}
					}
					if(otherMemberEmail!=null && !otherMemberEmail.equalsIgnoreCase(""))
					{
						for(String email: otherMemberEmail.split("!#"))
						{
							if(email.contains("@") && !receiverEmails.contains(email)){
								receiverEmails.add(email);	
							}							
						}
					}
					if(departmentHeadMobile!=null && !departmentHeadMobile.equalsIgnoreCase(""))
					{
						for(String mobile: departmentHeadMobile.split("!#"))
						{
							if(!receiverMobiles.contains(mobile)){
								receiverMobiles.add(mobile);	
							}							
						}
					}
					if(otherMemberMobile!=null && !otherMemberMobile.equalsIgnoreCase(""))
					{
						for(String mobile: otherMemberMobile.split("!#"))
						{
							if(!receiverMobiles.contains(mobile)){
								receiverMobiles.add(mobile);	
							}							
						}
					}
				}
				
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			IstarUser user = new IstarUserDAO().findById(Integer.parseInt(createdBy));
			if(!receiverEmails.contains(user.getEmail()))
			{
				receiverEmails.add(user.getEmail());
			}
			if(user.getMobile()!=null && !receiverMobiles.contains(user.getMobile()+""))
			{
				receiverMobiles.add(user.getMobile()+"");
			}
			//got the emails and mobile of all ticket receivers			
			EmailService emailService = new EmailService();
			SMSServices smsService = new SMSServices();
			String groupCode = UUID.randomUUID().toString();
			for(String recievr : receivers)
			{
				for(String tctType : ticketType)
				{
					int ticketId = serv.createTicket(title, description, createdBy, recievr, TicketStates.RAISED, tctType,otherMembers, java.util.Arrays.toString(department));					
					noticeServices.createIstarNotification(300, Integer.parseInt(recievr), title, "", "UNREAD", "TICKET, "+tctType.replace("_", " "), NotificationType.TICKET_NOTIFICATION, false, null, groupCode);
					emailService.emailTicketToTargetUsers(receiverEmails, ticketId);
					smsService.sendTicketAsSMSToUsers(receiverMobiles, ticketId);
				}				
			}			
			
			user_type = user.getUserRoles().iterator().next().getRole().getRoleName();				
		}	
		
		if (user_type.equalsIgnoreCase("SUPER_ADMIN")) {				
			response.sendRedirect("super_admin/super_admin_tickets.jsp");
		} else {
			response.sendRedirect("orgadmin/org_admin_tickets.jsp");
		}
			
		
		
	}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
