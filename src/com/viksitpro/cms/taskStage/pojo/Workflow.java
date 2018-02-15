package com.viksitpro.cms.taskStage.pojo;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Workflow {
	
	String category;
	String description;
	Integer id;
	String name;
	ArrayList<Stage> stages;
	
	
	public Workflow() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	public Workflow(String category, String description, Integer id, String name, ArrayList<Stage> stages) {
		super();
		this.category = category;
		this.description = description;
		this.id = id;
		this.name = name;
		this.stages = stages;
	}

	@XmlAttribute (name = "category" )
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	
	@XmlAttribute ( name = "description" )
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	@XmlAttribute ( name = "id" )
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	@XmlAttribute ( name = "name" )
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@XmlElement ( name = "stage" )
	public ArrayList<Stage> getStages() {
		return stages;
	}
	public void setStages(ArrayList<Stage> stages) {
		this.stages = stages;
	}
	
	

}

