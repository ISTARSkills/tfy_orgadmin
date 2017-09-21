package com.viksitpro.user.service;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.ConcreteItemPOJO;
import com.istarindia.android.pojo.CoursePOJO;
import com.istarindia.android.pojo.ModulePOJO;
import com.istarindia.android.pojo.RestClient;
import com.istarindia.android.pojo.SessionPOJO;
import com.istarindia.android.pojo.TaskSummaryPOJO;
import com.viksitpro.core.utilities.TaskItemCategory;

public class UserNextTaskService {

	public StringBuffer getnextTask(int user_id, int current_task_id) {
		StringBuffer out = new StringBuffer();
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user_id);

		List<TaskSummaryPOJO> taskSummaryPOJOList = cp.getTasks();

		try {
			Collections.sort(taskSummaryPOJOList, new Comparator<TaskSummaryPOJO>() {
				public int compare(TaskSummaryPOJO o1, TaskSummaryPOJO o2) {
					if (o1.getDate() == null) {
						return (o2.getId() == null) ? 0 : 1;
					}
					if (o2.getDate() == null) {
						return -1;
					}
					return o2.getDate().compareTo(o1.getDate());
				}
			});
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		for (int i = 0; i < taskSummaryPOJOList.size(); i++) {
			TaskSummaryPOJO summaryPOJO = taskSummaryPOJOList.get(i);
			if (current_task_id == (int) summaryPOJO.getId()) {
				TaskSummaryPOJO pojo = getNextTaskSummaryPojo(i, taskSummaryPOJOList);
				if (pojo != null) {
					out.append(getNextTask(pojo));
					break;
				} else {
					
				}
			}
		}
		return out;

	}

	private TaskSummaryPOJO getNextTaskSummaryPojo(int i, List<TaskSummaryPOJO> taskSummaryPOJOList) {
		TaskSummaryPOJO summaryPOJO = null;
		try {
			for (int j = i; j < taskSummaryPOJOList.size(); j++) {
				if (j > i) {
					if (taskSummaryPOJOList.get(j) != null) {
						if (taskSummaryPOJOList.get(j).getItemType()
								.equalsIgnoreCase(TaskItemCategory.LESSON_PRESENTATION)
								|| taskSummaryPOJOList.get(j).getItemType()
										.equalsIgnoreCase(TaskItemCategory.ASSESSMENT)) {
							summaryPOJO = taskSummaryPOJOList.get(j);
							break;
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return summaryPOJO;
	}

	public StringBuffer getNextTask(TaskSummaryPOJO taskSummaryPOJO) {
		StringBuffer out = new StringBuffer();
		
		try {
			String type = taskSummaryPOJO.getItemType();
			switch (type) {
			case TaskItemCategory.LESSON_PRESENTATION:
				out.append("student/presentation.jsp?task_id="+taskSummaryPOJO.getId()+"&lesson_id="+taskSummaryPOJO.getItemId());
				break;
			case TaskItemCategory.ASSESSMENT:
				//out.append("student/presentation.jsp?task_id="+taskSummaryPOJO.getId()+"&lesson_id="+taskSummaryPOJO.getItemId());
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return out;
	}
	
	public StringBuffer getnextLesson(int user_id, int lesson_id,int cmsession_id, int module_id, int course_id) throws IOException {
		
		StringBuffer out = new StringBuffer();
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user_id);
		ConcreteItemPOJO concretPojo = new ConcreteItemPOJO();
		
		for(CoursePOJO coursePojo : cp.getCourses()) {
			
			if(coursePojo.getId() == course_id) {
				
				for(ModulePOJO modulePojo : coursePojo.getModules()) {
					
					if(modulePojo.getId() == module_id) {
						
						for(SessionPOJO sessionPojo : modulePojo.getSessions()) {
							
							if(sessionPojo.getId() == cmsession_id) {
								
								List<ConcreteItemPOJO> lessons =  sessionPojo.getLessons();
								
								try {
									Collections.sort(lessons, new Comparator<ConcreteItemPOJO>() {
										public int compare(ConcreteItemPOJO o1, ConcreteItemPOJO o2) {
											if (o1.getOrderId() == null) {
												return (o2.getOrderId() == null) ? 0 : 1;
											}
											if (o2.getOrderId() == null) {
												return -1;
											}
											return o1.getOrderId().compareTo(o2.getOrderId());
										}
									});
								} catch (Exception e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								
								for (int i = 0; i < lessons.size(); i++) {
									
									if(lesson_id == lessons.get(i).getId()) {
										try {
										if(lessons.get(i+1) != null) {
											out.append("/student/presentation.jsp?lesson_id="+lessons.get(i+1).getId()+"&cmsession_id="+cmsession_id+"&module_id="+module_id+"&course_id="+course_id);
										}else {
											
										}
										}catch(Exception e) {
											
										}
										
									}
									
								}
								
							/*	for(ConcreteItemPOJO concreteItemPojo : sessionPojo.getLessons()) {
									
									if(concreteItemPojo.getId() == lesson_id) {
										
										int nextOrderId = concreteItemPojo.getOrderId()+1;
										
										if(concretPojo.getOrderId() == nextOrderId) {
											concretPojo.getId();
										}
										
									}
									
									
								}*/
								
								
							}
							
							
						}
					}
					
				}
				
				
			}
			
		}
		
		
		return out;
		
		
		
	}
	

}
