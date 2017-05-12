package in.talentify.core.controllers;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import tfy.admin.services.EmailService;
import tfy.admin.services.SMSServices;


/**
 * Servlet implementation class ChangeTicketStatusController
 */
@WebServlet("/change_ticket_status")
public class ChangeTicketStatusController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangeTicketStatusController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		String ticketId = request.getParameter("ticketId");
		String status = request.getParameter("status");
		
		EmailService serv = new EmailService();
		SMSServices smsService = new SMSServices();
		DBUTILS util= new DBUTILS();
		String updateTicket="update ticket set status ='"+status+"', updated_at=now() where id ="+ticketId;
		util.executeUpdate(updateTicket);
		ArrayList<String> receiverEmails = new ArrayList<>();
		ArrayList<String> receiverMobiles = new ArrayList<>();
		
		String sql ="select * from ticket where id="+ticketId;
		List<HashMap<String, Object>> tctData = util.executeQuery(sql);
		
				
		
		
		/*if(otherMembers!=null)
		{
			for(String email : otherMembers.split(","))
			{
				if(email.contains("@") && !receiverEmails.contains(email))
				{
					receiverEmails.add(email);
				}
			}
		}*/
		try{
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			if(tctData.size()>0)
			{
				if(tctData.get(0).get("accociated_user_email")!=null && !tctData.get(0).get("accociated_user_email").toString().equalsIgnoreCase(""))
				{
					for(String email : tctData.get(0).get("accociated_user_email").toString().split(","))
					{
						if(email.contains("@") && !receiverEmails.contains(email))
						{
							receiverEmails.add(email);
						}
					}
				}
				if(tctData.get(0).get("department")!=null)
				{
					String dep = tctData.get(0).get("department").toString();
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
			}
			
			
			
			
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		serv.emailTicketStatusChange(receiverEmails,Integer.parseInt(ticketId), status);
		smsService.sendTicketStatusChangeAsSMSToUsers(receiverEmails, Integer.parseInt(ticketId), status);
		
		response.getWriter().write(status);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}