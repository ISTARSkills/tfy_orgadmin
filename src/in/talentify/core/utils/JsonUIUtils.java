package in.talentify.core.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import com.viksitpro.core.utilities.DBUTILS;

public class JsonUIUtils {

	public ArrayList<JSONArray> getBarChartData(int course_id, int college_id, String type) {
		DBUTILS db = new DBUTILS();
		String sql = "";
		ArrayList<JSONArray> arrayList = new ArrayList<>();

		if (type.equalsIgnoreCase("Program")) {
			sql = "SELECT DISTINCT 	skill_objective.name as skill_title, 	rookie, 	master, 	apprentice, 	wizard FROM 	mastery_level_per_course, 	skill_objective WHERE 	course_id = "
					+ course_id + " AND college_id = " + college_id
					+ " AND skill_objective.id = mastery_level_per_course.skill_id AND ( 	rookie != '0' 	AND master != '0' 	AND apprentice != '0' 	AND wizard != '0' )";
		} else {
			sql = "SELECT DISTINCT 	skill_objective. NAME as skill_title, 	rookie, 	master, 	apprentice, 	wizard FROM 	mastery_level_per_course, 	skill_objective, 	batch WHERE 	batch.batch_group_id = mastery_level_per_course.batch_group_id AND batch.course_id = "
					+ course_id + " AND college_id = " + college_id
					+ " AND skill_objective. ID = mastery_level_per_course.skill_id AND ( 	rookie != '0' 	AND master != '0' 	AND apprentice != '0' 	AND wizard != '0' )";
		}

		List<HashMap<String, Object>> data = db.executeQuery(sql);

		HashMap<String, Float> rookie_map = new HashMap<>();
		HashMap<String, Float> master_map = new HashMap<>();
		HashMap<String, Float> apprentice_map = new HashMap<>();
		HashMap<String, Float> wizard_map = new HashMap<>();

		JSONArray titles = new JSONArray();
		JSONArray contentArry = new JSONArray();

		for (HashMap<String, Object> hashMap : data) {
			titles.put(hashMap.get("skill_title"));
			float rookie_val = Float.parseFloat(hashMap.get("rookie").toString());
			float master_val = Float.parseFloat(hashMap.get("master").toString());
			float apprentice_val = Float.parseFloat(hashMap.get("apprentice").toString());
			float wizard_val = Float.parseFloat(hashMap.get("wizard").toString());
			rookie_map.put(hashMap.get("skill_title").toString(), rookie_val);
			master_map.put(hashMap.get("skill_title").toString(), master_val);
			apprentice_map.put(hashMap.get("skill_title").toString(), apprentice_val);
			wizard_map.put(hashMap.get("skill_title").toString(), wizard_val);
		}

		JSONObject rookie = new JSONObject();
		
		JSONObject master = new JSONObject();
		try {
			JSONArray dataArry = new JSONArray();
			for (String key : master_map.keySet()) {
				float total = rookie_map.get(key) + master_map.get(key) + apprentice_map.get(key) + wizard_map.get(key);
				dataArry.put((master_map.get(key) / total) * 100);
			}
			master.put("name", "Master");
			master.put("data", dataArry);
		} catch (Exception e) {
		}

		JSONObject wizard = new JSONObject();
		try {
			JSONArray dataArry = new JSONArray();
			for (String key : wizard_map.keySet()) {
				float total = rookie_map.get(key) + master_map.get(key) + apprentice_map.get(key) + wizard_map.get(key);
				dataArry.put((wizard_map.get(key) / total) * 100);
			}
			wizard.put("name", "Wizard");
			wizard.put("data", dataArry);
		} catch (Exception e) {
		}
		try {
			JSONArray dataArry = new JSONArray();
			for (String key : rookie_map.keySet()) {
				float total = rookie_map.get(key) + master_map.get(key) + apprentice_map.get(key) + wizard_map.get(key);
				dataArry.put((rookie_map.get(key) / total) * 100);
			}
			rookie.put("name", "Rookie");
			rookie.put("data", dataArry);
		} catch (Exception e) {
		}

		JSONObject apprentice = new JSONObject();
		try {
			JSONArray dataArry = new JSONArray();
			for (String key : apprentice_map.keySet()) {
				float total = rookie_map.get(key) + master_map.get(key) + apprentice_map.get(key) + wizard_map.get(key);
				dataArry.put((apprentice_map.get(key) / total) * 100);
			}
			apprentice.put("name", "Apprentice");
			apprentice.put("data", dataArry);
		} catch (Exception e) {
		}

		
		contentArry.put(master);
		contentArry.put(wizard);
		contentArry.put(rookie);
		contentArry.put(apprentice);
		arrayList.add(titles);
		arrayList.add(contentArry);

		return arrayList;

	}

