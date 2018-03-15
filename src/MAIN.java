import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URISyntaxException;
import java.net.URL;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.PropertyException;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.istarindia.android.pojo.AssessmentPOJO;
import com.istarindia.android.pojo.OptionPOJO;
import com.istarindia.android.pojo.QuestionPOJO;
import com.istarindia.android.pojo.QuestionResponsePOJO;
import com.istarindia.android.pojo.RestClient;
import com.viksitpro.core.cms.interactive.InteractiveContent;
import com.viksitpro.core.customtask.DropDownList;
import com.viksitpro.core.customtask.TaskFormElement;
import com.viksitpro.core.customtask.TaskLibrary;
import com.viksitpro.core.customtask.TaskStep;
import com.viksitpro.core.customtask.TaskTemplate;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.dao.entities.UserOrgMapping;
import com.viksitpro.core.dao.entities.UserRole;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.NotificationType;
import com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes;
import com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportList;
import in.orgadmin.utils.report.CustomReportUtils;
import in.orgadmin.utils.report.ReportUtils;
import in.talentify.core.utils.AndroidNoticeDelegator;
import in.talentify.core.utils.CMSRegistry;
import tfy.admin.studentmap.pojos.AdminCMSessionSkillData;
import tfy.admin.studentmap.pojos.AdminCMSessionSkillGraph;
import tfy.admin.trainer.CreateInterviewSchedule;


public class MAIN {
	
	
	public static void main(String[] args) throws IOException {

		/*ReportUtils util = new ReportUtils();
		HashMap<String, String> conditions = new HashMap();
		
		
		
		  String course_id="3";
		 conditions.put("course_id", course_id); 
		  String college_id="3";
		 conditions.put("college_id", college_id+"");
		  getAttendanceGraph(3052, conditions);
		//checkingReportUtils();
		//nosense();
*/
		
		//dapoooo();
		//asdas();
		//datlooper();
		//reportUtilTesting();
		//ss();
		//jsontesting();
		
		//createInterviewSkill();
		//createFarziData();
		//for(int i=0;i<15;i++)
		//{
			//createFarziData();
		//}
		
		//scheduleMeeting();
         //exceptiontesting();

		//ImportDatafromPostgres();
		//taslCreator();
		//testingTask();
		//ViksitLogger.logMSG(this.getClass().getName(),(int)Math.ceil(Float.parseFloat("2.5")));
		//xmlTesting();
		//appPropertiesTesting();
		
		//loadLogin();
		DesktopImageValidator();
		System.out.println("done");
	}
	
	





	private static void DesktopImageValidator() {
		
		//this log file is out put of tree -f -p -P *.png >tree.log
		String filePath ="C:\\Users\\vaibhav\\Documents\\tree.log";
		BufferedReader br = null;
		FileReader fr = null;

		try {

			//br = new BufferedReader(new FileReader(FILENAME));
			fr = new FileReader(filePath);
			br = new BufferedReader(fr);

			String sCurrentLine;
			HashSet<String>filestotal = new HashSet<>();
			while ((sCurrentLine = br.readLine()) != null) {
				
				if(!sCurrentLine.contains("Trash_content") && !sCurrentLine.contains("tobecopied") && !sCurrentLine.contains("oldAudio") && sCurrentLine.contains(".png"))
				{
					
					if(sCurrentLine.indexOf("./")>0) {
						//System.out.println(sCurrentLine.substring(sCurrentLine.indexOf("./"), sCurrentLine.length()-1));
						filestotal.add(sCurrentLine.substring(sCurrentLine.indexOf("./"), sCurrentLine.length()));
					}
				}	
			}
			System.out.println("total size = "+filestotal.size());
			BufferedWriter bw = null;
			FileWriter fw = null;
			String FILENAME ="C:\\Users\\vaibhav\\Documents\\defaulter.log";;
			

			fw = new FileWriter(FILENAME );
			bw = new BufferedWriter(fw);
			

			int i =0;
			for(String str : filestotal)
			{
				//String desktopFileName = str.substring(beginIndex
				//System.out.println(str);
				if(!str.contains("desktop.png"))
				{
					String desktopName = str.substring(0, str.indexOf(".png"))+"_desktop.png";
					//System.out.println(">>>>"+desktopName);
					if(!filestotal.contains(desktopName))
					{
						i++;
						
						bw.write(str+System.lineSeparator());
					}	
				}	
				
			}	
			System.out.println(i);
			try {

				if (bw != null)
					bw.close();

				if (fw != null)
					fw.close();

			} catch (IOException ex) {

				ex.printStackTrace();

			}
		} catch (IOException e) {

			e.printStackTrace();

		} finally {

			try {

				if (br != null)
					br.close();

				if (fr != null)
					fr.close();

			} catch (IOException ex) {

				ex.printStackTrace();

			}
			
			

		}
		
	}







