
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.cms.oldcontent.CMSLesson;
import com.viksitpro.core.cms.oldcontent.CMSSlide;
import com.viksitpro.core.cms.oldcontent.CMSTitle;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.utilities.IStarBaseServelet;
import com.viksitpro.factory.task.TaskEntityServices;

@WebServlet("/slide_add_delete")
public class SlideAddDeleteController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public SlideAddDeleteController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//

		String key = request.getParameter("key");
		String lesson_id = request.getParameter("lesson_id");
		TaskEntityServices entityServices = new TaskEntityServices();
		Lesson lesson = (new LessonDAO()).findById(Integer.parseInt(lesson_id));
		entityServices.updateLesson(lesson , request.getSession());
		String slide_id = request.getParameter("slide_id");
		String colorCode = request.getParameter("colorCode");
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

		if (key.equalsIgnoreCase("background_img_delete")) {

			if (!slide_id.trim().equalsIgnoreCase("")) {
				CMSLesson cmsLesson = null;
				try {
					cmsLesson = (CMSLesson)getLessonXmlForBackgroundImage(file, lesson_id, slide_id);
				} catch (JAXBException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				writeLessonXml(file, lesson_id, cmsLesson);
			}
		}
		
		if (key.equalsIgnoreCase("addBGColor")) {
			if (!slide_id.trim().equalsIgnoreCase("")) {
				CMSLesson cmsLesson = (CMSLesson) getLessonXml(file, lesson_id, slide_id,colorCode);
				
				if(cmsLesson != null) {
					
					writeLessonXml(file, lesson_id, cmsLesson);
				}
				
			}

		}

		if (key.equalsIgnoreCase("delete")) {

			if (!slide_id.trim().equalsIgnoreCase("")) {
				CMSLesson cmsLesson = (CMSLesson) getLessonXml(file, lesson_id, slide_id,null);
				writeLessonXml(file, lesson_id, cmsLesson);
			}

		} else if (key.equalsIgnoreCase("re_order")) {

			if (!slide_id.trim().equalsIgnoreCase("")) {
				CMSLesson cmsLesson = new CMSLesson();
				ArrayList<CMSSlide> cmSlideList = new ArrayList<>();
				String[] slide_ids = slide_id.split(",");
				int order_id =1;
				for (String Slide : slide_ids) {

					CMSSlide cmsSlide = (CMSSlide) reorderLessonXml(file, lesson_id, Integer.parseInt(Slide),order_id);
					
					cmSlideList.add(cmsSlide);
					order_id++;
				}

				cmsLesson.setSlides(cmSlideList);
				writeLessonXml(file, lesson_id, cmsLesson);
			}

		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	private Object getLessonXmlForBackgroundImage(File file, String lesson_id, String slide_id) throws JAXBException {

		JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
		Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
		CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
		ArrayList<CMSSlide> cmSlideList = new ArrayList<>();
		if (cmsLesson.getSlides() != null) {
			for (CMSSlide cmsSlide : cmsLesson.getSlides()) {

				if (cmsSlide.getId() == Integer.parseInt(slide_id)) {
					
					cmsSlide.setImage_BG(null);
					cmSlideList.add(cmsSlide);
					
				}else {
					cmSlideList.add(cmsSlide);
				}
			}
			cmsLesson.setSlides(cmSlideList);
			return cmsLesson;
		}

		return null;

	}

	private Object getLessonXml(File file, String lesson_id, String slide_id,String colorCode) {

		try {

			JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
			Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
			CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
			ArrayList<CMSSlide> cmSlideList = new ArrayList<>();
			if (cmsLesson.getSlides() != null) {
				for (CMSSlide cmsSlide : cmsLesson.getSlides()) {

					if (cmsSlide.getId() == Integer.parseInt(slide_id)) {
						
						if(colorCode != null && !colorCode.equalsIgnoreCase("null") && !colorCode.equalsIgnoreCase("")) {
							System.err.println("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");

							cmsSlide.setBackground(colorCode);
							cmSlideList.add(cmsSlide);
							
						}

					} else {

						cmSlideList.add(cmsSlide);

					}
				}
				cmsLesson.setSlides(cmSlideList);
			}
			return cmsLesson;

		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return null;
	}
	

	private Object reorderLessonXml(File file, String lesson_id, int slide_id,int order_id) {

		try {

			JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
			Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
			CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
			ArrayList<CMSSlide> cmSlideList = new ArrayList<>();
			 
			for (CMSSlide cmsSlide : cmsLesson.getSlides()) {

				if (cmsSlide.getId() == slide_id) {
					cmsSlide.setOrder_id(order_id);
					
					return cmsSlide;

				}
			}

		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return null;
	}

	private void writeLessonXml(File file, String lesson_id, CMSLesson cmsLesson) {

		try {

			JAXBContext jaxbContext = JAXBContext.newInstance(CMSLesson.class);
			Marshaller jaxbMarshaller = jaxbContext.createMarshaller();

			jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

			jaxbMarshaller.marshal(cmsLesson, file);
			// jaxbMarshaller.marshal(cmsLesson, System.out);

		} catch (JAXBException e) {
			e.printStackTrace();
		}

	}

}
