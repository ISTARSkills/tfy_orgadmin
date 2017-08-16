package com.viksitpro.cms.services;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFilePermission;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.Result;

import org.apache.commons.lang.StringUtils;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.RuntimeConstants;
import org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.viksitpro.core.cms.oldcontent.CMSEVALUTAOR;
import com.viksitpro.core.cms.oldcontent.CMSImage;
import com.viksitpro.core.cms.oldcontent.CMSLesson;
import com.viksitpro.core.cms.oldcontent.CMSList;
import com.viksitpro.core.cms.oldcontent.CMSParagraph;
import com.viksitpro.core.cms.oldcontent.CMSSlide;
import com.viksitpro.core.cms.oldcontent.CMSTextItem;
import com.viksitpro.core.cms.oldcontent.CMSTitle;
import com.viksitpro.core.cms.oldcontent.CMSTitle2;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.Context;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.upload.controllers.CroppedImageUploadController;
import com.viksitpro.upload.controllers.MediaUploadServices;

public class LessonServices {

	public String lessonHTMLfromLessonXML(int lessonID) {
		StringBuffer stringBuffer = new StringBuffer();

		String path = "";
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			path = properties.getProperty("mediaLessonPath");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		path += "/" + lessonID + "/" + lessonID + "/" + lessonID + ".xml";

		File file = new File(path);
		String url_path = "";
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			url_path = properties.getProperty("media_url_path");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		try {
			JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
			Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
			CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
			if (cmsLesson.getSlides() != null) {
				for (CMSSlide cmsSlide : cmsLesson.getSlides()) {
					String ext = "_desktop.vm";
					String templateVMFileName = "";
					if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_EVALUATOR_EXCEL")) {
						templateVMFileName = "ONLY_TITLE" + ext;
					} else {
						templateVMFileName = cmsSlide.getTemplateName() + ext;
					}

					if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_LIST")) {
						templateVMFileName = cmsSlide.getList().getList_type() + "___" + cmsSlide.getTemplateName() + ext;
					}
					VelocityEngine ve = new VelocityEngine();
					ve.setProperty(RuntimeConstants.RESOURCE_LOADER, "classpath");
					ve.setProperty("classpath.resource.loader.class", ClasspathResourceLoader.class.getName());
					ve.init();
					VelocityContext context = new VelocityContext();
					int cnt = 1;
					String[] transitions = { "fade", "slide", "convex", "concave", "zoom", "cube", "slide-in fade-out" };
					int rand = (new Random()).nextInt(7);

					String bg_image = null;
					String bgImage = "";
					String type = "100% 100%";

					String fragment_count = "fragment_count=" + cmsSlide.getFragmentCount();

					if (cmsSlide.getImage_BG() != null) {

						if (cmsSlide.getImage_BG().contains(".png")) {

							bg_image = cmsSlide.getImage_BG().replaceAll(".png", "_desktop.png");
							bgImage = "data-background-image='" + bg_image + "'";
							type = "100% 100%";

						}

						if (cmsSlide.getImage_BG().contains(".gif")) {
							bg_image = cmsSlide.getImage_BG();

							type = "contain";
							bgImage = "data-background-image='" + bg_image + "'";
						}

					}

					String header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand] + "' data-background-color='" + cmsSlide.getBackground() + "' " + bgImage + " data-background-size='" + type + "'";
					if (cmsSlide.getBackground().equalsIgnoreCase("#000000")) {

						header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand] + "'   " + bgImage + "  data-background-color='#ffffff' data-background-size='" + type + "'";
					}

