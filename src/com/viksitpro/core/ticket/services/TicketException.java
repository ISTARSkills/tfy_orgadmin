/**
 * 
 */
package com.viksitpro.core.ticket.services;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;

/**
 * @author ISTAR-SKILL
 *
 */
public class TicketException {

	Integer id;
	String type;
	String department;
	String defaulterItemQuery;
	String primaryReceiverQuery;
	String associatedReceiverQuery;
	ArrayList<ExceptionParam> params;
	
	@XmlAttribute(name = "id", required = false)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	@XmlAttribute(name = "type", required = false)
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	@XmlAttribute(name = "department", required = false)
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}

	@XmlElement(name = "primary_receiver_query", required = false)
	public String getPrimaryReceiverQuery() {
		return primaryReceiverQuery;
	}
	public void setPrimaryReceiverQuery(String primaryReceiverQuery) {
		this.primaryReceiverQuery = primaryReceiverQuery;
	}
	
	@XmlElement(name = "associated_receiver_query", required = false)
	public String getAssociatedReceiverQuery() {
		return associatedReceiverQuery;
	}
	public void setAssociatedReceiverQuery(String associatedReceiverQuery) {
		this.associatedReceiverQuery = associatedReceiverQuery;
	}
	
	@XmlElement(name = "defaulter_item_query", required = false)
	public String getDefaulterItemQuery() {
		return defaulterItemQuery;
	}
	public void setDefaulterItemQuery(String defaulterItemQuery) {
		this.defaulterItemQuery = defaulterItemQuery;
	}
	
	@XmlElement(name = "exception_param", required = false)
	public ArrayList<ExceptionParam> getParams() {
		return params;
	}
	public void setParams(ArrayList<ExceptionParam> params) {
		this.params = params;
	}
	
}
