package com.viksitpro.cms.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Context;
import com.viksitpro.core.dao.entities.ContextDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;
import com.viksitpro.core.utilities.DBUTILS;

public class SessionServices {
	
	public Cmsession createCmsessionLessonMapping(Cmsession Cmsession, CmsessionDAO CmsessionDAO, String[] lesson_ids) {
		List<Lesson> lessons = Cmsession.getLessons();
		try {
			if(lessons.size()>0){
				lessons.removeAll(lessons);
			}
		} catch (NullPointerException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		for(String lesson_id : lesson_ids){
			try{
				lessons.add((new LessonDAO()).findById(Integer.parseInt(lesson_id)));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} 
		}
		Cmsession.setLessons(lessons);;
		return Cmsession;
	}

	public Cmsession createCmsessionSkillObjectivesMapping(Cmsession Cmsession, CmsessionDAO CmsessionDAO, String[] skill_objective_ids) {
		List<SkillObjective> skillObjectives = Cmsession.getSkillObjectives();
		try {
			if(skillObjectives.size()>0){
				skillObjectives.removeAll(skillObjectives);
			}
		} catch (NullPointerException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} 
		for(String skill_objective_id : skill_objective_ids){
			try{
				skillObjectives.add((new SkillObjectiveDAO()).findById(Integer.parseInt(skill_objective_id)));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (NullPointerException e) {
				e.printStackTrace();
			}
		}
		Cmsession.setSkillObjectives(skillObjectives);
		return Cmsession;
	}
	
	public Cmsession editCmsessionLessonMapping(Cmsession Cmsession, CmsessionDAO CmsessionDAO, String[] lesson_ids) {
		List<Lesson> lessons = Cmsession.getLessons();
		try {
			if(lessons.size()>0){
				lessons.removeAll(lessons);
			}
		} catch (NullPointerException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		for(String lesson_id : lesson_ids){
			try{
				lessons.add((new LessonDAO()).findById(Integer.parseInt(lesson_id)));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} 
		}
		Cmsession.setLessons(lessons);;
		return Cmsession;
	}

	public Cmsession editCmsessionSkillObjectivesMapping(Cmsession Cmsession, CmsessionDAO CmsessionDAO, String[] skill_objective_ids) {
		List<SkillObjective> skillObjectives = Cmsession.getSkillObjectives();
		try {
			if(skillObjectives.size()>0){
				skillObjectives.removeAll(skillObjectives);
			}
		} catch (NullPointerException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} 
		for(String skill_objective_id : skill_objective_ids){
			try{
				skillObjectives.add((new SkillObjectiveDAO()).findById(Integer.parseInt(skill_objective_id)));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (NullPointerException e) {
				e.printStackTrace();
			}
		}
		Cmsession.setSkillObjectives(skillObjectives);
		return Cmsession;
	}

	public Cmsession saveCmsessionDetails(Cmsession Cmsession, CmsessionDAO CmsessionDAO) {
		Session session = null;
		Transaction tx = null;
		try {
			session = CmsessionDAO.getSession();
			tx = session.beginTransaction();
			CmsessionDAO.attachDirty(Cmsession);
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
			tx.rollback();
		} finally {
			//session.flush();
			session.clear();
			session.close();
		}
		return Cmsession;
	}

	public HashSet<SkillObjective> getSessionSkillsfromSession(Cmsession cmsession) {
		HashSet<SkillObjective> session_skills = new HashSet<>();
		String sql = "select skill_objective_id from cmsession_skill_objective where cmsession_id = " + cmsession.getId();
		List<HashMap<String, Object>> selected_session_skills = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_session_skill : selected_session_skills){
			session_skills.add((new SkillObjectiveDAO()).findById(Integer.parseInt(selected_session_skill.get("skill_objective_id").toString())));
		}
		return session_skills;
	}

	public HashSet<SkillObjective> getModuleSkillfromSession(Cmsession cmsession) {
		HashSet<SkillObjective> module_skills = new HashSet<>();
		String sql = "select parent_skill from skill_objective where id in (select skill_objective_id from cmsession_skill_objective where cmsession_id = "+cmsession.getId()+")";
		List<HashMap<String, Object>> selected_module_skills = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_module_skill : selected_module_skills){
			module_skills.add((new SkillObjectiveDAO()).findById(Integer.parseInt(selected_module_skill.get("parent_skill").toString())));
		}
		return module_skills;
	}

	public HashSet<Context> getContextfromSession(Cmsession cmsession) {
		HashSet<Context> contexts = new HashSet<>();
		String sql = "select * from skill_objective where id in (select skill_objective_id from cmsession_skill_objective where cmsession_id = "+cmsession.getId()+")";
		List<HashMap<String, Object>> selected_contexts = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_context : selected_contexts){
			contexts.add((new ContextDAO()).findById(Integer.parseInt(selected_context.get("context").toString())));
		}
		return contexts;
	}

	
	
}
