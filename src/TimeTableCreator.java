import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.admin.services.EventSchedulerService;

/**
 * 
 */

/**
 * @author vaibhav
 *
 */
public class TimeTableCreator {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		TimeTableCreator serv = new TimeTableCreator();
		try {
			serv.importTimeTable("C:\\Users\\vaibhav\\Pictures\\HSPT-2 (1).xlsx");
		} catch (IOException | SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("done");

	}

	private void validateTalentifyEvents(Sheet timeTableSheet) throws Exception {
		Iterator<Row> timeTableIterator = timeTableSheet.iterator();
		int index = 0;
		if(timeTableIterator.hasNext()){while(timeTableIterator.hasNext())
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
					ViksitLogger.logMSG(this.getClass().getName(),date);
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
	}
	public void importTimeTable(String excelPath) throws Exception
	{
		 Sheet timeTableSheet  = null;
		 FileInputStream excelFile = new FileInputStream(new File(excelPath));
	     Workbook workbook = new XSSFWorkbook(excelFile);
	     if(workbook.getNumberOfSheets()>0) {
	         timeTableSheet = workbook.getSheetAt(0);  
	         validateTalentifyEvents(timeTableSheet);
	     }
	     
	     DBUTILS util = new DBUTILS();
	     HashMap<Integer, Integer>courseBatchMap = new HashMap<>();
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
	    					ViksitLogger.logMSG(this.getClass().getName(),startDate);
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
	    					Integer courseId = (int)courseCell.getNumericCellValue();
	    					  					
	    					Integer batchId = null;
	    					
	    					if(courseBatchMap.containsKey(courseId))
	    					{
	    						batchId = courseBatchMap.get(courseId);
	    					}
	    					else
	    					{
	    						//create batch 
	    						Course c = new CourseDAO().findById(courseId);
	    						BatchGroup bg = new BatchGroupDAO().findById(batchGroupId);
		    					String sqlInsert ="INSERT INTO batch (id, createdat, name, updatedat, batch_group_id, course_id, order_id, year) "
		    							+ "VALUES ((select max(id)+1 from batch), now(), '"+c.getCourseName()+" - "+bg.getName()+"', now(), "+batchGroupId+", "+courseId+", (select max(id)+1 from batch), '2018') returning id;";
		    					batchId = util.executeUpdateReturn(sqlInsert);
		    					courseBatchMap.put(courseId, batchId);	    						
	    					}	
	    					if(batchId==null)
	    					{
	    						throw new Exception("course id in row = "+(index+1)+" and column = "+(courseIndex+1)+" is not mapped to batch group.");
	    					}
	    					ViksitLogger.logMSG(this.getClass().getName(),"course index "+courseIndex);
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
	    					ViksitLogger.logMSG(this.getClass().getName(),"event date "+eventDate);
	    					serv.insertUpdateData(trainerId, (int)diffHours, (int)diffMinutes, batchId, null, eventDate, startTimeOfEvent, classroomId, 300, -1, null, "0");    					
	    					eventCounterInDay++;
	    					courseIndex+=3;
	    					trainerIdIndex+=3;
	    					classroomIndex+=3;
	    				}
	    				cal.add(Calendar.DATE, 1);
	    			}
	    			index++;
	    			ViksitLogger.logMSG(this.getClass().getName(),"index ="+index);
	    		}	
	        	
	        }
	}
}
