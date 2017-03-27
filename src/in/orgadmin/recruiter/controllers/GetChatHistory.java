package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.ocpsoft.prettytime.PrettyTime;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class GetChatHistory
 */
@WebServlet("/get_chat_history")
public class GetChatHistory extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetChatHistory() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String  sender_id= request.getParameter("sender_id");
		String  receiver_id= request.getParameter("receiver_id");
   	 	String sql ="select details, created_at from istar_notification where sender_id="+sender_id+" and receiver_id="+receiver_id+" and type='JOBS' order by created_at  ";
   	 	System.out.println(sql);
   	 	DBUTILS util = new DBUTILS();
   	 	StringBuffer sb = new StringBuffer();
   	 SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
   	 	for(HashMap<String, Object> row: util.executeQuery(sql))
   	 	{
   	 		String details =(String )row.get("details");
   	 		Timestamp datetime = (Timestamp)row.get("created_at");
   	 		try {
				String prettyTimeString = new PrettyTime().format(formatter.parse(datetime.toString()));
				sb.append("<div class='message' style=' margin-left: 0px; padding: 10px 7px;'>");
   	 			sb.append("<span class='message-date'> "+prettyTimeString+"</span>");
   	 				sb.append("<span class='message-content'>");
   	 					sb.append(""+details+"");
   	 						sb.append("</span>");
   	 							sb.append("</div>");
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
   	 		
   	 	}
   	 	   	 	
   	 response.getWriter().print(sb.toString());
		
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
