package in.talentify.core.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.utilities.TicketStates;

import in.talentify.core.services.NotificationAndTicketServices;



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
		if(request.getParameterMap().containsKey("title") && request.getParameterMap().containsKey("description") && request.getParameterMap().containsKey("ticket_type") && request.getParameterMap().containsKey("receivers") 
				&& request.getParameterMap().containsKey("created_by") )
		{
			String title=request.getParameter("title");
			String description=request.getParameter("description");
			String ticketType=request.getParameter("ticket_type");
			String receivers [] = request.getParameterValues("receivers");
			String createdBy = request.getParameter("created_by");
			NotificationAndTicketServices serv = new NotificationAndTicketServices();
			System.out.println(receivers.length);
			IstarUser user = new IstarUserDAO().findById(Integer.parseInt(createdBy));
			 user_type = user.getUserRoles().iterator().next().getRole().getRoleName();
			for(String recievr : receivers)
			{
				serv.createTicket(title, description, createdBy, recievr, TicketStates.RAISED, ticketType);
			}	
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
