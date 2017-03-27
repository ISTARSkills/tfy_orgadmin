package in.orgadmin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.service.NotificationService;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.utils.OrgadminUtil;

/**
 * Servlet implementation class StudentBatchFilter
 */
@WebServlet("/StudentBatchFilter")
public class StudentBatchFilter extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StudentBatchFilter() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		printParams(request);

		int batchg_id = Integer.parseInt(request.getParameter("batchg_id"));
		OrgadminUtil b_id = new OrgadminUtil();

		b_id.getUserInbatchGroup(batchg_id);
		response.getWriter().print(b_id.getUserInbatchGroup(batchg_id));
	}
	
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