	private static void loadLogin() {
		
		int arr[] = {11597,11604,11606,11607,11611,11612,11614,11615,11656,11667,11668,11669,11677,11689,11704,11734,11773,11789,11798,11805,11809,11813,11816,11819,11822,11825,11828,11670,11678,11698,11712,11768,11774,11794,11799,11807,11811,11814,11817,11820,11823,11826,11829,11671,11687,11700,11788,11797,11802,11808,11812,11815,11818,11821,11824,11827,11830,11594,11596,11599,11600,11601,11602,11603,11605,11608,11609,11610,11629,11630,11632,11657,11658,11659,11663,11672,11673,11674,11675,11676,11679,11684,11685,11686,11688,11690,11691,11692,11694,11695,11696,11697,11701,11702,11705,11706,11707,11708,11709,11710,11713,11724,11725,11726,11727,11766,11800,11801,11803,11835,11836,11842,11915,11916,11917,11978,11979,11980,11982,11597,11604,11606,11607,11611,11612,11614,11615,11656,11667,11668,11669,11677,11689,11704,11734,11773,11789,11798,11805,11809,11813,11816,11819,11822,11825,11828,11670,11678,11698,11712,11768,11774,11794,11799,11807,11811,11814,11817,11820,11823,11826,11829,11671,11687,11700,11788,11797,11802,11808,11812,11815,11818,11821,11824,11827,11830,11594,11596,11599,11600,11601,11602,11603,11605,11608,11609,11610,11629,11630,11632,11657,11658,11659,11663,11672,11673,11674,11675,11676,11679,11684,11685,11686,11688,11690,11691,11692,11694,11695,11696,11697,11701,11702,11705,11706,11707,11708,11709,11710,11713,11724,11725,11726,11727,11766,11800,11801,11803,11835,11836,11842,11915,11916,11917,11978,11979,11980,11982,11597,11604,11606,11607,11611,11612,11614,11615,11656,11667,11668,11669,11677,11689,11704,11734,11773,11789,11798,11805,11809,11813,11816,11819,11822,11825,11828,11670,11678,11698,11712,11768,11774,11794,11799,11807,11811,11814,11817,11820,11823,11826,11829,11671,11687,11700,11788,11797,11802,11808,11812,11815,11818,11821,11824,11827,11830,11594,11596,11599,11600,11601,11602,11603,11605,11608,11609,11610,11629,11630,11632,11657,11658,11659,11663,11672,11673,11674,11675,11676,11679,11684,11685,11686,11688,11690,11691,11692,11694,11695,11696,11697,11701,11702,11705,11706,11707,11708,11709,11710,11713,11724,11725,11726,11727,11766,11800,11801,11803,11835,11836,11842,11915,11916,11917,11978,11979,11980,11982,11597,11604,11606,11607,11611,11612,11614,11615,11656,11667,11668,11669,11677,11689,11704,11734,11773,11789,11798,11805,11809,11813,11816,11819,11822,11825,11828,11670,11678,11698,11712,11768,11774,11794,11799,11807,11811,11814,11817,11820,11823,11826,11829,11671,11687,11700,11788,11797,11802,11808,11812,11815,11818,11821,11824,11827,11830,11594,11596,11599,11600,11601,11602,11603,11605,11608,11609,11610,11629,11630,11632,11657,11658,11659,11663,11672,11673,11674,11675,11676,11679,11684,11685,11686,11688,11690,11691,11692,11694,11695,11696,11697,11701,11702,11705,11706,11707,11708,11709,11710,11713,11724,11725,11726,11727,11766,11800,11801,11803,11835,11836,11842,11915,11916,11917,11978,11979,11980,11982,11597,11604,11606,11607,11611,11612,11614,11615,11656,11667,11668,11669,11677,11689,11704,11734,11773,11789,11798,11805,11809,11813,11816,11819,11822,11825,11828,11670,11678,11698,11712,11768,11774,11794,11799,11807,11811,11814,11817,11820,11823,11826,11829,11671,11687,11700,11788,11797,11802,11808,11812,11815,11818,11821,11824,11827,11830,11594,11596,11599,11600,11601,11602,11603,11605,11608,11609,11610,11629,11630,11632,11657,11658,11659,11663,11672,11673,11674,11675,11676,11679,11684,11685,11686,11688,11690,11691,11692,11694,11695,11696,11697,11701,11702,11705,11706,11707,11708,11709,11710,11713,11724,11725,11726,11727,11766,11800,11801,11803,11835,11836,11842,11915,11916,11917,11978,11979,11980,11982,11597,11604,11606,11607,11611,11612,11614,11615,11656,11667,11668,11669,11677,11689,11704,11734,11773,11789,11798,11805,11809,11813,11816,11819,11822,11825,11828,11670,11678,11698,11712,11768,11774,11794,11799,11807,11811,11814,11817,11820,11823,11826,11829,11671,11687,11700,11788,11797,11802,11808,11812,11815,11818,11821,11824,11827,11830,11594,11596,11599,11600,11601,11602,11603,11605,11608,11609,11610,11629,11630,11632,11657,11658,11659,11663,11672,11673,11674,11675,11676,11679,11684,11685,11686,11688,11690,11691,11692,11694,11695,11696,11697,11701,11702,11705,11706,11707,11708,11709,11710,11713,11724,11725,11726,11727,11766,11800,11801,11803,11835,11836,11842,11915,11916,11917,11978,11979,11980,11982};
		ExecutorService executorService = Executors.newFixedThreadPool(arr.length*10);
		
		for(int i=0; i<arr.length;i++)
		{
			try {
				Runnable worker = new LoginThread(arr[i]);
				executorService.execute(worker);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
			}
		}	
		

}	
	







	private static void appPropertiesTesting() {
		AndroidNoticeDelegator nd = new AndroidNoticeDelegator();
		
	}




