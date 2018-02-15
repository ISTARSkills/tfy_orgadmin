package com.viksitpro.cms.services;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;

public class CourseTreeServices {

	public CourseTreeServices() {
		super();
		// TODO Auto-generated constructor stub
	}

	public static JSONArray getCourseJson() throws JSONException {
		DBUTILS dbutils = new DBUTILS();
		List<Course> courses = (new CourseDAO()).findAll();
		JSONArray carray = new JSONArray();
		for (Course course : courses) {
			JSONObject cobj = new JSONObject();
			JSONArray marray = new JSONArray();
			String sql = "select * from module_course where course_id = " + course.getId();
			List<HashMap<String, Object>> modulz = dbutils.executeQuery(sql);
			for (HashMap<String, Object> modul : modulz) {
				JSONObject mobj = new JSONObject();
				JSONArray sarray = new JSONArray();
				Module module = (new ModuleDAO()).findById(Integer.parseInt(modul.get("module_id").toString()));
				String sql1 = "select * from cmsession_module where module_id =" + module.getId();
				List<HashMap<String, Object>> cmsessioz = dbutils.executeQuery(sql1);
				for (HashMap<String, Object> cmsessio : cmsessioz) {
					JSONObject sobj = new JSONObject();
					JSONArray larray = new JSONArray();
					Cmsession cmsession = (new CmsessionDAO()).findById(Integer.parseInt(cmsessio.get("cmsession_id").toString()));
					String sql2 = "select * from lesson_cmsession where cmsession_id = " + cmsession.getId();
					List<HashMap<String, Object>> lessoz = dbutils.executeQuery(sql2);
					for (HashMap<String, Object> lesso : lessoz) {
						JSONObject lobj = new JSONObject();
						Lesson lesson = (new LessonDAO()).findById(Integer.parseInt(lesso.get("lesson_id").toString()));

						lobj.put("name", "<span class='label label-primary'>" + lesson.getTitle() + "</span>");

						larray.put(lobj);
					}
					sobj.put("name", cmsession.getTitle());
					sobj.put("children", larray);
					sarray.put(sobj);
				}
				mobj.put("name", module.getModuleName());
				mobj.put("children", sarray);
				marray.put(mobj);
			}
			cobj.put("name", course.getCourseName());
			cobj.put("children", marray);
			carray.put(cobj);
		}
		// ViksitLogger.logMSG(this.getClass().getName(),(carray.toString());
		return carray;
	}

