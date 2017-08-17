package com.viksitpro.cms.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;

public class CourseServices {

	public Course updateCourseSkillObjectivesDetails(Course course, CourseDAO courseDAO, String[] skillobjectiveids) {
		List<SkillObjective> skillObjectives = course.getSkillObjectives();
		try {
			if(skillObjectives.size()>0){
				skillObjectives.removeAll(skillObjectives);
			}
		} catch (NullPointerException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		CourseServices courseServices = new CourseServices();
		course = courseServices.saveCourseDetails(course, courseDAO);
		for (String skillobjectiveid : skillobjectiveids) {
			try {
				SkillObjective objective = (new SkillObjectiveDAO()).findById(Integer.parseInt(skillobjectiveid));
				skillObjectives.add(objective);
			} catch (NumberFormatException e) {	}
		}
		return course;
	}

	public Course updateCourseModuleDetails(Course course, CourseDAO courseDAO, String[] moduleids) {
		List<Module> modules = course.getModules();
		try {
			if(modules.size()>0){
				modules.removeAll(modules);
			}
		} catch (NullPointerException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		CourseServices courseServices = new CourseServices();
		course = courseServices.saveCourseDetails(course, courseDAO);
		for (String moduleid : moduleids) {
			try {
				Module module = (new ModuleDAO()).findById(Integer.parseInt(moduleid));
				/// System.out.println("<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>"+module.getId()+">>>>"+module.getModuleName());
				modules.add(module);
			} catch (NumberFormatException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
			}
		}
		return course;
	}

	
	// HERE LIE THE SCRIPTS SPECIIC TO COURCE CREATION
	// PLEASE NOTE <<<<<<<<<<<>>>>>>>>>>>>

	public Course createCourseDetailsModule(Course course, CourseDAO courseDAO, String[] moduleids) {
		List<Module> modules = course.getModules();
		for (String moduleid : moduleids) {
			try {
				Module module = (new ModuleDAO()).findById(Integer.parseInt(moduleid));
				modules.add(module);
			} catch (Exception e) {
				// TODO: handle exception
			}

		}
		return course;
	}

	public Course saveCourseDetails(Course course, CourseDAO courseDAO) {
		Session session = null;
		Transaction tx = null;
		try {
			session = courseDAO.getSession();
			tx = session.beginTransaction();
			courseDAO.attachDirty(course);
			tx.commit();
		} catch (Exception ex) {
			ex.printStackTrace();
			tx.rollback();
		} finally {
			//session.flush();
			session.clear();
			session.close();
		}

		return course;
	}

	public Course createCourseDetailsSkillObjectives(Course course, CourseDAO courseDAO, String[] skillobjectiveids) {
		List<SkillObjective> skillObjectives = course.getSkillObjectives();

		for (String skillobjectiveid : skillobjectiveids) {
			try {
				SkillObjective objective = (new SkillObjectiveDAO()).findById(Integer.parseInt(skillobjectiveid));
				skillObjectives.add(objective);
			} catch (NumberFormatException e) {

			}
		}
		return course;
	}

	public static String getSkillTreeForCourse(Course course) {
		HashMap<String, String> skillList = new HashMap<>();
		StringBuffer out = new StringBuffer();
		String course_level_skill_id = "course_level_skill_" + course.getSkillObjectives().get(0).getId();
		// out.append(" root = {},");
		out.append("  " + course_level_skill_id + " = { parent: root,\n");
		out.append("       text:{\n");
		out.append("           name: \"" + course.getCourseName().replaceAll("\\(", "").replaceAll("\\)", "") + "\",\n");
		out.append("            title: \"Course Level Skill\",\n");
		out.append("            contact: \"" + course.getCourseName().replaceAll("\\(", "").replaceAll("\\)", "") + "\"\n");
		out.append("         },\n");
		out.append("       stackChildren: true,\n");
		out.append("       HTMLid: \"" + course_level_skill_id + "\"\n");
		out.append("     },\n\n\n");
		skillList.put(course_level_skill_id, course_level_skill_id);

		for (Module module : course.getModules()) {
			for (SkillObjective skillObjective : module.getSkillObjectives()) {
				String module_level_skill_id = "module_level_skill_" + skillObjective.getId();

				skillList.put(module_level_skill_id, module_level_skill_id);

				out.append("  " + module_level_skill_id + " = { parent: " + course_level_skill_id + ",\n");
				out.append("       text:{\n");
				out.append("           name: \"" + skillObjective.getName().replaceAll("\\(", "").replaceAll("\\)", "") + "\",\n\n");
				out.append("            title: \"Module Level Skill\",\n");
				out.append("            module: \"" + module.getModuleName().replaceAll("\\(", "").replaceAll("\\)", "") + "\"\n\n");
				out.append("         },\n");
				out.append("       stackChildren: true,\n");
				out.append("       HTMLid: \"" + module_level_skill_id + "\"\n");
				out.append("     },\n\n");

				for (Cmsession cmsession : module.getCmsessions()) {
					for (SkillObjective skillObjective1 : cmsession.getSkillObjectives()) {
						String session_level_skill_id = "cmsession_level_skill_" + skillObjective1.getId();

						skillList.put(session_level_skill_id, session_level_skill_id);

						out.append("  " + session_level_skill_id + " = { parent: " + module_level_skill_id + ",\n\n");
						out.append("       text:{");
						out.append("           name: \"" + skillObjective1.getName().replaceAll("\\(", "").replaceAll("\\)", "") + "\",\n");
						out.append("            title: \"CMsession Level Skill\",");
						out.append("            module: \"" + cmsession.getTitle().replaceAll("\\(", "").replaceAll("\\)", "") + "\"\n");
						out.append("         },\n");
						out.append("       stackChildren: true,\n");
						out.append("       HTMLid: \"" + session_level_skill_id + "\"\n");
						out.append("     },\n");
						System.err.print("," + skillObjective1.getId());

					}
				}
			}
		}

		return out.toString();

	}

	static String getMinified(String text) {
		return text.trim().replaceAll(",", "").replaceAll(" ", "").replaceAll("&", "").replaceAll("-", "").replaceAll(":", "").replaceAll("\\(", "").replaceAll("\\)", "").toLowerCase().replaceAll("[0-9]", "").replaceAll("_", "").replaceAll("/", "");

	}

	public static String getMinified(Course course) {
		StringBuffer out = new StringBuffer();
		String course_level_skill_id = "course_level_skill_" + course.getSkillObjectives().get(0).getId();

		TreeSet<String> skillList = new TreeSet<>();
		skillList.add(course_level_skill_id);

		//out.append(getMinified(course.getCourseName()) + ",");
		for (Module module : course.getModules()) {

			for (SkillObjective skillObjective : module.getSkillObjectives()) {
				String module_level_skill_id = "module_level_skill_" + skillObjective.getId();
				skillList.add(module_level_skill_id);
				///out.append(getMinified(skillObjective.getName()) + ",");
				for (Cmsession cmsession : module.getCmsessions()) {
					for (SkillObjective skillObjective1 : cmsession.getSkillObjectives()) {
						String session_level_skill_id = "cmsession_level_skill_" + skillObjective1.getId();
						skillList.add(session_level_skill_id);
						//out.append(getMinified(skillObjective1.getName()) + ",");
					}
				}
			}

		}
		
		for (String key : skillList) {
			out.append(key + ",");
		}
		return out.toString().trim();
	}

}
