import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.HashMap;
import java.util.Iterator;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * 
 */

/**
 * @author vaibhav
 *
 */
public class CourseCreatorService {
	
	public static void main(String args[])
	{
		CourseCreatorService serv = new CourseCreatorService();
		try {
			serv.createCourseStructureSQLs("C:\\Users\\vaibhav\\Documents\\course_structure.xlsx");
		} catch (IOException | SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	public void createCourseStructureSQLs(String excelPath) throws FileNotFoundException, IOException, SQLException 
	{
		HashMap<String , Integer> courseNameIdMap = new HashMap<>();
		
		LinkedHashMap<String, LinkedHashMap<String, LinkedHashMap<String, LinkedHashMap<String, Integer>>>> courseTree = new LinkedHashMap<>();
		LinkedHashMap<Integer, Integer> pptLessinIdMap = new LinkedHashMap<>();
		String sql = "select reference_ppt_id , id from lesson where reference_ppt_id is not null";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		for(HashMap<String, Object>row: data)
		{
			pptLessinIdMap.put((int)row.get("reference_ppt_id"), (int)row.get("id"));
		}
		
		
		FileInputStream excelFile = new FileInputStream(new File(excelPath));
        Workbook workbook = new XSSFWorkbook(excelFile);
        Sheet courseStructureSheet = workbook.getSheetAt(0);
        Sheet timeTableSheet = workbook.getSheetAt(1);        
        Iterator<Row> courseIterator = courseStructureSheet.iterator();
        Pattern lastIntPattern = Pattern.compile("[^0-9]+([0-9]+)$");
        int i =0;
        while(courseIterator.hasNext())
        {
        	Row row = courseIterator.next();
        	if(i==0)
        	{
        		i++;
        		continue;
        	}
        	String courseName = row.getCell(0).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	String moduleName = row.getCell(1).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	String sessionName = row.getCell(2).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	String lessonName = row.getCell(3).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	Integer lessonId = null;
        	
        	
        	if(row.getCell(4)!=null)
        	{
        		if(row.getCell(4).getStringCellValue()!=null)
        		{
        			String lessonUrl = row.getCell(4).getStringCellValue();
        			if(lessonUrl.toLowerCase().contains("api.talentify.in"))
        			{
        				Matcher matcher = lastIntPattern.matcher(lessonUrl);        				
        				if (matcher.find()) {
        				    String someNumberStr = matcher.group(1);
        				    int pptId = Integer.parseInt(someNumberStr);
        				    if(pptLessinIdMap.get(pptId)!=null)
        				    {
        				    	lessonId = pptLessinIdMap.get(pptId);
        				    }	
        				}
        			}
        			else if (lessonUrl.toLowerCase().contains("elt.talentify.in"))
        			{
        				Matcher matcher = lastIntPattern.matcher(lessonUrl);        				
        				if (matcher.find()) {
        				    String someNumberStr = matcher.group(1);
        				    lessonId = Integer.parseInt(someNumberStr);
        				}
        			}	
        		}
        	}
        	
        	if(courseTree.containsKey(courseName))
        	{
        		 LinkedHashMap<String, LinkedHashMap<String, LinkedHashMap<String, Integer>>> modulesInCourse = courseTree.get(courseName);       		 
        		 if(modulesInCourse.containsKey(moduleName))
        		 {
        			 LinkedHashMap<String, LinkedHashMap<String, Integer>>  cmsessionsInModule= modulesInCourse.get(moduleName);
        			 if(cmsessionsInModule.containsKey(sessionName))
        			 {
        				 LinkedHashMap<String, Integer> lessonsInCMSession =  cmsessionsInModule.get(sessionName);
        				 if(!lessonsInCMSession.containsKey(lessonName))
        				 {
        					 lessonsInCMSession.put(lessonName, lessonId);            				
        				 }
        				 cmsessionsInModule.put(sessionName, lessonsInCMSession);        				 
        			 }
        			 else
        			 {
        				 LinkedHashMap<String, Integer> lessonsInCMSession =  new LinkedHashMap<>();
        				 lessonsInCMSession.put(lessonName, lessonId);
        				 cmsessionsInModule.put(sessionName, lessonsInCMSession);   				 
        			 }
        			 modulesInCourse.put(moduleName, cmsessionsInModule);
        		 }
        		 else
        		 {
        			 LinkedHashMap<String, LinkedHashMap<String, Integer>>  cmsessionsInModule= new LinkedHashMap<>();
        			 LinkedHashMap<String, Integer> lessonsInCMSession =  new LinkedHashMap<>();
    				 lessonsInCMSession.put(lessonName, lessonId);
    				 cmsessionsInModule.put(sessionName, lessonsInCMSession);
    				 modulesInCourse.put(moduleName, cmsessionsInModule);
        		 }
        		 courseTree.put(courseName, modulesInCourse);
        	}
        	else
        	{
        		 LinkedHashMap<String, LinkedHashMap<String, LinkedHashMap<String, Integer>>> modulesInCourse = new LinkedHashMap<>();  		 
        		 LinkedHashMap<String, LinkedHashMap<String, Integer>>  cmsessionsInModule= new LinkedHashMap<>();
        		 LinkedHashMap<String, Integer> lessonsInCMSession =  new LinkedHashMap<>();
    			 lessonsInCMSession.put(lessonName, lessonId);
    			 cmsessionsInModule.put(sessionName, lessonsInCMSession);
    			 modulesInCourse.put(moduleName, cmsessionsInModule);        		 
        		 courseTree.put(courseName, modulesInCourse);
        	}	
        }
        
        int j=0;
        for(String courseName : courseTree.keySet())
    	{
        	String insertCourse ="INSERT INTO course (id, course_name, course_description, tags, created_at, category, image_url) "
        			+ "VALUES ((select max(id) +1 from course), '"+courseName+"', '"+courseName+"', NULL, NULL, NULL, NULL) returning id;";
        	Integer courseId =  util.executeUpdateReturn(insertCourse);
        	
        	LinkedHashMap<String, LinkedHashMap<String, LinkedHashMap<String, Integer>>> modulesInCourse = courseTree.get(courseName);       		 
    		for(String moduleName : modulesInCourse.keySet())
    		{
    			String insertModule = "INSERT INTO module (id, module_name, order_id, is_deleted, module_description, image_url) "
    					+ "VALUES ((select max(id) +1 from module), '"+moduleName+"', '1', 'f', '"+moduleName+"', NULL) returning id;";
    			Integer moduleId =  util.executeUpdateReturn(insertModule);
    			LinkedHashMap<String, LinkedHashMap<String, Integer>>  cmsessionsInModule= modulesInCourse.get(moduleName);
    			for(String cmsessionName : cmsessionsInModule.keySet())
    			{
    				String insertCMSession ="INSERT INTO cmsession (id, title, description, order_id, is_deleted, created_at, image_url) "
    						+ "VALUES ((select max(id) +1 from cmsession), '"+cmsessionName+"', '"+cmsessionName+"', NULL, 'f', now(), NULL) returning id;";
    				Integer sessionId = util.executeUpdateReturn(insertCMSession);
    				LinkedHashMap<String, Integer> lessonsInCMSession =  cmsessionsInModule.get(cmsessionName);
    				for(String lessonName : lessonsInCMSession.keySet())
    				{
    					Integer lessonId = null;
    					System.out.println((j++)+" >"+courseName+" > "+moduleName+" >"+cmsessionName+" >"+lessonName);
    					if(lessonsInCMSession.get(lessonName)!=null)
    					{
    						lessonId = lessonsInCMSession.get(lessonName);
    					}
    					else
    					{
    						String insertLesson ="INSERT INTO lesson (id, type, duration, tags, title, subject, order_id, created_at, is_deleted, description, image_url, lesson_xml, category, is_published, reference_ppt_id) "
    								+ "VALUES ((select max(id) +1 from lesson), 'PRESENTATION', '60', NULL, '"+lessonName+"', 'NONE', NULL, now(), 'f', NULL, NULL, '', 'BOTH', 'f', NULL) returning id;";
    						lessonId = util.executeUpdateReturn(insertLesson);
    					}
    					if(lessonId!=null && sessionId!=null)
    					{
    						String insertLessonCMSessionMap ="INSERT INTO lesson_cmsession (lesson_id, cmsession_id) VALUES ("+lessonId+", "+sessionId+");";
    						util.executeUpdate(insertLessonCMSessionMap);
    					}
    					else
    					{
    						System.out.println("session id or lesson id is null for "+lessonName);
    					}	
    				}
    				
    				if(sessionId!=null && moduleId!=null)
    				{
    					String insertSessionModuleMap ="INSERT INTO cmsession_module (cmsession_id, module_id) VALUES ("+sessionId+", "+moduleId+");";
						util.executeUpdate(insertSessionModuleMap);
    				}
    				else
    				{
    					System.out.println("session id or module id is null for "+ cmsessionName);
    				}	
    			}
    			if(courseId!=null)
    			{
    				courseNameIdMap.put(courseName, courseId);
    			}	
    			if(moduleId!=null && courseId!=null)
    			{
    				String moduleCourseMap ="INSERT INTO module_course (module_id, course_id) VALUES ("+moduleId+", "+courseId+");";
    				util.executeUpdate(moduleCourseMap);
    			}
    			else
    			{
    				System.out.println("course id or module id is null for "+ moduleName);
    			}	
    		}
    	}
        
        if(timeTableSheet!=null)
        {
        	Iterator<Row> timeTableIterator = timeTableSheet.iterator();
        	
        }
        
	}
}
