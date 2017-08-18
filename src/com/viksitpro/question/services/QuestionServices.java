package com.viksitpro.question.services;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import com.viksitpro.core.dao.entities.Context;
import com.viksitpro.core.dao.entities.ContextDAO;
import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.utilities.DBUTILS;

public class QuestionServices {

	public QuestionServices() {
		super();
		// TODO Auto-generated constructor stub
	}
	public HashSet<SkillObjective> getLOsfromQuestion (Question question) {
		HashSet<SkillObjective> questionLOs = new HashSet<>();
		String sql = "select learning_objectiveid from question_skill_objective where questionid = " + question.getId();
		List<HashMap<String, Object>> selected_learning_objectives = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_learning_objective : selected_learning_objectives){
			questionLOs.add((new SkillObjectiveDAO()).findById(Integer.parseInt(selected_learning_objective.get("learning_objectiveid").toString())));
		}
		return questionLOs;
	}
	public HashSet<SkillObjective> getSessionSkillsfromQuestion(Question question) {
		HashSet<SkillObjective> questionSessionSkills = new HashSet<>();
		String sql = "select distinct(parent_skill) from skill_objective where id in( select learning_objectiveid from question_skill_objective where questionid = " + question.getId() + ")";
		List<HashMap<String, Object>> selected_learning_objectives = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_learning_objective : selected_learning_objectives){
			questionSessionSkills.add((new SkillObjectiveDAO()).findById(Integer.parseInt(selected_learning_objective.get("parent_skill").toString())));
		}
		return questionSessionSkills;
	}
	public HashSet<SkillObjective> getModuleSkillsfromQuestion(Question question) {
		HashSet<SkillObjective> questionModuleSkills = new HashSet<>();
		String sql = "select distinct(parent_skill) from skill_objective where id in (select parent_skill from skill_objective where id in ( select learning_objectiveid from question_skill_objective where questionid = "+question.getId()+"))";
		List<HashMap<String, Object>> selected_learning_objectives = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> selected_learning_objective : selected_learning_objectives){
			questionModuleSkills.add((new SkillObjectiveDAO()).findById(Integer.parseInt(selected_learning_objective.get("parent_skill").toString())));
		}
		return questionModuleSkills;
	}
	public HashSet<Context> getContextfromQuestion(Question question) {
		HashSet<Context> contextz = new HashSet<>();
		String sql = "select DISTINCT(context) from skill_objective where id in (select learning_objectiveid from question_skill_objective where questionid = "+question.getId()+")";
		List<HashMap<String, Object>> contexts = (new DBUTILS()).executeQuery(sql);
		for(HashMap<String, Object> context : contexts){
			contextz.add((new ContextDAO()).findById(Integer.parseInt(context.get("context").toString())));
		}
		if(contextz.size()>1){
			System.err.println("More than one context exists for question "+question.getId());
		} else if(contextz.size()==0){
			System.err.println("No context exists for question "+question.getId());
		}
		return contextz;
	}
}
