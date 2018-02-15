package tfy.webapp.ui;

import java.io.File;
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

		String mediaPath = null;
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
				mediaPath = properties.getProperty("mediaPath");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		uploadFolder = new File(mediaPath);
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
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// printParams(request);
		String redirectType = request.getParameter("redirect");
		if (redirectType != null && !redirectType.equalsIgnoreCase("")) {
			if (redirectType.equalsIgnoreCase("create")) {
				String userId = request.getParameter("stu_id");
				//ViksitLogger.logMSG(this.getClass().getName(),("type--> " + redirectType + " student id --> " + userId);
				DBUTILS db = new DBUTILS();
				String sql = "SELECT email,password from istar_user where id = " + userId;
				List<HashMap<String, Object>> data = db.executeQuery(sql);
				if (data.get(0) != null) {
					//ViksitLogger.logMSG(this.getClass().getName(),("login?email=" + data.get(0).get("email") + "&password=" + data.get(0).get("password") + "");
					response.getWriter().println(("login?email=" + data.get(0).get("email") + "&password=" + data.get(0).get("password") + ""));
				}
			}
		}
		out = new StringBuffer();
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
				String selected ="";
						
				
				out.append("<option value='" + key + "'  >" + key + "</option>");
			}
		}
		response.getWriter().print(out);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException("Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}

		ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());

		List<FileItem> items = null;
		// items will include one type {profile_image, resume, marks_10,
		// marks_12}
		try {
			items = uploadHandler.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
		}

		String type = "";
		String studentId = "";
		String fileExtension = "";

		FileItem fileItem = null;

		for (FileItem item : items) {

			if (!item.isFormField()) {

				fileItem = item;
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
				} else if (item.getName().toString().toLowerCase().endsWith(".docx")) {
					fileExtension = ".docx";
				}

			} else {
				if (item.getFieldName().equalsIgnoreCase("type")) {
					type = item.getString();
				}
				if (item.getFieldName().equalsIgnoreCase("student_id")) {
					studentId = item.getString();
				}
			}
		}
		String mediaUrl = "";
		if (!fileExtension.trim().isEmpty() && fileItem != null) {
			out = new StringBuffer();
			switch (type) {
			case "profile_image":
				mediaUrl = uploadMedia(fileItem, fileExtension, "users", studentId).trim();
				updateInDB(mediaUrl, "user_profile", "profile_image", studentId);
				break;
			case "resume":
				mediaUrl = uploadMedia(fileItem, fileExtension, "resumes", studentId).trim();
				updateInDB(mediaUrl, "professional_profile", "resume_url", studentId);
				break;
			case "marks_10":
				mediaUrl = uploadMedia(fileItem, fileExtension, "marks_10", studentId).trim();
				updateInDB(mediaUrl, "professional_profile", "marksheet_10", studentId);
				break;
			case "marks_12":
				mediaUrl = uploadMedia(fileItem, fileExtension, "marks_12", studentId).trim();
				updateInDB(mediaUrl, "professional_profile", "marksheet_12", studentId);
				break;
			default:
				return;
			}

		}

		response.getWriter().print(out);
	}

	private void updateInDB(String mediaUrl, String table_name, String column_name, String studentId) {

		DBUTILS util = new DBUTILS();
		String updateInDB = "update " + table_name + " set " + column_name + " ='" + mediaUrl + "' where user_id = " + studentId;
		util.executeUpdate(updateInDB);

	}

	private String uploadMedia(FileItem fileItem, String fileExtension, String innerDirectory, String studentId) {

		Path path = Paths.get(uploadFolder.getAbsolutePath() + "/" + innerDirectory + "/" + studentId);
		if (Files.exists(path)) {
		} else {
			try {
				Files.createDirectories(path);
			} catch (IOException e) {
				//ViksitLogger.logMSG(this.getClass().getName(),("Cannot create directories - " + e);
			}
		}
		File parentFolder = new File(path.toString());

		UUID uuidName = UUID.randomUUID();
		File imageFile = new File(parentFolder, uuidName.toString() + fileExtension);
		String imageURL = "";
		try {
			fileItem.write(imageFile);
			imageURL = "/" + innerDirectory + "/" + studentId + "/" + uuidName.toString() + fileExtension;
			// //ViksitLogger.logMSG(this.getClass().getName(),"Absolute Path id: " +
			// imageFile.getAbsoluteFile());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return imageURL;
	}

}
