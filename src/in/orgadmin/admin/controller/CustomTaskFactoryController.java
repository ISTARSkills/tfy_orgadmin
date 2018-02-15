package in.orgadmin.admin.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.customtask.ElementParam;
import com.viksitpro.core.customtask.TaskFormElement;
import com.viksitpro.core.customtask.TaskLibrary;
import com.viksitpro.core.customtask.TaskStep;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.CustomFormElementDataTypes;
import com.viksitpro.core.utilities.CustomFormElementTypes;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

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
				String speechText = request.getParameter(formelement.getElemntName().trim());
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
					ViksitLogger.logMSG(this.getClass().getName(),"key - "+ " "+ returnedData.get(str));
				}
				//just for the sake of testing
				for(String key: keywords.split("!#"))
				{
					if(returnedData.get(key)!=null){
						ViksitLogger.logMSG(this.getClass().getName(),"density of "+key+" is "+returnedData.get(key).toString());
					}
				}	
				break;
			case CustomFormElementTypes.DROP_DOWN:
				String value = request.getParameter(formelement.getElemntName().trim());
				if(value != null && !value.equalsIgnoreCase("")){
					updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), value);
				}else{
					String defaultValue = getDefaultValue(formelement.getDataType());
					updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), defaultValue);
				}
				break;
			case CustomFormElementTypes.TEXT_BOX:
				String textBoxValue = request.getParameter(formelement.getElemntName().trim());
				if(textBoxValue != null && !textBoxValue.equalsIgnoreCase("")){
					updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), textBoxValue);
				}else
				{
					String defaultValue = getDefaultValue(formelement.getDataType());
					updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), defaultValue);
				}	
				 
				break;
			case CustomFormElementTypes.DATE_PICKER:
				String dateValue = request.getParameter(formelement.getElemntName().trim());
				SimpleDateFormat from = new SimpleDateFormat("dd/MM/yyyy");
				SimpleDateFormat to = new SimpleDateFormat("yyyy-MM-dd");
				if(dateValue!=null && !dateValue.equalsIgnoreCase("")){
					try {
						updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), to.format(from.parse(dateValue)));
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				else
				{
					String defaultValue = getDefaultValue(formelement.getDataType());
					updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), defaultValue);
				}	
				break;
			case CustomFormElementTypes.TEXT_AREA:
				String textAreaValue = request.getParameter(formelement.getElemntName().trim());
				if(textAreaValue!=null && !textAreaValue.equalsIgnoreCase("")){
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), textAreaValue);
				}
				else
				{
					String defaultValue = getDefaultValue(formelement.getDataType());
					updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), defaultValue);
				}	
				break;
			case CustomFormElementTypes.SWITCH:
				String switchValue = request.getParameter(formelement.getElemntName().trim());
				boolean val = false;
				if(switchValue != null && switchValue.equalsIgnoreCase("on"))
				{
					val= true;
				}
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), Boolean.toString(val).charAt(0)+"");
				break;
			case CustomFormElementTypes.STAR_RATING:
				ViksitLogger.logMSG(this.getClass().getName(),formelement.getElemntName().trim()+"00000000");
				Float rating = Float.parseFloat(request.getParameter(formelement.getElemntName().trim()));
				String ratingVal= rating+"";
				if (formelement.getDataType().equalsIgnoreCase(CustomFormElementDataTypes.NUMBER))
				{
					ratingVal= (int)Math.ceil(rating)+"";					
				}
				updateQuery = updateQuery.replaceAll(":"+formelement.getElemntName().trim(), ratingVal);
				break;
			default:
				break;
			}
		}
		
		updateQuery = updateQuery.replaceAll(":USER_ID", user_id+"");
		updateQuery = updateQuery.replaceAll(":TASK_ID", task_id+"");
		ViksitLogger.logMSG(this.getClass().getName(),"updateQuery ->>>"+updateQuery);
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
			//ViksitLogger.logMSG(this.getClass().getName(),(updateSql);
		}
		
	}
	
	for (TaskStep step : task.fetchTaskTemplate().getSteps()) {
		for (TaskFormElement formelement : step.getForm_elements()) {
			
		   String paramvalues = formelement.getElemntName().trim();
			
		   paramvalues = request.getParameter(paramvalues.replaceAll(" ", "_"))!=null?request.getParameter(paramvalues):"NULL";
			if(!paramvalues.equalsIgnoreCase("NULL") && !paramvalues.equalsIgnoreCase("")) {
				
				if(paramvalues.equalsIgnoreCase("on")) {
					paramvalues = "true";
				}	
			
			updateSql = "Select id from task_elements_list where element_name = '"+formelement.getElemntName().trim()+"' ";
			
			List<HashMap<String, Object>> res = util.executeQuery(updateSql);
			if(res.size() > 0){
				
				int task_element_id = (int)res.get(0).get("id");
				
				
				
				 String sql = "INSERT INTO user_task_feedback ( 	ID, 	task_id, 	user_id, 	task_element_id, 	feedback ) VALUES 	((SELECT COALESCE(MAX(id)+1,1) FROM user_task_feedback), "+task_id+", "+user_id+", "+task_element_id+", '"+paramvalues+"');";
					
					util.executeUpdate(sql);
					//ViksitLogger.logMSG(this.getClass().getName(),(sql);
			}
			
			
		}	
			
		}
		//querypart += formelement.getElemntName().trim() +"="+ paramvalues +",";
		//querypart = querypart.substring(0, querypart.length() - 1);
		// updateSql = "UPDATE xyz SET user_id="+ user_id +","+querypart+", task_name="+taskName+" WHERE task_id="+id;
		
		////ViksitLogger.logMSG(this.getClass().getName(),(updateSql);
		
		
		
	}*/
	

	response.getWriter().print("success");
	}

	
	

	private String getDefaultValue(String dataType) {
		SimpleDateFormat to = new SimpleDateFormat("yyyy-MM-dd");
		switch (dataType.trim())
		{
		 	case	CustomFormElementDataTypes.NUMBER :		 		
		 		return "0";
		 	case	CustomFormElementDataTypes.STRING :		 		
		 		return "";
		 	case	CustomFormElementDataTypes.BOOLEAN :		 		
		 		return "f";
		 	case	CustomFormElementDataTypes.DECIMAL :		 		
		 		return "0.0";
		 	case CustomFormElementDataTypes.DATE:
		 		return to.format(new Date())+"";
		 	default :
		 		return "";
		}	
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