	private static void xmlTesting() {
		// TODO Auto-generated method stub
		InteractiveContent content = new InteractiveContent();
		String xmlPath = "C:\\var\\www\\html\\lessonXMLs\\5778\\5778\\5778.xml";
		try {
			String contentq = FileUtils.readFileToString(new File(xmlPath));
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		/*String lessonXML = lesson.getLessonXml();
		Serializer serializer = new Persister();*/
		//interactiveContent = serializer.read(InteractiveContent.class, lessonXML);
		//interactiveContent.setZipFileURL(mediaURLPath+"lessons" + lessonZipFilePath);
	}




	private static void testingTask() {
		// TODO Auto-generated method stub
		
		try {
			// req.getServletContext().getRealPath("/WEB-INF/fileName.properties")
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("dropdown_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(DropDownList.class);

			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			 DropDownList dropdownList = (DropDownList) jaxbUnmarshaller.unmarshal(file);
			//ViksitLogger.logMSG(this.getClass().getName(),dropdownList);
			//ViksitLogger.logMSG(this.getClass().getName(),dropdownList.getDropdowns().size());

		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}




	private static void taslCreator() {
		// TODO Auto-generated method stub
		TaskLibrary lib = new TaskLibrary();
		HashMap<Integer, TaskTemplate> templates = new HashMap<>();
		
		TaskTemplate template = new TaskTemplate();
		template.setDescription("This template is for sentiemnt analysis and density analysis");
		template.setId(200);
		template.setLabel("Text Analysis");
		template.setTaskName("Text Analysis");
		ArrayList<TaskStep> steps = new ArrayList<>();
		TaskStep step = new TaskStep();
		
		ArrayList<TaskFormElement> formElements = new ArrayList<>();
		TaskFormElement element = new TaskFormElement();
		element.setDataType("text_area");
		element.setElemntName("input_text");
		element.setElemntType("TEXT");
		element.setLabel("Enter Text");
		
		formElements.add(element);		
		step.setForm_elements(formElements);
		step.setLabel("Text Analysis");
		
		steps.add(step);
		
		template.setSteps(steps);
		templates.put(200, template);
		
		lib.setTemplates(templates);
		try {
			JAXBContext jaxbContext = JAXBContext.newInstance(TaskLibrary.class);
			Marshaller jaxbMarshaller = jaxbContext.createMarshaller();

			// output pretty printed
			jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);


			jaxbMarshaller.marshal(lib, System.out);
		} catch (PropertyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JAXBException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	     
		
	}




	private static void exceptiontesting() {
		
	}	




	private static void ImportDatafromPostgres() {
		// TODO Auto-generated method stub
		mAYANKtEST mm= new mAYANKtEST();
		//mm.ImportDatafromPostgres();
	}



	public static double round(double value, int places) {
		if (places < 0)
			throw new IllegalArgumentException();

		BigDecimal bd = new BigDecimal(value);
		bd = bd.setScale(places, RoundingMode.HALF_UP);
		return bd.doubleValue();
	}

	private static void createTrainerSelectionStatus() {
		DBUTILS util = new DBUTILS();

		HashMap<String, String> listofTrainerCourse = new HashMap<>();

		listofTrainerCourse.put("134","");
		listofTrainerCourse.put("133","");
		listofTrainerCourse.put("2641","");
		listofTrainerCourse.put("1779","");
		listofTrainerCourse.put("5236","");
		listofTrainerCourse.put("4482","");
		listofTrainerCourse.put("7141","");
		listofTrainerCourse.put("160","");
		listofTrainerCourse.put("385","");
		listofTrainerCourse.put("5189","");
		listofTrainerCourse.put("5968","");
		listofTrainerCourse.put("4753","");
		listofTrainerCourse.put("4739","");
		listofTrainerCourse.put("5098","");
		listofTrainerCourse.put("7210","");
		listofTrainerCourse.put("5984","");
		listofTrainerCourse.put("151","");
		listofTrainerCourse.put("147","");
		listofTrainerCourse.put("1905","");
		listofTrainerCourse.put("5036","");
		listofTrainerCourse.put("142","");
		listofTrainerCourse.put("408","");
		listofTrainerCourse.put("416","");
		
		for (String trainerList : listofTrainerCourse.keySet()) {
			String courseList = listofTrainerCourse.get(trainerList);
			String trainerCourseListQuery = "";

			if (!courseList.equalsIgnoreCase("")) {
				trainerCourseListQuery = "and course_id in(" + courseList + ")";
			}

			String courseIntrestedWiseTrainer = "SELECT DISTINCT istar_user.id,trainer_intrested_course.course_id from istar_user,user_role,trainer_intrested_course where user_role.user_id=istar_user.id and user_role.role_id=24 and istar_user.id  in (SELECT trainer_id from trainer_intrested_course) and trainer_intrested_course.trainer_id=istar_user.id and trainer_id in("
					+ trainerList + ") " + trainerCourseListQuery;
			//ViksitLogger.logMSG(this.getClass().getName(),"courseIntrestedWiseTrainer--" + courseIntrestedWiseTrainer);
			List<HashMap<String, Object>> courseIntrestedWiseTrainerList = util
					.executeQuery(courseIntrestedWiseTrainer);


			String checktrainerintrestedcourses = "SELECT DISTINCT istar_user.id,istar_user.email from istar_user,user_role where user_role.user_id=istar_user.id and user_role.role_id=24 and istar_user.id not in (SELECT trainer_id from trainer_intrested_course) and istar_user.id in ("
					+ trainerList + ")";
			List<HashMap<String, Object>> checktrainerintrestedcoursesList = util
					.executeQuery(checktrainerintrestedcourses);

			if (checktrainerintrestedcoursesList != null && checktrainerintrestedcoursesList.size() != 0) {
				//ViksitLogger.logMSG(this.getClass().getName(),"Trainer intrested courses not available for these users----->>>start \n\n");
				for (HashMap<String, Object> data : checktrainerintrestedcoursesList) {
					//ViksitLogger.logMSG(this.getClass().getName(),"ID------" + data.get("id") + " email----" + data.get("email"));
				}
				//ViksitLogger.logMSG(this.getClass().getName(),"\n\nTrainer intrested courses not available for these users----->>>end");
			}


			for (HashMap<String, Object> data : courseIntrestedWiseTrainerList) {
				int trainerId = (int) data.get("id");
				int courseId = (int) data.get("course_id");
				String checkEmpStatus = "SELECT * from trainer_empanelment_status where trainer_id=" + trainerId
						+ " and course_id=" + courseId + " ORDER BY stage desc limit 1;";

				List<HashMap<String, Object>> trainer_empanelment_statusList = util.executeQuery(checkEmpStatus);

				if (trainer_empanelment_statusList != null && trainer_empanelment_statusList.size() != 0) {
					// get latest stage selection

					for (HashMap<String, Object> item : trainer_empanelment_statusList) {
						String stage = item.get("stage").toString();
						int stageCount = Integer.parseInt(stage.charAt(stage.length() - 1) + "") + 1;
						stage = "L" + stageCount;
						setStages(trainerId, courseId, stage);
					}
				} else {
					setStages(trainerId, courseId, "L1");
				}

			}
		}
	}

	private static void createActiveTrainerCourseStautus() {
		DBUTILS util = new DBUTILS();

		String checkSelectedTrainer = "select DISTINCT trainer_id,course_id from trainer_empanelment_status where stage ='L6' and empanelment_status ='SELECTED';";
		List<HashMap<String, Object>> selectedtrainerList = util.executeQuery(checkSelectedTrainer);

		for (HashMap<String, Object> selectedTrainer : selectedtrainerList) {
			int trainer_id = (int) selectedTrainer.get("trainer_id");
			int course_id = (int) selectedTrainer.get("course_id");

			String checktrainer_course_statusExist = "SELECT * from trainer_course_status where trainer_id="
					+ trainer_id + " and course_id=" + course_id;

			List<HashMap<String, Object>> lists = util.executeQuery(checktrainer_course_statusExist);

			if (lists != null && lists.size() == 0) {
				String createtrainerCourseStatus = "INSERT INTO trainer_course_status (id, trainer_id, course_id, status, type) VALUES ((select COALESCE(max(id),0)+1 from trainer_course_status), "
						+ trainer_id + ", " + course_id + ", 'ACTIVE', 'FULL_TIME');";

				util.executeUpdate(createtrainerCourseStatus);
			}
		}
	}
	
	
	public static void setStages(int trainerId, int courseId, String stage) {
		switch (stage) {
		case "L1":
			stageEntry(trainerId, courseId, stage);
			setStages(trainerId, courseId, "L2");
			break;
		case "L2":
			stageEntry(trainerId, courseId, stage);
			setStages(trainerId, courseId, "L3");
			break;
		case "L3":
			checkAssessmentForTrainer(trainerId,courseId,stage);
			stageEntry(trainerId, courseId, stage);
			setStages(trainerId, courseId, "L4");
			break;
		case "L4":
			stageEntry(trainerId, courseId, stage);
			setStages(trainerId, courseId, "L5");
			break;
		case "L5":
			stageEntry(trainerId, courseId, stage);
			setStages(trainerId, courseId, "L6");
			break;
		case "L6":
			stageEntry(trainerId, courseId, stage);
			createActiveTrainerCourseStautus();
			break;
		default:
			createActiveTrainerCourseStautus();
		}
	}

	private static void checkAssessmentForTrainer(int trainerId, int courseId, String stage) {
		DBUTILS util = new DBUTILS();

		String sql = "select * from task where actor=" + trainerId
				+ " and item_type='ASSESSMENT' and item_id in (select assessment_id from course_assessment_mapping where course_id="
				+ courseId
				+ " UNION 	SELECT  CAST (regexp_split_to_table(constant_properties.property_value,E',') AS INTEGER) FROM constant_properties 	WHERE constant_properties.property_name = 'default_assessment_for_trainer')";
		
		
		List<HashMap<String, Object>> list = util.executeQuery(sql);
		for (HashMap<String, Object> item : list) {
			if (item.get("state").toString().equalsIgnoreCase("COMPLETED")) {
			} else {
				try {
					giveAllAssessment(trainerId);
				} catch (IOException e) {
					e.printStackTrace();
				}
				break;
			}
		}
	}

	public static void stageEntry(int trainerId, int courseId, String stage) {
		// create interview skills
		createinterviewSkillRating(trainerId, courseId, stage);

		// create trainer_empanelment_status entry
		String status = "SELECTED";
		DBUTILS util = new DBUTILS();
		String insertIntoStatus = "INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
				+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), " + trainerId + ", '"
				+ status + "', now(), '" + stage + "', " + courseId + ");";
		util.executeUpdate(insertIntoStatus);
	}

	public static void createinterviewSkillRating(int trainerId, int courseId, String stage) {
		DBUTILS util = new DBUTILS();
		Random r = new Random();
		String comments = "Trainer is Selected in stage " + stage;

		String getListofSkills = "SELECT * from interview_skill where course_id=" + courseId + " and stage_type='"
				+ stage + "'";

		String getMasterTrainer = "SELECT istar_user.id from istar_user,user_role where istar_user.id=user_role.user_id and user_role.role_id=23;";

		List<HashMap<String, Object>> masterTrainerList = util.executeQuery(getMasterTrainer);
		int maxMasters = masterTrainerList.size();

		List<HashMap<String, Object>> ListofSkills = util.executeQuery(getListofSkills);
		if (ListofSkills != null && ListofSkills.size() != 0) {
			for (HashMap<String, Object> item : ListofSkills) {
				int skill_id = (int) item.get("id");

				double rating = round(0 + (r.nextDouble() * (5 - 0)), 2);
				int master_id = (int) masterTrainerList.get(r.nextInt(maxMasters - 1) + 1).get("id");

				String createInterviewSkill = "INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) VALUES ((select COALESCE(max(id),0)+1 from interview_rating), "
						+ trainerId + ", " + skill_id + ", " + rating + ", " + master_id + ", '" + stage + "', "
						+ courseId + ");";
				util.executeUpdate(createInterviewSkill);

			}
		}

		// create trainer_comments
		int master_id = (int) masterTrainerList.get(r.nextInt(maxMasters - 1) + 1).get("id");
		String insertComments = "INSERT INTO trainer_comments (id, trainer_id, interviewer_id, stage, course_id, comments,created_at)"
				+ " VALUES ((select COALESCE(max(id),0)+1 from trainer_comments), " + trainerId + ", " + master_id
				+ ", '" + stage + "', " + courseId + ", '" + comments + "', now())";
		util.executeUpdate(insertComments);
	}
	
	
	private static void updateUserProfile() {
		
		DBUTILS dbutils=new DBUTILS();
		
		
		String userListsSql="SELECT 	ID,email FROM 	istar_user WHERE 	ID NOT IN ( 		SELECT 			user_id 		FROM 			user_profile 	)";
		List<HashMap<String, Object>> listsNotHaveProfile=dbutils.executeQuery(userListsSql);
		
		for(HashMap<String, Object> item:listsNotHaveProfile){
			int userId=(int)item.get("id");
			String email=(String)item.get("email");
			
			String firstName=email.split("@")[0];
			String gender="MALE";
			
			String userUpdateSql="INSERT INTO user_profile (id, address_id, first_name, last_name, dob, gender, profile_image, user_id, aadhar_no, father_name, mother_name, user_category) VALUES ((select COALESCE(max(id),0)+1 from user_profile), 2, '"+firstName+"', '', NULL, '"+gender+"', '', "+userId+", '0', NULL, NULL, NULL);";
			
			////ViksitLogger.logMSG(this.getClass().getName(),userUpdateSql);
			dbutils.executeUpdate(userUpdateSql);
		}
		
		userListsSql="SELECT 	ID,email FROM 	istar_user WHERE 	ID NOT IN ( 		SELECT 			user_id 		FROM 			professional_profile)";
		
List<HashMap<String, Object>> listsNotHaveProffesionProfile=dbutils.executeQuery(userListsSql);
		
		for(HashMap<String, Object> item:listsNotHaveProffesionProfile){
			int userId=(int)item.get("id");
			String userUpdateSql="INSERT INTO professional_profile (id, user_id, yop_10, marks_10, yop_12, marks_12, has_under_graduation, under_graduation_specialization_name, under_gradution_marks, has_post_graduation, post_graduation_specialization_name, post_gradution_marks, is_studying_further_after_degree, job_sector, preferred_location, company_name, position, duration, description, interested_in_type_of_course, area_of_interest, marksheet_10, marksheet_12, under_graduate_degree_name, pg_degree_name, resume_url, under_graduation_year, post_graduation_year, under_graduation_college, post_graduation_college, experience_in_years, experince_in_months, pan_no) VALUES ((select COALESCE(max(id),0)+1 from professional_profile), "+userId+", NULL, NULL, NULL, NULL, 't', NULL, NULL, 't', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'BCA', 'OTHERS', NULL, NULL, NULL, NULL, NULL, '0', '0', NULL)";
			dbutils.executeUpdate(userUpdateSql);
			////ViksitLogger.logMSG(this.getClass().getName(),userUpdateSql);
		}		
	}

	private static void scheduleMeeting() {
		CreateInterviewSchedule cc= new CreateInterviewSchedule();
		//cc.createInterviewForTrainer(6991, 174, 7000, 90, "27/06/2017", "18:22", 14,"S$");				
		//cc.createZoomSchedule("2017-06-27T12:00:00Z", "", 90);
	}

	private static void createInterviewSkill() {
		// TODO Auto-generated method stub
		DBUTILS db = new DBUTILS();
		String selectCourse = "select distinct course_id from cluster_requirement where course_id in (select DISTINCT course_id from   cluster_requirement)";
		List<HashMap<String, Object>> cc = db.executeQuery(selectCourse);
		for(HashMap<String, Object> row: cc)
		{
			int cid = (int)row.get("course_id");
			
			for(int j=0;j<10;j++)
			{
				String skillNAme = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
				String insertIntoIntervieSkill ="INSERT INTO interview_skill (id, interview_skill_name, course_id, stage_type) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_skill), '"+skillNAme+"', "+cid+", 'L4');"; 
				db.executeUpdate(insertIntoIntervieSkill);
			}						
		}
		
		for(int j=0;j<10;j++)
		{
			String skillNAme = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
			String insertIntoIntervieSkill ="INSERT INTO interview_skill (id, interview_skill_name,  stage_type) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from interview_skill), '"+skillNAme+"',  'L5');"; 
			db.executeUpdate(insertIntoIntervieSkill);
		}
		
		for(int j=0;j<10;j++)
		{
			String skillNAme = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
			String insertIntoIntervieSkill ="INSERT INTO interview_skill (id, interview_skill_name,  stage_type) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from interview_skill), '"+skillNAme+"',  'L6');"; 
			db.executeUpdate(insertIntoIntervieSkill);
		}
	}

	private static void createFarziData() throws IOException {
		// TODO Auto-generated method stub
		IstarNotificationServices notificationService = new IstarNotificationServices();
		DBUTILS db = new DBUTILS();
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");
		String firstName = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
		String lastName = RandomStringUtils.randomAlphanumeric(10).toUpperCase();
		String email = RandomStringUtils.randomAlphanumeric(5).toUpperCase()+"@"+RandomStringUtils.randomAlphanumeric(5).toUpperCase()+".com";;
		String password = "test123";
		String mobile = "789654123";
		String ugDegree = "BA";
		String pgDegree = "MA";
		String gender = "MALE";
		String dob = "28/03/1991";
		String courseIds = "";
		String avaiableTime = "";
		String experinceYears = "1";
		String experinceMonths = "0";
		String teachingAddress = "";
		String addressLine1 = RandomStringUtils.randomAlphanumeric(10).toUpperCase();;
		String addressLine2 = RandomStringUtils.randomAlphanumeric(10).toUpperCase();;
		String userType = "";
		int pincode = 560066;
		boolean hasUgDegree = false;
		boolean hasPgDegree = false;
		userType = "TRAINER";
		String presentor[] = email.split("@");
		String part1 = presentor[0];
		String part2 = presentor[1];
		String presentor_email = part1 + "_presenter@" + part2;
		TaskServices taskService = new TaskServices();
		String sql = "INSERT INTO address ( 	ID, 	addressline1, 	addressline2, 	pincode_id, 	address_geo_longitude, 	address_geo_latitude ) VALUES 	( 		(SELECT max(id)+1 FROM address), 		'"
				+ addressLine1 + "', 		'" + addressLine2 + "', 		 (select id from pincode where pin="
				+ pincode + " limit 1), 		 NULL, 		 NULL 	)RETURNING ID;";

		//ViksitLogger.logMSG(this.getClass().getName(),(sql);
		int address_id = db.executeUpdateReturn(sql);

		String insertIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
				+ email + "', '" + password + "', now(), " + mobile + ", NULL, NULL, 't') returning id;";
		int urseId = db.executeUpdateReturn(insertIntoIstarUser);
		if (userType.equalsIgnoreCase("TRAINER")) {
			String insertPresentorIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
					+ presentor_email + "', '" + password + "', now(), " + mobile
					+ ", NULL, NULL, 't') returning id;";
			int presentorId = db.executeUpdateReturn(insertPresentorIntoIstarUser);
		}

		String createUserProfile = "INSERT INTO user_profile (id,  first_name, last_name,  gender, user_id,address_id ,dob) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"
				+ firstName + "', '" + lastName + "', '" + gender + "'," + urseId + "," + address_id + " , '"
				+ dob + "');";
		db.executeUpdate(createUserProfile);

		String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + urseId
				+ ", (select id from role where role_name='" + userType
				+ "'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
		db.executeUpdate(insertIntoUserRole);

		String insertIntoProfessionalProfile = "INSERT INTO professional_profile (id, user_id, has_under_graduation,has_post_graduation, under_graduate_degree_name, pg_degree_name, experience_in_years, experince_in_months) VALUES ((select COALESCE(max(id),0)+1 from professional_profile), "
				+ urseId + ", '" + Boolean.toString(hasUgDegree).charAt(0) + "','"
				+ Boolean.toString(hasPgDegree).charAt(0) + "','" + ugDegree + "','" + pgDegree + "','"
				+ experinceYears + "','" + experinceMonths + "'); ";
		db.executeUpdate(insertIntoProfessionalProfile);

		if (userType.equalsIgnoreCase("TRAINER")) {

			String insertIntoTrainerEmpanelmentStatus = "insert into trainer_empanelment_status (id, trainer_id, empanelment_status,created_at,stage) values((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "
					+ urseId + ", '" + TrainerEmpanelmentStatusTypes.SELECTED + "',now(), '"
					+ TrainerEmpanelmentStageTypes.SIGNED_UP + "')";
			db.executeUpdate(insertIntoTrainerEmpanelmentStatus);

			String insertIntoUserOrg = "INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("
					+ urseId + ", 2, ((select COALESCE(max(id),0)+1 from user_org_mapping)));";
			db.executeUpdate(insertIntoUserOrg);
			String groupNotificationCode = UUID.randomUUID().toString();
			String selectCourse = "select distinct course_id from cluster_requirement where course_id in (select DISTINCT course_id from   cluster_requirement) and course_id in (select DISTINCT course_id from course_assessment_mapping)";
			List<HashMap<String, Object>> cc = db.executeQuery(selectCourse);			
			
			for(int i=0 ; i<3;i++)
			{
				HashMap<String, Object> row = cc.get(i);
				int course_id =(int) row.get("course_id");
				String insertInIntrestedTable = "insert into trainer_intrested_course (id, trainer_id, course_id) values((select COALESCE(max(id),0)+1 from trainer_intrested_course),"
						+ urseId + "," + course_id + ")";
				db.executeUpdate(insertInIntrestedTable);

				Course course = new CourseDAO().findById(course_id);
				String getAssessmentForCourse = "select distinct assessment_id from  course_assessment_mapping where course_id="
						+ course_id;
				List<HashMap<String, Object>> assessments = db.executeQuery(getAssessmentForCourse);
				for (HashMap<String, Object> assess : assessments) {
					int assessmentId = (int) assess.get("assessment_id");
					Assessment assessment = new AssessmentDAO().findById(assessmentId);
					String notificationTitle = "An assessment with title <b>"
							+ assessment.getAssessmenttitle() + "</b> of course <b>"
							+ course.getCourseName() + "</b> has been added to task list.";
					String notificationDescription = notificationTitle;
					String taskTitle = assessment.getAssessmenttitle();
					String taskDescription = notificationDescription;
					int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""),
							taskDescription.trim().replace("'", ""), 300 + "", urseId + "",
							assessmentId + "", "ASSESSMENT");
					IstarNotification istarNotification = notificationService.createIstarNotification(300,
							urseId, notificationTitle, notificationDescription, "UNREAD", null,
							NotificationType.ASSESSMENT, true, taskId, groupNotificationCode);
				}
			}
			
			/*String findDefaultAssessment = "select property_value from constant_properties where property_name ='default_assessment_for_trainer'";
			List<HashMap<String, Object>> defaultAssessment = db.executeQuery(findDefaultAssessment);
			if (defaultAssessment.size() > 0) {
				String defAssessments = defaultAssessment.get(0).get("property_value").toString();
				if (defAssessments != null) {
					for (String defAssess : defAssessments.split(",")) {
						int aid = Integer.parseInt(defAssess);
						Assessment assessment = new AssessmentDAO().findById(aid);
						if (assessment != null) {
							String notificationTitle = "An assessment with title <b>"
									+ assessment.getAssessmenttitle() + "</b> has been added to task list.";
							String notificationDescription = notificationTitle;
							String taskTitle = assessment.getAssessmenttitle();
							String taskDescription = notificationDescription;
							int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""),
									taskDescription.trim().replace("'", ""), 300 + "", urseId + "",
									aid + "", "ASSESSMENT");
							IstarNotification istarNotification = notificationService
									.createIstarNotification(300, urseId, notificationTitle,
											notificationDescription, "UNREAD", null,
											NotificationType.ASSESSMENT, true, taskId,
											groupNotificationCode);
						}

					}
				}
			}*/
			
			String selectPincode ="select pin from pincode where id in (select pincode_id from cluster_pincode_mapping)";
			List<HashMap<String, Object>> pincodeData = db.executeQuery(selectPincode);
			for(int i=0;i<5;i++)
			{
				
				String ssql = "INSERT INTO trainer_prefred_location ( 	ID, 	trainer_id, 	marker_id, 	prefred_location, pincode ) "
						+ "VALUES 	((SELECT COALESCE(max(id)+1,1) FROM trainer_prefred_location), "
						+ urseId + ", '" + UUID.randomUUID().toString() + "', '" + UUID.randomUUID().toString() + "',"+pincodeData.get(i).get("pin")+");";
				//ViksitLogger.logMSG(this.getClass().getName(),(ssql);
				db.executeUpdate(ssql);
			}

			ArrayList<String>days = new ArrayList<>();
			days.add("Monday");
			days.add("Tuesday");
			days.add("Wednesday");
			days.add("Thursday");
			days.add("Friday");
			days.add("Saturday");
			for(int i=0;i<5;i++)
			{
				String ssql = "INSERT INTO trainer_available_time_sloat ( 	ID, 	trainer_id, 	DAY, 	t8am_9am, 	t9am_10am, 	t10am_11am, 	t11am_12pm, 	t12pm_1pm, 	t1pm_2pm, 	t2pm_3pm, 	t3pm_4pm, 	t4pm_5pm, 	t5pm_6pm ) VALUES 	( 		(SELECT COALESCE(max(id)+1,1) FROM trainer_available_time_sloat), 	  "
						+ urseId + ", 		'" + days.get(i) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'"
						+ Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0)
						+ "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'"
						+ Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0)
						+ "', 		'" + Boolean.toString(new Random().nextBoolean()).charAt(0) + "' 	);";

				//ViksitLogger.logMSG(this.getClass().getName(),(ssql);
				db.executeUpdate(ssql);
			}

		}
		
		giveAllAssessment(urseId);
		giveL4Iterview(urseId);
		giveL5Interview(urseId);
		giveL6Interview(urseId);
	}






	private static void giveL6Interview(int urseId) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
				DBUTILS util = new DBUTILS();
				String findAllCoursesTrainerAppliedFor ="select course_id from trainer_empanelment_status where trainer_id = "+urseId+" and stage ='L5' and empanelment_status='SELECTED'";
				List<HashMap<String, Object>> data = util.executeQuery(findAllCoursesTrainerAppliedFor);
				for(HashMap<String, Object> row: data)
				{
					
					String findskills = "select id from interview_skill where  stage_type='L6'";
					List<HashMap<String, Object>> data111 = util.executeQuery(findskills);
					for(HashMap<String, Object> skll : data111)
					{
						String insert="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
								+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), "+urseId+", "+skll.get("id")+", 4.5, '300', 'L6', "+row.get("course_id")+");";
						util.executeUpdate(insert);
					}
					
					ArrayList<String> selected = new ArrayList<>();
					selected.add("SELECTED");
					selected.add("REJECTED");
					int i =  new Random().nextInt(2);
					String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
							+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", '"+selected.get(i)+"', now(), 'L6', "+row.get("course_id")+");";
					util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
				}
	}

	private static void giveL5Interview(int urseId) {
		// TODO Auto-generated method stub
		DBUTILS util = new DBUTILS();
		String findAllCoursesTrainerAppliedFor ="select course_id from trainer_empanelment_status where trainer_id = "+urseId+" and stage ='L4' and empanelment_status='SELECTED'";
		List<HashMap<String, Object>> data = util.executeQuery(findAllCoursesTrainerAppliedFor);
		for(HashMap<String, Object> row: data)
		{
			
			String findskills = "select id from interview_skill where  stage_type='L5'";
			List<HashMap<String, Object>> data111 = util.executeQuery(findskills);
			for(HashMap<String, Object> skll : data111)
			{
				String insert="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), "+urseId+", "+skll.get("id")+", 4.5, '300', 'L5', "+row.get("course_id")+");";
				util.executeUpdate(insert);
			}
			
			ArrayList<String> selected = new ArrayList<>();
			selected.add("SELECTED");
			selected.add("REJECTED");
			int i =  new Random().nextInt(2);
			String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", '"+selected.get(i)+"', now(), 'L5', "+row.get("course_id")+");";
			util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
		}
	}

	private static void giveL4Iterview(int urseId) {
		DBUTILS util = new DBUTILS();
		String findAllCoursesTrainerAppliedFor ="select course_id from trainer_empanelment_status where trainer_id = "+urseId+" and stage ='L3'";
		List<HashMap<String, Object>> data = util.executeQuery(findAllCoursesTrainerAppliedFor);
		for(HashMap<String, Object> row: data)
		{
			
			String findskills = "select id from interview_skill where course_id = 5 and stage_type='L4'";
			List<HashMap<String, Object>> data111 = util.executeQuery(findskills);
			for(HashMap<String, Object> skll : data111)
			{
				String insert="INSERT INTO interview_rating (id, trainer_id, interview_skill_id, rating, interviewer_id, stage_type, course_id) "
						+ "VALUES ((select COALESCE(max(id),0)+1 from interview_rating), "+urseId+", "+skll.get("id")+", 4.5, '300', 'L4', "+row.get("course_id")+");";
				util.executeUpdate(insert);
			}
			
			ArrayList<String> selected = new ArrayList<>();
			selected.add("SELECTED");
			selected.add("REJECTED");
			int i =  new Random().nextInt(2);
			String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", '"+selected.get(i)+"', now(), 'L4', "+row.get("course_id")+");";
			util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
		}
	}

	private static void giveAllAssessment(int urseId) throws IOException {
		DBUTILS util = new DBUTILS();
		String findAssessmentTasks = "select id, item_id from task where item_type='ASSESSMENT' and actor="+urseId;
		List<HashMap<String, Object>> data = util.executeQuery(findAssessmentTasks);
		for(HashMap<String, Object> row: data)
		{
			int assessmentId = (int)row.get("item_id");
			int taskId = (int)row.get("id");
			RestClient client = new  RestClient();

			AssessmentPOJO assessment = client.getAssessment(assessmentId, urseId);
			ArrayList<QuestionResponsePOJO> asses_response = new ArrayList<>();
			for(QuestionPOJO que : assessment.getQuestions())
			{
				QuestionResponsePOJO queResponse = new QuestionResponsePOJO();
				queResponse.setQuestionId(que.getId());	
				
				ArrayList<Integer>options = new ArrayList<>();
				for(OptionPOJO op :que.getOptions())
				{
					options.add(op.getId());				
					queResponse.setOptions(options);
				}
				
				queResponse.setDuration(2);				
				asses_response.add(queResponse);						
			}				
			client.SubmitAssessment(taskId,urseId, asses_response, assessmentId);
			String selectCourseForAssessment ="select course_id from course_assessment_mapping where assessment_id = "+assessmentId+" limit 1";
			List<HashMap<String, Object>> cc = util.executeQuery(selectCourseForAssessment);
			String insertIntoTrainerEmpanelMentStatus ="INSERT INTO trainer_empanelment_status (id, trainer_id, empanelment_status, created_at, stage, course_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "+urseId+", 'SELECTED', now(), 'L3', "+cc.get(0).get("course_id")+");";
			util.executeUpdate(insertIntoTrainerEmpanelMentStatus);
		}
	}

	
	private static void jsontesting() {
		// TODO Auto-generated method stub
		AdminCMSessionSkillGraph graph = new AdminCMSessionSkillGraph();
		HashMap<String, ArrayList<AdminCMSessionSkillData>> data = new HashMap<>();
		
		ArrayList<AdminCMSessionSkillData> list = new ArrayList<>();
		{	
		AdminCMSessionSkillData dd= new AdminCMSessionSkillData();
		dd.setName("ROOKIE");
		
		ArrayList<ArrayList<Object>> data2 = new ArrayList<>(); 
		ArrayList<Object> kv = new ArrayList<>();
		kv.add("ASDasd");
		kv.add(2);
		data2.add(kv);
		
		dd.setData(data2);
		list.add(dd);
		
	}
		{
			AdminCMSessionSkillData dd= new AdminCMSessionSkillData();
			dd.setName("MAster");
			

			ArrayList<ArrayList<Object>>data2 = new ArrayList<>(); 
			ArrayList<Object> kv = new ArrayList<>();
			kv.add("sfsdfwrew");
			kv.add(2);
			data2.add(kv);
			
			dd.setData(data2);
			list.add(dd);
			
		}
		
		data.put("MOB", list);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		String result="";
		result = gson.toJson(data);
		
		//ViksitLogger.logMSG(this.getClass().getName(),result);
		
		
		
	}


	private static void ss() {
		// TODO Auto-generated method stub
		CustomReportUtils repUtils = new CustomReportUtils();
		CustomReport report = repUtils.getReport(26);
		String sql=report.getSql();
		//ViksitLogger.logMSG(this.getClass().getName(),sql);
		sql = sql.replaceAll(":user_id", "6044").replaceAll(":limit","10").replaceAll(":offset", "20");
		//ViksitLogger.logMSG(this.getClass().getName(),sql);
		
		
	}


	private static void reportUtilTesting() {
		// TODO Auto-generated method stub
		CustomReportUtils repUtils = new CustomReportUtils();
		CustomReport report = repUtils.getReport(26);
		String sql=report.getSql().replace(":user_id", "6044");
		//ViksitLogger.logMSG(this.getClass().getName(),sql);
	}


	private static void datlooper() {
		// TODO Auto-generated method stub
		Calendar startCal = Calendar.getInstance();
	    startCal.setTime(new Date());      
    	/* if (daysList.contains(startCal.get(Calendar.DAY_OF_WEEK)) && currentOrderId< lessons.size()) {
	        	Date taskDate = new Date(startCal.getInstance().getTimeInMillis());
	        	//ViksitLogger.logMSG(this.getClass().getName(),"creatting task for date+"+taskDate);		        	
	        	for(int stid : users)
	        	{
	        		int cid=Integer.parseInt(scheduler_course_id);
	        		for(int i=0;i<freq;i++){
	        			int orderId = currentOrderId+i;
		        		if(orderId<lessons.size()){
		        			int mid = modules.get(orderId);
			        		int cms = cmsessions.get(orderId);
			        		int lid = lessons.get(orderId);
			        		scheduleTask(stid, cid, mid, cms, lid, taskDate);
		        		}
	        		}
	        	}		            
	            currentOrderId = currentOrderId+freq;
	            daysCount++;
	        }*/
			startCal.add(Calendar.DATE, 4);
    	 //ViksitLogger.logMSG(this.getClass().getName(),"checkig for "+startCal.getTime());
    	 
		/*for(int daysCount=0; daysCount< 10; )
	    {
			
	    }*/
	}


	private static void asdas() {
		// TODO Auto-generated method stub
		Organization org = new OrganizationDAO().findById(2);
		for(BatchGroup bg : org.getBatchGroups())
		{
			if(bg.getBatchStudentses().size()>0){
			//ViksitLogger.logMSG(this.getClass().getName(),bg.getName()+ " "+bg.getId()+" "+bg.getType());
			
			}
		}
	}


	private static void dapoooo() {
		Organization college = new OrganizationDAO().findById(2);
		//String sql="SELECT id,email,gender,CAST (mobile AS INTEGER),name FROM org_admin where organization_id="+org_id;
		for(UserOrgMapping userOrg : college.getUserOrgMappings())
		{
			for(UserRole  userRole : userOrg.getIstarUser().getUserRoles())
			{
				if(userRole.getRole().getRoleName().equalsIgnoreCase("ORG_ADMIN"))
				{
					IstarUser orgadmin = userRole.getIstarUser(); 
					//ViksitLogger.logMSG(this.getClass().getName(),userRole.getIstarUser());
					//ViksitLogger.logMSG(this.getClass().getName(),orgadmin.getId());
					//ViksitLogger.logMSG(this.getClass().getName(),orgadmin.getEmail());
					//ViksitLogger.logMSG(this.getClass().getName(),);
					//ViksitLogger.logMSG(this.getClass().getName(),);
					//ViksitLogger.logMSG(this.getClass().getName(),);
					//ViksitLogger.logMSG(this.getClass().getName(),);
					//ViksitLogger.logMSG(this.getClass().getName(),);
					//ViksitLogger.logMSG(this.getClass().getName(),);
					//ViksitLogger.logMSG(this.getClass().getName(),);
					
				/*	orgAdminId=orgadmin.getId()+"";
					orgAdminEmail=orgadmin.getEmail();
					orgAdminMobile=orgadmin.getMobile()+"";
					if(orgadmin.getUserProfile()!=null){
					orgAdminGender=orgadmin.getUserProfile().getGender();					
					orgAdminFirstName = orgadmin.getUserProfile().getFirstName();	
					orgAdminLastName = orgadmin.getUserProfile().getLastName();*/
					}
				}
			}
		
		//ViksitLogger.logMSG(this.getClass().getName(),"done");
		}
		
	


	public static CustomReport getReport(int reportID) {
		CustomReportList reportCollection = new CustomReportList();
		CustomReport report = new CustomReport();
		try {
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("custom_report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(CustomReportList.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (CustomReportList) jaxbUnmarshaller.unmarshal(file);

		} catch (URISyntaxException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		
		for (CustomReport r : reportCollection.getCustomReports()) {
			if (r.getId() == reportID) {
				report = r;
			}
		}
		return report;
	}
	
public static StringBuffer getAttendanceGraph(int reportID,HashMap<String, String> conditions){
		
		DBUTILS dbutils = new DBUTILS();
		StringBuffer out = new StringBuffer();
		
		
		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_"+id+"' ></div> ");
		out.append("<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"+id+"' data-y_axis_title='' data-report_title='' "
				+ " data-graph_holder='container" + id + "' id='chart_datatable_"+id+"'");
		out.append(" data-graph_type='area'>");	
		CustomReport report = getReport(reportID) ;
		String sql9 = report.getSql();
		for(String key : conditions.keySet())
		{
			sql9 = sql9.replaceAll(":"+key, conditions.get(key));
		}	
		ArrayList<String> batchNames = new ArrayList<>();
		ArrayList<String> createdAt = new ArrayList<>();
		List<HashMap<String, Object>> attendance_view = dbutils.executeQuery(sql9);
		HashMap<String, Integer> created_attendance = new HashMap<>();
		out.append(" <thead><tr>");	
		for(HashMap<String, Object>  rows : attendance_view)
		{
			if(!batchNames.contains(rows.get("batchname")))
			{
				batchNames.add(rows.get("batchname").toString());
				
			}
		}
		
		for(HashMap<String, Object>  rows : attendance_view)
		{
			if(!createdAt.contains(rows.get("created_at")))
			{
				createdAt.add(rows.get("created_at").toString());
			}
		}
		
		for(int i=0;i<batchNames.size();i++){
			
			out.append("<th>"+batchNames.get(i).trim()+"</th>");
		}
		out.append("</tr> </thead>");	
		out.append(" <tbody>");
		
		
			
			
			
			for(HashMap<String, Object>  rows1 : attendance_view)
			{
				out.append(" <tr>");
				for(int j = 0; j<createdAt.size();j++){
				
				//ViksitLogger.logMSG(this.getClass().getName(),createdAt.get(j)+"--"+rows1.get("created_at").toString());
				if(createdAt.get(j) == rows1.get("created_at").toString()){
					
					out.append( "<td>"+rows1.get("attendance")+"</td>");
					
				}else{
					out.append(" <tr><td>"+rows1.get("created_at")+"</td> ");
					  out.append( "<td>"+rows1.get("attendance")+"</td>");
				}
				
			}
			out.append( "</tr>");
		}
		
		out.append("</tbody></table>");
		
		////ViksitLogger.logMSG(this.getClass().getName(),out);
		return out;
		
		
	}
	

	private static void nosense() {
		String sql1="	SELECT 	batch_group. NAME, 	CAST ( 		(SUM(master) * 100) / COUNT (*) AS INTEGER 	) AS master, 	CAST ( 		(SUM(rookie) * 100) / COUNT (*) AS INTEGER 	) AS rookie, 	CAST ( 		(SUM(apprentice) * 100) / COUNT (*) AS INTEGER 	) AS apprentice, 	CAST ( 		(SUM(wizard) * 100) / COUNT (*) AS INTEGER 	) AS wizard FROM 	mastery_level_per_course, 	batch_group WHERE 	mastery_level_per_course.college_id =:college_id AND course_id =:course_id AND batch_group. ID = mastery_level_per_course.batch_group_id GROUP BY 	batch_group. NAME";
		Transaction tx = null;
		Session session = new BaseHibernateDAO().getSession();
		try {
			tx = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(sql1);
			HashMap<String, String> conditions = new HashMap<>();
			conditions.put("course_id", "3");
			conditions.put("college_id", "3");
			for (String key : conditions.keySet()) {
				try {
					if (sql1.contains(key)) {
						//ViksitLogger.logMSG(this.getClass().getName(),"key->" + key + "   value-> " + conditions.get(key));						
						//query.setParameter("course_id", Integer.parseInt(conditions.get(key)));
						query.setParameter("course_id", "3");
						query.setParameter("college_id", "3");
					}
				} catch (Exception e) {
					e.printStackTrace();
					query.setParameter(key, conditions.get(key));
				}
			}
			sql1= query.getQueryString();
			//ViksitLogger.logMSG(this.getClass().getName(),"finalSql >>"+sql1);
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}				
		
	}

	private static void checkingReportUtils() {
		// TODO Auto-generated method stub
		
		////ViksitLogger.logMSG(this.getClass().getName(),"1>>>"+(new CMSRegistry()).getClass().getClassLoader());
		////ViksitLogger.logMSG(this.getClass().getName(),"2>>>"+(new CMSRegistry()).getClass().getClassLoader().getResource("report_list.xml"));
		ReportUtils utils = new ReportUtils();
		HashMap<String, String> conditions = new HashMap<>();
		
		//ViksitLogger.logMSG(this.getClass().getName(),(utils.getHTML(3052, conditions));;
		
		/*int totalStudent=50;
		int nintyPercent = (int)(.9* totalStudent);		
		//ViksitLogger.logMSG(this.getClass().getName(),nintyPercent);
		
		
		double r = Math.random()*0.8;
		//ViksitLogger.logMSG(this.getClass().getName(),r);*/
	}
}
