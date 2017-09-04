package com.talentify.admin.services;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportList;
import in.talentify.core.utils.CMSRegistry;

public class AdminUIServices {
	private DBUTILS db = new DBUTILS();

	public ArrayList<BatchGroup> getBatchGroupInCollege(int college_id) {
		BatchGroupDAO dao = new BatchGroupDAO();
		ArrayList<BatchGroup> batchGroup = new ArrayList<>();
		Organization org = new OrganizationDAO().findById(college_id);
		batchGroup.addAll(org.getBatchGroups());
		return batchGroup;
	}

	public ArrayList<Course> getCoursesInCollege(int college_id) {
		CourseDAO dao = new CourseDAO();

		ArrayList<Course> courses = new ArrayList<>();
		ArrayList<Integer> alreadyAddedCourses = new ArrayList<>();
		Organization org = new OrganizationDAO().findById(college_id);
		for (BatchGroup bg : org.getBatchGroups()) {
			for (Batch batch : bg.getBatchs()) {
				if (!alreadyAddedCourses.contains(batch.getCourse().getId())) {
					alreadyAddedCourses.add(batch.getCourse().getId());
					courses.add(batch.getCourse());
				}
			}
		}

		return courses;

	}

	public StringBuffer getRolesofOrganization(int orgId, ArrayList<Integer> selectedOrgs) {
		// <option value="">Data Analytics</option>
		String sql = "SELECT DISTINCT 	batch_group. ID, 	batch_group. NAME FROM 	batch_group WHERE 	batch_group.college_id ="
				+ orgId + " ORDER BY name";

		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {

			if (selectedOrgs != null) {
				out.append("<option " + checkAlreadyExist(selectedOrgs, (int) item.get("id")) + "  value='"
						+ item.get("id") + "'>" + item.get("name") + "</option>");
			} else {
				out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
			}
		}
		out.append("");
		return out;
	}

	private String checkAlreadyExist(ArrayList<Integer> selected, int object) {
		if (selected.contains(object)) {
			return "selected";
		} else {
			return "";
		}
	}

	public StringBuffer getCompetitionGraph(HashMap<String, String> conditions) {
		DBUTILS dbutils = new DBUTILS();
		StringBuffer out = new StringBuffer();

		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_" + id + "' ></div> ");
		out.append(
				"<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"
						+ id
						+ "' data-y_axis_title='Average Adjusted Score' data-report_title='Competetive Performance with Other Organizations' "
						+ " data-graph_holder='container" + id + "' id='chart_datatable_" + id + "'");
		out.append(" data-graph_type='column'>");
		int col_id = Integer.parseInt(conditions.get("college_id"));
		Organization org = new OrganizationDAO().findById(col_id);
		out.append("<thead><tr><th></th><th>" + org.getName() + "</th><th>Other Colleges</th></tr></thead>");
		out.append("<tbody>");

		CustomReport report2 = getReport(3);
		String sql2 = report2.getSql();
		for (String key : conditions.keySet()) {
			sql2 = sql2.replaceAll(":" + key, conditions.get(key));
		}
		String avgeScoreForCurrentCollege = sql2;
		List<HashMap<String, Object>> avgScoreData = dbutils.executeQuery(avgeScoreForCurrentCollege);
		CustomReport report4 = getReport(4);
		String sql4 = report4.getSql();
		for (String key : conditions.keySet()) {
			sql4 = sql4.replaceAll(":" + key, conditions.get(key));
		}

		String avgScoreForOtherCollege = sql4;
		List<HashMap<String, Object>> avgScoreDataForOtherCollege = dbutils.executeQuery(avgScoreForOtherCollege);

		HashMap<Integer, Integer> currentCollegeCourseAvgScoreMap = new HashMap<>();
		HashMap<Integer, Integer> otherCollegeCourseAvgScoreMap = new HashMap<>();
		for (HashMap<String, Object> row : avgScoreData) {
			int course_id = (int) row.get("course_id");
			int avg_score = (int) row.get("avg_score");
			int collId = (int) row.get("college_id");

			currentCollegeCourseAvgScoreMap.put(course_id, avg_score);

		}

		for (HashMap<String, Object> row : avgScoreDataForOtherCollege) {
			int course_id = (int) row.get("course_id");
			int avg_score = (int) row.get("avg_score");
			otherCollegeCourseAvgScoreMap.put(course_id, avg_score);
		}

		CustomReport report1 = getReport(2);
		String sql9 = report1.getSql();
		for (String key : conditions.keySet()) {
			sql9 = sql9.replaceAll(":" + key, conditions.get(key));
		}
		String coursesInCollege = sql9;
		List<HashMap<String, Object>> CoursesInCollege = dbutils.executeQuery(coursesInCollege);
		for (HashMap<String, Object> row : CoursesInCollege) {
			int course_id = (int) row.get("id");
			out.append("<tr>");
			out.append("<td>" + row.get("course_name") + "</td>");
			int currentCollegeScore = 0;
			if (currentCollegeCourseAvgScoreMap.containsKey(course_id)) {
				currentCollegeScore = currentCollegeCourseAvgScoreMap.get(course_id);
			}
			int otherCollegeScore = 0;
			if (otherCollegeCourseAvgScoreMap.containsKey(course_id)) {
				otherCollegeScore = otherCollegeCourseAvgScoreMap.get(course_id);
			}
			out.append("<td>" + currentCollegeScore + "</td>");
			out.append("<td>" + otherCollegeScore + "</td>");
			out.append("</tr>");
		}

		out.append("</tbody></table>");

		return out;
	}

	public CustomReport getReport(int reportID) {
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

}
