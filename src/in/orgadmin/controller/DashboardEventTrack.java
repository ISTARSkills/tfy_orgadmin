package in.orgadmin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Slide;
import com.istarindia.apps.services.controllers.IStarBaseServelet;


@WebServlet("/get_lastest_slide_of_event")
public class DashboardEventTrack extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
   
    public DashboardEventTrack() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		int slide_id = 6060;
		int ppt_id = 6060;
		String url = null;
		DBUTILS db = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String event_id = request.getParameter("event_id");
		
		String sql = "SELECT slide_id,ppt_id FROM event_session_log WHERE event_id = '"+event_id+"' ORDER BY 	ID DESC LIMIT 1";
		
		  List<HashMap<String, Object>> data = db.executeQuery(sql);
			 
			if(data.size() != 0 ){
				for (HashMap<String, Object> row2 : data) {
					
					slide_id = (int) row2.get("slide_id");
					ppt_id = (int) row2.get("ppt_id");
					url = ppt_id+"#"+slide_id;
				
				}
				
       sb.append("<div class='tab-pane fade in active' id='desktop'>");
       
       
       sb.append("<iframe id='d-preview desktop-preview-frame' class='col-lg-12' style='height: 46em;' src='http://beta.talentify.in:8080/content/lesson/preview_desktop.jsp?src=orgadmin&ppt_id="+url+"'> </iframe>");
      //sb.append("<iframe id='d-preview desktop-preview-frame' class='col-lg-12' style='height: 46em;' src='http://localhost:8080/content/lesson/preview_desktop.jsp?src=orgadmin&ppt_id="+url+"'> </iframe>");
      	
			
	
		sb.append("</div>");
		
	}
			else{
		
		sb.append("<div class='well'>");
		
		sb.append("<h1 class='text-center'>NO DATA</h1>");

		sb.append("</div>");
		
		 
			

	
		
		
		
	}
		
			System.out.println("-----------event_id-----------------"+event_id);

			System.out.println("-----------url-----------------"+url);
			
		
		response.getWriter().print(sb);
		
	}

	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
