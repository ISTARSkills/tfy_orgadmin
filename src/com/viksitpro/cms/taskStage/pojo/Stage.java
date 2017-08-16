package com.viksitpro.cms.taskStage.pojo;

import javax.xml.bind.annotation.XmlAttribute;

public class Stage {
	
	String allowed_roles;
	String description;
	Integer id;
	String name;
	String next_stages;
	Integer order;
	String icon;
	
	public Stage() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Stage(String allowed_roles, String description, Integer id, String name, String next_stages, Integer order, String icon) {
		super();
		this.allowed_roles = allowed_roles;
		this.description = description;
		this.id = id;
		this.name = name;
		this.next_stages = next_stages;
		this.order = order;
		this.icon = icon;
	}

	@XmlAttribute ( name = "allowed_roles" )
	public String getAllowed_roles() {
		return allowed_roles;
	}
	public void setAllowed_roles(String allowed_roles) {
		this.allowed_roles = allowed_roles;
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
	
	@XmlAttribute ( name = "next_stages" )
	public String getNext_stages() {
		return next_stages;
	}
	public void setNext_stages(String next_stages) {
		this.next_stages = next_stages;
	}
	
	@XmlAttribute ( name = "order" )
	public Integer getOrder() {
		return order;
	}
	public void setOrder(Integer order) {
		this.order = order;
	}

	@XmlAttribute ( name = "icon" )
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
}
