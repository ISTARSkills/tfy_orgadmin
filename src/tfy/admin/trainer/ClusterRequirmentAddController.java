package tfy.admin.trainer;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class ClusterRequirmentAddController
 */
@WebServlet("/cluster_requirment_add")
public class ClusterRequirmentAddController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ClusterRequirmentAddController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		
		int pincode=Integer.parseInt(request.getParameter("pincode"));
		int course=Integer.parseInt(request.getParameter("course"));
		int requirement=Integer.parseInt(request.getParameter("requirement"));
		
		ClusterRequirmentUtil util=new ClusterRequirmentUtil();
		util.addRequirment(pincode, course, requirement);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
