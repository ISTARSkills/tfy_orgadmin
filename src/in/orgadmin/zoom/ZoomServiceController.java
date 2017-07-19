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

		//System.out.println("Checking for User in Zoom DB");

		ZoomClientUserService zoom = new ZoomClientUserService();

		//System.out.println("Making REST Request to Zoom for creating a user");
		zoom.createZoomUser("vaibhav@istarindia.com", 1, "Ravy", "Bathla");
		//System.out.println("Response Recieved from ZOOM");

		//System.out.println("User ID is: " + zoom.getUserID("ravitashaw@istarindia.com"));

		zoom.createMeeting("ravitashaw@istarindia.com");
		//System.out.println("Meeting created for the host");

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

}
*/