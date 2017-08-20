<%@page import="com.viksitpro.core.dao.entities.SkillObjectiveDAO"%>
<%@page import="com.viksitpro.core.dao.entities.QuestionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.dao.entities.SkillObjective"%>
<%@page import="com.viksitpro.core.dao.entities.LessonDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Lesson"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.ContextDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.Context"%>

<div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                               
                                                <div class="col-sm-12"><h3 class="m-t-none m-b">Modify Skill Tree</h3>
											     <form role="form">

<%
int parent_id = Integer.parseInt(request.getParameter("parent_id"));
String parentType= request.getParameter("parent_entity_type");

if(parentType.equalsIgnoreCase("CONTEXT"))
{
	Context context = new ContextDAO().findById(parent_id);
	%>
	<div class="form-group"><label>Context</label> <input type="text" class="form-control" 
                                                        disabled value="<%=context.getTitle()%>"></div>
    <div class="form-group"><label>Module Level Skill Name</label> <input type="text" class="form-control" 
                                                         id="new_child_entity"></div>
                                                                                                            
	<% 
}
else if(parentType.equalsIgnoreCase("MODULE_LEVEL_SKILL")){
	SkillObjective  moduleLevelSkill= new SkillObjectiveDAO().findById(parent_id);
	Context context = new ContextDAO().findById(moduleLevelSkill.getParentSkill());
	%>
	<div class="form-group"><label>Context</label> <input type="text" class="form-control" 
                                                        disabled value="<%=context.getTitle()%>"></div>
     <div class="form-group"><label>Module Level Skill</label> <input type="text" class="form-control" 
                                                        disabled value="<%=moduleLevelSkill.getName()%>"></div> 
                                                       <div class="form-group"><label>Session Level Skill Name</label> <input type="text" class="form-control" 
                                                         id="new_child_entity"></div>                                                   
                                                        
	<%
}
else if (parentType.equalsIgnoreCase("SESSION_LEVEL_SKILL"))
{
	SkillObjective  sessionLevelSkill= new SkillObjectiveDAO().findById(parent_id);
	
	%>
	
     <div class="form-group"><label>Session Level Skill</label> <input type="text" class="form-control" 
                                                        disabled value="<%=sessionLevelSkill.getName()%>"></div> 
                                                       <div class="form-group"><label>Learning Objective Name</label> <input type="text" class="form-control" 
                                                         id="new_child_entity"></div>  
	<%
}	
%>                                                
                                                        
                                                        
                                                        <div>
                                                            <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="button" id="update_entity" data-parent_id="<%=parent_id%>" data-parent_type="<%=parentType%>"><strong>Update</strong></button> 
                                                        </div>
                                                    </form>
                                                </div>                                               
                                        </div>
                                    </div>
                                    </div>
                                </div>