package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.service.NotificationService;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class AllPublishedSessionsFilter
 */
@WebServlet("/AllPublishedSessionsFilter")
public class AllPublishedSessionsFilter extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AllPublishedSessionsFilter() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		
		int	course_id = Integer.parseInt(request.getParameter("course_id"));
		NotificationService notify = new NotificationService();
		
		HashMap<String, String> session_list =notify.getAllPublishedSessionsFilter(course_id);
		StringBuffer sb = new StringBuffer();
		sb.append("<option value='No Session' disabled selected>No Session</option>");
		
		for(String session_id:session_list.keySet()){
			
			sb.append("<option value='"+session_id+"'>"+session_list.get(session_id)+"</option>");
		}
		
		response.getWriter().print(sb);
	}



	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
		
	}

}
