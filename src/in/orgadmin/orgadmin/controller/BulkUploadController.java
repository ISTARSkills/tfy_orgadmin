package in.orgadmin.orgadmin.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.utils.bulkupload.BulkUploadUtils;

/**
 * Servlet implementation class BulkUploadController
 */
@WebServlet("/excel_upload")
public class BulkUploadController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
	public static File UPLOAD_DIRECTORY;	
	private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB

	/** The Constant MAX_FILE_SIZE. */
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB

	/** The Constant MAX_REQUEST_SIZE. */
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

	/** The Constant UPLOAD_DIRECTORY. */
	private static final String UPLOAD_DIRECTORY_PATH = "upload";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BulkUploadController() {
        super();
        // TODO Auto-generated constructor stub
    }

    @Override
    public void init(ServletConfig config) {
    	File UPLOAD_DIRECTORY = new File(UPLOAD_DIRECTORY_PATH);
		if (!UPLOAD_DIRECTORY.exists()) {
			UPLOAD_DIRECTORY.mkdir();
		}
    }
    
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException("Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		
		//response.setContentType("application/json");
		ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());
		BulkUploadUtils bulkUploadUtils = new BulkUploadUtils();

		File file = null;
		String table = new String();
		HashMap<String, String> paramMap = new HashMap<>();
		
		try {
			List<FileItem> items = uploadHandler.parseRequest(request);
			for (FileItem item : items) {
				if(item.isFormField()) {
					//params in request
					System.err.println("Param: " + item.getFieldName() + " --> " + item.getString());
					paramMap.put(item.getFieldName(), item.getString());
				} else {
					//file in request
					file = getFile(item);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		switch(paramMap.get("type")) {
		case "students" :
			LinkedList<String> columnOrderHolder = new LinkedList<>(); 
			
			for(String item : paramMap.get("column_order").split(",")) {
				if(!(item.equalsIgnoreCase("#") || item.equalsIgnoreCase("NONE"))) {
					columnOrderHolder.add(item);
				}
			}
			
			table = bulkUploadUtils.getStudents(file, columnOrderHolder);
			System.err.println("students file uploaded");
			break;
		default :
			System.err.println("Something is wrong!");
		}
		
		PrintWriter out = response.getWriter();
		out.print(table);
	}

	private File getFile(FileItem formFileItem) {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// sets memory threshold - beyond which files are stored in disk
		factory.setSizeThreshold(MEMORY_THRESHOLD);
		// sets temporary location to store files
		factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

		ServletFileUpload upload = new ServletFileUpload(factory);

		// sets maximum size of upload file
		upload.setFileSizeMax(MAX_FILE_SIZE);

		// sets maximum size of request (include file + form data)
		upload.setSizeMax(MAX_REQUEST_SIZE);

		try {
			File file = null;
			String fileName = new File(formFileItem.getName()).getName();
			String filePath = UPLOAD_DIRECTORY_PATH + File.separator + fileName;
			file = new File(filePath);
			formFileItem.write(file);
			//System.err.println("file name --> " + file.getAbsolutePath());
			return file;
		} catch (org.apache.poi.poifs.filesystem.NotOLE2FileException e) {
			e.printStackTrace();
			com.istarindia.apps.dao.UUIUtils.printlog("java.io.FileNotFoundException");

		} catch (java.io.FileNotFoundException e) {
			com.istarindia.apps.dao.UUIUtils.printlog("java.io.FileNotFoundException");

		} catch (Exception ex) {
			com.istarindia.apps.dao.UUIUtils.printlog("Exception");
			ex.printStackTrace();
		}
		return null;
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
