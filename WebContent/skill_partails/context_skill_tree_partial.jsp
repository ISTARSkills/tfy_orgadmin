<%@page import="com.viksitpro.core.dao.entities.ContextDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Context"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.core.skill.pojo.LearningObjective"%>
<%@page import="com.viksitpro.core.skill.pojo.SessionLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.ModuleLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.CourseLevelSkill"%>
<%@page import="com.viksitpro.core.skill.services.CoreSkillService"%>
<%
int contextId = Integer.parseInt(request.getParameter("context_id"));
Context context = new ContextDAO().findById(contextId);
CoreSkillService skillService = new CoreSkillService();																							
CourseLevelSkill courseSkill = skillService.getShellTreeForContext(contextId);
boolean validContext = false;
String txt ="This context do not contain any child module";
if(courseSkill!=null && courseSkill.getModuleLevelSkill()!=null && courseSkill.getModuleLevelSkill().size()>0)
{
	validContext=true;
	txt ="Context";
}	
%>
<ul>
<li data-entity_type="CONTEXT" data-entity_id="<%=contextId%>" data-title="<%=txt %>" data-is_valid="<%=validContext%>"
															data-jstree='{"icon":"glyphicon glyphicon-tree-deciduous"}'><%=context.getId()%> - <%=context.getTitle()%>
<%								
												if(courseSkill!=null )
												{
											%>
											
<ul>										<%
													for (ModuleLevelSkill moduleskill : courseSkill.getModuleLevelSkill()) {
														String modTitle="This module level Skill is not mapped to any session level skill.";
														boolean isValid =false;
														if(moduleskill.getSessionLevelSkill()!=null && moduleskill.getSessionLevelSkill().size()>0)
														{
															modTitle="Module Level Skill";
															isValid= true;
														}	
														%>
														<li data-entity_type="MODULE_LEVEL_SKILL" data-entity_id="<%=moduleskill.getId()%>" data-title="<%=modTitle%>" data-is_valid="<%=isValid%>"
															data-jstree='{"icon":"glyphicon glyphicon-tree-deciduous"}'><%=moduleskill.getId() %> - <%=moduleskill.getSkillName()%>
															<ul>
																<%
																	for (SessionLevelSkill sessionskill : moduleskill.getSessionLevelSkill()) {
																		String sessionTitle="This session level skill is not mapped to any learning objective.";
																		boolean isSessionValid =false;
																		if(sessionskill.getLearningObjectives()!=null && sessionskill.getLearningObjectives().size()>0)
																		{
																			sessionTitle="Session Level Skill";
																			isSessionValid=true;
																		}	
																			%>
																			<li data-entity_type="SESSION_LEVEL_SKILL" data-entity_id="<%=sessionskill.getId()%>" data-title="<%=sessionTitle %>" data-is_valid="<%=isSessionValid%>" data-jstree='{"icon":"glyphicon glyphicon-leaf"}'><%=sessionskill.getId() %> - <%=sessionskill.getSkillName()%>
																				<ul>
																					<%
																						for (LearningObjective learningObjective : sessionskill.getLearningObjectives()) {
																										%>
																					<li data-title="Learning Objective" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=learningObjective.getId() %> - <%=learningObjective.getLearningObjectiveName()%>
																					<ul><%
																						for(Lesson lesson : learningObjective.getLessons())	
																						{
																							%>
																							<li data-title="Lesson" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=lesson.getId() %> - <%=lesson.getTitle()%>
																							<%
																						}
																					
																					%></ul><%
																						}
																	
																					%>
																					
																					</li>
																					
																				</ul></li>
																			<%
																				
													}
																		
																%>
															</ul></li>
															
															
														<%
															}
													
												%>
												<li data-jstree='{"icon":"glyphicon glyphicon-tree-deciduous"}'>
															<input type="text" placeholder="Add New Module Level Skill" class="new_entity" data-parent_type="CONTEXT" data-parent_id ="<%=contextId%>">
															</li>
											</ul>
																		
											<%
												}
												else
												{
													%>
													<ul>
													<li data-jstree='{"icon":"glyphicon glyphicon-asterisk"}'>
														<span class="label label-danger">No Skill Tree Available For Context</span>
													</li>
													</ul>	
													<%
													
												}	
										%>
										</li>
										</ul>