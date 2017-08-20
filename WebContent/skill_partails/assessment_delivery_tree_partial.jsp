<%@page import="com.viksitpro.core.skill.pojo.LearningObjective"%>
<%@page import="com.viksitpro.core.skill.pojo.SessionLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.ModuleLevelSkill"%>
<%@page import="com.viksitpro.core.skill.pojo.DeliveryQuestion"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.skill.pojo.DeliveryAssessmentTree"%>
<%@page import="com.viksitpro.core.skill.services.CoreSkillService"%>
<%
int assessmentId = Integer.parseInt(request.getParameter("assessment_id"));
CoreSkillService skillService = new CoreSkillService();																							
DeliveryAssessmentTree asessTree = skillService.getDeliveryTreeForAssessment(assessmentId);
%>
											<ul>
												<%
												if(asessTree.getQuestions()!=null && asessTree.getQuestions().size()>0)
												{
													for (DeliveryQuestion question : asessTree.getQuestions()) {
														boolean is_valid = false;
														String errorInQuestion ="This Question is not mapped to any Learning Objective";
														if(question.getModuleLevelSkill()!=null && question.getModuleLevelSkill().size()>0)
														{
															is_valid =true;
															errorInQuestion="Delivery Question";
														}	
														%>
														<li data-entity_type="question" data-question_id="<%=question.getId()%>" data-is_valid="<%=is_valid%>" data-title="<%=errorInQuestion%>"
															data-jstree='{"icon":"glyphicon glyphicon-tree-deciduous"}'><%=question.getId() %> - <%=question.getQuestion().getQuestionText()%>
															<ul>
																<%
																	if(question.getModuleLevelSkill()!=null)
																	{
																		for (ModuleLevelSkill moduleLevelSkill : question.getModuleLevelSkill()) {
																			%>
																			<li data-title="Module Level Skill" data-jstree='{"icon":"glyphicon glyphicon-leaf"}'><%=moduleLevelSkill.getId() %> - <%=moduleLevelSkill.getSkillName()%>
																				<ul>
																					<%
																						
																						for (SessionLevelSkill sessionSkill : moduleLevelSkill.getSessionLevelSkill()) {
																										%>
																					<li data-title="Session Level Skill" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=sessionSkill.getId() %> - <%=sessionSkill.getSkillName()%>
																					<ul><%
																						for(LearningObjective lobj : sessionSkill.getLearningObjectives())	
																						{
																							%>
																							<li data-title="Learning Objective" data-jstree='{"icon":"glyphicon glyphicon-apple"}'><%=lobj.getId() %> - <%=lobj.getLearningObjectiveName()%></li>
																							<%
																						}
																					
																					%></ul><%
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
												else
												{
													%>
													<li data-jstree='{"icon":"glyphicon glyphicon-apple"}'>No Delivery Tree Available</li>
													<%
												}	
												%>
											</ul>