	public JSONArray getBatchProgressReport(Course course) throws JSONException {
		JSONArray reports = new JSONArray();
		DBUTILS dbutils = new DBUTILS();
		String sql1 = "select batch.id, batch.batch_group_id,batch_group.college_id  from batch, batch_group where course_id=" + course.getId() + " and batch.batch_group_id=batch_group.id";
		List<HashMap<String, Object>> bgs = dbutils.executeQuery(sql1);
		for (HashMap<String, Object> bg : bgs) {
			int netDurationTaught = 0;
			JSONObject report = new JSONObject();
			BatchGroup bgrp = (new BatchGroupDAO()).findById(Integer.parseInt(bg.get("batch_group_id").toString()));
			Organization college = (new OrganizationDAO()).findById(Integer.parseInt(bg.get("college_id").toString()));
			String sql2 = "select DISTINCT(lesson_id) from event_log where batch_group_id = " + bg.get("batch_group_id").toString() + " and event_type = 'SLIDE_CHANGED' and course_id = 3";
			List<HashMap<String, Object>> lessonzTaught = dbutils.executeQuery(sql2);
			for (HashMap<String, Object> lessonTaught : lessonzTaught) {
				try {
					Lesson lesson = (new LessonDAO()).findById(Integer.parseInt(lessonTaught.get("lesson_id").toString()));
					netDurationTaught += lesson.getDuration();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			HashMap<String, Object> lastLesson = getLastLessonTaught(bgrp, course);
			int lastLessonID = 0;
			String lastLessonName = "No Lessons Taught!";
			if (lastLesson.size() > 0) {
				Lesson lesson = (new LessonDAO()).findById(Integer.parseInt(lastLesson.get("lesson_id").toString()));
				lastLessonID = lesson.getId();
				lastLessonName = lesson.getTitle();
			}
			List<HashMap<String, Object>> trainers = getTrainersforCourseandBatch(course, Integer.parseInt(bg.get("id").toString()));
			String trainerNames = "";
			if (trainers.size() > 0) {
				for (HashMap<String, Object> t : trainers) {
					IstarUser trainer = (new IstarUserDAO()).findById(Integer.parseInt(t.get("trainer_id").toString()));
					trainerNames = trainerNames + trainer.getUserProfile().getFirstName() + ",";
				}
				trainerNames = trainerNames.substring(0, (trainerNames.length() - 1));
			} else {
				trainerNames = "NA";
			}
			report.put("batchID", bg.get("id"));
			report.put("bgName", bgrp.getName());
			report.put("collName", college.getName());
			report.put("totalLessons", getLessonCount(course));
			report.put("lessonsTaught", lessonzTaught.size());
			report.put("netDurationTaught", netDurationTaught);
			report.put("netDuration", getLessonDurationCount(course));
			report.put("lastLessonID", lastLessonID);
			report.put("lastLessonName", lastLessonName);
			report.put("trainerNames", trainerNames);
			reports.put(report);
		}
		return reports;
	}

	public static int getLessonCount(Course course) {
		Set<Integer> lessonIDs = new HashSet<>();
		for (Module module : course.getModules()) {
			if (!module.getIsDeleted()) {
				for (Cmsession cmsession : module.getCmsessions()) {
					if (!module.getIsDeleted()) {
						for (Lesson lesson : cmsession.getLessons()) {
							if (!(lesson.getIsDeleted()) && !(lesson.getType().equalsIgnoreCase("ASSESSMENT")) && (lesson.getIsPublished())) {
								lessonIDs.add(lesson.getId());
							}
						}
					}
				}
			}
		}
		return lessonIDs.size();
	}

	public static int getLessonDurationCount(Course course) {
		int count = 0;
		for (Module module : course.getModules()) {
			if (!module.getIsDeleted()) {
				for (Cmsession cmsession : module.getCmsessions()) {
					if (!module.getIsDeleted()) {
						for (Lesson lesson : cmsession.getLessons()) {
							if (!(lesson.getIsDeleted()) && !(lesson.getType().equalsIgnoreCase("ASSESSMENT")) && (lesson.getIsPublished())) {
								count += lesson.getDuration();
							}
						}
					}
				}
			}
		}
		return count;
	}

	public static HashMap<String, Object> getLastLessonTaught(BatchGroup batchGroup, Course course) {
		String sql = "select * from event_log where batch_group_id = " + batchGroup.getId() + " and event_type = 'SLIDE_CHANGED' and course_id = " + course.getId() + " ORDER BY created_at desc  limit 1";
		List<HashMap<String, Object>> lastEventLogEntry = (new DBUTILS()).executeQuery(sql);
		if (lastEventLogEntry.size() > 0) {
			return (lastEventLogEntry.get(0));
		} else {
			return (new HashMap<String, Object>());
		}
	}

	public JSONObject totStatus(Course course) throws JSONException {
		JSONObject totCourseStatus = new JSONObject();
		List<HashMap<String, Object>> trainers = getTrainersforCourse(course);
		int trainerSize = trainers.size();
		if (trainerSize > 0) {
			for (HashMap<String, Object> t : trainers) {
				IstarUser trainer = (new IstarUserDAO()).findById(Integer.parseInt(t.get("trainer_id").toString()));
				JSONArray totlessons = getUserBrowsedLessons(course, trainer);
				totCourseStatus.put(trainer.getId().toString(), totlessons);
			}
		}
		return totCourseStatus;
	}

	private static JSONArray getUserBrowsedLessons(Course course, IstarUser trainer) {
		JSONArray lessons = new JSONArray();
		String sql = "select DISTINCT(lesson_id) from user_session_log where user_id = " + trainer.getId() + " and course_id = " + course.getId() + "";
		List<HashMap<String, Object>> lessonsBrowsed = (new DBUTILS()).executeQuery(sql);
		if (lessonsBrowsed.size() > 0) {
			for (HashMap<String, Object> lessonBrowsed : lessonsBrowsed) {
				lessons.put(lessonBrowsed.get("lesson_id"));
			}
		}
		return lessons;
	}

	public static List<HashMap<String, Object>> getTrainersforCourse(Course course) {
		String sql = "SELECT DISTINCT(trainer_id) FROM event_log WHERE batch_group_id IN (SELECT DISTINCT(batch_group_id) FROM batch WHERE course_id = " + course.getId() + ")";
		List<HashMap<String, Object>> trainers = (new DBUTILS()).executeQuery(sql);
		return trainers;
	}

	public static List<HashMap<String, Object>> getTrainersforCourseandBatch(Course course, int batch_id) {
		String sql = "SELECT DISTINCT(trainer_id) FROM event_log WHERE course_id = " + course.getId() + " and batch_group_id IN (SELECT DISTINCT(batch_group_id) FROM batch WHERE id = " + batch_id + ")";
		List<HashMap<String, Object>> trainers = (new DBUTILS()).executeQuery(sql);
		return trainers;
	}

	public JSONObject getallLessons(Course course) throws JSONException {
		JSONObject allLessons = new JSONObject();
		for (Module module : course.getModules()) {
			if (!module.getIsDeleted()) {
				for (Cmsession cmsession : module.getCmsessions()) {
					if (!module.getIsDeleted()) {
						for (Lesson lesson : cmsession.getLessons()) {
							if ((!lesson.getIsDeleted()) && !(lesson.getType().equalsIgnoreCase("ASSESSMENT")) && (lesson.getIsPublished())) {
								allLessons.put(lesson.getId().toString(), lesson.getTitle());
							}
						}
					}
				}
			}
		}
		return allLessons;
	}
}
