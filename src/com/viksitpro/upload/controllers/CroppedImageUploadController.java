package com.viksitpro.upload.controllers;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFilePermission;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class CroppedImageUploadController
 */
@WebServlet("/cropped_image_uploader")
public class CroppedImageUploadController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CroppedImageUploadController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @throws IOException 
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		MediaUploadServices mediaUploadServices = new MediaUploadServices();
		Set<PosixFilePermission> perms = mediaUploadServices.getPermissions();
		//doGet(request, response);
		System.err.println("CROPPED IMAGE UPPLAODER CALLED");
		if(request.getParameterMap().containsKey("image_base_64")){
			//System.err.println(request.getParameter("image_base_64"));	
			String base64Image = request.getParameter("image_base_64").split(",")[1];
			byte[] imageInByte = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64Image);
			//checking if folder exists
			File file1 = new File(mediaUploadServices.getAnyPath("imagePath"));
			if (file1.exists()) {
				System.out.println(mediaUploadServices.getAnyPath("imagePath") + " Folder exists");
			} else {
				boolean success = (new File(mediaUploadServices.getAnyPath("imagePath"))).mkdirs();
				if (!success) {
					System.err.println("Folder creation failed");
				} else {
					System.err.println("Folder creation succeeded");
				}
			}			
			// write the image to a file
			UUID uui = UUID.randomUUID();
			System.err.println(mediaUploadServices.getAnyPath("imagePath") + uui.toString() + ".png");
			File file = new File(mediaUploadServices.getAnyPath("imagePath"), uui.toString() + ".png");
			file.createNewFile();
			if(mediaUploadServices.getAnyPath("server_type").equalsIgnoreCase("linux")){
				Files.setPosixFilePermissions(file.toPath(), perms);
			}
			InputStream in = new ByteArrayInputStream(imageInByte);
			BufferedImage bImageFromConvert = ImageIO.read(in);
			ImageIO.write(bImageFromConvert, "png", file);			
			if(mediaUploadServices.getAnyPath("server_type").equalsIgnoreCase("linux")){
				Files.setPosixFilePermissions(Paths.get(file.getAbsolutePath()), perms);
			}
			System.err.println(file.getAbsolutePath());
			out.println(mediaUploadServices.getAnyPath("media_url_path")+ "course_images/" + file.getName());
			System.err.println("UPLOADED image url -->" + mediaUploadServices.getAnyPath("imagePath") + file.getName());
		}
	}

}
