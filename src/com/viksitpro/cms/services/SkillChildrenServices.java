package com.viksitpro.cms.services;

import java.util.HashMap;
import java.util.HashSet;
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

	public Set<SkillObjective> LOsfromSessionSkill(String session_skill_id, String context_id,
			Set<SkillObjective> objectives) {
		String sql = "select * from skill_objective where type = 'LEARNING_OBJECTIVE' AND parent_skill = "
				+ session_skill_id + " and context = " + context_id + " order by order_id";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> results = dbutils.executeQuery(sql);
		for (HashMap<String, Object> result : results) {
			objectives.add((new SkillObjectiveDAO()).findById(Integer.parseInt(result.get("id").toString())));
		}
		return objectives;
	}

	public Set<SkillObjective> LOsfromContextSkill(String context_skill, Set<SkillObjective> objectives) {
		String sql = "select * from skill_objective where type = 'LEARNING_OBJECTIVE' and context = " + context_skill
				+ ";";
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> results = dbutils.executeQuery(sql);
		for (HashMap<String, Object> result : results) {
			objectives.add((new SkillObjectiveDAO()).findById(Integer.parseInt(result.get("id").toString())));
		}
		return objectives;
	}

	public Set<SkillObjective> SearchLearningObjectivesFromAnySkillString(String searchString) {
		Set<SkillObjective> objectives = new HashSet<SkillObjective>();
		for (SkillObjective objective : new SkillObjectiveDAO().findAll()) {
			if (objective.getName().toLowerCase().contains(searchString)) {
				objectives.add(objective);
			}
		}
		Set<SkillObjective> learningObjectives = new HashSet<SkillObjective>();
		for (SkillObjective objective : objectives) {
			String sql = "";
			DBUTILS dbutils = new DBUTILS();
			switch (objective.getSkillLevelType()) {
			case "MODULE":
				sql = "select id from skill_objective where parent_skill in (select id from skill_objective where parent_skill = "
						+ objective.getId() + ")";
				List<HashMap<String, Object>> executeQuery = dbutils.executeQuery(sql);
				for (HashMap<String, Object> hashMap : executeQuery) {
					SkillObjective objective2 = (new SkillObjectiveDAO()
							.findById(Integer.parseInt(hashMap.get("id").toString())));
					if (objective2 != null) {
						learningObjectives.add(objective2);
					}
				}
				break;
			case "CMSESSION":
				sql = "select * from skill_objective where parent_skill = " + objective.getId()
						+ " and type = 'LEARNING_OBJECTIVE' and skill_level_type = 'LESSON'";
				List<HashMap<String, Object>> executeQuery2 = dbutils.executeQuery(sql);
				for (HashMap<String, Object> hashMap : executeQuery2) {
					SkillObjective objective2 = (new SkillObjectiveDAO())
							.findById(Integer.parseInt(hashMap.get("id").toString()));
					if (objective2 != null) {
						learningObjectives.add(objective2);
					}
				}
				break;
			case "LESSON":
				learningObjectives.add(objective);
				break;
			default:
				break;
			}
		}
		return learningObjectives;
	}
}
