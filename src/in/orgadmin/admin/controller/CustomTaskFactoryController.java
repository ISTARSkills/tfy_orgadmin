package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.customtask.TaskFormElement;
import com.viksitpro.core.customtask.TaskLibrary;
import com.viksitpro.core.customtask.TaskStep;
import com.viksitpro.core.customtask.TaskTemplate;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.utilities.CustomFormElementTypes;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;
import com.viksitpro.core.utilities.CustomFormElementTypes;

@WebServlet("/custom_task_factory")
public class CustomTaskFactoryController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    
    public CustomTaskFactoryController() {
        super();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	
	DBUTILS util = new DBUTILS();
	int task_id = Integer.parseInt(request.getParameter("task_id"));
	int user_id = Integer.parseInt(request.getParameter("user_id"));
	Task task = new TaskLibrary().getTaskTemplate(task_id);
	EvaluaterServices service = new EvaluaterServices();
	for (TaskStep step : task.fetchTaskTemplate().getSteps()) {
		
		String updateQuery = step.getUpdateQuery();
		for (TaskFormElement formelement : step.getForm_elements()) {
			switch (formelement.getElemntType()) {
			case CustomFormElementTypes.VOICE:
				service.evaluateVoiceText();
				break;
			default:
				break;
			}
		}
	}
	
	
	
	
	
	String updateSql = "";
	
	
	
	String checkQuery = "SELECT CAST (count(*) AS INTEGER) as counts FROM user_task_feedback WHERE user_id ="+user_id+" AND task_id ="+task_id;
	List<HashMap<String, Object>> data = util.executeQuery(checkQuery);
	if(data.size() > 0){
		if((int)data.get(0).get("counts") > 0) {
		
			updateSql = "DELETE FROM user_task_feedback WHERE user_id = "+user_id+" AND task_id ="+task_id;
			util.executeUpdate(updateSql);
			System.err.println(updateSql);
		}
		
	}
	
	for (TaskStep step : task.fetchTaskTemplate().getSteps()) {
		for (TaskFormElement formelement : step.getForm_elements()) {
			
		   String paramvalues = formelement.getElemntName();
			
		   paramvalues = request.getParameter(paramvalues.replaceAll(" ", "_"))!=null?request.getParameter(paramvalues):"NULL";
			if(!paramvalues.equalsIgnoreCase("NULL") && !paramvalues.equalsIgnoreCase("")) {
				
				if(paramvalues.equalsIgnoreCase("on")) {
					paramvalues = "true";
				}	
			
			updateSql = "Select id from task_elements_list where element_name = '"+formelement.getElemntName()+"' ";
			
			List<HashMap<String, Object>> res = util.executeQuery(updateSql);
			if(res.size() > 0){
				
				int task_element_id = (int)res.get(0).get("id");
				
				
				
				 String sql = "INSERT INTO user_task_feedback ( 	ID, 	task_id, 	user_id, 	task_element_id, 	feedback ) VALUES 	((SELECT COALESCE(MAX(id)+1,1) FROM user_task_feedback), "+task_id+", "+user_id+", "+task_element_id+", '"+paramvalues+"');";
					
					util.executeUpdate(sql);
					System.err.println(sql);
			}
			
			
		}	
			
		}
		//querypart += formelement.getElemntName() +"="+ paramvalues +",";
		//querypart = querypart.substring(0, querypart.length() - 1);
		// updateSql = "UPDATE xyz SET user_id="+ user_id +","+querypart+", task_name="+taskName+" WHERE task_id="+id;
		
		//System.err.println(updateSql);
		
		
		
	}
	
	
	}

	
	private void printParams(HttpServletRequest request) {
		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
