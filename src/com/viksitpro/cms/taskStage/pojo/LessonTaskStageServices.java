package com.viksitpro.cms.taskStage.pojo;

import java.util.HashSet;
import java.util.Set;

public class LessonTaskStageServices {
	public static Stage getCurrentStage(String stateName) {
		Stage stage = new Stage();
		Workflow workflow = (new WorkflowHolder()).generateWorkflow();
		for (Stage stage2 : workflow.getStages()) {
			if (stage2.getName().equalsIgnoreCase(stateName)) {
				stage = stage2;
				break;
			}
		}
		return stage;
	}

	public static Set<Stage> getNextStages(Stage currentStage){
		Set<Stage> stages = new HashSet<Stage>();
		Workflow workflow = (new WorkflowHolder()).generateWorkflow();
		String[] stage_ids = currentStage.getNext_stages().split(",");
		for(String stage_id : stage_ids){
			for(Stage stage : workflow.getStages()){
				if(Integer.parseInt(stage_id)==stage.getId()){
					stages.add(stage);
					break;
				}
			}
		}
		return stages;
	}

}
