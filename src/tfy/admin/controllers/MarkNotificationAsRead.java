package tfy.admin.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.talentify.core.services.NotificationAndTicketServices;

/**
 * Servlet implementation class MarkNotificationAsRead
 */
@WebServlet("/mark_notice_as_read")
public class MarkNotificationAsRead extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MarkNotificationAsRead() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/*notice_id:notice_id,group_code:group_code,notice_type:notice_type*/
		String noticeId = request.getParameter("notice_id");
		String groupCode = request.getParameter("group_code");
		String noticeType = request.getParameter("notice_type");
		NotificationAndTicketServices serv = new NotificationAndTicketServices();
		if(noticeType.equalsIgnoreCase("SINGLE_NOTICE") && noticeId!=null && !noticeId.equalsIgnoreCase(""))
		{
			// mark notification as read by marking status as read.
			serv.markNotificationAsRead(noticeId);
			
		}
		else if(noticeType.equalsIgnoreCase("GROUP_NOTICE"))
		{
			//mark group notification as read by marking read_by_admin as true.
			serv.markGroupNotificationAsRead(groupCode);
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
