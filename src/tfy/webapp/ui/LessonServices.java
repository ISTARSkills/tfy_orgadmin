package tfy.webapp.ui;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import java.util.Set;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.RuntimeConstants;
import org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.viksitpro.core.cms.oldcontent.CMSLesson;
import com.viksitpro.core.cms.oldcontent.CMSSlide;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.Context;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;
import com.viksitpro.core.utilities.DBUTILS;

public class LessonServices {

	public String lessonHTMLfromLessonXML(int lessonID) throws IOException {
		StringBuffer stringBuffer = new StringBuffer();
		URL url = new URL("http://cdn.talentify.in/lessonXMLs/" + lessonID + "/" + lessonID + "/" + lessonID + ".xml");
		HttpURLConnection http = (HttpURLConnection) url.openConnection();
		InputStream is = http.getInputStream();
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

		URL file = new URL("http://cdn.talentify.in/lessonXMLs/" + lessonID + "/" + lessonID + "/" + lessonID + ".xml");

		try {
			JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
			Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
			CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(is);
			for (CMSSlide cmsSlide : cmsLesson.getSlides()) {
				String ext = "_desktop.vm";
				String templateVMFileName = cmsSlide.getTemplateName() + ext;
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

				String header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand]
						+ "' data-background-color='" + cmsSlide.getBackground() + "' " + bgImage
						+ " data-background-size='" + type + "'";
				if (cmsSlide.getBackground().equalsIgnoreCase("#000000")) {

					header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand] + "'   "
							+ bgImage + "  data-background-color='#ffffff' data-background-size='" + type + "'";
				}

				if (cmsSlide.getBackground().equalsIgnoreCase("null")) {
					header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand] + "'   "
							+ bgImage + "  data-background-color='#ffffff' data-background-size='" + type + "'";
				}

				if (cmsSlide.getBackground().equalsIgnoreCase("none")) {
					header = "id='" + cmsSlide.getId() + "' data-background-transition='" + transitions[rand] + "'   "
							+ bgImage + " data-background-color='#ffffff' data-background-size='" + type + "'";
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
					data1 = data1.replaceAll("<th scope=\"row\"",
							"<th scope='row' style='border: 1px solid;background: lightgray;'");
					data1 = data1.replaceAll("<th scope=\"col\"",
							"<th scope='row' style='border: 1px solid;background: lightgray;'");
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
				stringBuffer.append(
						"<div data-title='" + cmsSlide.getTitle().getText() + "' class='hidden_element' id='slide_"
								+ cmsSlide.getId() + "' data-template='" + cmsSlide.getTemplateName().toLowerCase()
								+ "' data-slide_id='" + cmsSlide.getId() + "' data-length='" + length + "' ></div>");

			}
		} catch (JAXBException e) {
			System.out.println("file name ->" + file);
			e.printStackTrace();
		}
		return stringBuffer.toString();
	}

	public String lessonHTMLfromLessonXMLAddendum(int lessonID) throws IOException {
		String addendum = "";
		Set<String> addendum_links = new HashSet<>();
		Boolean is_addendum = checkLessonFolderforAddendum(lessonID, addendum_links, addendum);
		if(is_addendum) {
			addendum += "<section  fragment_count="+addendum_links.size()+" class='SIMPLE_LIST___ONLY_TITLE_LIST' id='9999' data-background-transition='convex' data-background-color='#ffffff' data-background-image='http://cdn.talentify.in/lessonXMLs/3477/3477/MS_Word_Session01_Common_desktop.png' data-background-size='100% 100%' >";
			addendum += "<h1 data-slide_id='9999' data-element_type='TITLE' class='edit'>Addendum</h1>";
			addendum += "<ul>";
			for(String addendum_link : addendum_links) {
				String link = getAnyPath("cdn_path")+"lessonXMLs/"+lessonID+"/"+lessonID+"/"+addendum_link;
				addendum += "<li data-slide_id='9999' data-element_type='LIST' class=' fade-up' data-fragment-index='0'><a href='"+link+"'>"+addendum_link+"</li> ";
			}
			addendum += "</ul><aside class='notes'> Ask the class to download these resources, as they will form the basis of the case studies etc during the lesson </aside> </section> <div class='hidden_element' id='slide_4529' data-template='only_title_list' data-slide_id='4529' data-length='120' ></div>";
		}
		return addendum;
	}

	public Boolean checkLessonFolderforAddendum(int lessonID, Set<String> addendum_links, String addendum) throws IOException {
		Boolean is_addendum = false;
		String lessonXMLFolderPath = "";
		String lessonFolderPath = "";
		lessonXMLFolderPath = getAnyPath("mediaLessonPath");
		lessonFolderPath = lessonXMLFolderPath + lessonID + "/" + lessonID;
		File lessonmFolder = new File(lessonFolderPath);
		if (lessonmFolder.exists() && lessonmFolder.isDirectory()) {
			for (File file : lessonmFolder.listFiles()) {
				if (file.getName().endsWith(".docx") || file.getName().endsWith(".xlsx")
						|| file.getName().endsWith(".pdf")) {
					is_addendum = true;
					addendum_links.add(file.getName());
				}
			}
		}
		return is_addendum;
	}

	public String getAnyPath(String nick) throws IOException {
		Properties properties = new Properties();
		properties.load(LessonServices.class.getClassLoader().getResourceAsStream("app.properties"));
		String lessonXMLPath = properties.getProperty(nick);
		return lessonXMLPath;
	}

	public Lesson saveLessonDetails(Lesson lesson, LessonDAO lessonDAO) {
		Session session = null;
		Transaction tx = null;
		try {
			session = HibernateSessionFactory.getSession();
			tx = session.beginTransaction();
			lessonDAO.attachDirty(lesson);
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
			tx.rollback();
		} finally {
			session.flush();
			session.close();

		}
		return lesson;
	}

	public HashSet<SkillObjective> getLOsfromLesson(Lesson lesson) {
		HashSet<SkillObjective> lessonLOs = new HashSet<>();
		String sql = "select learning_objectiveid from lesson_skill_objective where lessonid = " + lesson.getId();
		List<HashMap<String, Object>> selected_learning_objectives = (new DBUTILS()).executeQuery(sql);
		for (HashMap<String, Object> selected_learning_objective : selected_learning_objectives) {
			lessonLOs.add((new SkillObjectiveDAO())
					.findById(Integer.parseInt(selected_learning_objective.get("learning_objectiveid").toString())));
		}
		return lessonLOs;
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

	public Lesson getLessonforAssessment(Assessment assessment) {
		Lesson lesson = new Lesson();
		String sql = "select * from lesson where lesson_xml = '" + assessment.getId() + "'";
		List<HashMap<String, Object>> lessons = (new DBUTILS()).executeQuery(sql);
		for (HashMap<String, Object> l : lessons) {
			lesson = (new LessonDAO()).findById(Integer.parseInt(l.get("id").toString()));
		}
		return lesson;
	}
}
