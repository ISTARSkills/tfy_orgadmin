/*package in.orgadmin.zoom;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

public class ZoomServiceController extends IStarBaseServelet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);

		String panelistID = request.getParameter("panelist_id");
		String studentID = request.getParameter("student_id");

		//ViksitLogger.logMSG(this.getClass().getName(),"Checking for User in Zoom DB");

		ZoomClientUserService zoom = new ZoomClientUserService();

		//ViksitLogger.logMSG(this.getClass().getName(),"Making REST Request to Zoom for creating a user");
		zoom.createZoomUser("vaibhav@istarindia.com", 1, "Ravy", "Bathla");
		//ViksitLogger.logMSG(this.getClass().getName(),"Response Recieved from ZOOM");

		//ViksitLogger.logMSG(this.getClass().getName(),"User ID is: " + zoom.getUserID("ravitashaw@istarindia.com"));

		zoom.createMeeting("ravitashaw@istarindia.com");
		//ViksitLogger.logMSG(this.getClass().getName(),"Meeting created for the host");

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

}
*/