					if (cmsSlide.getBackground().equalsIgnoreCase("null")) {
						header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand] + "'   " + bgImage + "  data-background-color='#ffffff' data-background-size='" + type + "'";
					}

					if (cmsSlide.getBackground().equalsIgnoreCase("none")) {
						header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand] + "'   " + bgImage + " data-background-color='#ffffff' data-background-size='" + type + "'";
					}

					if (templateVMFileName.contains("PARAGRAPH")) {
						if (cmsSlide.getParagraph().getText().contains("<table")) {
							templateVMFileName = "ONLY_TITLE_PARAGRAPH_cells__desktop2.vm";

						}
					}

					context.put("fragment_count", fragment_count);
					context.put("header", header);
					context.put("slide", cmsSlide);
					Template t = ve.getTemplate(templateVMFileName);
					StringWriter writer = new StringWriter();
					t.merge(context, writer);
					String data1 = writer.toString();
					// data1 = data1.replaceAll("[^\\x00-\\x7F]","");
					data1 = data1.replaceAll("<p></p>", "");
					data1 = data1.replaceAll("/content/media_upload\\?getfile=", "/video/");
					data1 = data1.replaceAll("/video/backgrounds/", "/video/");

					if (!data1.contains("<table")) {

						data1 = data1.replaceAll("<p>", "<p class='fragment fade-up'>");

					}

					data1 = data1.replaceAll("<b>", "");

					data1 = data1.replaceAll("width:500px", "");

					if (templateVMFileName.contains("ONLY_TITLE_PARAGRAPH_cells_fragemented")) {
						// data1 = data1.replaceAll("<span
						// style=\"font-size:22px\">", "<span class='fragment
						// fade-up ' style=\"font-size:22px\">");

						data1 = data1.replaceAll("<td", "<td class='fragment fade-up visible' style=' border: 1px solid;'");
						data1 = data1.replaceAll("<th scope=\"row\"", "<th scope='row' style='border: 1px solid;background: lightgray;'");
						data1 = data1.replaceAll("<th scope=\"col\"", "<th scope='row' style='border: 1px solid;background: lightgray;'");
					}

					if (templateVMFileName.contains("ONLY_PARAGRAPH_TITLE")) {

						data1 = data1.replaceAll("<li>", "<li class='fragment fade-up' >");
						data1 = data1.replaceAll("<h1>", "<h1 class='fragment fade-up' >");
					}

					if (templateVMFileName.contains("ONLY_TITLE_PARAGRAPH")) {

						data1 = data1.replaceAll("<li>", "<li class='fragment fade-up' >");

					}
					if (templateVMFileName.contains("ONLY_PARAGRAPH_IMAGE")) {

						data1 = data1.replaceAll("<li>", "<li class='fragment fade-up' >");
					}

					if (templateVMFileName.contains("ONLY_2BOX")) {

						data1 = data1.replaceAll("<p class='fragment fade-up'>", "<p>");
					}

					stringBuffer.append(data1);
					Document doc = Jsoup.parse(stringBuffer.toString());
					int length = doc.text().length();

					if (cmsSlide.getId() == 981868) {
						// System.err.println("doc.text().length()------->"+doc.text().length());
					}
					if (length < 500) {
						length = 120;
					} else {
						length = 100;
					}
					stringBuffer.append("<div class='hidden_element' id='slide_" + cmsSlide.getId() + "' data-template='" + cmsSlide.getTemplateName().toLowerCase() + "' data-slide_id='" + cmsSlide.getId() + "' data-length='" + length + "' ></div>");

				}
			}
		} catch (JAXBException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return stringBuffer.toString();
	}

	public Lesson saveLessonDetails(Lesson lesson, LessonDAO lessonDAO) {
		Session session = null;
		Transaction tx = null;
		try {
			session = lessonDAO.getSession();
			tx = session.beginTransaction();
			lessonDAO.attachDirty(lesson);
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
			tx.rollback();
		} finally {
			// session.flush();
			session.clear();
			session.close();
		}
		return lesson;
	}

	public HashSet<SkillObjective> getLOsfromLesson(Lesson lesson) {
		HashSet<SkillObjective> lessonLOs = new HashSet<>();
		String sql = "select learning_objectiveid from lesson_skill_objective where lessonid = " + lesson.getId();
		List<HashMap<String, Object>> selected_learning_objectives = (new DBUTILS()).executeQuery(sql);
		for (HashMap<String, Object> selected_learning_objective : selected_learning_objectives) {
			lessonLOs.add((new SkillObjectiveDAO()).findById(Integer.parseInt(selected_learning_objective.get("learning_objectiveid").toString())));
		}
		return lessonLOs;
	}

	public Lesson getLessonforAssessment(Assessment assessment) {
		Lesson lesson = new Lesson();
		String sql = "select * from lesson where lesson_xml = '" + assessment.getId() + "'";
		List<HashMap<String, Object>> lessons = (new DBUTILS()).executeQuery(sql);
		for (HashMap<String, Object> l : lessons) {
			lesson = (new LessonDAO()).findById(Integer.parseInt(l.get("id").toString()));
		}
		return lesson;
	}

	public Assessment getAssessmentforLesson(Lesson lesson) {
		Assessment assessment = new Assessment();
		try {
			assessment = (new AssessmentDAO()).findById(Integer.parseInt(lesson.getLessonXml()));
		} catch (Exception e) {
			// TODO: handle exception
		}
		return assessment;
	}

	/*
	 * String sql =
	 * "select learning_objectiveid from lesson_skill_objective where lessonid = "
	 * +lesson.getId(); List<HashMap<String, Object>>
	 * selected_learning_objectives = dbutils.executeQuery(sql); sql =
	 * "select distinct(parent_skill) from skill_objective where id in (select learning_objectiveid from lesson_skill_objective where lessonid = "
	 * +lesson.getId()+")"; List<HashMap<String, Object>>
	 * selected_session_skills = dbutils.executeQuery(sql); sql =
	 * "select distinct(parent_skill) from skill_objective where id in (select parent_skill from skill_objective where id in (select learning_objectiveid from lesson_skill_objective where lessonid = "
	 * +lesson.getId()+"))"; List<HashMap<String, Object>>
	 * selected_module_skills = dbutils.executeQuery(sql); sql =
	 * "select * from skill_objective where skill_level_type = 'MODULE' and context = "
	 * +context_id+" order by order_id"; List<HashMap<String, Object>>
	 * module_skills = dbutils.executeQuery(sql);
	 */

	public Boolean checkLessonXMLFolderSanity(Lesson lesson) throws IOException {
		Boolean success = false;
		if (checkLessonFolderExists(lesson)) {
			System.err.println("Folder exists");
			if (checkLessonXMLExists(lesson)) {
				System.err.println("XML exists");
				if (checkAssetsExist(lesson)) {
					System.err.println("Assets exists");
					success = true;
				}
			}
		}
		return success;
	}

	public boolean checkAssetsExist(Lesson lesson) throws IOException {
		Boolean success = false;
		Boolean boo = true;
		if (checkLessonFolderExists(lesson) && checkLessonXMLExists(lesson)) {
			String lessonXMLFolderPath = "";
			String lessonXMLPath = "";
			lessonXMLFolderPath = getAnyPath("mediaLessonPath");
			lessonXMLPath = lessonXMLFolderPath + lesson.getId() + "/" + lesson.getId() + "/" + lesson.getId() + ".xml";
			BufferedReader br = null;
			FileReader fr = null;
			fr = new FileReader(lessonXMLPath);
			br = new BufferedReader(fr);
			String line;
			StringBuilder sb = new StringBuilder();
			while ((line = br.readLine()) != null) {
				sb.append(line.trim());
			}
			if (br != null)
				br.close();
			if (fr != null)
				fr.close();
			String linkhref = lesson.getId() + "/" + lesson.getId();
			String lessonXML = sb.toString();
			// System.err.println(lessonXML);
			// String lessonAssetPath = getAnyPath("mediaLessonPath") +
			// lesson.getId() + "/" + lesson.getId() + "/";
			int beginIndex = lessonXML.indexOf(linkhref);
			while (beginIndex > 0 && boo) {
				int endIndex = lessonXML.substring(beginIndex).indexOf("\"");
				String url = lessonXML.substring(beginIndex, endIndex + beginIndex);
				// System.err.println(url);
				// System.err.println(lessonXMLFolderPath + url);
				File asset = new File(lessonXMLFolderPath + url);
				if (asset.exists() && !asset.isDirectory()) {
					boo = true;
					// System.err.println(boo+url);
				} else {
					boo = false;
				}
				beginIndex = lessonXML.indexOf(linkhref, beginIndex + 1);
			}
		} else {
			System.err.println("The lesson Folder or the xml doesn't exist.");
		}
		if (boo) {
			success = true;
		}
		return success;
	}

	public boolean checkLessonXMLExists(Lesson lesson) {
		Boolean success = false;
		String lessonXMLFolderPath = "";
		String lessonXMLPath = "";
		try {
			lessonXMLFolderPath = getAnyPath("mediaLessonPath");
		} catch (IOException e) {
			e.printStackTrace();
		}
		lessonXMLPath = lessonXMLFolderPath + lesson.getId() + "/" + lesson.getId() + "/" + lesson.getId() + ".xml";
		File f = new File(lessonXMLPath);
		if (f.exists() && !f.isDirectory()) {
			success = true;
		}
		return success;
	}

	public boolean checkLessonFolderExists(Lesson lesson) {
		String lessonXMLPath = "";
		Boolean success = false;
		try {
			lessonXMLPath = getAnyPath("mediaLessonPath");
		} catch (IOException e) {
			// e.printStackTrace();
		}
		// System.err.println(lessonXMLPath);
		// System.err.println(lesson.getId());
		Path path = Paths.get(lessonXMLPath + lesson.getId() + "/" + lesson.getId());

		if (Files.exists(path)) {
			success = true;
		}
		return success;
	}

	public Boolean createLessonZIP(Lesson lesson) throws IOException {
		Boolean success = false;
		if (checkLessonXMLFolderSanity(lesson)) {
			String lessonXMLPath = "";
			lessonXMLPath = getAnyPath("mediaLessonPath");
			lessonXMLPath += lesson.getId();
			String OUTPUT_ZIP_FILE = lessonXMLPath + ".zip";
			String SOURCE_FOLDER = lessonXMLPath;
			List<String> fileList = new ArrayList<String>();
			File node = new File(SOURCE_FOLDER);
			generateFileList(node, fileList, SOURCE_FOLDER);
			zipIt(OUTPUT_ZIP_FILE, SOURCE_FOLDER, fileList);
			File zipFile = new File(OUTPUT_ZIP_FILE);
			if (zipFile.exists() && !zipFile.isDirectory()) {
				success = true;
			} else {
				success = false;
			}
		}
		return success;
	}

	public void generateFileList(File node, List<String> fileList, String SOURCE_FOLDER) {

		// add file only
		if (node.isFile()) {
			fileList.add(generateZipEntry(node.getAbsoluteFile().toString(), SOURCE_FOLDER));
		}

		if (node.isDirectory()) {
			String[] subNote = node.list();
			for (String filename : subNote) {
				generateFileList(new File(node, filename), fileList, SOURCE_FOLDER);
			}
		}

	}

	private String generateZipEntry(String file, String SOURCE_FOLDER) {
		return file.substring(SOURCE_FOLDER.length() + 1, file.length());
	}

	public void zipIt(String zipFile, String SOURCE_FOLDER, List<String> fileList) {

		byte[] buffer = new byte[1024];

		try {

			FileOutputStream fos = new FileOutputStream(zipFile);
			ZipOutputStream zos = new ZipOutputStream(fos);

			System.out.println("Output to Zip : " + zipFile);

			for (String file : fileList) {

				System.out.println("File Added : " + file);
				ZipEntry ze = new ZipEntry(file);
				zos.putNextEntry(ze);

				FileInputStream in = new FileInputStream(SOURCE_FOLDER + File.separator + file);

				int len;
				while ((len = in.read(buffer)) > 0) {
					zos.write(buffer, 0, len);
				}

				in.close();
			}

			zos.closeEntry();
			// remember close it
			zos.close();

			System.out.println("Done");
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

	public Boolean createLessonFolder(Lesson lesson) throws IOException {
		String lessonXMLPath = "";
		Boolean success = false;
		MediaUploadServices services = new MediaUploadServices();
		Set<PosixFilePermission> perms = services.getPermissions();
		try {
			lessonXMLPath = getAnyPath("mediaLessonPath");
		} catch (IOException e) {
			// e.printStackTrace();
		}
		Path path = Paths.get(lessonXMLPath + lesson.getId() + "/" + lesson.getId());
		if (Files.exists(path)) {
			success = true;
		} else {
			Files.createDirectories(path);
			if (getAnyPath("server_type").equalsIgnoreCase("linux")) {
				Files.setPosixFilePermissions(path, perms);
				Files.setPosixFilePermissions(Paths.get(lessonXMLPath + lesson.getId()), perms);
			}
			success = true;
		}
		return success;
	}

	public Boolean saveLessonAssets(Lesson lesson, String lessonXML) throws IOException {
		Boolean success = false;
		String linkhref = "course_images";
		String sourcePath = "";
		String destPath = "";
		sourcePath = getAnyPath("imagePath");
		destPath = getAnyPath("mediaLessonPath") + "" + lesson.getId() + "/" + lesson.getId() + "/";
		int beginIndex = lessonXML.indexOf(linkhref);
		while (beginIndex > 0) {
			int endIndex = lessonXML.substring(beginIndex).indexOf("<");
			String url = lessonXML.substring(beginIndex, endIndex + beginIndex);
			// System.err.println(url);
			// System.err.println(sourcePath + url.substring(url.indexOf("/") +
			// 1));
			// System.err.println(destPath + url.substring(url.indexOf("/") +
			// 1));
			File source = new File(sourcePath + url.substring(url.indexOf("/") + 1));
			File dest = new File(destPath + url.substring(url.indexOf("/") + 1));
			copyFileUsingStream(source, dest);
			success = success && dest.createNewFile();
			beginIndex = lessonXML.indexOf(linkhref, beginIndex + 1);
		}
		return !success;
	}

	public Boolean saveLessonXML(String lessonXML, Lesson lesson) throws IOException {
		Boolean folderexists = createLessonFolder(lesson); // change with
															// checkLessonFolderExists
															// during edit mode
		Boolean success = false;
		String lessonXMLFolderPath = "";
		String lessonXMLPath = "";
		if (folderexists && !lessonXML.trim().equalsIgnoreCase("")) {
			try {
				lessonXMLFolderPath = getAnyPath("mediaLessonPath");
			} catch (IOException e) {
				e.printStackTrace();
			}
			lessonXMLPath = lessonXMLFolderPath + lesson.getId() + "/" + lesson.getId() + "/" + lesson.getId() + ".xml";
			Writer out = null;
			try {
				out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(lessonXMLPath), "UTF-8"));
			} catch (UnsupportedEncodingException | FileNotFoundException e) {
				e.printStackTrace();
			}
			try {
				out.write(lessonXML.replaceAll("[^\\x00-\\x7F]", "").replaceAll("course_images", "lessonXMLs/" + lesson.getId() + "/" + lesson.getId()));
				success = true;
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				out.close();
			}
		} else {
			System.err.println("Lesson folder could not be created or lesson XML is empty!");
		}
		return success;
	}

	public Boolean updateLessonXML(String lessonXML, Lesson lesson) throws IOException {
		return saveLessonXML(lessonXML, lesson);
	}

	public String readLessonXML(Lesson lesson) throws IOException {
		String lessonXML = "";
		String lessonXMLFolderPath = "";
		String lessonXMLPath = "";
		try {
			lessonXMLFolderPath = getAnyPath("mediaLessonPath");
		} catch (IOException e) {
			e.printStackTrace();
		}
		lessonXMLPath = lessonXMLFolderPath + lesson.getId() + "/" + lesson.getId() + "/" + lesson.getId() + ".xml";
		File f = new File(lessonXMLPath);
		if (f.exists() && !f.isDirectory()) {
			BufferedReader br = null;
			FileReader fr = null;
			fr = new FileReader(lessonXMLPath);
			br = new BufferedReader(fr);
			String line;
			StringBuilder sb = new StringBuilder();
			while ((line = br.readLine()) != null) {
				sb.append(line.trim());
			}
			if (br != null)
				br.close();
			if (fr != null)
				fr.close();
			lessonXML = sb.toString();
		}
		return lessonXML;
	}

	public String getAnyPath(String nick) throws IOException {
		Properties properties = new Properties();
		properties.load(LessonServices.class.getClassLoader().getResourceAsStream("app.properties"));
		String lessonXMLPath = properties.getProperty(nick);
		return lessonXMLPath;
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

	public Lesson firstSaveMoveLessonImage(Lesson lesson) throws IOException {
		MediaUploadServices services = new MediaUploadServices();
		Set<PosixFilePermission> perms = services.getPermissions();
		String linkhref = "course_images";
		if (lesson.getImage_url().contains(linkhref)) {
			String lessonImageUrl = lesson.getImage_url();
			int beginIndex = lessonImageUrl.indexOf(linkhref);
			String url = lessonImageUrl.substring(beginIndex + 14);
			String rep = "lessonXMLs/" + lesson.getId() + "/" + lesson.getId();
			String lessonImageUrl1 = lessonImageUrl.replaceAll("course_images", rep);
			// System.err.println(lessonImageUrl1+">>>>>>>>>");
			lesson.setImage_url(lessonImageUrl1);
			String sourcePath = getAnyPath("imagePath");
			String destPath = getAnyPath("mediaLessonPath") + "" + lesson.getId() + "/" + lesson.getId() + "/";
			File source = new File(sourcePath + url);
			File dest = new File(destPath + url);
			copyFileUsingStream(source, dest);
			// Files.setPosixFilePermissions(dest.toPath(), perms);
		}
		return lesson;
	}

	public String addslideHTMLtoLessonXML(String template_type, int slide_id, int lesson_id) throws JAXBException {
		StringBuffer stringBuffer = new StringBuffer();

		// System.err.println(">>>>>>>>>><<<<<<<<<<<<" + template_type + ">>> "
		// +
		// slide_id + " >>>>>> " + lesson_id);

		String ext = "_desktop.vm";
		String templateVMFileName = "";
		if (template_type.equalsIgnoreCase("ONLY_EVALUATOR_EXCEL")) {
			templateVMFileName = "ONLY_TITLE" + ext;
		} else {
			templateVMFileName = template_type + ext;
		}
		if (template_type.equalsIgnoreCase("ONLY_TITLE_LIST")) {
			templateVMFileName = "SIMPLE_LIST___ONLY_TITLE_LIST" + ext;
		}
		VelocityEngine ve = new VelocityEngine();
		ve.setProperty(RuntimeConstants.RESOURCE_LOADER, "classpath");
		ve.setProperty("classpath.resource.loader.class", ClasspathResourceLoader.class.getName());
		ve.init();
		VelocityContext context = new VelocityContext();
		int cnt = 1;
		String[] transitions = { "fade", "slide", "convex", "concave", "zoom", "cube", "slide-in fade-out" };
		int rand = (new Random()).nextInt(7);
		CMSSlide cmsSlide = new CMSSlide();
		CMSTitle cmsTitle = new CMSTitle();
		CMSTitle2 cmsTitle2 = new CMSTitle2();
		CMSParagraph cmsParagraph = new CMSParagraph();
		CMSImage cmsImage = new CMSImage();

		CMSList cmsList = new CMSList();
		ArrayList<CMSTextItem> items = new ArrayList<>();
		if (template_type.equalsIgnoreCase("ONLY_TITLE_TREE")) {
			for (int i = 1; i <= 3; i++) {
				CMSTextItem cmsTextItem = new CMSTextItem();
				cmsTextItem.setText("Click to edit list " + i + "...");

				CMSList cmsSubList = new CMSList();
				ArrayList<CMSTextItem> subitems = new ArrayList<>();
				for (int j = 1; j <= 2; j++) {
					CMSTextItem cmsSubTextItem = new CMSTextItem();
					cmsSubTextItem.setText("Click to edit sub list " + j + "...");
					subitems.add(cmsSubTextItem);
				}
				cmsSubList.setItems(subitems);
				cmsTextItem.setList(cmsSubList);
				items.add(cmsTextItem);

			}
		} else {

			for (int i = 1; i < 6; i++) {
				CMSTextItem cmsTextItem = new CMSTextItem();
				cmsTextItem.setText("Click to edit list " + i + "...");
				// System.err.println(template_type);
				items.add(cmsTextItem);
			}
		}
		cmsList.setItems(items);

		String url = "../../img/no_content.png";
		String bgImage = "";
		String bgColor = "#ffffff";
		cmsTitle.setText("Click to edit title...");
		cmsTitle2.setText("Click to edit title2...");
		cmsParagraph.setText("Click to edit paragraph...");
		cmsImage.setUrl(url);

		if (template_type.equalsIgnoreCase("NO_CONTENT")) {
			bgImage = "data-background-image='" + "../../img/no_content.png" + "'";
		}

		cmsSlide.setTitle(cmsTitle);
		cmsSlide.setTitle2(cmsTitle2);
		cmsSlide.setParagraph(cmsParagraph);
		if (cmsImage.getUrl().equalsIgnoreCase("") && cmsImage.getUrl().equalsIgnoreCase("none")) {
			url = cmsImage.getUrl().replaceAll("none", "../../img/no_content.png");
			cmsImage.setUrl(url);
		}
		cmsSlide.setImage(cmsImage);
		cmsSlide.setList(cmsList);

		String path = "";
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			path = properties.getProperty("mediaLessonPath");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		path += "" + lesson_id + "/" + lesson_id + "/" + lesson_id + ".xml";

		File file = new File(path);

		JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
		Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
		CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
		if (cmsLesson.getSlides() != null) {
			for (CMSSlide cmsSlide1 : cmsLesson.getSlides()) {

				if (slide_id != 0 && cmsSlide1.getId() == slide_id) {
					if (cmsSlide1.getTitle() != null && !cmsSlide1.getTitle().getText().equalsIgnoreCase("") && !cmsSlide1.getTitle().getText().equalsIgnoreCase("EMPTY_TITLE")) {
						cmsSlide.setTitle(cmsSlide1.getTitle());
					}
					if (cmsSlide1.getTitle2() != null && !cmsSlide1.getTitle2().getText().equalsIgnoreCase("") && !cmsSlide1.getTitle2().getText().equalsIgnoreCase("EMPTY_TITLE")) {
						cmsSlide.setTitle2(cmsSlide1.getTitle2());
					}

					cmsSlide.setParagraph(cmsSlide1.getParagraph());
					cmsSlide.setImage(cmsSlide1.getImage());
					cmsSlide.setTeacherNotes(cmsSlide1.getTeacherNotes());
					CMSList list = new CMSList();
					items = new ArrayList<>();

					if (template_type.equalsIgnoreCase("ONLY_TITLE_TREE")) {
						int count = 1;
						for (int i = 0; i <= 2; i++) {
							CMSTextItem cmsTextItem = new CMSTextItem();

							int totalSize = cmsSlide1.getList().getItems().size();
							System.err.println("totalSize>>>" + totalSize);
							if (i < totalSize && !cmsSlide1.getList().getItems().get(i).getText().trim().equalsIgnoreCase("")) {
								cmsTextItem.setText(cmsSlide1.getList().getItems().get(i).getText());
							} else {
								cmsTextItem.setText("Click to edit list " + count + "...");
							}
							CMSList cmsSubList = new CMSList();
							ArrayList<CMSTextItem> subitems = new ArrayList<>();
							int subCount = 1;
							for (int j = 0; j <= 1; j++) {
								CMSTextItem cmsSubTextItem = new CMSTextItem();
								int totalSubSize = cmsSlide1.getList().getItems().get(i).getList().getItems().size();

								System.err.println("totalSubSize>>>" + totalSubSize);
								if (i < totalSize && j < totalSubSize && !cmsSlide1.getList().getItems().get(i).getList().getItems().get(j).getText().trim().equalsIgnoreCase("")) {
									System.err.println(cmsSlide1.getList().getItems().get(i).getList().getItems().get(j).getText());
									cmsSubTextItem.setText(cmsSlide1.getList().getItems().get(i).getList().getItems().get(j).getText());
								} else {
									cmsSubTextItem.setText("Click to edit sub list " + subCount + "...");
								}

								subitems.add(cmsSubTextItem);
								subCount++;
							}

							cmsSubList.setItems(subitems);
							cmsTextItem.setList(cmsSubList);
							items.add(cmsTextItem);
							list.setItems(items);
							cmsSlide.setList(list);
							count++;
						}

					} else {

						if (cmsSlide1.getList() != null && cmsSlide1.getList().getItems() != null) {

							int totalSize = cmsSlide1.getList().getItems().size();
							int count = 1;
							for (int i = 0; i <= 4; i++) {
								CMSTextItem cmsTextItem = new CMSTextItem();
								if (i < totalSize && cmsSlide1.getList().getItems() != null && !cmsSlide1.getList().getItems().get(i).getText().trim().equalsIgnoreCase("")) {
									cmsTextItem.setText(cmsSlide1.getList().getItems().get(i).getText());
								} else {
									cmsTextItem.setText("Click to edit list " + count + "...");
								}

								items.add(cmsTextItem);
								count++;
							}

							list.setItems(items);
							cmsSlide.setList(list);

						}
					}

					if (template_type.equalsIgnoreCase("ONLY_VIDEO")) {
						if (cmsSlide1.getVideo() != null && cmsSlide1.getVideo().getUrl() != null && !cmsSlide1.getVideo().getUrl().equalsIgnoreCase("null")) {
							cmsSlide.setVideo(cmsSlide1.getVideo());
						}
					}

					if (template_type.equalsIgnoreCase("ONLY_EVALUATOR_ASSESSMENT")) {
						if (cmsSlide1.getEvaluators() != null) {
							List<CMSEVALUTAOR> evaluators = new ArrayList<>();
							evaluators.addAll(cmsSlide1.getEvaluators());
							cmsSlide.setEvaluators(evaluators);
						}
					}

					if (cmsSlide1.getImage_BG() != null && !cmsSlide1.getImage_BG().equalsIgnoreCase("null")) {
						String tempimg = cmsSlide1.getImage_BG().replaceAll(".png", "_desktop.png").replaceAll("none", "").replaceAll(".gif", "_desktop.gif");
						if (template_type.equalsIgnoreCase("NO_CONTENT") && cmsSlide1.getImage_BG().equalsIgnoreCase("none") || cmsSlide1.getImage_BG().equalsIgnoreCase("")) {
							tempimg = cmsSlide1.getImage_BG().replaceAll(".png", "_desktop.png").replaceAll("none", "../../img/no_content.png");
						} else {
							tempimg = cmsSlide1.getImage_BG().replaceAll(".png", "_desktop.png").replaceAll("none", "").replaceAll(".gif", "_desktop.gif");
						}
						bgImage = "data-background-image='" + tempimg + "'";
					}

					if (cmsSlide1.getBackground() != null && !cmsSlide1.getBackground().equalsIgnoreCase("") && !cmsSlide1.getBackground().equalsIgnoreCase("null")) {
						bgColor = cmsSlide1.getBackground();
					}

				}

			}
		}
		String type = "100% 100%";
		String header = "data-background-transition='" + transitions[rand] + "' data-background-color='" + bgColor + "' data-background-size='" + type + "' " + bgImage + "";

		context.put("header", header);
		context.put("slide", cmsSlide);
		Template t = ve.getTemplate(templateVMFileName);
		StringWriter writer = new StringWriter();
		t.merge(context, writer);
		String data = writer.toString();
		stringBuffer.append(data);

		return stringBuffer.toString();
	}

	public StringBuffer chooseBgColorForLesson() {
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append(" <option value='#A0522D' data-color='#A0522D'>sienna</option> " + "    <option value='#CD5C5C' data-color='#CD5C5C'>indianred</option>  " + "   <option value='#FF4500' data-color='#FF4500'>orangered</option>  " + "   <option value='#DC143C' data-color='#DC143C'>crimson</option>  " + "   <option value='#FF8C00' data-color='#FF8C00'>darkorange</option>  "
				+ "   <option value='#C71585' data-color='#C71585'>mediumvioletred</option>   " + "   <option value='#000000' data-color='#000000'>Black</option>   " + "   <option value='#FFFFFF' data-color='#FFFFFF'>White</option>    " + "  <option value='#FFFF00' data-color='#FFFF00'>Yellow</option>  " + "    <option value='#0000FF' data-color='#0000FF'>Blue</option>   "
				+ "   <option value='#A52A2A' data-color='#A52A2A'>Brown</option>   " + "    <option value='#00008B' data-color='#00008B'>DarkBlue</option>   " + "   <option value='#A9A9A9' data-color='#A9A9A9'>DarkGray</option>   " + "    <option value='#006400' data-color='#006400'>DarkGreen</option>  " + "    <option value='#8B0000' data-color='#8B0000'>DarkRed</option>   "
				+ "    <option value='#228B22' data-color='#228B22'>ForestGreen</option>   " + "   <option value='#FFFAF0' data-color='#FFFAF0'>FloralWhite</option>   " + "    <option value='#808080' data-color='#808080'>Grey</option>   " + "   <option value='#D3D3D3' data-color='#D3D3D3'>LightGray</option>   " + "    <option value='#191970' data-color='#191970'>MidnightBlue</option>  "
				+ "    <option value='#000080' data-color='#000080'>Navy</option>   " + "   <option value='#FFA500' data-color='#FFA500'>Orange</option>   " + "   <option value='#800080' data-color='#800080'>Purple</option>   " + "    <option value='#C71585' data-color='#C71585'>RoyalBlue</option>   " + "   <option value='#87CEEB' data-color='#87CEEB'>SkyBlue</option>");

		return stringBuffer;

	}

	public StringBuffer chooseTemplatForLesson(int lessonID) {
		StringBuffer stringBuffer = new StringBuffer();
		int slide_id = Math.abs((int) System.nanoTime());
		stringBuffer.append("<ul class='dropdown-menu'>       " + "<li><a href='../template/create_slide.jsp?template_type=NO_CONTENT&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>NO CONTENT TEMPLATE</a></li>        " + " <li ><a href='../template/create_slide.jsp?template_type=ONLY_TITLE&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY TITLE TEMPLATE</a></li>       "
				+ "  <li ><a href='../template/create_slide.jsp?template_type=ONLY_2BOX&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY 2BOX TEMPLATE</a></li>        " + " <li ><a href='../template/create_slide.jsp?template_type=ONLY_2TITLE&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY 2TITLE TEMPLATE</a></li>       "
				+ "  <li><a  href='../template/create_slide.jsp?template_type=ONLY_2TITLE_IMAGE&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY 2TITLE IMAGE TEMPLATE</a></li>              " + "   <li><a href='../template/create_slide.jsp?template_type=ONLY_IMAGE&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY IMAGE TEMPLATE</a></li>         "
				+ "<li ><a href='../template/create_slide.jsp?template_type=ONLY_LIST&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY LIST TEMPLATE</a></li>        " + " <li ><a href='../template/create_slide.jsp?template_type=ONLY_LIST_NUMBERED&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY LIST NUMBERED TEMPLATE</a></li>         " + ""
				+ "<li ><a href='../template/create_slide.jsp?template_type=ONLY_PARAGRAPH_IMAGE_LIST&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY PARAGRAPH IMAGE LIST TEMPLATE</a></li>                 " + "<li ><a href='../template/create_slide.jsp?template_type=ONLY_PARAGRAPH_TITLE_LIST&lesson_id=" + lessonID + "&slide_id=" + slide_id
				+ "'>ONLY PARAGRAPH TITLE LIST TEMPLATE</a></li>                         " + "<li><a href='../template/create_slide.jsp?template_type=ONLY_TITLE_IMAGE&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY TITLE IMAGE TEMPLATE</a></li>                " + "<li><a href='../template/create_slide.jsp?template_type=ONLY_TITLE_LIST&lesson_id=" + lessonID + "&slide_id=" + slide_id
				+ "'>ONLY TITLE LIST TEMPLATE</a></li>                       " + "<li><a  href='../template/create_slide.jsp?template_type=ONLY_TITLE_LIST_NUMBERED&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY TITLE LIST NUMBERED TEMPLATE</a></li>         " + "<li ><a  href='../template/create_slide.jsp?template_type=ONLY_TITLE_PARAGRAPH_cells_fragemented&lesson_id=" + lessonID
				+ "&slide_id=" + slide_id + "'>ONLY  TITLE PARAGRAPH cells fragmented TEMPLATE</a></li>         " + " " + " <li ><a  href='../template/create_slide.jsp?template_type=ONLY_TITLE_PARAGRAPH_IMAGE&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY TITLE PARAGRAPH IMAGE TEMPLATE</a></li>         "
				+ "<li ><a  href='../template/create_slide.jsp?template_type=ONLY_TITLE_TREE&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY TITLE TREE TEMPLATE</a></li>         " + "<li ><a  href='../template/create_slide.jsp?template_type=ONLY_VIDEO&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ONLY VIDEO TEMPLATE</a></li>   </ul> ");

		return stringBuffer;

	}

	public List<HashMap<String, Object>> getQuestion(int question_id) {
		DBUTILS util = new DBUTILS();
		String sql = "SELECT id,question_text FROM question WHERE id = " + question_id;
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAllOptionsForQuestion(int question_id) {
		DBUTILS util = new DBUTILS();
		String sql = "SELECT id,text,marking_scheme FROM assessment_option WHERE assessment_option.question_id = " + question_id + " ORDER BY id ASC";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;
	}

	public StringBuffer addslideTypeHTMLtoLessonXML(String slide_type, int slide_id, int lesson_id) throws JAXBException {

		String path = "";
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			path = properties.getProperty("mediaLessonPath");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		path += "" + lesson_id + "/" + lesson_id + "/" + lesson_id + ".xml";

		File file = new File(path);

		JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
		Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
		CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
		StringBuffer stringBuffer = new StringBuffer();
		if (slide_type.equalsIgnoreCase("type1")) {
			if (cmsLesson.getSlides() != null) {

				stringBuffer.append("<div class='bs-example' data-example-id='table-within-panel'> <div class='panel panel-default'><form id='form_data' action='/content/slide_evaluator' method='post'><table class='table'> <thead>"
						+ " <tr> <th style='text-align: center;'>Cell ID</th> <th style='text-align: center;'>Value</th> <th style='text-align: center;'>Formula</th> <th style='text-align: center;'>Result</th></tr>" + " </thead> " + "<tbody> ");

				int count = 1;
				String str = "";
				for (CMSSlide cmsSlide : cmsLesson.getSlides()) {

					if (cmsSlide.getId() == slide_id) {

						for (CMSEVALUTAOR eve : cmsSlide.getEvaluators()) {

							stringBuffer.append("<tr> " + "<td><input name='key_" + count + "' class='form-control' aria-label='Text input with dropdown button' value='" + eve.getKey() + "'></td>" + " <td> <select name='value_" + count
									+ "' class='form-control'>   <option value='CELL_TYPE_BLANK'>CELL_TYPE_BLANK</option>   <option value='CELL_TYPE_BOOLEAN'>CELL_TYPE_BOOLEAN</option>   <option value='CELL_TYPE_ERROR'>CELL_TYPE_ERROR</option>   <option value='CELL_TYPE_FORMULA'>CELL_TYPE_FORMULA</option>    <option value='CELL_TYPE_NUMERIC'>CELL_TYPE_NUMERIC</option>     <option value='CELL_TYPE_STRING'>CELL_TYPE_STRING</option> </select></td> "
									+ "<td><input name='formula_" + count + "' class='form-control' aria-label='Text input with dropdown button'></td> <td><input name='result_" + count + "' class='form-control' aria-label='Text input with dropdown button' value='" + eve.getValue() + "'></td><td><button id='remove_" + count
									+ "' type='button'class='btn btn-default btn-sm remove-row'><span class='glyphicon glyphicon-minus' aria-hidden='true'></span></button></td>" + "</tr> ");

							count++;

						}

						str = "<td><button id='remove_" + count + "' type='button'class='btn btn-default btn-sm remove-row'><span class='glyphicon glyphicon-minus' aria-hidden='true'></span></button></td>";

					}

				}

				stringBuffer.append("<tr> " + "<td><input name='key_" + count + "' class='form-control' aria-label='Text input with dropdown button'></td>" + " <td> <select name='value_" + count
						+ "' class='form-control'>   <option value='CELL_TYPE_BLANK'>CELL_TYPE_BLANK</option>   <option value='CELL_TYPE_BOOLEAN'>CELL_TYPE_BOOLEAN</option>   <option value='CELL_TYPE_ERROR'>CELL_TYPE_ERROR</option>   <option value='CELL_TYPE_FORMULA'>CELL_TYPE_FORMULA</option>    <option value='CELL_TYPE_NUMERIC'>CELL_TYPE_NUMERIC</option>     <option value='CELL_TYPE_STRING'>CELL_TYPE_STRING</option> </select></td> "
						+ "<td><input name='formula_" + count + "' class='form-control' aria-label='Text input with dropdown button'></td> <td><input name='result_" + count + "' class='form-control' aria-label='Text input with dropdown button'></td>" + str + "" + "</tr> ");

				stringBuffer.append(" </tbody> </table></form></div></div>");

			} else {

				stringBuffer.append("<div class='bs-example' data-example-id='table-within-panel'> <div class='panel panel-default'><form id='form_data' action='/content/slide_evaluator' method='post'><table class='table'> <thead>"
						+ " <tr> <th style='text-align: center;'>ID</th> <th style='text-align: center;'>Cell ID</th> <th style='text-align: center;'>Value</th> <th style='text-align: center;'>Formula</th> <th style='text-align: center;'>Result</th></tr>" + " </thead> " + "<tbody> " + "<tr> <th scope='row'>1</th> "
						+ "<td><input name='key_1' class='form-control' aria-label='Text input with dropdown button'></td>"
						+ " <td> <select name='value_1' class='form-control'>   <option value='CELL_TYPE_BLANK'>CELL_TYPE_BLANK</option>   <option value='CELL_TYPE_BOOLEAN'>CELL_TYPE_BOOLEAN</option>   <option value='CELL_TYPE_ERROR'>CELL_TYPE_ERROR</option>   <option value='CELL_TYPE_FORMULA'>CELL_TYPE_FORMULA</option>    <option value='CELL_TYPE_NUMERIC'>CELL_TYPE_NUMERIC</option>     <option value='CELL_TYPE_STRING'>CELL_TYPE_STRING</option> </select></td> "
						+ "<td><input name='formula_1' class='form-control' aria-label='Text input with dropdown button'></td> <td><input name='result_1' class='form-control' aria-label='Text input with dropdown button'></td>" + "</tr> " + " </tbody> </table></form></div></div>");

			}

		}
		if (slide_type.equalsIgnoreCase("type2")) {
			HashMap<Integer, String> hashMap = new HashMap<>();
			if (cmsLesson.getSlides() != null) {
				for (CMSSlide cmsSlide : cmsLesson.getSlides()) {
					if (cmsSlide.getSlide_type().equalsIgnoreCase("EVALUATOR_ASSESSMENT")) {
						for (CMSEVALUTAOR evalutaor : cmsSlide.getEvaluators()) {
							hashMap.put(Integer.parseInt(evalutaor.getKey()), evalutaor.getValue());
						}

					}
				}
			}

			DBUTILS util = new DBUTILS();
			stringBuffer.append("<div class='col-md-9'><div class='panel panel-primary'>Question List</div><ul class='list-group' style='max-height: 40vh;overflow-y: auto;     border: 1px solid lightgray;'>");

			String sql = "SELECT DISTINCT 	question. ID, 	question.question_text FROM 	question, 	question_skill_objective WHERE 	question_skill_objective.learning_objectiveid IN ( 		SELECT 			skill_objective. ID 		FROM 			lesson, 			skill_objective, 			lesson_skill_objective 		WHERE 			lesson. ID = lesson_skill_objective.lessonid 		AND lesson_skill_objective.learning_objectiveid = skill_objective. ID 		AND lesson. ID = "
					+ lesson_id + " 	) AND question. ID = question_skill_objective.questionid ORDER BY id ASC";

			List<HashMap<String, Object>> data = util.executeQuery(sql);

			for (HashMap<String, Object> item : data) {

				if (!hashMap.containsKey((int) item.get("id"))) {
					hashMap.put((int) item.get("id"), item.get("question_text").toString().replaceAll("<p>", "").replaceAll("</p>", ""));
				}

			}

			for (Integer key : hashMap.keySet()) {

				stringBuffer.append("   <li id='" + key + "'  class='list-group-item select_question active '> <span class='badge question_holder' style='float: left;'>" + key + "</span><div class='question_text'>" + hashMap.get(key) + "</div></li> ");

			}

			String sql1 = "SELECT skill_objective.name, 			skill_objective. ID 		FROM 			lesson, 			skill_objective, 			lesson_skill_objective 		WHERE 			lesson. ID = lesson_skill_objective.lessonid 		AND lesson_skill_objective.learning_objectiveid = skill_objective. ID";
			List<HashMap<String, Object>> data1 = util.executeQuery(sql1);

			stringBuffer.append("</ul>");
			stringBuffer.append("<label >Add More Questions Using LO</label><select id='lo_select' class='form-control'> ");
			for (HashMap<String, Object> item : data1) {
				stringBuffer.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>   ");
			}
			stringBuffer.append("</select><br/> Select All <input id='checkAll' type='checkbox' aria-label='...'><br/><ul class='list-group add_lo_question_holder' style='max-height: 40vh;overflow-y: auto;    border: 1px solid lightgray;'></ul></div>");

		}

		return stringBuffer;

	}

	public String lessonHTMLPreviewfromLessonXML(int lessonID) {
		StringBuffer stringBuffer = new StringBuffer();

		String path = "";
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			path = properties.getProperty("mediaLessonPath");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		path += "/" + lessonID + "/" + lessonID + "/" + lessonID + ".xml";

		File file = new File(path);

		try {
			JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
			Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
			CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
			int slide_id = Math.abs((int) System.nanoTime());

			stringBuffer.append(
					"<div class='row' style='text-align: center; margin-top: 5%;' ><div class='dropdown' style='margin-top: 10px;'>     <button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown'>Choose Slide Type <span class='caret'></span></button>    " + " <ul class='dropdown-menu'>       " + "<li><a href='../template/create_slide.jsp?slide_type=type1&lesson_id="
							+ lessonID + "&slide_id=" + slide_id + "'>EXCEL EVALUATOR</a></li>" + "<li><a href='../template/create_slide.jsp?slide_type=type2&lesson_id=" + lessonID + "&slide_id=" + slide_id + "'>ASSESSMENT EVALUATOR</a></li><li><a href='../template/create_slide.jsp?lesson_id=" + lessonID + "'>CREATE SLIDE</a></li></ul>   </div></div>");

			stringBuffer.append("<div id='sortable'>");
			if (cmsLesson.getSlides() != null) {
				for (CMSSlide cmsSlide : cmsLesson.getSlides()) {

					if (cmsSlide.getTemplateName().equalsIgnoreCase("NO_CONTENT")) {
						System.err.println("<<<cmsSlide.getImage_BG()>>>>>" + cmsSlide.getImage_BG());
						stringBuffer.append("<div class='row'><div style='background-image: url(" + cmsSlide.getImage_BG().replaceAll(".png", "_desktop.png").replaceAll("none", "../../img/no_content.png") + ");background-size: 100% 100%; background-repeat: no-repeat;' class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId()
								+ "'><h2></h2> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>BACKGROUND IMAGE</span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + "TITLE </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_2BOX")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + cmsSlide.getTemplateName() + "</span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_2TITLE")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + "2 TITLE </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_2TITLE_IMAGE")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + " 2 TITLE IMAGE </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_IMAGE")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div'  data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h2></h2> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>IMAGE </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_LIST")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h2></h2> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>UN-ORDERED LIST </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_LIST_NUMBERED")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h2></h2> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>ORDERED LIST </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_PARAGRAPH_TITLE_LIST")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h2></h2> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>LIST TITLE </span></div></div>");
					}

					else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_PARAGRAPH_IMAGE_LIST")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h2></h2> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>LIST IMAGE </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_IMAGE")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + "TITLE IMAGE </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_LIST")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + " TITLE UN-ORDERED LIST </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_LIST_NUMBERED")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + "TITLE ORDERED LIST </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_PARAGRAPH_cells_fragemented")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + cmsSlide.getTemplateName() + "</span></div></div>");
					}

					else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_PARAGRAPH_IMAGE") || cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_PARAGRAPH_IMAGE_LIST")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + " TITLE LIST IMAGE </h6></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_TITLE_TREE")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div'  data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(cmsSlide.getTitle().getText(), 23)
								+ "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + "TITLE TREE </h6></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_VIDEO")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div'  data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h2></h2> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>VIDEO </h6></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_EVALUATOR_EXCEL")) {
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'></h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>" + "EVALUATOR_EXCEL </span></div></div>");
					} else if (cmsSlide.getTemplateName().equalsIgnoreCase("ONLY_EVALUATOR_ASSESSMENT")) {
						String evalutaor = "";
						evalutaor = cmsSlide.getEvaluators().get(0).getValue();
						stringBuffer.append("<div class='row'><div class='col-md-8 custom_div' data-template='" + cmsSlide.getTemplateName() + "' data-slideID='" + cmsSlide.getId() + "'><h4 style='    display: inline;'>" + StringUtils.abbreviate(evalutaor, 23) + "</h4> <span class='label label-info' style='font-size: 8px; position: absolute;     bottom: 1px;          left: 0;'>"
								+ "EVALUATOR_ASSESSMENT </span></div></div>");
					}

				}
			}
			stringBuffer.append("</div>");

		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return stringBuffer.toString();
	}

	public void createDummyLessonXML(Lesson lesson) throws JAXBException, IOException {
		// creates a dummy Presentation type Lesson Presentation
		CMSLesson cmsLesson = new CMSLesson();
		String type = lesson.getType();
		String lessonDescription = lesson.getDescription();
		String lessonTitle = lesson.getTitle();
		ArrayList<CMSSlide> slides = new ArrayList<>();
		CMSSlide cmsSlide = new CMSSlide();
		java.io.StringWriter lessonXml = new StringWriter();
		cmsSlide = createNoContentSlide(cmsSlide);
		slides.add(cmsSlide);
		cmsLesson.setType(type);
		cmsLesson.setLessonDescription(lessonDescription);
		cmsLesson.setLessonTitle(lessonTitle);
		cmsLesson.setSlides(slides);
		JAXBContext context = JAXBContext.newInstance(CMSLesson.class);
		Marshaller marshaller = context.createMarshaller();
		marshaller.marshal(cmsLesson, lessonXml);
		saveLessonXML(lessonXml.toString(), lesson);
	}

	public CMSSlide createNoContentSlide(CMSSlide cmsSlide) {
		cmsSlide.setTemplateName("NO_CONTENT");
		cmsSlide.setOrder_id(1);
		cmsSlide.setId(999999);
		cmsSlide.setSlide_type("INFORMATION_ONLY");
		String image_BG = "none";
		cmsSlide.setImage_BG(image_BG);
		return cmsSlide;
	}

}
