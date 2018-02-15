package in.talentify.core.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;



/**
 * Servlet implementation class AddCommentToTicket
 */
@WebServlet("/add_comment_to_ticket")
public class AddCommentToTicket extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddCommentToTicket() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		//ticketId:tiketId, message:message,commentBy:commentBy
		String ticketId = request.getParameter("ticketId");
		String message=request.getParameter("message");
		String commentBy = request.getParameter("commentBy");
		DBUTILS util = new DBUTILS();
		String insertComment="INSERT INTO ticket_comment (id, ticket_id, comment, comment_by, created_at) VALUES ((select COALESCE(max(id),0)+1 from ticket_comment), "+ticketId+", '"+message.replaceAll("'", "")+"',"+commentBy+" , now());";
		util.executeUpdate(insertComment);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