	public JSONArray getPieChartData(int course_id, int college_id, String type) {
		String sql = "";
		if (type.equalsIgnoreCase("Program")) {

			sql = "SELECT DISTINCT 	course_id, 	college_id, 	AVG (cast(NULLIF (master,0) as INTEGER)) AS master, 	AVG (cast(NULLIF (rookie,0) as INTEGER)) AS rookie, 	AVG (cast(NULLIF (apprentice,0) as INTEGER)) AS apprentice, 	AVG (cast(NULLIF (wizard,0) as INTEGER)) AS wizard FROM 	mastery_level_per_course WHERE 	course_id = "
					+ course_id + " AND college_id = " + college_id + " GROUP BY 	course_id, 	college_id";
		} else {
			sql = "SELECT DISTINCT 	mastery_level_per_course.batch_group_id, 	mastery_level_per_course.college_id, 	AVG (cast(NULLIF (master,0) as INTEGER)) AS master, 	AVG (cast(NULLIF (rookie,0) as INTEGER)) AS rookie, 	AVG (cast(NULLIF (apprentice,0) as INTEGER)) AS apprentice, 	AVG (cast(NULLIF (wizard,0) as INTEGER)) AS wizard FROM 	mastery_level_per_course,batch WHERE 	batch.id="
					+ course_id
					+ " and batch.batch_group_id = mastery_level_per_course.batch_group_id  AND college_id = "
					+ college_id
					+ " GROUP BY 	mastery_level_per_course.batch_group_id, 	mastery_level_per_course.college_id";

		}
		DBUTILS db = new DBUTILS();
		ArrayList<PieChartJson> pie = new ArrayList<>();
		//ViksitLogger.logMSG(this.getClass().getName(),"22 - > " + sql);

		List<HashMap<String, Object>> data = db.executeQuery(sql);
		for (HashMap<String, Object> item : data) {

			try {
				PieChartJson json = new PieChartJson();
				json.setName("Master");
				json.setY(Float.parseFloat(item.get("master").toString()));
				pie.add(json);
				PieChartJson json1 = new PieChartJson();
				json1.setName("Wizard");
				json1.setY(Float.parseFloat(item.get("wizard").toString()));
				pie.add(json1);
				
				PieChartJson json2 = new PieChartJson();
				json2.setName("Rookie");
				json2.setY(Float.parseFloat(item.get("rookie").toString()));
				pie.add(json2);
				PieChartJson json3 = new PieChartJson();
				json3.setName("Apprentice");
				json3.setY(Float.parseFloat(item.get("apprentice").toString()));
				pie.add(json3);
				
			} catch (Exception e) {

				pie = null;
			}
		}
		JSONArray result = new JSONArray(pie);
		return result;
	}

