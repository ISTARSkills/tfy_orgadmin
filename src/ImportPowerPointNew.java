
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFilePermission;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.viksitpro.core.cms.oldcontent.CMSLesson;
import com.viksitpro.core.cms.oldcontent.CMSSlide;
import com.viksitpro.core.cms.oldcontent.services.ZipFiles;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.exceptions.EntityNotFoundException;
import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.AppProperies;

/**
 * Servlet implementation class ImportPowerPointNew
 */
@WebServlet("/ImportPowerPointNew")
public class ImportPowerPointNew extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// location to store file uploaded
	private static final String UPLOAD_DIRECTORY = "upload";

	// upload settings
	private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 900; // 900MB
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 900; // 900MB/**

	public ImportPowerPointNew() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(MEMORY_THRESHOLD);
		factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setFileSizeMax(MAX_FILE_SIZE);
		upload.setSizeMax(MAX_REQUEST_SIZE);
		String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) {
			uploadDir.mkdir();
		}
		ArrayList<File> imageFiles = new ArrayList<>();
		String lessonId = null;
		List<FileItem> slideImages = null;
		try {
			slideImages = upload.parseRequest(request);
			for (FileItem fileItem : slideImages) {
				if (fileItem.isFormField()) {
					if (fileItem.getFieldName().equalsIgnoreCase("lesson")) {
						lessonId = fileItem.getString();
					}
				} else {
					if (fileItem.getName().endsWith(".png")) {
						String fileName = UUID.randomUUID().toString() + ".png";
						String filePath = uploadPath + File.separator + fileName;
						File storeFile = new File(filePath);
						fileItem.write(storeFile);
						imageFiles.add(storeFile);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		Integer lessonID = null;
		try {
			lessonID = Integer.parseInt(lessonId);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		if (!(slideImages.size() == (imageFiles.size() + 1)))
			ViksitLogger.logMSG("!!!!!!!!!!ALERT!!!!!!!!! from: " + this.getClass().getName());
		class myRunnable implements Runnable {
			Integer lessonID;
			myRunnable(Integer l) {
				lessonID = l;
			}

			public void run() {
				Lesson l = new LessonDAO().findById(lessonID);
				if (l != null) {
					String apachePath = null;
					String mediaUrlPath = null;
					apachePath = AppProperies.getProperty("apache_path");
					mediaUrlPath = AppProperies.getProperty("media_url_path");
					if (apachePath == null || mediaUrlPath == null) {
						ViksitLogger.logMSG(
								"ALERT >> \"apache_path || media_url_path not defined in app.properties\" from: "
										+ this.getClass().getName());
						return;
					} else {
						File innerDirectory = refreshLessonFolder(lessonID, apachePath);
						ArrayList<String> images = convertPPTtoImages(lessonID, imageFiles, apachePath);
						createLessonXML(lessonID, l, images, apachePath, mediaUrlPath, innerDirectory);
						zipLessonXML(lessonID, apachePath);
					}
				}
			}
		}
		;

		Thread thread = new Thread(new myRunnable(lessonID));
		thread.start();
	}

	private File refreshLessonFolder(Integer lessonId, String apachePath) {
		String directoryName = apachePath + "/lessonXMLs/" + lessonId;
		File directory = new File(directoryName);
		if (!directory.exists()) {
			directory.mkdir();
			try {
				setAsExecutable(directory.getAbsolutePath());
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			try {
				delete(directory);
			} catch (IOException e) {
				e.printStackTrace();
			}
			directory.mkdir();
			try {
				setAsExecutable(directory.getAbsolutePath());
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		directoryName = apachePath + "/lessonXMLs/" + lessonId + "/" + lessonId;
		File innerDirectory = new File(directoryName);
		if (!innerDirectory.exists()) {
			innerDirectory.mkdir();
			try {
				setAsExecutable(innerDirectory.getAbsolutePath());
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			innerDirectory.delete();
			innerDirectory.mkdir();
			try {
				setAsExecutable(innerDirectory.getAbsolutePath());
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return innerDirectory;
	}

	private void setAsExecutable(String filePath) throws IOException {
		Set<PosixFilePermission> perms = new HashSet<PosixFilePermission>();
		// add owners permission
		perms.add(PosixFilePermission.OWNER_READ);
		perms.add(PosixFilePermission.OWNER_WRITE);
		perms.add(PosixFilePermission.OWNER_EXECUTE);
		// add group permissions
		perms.add(PosixFilePermission.GROUP_READ);
		perms.add(PosixFilePermission.GROUP_WRITE);
		perms.add(PosixFilePermission.GROUP_EXECUTE);
		// add others permissions
		perms.add(PosixFilePermission.OTHERS_READ);
		perms.add(PosixFilePermission.OTHERS_WRITE);
		perms.add(PosixFilePermission.OTHERS_EXECUTE);
		Files.setPosixFilePermissions(Paths.get(filePath), perms);
		ViksitLogger.logMSG("Modified as executable " + filePath);
	}

	public void delete(File file) throws IOException {
		if (file.isDirectory()) {
			if (file.list().length == 0) {
				file.delete();
			} else {
				String files[] = file.list();
				for (String temp : files) {
					File fileDelete = new File(file, temp);
					delete(fileDelete);
				}
				if (file.list().length == 0) {
					file.delete();
				}
			}
		} else
			file.delete();
	}

	private ArrayList<String> convertPPTtoImages(Integer lessonId, ArrayList<File> imageFiles, String apachePath) {
		ArrayList<String> images = new ArrayList<>();
		String lessonPath = apachePath + "/lessonXMLs/" + lessonId + "/" + lessonId + "/";
		for (File file : imageFiles) {
			if (file.getName().endsWith(".png")) {
				try {
					File dest = new File(lessonPath + file.getName());
					copyFileUsingStream(file, dest);
					setAsExecutable(dest.getAbsolutePath());
					File dest2 = new File(lessonPath + file.getName().replaceAll(".png", "_desktop.png"));
					copyFileUsingStream(file, dest2);
					setAsExecutable(dest2.getAbsolutePath());
					images.add(file.getName());
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return images;
	}

	public void copyFileUsingStream(File source, File dest) throws IOException {
		InputStream is = null;
		OutputStream os = null;
		try {
			is = new FileInputStream(source);
			os = new FileOutputStream(dest);
			byte[] buffer = new byte[1024];
			int length;
			while ((length = is.read(buffer)) > 0) {
				os.write(buffer, 0, length);
			}
		} finally {
			if (!(is == null)) {
				is.close();
			}
			if (!(os == null)) {
				os.close();
			}
		}
	}

	private void createLessonXML(Integer lessonId, Lesson l, ArrayList<String> images, String apachePath,
			String mediaUrlPath, File innerDirectory) {
		CMSLesson lesson = new CMSLesson();
		lesson.setLessonDescription(l.getDescription());
		lesson.setLessonTitle(l.getTitle());
		lesson.setType("PRESENTATION");
		ArrayList<CMSSlide> slides = new ArrayList<>();
		int slideCounter = 0;
		for (String imageName : images) {
			slideCounter++;
			CMSSlide slide = new CMSSlide();
			slide.setId(((lessonId * 1000) + slideCounter));
			slide.setImage_BG(mediaUrlPath + "/lessonXMLs/" + lessonId + "/" + lessonId + "/" + imageName);
			slide.setOrder_id(slideCounter);
			slide.setTemplateName("NO_CONTENT");
			slides.add(slide);
		}
		lesson.setSlides(slides);
		File file = new File(innerDirectory.getAbsolutePath() + "/" + lessonId + ".xml");
		try {
			if (file.createNewFile()) {
				JAXBContext jaxbContext;
				jaxbContext = JAXBContext.newInstance(CMSLesson.class);
				Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
				jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
				jaxbMarshaller.marshal(lesson, file);
				setAsExecutable(file.getAbsolutePath());
			}
		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void zipLessonXML(Integer lessonId, String apachePath) {
		String SOURCE_FOLDER = apachePath + "/lessonXMLs/" + lessonId;
		File sourceFile = new File(SOURCE_FOLDER);
		String zipName = SOURCE_FOLDER + ".zip";
		ViksitLogger.logMSG(this.getClass().getName(), "creating " + zipName);
		ZipFiles zipFiles = new ZipFiles();
		zipFiles.zipDirectory(sourceFile, zipName);
		/*if (AppProperies.getProperty("server_type").equalsIgnoreCase("linux"))
			try {
				setAsExecutable(zipName);
			} catch (IOException e) {
				e.printStackTrace();
			}*/
	}

}
