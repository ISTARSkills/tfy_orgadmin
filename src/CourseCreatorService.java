import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.admin.services.EventSchedulerService;

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
			serv.createCourseStructureSQLs("C:\\Users\\Mayank\\Documents\\course_structure.xlsx");
		} catch (IOException | SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	public void createCourseStructureSQLs(String excelPath) throws Exception 
	{
		HashMap<String , Integer> courseNameIdMap = new HashMap<>();
		HashMap<String , Integer> courseBatchMap = new HashMap<>();
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
        //validating sheet 0 
        validateCourseStructure(courseStructureSheet);
		validateTalentifyEvents(timeTableSheet);
        
        
          
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
        	i++;
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
        EventSchedulerService serv = new EventSchedulerService();
        DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeFormat  = new SimpleDateFormat("HH:mm");
        HashMap<Integer, String> calDayMap = new HashMap<>();
        calDayMap.put(0,"SUN");
        calDayMap.put(1,"MON");
        calDayMap.put(2,"TUE");
        calDayMap.put(3,"WED");
        calDayMap.put(4,"THU");
        calDayMap.put(5,"FRI");
        calDayMap.put(6,"SAT");
        Calendar cal = Calendar.getInstance();
        if(timeTableSheet!=null)
        {
        	String startDateString = null;
			String excludedDaysString = null;
			Integer batchGroupId = null;
			ArrayList<String> startTimeArray = new ArrayList<>();
			ArrayList<String> endTimeArray = new ArrayList<>();
			Date startDate = null;
			HashSet<String>excludedDays = new HashSet<>();
			
        	Iterator<Row> timeTableIterator = timeTableSheet.iterator();
    		int index = 0;
    		while(timeTableIterator.hasNext())
    		{
    			
    			Row timeTableRow = timeTableIterator.next();
    			
    			if(index==0)
    			{
    				if(timeTableRow.getCell(1)==null)
    				{
    					throw new Exception("start date is null in row 1 and column B");
    				}	
    				startDateString = timeTableRow.getCell(1).getStringCellValue();
    				if(startDateString==null)
    				{
    					throw new Exception("start date is null in row 1 and column B");
    				}
    				SimpleDateFormat sdf = new SimpleDateFormat("dd:MM:yyyy");
    				sdf.setLenient(false);
    				try {
    					startDate = sdf.parse(startDateString);
    					System.out.println(startDate);
    					cal.setTime(startDate);
    				}
    				catch(Exception e)
    				{
    					throw  new Exception("start date is in incorrect format in row 1 and column B. Correct format should be dd:MM:yyyy");
    				}    				
    			}
    			else if (index==1)
    			{
    				if(timeTableRow.getCell(1)!=null)
    				{	
    					excludedDaysString = 	timeTableRow.getCell(1).getStringCellValue();
    					if(excludedDaysString.contains(","))
    					{
    						String arr[] = excludedDaysString.split(",");
    						for(int q = 0; q<arr.length;q++)
    						{
    							excludedDays.add(arr[q].trim());
    						}	
    					}
    					else
    					{
    						excludedDays.add(excludedDaysString.trim().replace(",", ""));
    					}	
    				}
    			}
    			else if(index == 2)
    			{
    				if(timeTableRow.getCell(1)==null)
    				{
    					throw new Exception("batchGroupId is null in row 3 and column B");
    				}	
    				batchGroupId = (int)timeTableRow.getCell(1).getNumericCellValue();
    				BatchGroup bg = new BatchGroupDAO().findById(batchGroupId);
    				if(bg==null)
    				{
    					throw new Exception("No batch group exists with given id");
    				}	
    				for(String courseName : courseNameIdMap.keySet())
    				{
    					Integer courseId = courseNameIdMap.get(courseName);
    					String sqlInsert ="INSERT INTO batch (id, createdat, name, updatedat, batch_group_id, course_id, order_id, year) "
    							+ "VALUES ((select max(id)+1 from batch), now(), '"+courseName+" - "+bg.getName()+"', now(), "+batchGroupId+", "+courseId+", (select max(id)+1 from batch), '2018') returning id;";
    					int batchId = util.executeUpdateReturn(sqlInsert);
    					courseBatchMap.put(courseName, batchId);
    				}
    			}
    			else if(index ==4)
    			{
    				int cellCounter = 0;
    				while(timeTableRow.getCell(cellCounter)!=null && timeTableRow.getCell(cellCounter).getStringCellValue()!=null)
    				{
    					Cell timeCell = timeTableRow.getCell(cellCounter);					
    					String timeValue = timeCell.getStringCellValue().trim().replace(" ", "");
    					if(!timeValue.contains("-"))
    					{
    						throw new Exception("Invalid Time range in row ="+(index+1)+" and column ="+(cellCounter+1)+". Correct format is 13:00-14:00.");
    					}
    					String startTime = timeValue.split("-")[0];
    					String endTime = timeValue.split("-")[1];
    					if(startTime==null)
    					{
    						throw new Exception("Invalid start time in row ="+(index+1)+" and column ="+(cellCounter+1));
    					}
    					if(endTime==null)
    					{
    						throw new Exception("Invalid end time in row ="+(index+1)+" and column ="+(cellCounter+1));
    					}	
    					startTimeArray.add(startTime);
    					endTimeArray.add(endTime);
    					cellCounter+=3;
    				}				
    			}
    			else if (index>=6)
    			{
    				int courseIndex = 0;
    				int trainerIdIndex = 1;
    				int classroomIndex = 2;
    				int eventCounterInDay = 0;
    				Timestamp eDate = new Timestamp(cal.getTimeInMillis());
    				if(excludedDays.size()>0)
    				{
    					while(excludedDays.contains(calDayMap.get(eDate.getDay())))
    					{
    						cal.add(Calendar.DATE, 1);
    						eDate = new Timestamp(cal.getTimeInMillis());
    					}	
    				}	
    				while(timeTableRow.getCell(courseIndex)!=null && timeTableRow.getCell(trainerIdIndex)!=null && timeTableRow.getCell(trainerIdIndex).getNumericCellValue()!=0d && timeTableRow.getCell(classroomIndex)!=null && timeTableRow.getCell(classroomIndex).getNumericCellValue()!=0d)					
    				{
    					
    					Cell courseCell =  timeTableRow.getCell(courseIndex);
    					Cell trainerCell = timeTableRow.getCell(trainerIdIndex);
    					Cell classroomCell = timeTableRow.getCell(classroomIndex);
    					String courseName = courseCell.getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
    					Integer courseId = null;    					
    					if(courseNameIdMap.containsKey(courseName))
    					{
    						courseId = courseNameIdMap.get(courseName);
    					}
    					if(courseId==null)
    					{
    						throw new Exception("course name in row = "+(index+1)+" and column = "+(courseIndex+1)+" does not matches with any course in course structure");
    					}
    					Integer batchId = null;
    					if(courseBatchMap.containsKey(courseName))
    					{
    						batchId = courseBatchMap.get(courseName);
    					}
    					if(batchId==null)
    					{
    						throw new Exception("course name in row = "+(index+1)+" and column = "+(courseIndex+1)+" is not mapped to batch group.");
    					}
    					System.out.println("course index "+courseIndex);
    					Integer trainerId = (int)trainerCell.getNumericCellValue();
    					Integer classroomId = (int)classroomCell.getNumericCellValue();
    					String startTimeOfEvent = startTimeArray.get(eventCounterInDay);
    					String endTimeOfEvent = endTimeArray.get(eventCounterInDay);
    					Date startTime = timeFormat.parse(startTimeOfEvent);
    					Date endTime = timeFormat.parse(endTimeOfEvent);
    					long diff = endTime.getTime() - startTime.getTime();
    					long diffSeconds = diff / 1000 % 60;
    					long diffMinutes = diff / (60 * 1000) % 60;
    					long diffHours = diff / (60 * 60 * 1000) % 24;
    					String eventDate = dateformatfrom.format(eDate);
    					System.out.println("event date "+eventDate);
    					serv.insertUpdateData(trainerId, (int)diffHours, (int)diffMinutes, batchId, null, eventDate, startTimeOfEvent, classroomId, 300, -1, null, null);    					
    					eventCounterInDay++;
    					courseIndex+=3;
    					trainerIdIndex+=3;
    					classroomIndex+=3;
    				}
    				cal.add(Calendar.DATE, 1);
    			}
    			index++;
    			System.out.println("index ="+index);
    		}	
        	
        }
        
	}


	private void validateTalentifyEvents(Sheet timeTableSheet) throws Exception {
		Iterator<Row> timeTableIterator = timeTableSheet.iterator();
		int index = 0;
		while(timeTableIterator.hasNext())
		{
			String startDate = null;
			String excludedDays = null;
			Integer batchGroupId = null;
			ArrayList<String> startTimeArray = new ArrayList<>();
			ArrayList<String> endTimeArray = new ArrayList<>();
			Row timeTableRow = timeTableIterator.next();
			if(index==0)
			{
				if(timeTableRow.getCell(1)==null)
				{
					throw new Exception("start date is null in row 1 and column B");
				}	
				startDate = timeTableRow.getCell(1).getStringCellValue();
				if(startDate==null)
				{
					throw new Exception("start date is null in row 1 and column B");
				}
				SimpleDateFormat sdf = new SimpleDateFormat("dd:MM:yyyy");
				sdf.setLenient(false);
				try {
					Date date = sdf.parse(startDate);
					System.out.println(date);
				}
				catch(Exception e)
				{
					throw  new Exception("start date is in incorrect format in row 1 and column B. Correct format should be dd-MM-yyyy");
				}
			}
			else if (index==1)
			{
				if(timeTableRow.getCell(1)!=null)
				{	
					excludedDays = 	timeTableRow.getCell(1).getStringCellValue();
				}
			}
			else if(index == 2)
			{
				if(timeTableRow.getCell(1)==null)
				{
					throw new Exception("batchGroupId is null in row 3 and column B");
				}	
				batchGroupId = (int)timeTableRow.getCell(1).getNumericCellValue();					
			}
			else if(index ==4)
			{
				int cellCounter = 0;
				while(timeTableRow.getCell(cellCounter)!=null && timeTableRow.getCell(cellCounter).getStringCellValue()!=null)
				{
					Cell timeCell = timeTableRow.getCell(cellCounter);					
					String timeValue = timeCell.getStringCellValue().trim().replace(" ", "");
					if(!timeValue.contains("-"))
					{
						throw new Exception("Invalid Time range in row ="+(index+1)+" and column ="+(cellCounter+1)+". Correct format is 13:00-14:00.");
					}
					String startTime = timeValue.split("-")[0];
					String endTime = timeValue.split("-")[1];
					if(startTime==null)
					{
						throw new Exception("Invalid start time in row ="+(index+1)+" and column ="+(cellCounter+1));
					}
					if(!startTime.contains(":"))
					{
						throw new Exception("Invalid start time in row ="+(index+1)+" and column ="+(cellCounter+1)+". Time must be in 24 Hrs format. Example 15:25.");
					}
					if(endTime==null)
					{
						throw new Exception("Invalid end time in row ="+(index+1)+" and column ="+(cellCounter+1));
					}
					if(!endTime.contains(":"))
					{
						throw new Exception("Invalid end time in row ="+(index+1)+" and column ="+(cellCounter+1)+". Time must be in 24 Hrs format. Example 15:25.");
					}
					cellCounter+=3;
				}				
			}
			else if (index>=6)
			{
				int courseIndex = 0;
				int trainerIdIndex = 1;
				int classroomIndex = 2;
				while(timeTableRow.getCell(courseIndex)!=null && timeTableRow.getCell(trainerIdIndex)!=null && timeTableRow.getCell(classroomIndex)!=null)					
				{
					Cell courseCell =  timeTableRow.getCell(courseIndex);
					Cell trainerCell = timeTableRow.getCell(trainerIdIndex);
					Cell classroomCell = timeTableRow.getCell(classroomIndex);
					courseIndex +=3;
					trainerIdIndex +=3;
					classroomIndex+=3;
				}
				
			}
			index++;	
		}
	}


	private void validateCourseStructure(Sheet courseStructureSheet) throws Exception {
		Iterator<Row> courseIterator = courseStructureSheet.iterator();
        int i =0;
        while(courseIterator.hasNext())
        {
        	Row row = courseIterator.next();
        	if(i==0)
        	{
        		i++;
        		continue;
        	}
        	
        	String courseName = null;
        	String moduleName = null;
        	String sessionName = null;
        	String lessonName = null;
        	
        	try {
        	courseName = row.getCell(0).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	moduleName = row.getCell(1).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	sessionName = row.getCell(2).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	lessonName = row.getCell(3).getStringCellValue().replaceAll("'", "").replaceAll("\"", "");
        	}catch(Exception e)
        	{
        		throw new Exception(e.getMessage().toString());
        	}
        	
        	if(courseName==null || moduleName==null || sessionName==null || lessonName==null )
        	{
        		throw new Exception("Either course name, module name , session name or lesson name is null in row "+i);
        	}	
        }	
	}
}
