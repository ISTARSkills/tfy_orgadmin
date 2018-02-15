package tfy.admin.autoscheduler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class GetEntities
 */
@WebServlet("/get_entities")
public class GetEntities extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetEntities() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		int orgId = Integer.parseInt(request.getParameter("org_id"));
		String entityType = request.getParameter("entity_type");
		
		if(entityType.equalsIgnoreCase("USER"))
		{
			
		}
		else if(entityType.equalsIgnoreCase("SECTION"))
		{
			
		}
		else if(entityType.equalsIgnoreCase("ROLE"))
		{
			
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
