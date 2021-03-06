package com.viksitpro.upload.controllers;

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

import com.viksitpro.core.dao.entities.Lesson;

/**
 * Servlet implementation class MediaUploadController
 */
@WebServlet("/upload_media")
public class MediaUploadController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final String UPLOAD_DIRECTORY = "C:/Users/abhinav/workspace";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MediaUploadController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		MediaUploadServices mediaUploadServices = new MediaUploadServices();
		Set<PosixFilePermission> perms = mediaUploadServices.getPermissions();
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException(
					"Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		PrintWriter writer = response.getWriter();
		String lesson_id = "";
		Lesson lesson = new Lesson();
		try {
			List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory())
					.parseRequest(new ServletRequestContext(request));
			for (FileItem item : items) {
				if (!item.isFormField()) {
					if (item.getName().toLowerCase().endsWith(".PNG".toLowerCase())) {
						out = mediaUploadServices.writeToFile(item, perms, out, ".png");
					} else if (item.getName().endsWith(".mp4")) {
						out = mediaUploadServices.writeToFile(item, perms, out, ".mp4");
					} else if (item.getName().endsWith(".gif")) {
						out = mediaUploadServices.writeToFile(item, perms, out, ".gif");
					}
				}
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
}
