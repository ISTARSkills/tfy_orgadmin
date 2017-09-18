package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.attribute.PosixFilePermission;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.jgroups.util.UUID;

import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.upload.controllers.MediaUploadServices;

/**
 * Servlet implementation class InteractiveMediaUploadController
 */
@WebServlet("/interactive_media_upload")
public class InteractiveMediaUploadController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InteractiveMediaUploadController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		response.setContentType("text/html");
		StringBuffer out = new StringBuffer();
		MediaUploadServices mediaUploadServices = new MediaUploadServices();
		Set<PosixFilePermission> perms = mediaUploadServices.getPermissions();
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException(
					"Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		String lesson_id = "";

		Lesson lesson = new Lesson();
		try {
			List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory())
					.parseRequest(new ServletRequestContext(request));
			
			for (FileItem item : items) {
				if(item.isFormField()){
					if(item.getFieldName().equalsIgnoreCase("lesson_id")){
						lesson_id=item.getString();
					}
				}
			}
			
			lesson=new LessonDAO().findById(Integer.parseInt(lesson_id));
			
			for (FileItem item : items) {
				if (!item.isFormField()) {
					String name=UUID.randomUUID().toString();
					if (item.getName().toLowerCase().endsWith(".PNG".toLowerCase())) {
						out = mediaUploadServices.writeToFileForSlide(name,lesson,item,perms ,out, ".png");
					}else if (item.getName().toLowerCase().endsWith(".JPEG".toLowerCase())) {
						out = mediaUploadServices.writeToFileForSlide(name,lesson,item,perms ,out, ".jpeg");
					} else if (item.getName().endsWith(".mp4")) {
						out = mediaUploadServices.writeToFileForSlide(name,lesson,item,perms ,out,  ".mp4");
					} else if (item.getName().endsWith(".gif")) {
						out = mediaUploadServices.writeToFileForSlide(name,lesson,item,perms ,out,  ".gif");
					}else if (item.getName().endsWith(".mp3") || item.getName().endsWith(".wav")) {
						out = mediaUploadServices.writeToFileForSlide(name,lesson,item,perms ,out,  ".mp3");
					}
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
			// TODO: handle exception
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		
		//System.out.println("url----------------------------"+out.toString());
		response.getWriter().println(AppProperies.getProperty("media_url_path")+out.toString());
	
	}

}
