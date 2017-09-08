package com.viksitpro.cms.services;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.cms.utilities.LessonTypeNames;
import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.AssessmentQuestion;
import com.viksitpro.core.dao.entities.AssessmentQuestionDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.QuestionDAO;
import com.viksitpro.core.dao.entities.SkillObjective;
import com.viksitpro.core.dao.entities.SkillObjectiveDAO;
import com.viksitpro.core.dao.utils.HibernateSessionFactory;
import com.viksitpro.core.utilities.DBUTILS;

public class AssessmentEngineService {

	com.viksitpro.core.utilities.DBUTILS db = new com.viksitpro.core.utilities.DBUTILS();

	public List<HashMap<String, Object>> getQustionInfo(int questionId) {

		String sql = "select id,question_text,question_type,difficulty_level,explanation,comprehensive_passage_text from question where id=" + questionId;
		System.err.println(sql);
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAllOptionsInfo(int questionId) {
		String sql = "select id,text,marking_scheme from assessment_option where question_id=" + questionId + " ORDER BY id";
		System.err.println(sql);
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getallLearningObjectives(int questionId) {
		String sql = "SELECT lo. ID, lo.name FROM question_skill_objective loq, skill_objective lo WHERE loq.learning_objectiveid = lo. ID AND loq.questionid =" + questionId;
		System.err.println(sql);
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getallSkillObjectives(Question que) {
		String sql = "select * from skill_objective where type = 'SKILL' and context = " + que.getContext_id();
		System.err.println(sql);
		List<HashMap<String, Object>> skills = db.executeQuery(sql);
		return skills;
	}

	public List<HashMap<String, Object>> getchosenSkillObjective(Question que) {
		String sql = "select * from skill_objective where id in (select parent_skill from skill_objective where id in (select learning_objectiveid from question_skill_objective where questionid = " + que.getId() + "))";
		System.err.println(sql);
		List<HashMap<String, Object>> chosen_skill = db.executeQuery(sql);
		return chosen_skill;
	}

	public List<HashMap<String, Object>> getsiblingLearningObjectives(Question que) {
		String sql = "select * from skill_objective where type = 'LEARNING_OBJECTIVE' and parent_skill in (select id from skill_objective where id in (select parent_skill from skill_objective where id in (select learning_objectiveid from question_skill_objective where questionid = " + que.getId() + ")))";
		System.err.println(sql);
		List<HashMap<String, Object>> sibling_los = db.executeQuery(sql);
		return sibling_los;
	}

	public List<Question> getOrderedQuestionsFromSkill(String context_skill, String session_skill, String learning_obj, String orderString, String order) {
		// TODO Auto-generated method stub
		Set<SkillObjective> objectives = new HashSet<>();
		List<Question> questions = new ArrayList<>();
		if (learning_obj != "") {
			for (String lo : learning_obj.split(",")) {
				objectives.add((new SkillObjectiveDAO()).findById(Integer.parseInt(lo)));
			}
		}
		SkillChildrenServices childrenServices = new SkillChildrenServices();
		if (session_skill != "") {
			objectives = childrenServices.LOsfromSessionSkill(session_skill, context_skill, objectives);
		}
		if (context_skill != "") {
			objectives = childrenServices.LOsfromContextSkill(context_skill, objectives);
		}
		String los = "";
		for (SkillObjective objective : objectives) {
			los += objective.getId() + ",";
		}
		String sql = "";
		if (!(los.length() > 0)) {
			sql = "select * from question order by " + orderString + " " + order;
		} else {
			sql = "select * from question where id in (select questionid from question_skill_objective where learning_objectiveid in (" + los.substring(0, los.length() - 1) + ")) order by " + orderString + " " + order;
		}
		System.err.println(sql);
		List<HashMap<String, Object>> results = (new DBUTILS()).executeQuery(sql);
		for (HashMap<String, Object> result : results) {
			questions.add((new QuestionDAO()).findById(Integer.parseInt(result.get("id").toString())));
		}
		return questions;
	}

	public Assessment saveAssessmentDetails(Assessment assessment, AssessmentDAO assessmentDAO) {
		Session session = null;
		Transaction tx = null;
		try {
			session = assessmentDAO.getSession();
			tx = session.beginTransaction();
			assessmentDAO.attachDirty(assessment);
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
			tx.rollback();
		} finally {
			//session.flush();
			session.clear();
			session.close();
		}
		return assessment;
	}

	public Set<AssessmentQuestion> saveAssessmentQuestions(Assessment assessmento, String question_list, Set<AssessmentQuestion> assessmentQuestions) {
		int orderId = 1;
		Set<Question> questions = new HashSet<Question>();
		for (String questionid : question_list.split(",")) {
			Question question = (new QuestionDAO()).findById(Integer.parseInt(questionid));
			questions.add(question);
		}
		for (Question question : questions) {
			AssessmentQuestion assessmentQuestion = new AssessmentQuestion();
			assessmentQuestion.setAssessment(assessmento);
			assessmentQuestion.setCreatedAt(new Timestamp(System.currentTimeMillis()));
			assessmentQuestion.setOrderId(orderId++);
			assessmentQuestion.setQuestion(question);
			assessmentQuestions.add(assessmentQuestion);
		}
		return assessmentQuestions;
	}
	
	public Lesson createAssessmentLesson ( Lesson lesson, LessonDAO lessonDAO, Assessment assessment) {
		lesson.setTitle(assessment.getAssessmenttitle());
		lesson.setIsDeleted(false);
		lesson.setLessonXml(assessment.getId().toString());
		lesson.setIsPublished(false);
		lesson.setDuration(assessment.getAssessmentdurationminutes());
		lesson.setType(LessonTypeNames.ASSESSMENT.toString());
		lesson.setDescription(assessment.getDescription());
		(new LessonServices()).saveLessonDetails(lesson, lessonDAO);
		return lesson;
	}

}