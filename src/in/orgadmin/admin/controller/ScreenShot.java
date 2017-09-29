package in.orgadmin.admin.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.cms.utilities.URLServices;
import com.viksitpro.core.utilities.AppProperies;

/**
 * Servlet implementation class ScreenShot
 */
@WebServlet("/ScreenShot")
public class ScreenShot extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ScreenShot() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 response.setContentType("image/png");
		 
		 int current_slide_id =Integer.parseInt( request.getParameter("current_slide_id"));
		 int lesson_id =Integer.parseInt( request.getParameter("lesson_id"));
		 UUID uuid = UUID.randomUUID();
		    URLServices services = new URLServices();
			
			String live_session_log_url = services.getAnyProp("live_session_log_url");		   
			String server_type = services.getAnyProp("server_type");
			 Process process = null;
			    String pathToPhantomJS = ""; 
				String pathToRasterizeJS = ""; 
				String url = "";
				File outputFile = new File("/tmp/screenshots/", uuid+".png");
				int exitStatus;

			 if(server_type.equalsIgnoreCase("windows")) {
				 String phantom_path = services.getAnyProp("phantom_path_windows");
				 
				   pathToPhantomJS = phantom_path+"bin/phantomjs";
					 pathToRasterizeJS = phantom_path+"examples/rasterize.js"; 
					 url = live_session_log_url+"?current_slide_id="+current_slide_id+"&lesson_id="+lesson_id;
					   
				
				 
				 process = Runtime.getRuntime().exec(pathToPhantomJS + " " + pathToRasterizeJS + " " + url + " " + outputFile.getAbsolutePath() + " " );
				 System.out.println(pathToPhantomJS + " " + pathToRasterizeJS + " " + url + " " + outputFile.getAbsolutePath() + " " );
				 
				   
				 
			}else {
				String phantom_path = services.getAnyProp("phantom_path_linux");
				  pathToPhantomJS = phantom_path+"bin/phantomjs"; 
					 pathToRasterizeJS = phantom_path+"examples/rasterize.js"; 
					 url = live_session_log_url+"?current_slide_id="+current_slide_id+"&lesson_id="+lesson_id;
					   
				
				
				 process = Runtime.getRuntime().exec(pathToPhantomJS + " " + pathToRasterizeJS + " " + url + " " + outputFile.getAbsolutePath() + " " );
				 System.out.println(pathToPhantomJS + " " + pathToRasterizeJS + " " + url + " " + outputFile.getAbsolutePath() + " " );
				  
			}
			 try {
					exitStatus = process.waitFor();
					if (exitStatus != 0) {
						   System.out.println("EXIT-STATUS - " + process.toString());
						   }
				} catch (InterruptedException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} //do a wait here to prevent it running for ever
		  // System.err.println(command);

		    //Process process = Runtime.getRuntime().exec(command);
		    
		  
	        try {
				process.waitFor();
				System.out.println(process.getErrorStream());
				
			} catch (InterruptedException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		    
	         File imageFile = new File("/tmp/screenshots/"+uuid+".png");
	         System.err.println(imageFile.getAbsolutePath());
		    try {
		        BufferedImage bufferedImg = ImageIO.read(imageFile);
		        ServletOutputStream out = response.getOutputStream();
		        ImageIO.write(bufferedImg, "png", out);
		        out.close();
		    } catch (IOException e) {
		        e.printStackTrace();
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