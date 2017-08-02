package in.orgadmin.admin.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.customtask.ElementParam;
import com.viksitpro.core.customtask.TaskFormElement;
import com.viksitpro.core.customtask.TaskLibrary;
import com.viksitpro.core.customtask.TaskStep;
import com.viksitpro.core.customtask.TaskTemplate;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.utilities.CustomFormElementDataTypes;
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
		printParams(request);
	
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
				String speechText = request.getParameter(formelement.getElemntName());
				ArrayList<ElementParam> elementParams = formelement.getElementParams();
				String keywords = "";
				String benchMarkString ="";
				for(ElementParam param : elementParams)
				{
					if(param.getName().equalsIgnoreCase("keywords"))
					{
						keywords = param.getValue();
					}
					else if (param.getName().equalsIgnoreCase("benchmark_string"))
					{
						benchMarkString = param.getValue();
					}	
				}
				HashMap<String, Object> returnedData =service.evaluateVoiceText(speechText,keywords, benchMarkString);
				for(String str: returnedData.keySet())
				{
					System.out.println("key - "+ " "+ returnedData.get(str));
				}
				//just for the sake of testing
				for(String key: keywords.split("!#"))
				{
					if(returnedData.get(key)!=null){
						System.out.println("density of "+key+" is "+returnedData.get(key).toString());
					}
				}	
				break;
			case CustomFormElementTypes.DROP_DOWN:
				String value = request.getParameter(formelement.getElemntName());
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName(), value);
				break;
			case CustomFormElementTypes.TEXT_BOX:
				String textBoxValue = request.getParameter(formelement.getElemntName());
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName(), textBoxValue);
				break;
			case CustomFormElementTypes.DATE_PICKER:
				String dateValue = request.getParameter(formelement.getElemntName());
				SimpleDateFormat from = new SimpleDateFormat("dd/MM/yyyy");
				SimpleDateFormat to = new SimpleDateFormat("yyyy-MM-dd");
				try {
					updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName(), to.format(from.parse(dateValue)));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			case CustomFormElementTypes.TEXT:
				String textAreaValue = request.getParameter(formelement.getElemntName());
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName(), textAreaValue);
				break;
			case CustomFormElementTypes.SWITCH:
				String switchValue = request.getParameter(formelement.getElemntName());
				boolean val = false;
				if(switchValue != null && switchValue.equalsIgnoreCase("on"))
				{
					val= true;
				}
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName(), Boolean.toString(val).charAt(0)+"");
				break;
			case CustomFormElementTypes.STAR_RATING:
				
				Float rating = Float.parseFloat(request.getParameter(formelement.getElemntName()));
				String ratingVal= rating+"";
				if (formelement.getDataType().equalsIgnoreCase(CustomFormElementDataTypes.NUMBER))
				{
					ratingVal= (int)Math.ceil(rating)+"";					
				}
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName(), ratingVal);
				break;
			default:
				break;
			}
		}
		
		updateQuery = updateQuery.replaceAll(":USER_ID", user_id+"");
		updateQuery = updateQuery.replaceAll(":TASK_ID", task_id+"");
		System.out.println("updateQuery ->>>"+updateQuery);
		util.executeUpdate(updateQuery);
	}
	
	
/*
	
	
	
	
	String updateSql = "";
	
	
	
	String checkQuery = "SELECT CAST (count(*) AS INTEGER) as counts FROM user_task_feedback WHERE user_id ="+user_id+" AND task_id ="+task_id;
	List<HashMap<String, Object>> data = util.executeQuery(checkQuery);
	if(data.size() > 0){
		if((int)data.get(0).get("counts") > 0) {
		
			updateSql = "DELETE FROM user_task_feedback WHERE user_id = "+user_id+" AND task_id ="+task_id;
			util.executeUpdate(updateSql);
			//System.err.println(updateSql);
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
					//System.err.println(sql);
			}
			
			
		}	
			
		}
		//querypart += formelement.getElemntName() +"="+ paramvalues +",";
		//querypart = querypart.substring(0, querypart.length() - 1);
		// updateSql = "UPDATE xyz SET user_id="+ user_id +","+querypart+", task_name="+taskName+" WHERE task_id="+id;
		
		////System.err.println(updateSql);
		
		
		
	}*/
	

	response.getWriter().print("success");
	}

	
	

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
