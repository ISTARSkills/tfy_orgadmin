package com.viksitpro.factory.task;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import com.viksitpro.cms.utilities.LessonTaskNames;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.dao.entities.TaskDAO;
import com.viksitpro.core.dao.entities.TaskLog;
import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.DBUTILS;

public class TaskEntityServices {
	public void createLesson(Lesson lesson, HttpSession session) {
		Task task = new Task();
		TaskLog log = new TaskLog();
		IstarUser istarUser = (IstarUser) session.getAttribute("user");
		String title = "Lesson is created";
		String entityType = "LESSON";
		String state = "CREATED";
		String taskName = LessonTaskNames.CREATE_LESSON;
		String itemType = "LESSON";
		java.util.Date date = new Date();
		task.setCreatedAt(new java.sql.Timestamp(date.getTime()));
		int itemID = lesson.getId();
		String description = lesson.getDescription();
		createUpdateTask(task, istarUser, taskName, itemType, itemID, state, description);
		createTaskLogEntry(log, istarUser, session, task, title, entityType, state);
		boolean newTask = true;
		int taskID = saveTask(task, newTask);
		ViksitLogger.logMSG(this.getClass().getName(),"CREATING LOG ENTRY");
		saveTaskLog(log, taskID);
	}

	public void updateLesson(Lesson lesson, HttpSession session) {
		IstarUser istarUser = (IstarUser) session.getAttribute("user");
		int taskID = getCMSItemTaskID(lesson.getId(), istarUser);
		Task task = null;
		boolean newTask = true;
		if (taskID == 0) {
			ViksitLogger.logMSG(this.getClass().getName(),"No tasks existed for lesson " + lesson.getId() + " so a new task will now be created");
			task = new Task();
			newTask = true;
		} else {
			task = (new TaskDAO()).findById(taskID);
			newTask = false;
		}
		// ViksitLogger.logMSG(this.getClass().getName(),(task.getId());
		TaskLog log = new TaskLog();
		String title = "Lesson is drafted";
		String entityType = "LESSON";
		String state = "DRAFT";
		String taskName = LessonTaskNames.CREATE_LESSON;
		String itemType = "LESSON";
		java.util.Date date = new Date();
		task.setUpdatedAt(new java.sql.Timestamp(date.getTime()));
		int itemID = lesson.getId();
		String description = lesson.getDescription();
		createUpdateTask(task, istarUser, taskName, itemType, itemID, state, description);
		createTaskLogEntry(log, istarUser, session, task, title, entityType, state);
		taskID = saveTask(task, newTask);
		ViksitLogger.logMSG(this.getClass().getName(),"CREATING LOG ENTRY");
		saveTaskLog(log, taskID);
	}
	
	public void publishLesson(Lesson lesson, HttpSession session) {
		IstarUser istarUser = (IstarUser) session.getAttribute("user");
		int taskID = getCMSItemTaskID(lesson.getId(), istarUser);
		Task task = null;
		boolean newTask = true;
		if (taskID == 0) {
			ViksitLogger.logMSG(this.getClass().getName(),"No tasks existed for lesson " + lesson.getId() + " so a new task will now be created");
			task = new Task();
		} else {
			task = (new TaskDAO()).findById(taskID);
			newTask = false;
		}
		// ViksitLogger.logMSG(this.getClass().getName(),(task.getId());
		TaskLog log = new TaskLog();
		String title = "Lesson is published";
		String entityType = "LESSON";
		String state = "PUBLISHED";
		String taskName = LessonTaskNames.CREATE_LESSON;
		String itemType = "LESSON";
		java.util.Date date = new Date();
		task.setUpdatedAt(new java.sql.Timestamp(date.getTime()));
		int itemID = lesson.getId();
		String description = lesson.getDescription();
		createUpdateTask(task, istarUser, taskName, itemType, itemID, state, description);
		createTaskLogEntry(log, istarUser, session, task, title, entityType, state);
		saveTask(task, newTask);
		ViksitLogger.logMSG(this.getClass().getName(),"CREATING LOG ENTRY");
		saveTaskLog(log, taskID);
	}
	
	public void deleteLesson(Lesson lesson, HttpSession session) {
		IstarUser istarUser = (IstarUser) session.getAttribute("user");
		int taskID = getCMSItemTaskID(lesson.getId(), istarUser);
		Task task = null;
		boolean newTask = true;
		if (taskID == 0) {
			ViksitLogger.logMSG(this.getClass().getName(),"No tasks existed for lesson " + lesson.getId() + " so a new task will now be created");
			task = new Task();
		} else {
			task = (new TaskDAO()).findById(taskID);
			newTask = false;
		}
		// ViksitLogger.logMSG(this.getClass().getName(),(task.getId());
		TaskLog log = new TaskLog();
		String title = "Lesson is deleted";
		String entityType = "LESSON";
		String state = "DELETED";
		String taskName = LessonTaskNames.CREATE_LESSON;
		String itemType = "LESSON";
		java.util.Date date = new Date();
		task.setUpdatedAt(new java.sql.Timestamp(date.getTime()));
		int itemID = lesson.getId();
		String description = lesson.getDescription();
		createUpdateTask(task, istarUser, taskName, itemType, itemID, state, description);
		createTaskLogEntry(log, istarUser, session, task, title, entityType, state);
		task.setIsActive(false);
		saveTask(task, newTask);
		ViksitLogger.logMSG(this.getClass().getName(),"CREATING LOG ENTRY");
		saveTaskLog(log, taskID);
	}

