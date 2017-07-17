/**
 * 
 */
package com.viksitpro.core.ticket.services;

import javax.xml.bind.annotation.XmlAttribute;

/**
 * @author ISTAR-SKILL
 *
 */
public class ExceptionParam {

	String name ;
	String type;
	String expectation;
	
	@XmlAttribute(name = "name", required = false)
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@XmlAttribute(name = "type", required = false)
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	@XmlAttribute(name = "expectation", required = false)
	public String getExpectation() {
		return expectation;
	}
	public void setExpectation(String expectation) {
		this.expectation = expectation;
	}
	public ExceptionParam() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
}
