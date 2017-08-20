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
<%
int questionId = Integer.parseInt(request.getParameter("question_id"));
Question question = new QuestionDAO().findById(questionId);	
ArrayList<Integer> alreadyMappedLo = new ArrayList<Integer>();

for(SkillObjective lo : question.getSkillObjectives())
{
	alreadyMappedLo.add(lo.getId());	
}	
%>
<select class="js-source-states" >
  <%
  String findSkill="select distinct  context.title, mod_skill.name as mod_skill_name, session_skill.name as session_skill_name  , session_skill.id as session_skill_id from skill_objective mod_skill , context, skill_objective session_skill, module_skill_session_skill_map msp where mod_skill.skill_level_type ='MODULE' and context.id = mod_skill.context and msp.module_skill_id = mod_skill.id and msp.session_skill_id = session_skill.id and session_skill.skill_level_type ='CMSESSION' order by context.title, mod_skill.name, session_skill.name";
  DBUTILS util = new DBUTILS();
  List<HashMap<String,Object>> SkillData = util.executeQuery(findSkill);
  for(HashMap<String,Object> skillRow : SkillData)
  {
	  int sessionSkillId = (int)skillRow.get("session_skill_id");
	  String sessionSkillName = skillRow.get("session_skill_name").toString();
	  String modSkillName = skillRow.get("mod_skill_name").toString();
	  String context = skillRow.get("title").toString();
	  %>
	<optgroup  label="<%=context%> >> <%=modSkillName%> >> <%=sessionSkillName%>">
    <%
    String findLo="select skill_objective.id , skill_objective.name from skill_objective, session_skill_lo_map where session_skill_lo_map.session_skill_id= "+sessionSkillId+" and session_skill_lo_map.learning_obj_id = skill_objective.id order by skill_objective.name";
    List<HashMap<String,Object>> loData = util.executeQuery(findLo);
    for(HashMap<String,Object> loRow : loData)
    {
    	String selected="";
    	if(alreadyMappedLo.contains((int)loRow.get("id")))
    	{
    		selected="selected";
    	}
    	%>
    	<option value="<%=loRow.get("id")%>" <%=selected%>><%=loRow.get("name") %></option>
    	<%
    }
    %>
    </optgroup>	  
		<% 	  
  } 	  
  %>
</select>


<div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                               
                                                <div class="col-sm-12"><h3 class="m-t-none m-b">Add / Remove Learning Objectives</h3>
											    <p>Question can be mapped to learning objective. 
											     </p>
                                                    <form role="form">
                                                        <div class="form-group"><label>Question Text</label> <input type="text" class="form-control" 
                                                        disabled value="<%=question.getQuestionText()%>"></div>
                                                        <div class="form-group"><label>Select Learning Objective</label>
                                                        <select class="js-example-templating js-states form-control" multiple="multiple" id="lo_selector"></select>
                                                        </div>
                                                        <div>
                                                            <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="button" id="update_lo"><strong>Update</strong></button> 
                                                        </div>
                                                    </form>
                                                </div>                                               
                                        </div>
                                    </div>
                                    </div>
                                </div>