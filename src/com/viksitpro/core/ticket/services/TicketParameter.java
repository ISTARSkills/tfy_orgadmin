/**
 * 
 */
package com.viksitpro.core.ticket.services;

/**
 * @author mayank
 *
 */
public class TicketParameter {

	String paramName;
	String paramValue;
	String dataType;
	String operator;
	
	
	public String getParamName() {
		return paramName;
	}
	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
	public String getParamValue() {
		return paramValue;
	}
	public void setParamValue(String paramValue) {
		this.paramValue = paramValue;
	}
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public TicketParameter() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	
	
	
}