	public int saveTask(Task task, boolean newTask) {
		String sql = "";
		if (newTask) {
			sql = "INSERT INTO public.task (id, name, description, task_type, priority, owner, actor, state, parent_task, start_date, end_date, duration_in_hours, assignee_team, assignee_member, is_repeatative, followup_date, is_active, tags, created_at, updated_at, item_id, item_type, project_id, is_timed_task, follow_up_duration_in_days) VALUES (((select COALESCE(max(id),0)+1 from task)), '"
					+ task.getName() + "', '" + task.getDescription().replaceAll("'", "") + "', NULL, NULL, NULL, '" + task.getIstarUserByActor().getId() + "', '" + task.getState() + "', NULL, '" + task.getStartDate() + "', '" + task.getEndDate() + "', NULL, NULL, NULL, NULL, NULL, '" + task.getIsActive() + "', NULL, '" + task.getCreatedAt() + "', '" + task.getUpdatedAt() + "', '" + task.getItemId() + "', '"
					+ task.getItemType() + "', NULL, NULL, NULL) returning id;";
			// retuirning ID
			ViksitLogger.logMSG(this.getClass().getName(),sql);
		} else {
			sql = "UPDATE public.task SET name='" + task.getName() + "', description='" + task.getDescription().replaceAll("'", "") + "', task_type=NULL, priority=NULL, owner=NULL, actor='" + task.getIstarUserByActor().getId() + "', state='" + task.getState() + "', parent_task=NULL, start_date='" + task.getStartDate() + "', end_date='" + task.getEndDate()
					+ "', duration_in_hours=NULL, assignee_team=NULL, assignee_member=NULL, is_repeatative=NULL, followup_date=NULL, is_active='" + task.getIsActive() + "', tags=NULL, created_at='" + task.getCreatedAt() + "', updated_at='" + task.getUpdatedAt() + "', item_id='" + task.getItemId() + "', item_type='" + task.getItemType()
					+ "', project_id=NULL, is_timed_task=NULL, follow_up_duration_in_days=NULL WHERE (id='" + task.getId() + "') returning id;";
			ViksitLogger.logMSG(this.getClass().getName(),sql);
		}
		int taskID = (int) (new DBUTILS()).executeUpdateReturn(sql);
		return taskID;
	}

	public void saveTaskLog(TaskLog tasklog, int taskID) {
		String sql = "INSERT INTO public.task_log (id, pm_member, status, entity_type, title, jsession_id, created_at, updated_at, task, body) VALUES (((select COALESCE(max(id),0)+1 from task_log)), '" + tasklog.getIstarUser().getId() + "', '" + tasklog.getStatus() + "', '" + tasklog.getEntityType() + "', '" + tasklog.getTitle() + "', '" + tasklog.getJsessionId() + "', '" + tasklog.getCreatedAt()
				+ "', NULL, '" + taskID + "', NULL);";
		ViksitLogger.logMSG(this.getClass().getName(),sql);
		(new DBUTILS()).executeUpdate(sql);
	}

	public void createTaskLogEntry(TaskLog log, IstarUser istarUser, HttpSession session, Task task, String title, String entityType, String state) {
		java.util.Date date = new Date();
		log.setCreatedAt(new java.sql.Timestamp(date.getTime()));
		log.setEntityType(entityType);
		log.setIstarUser(istarUser);
		log.setJsessionId(session.getId());
		log.setStatus(state);
		log.setTask(task);
		log.setTitle(title);
	}

	public Task createUpdateTask(Task task, IstarUser user, String taskName, String itemType, int itemID, String state, String description) {
		java.util.Date date = new Date();
		task.setDescription(description);
		task.setIsActive(true);
		task.setIstarUserByActor(user);
		task.setItemId(itemID);
		task.setItemType(itemType);
		task.setName(taskName);
		task.setState(state);
		if(task.getCreatedAt()==null){
			task.setCreatedAt(new java.sql.Timestamp(date.getTime()));
		}
		task.setUpdatedAt(new java.sql.Timestamp(date.getTime()));
		task.setStartDate(new java.sql.Timestamp(date.getTime()));
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_YEAR, 14);
		Date dateEnd = calendar.getTime();
		task.setEndDate(new java.sql.Timestamp((dateEnd).getTime()));

		return task;
	}

	public int getCMSItemTaskID(int cmsItemID, IstarUser istarUser) {
		int taskID = 0;
		String sql = "select * from task where actor = " + istarUser.getId() + " and item_id = " + cmsItemID + " and  name = 'CREATE_LESSON'";
		List<HashMap<String, Object>> executeQuery = (new DBUTILS()).executeQuery(sql);
		if (executeQuery.size() > 1) {
			ViksitLogger.logMSG(this.getClass().getName(),"Something is wrong with cms item " + executeQuery.size() + ". More than one content entries exist.");
		}
		for (HashMap<String, Object> hashMap : executeQuery) {
			taskID = Integer.parseInt(hashMap.get("id").toString());
		}
		return taskID;
	}
}