	private ArrayList<Float> converttoFloatArray(String input) {
		String[] temp = input.split(",");
		ArrayList<Float> values = new ArrayList<Float>();
		for (int i = 0; i < temp.length; i++) {
			try {
				values.add(Float.parseFloat(temp[i]));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return values;
	}

	public int getStudentCountfromCourse(int course_id, int college_id, String type) {

		String sql = "";
		if (type.equalsIgnoreCase("Program")) {
			sql = "SELECT 	COUNT (DISTINCT s. ID) AS COUNT FROM 	batch b, 	batch_students bs, 	batch_group bg, 	istar_user s WHERE 	bs.student_id = s. ID AND bg. ID = b.batch_group_id AND bg. ID = bs.batch_group_id AND bg.college_id = " 					+ college_id + " AND b.course_id = " + course_id + "";
		} else {
			sql = "select   count(DISTINCT s.id) as count  from batch b , batch_students bs, batch_group bg, istar_user s where  bs.student_id = s.id and bg.id = b.batch_group_id and bg.id = bs.batch_group_id and bg.college_id = "
					+ college_id + " and b.id = " + course_id + "";
		}
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return Integer.parseInt(data.get(0).get("count").toString());

	}

	public List<HashMap<String, Object>> getStudentlistfromCourse(int id, int college_id, String type) {
		String sql = "";
		DBUTILS db = new DBUTILS();

		if (type.equalsIgnoreCase("Program")) {
			sql = "SELECT DISTINCT 	s. ID AS student_id, 	sp.first_name, 	s.mobile, 	s.email, 	COALESCE ( 		NULLIF (sp.last_name, ''), 		'Not Available' 	) AS lastname, 	COALESCE ( 		NULLIF (CAST(sp.dob AS VARCHAR), ''), 		'Not Available' 	) AS dob, 	CASE WHEN ( 	sp.gender IS NULL 	OR sp.gender LIKE '%null%' ) THEN 	CASE WHEN (sp.gender IS NULL) THEN 	'NA' ELSE 	sp.gender END ELSE 	sp.gender END AS gender,  CASE WHEN sp.profile_image LIKE 'null' OR sp.profile_image IS NULL THEN 	(select property_value from constant_properties where property_name ='media_url_path' )||'users/' || UPPER ( 		SUBSTRING (sp.first_name FROM 1 FOR 1) 	) || '.png' WHEN sp.profile_image LIKE '%graph.facebook.com%' 		ThEN 			sp.profile_image ELSE 	(select property_value from constant_properties where property_name ='media_url_path' ) || sp.profile_image END AS profile_image,  col. NAME AS college_name FROM 	batch b, 	batch_students bs, 	batch_group bg, 	istar_user s, 	user_profile sp, 	professional_profile pf, 	organization col WHERE 	bs.student_id = s. ID AND bg. ID = b.batch_group_id AND bg. ID = bs.batch_group_id AND bg.college_id = "+college_id+" AND b.course_id = "+id+" AND sp.user_id = s. ID AND col. ID = bg.college_id ORDER BY 	sp.first_name LIMIT 6 ";
		} else {
			sql = "SELECT DISTINCT 	s. ID AS student_id, 	sp.first_name, 	s.mobile, 	s.email, 	COALESCE ( 		NULLIF (sp.last_name, ''), 		'Not Available' 	) AS lastname, 	COALESCE ( 		NULLIF (CAST(sp.dob AS VARCHAR), ''), 		'Not Available' 	) AS dob, 	CASE WHEN ( 	sp.gender IS NULL 	OR sp.gender LIKE '%null%' ) THEN 	CASE WHEN (sp.gender IS NULL) THEN 	'NA' ELSE 	sp.gender END ELSE 	sp.gender END AS gender,  CASE WHEN sp.profile_image LIKE 'null' OR sp.profile_image IS NULL THEN 	(select property_value from constant_properties where property_name ='media_url_path' )||'/users/' || UPPER ( 		SUBSTRING (sp.first_name FROM 1 FOR 1) 	) || '.png' WHEN sp.profile_image LIKE '%graph.facebook.com%' 		ThEN 			sp.profile_image ELSE 	(select property_value from constant_properties where property_name ='media_url_path' ) || sp.profile_image  END AS profile_image,  col. NAME AS college_name FROM 	batch b, 	batch_students bs, 	batch_group bg, 	istar_user s, 	user_profile sp, 	professional_profile pf, 	organization col WHERE 	bs.student_id = s. ID AND bg. ID = b.batch_group_id AND bg. ID = bs.batch_group_id AND bg.college_id = "+college_id+" AND b. ID = "+id+" AND sp.user_id = s. ID AND col. ID = bg.college_id ORDER BY 	sp.first_name LIMIT 6";
		}

		//ViksitLogger.logMSG(this.getClass().getName(),sql);
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		//ViksitLogger.logMSG(this.getClass().getName(),"Hashmap size is " + data.size());
		return data;
	}

	public StringBuffer getAttendanceReport(int course_id, String type) {
		DBUTILS db = new DBUTILS();
		StringBuffer out = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

		String sql = "";
		if (type.equalsIgnoreCase("Program")) {
			sql = "SELECT 	 attendance_stats.created_at,attendance_stats.percentage_attendance AS attendance, 	batch. NAME AS batchname FROM 	attendance_stats, 	batch WHERE 	attendance_stats.course_id = "
					+ course_id
					+ " AND batch.batch_group_id = attendance_stats.batch_group_id AND attendance_stats.percentage_attendance != 0  GROUP BY 	attendance_stats.created_at,attendance_stats.percentage_attendance,batch. NAME order by attendance_stats.created_at ";
		} else {
			sql = "SELECT 	 attendance_stats.created_at,attendance_stats.percentage_attendance AS attendance, 	batch. NAME AS batchname FROM 	attendance_stats, 	batch WHERE 	batch.id = "
					+ course_id
					+ " AND batch.batch_group_id = attendance_stats.batch_group_id AND attendance_stats.percentage_attendance != 0  GROUP BY 	attendance_stats.created_at,attendance_stats.percentage_attendance,batch. NAME order by attendance_stats.created_at";
		}
		//ViksitLogger.logMSG(this.getClass().getName(),"111- > " + sql);
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		ArrayList<BarChartJson> attendence_list = new ArrayList<>();
		for (HashMap<String, Object> item : data) {
			try {
				out.append("<tr>");
				out.append("<td>" + sdf1.format(sdf.parse(item.get("created_at").toString())) + "</td>");
				out.append("<td>" + item.get("attendance") + "</td>");
				out.append("</tr>");
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

		JSONArray result = new JSONArray(attendence_list);
		return out;
	}
}
