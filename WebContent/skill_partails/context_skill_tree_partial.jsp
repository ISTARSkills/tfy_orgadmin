<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="com.viksitpro.core.skill.pojo.LearningObjective"%>
<%@page import="com.viksitpro.core.skill.pojo.SessionLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.ModuleLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.CourseLevelSkill"%>
<%@page import="com.viksitpro.core.skill.services.CoreSkillService"%>
<%
int contextId = Integer.parseInt(request.getParameter("context_id"));
%>

<%								
										
												CoreSkillService skillService = new CoreSkillService();																							
												CourseLevelSkill courseSkill = skillService.getShellTreeForContext(contextId);
												if(courseSkill!=null && courseSkill.getModuleLevelSkill()!=null )
												{
											%>
<ul>										
										<li data-jstree='{"icon":"glyphicon glyphicon-asterisk"}'><a
											><%=courseSkill.getId() %> - <%=courseSkill.getSkillName()%></a>
											<ul>
												<%
												if(courseSkill.getModuleLevelSkill()!=null)
												{
													for (ModuleLevelSkill moduleskill : courseSkill.getModuleLevelSkill()) {
														%>
														<li data-title="Module Level Skill"
															data-jstree='{"icon":"glyphicon glyphicon-tree-deciduous"}'><%=moduleskill.getId() %> - <%=moduleskill.getSkillName()%>
															<ul>
																<%
																
																	if(moduleskill.getSessionLevelSkill()!=null)
																	{
																		for (SessionLevelSkill sessionskill : moduleskill.getSessionLevelSkill()) {
																			%>
																			<li data-title="Session Level Skill" data-jstree='{"icon":"glyphicon glyphicon-leaf"}'><%=sessionskill.getId() %> - <%=sessionskill.getSkillName()%>
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
																	}	
																%>
															</ul></li>
														<%
															}
												}	
												%>
											</ul></li>
										
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