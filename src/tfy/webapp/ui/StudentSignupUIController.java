package tfy.webapp.ui;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class StudentSignupUIController
 */
@WebServlet("/student_signup_ui")
public class StudentSignupUIController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private File uploadFolder;
	private String fileUploadPath;
	StringBuffer out = new StringBuffer();

	@Override
	public void init(ServletConfig config) {
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			fileUploadPath = properties.getProperty("fileUploaderPath");
		} catch (Exception e) {
			fileUploadPath = "/var/www/html/android_images";
			e.printStackTrace();
		}
		uploadFolder = new File(fileUploadPath);
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StudentSignupUIController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// printParams(request);
		String redirectType = request.getParameter("redirect");
		if(redirectType != null && !redirectType.equalsIgnoreCase("")){
			if(redirectType.equalsIgnoreCase("create")){
				String userId = request.getParameter("stu_id");
				System.err.println("type--> "+redirectType+" student id --> "+userId);
				DBUTILS db = new DBUTILS();
				String sql = "SELECT email,password from istar_user where id = "+ userId;
				List<HashMap<String, Object>> data = db.executeQuery(sql);
				if(data.get(0) != null){
					System.err.println("login?email=" + data.get(0).get("email") + "&password=" + data.get(0).get("password") + "");
				response.getWriter().println(("login?email=" + data.get(0).get("email") + "&password=" + data.get(0).get("password") + ""));
				}
			}
		}
		out=new StringBuffer();
		if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("ug_degree")) {
			String value = AppProperies.getProperty(request.getParameter("value"));
			String[] lists = value.split("!#");
			for (String key : lists) {
				out.append("<option value='" + key + "'>" + key + "</option>");
			}
		}

		if (request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("pg_degree")) {
			String value = AppProperies.getProperty(request.getParameter("value"));
			String[] lists = value.split("!#");
			for (String key : lists) {
				out.append("<option value='" + key + "'>" + key + "</option>");
			}
		}
		response.getWriter().print(out);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException(
					"Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}

		ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());

		List<FileItem> items = null;
		try {
			items = uploadHandler.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
		}

		String type = "";

		for (FileItem item : items) {
			if (item.getFieldName().equalsIgnoreCase("type")) {
				type = item.getString();
			}
		}

		for (FileItem item : items) {	
			if (!item.isFormField()) {
				String fileExtension = "";
				String imagePath = "";
				if (item.getName().toString().toLowerCase().endsWith(".png")) {
					fileExtension = ".png";
				} else if (item.getName().toString().toLowerCase().endsWith(".jpg")) {
					fileExtension = ".jpg";
				} else if (item.getName().toString().toLowerCase().endsWith(".jpeg")) {
					fileExtension = ".jpeg";
				} else if (item.getName().toString().toLowerCase().endsWith(".pdf")) {
					fileExtension = ".pdf";
				} else if (item.getName().toString().toLowerCase().endsWith(".doc")) {
					fileExtension = ".doc";
				}else if (item.getName().toString().toLowerCase().endsWith(".docx")) {
					fileExtension = ".docx";
				}

				if (!fileExtension.trim().isEmpty()) {
						imagePath = uploadPersonalImage(item, fileExtension, type);
						System.out.println(imagePath);
						out=new StringBuffer();
						out.append(imagePath.trim());
				}
			}
		}
		response.getWriter().print(out);
	}

	private String uploadPersonalImage(FileItem item, String fileExtension, String innerDirectory) {
		Path path = Paths.get(uploadFolder.getAbsolutePath() + "/" + innerDirectory);
		if (Files.exists(path)) {
		} else {
			try {
				Files.createDirectories(path);
			} catch (IOException e) {
				System.err.println("Cannot create directories - " + e);
			}
		}

		File parentFolder = new File(path.toString());

		UUID uuidName = UUID.randomUUID();
		File imageFile = new File(parentFolder, uuidName.toString() + fileExtension);
		String imageURL = "";
		try {
			item.write(imageFile);
			imageURL = "/android_images/" + innerDirectory + "/" + uuidName.toString()+ fileExtension;
			System.out.println("Absolute Path id: " + imageFile.getAbsoluteFile());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return imageURL;
	}

}
