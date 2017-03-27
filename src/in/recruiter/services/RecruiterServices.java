/**
 * 
 */
package in.recruiter.services;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import java.util.Random;

import java.util.Set;

import java.util.Properties;
import java.util.UUID;

import javax.mail.Authenticator;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.PasswordAuthentication;
import javax.mail.Transport;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.WordUtils;
import org.apache.commons.lang3.StringUtils.*;
import org.apache.commons.lang.WordUtils.*;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.app.metadata.services.MetadataServices;
import com.istarindia.apps.UserTypes;
import com.istarindia.apps.VacancyStatuses;
import com.istarindia.apps.dao.Address;
import com.istarindia.apps.dao.AddressDAO;
import com.istarindia.apps.dao.Campaigns;
import com.istarindia.apps.dao.CampaignsDAO;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.CollegeRecruiter;
import com.istarindia.apps.dao.Company;
import com.istarindia.apps.dao.CompanyDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarTaskType;
import com.istarindia.apps.dao.IstarTaskTypeDAO;
import com.istarindia.apps.dao.IstarTaskWorkflow;
import com.istarindia.apps.dao.IstarTaskWorkflowDAO;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.JobsEvent;
import com.istarindia.apps.dao.JobsEventDAO;
import com.istarindia.apps.dao.Panelist;
import com.istarindia.apps.dao.PanelistDAO;
import com.istarindia.apps.dao.PanelistFeedback;
import com.istarindia.apps.dao.PanelistFeedbackDAO;
import com.istarindia.apps.dao.PanelistSchedule;
import com.istarindia.apps.dao.PanelistScheduleDAO;
import com.istarindia.apps.dao.Pincode;
import com.istarindia.apps.dao.PincodeDAO;
import com.istarindia.apps.dao.PlacementOfficer;
import com.istarindia.apps.dao.PlacementOfficerDAO;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.RecruiterDAO;
import com.istarindia.apps.dao.Skill;
import com.istarindia.apps.dao.SkillDAO;
import com.istarindia.apps.dao.SkillRating;
import com.istarindia.apps.dao.SkillRatingDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.service.NotificationService;
import com.publisher.utils.PublishDelegator;

import in.orgadmin.utils.RecruiterTypes;
/**
 * This is the service class to serve work flow templates, create new work flow
 * templates.
 * 
 * @author ComplexObject
 *
 */
public class RecruiterServices {

	ArrayList<String> position_types = new ArrayList<>();
	ArrayList<String> experience_levels = new ArrayList<>();
	ArrayList<String> position_categories = new ArrayList<>();
	ArrayList<String> ug_degrees = new ArrayList<String>();
	ArrayList<String> pg_degrees = new ArrayList<String>();
	ArrayList<String> ugEngineeringSpecializations = new ArrayList<String>();
	ArrayList<String> pgEngineeringSpecializations = new ArrayList<String>();
	ArrayList<String> ugScienceSpecializations = new ArrayList<String>();
	ArrayList<String> pgScienceSpecializations = new ArrayList<String>();
	ArrayList<String> ugCommerceSpecializations = new ArrayList<String>();
	ArrayList<String> pgCommerceSpecializations = new ArrayList<String>();
	ArrayList<String> ugBBMSpecializations = new ArrayList<String>();
	ArrayList<String> ugArtSpecializations = new ArrayList<String>();
	ArrayList<String> pgArtSpecializations = new ArrayList<String>();
	ArrayList<String> pgMBASpecializations = new ArrayList<String>();
	
	public RecruiterServices() {
		super();
		getStringFromProperties();
		// TODO Auto-generated constructor stub
	}
	
	public ArrayList<Integer> getDistinctPincode()
	{
		ArrayList<Integer> pincodes= new  ArrayList<Integer>();

		PincodeDAO pincodeDAO = new PincodeDAO();
			List<Pincode> pincode = pincodeDAO.findAll();
         for(Pincode p : pincode)
         {
        	 if(!pincodes.contains(p.getPin()))
        	 {
        		 pincodes.add(p.getPin());
        	 }
         }
		
		return pincodes;
	}

	private void getStringFromProperties() {
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}

			String pos_type = properties.getProperty("position_type");
			String exp_level = properties.getProperty("experience_level");
			String pos_cat = properties.getProperty("position_category");
			String ug_deg = properties.getProperty("ug_degrees");
			String pg_deg = properties.getProperty("pg_degrees");
			String ug_eng_specialization = properties.getProperty("ug_eng_specialization");
			String ug_sci_specialization = properties.getProperty("ug_sci_specialization");
			String ug_com_specialization = properties.getProperty("ug_com_specialization");
			String ug_bbm_specialization = properties.getProperty("ug_bbm_specialization");
			String ug_art_specialization = properties.getProperty("ug_art_specialization");
			String pg_mba_specialization = properties.getProperty("pg_mba_specialization");
			String pg_eng_specialization = properties.getProperty("pg_eng_specialization");
			String pg_sci_specialization = properties.getProperty("pg_sci_specialization");
			String pg_com_specialization = properties.getProperty("pg_com_specialization");
			String pg_art_specialization = properties.getProperty("pg_art_specialization");

