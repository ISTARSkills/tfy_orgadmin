package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.app.metadata.services.MetadataServices;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeRecruiter;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.dao.VacancyProfile;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/getFilteredStudents")
public class GetFilteredStudents  extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;


	public GetFilteredStudents() {
		super();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		
		String vacancyID = request.getParameter("vacancyID");
		Vacancy vacancy = (new VacancyDAO()).findById(Integer.parseInt(vacancyID));
		Recruiter recruiter = vacancy.getRecruiter();
		String sql  = getSQL(request);		
		System.out.println(sql);
		
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> allStudents= util.executeQuery(sql);
		ArrayList<Student> allStudentsToBeTargeted = new ArrayList<Student>();
		String filteredStudents ="";
		Set<College> targetedStudentColleges = new HashSet<College>();
		RecruiterServices recruiterServices = new RecruiterServices();
		
		if(allStudents.size() > 0){
		for(HashMap<String, Object> student : allStudents){
			filteredStudents = filteredStudents + "," + student.get("id");
			Student studentObject = new StudentDAO().findById(Integer.parseInt(student.get("id").toString()));
			allStudentsToBeTargeted.add(studentObject);
			targetedStudentColleges.add(studentObject.getCollege());
		}
		}else{
			filteredStudents = "";
		}

		
		if(allStudentsToBeTargeted.size() > 0){
			
			java.util.Date date= new java.util.Date();
			Timestamp current = new Timestamp(date.getTime());

			recruiterServices.createJobsEvents(current, 1, 40, vacancy.getRecruiter().getId(), vacancy.getId(),
				vacancy.getIstarTaskType().getId().toString(), allStudentsToBeTargeted);
		}else{
			System.out.println("No New Student to be targeted");
		}
		
		if(targetedStudentColleges.size() > 0){
			System.out.println("Launching Campaign for Colleges of Targeted Students");
			for(College college: targetedStudentColleges){
				System.out.println(college.getName());
				recruiterServices.addCampaignForTargetedStudents(Integer.parseInt(vacancyID), college.getId());
			}
		}else{
			System.out.println("No New Campaign Launched for this vacancy");
		}
		
		
		Set<Integer> collegesOfRecruiter = new HashSet<Integer>();
		
		Set<CollegeRecruiter> allCollegeRecruiters = recruiter.getCollegeRecruiters();
		
		for(CollegeRecruiter cr : allCollegeRecruiters){
			collegesOfRecruiter.add(cr.getCollege().getId());
		}
		
		Set<Integer> newCollegeForRecruiter = new HashSet<Integer>();
		
		for(College college: targetedStudentColleges){
			newCollegeForRecruiter.add(college.getId());
		}
		
		newCollegeForRecruiter.removeAll(collegesOfRecruiter);
		
		DBUTILS dbutils = new DBUTILS();
		
		for(int collegeID : newCollegeForRecruiter){
			
			String collegeRecruiterSQL = "insert into college_recruiter(id, college_id, recruiter_id) values "
					+ "((select coalesce(max(id)+1, 0) from college_recruiter),"
					+ " "+collegeID+" , " + recruiter.getId()+" )";
					System.out.println(collegeRecruiterSQL);
					
			dbutils.executeUpdate(collegeRecruiterSQL);
		}
		
		System.out.println("Filtered Students List:" + filteredStudents);
		response.getWriter().print(filteredStudents);
	}
	
	private String getStudentsWithRanks(HttpServletRequest request){
		String rank = request.getParameter("rank");
		String sqlRank = " AND student.id in (select student_id from ("
				+ " WITH records_table AS (	SELECT student_id, skill_id, MAX (TIMESTAMP) AS latest FROM skill_precentile WHERE "
				+ "skill_id = 0 GROUP BY student_id, skill_id ORDER BY student_id ) SELECT skill_precentile.student_id FROM skill_precentile INNER JOIN "
				+ "records_table ON skill_precentile.student_id = records_table.student_id AND records_table.latest "
				+ "= skill_precentile. TIMESTAMP AND records_table.skill_id = skill_precentile.skill_id ORDER BY PERCENTILE_COUNTRY DESC LIMIT ";

		switch(rank){
		case "100":	return  sqlRank + "101) as tempo)" ;
		case "200": return  sqlRank + "201) as tempo)" ;
		case "500":	return  sqlRank + "501) as tempo)" ;	 
		}
		System.out.println("Rank is-->" + sqlRank);
		return "";
	}
	
	private String getCitySearchPart(HttpServletRequest request) {
		String filtered_cities =  request.getParameter("cities");
		String city_parameter_value=" and pincode.city in (";
		for(String str :filtered_cities.split(","))
		{	
			if(!str.trim().isEmpty()){
			String city_name="'"+str.trim()+"'"; 
			city_parameter_value+=city_name+",";
			}
		}
		if (city_parameter_value.endsWith(",")) {
			city_parameter_value = city_parameter_value.substring(0, city_parameter_value.length()-1);
		}
		city_parameter_value+=")";	
		return city_parameter_value;
	}
	
	private String getCollegeSearchPart(HttpServletRequest request) {
		
		String  filtered_colleges_id =  request.getParameter("colleges");
		String college_parameter_value=" and college.id in ('";
		for(String str :filtered_colleges_id.split(","))
		{	if(!str.trim().isEmpty()){		
			String college_id=str.trim(); 
			college_parameter_value+=college_id+",";
		}
		}
		if (college_parameter_value.endsWith(",")) {
			college_parameter_value = college_parameter_value.substring(0, college_parameter_value.length()-1);
		}
		college_parameter_value+="')";
		return college_parameter_value;
	}
	
	private String getUGSearchPart(HttpServletRequest request) {
		String  filtered_ug_degrees =  request.getParameter("ugDegrees");
		
		String ug_degree_value=" and student_profile_data.under_graduate_degree_name in (";
		for(String str :filtered_ug_degrees.split(","))
		{	if(!str.trim().isEmpty()){		
			String city_name="'"+str.trim()+"'"; 
			ug_degree_value+=city_name+",";
		}
		}
		if (ug_degree_value.endsWith(",")) {
			ug_degree_value = ug_degree_value.substring(0, ug_degree_value.length()-1);
		}
		ug_degree_value+=")";
		return ug_degree_value;
	}
	
	
	private String getUGSpecializations(HttpServletRequest request)
	{ 
		String specialization = request.getParameter("specializations");
		String specialization_val = " and student_profile_data.under_graduation_specialization_name in (";
		for(String str: specialization.split(",")){
			if(!str.trim().isEmpty()){
			String specialization_name = "'"+str.trim()+"'"; 
			specialization_val+=specialization_name+",";
			}
		}
		if(specialization_val.endsWith(",")){
			specialization_val = specialization_val.substring(0, specialization_val.length()-1);
		}	
		specialization_val+=")";
		return specialization_val;
	}
	
	private String getPGSearchPart(HttpServletRequest request, boolean hasUndergraduateDegree) {
		String  filtered_pg_degrees =  request.getParameter("pgDegrees");
		String pg_degree_value;
		if(hasUndergraduateDegree){
		pg_degree_value=" or student_profile_data.pg_degree_name in (";
		}else{
			pg_degree_value=" and student_profile_data.pg_degree_name in (";
		}
		for(String str :filtered_pg_degrees.split(","))
		{			
			if(!str.trim().isEmpty()){
			String city_name="'"+str.trim()+"'"; 
			pg_degree_value+=city_name+",";
			}
		}
		if (pg_degree_value.endsWith(",")) {
			pg_degree_value = pg_degree_value.substring(0, pg_degree_value.length()-1);
		}
		pg_degree_value+=")";
		return pg_degree_value;
	}
	
	private String getPGSpecializations(HttpServletRequest request)
	{ 
		String specialization = request.getParameter("specializations");
		String specialization_val = " and student_profile_data.post_graduation_specialization_name in (";
		for(String str: specialization.split(",")){
			if(!str.trim().isEmpty()){
			String specialization_name = "'"+str.trim()+"'"; 
			specialization_val+=specialization_name+",";	
			}
		}
		if(specialization_val.endsWith(",")){
			specialization_val = specialization_val.substring(0, specialization_val.length()-1);
		}	
		specialization_val+=")";
		return specialization_val;
	}
	
	private String getHighSchoolPerformance(HttpServletRequest request) {
		String highSchoolPerformance = request.getParameter("highschool_performance");
		String sql =" and student_profile_data.marks_10 >= " + highSchoolPerformance;
		return sql;
	}
	
	private String getIntermediatePerformance(HttpServletRequest request) {
		String intermediatePerformance = request.getParameter("intermediate_performance");
		String sql =" and student_profile_data.marks_12 >= " + intermediatePerformance;
		return sql;
	}
	

	
	private String getSQL(HttpServletRequest request) {
		
		StringBuffer sb = new StringBuffer();
		
		boolean hasUndergraduateDegree = false;

		if(request.getParameterMap().containsKey("vacancyID")){
		
			 String vacancyID = request.getParameter("vacancyID");
			 
			 sb.append("select distinct student.id from student inner join student_profile_data on student.id = student_profile_data.student_id inner join "
			 		+ "address on student.address_id = address. ID inner join pincode on address.pincode_id = pincode.id inner join college on	"
			 		+ "student.organization_id = college.ID inner join skill_precentile on skill_precentile.student_id = student.id inner join jobs_event "
			 		+ "on jobs_event.actor_id = student.id WHERE student.user_type = 'STUDENT' and student.id=skill_precentile.student_id and "
					+ "student.id not in (select actor_id from jobs_event where jobs_event.vacancy_id='"+vacancyID+"')");
			  
		/*	 sb.append("select distinct student.id from student, student_profile_data, pincode, address, college, skill_precentile, jobs_event "
					+ "where student.id = student_profile_data.student_id and student.address_id = address.id and address.pincode_id = pincode.id "
					+ "and student.organization_id = college.id and student.user_type='STUDENT' and student.id=skill_precentile.student_id and "
					+ "student.id not in (select actor_id from jobs_event where jobs_event.vacancy_id='"+vacancyID+"')");*/
		}else{
			sb.append("select distinct student.id from student, student_profile_data, pincode, address, college, skill_precentile "
					+ "where student.id = student_profile_data.student_id and student.address_id = address.id and address.pincode_id = pincode.id "
					+ "and student.organization_id = college.id and student.user_type='STUDENT' and student.id=skill_precentile.student_id");			
		}
		
		
		if(!request.getParameter("rank").toString().trim().isEmpty() && !request.getParameter("rank").toString().trim().equals("0")){
			System.out.println("Rank is Defined");
			sb.append(getStudentsWithRanks(request));
		}
		else{
		
		if(!request.getParameter("cities").toString().trim().isEmpty()){
			sb.append(getCitySearchPart(request));					
		}
		if(!request.getParameter("colleges").toString().trim().isEmpty()){
			System.out.println("Adding college Search part: " + getCollegeSearchPart(request));
			sb.append(getCollegeSearchPart(request));
		}
		
		if(!request.getParameter("ugDegrees").toString().trim().isEmpty()){
			sb.append(getUGSearchPart(request));
			if(!request.getParameter("specializations").toString().trim().isEmpty()){
			sb.append(getUGSpecializations(request));
			}
			hasUndergraduateDegree = true;
		}
		
		if(!request.getParameter("pgDegrees").toString().trim().isEmpty()){
			sb.append(getPGSearchPart(request, hasUndergraduateDegree));
			if(!request.getParameter("specializations").toString().trim().isEmpty()){
			sb.append(getPGSpecializations(request));
			}
		}
		
		if(!request.getParameter("highschool_performance").toString().trim().isEmpty()){
			sb.append(getHighSchoolPerformance(request));
		}
		
		if(!request.getParameter("intermediate_performance").toString().trim().isEmpty()){
			sb.append(getIntermediatePerformance(request));
		}
		
		}
		//Skill Section yet to be added
		return sb.toString();
	}
	
	private void updateVacancyMetaData(HttpServletRequest request) {
		
		if(!request.getParameter("vacancyID").toString().trim().isEmpty())
		{
			String vacancyID = request.getParameter("vacancyID");
			Vacancy vacancy= new VacancyDAO().findById(Integer.parseInt(vacancyID));
			VacancyProfile vacancyProfile = vacancy.getVacancyProfile();
			
			String vacancyNumberOfPositions = "";
			String vacancyPositionType = "";
			String vacancyExperienceLevel = "";
			String vacancyCategory = "";
			String vacancyMinSalary = "";
			String vacancyMaxSalary = "";
			
			if(vacancyProfile!=null){
				vacancyPositionType = vacancyProfile.getVacancy_position_type();
				vacancyExperienceLevel = vacancyProfile.getVacancy_experience_level();
				vacancyCategory = vacancyProfile.getVacancy_category();
				vacancyMinSalary = vacancyProfile.getVacancy_min_salary();
				vacancyMaxSalary = vacancyProfile.getVacancy_max_salary();
			}
			
			String filteredRanks = request.getParameter("ranks");
			String filteredCities = request.getParameter("cities");
			String filteredColleges = request.getParameter("colleges");
			String filteredUGDegrees = request.getParameter("ugDegrees");
			String filteredPGDegrees = request.getParameter("pgDegrees");
			String filteredSpecializations = request.getParameter("specializations");
			String filteredHighSchoolPerformance = request.getParameter("highschool_performance");
			String filteredIntermediatePerformance = request.getParameter("intermediate_performance");
			String filteredSkills = request.getParameter("skills");
			
			MetadataServices metadataServices = new MetadataServices();
			metadataServices.saveVacancyProfile(vacancy.getId(), filteredCities, filteredColleges, filteredUGDegrees, filteredPGDegrees,
					null , "grade cutoffs",  vacancyCategory,
					vacancyPositionType, vacancyExperienceLevel,  vacancyMinSalary,  vacancyMaxSalary);
		}
		
	}

}
