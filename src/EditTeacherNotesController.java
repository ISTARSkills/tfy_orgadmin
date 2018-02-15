
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
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
import com.viksitpro.core.utilities.IStarBaseServelet;


@WebServlet("/edit_teachernotes")
public class EditTeacherNotesController  extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
   
    public EditTeacherNotesController() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		
		
	
		String teacher_notes_comment = request.getParameter("teacher_notes_comment");
		String lesson_id = request.getParameter("lesson_id");	
		String slide_id = request.getParameter("slide_id");
		
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
		
		path += "" + lesson_id + "/"+lesson_id+"/"+lesson_id+".xml";
	
		File file = new File(path);
		
		CMSLesson cmsLesson = (CMSLesson) getLessonXml(file,lesson_id,slide_id,teacher_notes_comment);
		writeLessonXml(file,lesson_id,cmsLesson);
		
		 response.getWriter().append(teacher_notes_comment);
	}

/*	
	private void printParams(HttpServletRequest request) {
		// TODO Auto-generated method stub
		
	}
*/

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}
	
	private void writeLessonXml(File file, String lesson_id, CMSLesson cmsLesson) {
		
		 try {

				
				JAXBContext jaxbContext = JAXBContext.newInstance(CMSLesson.class);
				Marshaller jaxbMarshaller = jaxbContext.createMarshaller();

				
				jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

				jaxbMarshaller.marshal(cmsLesson, file);
				//jaxbMarshaller.marshal(cmsLesson, System.out);

			      } catch (JAXBException e) {
				e.printStackTrace();
			      }
		
	}
	
private Object getLessonXml(File file, String lesson_id, String slide_id, String value) {
		
		
		try {

			
			    JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
				Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
				CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
				for (CMSSlide cmsSlide : cmsLesson.getSlides()) {
					
                  if(cmsSlide.getId() == Integer.parseInt(slide_id)){
                	  
                	  cmsSlide.setTeacherNotes(value);
						
				    }
				}
				
				return cmsLesson;
				
				

		  } catch (JAXBException e) {
			e.printStackTrace();
		  }
		return null;
	}

}