			for (String str : pos_type.split("!#")) {
				position_types.add(str);
			}
			for (String str : exp_level.split("!#")) {
				experience_levels.add(str);
			}
			for (String str : pos_cat.split("!#")) {
				position_categories.add(str);
			}
			for (String str : ug_deg.split("!#")) {
				ug_degrees.add(str);
			}
			for (String str : pg_deg.split("!#")) {
				pg_degrees.add(str);
			}
			for (String str : ug_eng_specialization.split("!#")){
				ugEngineeringSpecializations.add(str);
			}
			for (String str : ug_sci_specialization.split("!#")){
				ugScienceSpecializations.add(str);
			}
			for (String str : ug_com_specialization.split("!#")){
				ugCommerceSpecializations.add(str);
			}
			for (String str : ug_bbm_specialization.split("!#")){
				ugBBMSpecializations.add(str);
			}
			for (String str : ug_art_specialization.split("!#")){
				ugArtSpecializations.add(str);
			}
			for (String str : pg_mba_specialization.split("!#")){
				pgMBASpecializations.add(str);
			}
			for (String str : pg_eng_specialization.split("!#")){
				pgEngineeringSpecializations.add(str);
			}
			for (String str : pg_sci_specialization.split("!#")){
				pgScienceSpecializations.add(str);
			}
			for (String str : pg_com_specialization.split("!#")){
				pgCommerceSpecializations.add(str);
			}
			for (String str : pg_art_specialization.split("!#")){
				pgArtSpecializations.add(str);
			}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

	}

	public StringBuffer getVacancyActivityGraph(int recruiter_id)
	{
		DBUTILS util = new DBUTILS();
		String sql ="SELECT DISTINCT vacancy.id, vacancy.profile_title,	COUNT (jobs_event. ID) FROM 	vacancy, 	jobs_event WHERE 	recruiter_id = "+recruiter_id+" AND jobs_event.vacancy_id = vacancy.id  AND vacancy.status='PUBLISHED' GROUP BY vacancy.id,vacancy.profile_title";	
		
		System.out.println(sql);
		List<HashMap<String, Object>> vacancies = util.executeQuery(sql);
		String table_header="<thead><tr><th>Date</th>";
		
		for(HashMap<String, Object> row: vacancies)
		{
			String job_title = (String) row.get("profile_title");
			table_header +="<th>"+job_title+"</th>"; 			
		}
		table_header+="</tr></thead>";
		String table_body="<tbody>";
		String distinct_dates ="select DISTINCT 	cast (CAST (eventdate as date) as varchar(50)) from jobs_event , vacancy where vacancy.id = jobs_event.vacancy_id and vacancy.recruiter_id="+recruiter_id+" order by eventdate";
		System.out.println(distinct_dates);
		for(HashMap<String, Object> dates_row: util.executeQuery(distinct_dates))
		{			
			String date = (String)dates_row.get("eventdate");
			//System.out.println("date-----"+date);
			String tbody_row ="<tr><td>"+date+"</td>";
			for(HashMap<String, Object> row: vacancies)
			{				
					int vac_id = (int) row.get("id");
				
				String activity_per_vacancy="SELECT cast (COUNT (*) as integer) AS activity, jobs_event.status FROM 	jobs_event WHERE 	jobs_event.vacancy_id = "+vac_id+" and 	cast (CAST (eventdate as date) as varchar(50)) like '%"+date+"%' group by jobs_event.status";
				System.out.println(activity_per_vacancy);
				List<HashMap<String, Object>> per_vac_data = util.executeQuery(activity_per_vacancy);	
				if(per_vac_data.size()>0)
				{
					int activity= (int)per_vac_data.get(0).get("activity");
					if(activity==0)
					{
						tbody_row+="<td>0</td>";
					}
					else
					{
						tbody_row+="<td>"+activity+"</td>";
					}	
					
				}
				else
				{
					
				}	
			}
		
			tbody_row+="</tr>"+System.lineSeparator();
			table_body+=tbody_row;	
			
		}
		table_body+="</tbody>";
		
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='table-responsive'> "
				+ "<table class='table table-striped table-bordered display responsive dt-responsive  dataTable datatable_report111111'"
				+ "id='datatable_report_999' data-graph_type='datetime' 			"
				+ "data-graph_title='' data-graph_containter='report_container_999' style='display:none'>");
		sb.append(table_header);
		sb.append(table_body);
		sb.append("</table>");
		sb.append("</div>");
		
		return sb;
	}
	
	
	public List<HashMap<String, Object>> getStudentRatingPerskill(int student_id)
	{
		HashMap<String, String> data = new HashMap<>();
		String sql = "SELECT 	skill.skill_title, skill.id, 	CAST ( 		T .percentile_country AS INTEGER 	) FROM 	skill, 	( 		WITH summary AS ( 			SELECT 				P . ID, 				P .skill_id, 				P .percentile_country, 				ROW_NUMBER () OVER ( 					PARTITION BY P .skill_id 					ORDER BY 						P . TIMESTAMP DESC 				) AS rk 			FROM 				skill_precentile P 			WHERE 				P .student_id = "+student_id+" 		) SELECT 			s.* 		FROM 			summary s 		WHERE 			s.rk = 1 	) T WHERE 	T .skill_id = skill. ID AND skill. ID != 0 AND SKILL.parent_skill = 0 and T.skill_id in (select TTT.id from (WITH RECURSIVE menu_tree ( 	ID, 	skill_title, 	 	LEVEL, 	parent_skill ) AS ( 	SELECT 		ID, 		skill_title, 		0, 		parent_skill 	FROM 		skill 	WHERE 		parent_skill = - 1 	UNION ALL 		SELECT 			mn. ID, 			mn.skill_title, 			mt. LEVEL + 1, 			mt. ID 		FROM 			skill mn, 			menu_tree mt 		WHERE 			mn.parent_skill = mt. ID ) SELECT 	* FROM 	menu_tree WHERE 	LEVEL > 0 ORDER BY 	LEVEL, 	parent_skill ) TTT where TTT.level<=2 )ORDER BY 	T .percentile_country DESC";
		System.out.println(sql);
		DBUTILS utils = new DBUTILS();
		return utils.executeQuery(sql);
	}
	
	
	public List<Skill> getSkills() {
		return new SkillDAO().findAll();
	}

	public ArrayList<String> getUGDegrees() {
		ArrayList<String> deg = ug_degrees;
		Collections.sort(deg.subList(1, deg.size()));
		return deg;
	}

	public ArrayList<String> getPosTypes() {
		ArrayList<String> deg = position_types;
		Collections.sort(deg.subList(1, deg.size()));
		return deg;
	}

	public ArrayList<String> getCategories() {
		ArrayList<String> deg = position_categories;
		Collections.sort(deg.subList(1, deg.size()));
		return deg;
	}

	public ArrayList<String> getExpLevel() {
		ArrayList<String> deg = experience_levels;
		Collections.sort(deg.subList(1, deg.size()));
		return deg;
	}

	public ArrayList<String> getPGDegrees() {
		ArrayList<String> deg = pg_degrees;
		Collections.sort(deg.subList(1, deg.size()));
		return deg;
	}
	
	public ArrayList<String> getUGEngineeringSpecializations(){
		ArrayList<String> allUGEngineeringSpecializations = ugEngineeringSpecializations;
		Collections.sort(allUGEngineeringSpecializations.subList(0, allUGEngineeringSpecializations.size()));
		return allUGEngineeringSpecializations;
	}
	
	public ArrayList<String> getUGScienceSpecializations(){
		ArrayList<String> allUGScienceSpecializations = ugScienceSpecializations;
		Collections.sort(allUGScienceSpecializations.subList(0, allUGScienceSpecializations.size()));
		return allUGScienceSpecializations;
	}
	
	public ArrayList<String> getUGCommerceSpecializations(){
		ArrayList<String> allUGCommerceSpecializations = ugCommerceSpecializations;
		Collections.sort(allUGCommerceSpecializations.subList(0, allUGCommerceSpecializations.size()));
		return allUGCommerceSpecializations;
	}
	
	public ArrayList<String> getUGBBMSpecializations(){
		ArrayList<String> allUGBBMSpecializations = ugBBMSpecializations;
		Collections.sort(allUGBBMSpecializations.subList(0, allUGBBMSpecializations.size()));
		return allUGBBMSpecializations;
	}
	public ArrayList<String> getUGArtSpecializations(){
		ArrayList<String> allUGArtpecializations = ugArtSpecializations;
		Collections.sort(allUGArtpecializations.subList(1, allUGArtpecializations.size()));
		return allUGArtpecializations;
	}
	public ArrayList<String> getPGMBASpecializations(){
		ArrayList<String> allPGMBASpecializations = pgMBASpecializations;
		Collections.sort(allPGMBASpecializations.subList(1, allPGMBASpecializations.size()));
		return allPGMBASpecializations;
	}
	public ArrayList<String> getPGEngineeringSpecializations(){
		ArrayList<String> allPGEngineeringSpecializations = pgEngineeringSpecializations;
		Collections.sort(allPGEngineeringSpecializations.subList(1, allPGEngineeringSpecializations.size()));
		return allPGEngineeringSpecializations;
	}	
	public ArrayList<String> getPGScienceSpecializations(){
		ArrayList<String> allPGScienceSpecializations = pgScienceSpecializations;
		Collections.sort(allPGScienceSpecializations.subList(1, allPGScienceSpecializations.size()));
		return allPGScienceSpecializations;
	}
	
	public ArrayList<String> getPGCommerceSpecializations(){
		ArrayList<String> allPGCommerceSpecializations = pgCommerceSpecializations;
		Collections.sort(allPGCommerceSpecializations.subList(0, allPGCommerceSpecializations.size()));
		return allPGCommerceSpecializations;
	}
	public ArrayList<String> getPGArtSpecializations(){
		ArrayList<String> allPGArtpecializations = pgArtSpecializations;
		Collections.sort(allPGArtpecializations.subList(1, allPGArtpecializations.size()));
		return allPGArtpecializations;
	}
	

	public List<College> getCollegesForRecruiter(Recruiter rec) {
		List<College> colleges = new ArrayList<>();
		if (rec.getRecruiterType().equalsIgnoreCase(RecruiterTypes.NORMAL)) {
			for (CollegeRecruiter cr : rec.getCollegeRecruiters()) {
				colleges.add(cr.getCollege());
			}
		} else {
			colleges.addAll(new CollegeDAO().findAll());
		}

		Collections.sort(colleges, new Comparator<College>() {
			@Override
			public int compare(College one, College other) {
				return one.getName().compareTo(other.getName());
			}
		});
		return colleges;
	}

	public ArrayList<String> getCitiesName() {
		ArrayList<String> cities = new ArrayList<>();
		List<Pincode> pins = new PincodeDAO().findAll();
		for (Pincode p : pins) {
			if (!cities.contains(p.getCity().toLowerCase())) {
				cities.add(p.getCity().toLowerCase());
			}
		}
		
		ArrayList<String> allCities = new ArrayList<String>();
		
		for(String cityName:cities){
			allCities.add(WordUtils.capitalize(cityName));
		}
		Collections.sort(cities.subList(1, cities.size()));
		return allCities;
	}

	public HashMap<Integer, Student> getAllStudentsForRecruiter(Recruiter rec) {
		HashMap<Integer, Student> students = new HashMap<Integer, Student>();
		if (rec.getRecruiterType().equalsIgnoreCase(RecruiterTypes.NORMAL)) {
			// recruiter will see only students of college he belongs to.
			for (CollegeRecruiter rc : rec.getCollegeRecruiters()) {
				for (Student st : rc.getCollege().getStudents()) {
					if (st.getUserType().equalsIgnoreCase("STUDENT")) {
						students.put(st.getId(), st);
					}
				}
			}
		} else {
			// he will be able to see all students of college.
			List<College> colleges = new CollegeDAO().findAll();
			for (College c : colleges) {
				for (Student st : c.getStudents()) {
					if (st.getUserType().equalsIgnoreCase("STUDENT")) {
						students.put(st.getId(), st);
					}
				}
			}
		}
		return students;
	}
	
	public ArrayList<Student> getAllStudentsForRecruiterPaginated(Recruiter rec) {
		ArrayList<Student> students = new ArrayList<Student>();
		if (rec.getRecruiterType().equalsIgnoreCase(RecruiterTypes.NORMAL)) {
			// recruiter will see only students of college he belongs to.
			for (CollegeRecruiter rc : rec.getCollegeRecruiters()) {
				for (Student st : rc.getCollege().getStudents()) {
					if (st.getUserType().equalsIgnoreCase("STUDENT")) {
						students.add(st);
					}
				}
			}
		} else {
			// he will be able to see all students of college.
			List<College> colleges = new CollegeDAO().findAll();
			for (College c : colleges) {
				for (Student st : c.getStudents()) {
					if (st.getUserType().equalsIgnoreCase("STUDENT")) {
						students.add(st);
					}
				}
			}
		}
		return students;
	}

	public void mapActionWithStages(HashMap<String, String> stage_action_mapping) {
		for (String stage_id : stage_action_mapping.keySet()) {
			IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stage_id));
		}

	}

	/**
	 * This method creates and return the Recruiter.
	 * 
	 * @param companyId
	 *            int value of company id
	 * @param email
	 *            String value of email.
	 * @param gender
	 *            String value od gender
	 * @param mobile
	 *            Long value of mobile
	 * @param name
	 *            String value of name of recruiter
	 * @return Recruiter object.
	 */
	public Recruiter createRecruiter(int companyId, String email, String gender, Long mobile, String name) {
		Company comp = new CompanyDAO().findById(companyId);
		Address add = comp.getAddress();
		Recruiter rec = new Recruiter();
		rec.setAddress(add);
		rec.setCompany(comp);
		rec.setEmail(email);
		rec.setGender(gender);
		rec.setIstarAuthorizationToken("dddd");
		rec.setIsVerified(true);
		rec.setMobile(mobile);
		rec.setName(name);
		String password = RandomStringUtils.randomAlphanumeric(6);
		rec.setPassword(password);
		rec.setRecruiterType(RecruiterTypes.NORMAL);
		rec.setTokenExpired(true);
		rec.setTokenVerified("dddd");
		rec.setUserType(UserTypes.RECRUITER);
		RecruiterDAO dao = new RecruiterDAO();
		Session session = dao.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.save(rec);
			tx.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

		String details = "Current Password is " + password + ".";
		String subject = "Welcome to Istar Job Portal.";
		new Thread(new Runnable() {
			@Override
			public void run() {
				// do stuff here
			}
		}).start();

		return rec;
	}

	/**
	 * IstarTaskType is a work flow which consists of stages and order of
	 * stages.
	 * 
	 * @return This method will return a list of all predefined work flow
	 *         templates related to jobs that can be used directly instead of
	 *         creating new work flow.
	 */
	public List<IstarTaskType> getAllWorkFlowTemplate() {
		IstarTaskTypeDAO dao = new IstarTaskTypeDAO();
		return dao.findByTaskCategory("JOB");
	}

	/**
	 * @param companyId
	 *            int vale of company id.
	 * @return This method will return a list of all predefined work flow
	 *         templates related to jobs defined by company that can be used
	 *         directly instead of creating new work flow.
	 */
	public List<IstarTaskType> getCompanyWorkFlowTemplate(int companyId) {
		IstarTaskTypeDAO dao = new IstarTaskTypeDAO();
		return dao.findByOwnerOrganization(companyId);
	}

	/**
	 * @return This method will return a list of all open predefined work flow
	 *         templates related to jobs that can be used directly instead of
	 *         creating new work flow.
	 */
	public List<IstarTaskType> getOpenWorkFlowTemplate() {
		IstarTaskTypeDAO dao = new IstarTaskTypeDAO();
		return dao.findByIsOpen(true);
	}

	/**
	 * 
	 * This method creates a new work flow.
	 * 
	 * @param workflow_category
	 *            type of work flow (eg: "JOB").
	 * @param name
	 *            name of the work flow (eg: "ISTAR_JOB_TASK").
	 * @param owner_organization
	 *            integer id of the organization for which the work flow is
	 *            being getting created.
	 * @param change_level
	 *            Based on change level work flow can be edited. Access Level
	 *            can be (CANNOT_CHANGED, RESTRICT_CHANGE, CASCADE_CHANGE).
	 *            CANNOT_CHANGED: means work flow cannot be changed.
	 *            RESTRICT_CHANGE: means work flow can only be changed if there
	 *            is no vacancy associated with it. CASCADE_CHANGE: means work
	 *            flow can be changed but it will delete all the vacancy and
	 *            other dependency associated with it.
	 * @param stages
	 *            List of HashMap of stages. Each stage will have a 'stage_name'
	 *            and 'order' as key.
	 * @return Returns the newly created work flow.
	 */

	public IstarTaskType createNewWorkflow(String workflow_category, String name, Integer owner_organization,
			String change_level, List<HashMap<String, String>> stages, List<HashMap<String, String>> stage_actions, boolean is_open, Vacancy vacancy) {
		
		
		IstarTaskType workflow = new IstarTaskType();
		IstarTaskTypeDAO dao = new IstarTaskTypeDAO();
		workflow.setType(name);
		workflow.setTaskCategory(workflow_category);
		workflow.setIsOpen(is_open);
		workflow.setOwnerOrganization(owner_organization);
		workflow.setChangeLevel(change_level);
		//if (dao.findByExample(workflow).size() == 0) {
			Session session = dao.getSession();
			Transaction tx = null;
			try {
				tx = session.beginTransaction();
				session.save(workflow);
				
				tx.commit();
			} catch (HibernateException e) {
				e.printStackTrace();
				if (tx != null)
					tx.rollback();
				e.printStackTrace();
			} finally {
				session.close();
			}
			
		
			createStages(  workflow, stages,  stage_actions,vacancy);

		return workflow;
	}


	private void createStages(IstarTaskType workflow, List<HashMap<String, String>> stages,
			List<HashMap<String, String>> stage_actions, Vacancy vacancy) {
		// TODO Auto-generated method stub
		IstarTaskWorkflow target = new IstarTaskWorkflow();
		IstarTaskWorkflowDAO tagetdao = new IstarTaskWorkflowDAO();
		target.setIstarTaskType(workflow);
		target.setOrderId(1);
		target.setStage("TARGETED");

			Session targetsession1 = tagetdao.getSession();
			Transaction targettx1 = null;
			try {
				targettx1 = targetsession1.beginTransaction();
				targetsession1.save(target);
				;
				targettx1.commit();
			} catch (HibernateException e) {
				e.printStackTrace();
				if (targettx1 != null)
					targettx1.rollback();
				e.printStackTrace();
			} finally {
				targetsession1.close();
			}
		
		updateStageAction(target, "TARGETED", "Invited");	
			
		IstarTaskWorkflow appliedStage = new IstarTaskWorkflow();
		IstarTaskWorkflowDAO appliedStageDAO = new IstarTaskWorkflowDAO();
		appliedStage.setIstarTaskType(workflow);
		appliedStage.setOrderId(2);
		appliedStage.setStage("Applied");
		
		Session appliedStageSession = appliedStageDAO.getSession();
		Transaction appliedStageTranscation = null;
		try {
			appliedStageTranscation = appliedStageSession.beginTransaction();
			appliedStageSession.save(appliedStage);
			appliedStageTranscation.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (appliedStageTranscation != null)
				appliedStageTranscation.rollback();
			e.printStackTrace();
		} finally {
			appliedStageSession.close();
		}
	
	updateStageAction(appliedStage, "Applied", "Applied");		
		
		int stage_count=0;
		int order_id = 0;
		for (HashMap<String, String> stage : stages) {
			String stage_name = stage.get("stage_name").trim();
			System.out.println("ORDER ID from Frontend: " + stage.get("order"));
			order_id = Integer.parseInt(stage.get("order"));
			IstarTaskWorkflow itw = new IstarTaskWorkflow();
			IstarTaskWorkflowDAO d = new IstarTaskWorkflowDAO();
			itw.setIstarTaskType(workflow);
			itw.setOrderId(order_id+2);
			itw.setStage(stage_name);
			
				Session session1 = d.getSession();
				Transaction tx1 = null;
				try {
					tx1 = session1.beginTransaction();
					session1.save(itw);
					;
					tx1.commit();
				} catch (HibernateException e) {
					e.printStackTrace();
					if (tx1 != null)
						tx1.rollback();
					e.printStackTrace();
				} finally {
					session1.close();
				}
			
			HashMap<String, String> stage_action = stage_actions.get(stage_count);
			String action=stage_action.get("action");
			
			String stage_type=  stage_action.get("stage_type");
			
			if(stage_type.equalsIgnoreCase("interview"))
			{
				String panelist_emails[]= action.split(",");
				IstarUserDAO userdao = new IstarUserDAO();
				for(String emails : panelist_emails)
				{
					List<IstarUser> users = userdao.findByEmail(emails);
					if(users.size()>0)
					{
						IstarUser panelist = users.get(0);
						if(panelist.getUserType().equalsIgnoreCase("PANELIST")){
						updateVacancyPanelist(vacancy.getId(),panelist.getId(),vacancy.getRecruiter().getId());
						}else{
							System.out.println("The user already exists as " + panelist.getUserType() +", hence cannot be added as a PANELIST");
						}
					}
					else
					{
						Panelist panelist = createPanenlist(emails,"Panelist",vacancy);
						updateVacancyPanelist(vacancy.getId(),panelist.getId(),vacancy.getRecruiter().getId());
					}	
				}				
			}
			updateStageAction(itw, action, stage_type);
			stage_count++;
		}
		
		
		//This block of code is to insert a default last Offered Stage apart from the stages manually entered by the user (recruiter) 
		int lastOrderId = order_id+3; //to be tested further
		
		IstarTaskWorkflowDAO offeredPositionDAO = new IstarTaskWorkflowDAO();
		IstarTaskWorkflow offeredPosition = new IstarTaskWorkflow();
		offeredPosition.setIstarTaskType(workflow);
		offeredPosition.setOrderId(lastOrderId);
		offeredPosition.setStage("Offered");

			Session offeredPositionSession = offeredPositionDAO.getSession();
			Transaction offeredPositionTranscation = null;
			try {
				offeredPositionTranscation = offeredPositionSession.beginTransaction();
				offeredPositionSession.save(offeredPosition);
				offeredPositionTranscation.commit();
			} catch (HibernateException e) {
				e.printStackTrace();
				if (offeredPositionTranscation != null)
					offeredPositionTranscation.rollback();
				e.printStackTrace();
			} finally {
				offeredPositionSession.close();
			}
		
		updateStageAction(offeredPosition, "Offered", "Offered");		
	}

	

	private void updateStageAction(IstarTaskWorkflow itw, String action, String stage_type) {
		System.out.println("from CREATE_STAGES METHOD: StageAction" + action + "------- Type=" +stage_type);
		DBUTILS util = new DBUTILS();  
		String sql = "select id from stage_action_mapping where cast (stage_id as varchar) like '%"+itw.getId().toString()+"%' limit 1";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		if(data.size()>0)
		{
			//update				
			int id = (int) data.get(0).get("id");
			sql = "update stage_action_mapping set stage_id='"+itw.getId().toString()+"' , type ='"+stage_type+"' , stage_action='"+action+"' where id="+id;
			util.executeUpdate(sql);
		}
		else
		{
			sql = "insert into stage_action_mapping (id,stage_id, stage_action, type) values((select coalesce(max(id)+1, 0) from stage_action_mapping), '"+itw.getId().toString()+"', '"+action+"', '"+stage_type+"')";
			util.executeUpdate(sql);
		}	
		
	}

	public  int getRandomInteger(int maximum, int minimum){ return ((int) (Math.random()*(maximum - minimum))) + minimum; }

	public  Panelist createPanenlist(String email, String name, Vacancy v) {
		
		Panelist p = new Panelist();
		PanelistDAO dao = new PanelistDAO();
		p.setAddress(v.getCompany().getAddress());
		p.setCompany(v.getCompany());
		p.setEmail(email);
		p.setGender("male");
		p.setIstarAuthorizationToken("token");
		p.setIsVerified(true);
		p.setMobile(new Long(999999999));
		p.setName(name!=null?name:"Guest");
		String pwd = getRandomInteger(100000, 999999)+"";
		p.setPassword(pwd);
		p.setTokenExpired(false);
		p.setTokenVerified("asd");
		p.setUserType("PANELIST");
		Session session1 = dao.getSession();
		Transaction tx1 = null;
		try {
			tx1 = session1.beginTransaction();
			session1.save(p);
			;
			tx1.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (tx1 != null)
				tx1.rollback();
			e.printStackTrace();
		} finally {
			session1.flush();
			session1.close();
		}
		
		if(p!=null)
		{
			sendInviteMail(p.getEmail(), p.getName(), p.getPassword());
			
		}
		
		
		
		return p;
	}

	public void sendInviteMail(String email, String name, String password) {
		
		String subject="Welcome to Talentify";
		
		

	    
	String message = "Hi " + name + ", Your user id is: " + email
	+ " and password is "+password;
	
	 Runnable mailThread =	new Runnable() {
			@Override
			public void run() {
				sendEmail(email, subject, message);
				System.out.println("Starting Thread for sending mail");
			}
		};
		
		mailThread.run();
	}

	public  void sendEmail(String emailTo, String subject, String message)
	{

		try {
			String senderEmail = "vaibhav@istarindia.com";
			String senderPassword = "U6Zt0CrZBDnKvnHTNl2EKA";

			// sets SMTP server properties
			Properties properties = new Properties();
			properties.put("mail.smtp.host", "smtp.mandrillapp.com");
			properties.put("mail.smtp.port", "587");
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.starttls.enable", "false");

			// creates a new session with an authenticator
			Authenticator auth = new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(senderEmail, senderPassword);
				}
			};

			// Create transport session
			javax.mail.Session session = javax.mail.Session.getInstance(properties, auth);
			InternetAddress[] iAdressArray = InternetAddress.parse(emailTo);

			// creates a new e-mail message
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(senderEmail));
			msg.setRecipients(Message.RecipientType.TO, iAdressArray);
			msg.setSubject(subject);
			msg.setSentDate(new Date());
			
			msg.setContent(message, "text/html; charset=utf-8");

			// sends the e-mail
			Transport.send(msg);
			System.out.println("sending");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	public void updateVacancyPanelist(int vacancy_id, Integer panelist_id, Integer recruiter_id) {
		// TODO Auto-generated method stub
		String sql_check = "select * from vacancy_panelist where vacancy_id="+vacancy_id+" and panelist_id="+panelist_id+";";
		DBUTILS util = new DBUTILS();
		if(util.executeQuery(sql_check).size()==0)
		{
			String insert_sql="insert into vacancy_panelist (id,vacancy_id,panelist_id) values((select coalesce(max(id)+1, 0) from vacancy_panelist),"+vacancy_id+", "+panelist_id+")";
			util.executeUpdate(insert_sql);
		}
		
		String sql_rec_panelist_check=" select * from recruiter_panelist_mapping where recruiter_id="+recruiter_id+" and panelist_id="+panelist_id+";";
		if(util.executeQuery(sql_rec_panelist_check).size()==0)
		{
			String insert_rec_pan ="insert into recruiter_panelist_mapping (id,recruiter_id,panelist_id ) values ((select coalesce(max(id)+1, 0) from recruiter_panelist_mapping),"+recruiter_id+","+panelist_id+");";
			util.executeUpdate(insert_rec_pan);
		}
		
	}

	/**
	 * This method update the work flow for a job. Using this method ordering of
	 * stages and addition of new stages can be done.
	 * 
	 * 
	 * @param workflow
	 *            work flow id for which modification is needed.
	 * @param workflow_category
	 *            category of work flow ( eg: "JOBS")
	 * @param name
	 *            name of work flow
	 * @param stages
	 *            List of HashMap of stages. Each stage will have a 'stage_name'
	 *            and 'order' as key.
	 * @param stage_actions 
	 * @return returns the updated work flow.
	 */
	public IstarTaskType updateWorkflow(IstarTaskType workflow, String workflow_category, String name,
			List<HashMap<String, String>> stages, List<HashMap<String, String>> stage_actions) {

		if (workflow.getChangeLevel().equalsIgnoreCase("CASCADE_CHANGE")) {
			updateBasicWorkFlowDeatils(workflow, workflow_category, name, stages);
			/*
			 * deleting old stages
			 */
			deleteOldStages(workflow, workflow_category, name, stages);
			/*
			 * deleting all dependent data and vacancies
			 */
			deleteAllVacancy(workflow, workflow_category, name, stages);
			/*
			 * adding new stages
			 */
			addNewStages(workflow, workflow_category, name, stages);
		} 
		else if (workflow.getChangeLevel().equalsIgnoreCase("RESTRICT_CHANGE")) {
			if (workflow.getVacancies().size() == 0) {
				updateBasicWorkFlowDeatils(workflow, workflow_category, name, stages);
				deleteOldStages(workflow, workflow_category, name, stages);
				addNewStages(workflow, workflow_category, name, stages);
			}
		}
		return workflow;
	}

	private void addNewStages(IstarTaskType workflow, String workflow_category, String name,
			List<HashMap<String, String>> stages) {
		for (HashMap<String, String> stage : stages) {
			String stage_name = stage.get("stage_name").trim();
			int order_id = Integer.parseInt(stage.get("order"));
			IstarTaskWorkflow itw = new IstarTaskWorkflow();
			IstarTaskWorkflowDAO d = new IstarTaskWorkflowDAO();
			itw.setIstarTaskType(workflow);
			itw.setOrderId(order_id);
			itw.setStage(stage_name);

			if (d.findByExample(itw).size() == 0) {
				Session session_dd = d.getSession();
				Transaction tx_dd = null;
				try {
					tx_dd = session_dd.beginTransaction();
					session_dd.save(itw);
					;
					tx_dd.commit();
				} catch (HibernateException e) {
					e.printStackTrace();
					if (tx_dd != null)
						tx_dd.rollback();
					e.printStackTrace();
				} finally {
					session_dd.close();
				}
			}
		}
	}

	private void deleteAllVacancy(IstarTaskType workflow, String workflow_category, String name,
			List<HashMap<String, String>> stages) {
		List<Vacancy> vacancies = new VacancyDAO().findByProperty("istarTaskType", workflow);
		for (Vacancy vacancy : vacancies) {
			VacancyDAO vd = new VacancyDAO();

			//System.out.println("deleting vacancy");
			vd.delete(vacancy);
			Session svd = vd.getSession();
			Transaction tx_vd = null;
			try {
				tx_vd = svd.beginTransaction();
				svd.delete(vacancy);
				tx_vd.commit();
			} catch (HibernateException e) {
				e.printStackTrace();
				if (tx_vd != null)
					tx_vd.rollback();
				e.printStackTrace();
			} finally {
				svd.close();
			}
		}
	}

	private void deleteOldStages(IstarTaskType workflow, String workflow_category, String name,
			List<HashMap<String, String>> stages) {
		for (IstarTaskWorkflow stage : workflow.getIstarTaskWorkflows()) {
			IstarTaskWorkflowDAO d = new IstarTaskWorkflowDAO();
			Session session_d = d.getSession();
			Transaction tx_d = null;
			try {
				tx_d = session_d.beginTransaction();
				session_d.delete(stage);
				tx_d.commit();
			} catch (HibernateException e) {
				e.printStackTrace();
				if (tx_d != null)
					tx_d.rollback();
				e.printStackTrace();
			} finally {
				session_d.close();
			}
		}
	}

	private void updateBasicWorkFlowDeatils(IstarTaskType workflow, String workflow_category, String name,
			List<HashMap<String, String>> stages) {
		IstarTaskTypeDAO dao = new IstarTaskTypeDAO();
		workflow.setType(name);
		workflow.setTaskCategory(workflow_category);

		Session session = dao.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.saveOrUpdate(workflow);
			tx.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

	}

	/**
	 * Creates and return a vacancy
	 * 
	 * @param workflow
	 *            work flow id (istar task type)
	 * @param job_title
	 *            Title of the job
	 * @param location
	 *            Location of job
	 * @param description
	 *            Job description
	 * @param recruiter_id
	 *            Recruiter id
	 * @param min_exp
	 *            Minimum experience required
	 * @param max_exp
	 *            Maximum experience required
	 * @param available_positions
	 *            Available positions
	 * @param minSalary
	 *            Minimum Salary
	 * @param maxSalary
	 *            Maximum salary
	 * @return returns newly created Vacancy
	 */
	public Vacancy createVacancy(String job_title, String location, String description,
			int recruiter_id,  int available_positions, String category, String position_type, String experience_level, String minSalary, String maxSalary) {
		
		System.out.println("inside create vacancy");
		
		Vacancy vacany = new Vacancy();
		VacancyDAO dao = new VacancyDAO();
		vacany.setDescription(description);
		vacany.setLocation(location);
		vacany.setProfileTitle(job_title);
		vacany.setIstarTaskType(new IstarTaskTypeDAO().findByType("DEFAULT_VACANCY_WORKFLOW").get(0));
		Recruiter recruiter = new RecruiterDAO().findById(recruiter_id);
		vacany.setRecruiter(recruiter);
		vacany.setCompany(recruiter.getCompany());
		vacany.setOffer_letter("OFFER_LETTER");
		vacany.setTotalPositions(available_positions);
		vacany.setAvailablePositions(available_positions);
		vacany.setVacancyCode(UUID.randomUUID().toString());
		vacany.setStatus(VacancyStatuses.SAVED);
		Session vacanySession = dao.getSession();
		Transaction addtx = null;
		try {
			addtx = vacanySession.beginTransaction();
			dao.save(vacany);
			addtx.commit();
		} catch (HibernateException e) {
			if (addtx != null)
				addtx.rollback();
			e.printStackTrace();
		} finally {
			vacanySession.close();
		}

		
		MetadataServices serv = new MetadataServices();
		serv.saveVacancyProfile(vacany.getId(), "", "", "", "",new HashMap<>(), "",category,position_type ,experience_level,minSalary+"", maxSalary+"");		
		return vacany;
	}

	/**
	 * Update a vacancy
	 * 
	 * @param vacancy_id
	 *            vacancy_id
	 * @param workflow
	 *            work flow id (istar task type)
	 * @param job_title
	 *            Title of the job
	 * @param location
	 *            Location of job
	 * @param description
	 *            Job description
	 * @param recruiter_id
	 *            Recruiter id
	 * @param min_exp
	 *            Minimum experience required
	 * @param max_exp
	 *            Maximum experience required
	 * @param available_positions
	 *            Available positions
	 * @param minSalary
	 *            Minimum Salary
	 * @param maxSalary
	 *            Maximum salary
	 * @return returns newly created Vacancy
	 */
	public Vacancy updateVacancy(int vacancy_id, String job_title, String location,
			String description, int recruiter_id,  int available_positions, String category, String position_type, String experience_level, String minSalary, String maxSalary) {

		System.out.println("inside update vacancy");
		VacancyDAO dao = new VacancyDAO();
		Vacancy vacany = dao.findById(vacancy_id);
		vacany.setDescription(description);
		vacany.setLocation(location);
		
		vacany.setProfileTitle(job_title);		
		Recruiter recruiter = new RecruiterDAO().findById(recruiter_id);
		vacany.setRecruiter(recruiter);
		vacany.setCompany(recruiter.getCompany());
		vacany.setOffer_letter("OFFER_LETTER");
		vacany.setAvailablePositions(available_positions);		
		Session vacanySession = dao.getSession();
		Transaction addtx = null;
		try {
			addtx = vacanySession.beginTransaction();
			dao.attachDirty(vacany);
			addtx.commit();
		} catch (HibernateException e) {
			if (addtx != null)
				addtx.rollback();
			e.printStackTrace();
		} finally {
			vacanySession.close();
		}
		
		
		MetadataServices serv = new MetadataServices();
		serv.saveVacancyProfile(vacany.getId(), "", "", "", "",new HashMap<>(), "",category,position_type ,experience_level,minSalary+"", maxSalary+"");
		
		return vacany;
	}

	/**
	 * Creates and return Company
	 * 
	 * @param addressline1
	 *            address line1
	 * @param addressline2
	 *            address line2
	 * @param state
	 *            state
	 * @param city
	 *            city
	 * @param country
	 *            country
	 * @param pin
	 *            pin
	 * @param company_name
	 *            company_name(eg: Istar Skill Development)
	 * @param industry_type
	 *            industry_type( eg: Information Technology, Services etc )
	 * @param profile
	 *            company profile
	 * @param image_url
	 *            Image Url
	 * @return returns created company
	 */
	public Company createCompany(String addressline1, String addressline2, String state, String city, String country,
			int pin, String company_name, String industry_type, String profile, String image_url) {
		PincodeDAO pincodeDAO = new PincodeDAO();
		List<Pincode> pincode_list = pincodeDAO.findByPin(pin);

		Pincode p = new Pincode();
		if (pincode_list.size() > 0 && pincode_list.get(0).getId() != null) {
			p = pincode_list.get(0);
		} else {
			p.setCity(city);
			p.setCountry(country);
			p.setState(state);
			p.setPin(pin);
			Session pinsession = pincodeDAO.getSession();
			Transaction addtx = null;
			try {
				addtx = pinsession.beginTransaction();
				pincodeDAO.save(p);
				addtx.commit();
			} catch (HibernateException e) {
				if (addtx != null)
					addtx.rollback();
				e.printStackTrace();
			} finally {
				pinsession.close();
			}
		}

		Address address = new Address();
		address.setAddressline1(addressline1);
		address.setAddressline2(addressline2);
		address.setPincode(p);
		AddressDAO adddao = new AddressDAO();
		Session addsession = adddao.getSession();
		Transaction addtx = null;
		try {
			addtx = addsession.beginTransaction();
			adddao.save(address);
			addtx.commit();
		} catch (HibernateException e) {
			if (addtx != null)
				addtx.rollback();
			e.printStackTrace();
		} finally {
			addsession.close();
		}

		Company c = new Company();
		CompanyDAO companydao = new CompanyDAO();
		c.setAddress(address);
		c.setCompany_profile(profile);
		c.setImage("not_available");
		if (image_url != null && image_url != "") {
			c.setImage(image_url);
		}
		c.setIndustry(industry_type);
		c.setMaxStudents(9999);
		c.setName(company_name);
		c.setOrgType("COMPANY");
		Session session = companydao.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			companydao.save(c);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return c;
	}

	/**
	 * Update a Company
	 * 
	 * @param company_id
	 *            company id
	 * @param addressline1
	 *            address line1
	 * @param addressline2
	 *            address line2
	 * @param state
	 *            state
	 * @param city
	 *            city
	 * @param country
	 *            country
	 * @param pin
	 *            pin
	 * @param company_name
	 *            company_name(eg: Istar Skill Development)
	 * @param industry_type
	 *            industry_type( eg: Information Technology, Services etc )
	 * @param profile
	 *            company profile
	 * @param image_url
	 *            Image Url
	 * @return returns updated company
	 */
	public Company updateCompany(int company_id, String addressline1, String addressline2, String state, String city,
			String country, int pin, String company_name, String industry_type, String profile, String image_url) {

		Company c = new CompanyDAO().findById(company_id);

		PincodeDAO pincodeDAO = new PincodeDAO();
		List<Pincode> pincode_list = pincodeDAO.findByPin(pin);

		Pincode p = new Pincode();
		if (pincode_list.size() > 0 && pincode_list.get(0).getId() != null) {
			p = pincode_list.get(0);
		} else {
			p.setCity(city);
			p.setCountry(country);
			p.setState(state);
			p.setPin(pin);
			Session pinsession = pincodeDAO.getSession();
			Transaction addtx = null;
			try {
				addtx = pinsession.beginTransaction();
				pincodeDAO.save(p);
				addtx.commit();
			} catch (HibernateException e) {
				if (addtx != null)
					addtx.rollback();
				e.printStackTrace();
			} finally {
				pinsession.close();
			}
		}

		Address address = c.getAddress();
		address.setAddressline1(addressline1);
		address.setAddressline2(addressline2);
		address.setPincode(p);
		AddressDAO adddao = new AddressDAO();
		Session addsession = adddao.getSession();
		Transaction addtx = null;
		try {
			addtx = addsession.beginTransaction();
			adddao.attachDirty(address);
			;
			addtx.commit();
		} catch (HibernateException e) {
			if (addtx != null)
				addtx.rollback();
			e.printStackTrace();
		} finally {
			addsession.close();
		}

		CompanyDAO companydao = new CompanyDAO();
		c.setAddress(address);
		c.setCompany_profile(profile);
		c.setImage("not_available");
		if (image_url != null && image_url != "") {
			c.setImage(image_url);
		}
		c.setIndustry(industry_type);
		c.setMaxStudents(9999);
		c.setName(company_name);
		c.setOrgType("COMPANY");
		Session session = companydao.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			companydao.attachDirty(c);
			;
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

		return c;
	}

	/**
	 * This method gets all the Vacancy from a Company (company_id)
	 * 
	 * @param company_id
	 *            The reference Id of the company for which Vacancy(s) has to be
	 *            retrieved
	 * @return List<Vacancy> The List of Vacancy(s) based upon company_id
	 */
	public List<Vacancy> getAllVacancyByCompany(int company_id) {

		CompanyDAO companyDAO = new CompanyDAO();
		Company company = companyDAO.findById(company_id);

		VacancyDAO vacancyDAO = new VacancyDAO();
		List<Vacancy> vacancies = vacancyDAO.findByProperty("company_id", company.getId());

		return vacancies;
	}

	/**
	 * This method gets all the Students from a College (college_id).
	 * 
	 * @param college_id
	 *            The reference Id of the college for which the Student(s) has
	 *            to be retrieved
	 * @return List<Student> The List of Student(s) based upon college_id
	 */
	public List<Student> getAllStudentsByCollege(int college_id) {

		CollegeDAO collegeDAO = new CollegeDAO();
		College college = collegeDAO.findById(college_id);

		StudentDAO studentDAO = new StudentDAO();
		List<Student> students = studentDAO.findByProperty("college", college);

		return students;
	}


	/**
	 * This method will create JobsEvents for all students of a college. This
	 * method assigns the specified Vacancy (vacancy_id) to all students for a
	 * college (college_id). This method does not return any object. This method
	 * calls the
	 * {@link #createJobsEventForEachStudent(Date, int, int, int, int, String, String, Student)
	 * createJobsEventForEachStudent} method for each Student.
	 * 
	 * @param eventDate
	 *            The time at which the job event will occur
	 * @param eventHour
	 *            The duration in hours of the event
	 * @param eventMinutes
	 *            The duration in minutes of the event
	 * @param creatorID
	 *            The reference Id of the Student (Creator is Admin but as
	 *            default assigning Student)
	 * @param vacancy_id
	 *            The reference Id of the Vacancy for which the job event will
	 *            be created
	 * @param task_id
	 *            The reference Id of the Task i.e. task is ISTAR_JOB_TASK
	 * @param college_id
	 *            The reference Id of the College for which the JobsEvent is to
	 *            be created based upon the vacancy
	 */
	public void createJobsEvents(Date eventDate, int eventHour, int eventMinutes, int creatorID, int vacancy_id,
			String task_id, List<Student> students) {

		if(students.size() > 0){
		String jobStage = "TARGETED";
		
		VacancyDAO vacancyDAO = new VacancyDAO();
		Vacancy vacancy = vacancyDAO.findById(vacancy_id);
		
		
		int senderId = creatorID;
		String notificationMessage = "You have been shortlisted for " + vacancy.getProfileTitle() + " job position at " + vacancy.getCompany().getName();
		String notificationSubject = " Job invitation from " + vacancy.getCompany().getName();
		String notificationType = "JOBS";
		String notificationAction = "No Action Required";
		String hiddenID = "No Session";
		ArrayList<String>allReceiverIds = new ArrayList<String>();

		for (Student student : students) {
			if (jobStage != null) {
		JobsEvent jobsEvent = createJobsEventForEachStudent(eventDate, eventHour, eventMinutes, creatorID, vacancy_id, task_id,
						jobStage, student);
				
		allReceiverIds.add(student.getId().toString());
		NotificationService service = new NotificationService();
				
		System.out.println("Sending Notification to Targeted students");
		service.createNONEventBasedNotification(notificationMessage, student.getId(), senderId,
								notificationSubject, notificationType, notificationAction);
			}
		}
		
		PublishDelegator pd = new PublishDelegator();
		pd.publishAfterCreatingNotification(allReceiverIds, notificationSubject, notificationMessage, hiddenID);				
		System.out.println("Notification Sent to All Targeted students");
		}else{
			System.out.println("No Students targeted");
		}
	}

	/**
	 * This method will create a JobsEvent for each student. This method assigns
	 * the specified Vacancy (vacancy_id) to each Student (student).
	 * 
	 * @param eventDate
	 *            The time at which the job event will occur
	 * @param eventHour
	 *            The duration in hours of the event
	 * @param eventMinutes
	 *            The duration in minutes of the event
	 * @param creatorID
	 *            The reference Id of the ..........
	 * @param vacancy_id
	 *            The reference Id of the Vacancy for which the job event will
	 *            be created
	 * @param task_id
	 *            The reference Id of the Task i.e. task is ISTAR_JOB_TASK
	 * @param jobStage
	 *            The stage of the Istar Task Workflow based upon task_id whose
	 *            order_id is 1
	 * @param student
	 *            The student to whom the created Job Event would be assigned
	 * @return JobsEvent This returns the JobsEvent created
	 */
	public JobsEvent createJobsEventForEachStudent(Date eventDate, int eventHour, int eventMinutes, int creatorID,
			int vacancy_id, String task_id, String jobStage, Student student) {

		VacancyDAO vacancyDAO = new VacancyDAO();
		Vacancy vacancy = vacancyDAO.findById(vacancy_id);

		JobsEvent jobsEvent = new JobsEvent();
		JobsEventDAO jobsEventDAO = new JobsEventDAO();

		Date current = (Date) Calendar.getInstance().getTime();

		jobsEvent.setCreatedAt(current);
		jobsEvent.setType("JOBS_EVENT");
		jobsEvent.setUpdatedAt(current);
		jobsEvent.setEventdate(eventDate);
		jobsEvent.setEventhour(eventHour);
		jobsEvent.setEventminute(eventMinutes);
		jobsEvent.setIsactive(true);
		jobsEvent.setCreatorId(creatorID);
		jobsEvent.setActor(student);
		jobsEvent.setStatus(jobStage);
		jobsEvent.setVacancy(vacancy);
		jobsEvent.setTaskId(java.util.UUID.fromString(task_id));

		Session jobsEventSession = jobsEventDAO.getSession();

		Transaction jobsEventTransaction = null;
		try {
			jobsEventTransaction = jobsEventSession.beginTransaction();
			jobsEventDAO.save(jobsEvent);
			jobsEventTransaction.commit();
		} catch (HibernateException e) {
			if (jobsEventTransaction != null)
				jobsEventTransaction.rollback();
			e.printStackTrace();
		} finally {
			jobsEventSession.flush();
			jobsEventSession.close();
		}

		return jobsEvent;
	}

	/**
	 * This function promotes students from their current stage to next stage
	 * based upon the Vacancy. This method will be mainly used by recruiter to
	 * update student's stage. This method calls the
	 * {@link #createJobsEventForEachStudent(Date, int, int, int, int, String, String, Student)
	 * createJobsEventForEachStudent} method for each Student.
	 * 
	 * @param vacancy_id
	 *            The Vacancy Id for which the recruiter wants to update the
	 *            student's stage
	 * @param allStudentIDs
	 *            The List of student ids (comma-separated) to be promoted to
	 *            next stage
	 * 
	 * @return This method returns nothing
	 */
	public HashMap<String, String> promoteStudents(int vacancy_id, String stageId, String allStudentIDs) {

		int recruiterID;
		HashMap<String, String> result = new HashMap<String, String>();

		ArrayList<String> allStudents = new ArrayList<String>(Arrays.asList(allStudentIDs.split(",")));
		System.out.println("SIZE:" + allStudents.size());

		VacancyDAO vacancyDAO = new VacancyDAO();
		Vacancy vacancy = vacancyDAO.findById(vacancy_id);
		
		recruiterID = vacancy.getRecruiter().getId();
		
		if(allStudents.size() > 1){
		for (String studentID : allStudents) {
			
			if (!studentID.equalsIgnoreCase("")) {
				
				StudentDAO studentDAO = new StudentDAO();
				Student student = studentDAO.findById(Integer.parseInt(studentID));
				
				
				System.out.println("Recruiter with ID->" + recruiterID+ "promoting student ID--> " + studentID + "for Vacancy ID->" + vacancy.getId() + "from Stage->" + stageId) ;
				String taskID;
				int currentMaxOrderID;

				DBUTILS dbUtils = new DBUTILS();
				
				String queryForStudentWithExistingStages = "WITH events AS (SELECT jobs_event.task_id, jobs_event.status, MAX (jobs_event.created_at) AS ctime FROM jobs_event "
						+ "WHERE actor_id =" + studentID + " AND vacancy_id =" + vacancy_id + " AND creator_id =" + recruiterID + " GROUP BY jobs_event.task_id, "
						+ "jobs_event.status ORDER BY ctime) SELECT istar_task_workflow.stage, CAST (istar_task_workflow.task_id AS VARCHAR), CAST (istar_task_workflow.ID AS VARCHAR) as stage_id, "
						+ "MAX (istar_task_workflow.order_id) AS order_id FROM istar_task_workflow INNER JOIN events ON "
						+ "istar_task_workflow.stage = events.status AND istar_task_workflow.task_id = events.task_id"
						+ " GROUP BY istar_task_workflow.task_id,stage_id,istar_task_workflow.stage,istar_task_workflow.order_id ORDER BY istar_task_workflow.order_id";
				
				System.out.println(queryForStudentWithExistingStages);
				
				List<HashMap<String, Object>> resultForStudentWithExistingStages = dbUtils
						.executeQuery(queryForStudentWithExistingStages);
				
				if (resultForStudentWithExistingStages.size() > 0) {
					System.out.println(resultForStudentWithExistingStages.toString());
					taskID = resultForStudentWithExistingStages.get(resultForStudentWithExistingStages.size()-1).get("task_id").toString();
					currentMaxOrderID = Integer.parseInt(resultForStudentWithExistingStages.get(resultForStudentWithExistingStages.size()-1).get("order_id").toString());

					int currentStageOrderID = 0;
					String intermediateNextStageName = "";
					boolean foundCurrentStage = false;
					for(HashMap<String, Object> record : resultForStudentWithExistingStages){
						
						if(foundCurrentStage){
							intermediateNextStageName = record.get("stage").toString();
						}

						if(record.get("stage_id").toString().equals(stageId)){
							currentStageOrderID = Integer.parseInt(record.get("order_id").toString());
							foundCurrentStage = true;
						}
					}

					String sqlQueryForAllRemainingStages = "SELECT stage, cast (id as varchar), order_id from istar_task_workflow where task_id='"
							+ taskID + "' AND order_id>" + currentMaxOrderID + " order by order_id";
					
					System.out.println(sqlQueryForAllRemainingStages);
					
					List<HashMap<String, Object>> resultForAllRemaningOrderedStages = dbUtils
							.executeQuery(sqlQueryForAllRemainingStages);
					
					System.out.println(resultForAllRemaningOrderedStages.toString());
					
					if(resultForAllRemaningOrderedStages.size() > 0){
					String nextStageName = resultForAllRemaningOrderedStages.get(0).get("stage").toString();
					int nextOrderID = Integer.parseInt(resultForAllRemaningOrderedStages.get(0).get("order_id").toString());
					int lastStageOrderID = Integer.parseInt(resultForAllRemaningOrderedStages.get(resultForAllRemaningOrderedStages.size()-1).get("order_id").toString());
					
					if(currentStageOrderID < currentMaxOrderID){
						System.out.println("Student already exists in the next stage");
						result.put(student.getName(), student.getId()+",2, already promoted to " +intermediateNextStageName);
					}				
					else{						
						System.out.println("Student will be promoted");
						System.out.println("Promoting Student with ID->" + student.getId() + "to " + nextStageName);
						System.out.println("Updating existing stages as INACTIVE");
						
						String deactivateExistingStages = "update jobs_event set isactive='f' where actor_id =" + studentID + " AND vacancy_id =" + vacancy_id + " AND creator_id =" + recruiterID;						
						System.out.println("Deactivating Stages SQL-->" + deactivateExistingStages);
						
						dbUtils.executeUpdate(deactivateExistingStages);
						
						createJobsEventForEachStudent(Calendar.getInstance().getTime(), 1, 30, recruiterID,
								vacancy_id, taskID, nextStageName, student);
						result.put(student.getName(), student.getId()+",0, promoted to " +nextStageName);
					}
					
					}
					else{
						System.out.println("Student is already offered a position");
						result.put(student.getName(), student.getId()+",1, is already offered a position");
					}	
				}
				else{
					System.out.println("Something is fishy here.");
					result.put(student.getName(), student.getId()+",3, Oops! something is fishy here");
				}
			}
		}
		}else{
			System.out.println("No Student Selected");
		}
		return result;
	}
	
	/**
	 * This method is used to start a campaign for College Recruitment based upon particular vacancy
	 *
	 *@param vacancID
	 *			The vacancy Id for which the campaign has to be started
	 *@param CollegeID
	 *			The college ID where the campaign is to be launched
	 *
	 *@return
	 *		This method does not return a value
	 */
	public void addCampaign(int vacancyID, int collegeID){
		
		java.util.Date date= new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		VacancyDAO vacancyDAO = new VacancyDAO();
		Vacancy vacancy = vacancyDAO.findById(vacancyID);
		
		CollegeDAO collegeDAO = new CollegeDAO();
		College college = collegeDAO.findById(collegeID);
		
		CampaignsDAO campaignsDAO = new CampaignsDAO();
		Campaigns campaigns = new Campaigns();
		
		campaigns.setCollege(college);
		campaigns.setVacancy(vacancy);
		campaigns.setCreatedAt(current);
		campaigns.setUpdatedAt(current);
		
		Session campaignsSession = campaignsDAO.getSession();

		Transaction campaignsTransaction = null;
		try {
			campaignsTransaction = campaignsSession.beginTransaction();
			campaignsDAO.save(campaigns);
			campaignsTransaction.commit();
			System.out.println("Campaign Created for College -->"+ collegeID+ "of Vacancy->" +vacancyID);
		} catch (HibernateException e) {
			if (campaignsTransaction != null)
				campaignsTransaction.rollback();
			e.printStackTrace();
		} finally {
			campaignsSession.flush();
			campaignsSession.close();
		}
		
		Set<Student> tempStudents = college.getStudents();
		
		if(tempStudents.size() > 0){
		List<Student> allStudents = new ArrayList<Student>();
		
		for(Student tempStudent : tempStudents){
			allStudents.add(tempStudent);
		}
		
		createJobsEvents(current, 1, 40, vacancy.getRecruiter().getId(), vacancy.getId(),
				vacancy.getIstarTaskType().getId().toString(), allStudents);
		}else{
			System.out.println("No Student registered in College");
		}
	}
	
	
	public void addCampaignForTargetedStudents(int vacancyID, int collegeID){
		
		java.util.Date date= new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		VacancyDAO vacancyDAO = new VacancyDAO();
		Vacancy vacancy = vacancyDAO.findById(vacancyID);
		
		CollegeDAO collegeDAO = new CollegeDAO();
		College college = collegeDAO.findById(collegeID);
		
		CampaignsDAO campaignsDAO = new CampaignsDAO();
		Campaigns campaigns = new Campaigns();
		
		campaigns.setCollege(college);
		campaigns.setVacancy(vacancy);
		campaigns.setCreatedAt(current);
		campaigns.setUpdatedAt(current);
		
		Session campaignsSession = campaignsDAO.getSession();

		Transaction campaignsTransaction = null;
		try {
			campaignsTransaction = campaignsSession.beginTransaction();
			campaignsDAO.save(campaigns);
			campaignsTransaction.commit();
			System.out.println("Campaign Created for College -->"+ collegeID+ "of Vacancy->" +vacancyID);
		} catch (HibernateException e) {
			if (campaignsTransaction != null)
				campaignsTransaction.rollback();
			e.printStackTrace();
		} finally {
			campaignsSession.flush();
			campaignsSession.close();
		}
	}
	
	public boolean hasCampaigns(int vacancyID, int collegeID){
		
		List<Campaigns> campaignsForVacancy = getCampaignsForVacancy(vacancyID);
		List<Campaigns> campaignsForCollege = getCampaignsForCollege(collegeID);
		System.out.println("College->" + campaignsForCollege.size());
		System.out.println("Vacancy->" + campaignsForVacancy.size());
		List<Campaigns> commonCampaigns = new ArrayList<Campaigns>();
		
		commonCampaigns = (List<Campaigns>) CollectionUtils.intersection(campaignsForVacancy, campaignsForCollege);
		
		if(commonCampaigns.size() > 0){
			return true;
		}else{
			System.out.println("NO Common Campaign Found");
			return false;
		}
	}
	
	public boolean hasLaunchedCampaign(int recruiterID, int collegeID){
		List<Campaigns> campaignsForRecruiter = getCampaignsForRecruiter(recruiterID);
		List<Campaigns> campaignsForCollege = getCampaignsForCollege(collegeID);
		
		System.out.println("College->" + campaignsForCollege.size());
		System.out.println("Recruiter->" + campaignsForRecruiter.size());
		
		List<Campaigns> commonCampaigns = new ArrayList<Campaigns>();
		
		commonCampaigns = (List<Campaigns>) CollectionUtils.intersection(campaignsForRecruiter, campaignsForCollege);
		
		if(commonCampaigns.size() > 0){
			return true;
		}else{
			System.out.println("No Common Campaign Found");
			return false;
		}
	}
	
	public List<Campaigns> getCampaignsForVacancy(int vacancyID){
		VacancyDAO vacancyDAO = new VacancyDAO();
		Vacancy vacancy = vacancyDAO.findById(vacancyID);
		
		CampaignsDAO campaignsDAO = new CampaignsDAO();
		return (List<Campaigns>) campaignsDAO.findByProperty("vacancy", vacancy);
	}
	
	public List<Campaigns> getCampaignsForCollege(int collegeID){
		CollegeDAO collegeDAO = new CollegeDAO();
		College college = collegeDAO.findById(collegeID);
		
		CampaignsDAO campaignsDAO = new CampaignsDAO();
		return (List<Campaigns>) campaignsDAO.findByProperty("college", college);
	}
	
	public List<Campaigns> getCampaignsForRecruiter(int recruiterID){
		
		RecruiterDAO recruiterDAO = new RecruiterDAO();
		Recruiter recruiter = recruiterDAO.findById(recruiterID);
		List<Campaigns> allCampaignsOfRecruiter = new ArrayList<Campaigns>();
		
		Set<Vacancy> allVacancyOfRecruiter = recruiter.getVacancies();
		
		CampaignsDAO campaignsDAO = new CampaignsDAO();
		
		for(Vacancy vacancy :allVacancyOfRecruiter){
			List<Campaigns> allCampaignsForVacancy = getCampaignsForVacancy(vacancy.getId());
			
			if(allCampaignsForVacancy.size()>0){
				allCampaignsOfRecruiter.addAll(allCampaignsForVacancy);
				System.out.println("Found Campaign for vacancy");
			}
		}
	return allCampaignsOfRecruiter;		
	}
	
	

	public List<Company> getAllCompanies(){		
		CompanyDAO companyDAO = new CompanyDAO();
		return companyDAO.findAll();
	}
	
	public ArrayList<College> getAllColleges(){
		
		ArrayList<College> allColleges = new ArrayList<College>();
		
		CollegeDAO collegeDAO = new CollegeDAO();
		
		allColleges = (ArrayList<College>) collegeDAO.findAll();
		
		return allColleges;
	}
	
	public List<HashMap<String, Object>> getCountryPercentile(){
		HashMap<String, String> data = new HashMap<>();
/*		String sql = "select avg(percentile.percentile_country) as overall_percentile from (select CAST (T.percentile_country as INTEGER) from skill, "
				+ "(WITH summary AS (SELECT p.id,p.skill_id,p.percentile_country,ROW_NUMBER() OVER(PARTITION BY p.skill_id ORDER BY p.timestamp DESC) AS rk "
				+ "FROM skill_precentile p) SELECT s.* FROM summary s WHERE s.rk = 1 )T where T.skill_id = skill.id and "
				+ "skill.id !=0 AND SKILL.parent_skill = 0 order by T.percentile_country desc) percentile";*/
		
		/*String sql = "SELECT sum(report.score) AS score_obtained, report.user_id AS student_id, SUM(total.total_score) AS total_score from "
				+ "report INNER JOIN (SELECT COUNT (*) AS total_score, assessment.ID AS assessment_id FROM assessment_question INNER JOIN "
				+ "assessment ON assessment_question.assessmentid = assessment.ID GROUP BY assessment.ID ORDER BY assessment.ID) total "
				+ "ON report.assessment_id = total.assessment_id GROUP BY report.user_id, total.total_score";*/
		
		String sql = "WITH records_table AS (SELECT student_id, skill_id, MAX (TIMESTAMP) AS latest "
				+ " FROM skill_precentile WHERE skill_id = 0 GROUP BY student_id, skill_id 	ORDER BY student_id )"
				+ " select skill_precentile.student_id, skill_precentile.percentile_country from skill_precentile "
				+ " inner join records_table on skill_precentile.student_id = records_table.student_id AND "
				+ " records_table.latest = skill_precentile.timestamp and records_table.skill_id = skill_precentile.skill_id";
		
		//System.out.println(sql);
		DBUTILS utils = new DBUTILS();
		List<HashMap<String, Object>> overallPercentile = new ArrayList<HashMap<String, Object>>();
		overallPercentile = utils.executeQuery(sql);
		
		return overallPercentile;
	}
	
	public String getCountryPercentileForEachStudent(int studentID){

		String scoreObtained = "";
		
		String sql = "WITH records_table AS (SELECT student_id, skill_id, MAX (TIMESTAMP) AS latest "
				+ " FROM skill_precentile WHERE skill_id = 0 and student_id= "+studentID +" GROUP BY student_id, skill_id 	ORDER BY student_id )"
				+ " select skill_precentile.student_id, skill_precentile.percentile_country from skill_precentile "
				+ " inner join records_table on skill_precentile.student_id = records_table.student_id AND "
				+ " records_table.latest = skill_precentile.timestamp and records_table.skill_id = skill_precentile.skill_id";
		
		//System.out.println(sql);
		DBUTILS utils = new DBUTILS();
		List<HashMap<String, Object>> overallPercentile = new ArrayList<HashMap<String, Object>>();
		overallPercentile = utils.executeQuery(sql);
		
		if(overallPercentile.size() > 0){
			scoreObtained = overallPercentile.get(0).get("percentile_country").toString();
		}else{
			System.out.println("The student does not have country percentile in the DB.");
		}		
		return scoreObtained;
	}
	
	public HashMap<Integer, Integer> getCountryPercentile(HashMap<Integer, Student> allStudents) {

		HashMap<Integer, Integer> allStudentPercentile = new HashMap<Integer, Integer>();
		List<HashMap<String, Object>> overallPercentile = getCountryPercentile();
		
		if(!overallPercentile.isEmpty()){
			for(Integer studentID : allStudents.keySet()){
				for(HashMap<String, Object> queryResult: overallPercentile){
					if(queryResult.get("student_id").toString().equals(studentID.toString())){
						
						int scoreObtained = Integer.parseInt(queryResult.get("percentile_country").toString());

						allStudentPercentile.put(studentID, scoreObtained);
					}
				}
			}
		}
		return allStudentPercentile;
	}
	
	public HashMap<String, Object> getInterviewDetails(String uniqueURLCode){   
		HashMap<String, Object> interviewDetails = new HashMap<String, Object>();
		
		System.out.println("Getting Interview Details");
		
		PanelistScheduleDAO panelistScheduleDAO = new PanelistScheduleDAO();
		List<PanelistSchedule> allPanelistSchedule = panelistScheduleDAO.findByUrlCode(uniqueURLCode);
		
		if(allPanelistSchedule.size()>0){
			System.out.println("Schedule Found for the interview");
		Student student = allPanelistSchedule.get(0).getStudent();
		Vacancy vacancy = allPanelistSchedule.get(0).getVacancy();
		Panelist panelist = allPanelistSchedule.get(0).getPanelist();
		String hostURL =  allPanelistSchedule.get(0).getHostURL();
		String joinURL = allPanelistSchedule.get(0).getJoinURL();
		
		PanelistFeedbackDAO panelistFeedbackDAO = new PanelistFeedbackDAO();
		List<PanelistFeedback> allPanelistFeedback = panelistFeedbackDAO.findByProperty("vacancy", vacancy);
		
		List<PanelistFeedback> allPanelistFeedbackForVacancy = new ArrayList<PanelistFeedback>();
		
		for(PanelistFeedback panelistFeedback: allPanelistFeedback){
			if(panelistFeedback.getVacancy()== vacancy && !panelistFeedback.getUrlCode().equalsIgnoreCase(uniqueURLCode)){
				allPanelistFeedbackForVacancy.add(panelistFeedback);
				System.out.println("panelist feed back is->" + panelistFeedback.getFeedback());
			}
		}
		
		interviewDetails.put("student", student);
		interviewDetails.put("vacancy", vacancy);
		interviewDetails.put("panelist", panelist);
		interviewDetails.put("allPanelistFeedbackForVacancy", allPanelistFeedbackForVacancy);
		interviewDetails.put("hostURL", hostURL);
		interviewDetails.put("joinURL", joinURL);
		interviewDetails.put("uniqueURLCode", uniqueURLCode);
		
		System.out.println("HOST URL:" + hostURL);
		System.out.println("JOIN URL:" +joinURL);
		}else{
			System.out.println("No Schedule Found for this Interview");
		}
		
		System.out.println("Returning to Initializing servlet");
		return interviewDetails;
	}
	
	public void sendInterviewFeedback(String uniqueURLCode,  String interviewResult, String interviewFeedback){
		
		PanelistScheduleDAO panelistScheduleDAO = new PanelistScheduleDAO();
		PanelistSchedule panelistSchedule = panelistScheduleDAO.findByUrlCode(uniqueURLCode).get(0);
		
		PanelistFeedbackDAO panelistFeedbackDAO = new PanelistFeedbackDAO();
		List<PanelistFeedback> existingPanelistFeedbackList = panelistFeedbackDAO.findByUrlCode(uniqueURLCode);

		PanelistFeedback panelistFeedback;
		boolean isNewPanelistFeedback = true;
		if(existingPanelistFeedbackList.size()>0){
			panelistFeedback = existingPanelistFeedbackList.get(0);
			System.out.println("PanelistFeedback Already Exists");
			isNewPanelistFeedback = false;
		}else{
			panelistFeedback = new PanelistFeedback();
			System.out.println("Creating new Feedback");
		}
		
		java.util.Date date= new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		panelistFeedback.setCreatedAt(current);
		panelistFeedback.setUpdatedAt(current);
		panelistFeedback.setPanelist(panelistSchedule.getPanelist());
		panelistFeedback.setJobsEventId(panelistSchedule.getJobsEventId());
		panelistFeedback.setResult(interviewResult);
		panelistFeedback.setFeedback(interviewFeedback);
		panelistFeedback.setStudent(panelistSchedule.getStudent());
		panelistFeedback.setUrlCode(uniqueURLCode);
		panelistFeedback.setVacancy(panelistSchedule.getVacancy());
		
		Session panelistFeedbackSession = panelistFeedbackDAO.getSession();

		Transaction panelistFeedbackTransaction = null;
		try {
			panelistFeedbackTransaction = panelistFeedbackSession.beginTransaction();
			if(isNewPanelistFeedback){
			panelistFeedbackDAO.save(panelistFeedback);
			}else{
				panelistFeedbackDAO.attachDirty(panelistFeedback);
			}
			panelistFeedbackTransaction.commit();
		} catch (HibernateException e) {
			if (panelistFeedbackTransaction != null)
				panelistFeedbackTransaction.rollback();
			e.printStackTrace();
		} finally {
			panelistFeedbackSession.flush();
			panelistFeedbackSession.close();
		}
		
		System.out.println("PANELIST FEEDBACK INserted");
	}
	
	public void insertNewSkillRatingFromPanelist(String uniqueURLCode, int skillID, int rating){
		
		PanelistScheduleDAO panelistScheduleDAO = new PanelistScheduleDAO();
		PanelistSchedule panelistSchedule = panelistScheduleDAO.findByUrlCode(uniqueURLCode).get(0);
		
		SkillRating skillRating;
		boolean isNewSkillRating = true;
		
		SkillRatingDAO skillRatingDAO = new SkillRatingDAO();
		List<SkillRating> existingSkillRatingList = skillRatingDAO.findByUrlCode(uniqueURLCode);
		
			skillRating = new SkillRating();
			System.out.println("Creating new SkillRating");
		
		SkillDAO skillDAO = new SkillDAO();
		Skill skill = skillDAO.findById(skillID);

		java.util.Date date= new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		skillRating.setCreatedAt(current);
		skillRating.setUpdatedAt(current);
		skillRating.setPanelist(panelistSchedule.getPanelist());
		skillRating.setJobsEventId(panelistSchedule.getJobsEventId());
		skillRating.setStudent(panelistSchedule.getStudent());
		skillRating.setUrlCode(uniqueURLCode);
		skillRating.setVacancy(panelistSchedule.getVacancy());
		skillRating.setSkill(skill);
		skillRating.setRating(rating);
		skillRating.setComment("No Comment Provided");
		
		Session skillRatingSession = skillRatingDAO.getSession();

		Transaction skillRatingTransaction = null;
		try {
			skillRatingTransaction = skillRatingSession.beginTransaction();
			if(isNewSkillRating){
				skillRatingDAO.save(skillRating);
			}else{
				skillRatingDAO.attachDirty(skillRating);
			}
			skillRatingTransaction.commit();
		} catch (HibernateException e) {
			if (skillRatingTransaction != null)
				skillRatingTransaction.rollback();
			e.printStackTrace();
		} finally {
			skillRatingSession.flush();
			skillRatingSession.close();
		}
		System.out.println("Skill Rating Inserted");
	}
	
	public void insertMultipleSkillRatingsFromPanelist(String uniqueURLCode, HashMap<String, String> skillRatings){
		
		if(!uniqueURLCode.trim().isEmpty() && skillRatings.size()>0){
			for(Map.Entry<String, String> skill : skillRatings.entrySet()){
				if(skill.getValue()!=null){
					insertNewSkillRatingFromPanelist(uniqueURLCode, Integer.parseInt(skill.getKey()), Integer.parseInt(skill.getValue()));
					System.out.println("Adding Entry for Skill ID->" + skill.getKey() + "with value->" + skill.getValue());
				}
			}
			System.out.println("All Skill Ratings Entry added for this interview");
		}
	}
	
	public College createCollege(String addressline1, String addressline2, String state, String city, String country,
			int pin, String college_name, String industry_type, String profile, String image_url, String numberOfStudents) {
		PincodeDAO pincodeDAO = new PincodeDAO();
		List<Pincode> pincode_list = pincodeDAO.findByPin(pin);

		Pincode p = new Pincode();
		if (pincode_list.size() > 0 && pincode_list.get(0).getId() != null) {
			p = pincode_list.get(0);
		} else {
			p.setCity(city);
			p.setCountry(country);
			p.setState(state);
			p.setPin(pin);
			Session pinsession = pincodeDAO.getSession();
			Transaction addtx = null;
			try {
				addtx = pinsession.beginTransaction();
				pincodeDAO.save(p);
				addtx.commit();
			} catch (HibernateException e) {
				if (addtx != null)
					addtx.rollback();
				e.printStackTrace();
			} finally {
				pinsession.close();
			}
		}

		Address address = new Address();
		address.setAddressline1(addressline1);
		address.setAddressline2(addressline2);
		address.setPincode(p);
		AddressDAO adddao = new AddressDAO();
		Session addsession = adddao.getSession();
		Transaction addtx = null;
		try {
			addtx = addsession.beginTransaction();
			adddao.save(address);
			addtx.commit();
		} catch (HibernateException e) {
			if (addtx != null)
				addtx.rollback();
			e.printStackTrace();
		} finally {
			addsession.close();
		}

		College c = new College();
		CollegeDAO collegedao = new CollegeDAO();
		c.setAddress(address);
		c.setCompany_profile(profile);
		c.setImage("not_available");
		if (image_url != null && image_url != "") {
			c.setImage(image_url);
		}
		c.setIndustry(industry_type);
		c.setName(college_name);
		c.setOrgType("COLLEGE");
		c.setMaxStudents(Integer.parseInt(numberOfStudents));
		Session session = collegedao.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			collegedao.save(c);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return c;
	}
	
	
	public College updateCollege(int college_id, String addressline1, String addressline2, String state, String city,
			String country, int pin, String college_name, String industry_type, String profile, String image_url, String numberOfStudents) {

		CollegeDAO collegeDAO = new CollegeDAO();
		College c = collegeDAO.findById(college_id);

		PincodeDAO pincodeDAO = new PincodeDAO();
		List<Pincode> pincode_list = pincodeDAO.findByPin(pin);

		Pincode p = new Pincode();
		if (pincode_list.size() > 0 && pincode_list.get(0).getId() != null) {
			p = pincode_list.get(0);
		} else {
			p.setCity(city);
			p.setCountry(country);
			p.setState(state);
			p.setPin(pin);
			Session pinsession = pincodeDAO.getSession();
			Transaction addtx = null;
			try {
				addtx = pinsession.beginTransaction();
				pincodeDAO.save(p);
				addtx.commit();
			} catch (HibernateException e) {
				if (addtx != null)
					addtx.rollback();
				e.printStackTrace();
			} finally {
				pinsession.close();
			}
		}

		Address address = c.getAddress();
		address.setAddressline1(addressline1);
		address.setAddressline2(addressline2);
		address.setPincode(p);
		AddressDAO adddao = new AddressDAO();
		Session addsession = adddao.getSession();
		Transaction addtx = null;
		try {
			addtx = addsession.beginTransaction();
			adddao.attachDirty(address);
			;
			addtx.commit();
		} catch (HibernateException e) {
			if (addtx != null)
				addtx.rollback();
			e.printStackTrace();
		} finally {
			addsession.close();
		}

		c.setAddress(address);
		c.setCompany_profile(profile);
		c.setImage("not_available");
		if (image_url != null && image_url != "") {
			c.setImage(image_url);
		}
		c.setIndustry(industry_type);
		c.setName(college_name);
		c.setOrgType("COLLEGE");
		c.setMaxStudents(Integer.parseInt(numberOfStudents));
		Session session = collegeDAO.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			collegeDAO.attachDirty(c);
			;
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

		return c;
	}
	
	public PlacementOfficer createPlacementOfficer(int collegeID, String email, String name){
		
		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);
		
		if(istarUserList.size() > 0){
			System.out.println("A user with this email address already exists!");
			return null;
		}
		
		PlacementOfficer placementOfficer = new PlacementOfficer();
		PlacementOfficerDAO placementOfficerDAO = new PlacementOfficerDAO();
		
		College college = (new CollegeDAO()).findById(collegeID);
		
		placementOfficer.setName(name);
		placementOfficer.setEmail(email);
		placementOfficer.setCollege(college);
		placementOfficer.setAddress(college.getAddress());
		placementOfficer.setPassword("test123");
		placementOfficer.setUserType("PlacementOfficer");
		placementOfficer.setIstarAuthorizationToken("t");
		placementOfficer.setIsVerified(true);
		placementOfficer.setTokenExpired(false);
		placementOfficer.setTokenVerified("true");
		
		Session placementOfficerSession = placementOfficerDAO.getSession();
		Transaction placementOfficerTransaction = null;
		
		try {
			placementOfficerTransaction = placementOfficerSession.beginTransaction();
			placementOfficerDAO.save(placementOfficer);
			placementOfficerTransaction.commit();
		} catch (HibernateException e) {
			if (placementOfficerTransaction != null)
				placementOfficerTransaction.rollback();
			e.printStackTrace();
		} finally {
			placementOfficerSession.flush();
			placementOfficerSession.close();
		}
		System.out.println("Placement Officer Created");
		
		sendInviteMail(placementOfficer.getEmail(), placementOfficer.getName(), placementOfficer.getPassword());
		
		return placementOfficer;
	}
	
	
	public PlacementOfficer updatePlacementOfficer(int placementOfficerID, String name, String email, String gender, String mobileNumber, 
			String password, Address address){
		
		PlacementOfficerDAO placementOfficerDAO = new PlacementOfficerDAO();
		PlacementOfficer placementOfficer = placementOfficerDAO.findById(placementOfficerID);
		
		if(placementOfficer==null){
			System.out.println("Invalid Placement Officer ID");
			return null;
		}
		
		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);
		
		if(istarUserList.size() > 0 && placementOfficer!=istarUserList.get(0)){
			System.out.println("A user with this email address already exists!");
			return null;
		}
		
		placementOfficer.setName(name);
		placementOfficer.setEmail(email);
		placementOfficer.setGender(gender);
		placementOfficer.setAddress(address);
		placementOfficer.setPassword(password);
		placementOfficer.setMobile(Long.valueOf(mobileNumber).longValue());
		
		Session placementOfficerSession = placementOfficerDAO.getSession();
		Transaction placementOfficerTransaction = null;
		
			try {
				placementOfficerTransaction = placementOfficerSession.beginTransaction();
				placementOfficerDAO.attachDirty(placementOfficer);
				placementOfficerTransaction.commit();
			} catch (HibernateException e) {
				if (placementOfficerTransaction != null)
					placementOfficerTransaction.rollback();
				e.printStackTrace();
			} finally {
				placementOfficerSession.flush();
				placementOfficerSession.close();
			}
		
			System.out.println("PlacementOfficer details updated");
		return placementOfficer;		
		}
}