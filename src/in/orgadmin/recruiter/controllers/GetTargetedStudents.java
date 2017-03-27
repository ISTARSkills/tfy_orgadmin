package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.app.metadata.services.MetadataServices;
import com.istarindia.apps.MetaColumnTypes;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.MetaColumn;
import com.istarindia.apps.dao.MetaColumnDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.dao.VacancyProfile;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class FilterStudents
 */
@WebServlet("/getTargetedStudents")
public class GetTargetedStudents extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

    public GetTargetedStudents() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
				+ request.getContextPath() + "/";
		
		updateVacancyMetaData(request);
		
		
		String filtersql = getFilterSQL(request);
		
		System.out.println(filtersql);
		
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>>students= util.executeQuery(filtersql);
		
		
		StringBuffer sb = new StringBuffer();
		String vacancy_id = request.getParameter("vacancy_idd");
		
		String stage_id = "none"; // if not filtering from dashboard(i.e targetting)
		
		if(request.getParameterMap().containsKey("filter_stage_id"))
		{
			stage_id = request.getParameter("filter_stage_id");
		}
		StudentDAO studao = new StudentDAO();
		sb.append("<div class='feed-activity-list' style='max-height: 1000px; overflow-y: auto; overflow-x: hidden;'>");
		
			for (HashMap<String, Object> row : students) {
				int stu_id=(int)row.get("id");
				Student st = studao.findById(stu_id);
				sb.append("<div"); 
				sb.append(" data-vacancy_id="+vacancy_id+" class='feed-element student_holder_actor row' data-stage_id="+vacancy_id+"--"+stage_id+" data-stage="+stage_id+" id='"+st.getId()+"'>");
				
				if(stage_id.equalsIgnoreCase("none"))
				{
					// html for create vacancy target page
					sb.append("<div class='row'>");				
					sb.append("<div class='col-md-2'>");
					sb.append("<a class='pull-left' style='    margin-left: 27px;'> <img alt='image' class='img-circle' src='"+st.getImageUrl()+"'></a>");
					sb.append("</div>");				
					sb.append("<div class='col-md-10'></div>");
					sb.append("<div class='media-body' style='    padding-left: 31px;width: 340px;'>");
					sb.append("<strong class='student_name'>"+st.getName()+"</strong>");
					sb.append("<br> <small class='text-muted organization_name'>"+st.getCollege().getName()+"</small>");
					sb.append("<br> <small class='text-muted batch_name_name'>"+st.getStudentProfileData().getUnderGraduationSpecializationName()+"</small>");
					sb.append("</div>");
					sb.append("</div>");
					
				}
				else
				{
					//html for dash board page
					sb.append("<div class='col-md-1'>");
					sb.append("<label> <input type='checkbox' class='i-checks pull-left "+vacancy_id+" "+stage_id+"' data-student_id='"+st.getId()+"' name='send_msg' id=''></label>");
					sb.append("</div>");
					
					sb.append("<div class='col-md-11'>");
					
					sb.append("<a class='pull-left'> <img alt='image' class='img-circle' src='"+st.getImageUrl()+"'></a>");
					
					sb.append("<div class='media-body' style='    padding-left: 15px;width: 340px;'>");
					sb.append("<strong class='student_name'>"+st.getName()+"</strong>");
					sb.append("<br> <small class='text-muted organization_name'>"+st.getCollege().getName()+"</small>");
					sb.append("<br> <small class='text-muted batch_name_name'>"+st.getStudentProfileData().getUnderGraduationSpecializationName()+"</small>");
					sb.append("</div>");
					
					sb.append("<div style='float: right; margin-top: -55px; margin-right: 5px;'>");
					sb.append("<i class='fa fa-wechat chat_box chat_box11111' style='font-size: 35px; float: right;' id='student_chat_box"+vacancy_id+"--"+stage_id+"--"+st.getId()+"'></i>");				
					sb.append("</div>");
					
					sb.append("</div>");					
				}
				sb.append("</div>");
			}		
		sb.append("</div>");
		response.getWriter().print(sb);
	}

	private String getFilterSQL(HttpServletRequest request) {
		
		StringBuffer sb = new StringBuffer();
		System.out.println("TEST");
		//int vacancy_id =Integer.parseInt(request.getParameter("vacancy_idd"));
		sb.append("select distinct student.id from student, student_profile_data, pincode, address, college where student.id = student_profile_data.student_id and student.address_id = address.id and address.pincode_id = pincode.id and student.organization_id = college.id and student.user_type='STUDENT'");
		
		if(!request.getParameter("filtered_cities").toString().equalsIgnoreCase("none"))
		{
			// add city search query only if city parameters are sent.
			sb.append(getCitySearchPart(request));					
			
		}
		if(!request.getParameter("filtered_colleges").toString().equalsIgnoreCase("none"))
		{
			sb.append(getCollegeSearchPart(request));
		}
		
		if(!request.getParameter("filtered_ug_degrees").toString().equalsIgnoreCase("none"))
		{
			sb.append(getUGSearchPart(request));
		}
		
		if(!request.getParameter("filtered_pg_degrees").toString().equalsIgnoreCase("none"))
		{
			sb.append(getPGSearchPart(request));
		}

		if(!request.getParameter("filtered_ug_specializations").toString().equalsIgnoreCase("none"))
		{
			sb.append(getUGSpecializations(request));
		}
		
		if(!request.getParameter("filtered_pg_specializations").toString().equalsIgnoreCase("none"))
		{
			sb.append(getPGSpecializations(request));
		}
		
		/*for ug grade cutoff*/
		if(!request.getParameter("grade_cutoff").toString().equalsIgnoreCase("none") && request.getParameter("filtered_ug_degrees").toString().equalsIgnoreCase("none"))
		{
			sb.append(getUGGradeCutoffPart(request));
		}
		
		/*for pg grade cutoff*/
		if(!request.getParameter("grade_cutoff").toString().equalsIgnoreCase("none") && request.getParameter("filtered_pg_degrees").toString().equalsIgnoreCase("none"))
		{
			sb.append(getPGGradeCutoffPart(request));
		}
		
		
		if(!request.getParameter("skill_ids").toString().equalsIgnoreCase("none"))
		{
			sb.append(getSkillSerachPart(request));
		}
	
		return sb.toString();
	}

	private String getSkillSerachPart(HttpServletRequest request) {
		
		HashMap<Integer, String> skill_percentile_hashmap = getSkillKeyValueHashMap(request);
		StringBuffer sb = new StringBuffer();
		sb.append(" and student.id in (select distinct student_id as id from (");
		
		sb.append("WITH summary AS (	SELECT	 		P .student_id, 		P .timestamp, 		P .skill_id, 		P .percentile_country, 		ROW_NUMBER () OVER ( 			PARTITION BY P.student_id,P.skill_id 			ORDER BY 				P .timestamp DESC 		) AS rk 	FROM 		skill_precentile P )");	
		int i=1;
		for(int skill_id : skill_percentile_hashmap.keySet())
		{
			String table_alias= "s"+i;
			String sql =" ( SELECT 	"+table_alias+".* FROM 	summary "+table_alias+" WHERE 	"+table_alias+".rk = 1 and "+table_alias+".skill_id =0  and "+table_alias+".percentile_country  "+skill_percentile_hashmap.get(skill_id)+"	 )";
			i++;
			if(i<skill_percentile_hashmap.size())
			{
				sql+=" union ";
			}
			sb.append(sql);
		}
		sb.append(") TFINAL)");		
		return sb.toString();
	}

	private String getUGGradeCutoffPart(HttpServletRequest request) {
		String grade_cutoff = request.getParameter("grade_cutoff");
		String ug_parameter_value=" and student_profile_data.post_gradution_marks "+grade_cutoff;
		return ug_parameter_value;
	}

	private String getPGGradeCutoffPart(HttpServletRequest request) {
		String grade_cutoff = request.getParameter("grade_cutoff");
		String pg_parameter_value=" and student_profile_data.under_gradution_marks "+grade_cutoff;
		return pg_parameter_value;
	}
	
	private String getPGSpecializations(HttpServletRequest request)
	{ 
		String specialization = request.getParameter("filtered_pg_specializations");
		String specialization_val = " and student_profile_data.post_graduation_specialization_name in (";
		for(String str: specialization.split("!#")){
			String specialization_name = "'"+str.trim()+"'"; 
			specialization_val+=specialization_name+",";			
		}
		if(specialization_val.endsWith(",")){
			specialization_val = specialization_val.substring(0, specialization_val.length()-1);
		}	
		specialization_val+=")";
		return specialization;
	}
	
	
	private String getUGSpecializations(HttpServletRequest request)
	{ 
		String specialization = request.getParameter("filtered_ug_specializations");
		String specialization_val = " and student_profile_data.under_graduation_specialization_name in (";
		for(String str: specialization.split("!#")){
			String specialization_name = "'"+str.trim()+"'"; 
			specialization_val+=specialization_name+",";			
		}
		if(specialization_val.endsWith(",")){
			specialization_val = specialization_val.substring(0, specialization_val.length()-1);
		}	
		specialization_val+=")";
		return specialization;
	}
	
	
	private String getPGSearchPart(HttpServletRequest request) {
		String  filtered_pg_degrees =  request.getParameter("filtered_pg_degrees");
		String pg_degree_value=" and student_profile_data.pg_degree_name in (";
		for(String str :filtered_pg_degrees.split("!#"))
		{			
			String city_name="'"+str.trim()+"'"; 
			pg_degree_value+=city_name+",";
		}
		if (pg_degree_value.endsWith(",")) {
			pg_degree_value = pg_degree_value.substring(0, pg_degree_value.length()-1);
		}
		pg_degree_value+=")";
		return pg_degree_value;
	}

	private String getUGSearchPart(HttpServletRequest request) {
		String  filtered_ug_degrees =  request.getParameter("filtered_ug_degrees");
		
		String ug_degree_value=" and student_profile_data.under_graduate_degree_name in (";
		for(String str :filtered_ug_degrees.split("!#"))
		{			
			String city_name="'"+str.trim()+"'"; 
			ug_degree_value+=city_name+",";
		}
		if (ug_degree_value.endsWith(",")) {
			ug_degree_value = ug_degree_value.substring(0, ug_degree_value.length()-1);
		}
		ug_degree_value+=")";
		return ug_degree_value;
	}

	private String getCollegeSearchPart(HttpServletRequest request) {
		
		String  filtered_colleges_id =  request.getParameter("filtered_colleges");
		String college_parameter_value=" and college.id in (";
		for(String str :filtered_colleges_id.split("!#"))
		{			
			String college_id=str.trim(); 
			college_parameter_value+=college_id+",";
		}
		if (college_parameter_value.endsWith(",")) {
			college_parameter_value = college_parameter_value.substring(0, college_parameter_value.length()-1);
		}
		college_parameter_value+=")";
		return college_parameter_value;
	}

	private String getCitySearchPart(HttpServletRequest request) {
		String filtered_cities =  request.getParameter("filtered_cities");
		String city_parameter_value=" and pincode.city in (";
		for(String str :filtered_cities.split("!#"))
		{			
			String city_name="'"+str.trim()+"'"; 
			city_parameter_value+=city_name+",";
		}
		if (city_parameter_value.endsWith(",")) {
			city_parameter_value = city_parameter_value.substring(0, city_parameter_value.length()-1);
		}
		city_parameter_value+=")";	
		return city_parameter_value;
	}

	private void updateVacancyMetaData(HttpServletRequest request) {
		
		if(!request.getParameter("vacancy_idd").toString().equalsIgnoreCase("none"))
		{
			
			String vacancy_idd =  request.getParameter("vacancy_idd");	
			Vacancy vv= new VacancyDAO().findById(Integer.parseInt(vacancy_idd));
			VacancyProfile vp = vv.getVacancyProfile();
			String vacancy_category ="none";
			String vacancy_position_type="none";
			String vacancy_experience_level="none";
			String vacancy_min_salary ="none";
			String vacancy_max_salary ="none";
			
			if(vp!=null)
			{
				vacancy_category= (vp.getVacancy_category()!=null) ? vp.getVacancy_category(): "none";
				vacancy_position_type= (vp.getVacancy_position_type()!=null) ? vp.getVacancy_position_type(): "none";
				vacancy_experience_level= (vp.getVacancy_experience_level()!=null) ? vp.getVacancy_experience_level(): "none";
				vacancy_min_salary= (vp.getVacancy_min_salary()!=null) ? vp.getVacancy_min_salary(): "none";
				vacancy_max_salary= (vp.getVacancy_max_salary()!=null) ? vp.getVacancy_max_salary(): "none";
			}
			
			String filtered_cities =  request.getParameter("filtered_cities");
			String  filtered_colleges_id =  request.getParameter("filtered_colleges");
			String  filtered_ug_degrees =  request.getParameter("filtered_ug_degrees");
			String  filtered_pg_degrees =  request.getParameter("filtered_pg_degrees");
			String filtered_ug_specializations = request.getParameter("filtered_ug_specializations");
			String filtered_pg_specializations = request.getParameter("filtered_pg_specializations"); //To be added in VacancyProfile Metadata
			
			String grade_cutoff = request.getParameter("grade_cutoff");
			HashMap<Integer, String> skill_percentile_hashmap = getSkillKeyValueHashMap(request);
			
			MetadataServices services = new MetadataServices();
			services.saveVacancyProfile(vv.getId(), filtered_cities, filtered_colleges_id, filtered_ug_degrees, filtered_pg_degrees,
					skill_percentile_hashmap , grade_cutoff,  vacancy_category,
					 vacancy_position_type, vacancy_experience_level,  vacancy_min_salary,  vacancy_max_salary);
			
			
		}
		
	}

	private HashMap<Integer, String> getSkillKeyValueHashMap(HttpServletRequest request) {
		HashMap<Integer, String> skill_percentile_hashmap = new HashMap<>();		
		String skill_ids =  request.getParameter("skill_ids");
		String skill_percentile = request.getParameter("skill_percentile");
		if(!request.getParameter("skill_selector").toString().equalsIgnoreCase("none"))
		{
			String skill_percentile_arr[] = skill_percentile.split("!#");
			String skill_id_arr[] = skill_ids.split("!#");			
			int i=0;
			if(skill_id_arr.length>0)
			{
				for(String str : skill_id_arr)
				{
					skill_percentile_hashmap.put(Integer.parseInt(skill_id_arr[i]), skill_percentile_arr[i]);
					i++;
				}
			}
		}
		return skill_percentile_hashmap;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
