<%@page import="com.viksitpro.core.delivery.pojo.DeliveryLesson"%>
<%@page import="com.viksitpro.core.delivery.pojo.DeliverySession"%>
<%@page import="com.viksitpro.core.delivery.pojo.DeliveryModule"%>
<%@page import="com.viksitpro.core.delivery.pojo.DeliveryCourse"%>
<%@page import="com.viksitpro.core.skill.pojo.LearningObjective"%>
<%@page import="com.viksitpro.core.skill.pojo.SessionLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.ModuleLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.DeliveryQuestion"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.skill.pojo.DeliveryAssessmentTree"%>
<%@page import="com.viksitpro.core.skill.services.CoreSkillService"%>
<%
int courseId = Integer.parseInt(request.getParameter("course_id"));
CoreSkillService skillService = new CoreSkillService();																							
DeliveryCourse courseTree = skillService.getDeliveryTreeForCourse(courseId);
%><ul>										
										<li data-jstree='{"icon":"glyphicon glyphicon-asterisk"}'><a
											><%=courseTree.getId() %> - <%=courseTree.getCourseName()%></a>
											<ul>
												<%
												if(courseTree.getModules()!=null)
												{
													for (DeliveryModule deliveryMod : courseTree.getModules()) {
															String titleInModule="Delivery Module";
															if(deliveryMod.getSessions().size()==0)
															{
																titleInModule="Module is empty";
															}
															else 
															{
																titleInModule="One or more lesson in this module is not mapped to Learning objective";
															}
															
														%>
														<li data-is_valid="<%=deliveryMod.getIsPerfect()%>" data-title="<%=titleInModule%>"
															data-jstree='{"icon":"glyphicon glyphicon-tree-deciduous"}'><%=deliveryMod.getId() %> - <%=deliveryMod.getModuleName()%>
															<ul>
																<%
																
																	if(deliveryMod.getSessions()!=null)
																	{
																		for (DeliverySession deliverySesion : deliveryMod.getSessions()) {
																			String titleInSession="Delivery Session";
																			if(deliverySesion.getLessons().size()==0)
																			{
																				titleInSession ="This session is empty";
																			}
																			else {
																				titleInSession="One or more lesson in this session is not mapped to Learning objective";
																			}
																				
																			%>
																			<li data-is_valid="<%=deliverySesion.getIsPerfect()%>" data-title="<%=titleInSession%>" data-jstree='{"icon":"glyphicon glyphicon-leaf"}'><%=deliverySesion.getId() %> - <%=deliverySesion.getSessionName()%>
																				<ul>
																					<%
																						
																						for (DeliveryLesson lesson : deliverySesion.getLessons()) {
																						String titleInLesson ="Delivery Lesson";
																						if(lesson.getType().equalsIgnoreCase("ASSESSMENT"))
																						{
																							titleInLesson ="Delivery Assessment";
																							if(!lesson.getIsPerfect())
																							{
																								titleInLesson = "One or more question is not mapped to learning objective in this assessment";
																							}
																						}
																						else
																						{
																							titleInLesson ="Delivery Lesson";
																							if(!lesson.getIsPerfect())
																							{
																								titleInLesson = "Lesson is not mapped to Learning objective";
																							}	
																						}	
																							
																							%>
																					<li data-is_valid="<%=lesson.getIsPerfect()%>" data-title="<%=titleInLesson%>" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=lesson.getId() %> - <%=lesson.getLessonName()%>
																				<%
																				if(lesson.getMappedModuleLevelSkill()!=null){
																				%>
																					<ul><%
																						for(ModuleLevelSkill modSkill : lesson.getMappedModuleLevelSkill())	
																						{
																							%>
																							<li data-title="Module Level Skill" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=modSkill.getId() %> - <%=modSkill.getSkillName()%>
																							<ul><%
																							for(SessionLevelSkill sessionSkill:  modSkill.getSessionLevelSkill())
																							{
																							%>
																							<li data-title="Session Level Skill" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=sessionSkill.getId() %> - <%=sessionSkill.getSkillName()%>	
																							<ul><%
																							for(LearningObjective lobj : sessionSkill.getLearningObjectives())
																							{
																								%>
																								<li data-title="Learning Objective" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=lobj.getId() %> - <%=lobj.getLearningObjectiveName()%>
																								</li>
																								<%
																							}
																							%>
																							</ul>
																							</li>																						
																							<%	
																							}	
																							%>
																							</ul></li>
																							<%
																						}
																					
																					%></ul><%
																					
																						}
																						}
																					%>
																					
																					</li>
																					
																				</ul>
																				</li>
																			<%
																				}
																	}	
																%>
															</ul></li>
														<%
															}
												}	
												%>
											</ul></li>
										
									</ul>