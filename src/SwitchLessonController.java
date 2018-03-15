
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;


@WebServlet("/switch_lesson")
public class SwitchLessonController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
  
    public SwitchLessonController() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		String lesson_id = request.getParameter("lesson_id");
		DBUTILS db = new DBUTILS();
		
		String sql = "SELECT 	course.id as course_id FROM 	course LEFT JOIN module_course ON ( 	course. ID = module_course.course_id ) LEFT JOIN module ON ( 	module_course.module_id = module.id ) LEFT JOIN cmsession_module ON ( 	module. ID = cmsession_module.module_id ) LEFT JOIN cmsession ON ( 	cmsession. ID = cmsession_module.cmsession_id ) LEFT JOIN lesson_cmsession ON ( 	lesson_cmsession.cmsession_id = cmsession. ID ) LEFT JOIN lesson ON ( 	lesson_cmsession.lesson_id = lesson. ID ) WHERE lesson.id ="+Integer.parseInt(lesson_id);
		
		List<HashMap<String, Object>> data = db.executeQuery(sql); 
		
		if (data.size() > 0) {
			
			for (HashMap<String, Object> row : data) {
			

				String sql1 = "SELECT 	lesson.id as lesson_id FROM 	course LEFT JOIN module_course ON ( 	course. ID = module_course.course_id ) LEFT JOIN module ON ( 	module_course.module_id = module.id ) LEFT JOIN cmsession_module ON ( 	module. ID = cmsession_module.module_id ) LEFT JOIN cmsession ON ( 	cmsession. ID = cmsession_module.cmsession_id ) LEFT JOIN lesson_cmsession ON ( 	lesson_cmsession.cmsession_id = cmsession. ID ) LEFT JOIN lesson ON ( 	lesson_cmsession.lesson_id = lesson. ID ) WHERE lesson.id > "+Integer.parseInt(lesson_id)+" AND lesson.type = 'PRESENTATION' AND course.id ="+row.get("course_id")+" ORDER BY lesson. ID LIMIT 1";
				
				 List<HashMap<String, Object>> data1 = db.executeQuery(sql1); 
					
					if (data1.size() > 0) {
						for (HashMap<String, Object> row1 : data1) {
							
							lesson_id = row1.get("lesson_id").toString();
							
						}
						
					}
			}
			}
		
		
		System.err.println(lesson_id);
		
		response.getWriter().append(lesson_id);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
