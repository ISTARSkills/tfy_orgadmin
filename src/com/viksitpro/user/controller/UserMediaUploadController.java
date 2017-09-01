package com.viksitpro.user.controller;

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
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.UserProfile;
import com.viksitpro.core.dao.entities.UserProfileDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.user.service.UserMediaUploadService;

/**
 * Servlet implementation class UserMediaUploadController
 */
@WebServlet("/UserMediaUploadController")
public class UserMediaUploadController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	String url="";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserMediaUploadController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		UserMediaUploadService mediaUploadServices = new UserMediaUploadService();
		Set<PosixFilePermission> perms = mediaUploadServices.getPermissions();
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException(
					"Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		StringBuffer out = new StringBuffer();
		PrintWriter writer = response.getWriter();
		int user_id = 0;
		FileItem imgFile = null;
		String extension = null;
		try {
			List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory())
					.parseRequest(new ServletRequestContext(request));

			for (FileItem item : items) {

				if (item.getFieldName().equalsIgnoreCase("user_id")) {
					user_id = Integer.parseInt(item.getString());
					System.err.println("----------------->" + user_id);
				}

				if (!item.isFormField()) {

					System.err.println("----------------->" + item.getName());

					if (item.getName().toLowerCase().endsWith(".PNG".toLowerCase())) {

						imgFile = item;
						extension = ".png";

					} else if (item.getName().toLowerCase().endsWith(".JPG".toLowerCase())) {

						imgFile = item;
						extension = ".jpg";

					} else if (item.getName().toLowerCase().endsWith(".JPEG".toLowerCase())) {

						imgFile = item;
						extension = ".jpeg";

					}
				}
			}

			if (imgFile != null) {
				
				DBUTILS db = new DBUTILS();
				out = mediaUploadServices.writeUserProfile(imgFile, perms, extension, user_id);
				System.err.println("----------------->" + out.toString());
				
				String sql = "UPDATE user_profile SET profile_image = '"+out.toString()+"' WHERE user_id  = "+user_id+";";								
				db.executeUpdate(sql);
		
				response.getWriter().print(out.toString());
			}

		} catch (FileUploadException e) {
			e.printStackTrace();
			// TODO: handle exception
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			writer.close();
		}

		

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
