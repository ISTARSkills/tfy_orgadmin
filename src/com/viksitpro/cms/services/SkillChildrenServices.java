package com.viksitpro.cms.services;

import java.util.HashMap;
import java.util.List;
import java.util.Set;

import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.utilities.DBUTILS;

public class SkillChildrenServices {
	
	public SkillChildrenServices() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Set<SkillObjective> LOsfromSessionSkill(String session_skill_id, String context_id, Set<SkillObjective> objectives){
		String sql = "select * from skill_objective where type = 'LEARNING_OBJECTIVE' AND parent_skill = " + session_skill_id + " and context = " + context_id + " order by order_id";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> results = dbutils.executeQuery(sql);
		for(HashMap<String, Object> result : results){
			objectives.add((new SkillObjectiveDAO()).findById(Integer.parseInt(result.get("id").toString())));
		}
		return objectives;
	}

	public Set<SkillObjective> LOsfromContextSkill(String context_skill, Set<SkillObjective> objectives) {
		String sql = "select * from skill_objective where type = 'LEARNING_OBJECTIVE' and context = " + context_skill + ";";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> results = dbutils.executeQuery(sql);
		for(HashMap<String, Object> result : results){
			objectives.add((new SkillObjectiveDAO()).findById(Integer.parseInt(result.get("id").toString())));
		}
		return objectives;
	}
}
