package com.viksitpro.cms.services;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Context;
import com.viksitpro.core.dao.entities.ContextDAO;
import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.utilities.DBUTILS;

public class ModuleServices {
	
	public Module saveModuleCMSessionMapping(Module module, ModuleDAO moduleDAO, String[] cmsession_ids) {
		List<Cmsession> cmsessions = module.getCmsessions();
		try {
			if(cmsessions.size()>0){
				cmsessions.removeAll(cmsessions);
			}
		} catch (NullPointerException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		for(String cmsession_id : cmsession_ids){
			try{
				cmsessions.add((new CmsessionDAO()).findById(Integer.parseInt(cmsession_id)));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} 
		}
		module.setCmsessions(cmsessions);
		return module;
	}

	public Module saveModuleSkillObjectivesMapping(Module module, ModuleDAO moduleDAO, String[] skill_objective_ids) {
		List<SkillObjective> skillObjectives = module.getSkillObjectives();
		try {
			if(skillObjectives.size()>0){
				skillObjectives.clear();
				//skillObjectives.removeAll(skillObjectives);
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
		module.setSkillObjectives(skillObjectives);
		return module;
	}

	public Module saveModuleDetails(Module module, ModuleDAO moduleDAO) {
		Session session = null;
		Transaction tx = null;
		try {
			session = moduleDAO.getSession();
			tx = session.beginTransaction();
			moduleDAO.attachDirty(module);
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
			tx.rollback();
		} finally {
			//session.flush();
			session.clear();
			session.close();
		}
		return module;
	}

	public HashSet<Context> getContextfromModule(Module module) {
		HashSet<Context> contexts = new HashSet<>();
		String sql = "select * from skill_objective where id in (select skill_objective_id from module_skill_objective where module_id = "+module.getId()+")";
		List<HashMap<String, Object>> selected_contexts = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_context : selected_contexts){
			contexts.add((new ContextDAO()).findById(Integer.parseInt(selected_context.get("context").toString())));
		}
		return contexts;
	}

	public HashSet<SkillObjective> getModuleSkillfromModule(Module module) {
		HashSet<SkillObjective> module_skills = new HashSet<>();
		String sql = "select * from module_skill_objective where module_id = "+module.getId();
		List<HashMap<String, Object>> selected_module_skills = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_module_skill : selected_module_skills){
			module_skills.add((new SkillObjectiveDAO()).findById(Integer.parseInt(selected_module_skill.get("skill_objective_id").toString())));
		}
		return module_skills;
	}

	
	
}
