

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.json.JSONArray;
import org.json.JSONObject;

import com.viksitpro.core.cms.oldcontent.CMSEVALUTAOR;
import com.viksitpro.core.cms.oldcontent.CMSImage;
import com.viksitpro.core.cms.oldcontent.CMSLesson;
import com.viksitpro.core.cms.oldcontent.CMSList;
import com.viksitpro.core.cms.oldcontent.CMSSlide;
import com.viksitpro.core.cms.oldcontent.CMSTitle;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

@WebServlet("/slide_evaluator")
public class SlideEvaluatorsController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public SlideEvaluatorsController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//printParams(request);
		int lesson_id = 0;
		File file = null;
		if (request.getParameter("lesson_id") != null) {

			lesson_id = Integer.parseInt(request.getParameter("lesson_id"));

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

			file = new File(path);

		}
		
		if (request.getParameter("key") != null && request.getParameter("key").equalsIgnoreCase("getQuestionbylo")) {
			
			DBUTILS util = new DBUTILS();
			int lo_id = Integer.parseInt(request.getParameter("lo_id"));
			 StringBuffer stringBuffer = new StringBuffer();
			String sql = "SELECT 	question. ID, 	question.question_text FROM 	question, 	question_skill_objective WHERE 	question_skill_objective.learning_objectiveid = "+lo_id+" AND question.id = question_skill_objective.questionid";
			 List<HashMap<String, Object>> data = util.executeQuery(sql);
			 for (HashMap<String, Object> item : data) {
				 
	    		 stringBuffer.append("   <li id='"+item.get("id")+"'  class='list-group-item select_question new_select_holder'> <span class='badge question_holder' style='float: left;'>"+item.get("id") +"</span><div class='question_text'>"+item.get("question_text").toString().replaceAll("<p>", "").replaceAll("</p>", "")+"</div></li> ");

				 
			 }
			
			 
			
			response.getWriter().print(stringBuffer.toString());
		}

		if (request.getParameter("key") != null && request.getParameter("key").equalsIgnoreCase("delete")) {

			int slide_id = Integer.parseInt(request.getParameter("slide_id"));
			String cellID = request.getParameter("cellID");
			CMSLesson cmsLesson = null;
			try {
				cmsLesson = (CMSLesson) removeEvalutatorLessonXml(file, lesson_id, slide_id, cellID);
			} catch (JAXBException e) {
				e.printStackTrace();
			}
			writeLessonXml(file, lesson_id, cmsLesson);

		}
		
		if (request.getParameter("key") != null && request.getParameter("key").equalsIgnoreCase("addQuestionsToXmL")) {

			String questionID = request.getParameter("questionID");
			int slide_id = Integer.parseInt(request.getParameter("slide_id"));
			
			if(questionID != null  && !questionID.equalsIgnoreCase("")) {
				String[] questionsList=questionID.split(",&,");
			
				CMSLesson cmsLesson = null;
				try {
					cmsLesson = (CMSLesson) removeAssessmentEvalutatorLessonXml(file, lesson_id);
				} catch (JAXBException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				for(String questiondata:questionsList){  
					List<CMSEVALUTAOR> evaluators = new ArrayList<>();
					CMSEVALUTAOR cmsEvalutaor = new CMSEVALUTAOR();
					String[] questions_id =questiondata.split("&##&");
					
					String id = questions_id[0]; 
					String question = questions_id[1]; 
					
					cmsEvalutaor.setKey(id);
					cmsEvalutaor.setValue(question);
					evaluators.add(cmsEvalutaor);
					
					
					
					try {
						
						cmsLesson = (CMSLesson) CreateEvalutatorLessonXml(file, lesson_id, slide_id, evaluators,"EVALUATOR_ASSESSMENT",cmsLesson);
					} catch (JAXBException e) {
						e.printStackTrace();
					}
					writeLessonXml(file, lesson_id, cmsLesson);
				     slide_id = Math.abs((int) System.nanoTime());
				}
					}
				
				
				
			}
			
			
			
			
		
		
		

		if (request.getParameter("trcount") != null) {

			int slide_id = Integer.parseInt(request.getParameter("slide_id"));
			int trCount = Integer.parseInt(request.getParameter("trcount"));

			List<CMSEVALUTAOR> evaluators = new ArrayList<>();
			for (int i = 1; i <= trCount; i++) {

				CMSEVALUTAOR cmsEvalutaor = new CMSEVALUTAOR();
				String key = request.getParameter("key_" + i);
				String result = request.getParameter("result_" + i);
				System.err.println(key + " >>> " + result);

				cmsEvalutaor.setKey(key);
				cmsEvalutaor.setValue(result);
				if (key != null && !key.equalsIgnoreCase("")) {
					evaluators.add(cmsEvalutaor);
				}

			}

			CMSLesson cmsLesson = null;
			try {
				cmsLesson = (CMSLesson) CreateEvalutatorLessonXml(file, lesson_id, slide_id, evaluators,"EVALUATOR_EXCEL",cmsLesson);
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			writeLessonXml(file, lesson_id, cmsLesson);
			response.sendRedirect("content_creator/template/create_slide.jsp?slide_id=" + slide_id + "&slide_type=type1&lesson_id=" + lesson_id);

		}

	}

	private CMSLesson removeEvalutatorLessonXml(File file, int lesson_id, int slide_id, String cellID) throws JAXBException {

		JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
		Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
		CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
		ArrayList<CMSSlide> cmsSlideList = new ArrayList();
		for (CMSSlide cmsSlide : cmsLesson.getSlides()) {
			if (cmsSlide.getId() == slide_id) {
				List<CMSEVALUTAOR> evaluators = new ArrayList<>();
				for (CMSEVALUTAOR keydata : cmsSlide.getEvaluators()) {
					
					if (!keydata.getKey().equalsIgnoreCase(cellID)) {

						evaluators.add(keydata);

					}

				}
				cmsSlide.setEvaluators(evaluators);
			}
			cmsSlideList.add(cmsSlide);
		}

		return cmsLesson;
	}
	
	
	private CMSLesson removeAssessmentEvalutatorLessonXml(File file, int lesson_id) throws JAXBException {

		JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
		Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
		CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
		ArrayList<CMSSlide> cmsSlideList = new ArrayList();
		for (CMSSlide cmsSlide : cmsLesson.getSlides()) {
			
			if(!cmsSlide.getSlide_type().equalsIgnoreCase("EVALUATOR_ASSESSMENT")) {
				cmsSlideList.add(cmsSlide);
			}
				
		}
		cmsLesson.setSlides(cmsSlideList);
		return cmsLesson;
	}
	
	
	

	private void writeLessonXml(File file, int lesson_id, CMSLesson cmsLesson) {

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

	private CMSLesson CreateEvalutatorLessonXml(File file, int lesson_id, int slide_id, List<CMSEVALUTAOR> evaluators,String type,CMSLesson cmsLesson) throws JAXBException {

		JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
		Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
		if(cmsLesson == null) {
			cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
			
		}
		
		ArrayList<CMSSlide> cmsSlideList = new ArrayList();
		int order_id = 1;
		boolean isNew = true;
		if (cmsLesson.getSlides() != null) {
			for (CMSSlide cmsSlide : cmsLesson.getSlides()) {
					
				// set max order_id for new slide
				if (cmsSlide.getOrder_id() > order_id) {
					order_id = cmsSlide.getOrder_id();
				}

				if (cmsSlide.getId() == slide_id) {

					if (cmsSlide.getSlide_type().equalsIgnoreCase("EVALUATOR_EXCEL")) {

						cmsSlide.setEvaluators(evaluators);
						isNew = false;
					}
				}
				
					cmsSlideList.add(cmsSlide);
		
				
			}
			if (isNew) {
				CMSSlide newCmsSlide = new CMSSlide();
				newCmsSlide.setId(slide_id);
				newCmsSlide.setEvaluators(evaluators);

				newCmsSlide.setTemplateName("ONLY_"+type);
				newCmsSlide.setEvaluatorType(type);
				newCmsSlide.setFragmentCount(0);
				newCmsSlide.setOrder_id(++order_id);
				newCmsSlide.setSlide_type(type);
				newCmsSlide.setSlideDuration(0);
				newCmsSlide.setStudentNotes("Not Available");
				newCmsSlide.setTeacherNotes("Not Available");

				newCmsSlide.setAudioUrl(null);
				CMSImage image = new CMSImage();
				newCmsSlide.setImage(image);
				newCmsSlide.setImage_BG(null);
				CMSList list = new CMSList();
				newCmsSlide.setList(list);
				newCmsSlide.setParagraph(null);
				newCmsSlide.setTables(null);

				cmsSlideList.add(newCmsSlide);

			}
			cmsLesson.setSlides(cmsSlideList);
			return cmsLesson;

		}

		return null;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
