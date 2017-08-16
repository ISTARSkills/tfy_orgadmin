package com.viksitpro.cms.taskStage.pojo;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

public class WorkflowHolder {
	private static Workflow workflow;

	public static Workflow getWorkflow() {
		return workflow;
	}

	public static void setWorkflow(Workflow workflow) {
		WorkflowHolder.workflow = workflow;
	}
	
	public static Workflow generateWorkflow(){
		try{
			URL url = (new WorkflowHolder()).getClass().getClassLoader().getResource("lessonStages.xml");
			File file = new File(url.toURI());
			
			JAXBContext context = JAXBContext.newInstance(Workflow.class);
			Unmarshaller unmarshaller = context.createUnmarshaller();
			WorkflowHolder.workflow = (Workflow) unmarshaller.unmarshal(file);
		} catch (URISyntaxException e) {
			// TODO: handle exception
		} catch (JAXBException e) {
			// TODO: handle exception
		}
		
		return workflow;
	}
}
