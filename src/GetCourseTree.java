

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class GetCourseTree
 */
@WebServlet("/get_course_tree")
public class GetCourseTree extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetCourseTree() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String courseId = request.getParameter("course_id");
		Course c = new CourseDAO().findById(Integer.parseInt(courseId));
		int nodeCounter = 1;
		JSONArray array = new JSONArray();
		JSONObject course = new JSONObject();
		String baseImageURl = "http://elt.talentify.in:9999/";
		String courseImageUrl = null;
		if(c.getImage_url()!=null)
		{
			courseImageUrl =baseImageURl+c.getImage_url();
		}	
		try {
			course.put("node_id", new Integer(nodeCounter));
			course.put("item_id", "course_"+courseId);
			course.put("text", c.getCourseName());
			course.put("population", "null");
			course.put("flagUrl", courseImageUrl);
			course.put("checked", "null");
			course.put("hasChildren", "null");
			course.put("xmlExist", false);
			nodeCounter++;
			JSONArray modulesArray = new JSONArray();
			DBUTILS util = new DBUTILS();
			String getModules = "select * from module_course , module where module_course.course_id ="+courseId+" and module_course.module_id= module.id order by module_course.oid";
			List<HashMap<String, Object>> modules = util.executeQuery(getModules);						
			if(modules.size()>0)
			{
				for(HashMap<String, Object> modRow : modules)
				{		
					JSONObject modObject = new JSONObject();
					int moduleId = (int)modRow.get("id");
					String moduleImageUrl = null;
					if(modRow.get("image_url")!=null)
					{
						moduleImageUrl= baseImageURl+modRow.get("image_url");
					}	
					modObject.put("node_id", new Integer(nodeCounter));
					modObject.put("item_id", "module_"+moduleId);
					modObject.put("text",modRow.get("module_name"));
					modObject.put("population", "null");
					modObject.put("flagUrl", moduleImageUrl);
					modObject.put("checked", "null");
					modObject.put("hasChildren", "null");
					modObject.put("xmlExist", false);
					nodeCounter++;
					JSONArray sessionArray = new JSONArray();
					String getCMSessions ="select * from cmsession_module, cmsession where cmsession_module.module_id="+moduleId+" and cmsession_module.cmsession_id = cmsession.id order by cmsession_module.oid";
					List<HashMap<String, Object>> cmsessions = util.executeQuery(getCMSessions);
					if(cmsessions.size()>0)
					{
						for(HashMap<String, Object> sessionRow : cmsessions)
						{
							JSONArray lessonArray = new JSONArray();
							JSONObject sessionObject = new JSONObject();
							int sessionId = (int)sessionRow.get("id");
							String sessionImageUrl = null;
							if(sessionRow.get("image_url")!=null)
							{
								sessionImageUrl= baseImageURl+sessionRow.get("image_url");
							}	
							sessionObject.put("node_id", new Integer(nodeCounter));
							sessionObject.put("item_id", "session_"+sessionId);
							sessionObject.put("text",sessionRow.get("title"));
							sessionObject.put("population", "null");
							sessionObject.put("flagUrl", sessionImageUrl);
							sessionObject.put("checked", "null");
							sessionObject.put("hasChildren", "null");
							sessionObject.put("xmlExist", false);
							nodeCounter++;
							String getLesson ="select * from lesson_cmsession, lesson where lesson_cmsession.cmsession_id="+sessionId+" and lesson_cmsession.lesson_id = lesson.id order by lesson_cmsession.oid";
							List<HashMap<String, Object>> lessons = util.executeQuery(getLesson);
							if(lessons.size()>0)
							{
								for(HashMap<String, Object> lessonRow : lessons)
								{
									boolean xmlExist = false;
									JSONObject lessonObject = new JSONObject();
									int lessonId = (int)lessonRow.get("id");
									String xmlUrl = AppProperies.getProperty("apache_path")+"/lessonXMLs/"+lessonId+"/"+lessonId+"/"+lessonId+".xml";
									File lessonXML = new File(xmlUrl);
									if(lessonXML.exists())
									{
										xmlExist = true;
									}	
									String lessonImageUrl = null;
									if(lessonRow.get("image_url")!=null)
									{
										lessonImageUrl= baseImageURl+lessonRow.get("image_url");
									}	
									lessonObject.put("node_id", new Integer(nodeCounter));
									lessonObject.put("item_id", "lesson_"+lessonId);
									lessonObject.put("text",lessonRow.get("title"));
									lessonObject.put("population", "null");
									lessonObject.put("flagUrl", lessonImageUrl);
									lessonObject.put("checked", "null");
									lessonObject.put("hasChildren", "null");
									lessonObject.put("xmlExist", xmlExist);
									nodeCounter++;	
									lessonArray.put(lessonObject);
								}
							}
							sessionObject.put("children", lessonArray);
							sessionArray.put(sessionObject);
						}
					}
					modObject.put("children", sessionArray);
					modulesArray.put(modObject);
				}
			}
			course.put("children",modulesArray);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		array.put(course);
		response.getWriter().write(array.toString());		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
